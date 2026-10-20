import '../card/hyper_card_style.dart';
import '../cascader/hyper_cascader.dart';
import '../cascader/hyper_cascader_model.dart';
import '../cascader/hyper_cascader_style.dart';
import '../select/hyper_select_model.dart';
import 'hyper_form.dart';

/// A complete cascader path integrated with the form lifecycle.
///
/// Clearing produces an empty list. Initial, changed and submitted paths are
/// immutable snapshots. [requiredIndicator] only marks the label; use [validator]
/// to require a nonempty path or enforce business rules for imported values.
class HyperCascaderFormField<T> extends HyperFormField<List<T>> {
  HyperCascaderFormField({
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
    List<T> initialValue = const [],
    required List<HyperCascaderNode<T>> nodes,
    HyperCascaderChildrenLoader<T>? loadChildren,
    bool allowClear = true,
    String placeholder = '请选择',
    String rootLabel = '全部',
    String backLabel = '返回上一级',
    String pathSeparator = ' / ',
    String Function(T)? labelBuilder,
    HyperSelectPresentation? presentation,
    HyperCascaderStyle? cascaderStyle,
    HyperCardStyle? surfaceStyle,
  }) : super(
         initialValue: List<T>.unmodifiable(initialValue),
         valueSnapshot: (value) =>
             value == null ? null : List<T>.unmodifiable(value),
         fieldBuilder: (field) => HyperCascader<T>(
           nodes: nodes,
           value: field.value ?? <T>[],
           onChanged: field.enabled
               ? (value) => field.didChange(List<T>.unmodifiable(value))
               : null,
           enabled: field.enabled,
           loadChildren: loadChildren,
           allowClear: allowClear,
           placeholder: placeholder,
           rootLabel: rootLabel,
           backLabel: backLabel,
           pathSeparator: pathSeparator,
           labelBuilder: labelBuilder,
           presentation: presentation,
           style: cascaderStyle,
           surfaceStyle: surfaceStyle,
         ),
       );
}
