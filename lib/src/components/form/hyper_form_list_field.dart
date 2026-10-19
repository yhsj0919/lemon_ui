import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../button/hyper_button.dart';
import 'hyper_form.dart';

/// One repeated row. Pass enabled and errorText to the row's input.
class HyperFormListItem<T> {
  const HyperFormListItem({
    required this.index,
    required this.value,
    required this.enabled,
    required this.onChanged,
    required this.remove,
    required this.errorText,
  });
  final int index;
  final T value;
  final bool enabled;
  final ValueChanged<T>? onChanged;
  final VoidCallback? remove;
  final String? errorText;
}

FormFieldValidator<List<T>> _listValidator<T>(
  int min,
  int? max,
  String? Function(T value, int index)? itemValidator,
  FormFieldValidator<List<T>>? validator,
) {
  if (min < 0 || (max != null && max < min)) throw ArgumentError('列表数量范围无效');
  return (value) {
    final items = value ?? <T>[];
    if (items.length < min) return '至少添加 $min 项';
    if (max != null && items.length > max) return '最多添加 $max 项';
    for (var i = 0; i < items.length; i++) {
      final error = itemValidator?.call(items[i], i);
      if (error != null) return '第 ${i + 1} 项：$error';
    }
    return validator?.call(value);
  };
}

/// Repeated values register as one list field; row keys survive insert/remove.
/// Row builders should use controlled inputs rather than register nested fields.
class HyperFormListField<T> extends HyperFormField<List<T>> {
  HyperFormListField({
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
    List<T> initialValue = const [],
    int minimumItems = 0,
    int? maximumItems,
    required T Function() createItem,
    required Widget Function(BuildContext context, HyperFormListItem<T> item)
    itemBuilder,
    String? Function(T value, int index)? itemValidator,
    FormFieldValidator<List<T>>? validator,
    Widget addLabel = const Text('添加一项'),
  }) : super(
         initialValue: List<T>.unmodifiable(initialValue),
         validator: _listValidator(
           minimumItems,
           maximumItems,
           itemValidator,
           validator,
         ),
         fieldBuilder: (f) => _ListEditor<T>(
           field: f,
           minimum: minimumItems,
           maximum: maximumItems,
           createItem: createItem,
           itemBuilder: itemBuilder,
           itemValidator: itemValidator,
           addLabel: addLabel,
         ),
       );
}

class _ListEditor<T> extends StatefulWidget {
  const _ListEditor({
    required this.field,
    required this.minimum,
    required this.maximum,
    required this.createItem,
    required this.itemBuilder,
    required this.itemValidator,
    required this.addLabel,
  });
  final HyperFormFieldState<List<T>> field;
  final int minimum;
  final int? maximum;
  final T Function() createItem;
  final Widget Function(BuildContext, HyperFormListItem<T>) itemBuilder;
  final String? Function(T, int)? itemValidator;
  final Widget addLabel;
  @override
  State<_ListEditor<T>> createState() => _ListEditorState<T>();
}

class _ListEditorState<T> extends State<_ListEditor<T>> {
  List<T> get values => widget.field.value ?? <T>[];
  late List<Key> keys = [for (final _ in values) UniqueKey()];
  late List<T>? expected = widget.field.value;
  @override
  void didUpdateWidget(covariant _ListEditor<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(expected, widget.field.value)) {
      keys = [for (final _ in values) UniqueKey()];
      expected = widget.field.value;
    }
  }

  void update(List<T> next) {
    expected = List<T>.unmodifiable(next);
    widget.field.didChange(expected);
  }

  @override
  Widget build(BuildContext context) {
    final gap = HyperTheme.sizesOf(context).form.fieldSpacing;
    final enabled = widget.field.enabled;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < values.length; i++) ...[
          if (i > 0) SizedBox(height: gap),
          KeyedSubtree(
            key: keys[i],
            child: widget.itemBuilder(
              context,
              HyperFormListItem<T>(
                index: i,
                value: values[i],
                enabled: enabled,
                errorText: widget.field.hasError
                    ? widget.itemValidator?.call(values[i], i)
                    : null,
                onChanged: enabled
                    ? (v) {
                        final next = List<T>.of(values);
                        next[i] = v;
                        update(next);
                      }
                    : null,
                remove: enabled && values.length > widget.minimum
                    ? () {
                        keys.removeAt(i);
                        final next = List<T>.of(values)..removeAt(i);
                        update(next);
                      }
                    : null,
              ),
            ),
          ),
        ],
        SizedBox(height: gap),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: HyperButton.outlined(
            onPressed:
                enabled &&
                    (widget.maximum == null || values.length < widget.maximum!)
                ? () {
                    keys.add(UniqueKey());
                    update([...values, widget.createItem()]);
                  }
                : null,
            child: widget.addLabel,
          ),
        ),
      ],
    );
  }
}
