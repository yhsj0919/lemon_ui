import 'package:flutter/material.dart';

import '../text_field/hyper_text_field.dart';
import '../text_field/hyper_text_field_style.dart';
import 'hyper_form.dart';

/// Text adapter that shares the native Form lifecycle and HyperTextField UI.
class HyperTextFormField extends HyperFormField<String> {
  HyperTextFormField({
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
    String? hintText,
    bool readOnly = false,
    bool obscureText = false,
    int? maxLines = 1,
    TextInputType? keyboardType,
    HyperTextFieldStyle? inputStyle,
  }) : super(
         errorHandledByChild: true,
         fieldBuilder: (field) => _TextInput(
           field: field,
           hintText: hintText,
           readOnly: readOnly,
           obscureText: obscureText,
           maxLines: maxLines,
           keyboardType: keyboardType,
           style: inputStyle,
         ),
       );
}

class _TextInput extends StatefulWidget {
  const _TextInput({
    required this.field,
    required this.hintText,
    required this.readOnly,
    required this.obscureText,
    required this.maxLines,
    required this.keyboardType,
    required this.style,
  });
  final HyperFormFieldState<String> field;
  final String? hintText;
  final bool readOnly, obscureText;
  final int? maxLines;
  final TextInputType? keyboardType;
  final HyperTextFieldStyle? style;
  @override
  State<_TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<_TextInput> {
  late final controller = TextEditingController(text: widget.field.value ?? '');
  @override
  void didUpdateWidget(_TextInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    final text = widget.field.value ?? '';
    if (controller.text != text) {
      controller.value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HyperTextField(
    controller: controller,
    focusNode: widget.field.focusNode,
    semanticLabel: widget.field.field.semanticLabel ?? widget.field.field.label,
    hintText: widget.hintText,
    readOnly: widget.readOnly,
    obscureText: widget.obscureText,
    enabled: widget.field.enabled,
    maxLines: widget.maxLines,
    keyboardType: widget.keyboardType,
    errorText: widget.field.usesTrailingError
        ? widget.field.displayError
        : null,
    style: widget.style,
    onChanged: widget.field.didChange,
  );
}
