import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'editor_theme_document.dart';

class EditorWheelVisual {
  String? curve;
  EditorColor? borderColor;
  double? unselectedScale;
  double? fontSize,
      selectedFontSize,
      duration,
      fontWeight,
      selectedFontWeight,
      unselectedOpacity,
      diameterRatio,
      perspective,
      squeeze,
      borderWidth;
  EditorColor? foreground,
      selectedForeground,
      disabledForeground,
      selection,
      background;
  Map<String, Object?> toJson() => {
    if (curve != null) 'curve': curve,
    if (borderColor != null) 'borderColor': borderColor!.toJson(),
    if (fontWeight != null) 'fontWeight': fontWeight,
    if (selectedFontWeight != null) 'selectedFontWeight': selectedFontWeight,
    if (unselectedOpacity != null) 'unselectedOpacity': unselectedOpacity,
    if (diameterRatio != null) 'diameterRatio': diameterRatio,
    if (perspective != null) 'perspective': perspective,
    if (squeeze != null) 'squeeze': squeeze,
    if (borderWidth != null) 'borderWidth': borderWidth,
    if (unselectedScale != null) 'unselectedScale': unselectedScale,
    if (fontSize != null) 'fontSize': fontSize,
    if (selectedFontSize != null) 'selectedFontSize': selectedFontSize,
    if (duration != null) 'duration': duration,
    if (foreground != null) 'foreground': foreground!.toJson(),
    if (selectedForeground != null)
      'selectedForeground': selectedForeground!.toJson(),
    if (disabledForeground != null)
      'disabledForeground': disabledForeground!.toJson(),
    if (selection != null) 'selection': selection!.toJson(),
    if (background != null) 'background': background!.toJson(),
  };
  static EditorWheelVisual fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'curve',
        'borderColor',
        'fontWeight',
        'selectedFontWeight',
        'unselectedOpacity',
        'diameterRatio',
        'perspective',
        'squeeze',
        'borderWidth',
        'unselectedScale',
        'fontSize',
        'selectedFontSize',
        'duration',
        'foreground',
        'selectedForeground',
        'disabledForeground',
        'selection',
        'background',
      }.contains(k),
    )) {
      throw const FormatException('未知滚轮外观配置');
    }
    return EditorWheelVisual()
      ..curve = j['curve'] as String?
      ..borderColor = j['borderColor'] == null
          ? null
          : EditorColor.fromJson(j['borderColor'] as Map<String, dynamic>)
      ..unselectedScale = _number(j['unselectedScale'])
      ..borderWidth = _number(j['borderWidth'])
      ..squeeze = _number(j['squeeze'])
      ..perspective = _number(j['perspective'])
      ..diameterRatio = _number(j['diameterRatio'])
      ..unselectedOpacity = _number(j['unselectedOpacity'])
      ..selectedFontWeight = _number(j['selectedFontWeight'])
      ..fontWeight = _number(j['fontWeight'])
      ..fontSize = _number(j['fontSize'])
      ..selectedFontSize = _number(j['selectedFontSize'])
      ..duration = _number(j['duration'])
      ..foreground = j['foreground'] == null
          ? null
          : EditorColor.fromJson(j['foreground'] as Map<String, dynamic>)
      ..selectedForeground = j['selectedForeground'] == null
          ? null
          : EditorColor.fromJson(
              j['selectedForeground'] as Map<String, dynamic>,
            )
      ..disabledForeground = j['disabledForeground'] == null
          ? null
          : EditorColor.fromJson(
              j['disabledForeground'] as Map<String, dynamic>,
            )
      ..selection = j['selection'] == null
          ? null
          : EditorColor.fromJson(j['selection'] as Map<String, dynamic>)
      ..background = j['background'] == null
          ? null
          : EditorColor.fromJson(j['background'] as Map<String, dynamic>);
  }

  HyperWheelPickerStyle resolve(HyperColorScheme colors) =>
      HyperWheelPickerStyle(
        textStyle: fontSize == null && fontWeight == null
            ? null
            : TextStyle(
                fontSize: fontSize,
                fontWeight: fontWeight == null
                    ? null
                    : FontWeight.values[(fontWeight!.round() ~/ 100 - 1).clamp(
                        0,
                        8,
                      )],
              ),
        selectedTextStyle:
            selectedFontSize == null && selectedFontWeight == null
            ? null
            : TextStyle(
                fontSize: selectedFontSize,
                fontWeight: selectedFontWeight == null
                    ? null
                    : FontWeight.values[(selectedFontWeight!.round() ~/ 100 - 1)
                          .clamp(0, 8)],
              ),
        curve: switch (curve) {
          'linear' => Curves.linear,
          'easeOut' => Curves.easeOut,
          'easeOutCubic' => Curves.easeOutCubic,
          'easeInOutCubic' => Curves.easeInOutCubic,
          _ => null,
        },
        unselectedScale: unselectedScale,
        unselectedOpacity: unselectedOpacity,
        diameterRatio: diameterRatio,
        perspective: perspective,
        squeeze: squeeze,
        selectionBorder: borderWidth == null && borderColor == null
            ? null
            : Border.all(
                width: borderWidth ?? 1,
                color: borderColor?.resolve(colors) ?? colors.outline,
              ),
        foregroundColor: foreground?.resolve(colors),
        selectedForegroundColor: selectedForeground?.resolve(colors),
        disabledColor: disabledForeground?.resolve(colors),
        selectionColor: selection?.resolve(colors),
        backgroundColor: background?.resolve(colors),
        duration: duration == null
            ? null
            : Duration(milliseconds: duration!.round()),
      );
}

class EditorWheelMetrics {
  double? width, itemExtent, horizontalPadding, selectionRadius, selectionSize;
  Map<String, Object?> toJson() => {
    if (selectionSize != null) 'selectionSize': selectionSize,
    if (width != null) 'width': width,
    if (itemExtent != null) 'itemExtent': itemExtent,
    if (horizontalPadding != null) 'horizontalPadding': horizontalPadding,
    if (selectionRadius != null) 'selectionRadius': selectionRadius,
  };
  static EditorWheelMetrics fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'selectionSize',
        'width',
        'itemExtent',
        'horizontalPadding',
        'selectionRadius',
      }.contains(k),
    )) {
      throw const FormatException('未知滚轮尺寸配置');
    }
    return EditorWheelMetrics()
      ..selectionSize = _number(j['selectionSize'])
      ..width = _number(j['width'])
      ..itemExtent = _number(j['itemExtent'])
      ..horizontalPadding = _number(j['horizontalPadding'])
      ..selectionRadius = _number(j['selectionRadius']);
  }

  HyperWheelPickerSize resolve(HyperWheelPickerSize base) => base.copyWith(
    width: width,
    itemExtent: itemExtent,
    horizontalPadding: horizontalPadding,
    selectionRadius: selectionRadius,
  );
}

double? _number(dynamic value) {
  if (value == null) return null;
  if (value is! num || !value.isFinite || value < 0) {
    throw const FormatException('滚轮尺寸必须是有限非负数');
  }
  return value.toDouble();
}
