import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'editor_theme_document.dart';

class EditorTableMetrics {
  double? treeIndent;
  double? liftRadius;
  double? footerHorizontalPadding, footerVerticalPadding;
  double? liftBorderWidth;
  double? rowHeight;
  double? headerHeight;
  double? columnWidth;
  double? minimumColumnWidth;
  double? controlColumnWidth;
  double? horizontalPadding;
  double? verticalPadding;
  double? iconSize;
  double? borderWidth;
  double? radius;
  double? fontSize;
  double? headerFontSize;
  Map<String, Object?> toJson() => {
    if (treeIndent != null) 'treeIndent': treeIndent,
    if (liftRadius != null) 'liftRadius': liftRadius,
    if (footerHorizontalPadding != null)
      'footerHorizontalPadding': footerHorizontalPadding,
    if (footerVerticalPadding != null)
      'footerVerticalPadding': footerVerticalPadding,
    if (liftBorderWidth != null) 'liftBorderWidth': liftBorderWidth,
    if (rowHeight != null) 'rowHeight': rowHeight,
    if (headerHeight != null) 'headerHeight': headerHeight,
    if (columnWidth != null) 'columnWidth': columnWidth,
    if (minimumColumnWidth != null) 'minimumColumnWidth': minimumColumnWidth,
    if (controlColumnWidth != null) 'controlColumnWidth': controlColumnWidth,
    if (horizontalPadding != null) 'horizontalPadding': horizontalPadding,
    if (verticalPadding != null) 'verticalPadding': verticalPadding,
    if (iconSize != null) 'iconSize': iconSize,
    if (borderWidth != null) 'borderWidth': borderWidth,
    if (radius != null) 'radius': radius,
    if (fontSize != null) 'fontSize': fontSize,
    if (headerFontSize != null) 'headerFontSize': headerFontSize,
  };
  static EditorTableMetrics fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'treeIndent',
        'liftRadius',
        'footerHorizontalPadding',
        'footerVerticalPadding',
        'liftBorderWidth',
        'rowHeight',
        'headerHeight',
        'columnWidth',
        'minimumColumnWidth',
        'controlColumnWidth',
        'horizontalPadding',
        'verticalPadding',
        'iconSize',
        'borderWidth',
        'radius',
        'fontSize',
        'headerFontSize',
      }.contains(k),
    )) {
      throw const FormatException('未知表格主题字段');
    }
    return EditorTableMetrics()
      ..liftBorderWidth = _number(j['liftBorderWidth'])
      ..footerHorizontalPadding = _number(j['footerHorizontalPadding'])
      ..footerVerticalPadding = _number(j['footerVerticalPadding'])
      ..liftRadius = _number(j['liftRadius'])
      ..treeIndent = _number(j['treeIndent'])
      ..rowHeight = _number(j['rowHeight'])
      ..headerHeight = _number(j['headerHeight'])
      ..columnWidth = _number(j['columnWidth'])
      ..minimumColumnWidth = _number(j['minimumColumnWidth'])
      ..controlColumnWidth = _number(j['controlColumnWidth'])
      ..horizontalPadding = _number(j['horizontalPadding'])
      ..verticalPadding = _number(j['verticalPadding'])
      ..iconSize = _number(j['iconSize'])
      ..borderWidth = _number(j['borderWidth'])
      ..radius = _number(j['radius'])
      ..fontSize = _number(j['fontSize'])
      ..headerFontSize = _number(j['headerFontSize']);
  }

  HyperTableSize resolve(HyperTableSize s) => s.copyWith(
    liftRadius: liftRadius,
    headerFontSize: headerFontSize,
    treeIndent: treeIndent,
    rowHeight: rowHeight,
    headerHeight: headerHeight,
    columnWidth: columnWidth,
    minimumColumnWidth: minimumColumnWidth,
    controlColumnWidth: controlColumnWidth,
    horizontalPadding: horizontalPadding,
    verticalPadding: verticalPadding,
    iconSize: iconSize,
    borderWidth: borderWidth,
    radius: radius,
  );
}

