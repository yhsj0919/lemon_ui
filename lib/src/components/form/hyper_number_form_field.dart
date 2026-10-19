import '../number_input/hyper_number_input.dart';
import '../text_field/hyper_text_field_style.dart';
import '../icon_button/hyper_icon_button_style.dart';
import 'hyper_form.dart';

/// Numeric field sharing the native Form lifecycle and trailing error display.
class HyperNumberFormField extends HyperFormField<double> {
  HyperNumberFormField({
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
    double? minimum,
    double? maximum,
    double step = 1,
    int? precision,
    bool readOnly = false,
    bool showClearButton = true,
    String? hintText,
    HyperTextFieldStyle? inputStyle,
    HyperIconButtonStyle? stepperStyle,
  }) : super(
         errorHandledByChild: true,
         fieldBuilder: (f) => HyperNumberInput(
           value: f.value,
           onChanged: f.enabled ? f.didChange : null,
           minimum: minimum,
           maximum: maximum,
           step: step,
           precision: precision,
           enabled: f.enabled,
           readOnly: readOnly,
           showClearButton: showClearButton,
           hintText: hintText,
           semanticLabel: semanticLabel ?? label,
           focusNode: f.focusNode,
           style: inputStyle,
           stepperStyle: stepperStyle,
           errorText: f.usesTrailingError ? f.displayError : null,
         ),
       );
}
