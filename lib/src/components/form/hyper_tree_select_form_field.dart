import '../card/hyper_card_style.dart';
import '../select/hyper_select_model.dart';
import '../tree_select/hyper_tree_select.dart';
import '../tree_select/hyper_tree_select_style.dart';
import 'hyper_form.dart';

/// A single tree value integrated with the form lifecycle.
class HyperTreeSelectFormField<T extends Object> extends HyperFormField<T> {
  HyperTreeSelectFormField({
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
    super.initialValue,
    required List<HyperTreeSelectNode<T>> nodes,
    HyperTreeSelectChildrenLoader<T>? loadChildren,
    bool allowClear = true,
    bool leafOnly = false,
    String placeholder = '请选择',
    String Function(T)? labelBuilder,
    HyperSelectPresentation? presentation,
    HyperTreeSelectStyle? treeSelectStyle,
    HyperCardStyle? surfaceStyle,
  }) : super(
         fieldBuilder: (field) => HyperTreeSelect<T>(
           nodes: nodes,
           value: field.value,
           onChanged: field.enabled ? field.didChange : null,
           loadChildren: loadChildren,
           enabled: field.enabled,
           allowClear: allowClear,
           leafOnly: leafOnly,
           placeholder: placeholder,
           labelBuilder: labelBuilder,
           presentation: presentation,
           style: treeSelectStyle,
           surfaceStyle: surfaceStyle,
         ),
       );
}
