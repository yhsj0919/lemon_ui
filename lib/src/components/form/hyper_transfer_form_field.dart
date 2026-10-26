import '../transfer/hyper_transfer.dart';
import '../transfer/hyper_transfer_style.dart';
import 'hyper_form.dart';

class HyperTransferFormField<T> extends HyperFormField<Set<T>> {
  HyperTransferFormField({
    super.key,
    super.name,
    super.label,
    super.semanticLabel,
    super.description,
    super.requiredIndicator,
    super.layout,
    super.errorDisplay,
    super.style,
    super.initialValue,
    super.validator,
    super.asyncValidator,
    super.onSaved,
    super.onReset,
    super.onChanged,
    super.enabled,
    super.autovalidateMode,
    super.focusNode,
    required List<HyperTransferOption<T>> options,
    HyperTransferStyle? transferStyle,
  }) : super(
         fieldBuilder: (f) => HyperTransfer<T>(
           options: options,
           value: f.value ?? <T>{},
           enabled: f.enabled,
           style: transferStyle,
           onChanged: f.enabled ? f.didChange : null,
         ),
       );
}
