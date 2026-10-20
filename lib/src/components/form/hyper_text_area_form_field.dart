import 'package:flutter/material.dart';

import '../text_field/hyper_text_area.dart';
import '../text_field/hyper_text_field_style.dart';
import 'hyper_form.dart';

/// Multi-line text input integrated with the Form lifecycle.
class HyperTextAreaFormField extends HyperFormField<String> {
  HyperTextAreaFormField({
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
    bool showClearButton = false,
    bool showCounter = false,
    int? maxLength,
    int minLines = 3,
    int? maxLines,
    HyperTextFieldStyle? inputStyle,
  }) : super(
         errorHandledByChild: true,
         fieldBuilder: (field) => _TextAreaInput(
           field: field,
           hintText: hintText,
           readOnly: readOnly,
           showClearButton: showClearButton,
           showCounter: showCounter,
           maxLength: maxLength,
           minLines: minLines,
           maxLines: maxLines,
           style: inputStyle,
         ),
       );
}

class _TextAreaInput extends StatefulWidget {
  const _TextAreaInput({
    required this.field,
    required this.hintText,
    required this.readOnly,
    required this.showClearButton,
    required this.showCounter,
    required this.maxLength,
    required this.minLines,
    required this.maxLines,
    required this.style,
  });

  final HyperFormFieldState<String> field;
  final String? hintText;
  final bool readOnly, showClearButton, showCounter;
  final int? maxLength, maxLines;
  final int minLines;
  final HyperTextFieldStyle? style;

  @override
  State<_TextAreaInput> createState() => _TextAreaInputState();
}

class _TextAreaInputState extends State<_TextAreaInput> {
  late final controller = TextEditingController(text: widget.field.value ?? '');

  @override
  void didUpdateWidget(_TextAreaInput oldWidget) {
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
  Widget build(BuildContext context) => HyperTextArea(
    controller: controller,
    focusNode: widget.field.focusNode,
    semanticLabel: widget.field.field.semanticLabel ?? widget.field.field.label,
    hintText: widget.hintText,
    readOnly: widget.readOnly,
    showClearButton: widget.showClearButton,
    showCounter: widget.showCounter,
    maxLength: widget.maxLength,
    minLines: widget.minLines,
    maxLines: widget.maxLines,
    enabled: widget.field.enabled,
    errorText: widget.field.usesTrailingError
        ? widget.field.displayError
        : null,
    style: widget.style,
    onChanged: widget.field.didChange,
  );
}
