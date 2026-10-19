import 'package:flutter/material.dart';

import '../checkbox/hyper_checkbox.dart';
import '../checkbox/hyper_checkbox_style.dart';
import '../radio/hyper_radio.dart';
import '../radio/hyper_radio_style.dart';
import '../select/hyper_select.dart';
import '../select/hyper_select_style.dart';
import '../switch/hyper_switch.dart';
import '../switch/hyper_switch_style.dart';
import '../../theme/core/hyper_theme.dart';
import 'hyper_form.dart';

/// Single selection integrated with the Form lifecycle.
class HyperSelectFormField<T> extends HyperFormField<T> {
  HyperSelectFormField({
    super.key,
    super.name,
    super.label,
    super.semanticLabel,
    super.description,
    super.requiredIndicator,
    super.layout,
    super.errorDisplay,
    super.style,
    super.validator,
    super.asyncValidator,
    super.onSaved,
    super.onReset,
    super.onChanged,
    super.enabled,
    super.autovalidateMode,
    super.focusNode,
    super.initialValue,
    List<HyperSelectOption<T>> options = const [],
    HyperSelectSource<T>? source,
    List<HyperSelectOption<T>> selectedOptions = const [],
    String Function(T)? labelBuilder,
    T Function(String)? createValue,
    String placeholder = '请选择',
    bool searchable = false,
    bool allowDeselect = false,
    HyperSelectPresentation? presentation,
    HyperSelectStyle? selectStyle,
  }) : super(
         fieldBuilder: (f) => HyperSelect<T>(
           value: f.value,
           options: options,
           source: source,
           selectedOptions: selectedOptions,
           labelBuilder: labelBuilder,
           createValue: createValue,
           placeholder: placeholder,
           searchable: searchable,
           allowDeselect: allowDeselect,
           presentation: presentation,
           style: selectStyle,
           enabled: f.enabled,
           onChanged: f.enabled ? f.didChange : null,
         ),
       );
}

/// Checkbox integrated with the Form lifecycle; requiredIndicator is visual only.
class HyperCheckboxFormField extends HyperFormField<bool> {
  HyperCheckboxFormField({
    super.key,
    super.name,
    super.label,
    super.semanticLabel,
    super.description,
    super.requiredIndicator,
    super.layout,
    super.errorDisplay,
    super.style,
    super.validator,
    super.asyncValidator,
    super.onSaved,
    super.onReset,
    super.onChanged,
    super.enabled,
    super.autovalidateMode,
    super.focusNode,
    super.initialValue = false,
    bool tristate = false,
    HyperCheckboxStyle? checkboxStyle,
  }) : assert(tristate || initialValue != null),
       super(
         fieldBuilder: (f) => HyperCheckbox(
           value: tristate ? f.value : (f.value ?? false),
           tristate: tristate,
           style: checkboxStyle,
           semanticLabel: semanticLabel ?? label,
           onChanged: f.enabled ? f.didChange : null,
         ),
       );
}

/// Switch integrated with the Form lifecycle.
class HyperSwitchFormField extends HyperFormField<bool> {
  HyperSwitchFormField({
    super.key,
    super.name,
    super.label,
    super.semanticLabel,
    super.description,
    super.requiredIndicator,
    super.layout,
    super.errorDisplay,
    super.style,
    super.validator,
    super.asyncValidator,
    super.onSaved,
    super.onReset,
    super.onChanged,
    super.enabled,
    super.autovalidateMode,
    super.focusNode,
    bool initialValue = false,
    HyperSwitchStyle? switchStyle,
  }) : super(
         initialValue: initialValue,
         fieldBuilder: (f) => HyperSwitch(
           value: f.value ?? false,
           style: switchStyle,
           semanticLabel: semanticLabel ?? label,
           onChanged: f.enabled ? f.didChange : null,
         ),
       );
}

/// One radio group registers as one field, sharing validation and reset.
class HyperRadioFormField<T> extends HyperFormField<T> {
  HyperRadioFormField({
    super.key,
    super.name,
    super.label,
    super.semanticLabel,
    super.description,
    super.requiredIndicator,
    super.layout,
    super.errorDisplay,
    super.style,
    super.validator,
    super.asyncValidator,
    super.onSaved,
    super.onReset,
    super.onChanged,
    super.enabled,
    super.autovalidateMode,
    super.focusNode,
    super.initialValue,
    required List<HyperSelectOption<T>> options,
    bool toggleable = false,
    Axis direction = Axis.horizontal,
    HyperRadioStyle? radioStyle,
  }) : super(
         fieldBuilder: (f) => Builder(
           builder: (context) {
             final gap = HyperTheme.sizesOf(context).form.gap;
             final children = [
               for (final option in options)
                 HyperRadio<T>(
                   value: option.value,
                   groupValue: f.value,
                   style: radioStyle,
                   toggleable: toggleable,
                   semanticLabel: option.label,
                   onChanged: f.enabled && option.enabled ? f.didChange : null,
                   child: Text(option.label),
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
