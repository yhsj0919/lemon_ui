import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'editor_button_fields.dart';
import 'editor_theme_document.dart';

class EditorTagMetrics {
  double? height;
  double? horizontalPadding;
  double? radius;
  double? iconSize;
  double? iconSpacing;
  Map<String, Object?> toJson() => {
    if (height != null) 'height': height,
    if (horizontalPadding != null) 'horizontalPadding': horizontalPadding,
    if (radius != null) 'radius': radius,
    if (iconSize != null) 'iconSize': iconSize,
    if (iconSpacing != null) 'iconSpacing': iconSpacing,
  };
  static EditorTagMetrics fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'height',
        'horizontalPadding',
        'radius',
        'iconSize',
        'iconSpacing',
      }.contains(k),
    )) {
      throw const FormatException('不支持的标签尺寸');
    }
    return EditorTagMetrics()
      ..height = number(j['height'], min: 0, max: 300)
      ..horizontalPadding = number(j['horizontalPadding'], min: 0, max: 300)
      ..radius = number(j['radius'], min: 0, max: 300)
      ..iconSize = number(j['iconSize'], min: 0, max: 300)
      ..iconSpacing = number(j['iconSpacing'], min: 0, max: 300);
  }
}

class EditorTagVisual {
  double? fontSize;
  double? durationMilliseconds;
  double? backgroundFade;
  double? borderFade;
  double? foregroundFade;
  EditorColor? baseColor;
  EditorColor? foreground;
  String? colorVariant;
  String? foregroundMode;
  Map<String, Object?> toJson() => {
    if (fontSize != null) 'fontSize': fontSize,
    if (durationMilliseconds != null)
      'durationMilliseconds': durationMilliseconds,
    if (backgroundFade != null) 'backgroundFade': backgroundFade,
    if (borderFade != null) 'borderFade': borderFade,
    if (foregroundFade != null) 'foregroundFade': foregroundFade,
    if (colorVariant != null) 'colorVariant': colorVariant,
    if (foregroundMode != null) 'foregroundMode': foregroundMode,
    if (baseColor != null) 'baseColor': baseColor!.toJson(),
    if (foreground != null) 'foreground': foreground!.toJson(),
  };
  static EditorTagVisual fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'fontSize',
        'durationMilliseconds',
        'backgroundFade',
        'borderFade',
        'foregroundFade',
        'baseColor',
        'foreground',
        'colorVariant',
        'foregroundMode',
      }.contains(k),
    )) {
      throw const FormatException('不支持的标签外观');
    }
    if (j['colorVariant'] != null &&
        !HyperTagColorVariant.values.any((v) => v.name == j['colorVariant'])) {
      throw const FormatException('无效标签配色');
    }
    if (j['foregroundMode'] != null &&
        !HyperTagForegroundMode.values.any(
          (v) => v.name == j['foregroundMode'],
        )) {
      throw const FormatException('无效前景策略');
    }
    return EditorTagVisual()
      ..fontSize = number(j['fontSize'], min: 8, max: 300)
      ..durationMilliseconds = number(
        j['durationMilliseconds'],
        min: 0,
        max: 5000,
      )
      ..backgroundFade = number(j['backgroundFade'], min: 0, max: 1)
      ..borderFade = number(j['borderFade'], min: 0, max: 1)
      ..foregroundFade = number(j['foregroundFade'], min: 0, max: 1)
      ..colorVariant = j['colorVariant'] as String?
      ..foregroundMode = j['foregroundMode'] as String?
      ..baseColor = j['baseColor'] == null
          ? null
          : EditorColor.fromJson(j['baseColor'] as Map<String, dynamic>)
      ..foreground = j['foreground'] == null
          ? null
          : EditorColor.fromJson(j['foreground'] as Map<String, dynamic>);
  }
}

HyperTagStyle resolveEditorTag(
  EditorComponent a,
  HyperColorScheme colors,
  HyperContrastThemeData contrast,
) {
  final v = a.tagStyle;
  final config = HyperTagStyle(
    colorVariant: v.colorVariant == null
        ? null
        : HyperTagColorVariant.values.byName(v.colorVariant!),
    foregroundMode: v.foregroundMode == null
        ? null
        : HyperTagForegroundMode.values.byName(v.foregroundMode!),
    baseColor: v.baseColor?.resolve(colors),
    backgroundFade: v.backgroundFade,
    borderFade: v.borderFade,
    foregroundFade: v.foregroundFade,
    foregroundColor:
        v.foreground?.resolve(colors) ?? a.foreground?.resolve(colors),
    background: switch (a.fillKind) {
      EditorFillKind.none => const HyperFill.none(),
      EditorFillKind.gradient =>
        a.gradient == null
            ? null
            : HyperFill.gradient(a.gradient!.resolve(colors)),
      _ =>
        a.background == null
            ? null
            : HyperFill.color(a.background!.resolve(colors)),
    },
    textStyle: v.fontSize == null ? null : TextStyle(fontSize: v.fontSize),
    duration: v.durationMilliseconds == null
        ? null
        : Duration(milliseconds: v.durationMilliseconds!.round()),
    boxShadow: a.shadows?.map((s) => s.resolve(colors)).toList(),
  );
  return config.copyWith(
    boxBorder: a.border.resolve(
      colors,
      inherited: BorderSide(
        color:
            config.resolvePalette(colors, contrast).borderColor ??
            colors.outline,
        width: 1,
      ),
    ),
  );
}
