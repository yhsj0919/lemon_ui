import 'package:flutter/material.dart';

import '../checkbox/hyper_checkbox.dart';
import '../checkbox/hyper_checkbox_style.dart';
import '../select/hyper_select.dart';
import '../select/hyper_select_style.dart';
import '../../theme/core/hyper_theme.dart';
import 'hyper_form.dart';

FormFieldValidator<Set<T>> _countValidator<T>(
  int minimum,
  int? maximum,
  FormFieldValidator<Set<T>>? validator,
) {
  if (minimum < 0 || (maximum != null && (maximum < 1 || maximum < minimum))) {
    throw ArgumentError('选择数量范围无效');
  }
  return (values) {
    final count = values?.length ?? 0;
    if (count < minimum) return '至少选择 $minimum 项';
    if (maximum != null && count > maximum) return '最多选择 $maximum 项';
    return validator?.call(values);
  };
}

/// Multi-select field; values are immutable sets and reset restores the initial set.
class HyperMultiSelectFormField<T> extends HyperFormField<Set<T>> {
  HyperMultiSelectFormField({
    super.key,
    super.name,
    super.label,
    super.semanticLabel,
    super.description,
    super.requiredIndicator,
    super.layout,
    super.errorDisplay,
    super.style,
    super.asyncValidator,
    super.onSaved,
    super.onReset,
    super.onChanged,
    super.enabled,
    super.autovalidateMode,
    super.focusNode,
    Set<T> initialValue = const {},
    List<HyperSelectOption<T>> options = const [],
    HyperSelectSource<T>? source,
    List<HyperSelectOption<T>> selectedOptions = const [],
    String Function(T)? labelBuilder,
    T Function(String)? createValue,
    int minimumSelection = 0,
    int? maximumSelection,
    FormFieldValidator<Set<T>>? validator,
    String placeholder = '请选择',
    bool searchable = false,
    HyperSelectPresentation? presentation,
    HyperSelectStyle? selectStyle,
  }) : super(
         initialValue: Set<T>.unmodifiable(initialValue),
         validator: _countValidator(
           minimumSelection,
           maximumSelection,
           validator,
         ),
         fieldBuilder: (f) => HyperSelect<T>.multiple(
           values: f.value ?? <T>{},
           options: options,
           source: source,
           selectedOptions: selectedOptions,
           labelBuilder: labelBuilder,
           createValue: createValue,
           placeholder: placeholder,
           searchable: searchable,
           maximumSelection: maximumSelection,
           presentation: presentation,
           style: selectStyle,
           enabled: f.enabled,
           onSelectionChanged: f.enabled
               ? (values) => f.didChange(Set<T>.unmodifiable(values))
               : null,
         ),
       );
}

/// A checkbox group registers as one set-valued field.
class HyperCheckboxGroupFormField<T> extends HyperFormField<Set<T>> {
  HyperCheckboxGroupFormField({
    super.key,
    super.name,
    super.label,
    super.semanticLabel,
    super.description,
    super.requiredIndicator,
    super.layout,
    super.errorDisplay,
    super.style,
    super.asyncValidator,
    super.onSaved,
    super.onReset,
    super.onChanged,
    super.enabled,
    super.autovalidateMode,
    super.focusNode,
    Set<T> initialValue = const {},
    required List<HyperSelectOption<T>> options,
    int minimumSelection = 0,
    int? maximumSelection,
    FormFieldValidator<Set<T>>? validator,
    Axis direction = Axis.horizontal,
    HyperCheckboxStyle? checkboxStyle,
  }) : super(
         initialValue: Set<T>.unmodifiable(initialValue),
         validator: _countValidator(
           minimumSelection,
           maximumSelection,
           validator,
         ),
         fieldBuilder: (f) => Builder(
           builder: (context) {
             final values = f.value ?? <T>{};
             final gap = HyperTheme.sizesOf(context).form.gap;
             final children = <Widget>[
               for (final option in options)
                 Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     HyperCheckbox(
                       value: values.contains(option.value),
                       semanticLabel: option.label,
                       style: checkboxStyle,
                       onChanged:
                           f.enabled &&
                               option.enabled &&
                               (maximumSelection == null ||
                                   values.length < maximumSelection ||
                                   values.contains(option.value))
                           ? (checked) {
                               final next = Set<T>.of(values);
                               if (checked == true) {
                                 next.add(option.value);
                               } else {
                                 next.remove(option.value);
                               }
                               f.didChange(Set<T>.unmodifiable(next));
                             }
                           : null,
                     ),
                     Flexible(child: Text(option.label)),
                   ],
                 ),
             ];
             return direction == Axis.horizontal
                 ? Wrap(spacing: gap, runSpacing: gap, children: children)
                 : Column(
                     mainAxisSize: MainAxisSize.min,
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       for (var i = 0; i < children.length; i++) ...[
                         if (i > 0) SizedBox(height: gap),
                         children[i],
                       ],
                     ],
                   );
           },
         ),
       );
}