class EditorTableVisual {
  EditorColor? liftBackground;
  EditorColor? liftBorderColor;
  double? duration, liftDuration;
  final rowShadow = EditorComponentShadow();
  EditorColor? foreground;
  EditorColor? headerForeground;
  EditorColor? background;
  EditorColor? headerBackground;
  EditorColor? stripeBackground;
  EditorColor? hoverBackground;
  EditorColor? selectedBackground;
  EditorColor? editingBackground;
  EditorColor? borderColor;
  EditorColor? focusColor;
  Map<String, Object?> toJson() => {
    if (liftBackground != null) 'liftBackground': liftBackground!.toJson(),
    if (liftBorderColor != null) 'liftBorderColor': liftBorderColor!.toJson(),
    if (duration != null) 'duration': duration,
    if (liftDuration != null) 'liftDuration': liftDuration,
    if (rowShadow.shadows != null)
      'rowShadow': rowShadow.shadows!.map((s) => s.toJson()).toList(),
    if (foreground != null) 'foreground': foreground!.toJson(),
    if (headerForeground != null)
      'headerForeground': headerForeground!.toJson(),
    if (background != null) 'background': background!.toJson(),
    if (headerBackground != null)
      'headerBackground': headerBackground!.toJson(),
    if (stripeBackground != null)
      'stripeBackground': stripeBackground!.toJson(),
    if (hoverBackground != null) 'hoverBackground': hoverBackground!.toJson(),
    if (selectedBackground != null)
      'selectedBackground': selectedBackground!.toJson(),
    if (editingBackground != null)
      'editingBackground': editingBackground!.toJson(),
    if (borderColor != null) 'borderColor': borderColor!.toJson(),
    if (focusColor != null) 'focusColor': focusColor!.toJson(),
  };
  static EditorTableVisual fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'liftBackground',
        'liftBorderColor',
        'duration',
        'liftDuration',
        'rowShadow',
        'foreground',
        'headerForeground',
        'background',
        'headerBackground',
        'stripeBackground',
        'hoverBackground',
        'selectedBackground',
        'editingBackground',
        'borderColor',
        'focusColor',
      }.contains(k),
    )) {
      throw const FormatException('未知表格主题字段');
    }
    return EditorTableVisual()
      ..liftBorderColor = j['liftBorderColor'] == null
          ? null
          : EditorColor.fromJson(j['liftBorderColor'] as Map<String, dynamic>)
      ..liftBackground = j['liftBackground'] == null
          ? null
          : EditorColor.fromJson(j['liftBackground'] as Map<String, dynamic>)
      ..duration = _number(j['duration'])
      ..liftDuration = _number(j['liftDuration'])
      ..rowShadow.shadows = j['rowShadow'] == null
          ? null
          : (j['rowShadow'] as List)
                .map((v) => EditorShadow.fromJson(v as Map<String, dynamic>))
                .toList()
      ..foreground = j['foreground'] == null
          ? null
          : EditorColor.fromJson(j['foreground'] as Map<String, dynamic>)
      ..headerForeground = j['headerForeground'] == null
          ? null
          : EditorColor.fromJson(j['headerForeground'] as Map<String, dynamic>)
      ..background = j['background'] == null
          ? null
          : EditorColor.fromJson(j['background'] as Map<String, dynamic>)
      ..headerBackground = j['headerBackground'] == null
          ? null
          : EditorColor.fromJson(j['headerBackground'] as Map<String, dynamic>)
      ..stripeBackground = j['stripeBackground'] == null
          ? null
          : EditorColor.fromJson(j['stripeBackground'] as Map<String, dynamic>)
      ..hoverBackground = j['hoverBackground'] == null
          ? null
          : EditorColor.fromJson(j['hoverBackground'] as Map<String, dynamic>)
      ..selectedBackground = j['selectedBackground'] == null
          ? null
          : EditorColor.fromJson(
              j['selectedBackground'] as Map<String, dynamic>,
            )
      ..editingBackground = j['editingBackground'] == null
          ? null
          : EditorColor.fromJson(j['editingBackground'] as Map<String, dynamic>)
      ..borderColor = j['borderColor'] == null
          ? null
          : EditorColor.fromJson(j['borderColor'] as Map<String, dynamic>)
      ..focusColor = j['focusColor'] == null
          ? null
          : EditorColor.fromJson(j['focusColor'] as Map<String, dynamic>);
  }

  HyperTableStyle resolve(
    HyperColorScheme c,
    EditorTableMetrics m, {
    HyperTableSize? inherited,
  }) => HyperTableStyle(
    footerPadding:
        m.footerHorizontalPadding == null && m.footerVerticalPadding == null
        ? null
        : EdgeInsets.symmetric(
            horizontal:
                m.footerHorizontalPadding ??
                m.horizontalPadding ??
                inherited?.horizontalPadding ??
                0,
            vertical:
                m.footerVerticalPadding ??
                m.horizontalPadding ??
                inherited?.horizontalPadding ??
                0,
          ),
    liftRadius: m.liftRadius,
    liftBorder: m.liftBorderWidth == null && liftBorderColor == null
        ? null
        : (m.liftBorderWidth ?? 0) == 0
        ? BorderSide.none
        : BorderSide(
            color: liftBorderColor?.resolve(c) ?? c.outline,
            width: m.liftBorderWidth!,
          ),
    liftBackground: liftBackground?.resolve(c),
    duration: duration == null
        ? null
        : Duration(milliseconds: duration!.round()),
    liftDuration: liftDuration == null
        ? null
        : Duration(milliseconds: liftDuration!.round()),
    rowBoxShadow: rowShadow.shadows?.map((s) => s.resolve(c)).toList(),
    textStyle: TextStyle(fontSize: m.fontSize, color: foreground?.resolve(c)),
    headerTextStyle: TextStyle(
      fontSize: m.headerFontSize,
      color: headerForeground?.resolve(c),
    ),
    background: background?.resolve(c),
    headerBackground: headerBackground?.resolve(c),
    stripeBackground: stripeBackground?.resolve(c),
    hoverBackground: hoverBackground?.resolve(c),
    selectedBackground: selectedBackground?.resolve(c),
    editingBackground: editingBackground?.resolve(c),
    borderColor: borderColor?.resolve(c),
    focusColor: focusColor?.resolve(c),
  );
}

double? _number(dynamic v) {
  if (v == null) return null;
  if (v is! num || !v.isFinite || v < 0) {
    throw const FormatException('表格尺寸必须为非负有限数字');
  }
  return v.toDouble();
}
