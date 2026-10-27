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
    bool showPasswordToggle = true,
    bool autocorrect = true,
    bool enableSuggestions = true,
    Iterable<String>? autofillHints,
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
           showPasswordToggle: showPasswordToggle,
           autocorrect: autocorrect,
           enableSuggestions: enableSuggestions,
           autofillHints: autofillHints,
           maxLines: maxLines,
           keyboardType: keyboardType,
           style: inputStyle,
         ),
       );

  /// 单行密码字段，默认隐藏输入并显示显隐切换；关闭纠错和输入建议。
  HyperTextFormField.password({
    Key? key,
    String? name,
    String? label,
    String? semanticLabel,
    String? description,
    bool requiredIndicator = false,
    HyperFieldLayout? layout,
    HyperFieldErrorDisplay? errorDisplay,
    HyperFieldStyle? style,
    String? initialValue,
    FormFieldValidator<String>? validator,
    HyperAsyncFieldValidator<String>? asyncValidator,
    FormFieldSetter<String>? onSaved,
    VoidCallback? onReset,
    ValueChanged<String?>? onChanged,
    bool enabled = true,
    AutovalidateMode autovalidateMode = AutovalidateMode.disabled,
    FocusNode? focusNode,
    String? hintText,
    bool readOnly = false,
    bool showPasswordToggle = true,
    TextInputType keyboardType = TextInputType.visiblePassword,
    Iterable<String>? autofillHints = const [AutofillHints.password],
    HyperTextFieldStyle? inputStyle,
  }) : this(
         key: key,
         name: name,
         label: label,
         semanticLabel: semanticLabel,
         description: description,
         requiredIndicator: requiredIndicator,
         layout: layout,
         errorDisplay: errorDisplay,
         style: style,
         initialValue: initialValue,
         validator: validator,
         asyncValidator: asyncValidator,
         onSaved: onSaved,
         onReset: onReset,
         onChanged: onChanged,
         enabled: enabled,
         autovalidateMode: autovalidateMode,
         focusNode: focusNode,
         hintText: hintText,
         readOnly: readOnly,
         showPasswordToggle: showPasswordToggle,
         keyboardType: keyboardType,
         autofillHints: autofillHints,
         inputStyle: inputStyle,
         obscureText: true,
         maxLines: 1,
         autocorrect: false,
         enableSuggestions: false,
       );
}

class _TextInput extends StatefulWidget {
  const _TextInput({
    required this.field,
    required this.hintText,
    required this.readOnly,
    required this.obscureText,
    required this.showPasswordToggle,
    required this.autocorrect,
    required this.enableSuggestions,
    required this.autofillHints,
    required this.maxLines,
    required this.keyboardType,
    required this.style,
  });
  final HyperFormFieldState<String> field;
  final String? hintText;
  final bool readOnly, obscureText;
  final bool showPasswordToggle, autocorrect, enableSuggestions;
  final Iterable<String>? autofillHints;
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
    showPasswordToggle: widget.showPasswordToggle,
    autocorrect: widget.autocorrect,
    enableSuggestions: widget.enableSuggestions,
    autofillHints: widget.autofillHints,
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
