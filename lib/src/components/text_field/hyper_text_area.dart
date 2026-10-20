import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'hyper_text_field.dart';
import 'hyper_text_field_style.dart';

/// 多行文本输入，复用 HyperTextField 的主题、错误提示和操作布局。
class HyperTextArea extends StatelessWidget {
  const HyperTextArea({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.label,
    this.hintText,
    this.errorText,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.readOnly = false,
    this.showClearButton = false,
    this.showCounter = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.minLines = 3,
    this.maxLines,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.textCapitalization = TextCapitalization.sentences,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.semanticLabel,
    this.style,
    this.errorBuilder,
  }) : assert(controller == null || initialValue == null),
       assert(minLines == null || minLines > 0),
       assert(maxLines == null || maxLines > 0),
       assert(maxLines == null || minLines == null || minLines <= maxLines),
       assert(maxLength == null || maxLength > 0);

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final String? label, hintText, errorText, semanticLabel;
  final Widget? leading, trailing;
  final bool enabled, readOnly, showClearButton, showCounter;
  final int? maxLength, minLines, maxLines;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final bool autofocus, autocorrect, enableSuggestions;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged, onSubmitted;
  final HyperTextFieldStyle? style;
  final Widget Function(BuildContext context, String errorText)? errorBuilder;

  @override
  Widget build(BuildContext context) => HyperTextField(
    controller: controller,
    initialValue: initialValue,
    focusNode: focusNode,
    label: label,
    hintText: hintText,
    errorText: errorText,
    leading: leading,
    trailing: trailing,
    enabled: enabled,
    readOnly: readOnly,
    showClearButton: showClearButton,
    showCounter: showCounter,
    maxLength: maxLength,
    maxLengthEnforcement: maxLengthEnforcement,
    minLines: minLines,
    maxLines: maxLines,
    keyboardType: TextInputType.multiline,
    textCapitalization: textCapitalization,
    autofocus: autofocus,
    autocorrect: autocorrect,
    enableSuggestions: enableSuggestions,
    inputFormatters: inputFormatters,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    semanticLabel: semanticLabel,
    style: style,
    errorBuilder: errorBuilder,
  );
}
