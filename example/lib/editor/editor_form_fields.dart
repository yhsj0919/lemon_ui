import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'editor_theme_document.dart';

class EditorFormMetrics {
  double? labelWidth, gap, fieldSpacing, messageSpacing, minimumControlWidth;

  Map<String, Object?> toJson() => {
    if (labelWidth != null) 'labelWidth': labelWidth,
    if (gap != null) 'gap': gap,
    if (fieldSpacing != null) 'fieldSpacing': fieldSpacing,
    if (messageSpacing != null) 'messageSpacing': messageSpacing,
    if (minimumControlWidth != null) 'minimumControlWidth': minimumControlWidth,
  };
  static EditorFormMetrics fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'labelWidth',
        'gap',
        'fieldSpacing',
        'messageSpacing',
        'minimumControlWidth',
      }.contains(k),
    )) {
      throw const FormatException('未知表单配置字段');
    }
    return EditorFormMetrics()
      ..labelWidth = _number(j['labelWidth'])
      ..gap = _number(j['gap'])
      ..fieldSpacing = _number(j['fieldSpacing'])
      ..messageSpacing = _number(j['messageSpacing'])
      ..minimumControlWidth = _number(j['minimumControlWidth']);
  }

  HyperFormSize resolve(HyperFormSize s) => s.copyWith(
    labelWidth: labelWidth,
    gap: gap,
    fieldSpacing: fieldSpacing,
    messageSpacing: messageSpacing,
    minimumControlWidth: minimumControlWidth,
  );
}

class EditorFormVisual {
  double? labelFontSize, descriptionFontSize, errorFontSize;
  EditorColor? labelColor, descriptionColor, errorColor, requiredColor;
  Map<String, Object?> toJson() => {
    if (labelFontSize != null) 'labelFontSize': labelFontSize,
    if (descriptionFontSize != null) 'descriptionFontSize': descriptionFontSize,
    if (errorFontSize != null) 'errorFontSize': errorFontSize,
    if (labelColor != null) 'labelColor': labelColor!.toJson(),
    if (descriptionColor != null)
      'descriptionColor': descriptionColor!.toJson(),
    if (errorColor != null) 'errorColor': errorColor!.toJson(),
    if (requiredColor != null) 'requiredColor': requiredColor!.toJson(),
  };
  static EditorFormVisual fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'labelFontSize',
        'descriptionFontSize',
        'errorFontSize',
        'labelColor',
        'descriptionColor',
        'errorColor',
        'requiredColor',
      }.contains(k),
    )) {
      throw const FormatException('未知表单配置字段');
    }
    return EditorFormVisual()
      ..labelFontSize = _number(j['labelFontSize'])
      ..descriptionFontSize = _number(j['descriptionFontSize'])
      ..errorFontSize = _number(j['errorFontSize'])
      ..labelColor = j['labelColor'] == null
          ? null
          : EditorColor.fromJson(j['labelColor'] as Map<String, dynamic>)
      ..descriptionColor = j['descriptionColor'] == null
          ? null
          : EditorColor.fromJson(j['descriptionColor'] as Map<String, dynamic>)
      ..errorColor = j['errorColor'] == null
          ? null
          : EditorColor.fromJson(j['errorColor'] as Map<String, dynamic>)
      ..requiredColor = j['requiredColor'] == null
          ? null
          : EditorColor.fromJson(j['requiredColor'] as Map<String, dynamic>);
  }

  HyperFieldStyle resolve(HyperColorScheme colors) => HyperFieldStyle(
    labelStyle: labelFontSize == null && labelColor == null
        ? null
        : TextStyle(
            fontSize: labelFontSize,
            color: labelColor?.resolve(colors),
          ),
    descriptionStyle: descriptionFontSize == null && descriptionColor == null
        ? null
        : TextStyle(
            fontSize: descriptionFontSize,
            color: descriptionColor?.resolve(colors),
          ),
    errorStyle: errorFontSize == null && errorColor == null
        ? null
        : TextStyle(
            fontSize: errorFontSize,
            color: errorColor?.resolve(colors),
          ),
    requiredColor: requiredColor?.resolve(colors),
  );
}

double? _number(dynamic v) {
  if (v == null) return null;
  if (v is! num || !v.isFinite || v < 0) {
    throw const FormatException('表单尺寸须为非负有限数');
  }
  return v.toDouble();
}
