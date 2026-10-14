import 'package:flutter/material.dart';

import 'editor_theme_document.dart';
import 'editor_basic_control_fields.dart';

class EditorSurfaceFields {
  double? paddingLeft;
  double? paddingTop;
  double? paddingRight;
  double? paddingBottom;
  double? titlePadding;
  double? outsideTitlePadding;
  double? titleSpacing;
  double? outsideTitleSpacing;
  double? actionSpacing;
  double? titleFontSize;
  double? actionFontSize;
  double? padding;
  double? contentPadding;
  double? radius;
  double? itemRadius;
  double? headerHeight;
  double? iconSize;
  double? spacing;
  double? separatorThickness;
  double? separatorExtent;
  double? fontSize;
  double? lineHeight;
  double? duration;
  double? pressedScale;
  double? hoverOpacity;
  double? focusOpacity;
  double? pressedOpacity;
  double? disabledOpacity;
  EditorColor? iconColor;
  EditorColor? titleColor;
  EditorColor? actionColor;
  EditorColor? textColor;
  EditorColor? overlayColor;
  EditorColor? separatorColor;
  String? curve;
  String? clip;
  bool? showDividers;
  Map<String, Object?> toJson() => {
    if (paddingLeft != null) 'paddingLeft': paddingLeft,
    if (paddingTop != null) 'paddingTop': paddingTop,
    if (paddingRight != null) 'paddingRight': paddingRight,
    if (paddingBottom != null) 'paddingBottom': paddingBottom,
    if (titlePadding != null) 'titlePadding': titlePadding,
    if (outsideTitlePadding != null) 'outsideTitlePadding': outsideTitlePadding,
    if (titleSpacing != null) 'titleSpacing': titleSpacing,
    if (outsideTitleSpacing != null) 'outsideTitleSpacing': outsideTitleSpacing,
    if (actionSpacing != null) 'actionSpacing': actionSpacing,
    if (titleFontSize != null) 'titleFontSize': titleFontSize,
    if (actionFontSize != null) 'actionFontSize': actionFontSize,
    if (padding != null) 'padding': padding,
    if (contentPadding != null) 'contentPadding': contentPadding,
    if (radius != null) 'radius': radius,
    if (itemRadius != null) 'itemRadius': itemRadius,
    if (headerHeight != null) 'headerHeight': headerHeight,
    if (iconSize != null) 'iconSize': iconSize,
    if (spacing != null) 'spacing': spacing,
    if (separatorThickness != null) 'separatorThickness': separatorThickness,
    if (separatorExtent != null) 'separatorExtent': separatorExtent,
    if (fontSize != null) 'fontSize': fontSize,
    if (lineHeight != null) 'lineHeight': lineHeight,
    if (duration != null) 'duration': duration,
    if (pressedScale != null) 'pressedScale': pressedScale,
    if (hoverOpacity != null) 'hoverOpacity': hoverOpacity,
    if (focusOpacity != null) 'focusOpacity': focusOpacity,
    if (pressedOpacity != null) 'pressedOpacity': pressedOpacity,
    if (disabledOpacity != null) 'disabledOpacity': disabledOpacity,
    if (iconColor != null) 'iconColor': iconColor!.toJson(),
    if (titleColor != null) 'titleColor': titleColor!.toJson(),
    if (actionColor != null) 'actionColor': actionColor!.toJson(),
    if (textColor != null) 'textColor': textColor!.toJson(),
    if (overlayColor != null) 'overlayColor': overlayColor!.toJson(),
    if (separatorColor != null) 'separatorColor': separatorColor!.toJson(),
    if (curve != null) 'curve': curve,
    if (clip != null) 'clip': clip,
    if (showDividers != null) 'showDividers': showDividers,
  };
  static EditorSurfaceFields fromJson(Map<String, dynamic> j) {
    const fields = {
      'paddingLeft',
      'paddingTop',
      'paddingRight',
      'paddingBottom',
      'titlePadding',
      'outsideTitlePadding',
      'titleSpacing',
      'outsideTitleSpacing',
      'actionSpacing',
      'titleFontSize',
      'actionFontSize',
      'padding',
      'contentPadding',
      'radius',
      'itemRadius',
      'headerHeight',
      'iconSize',
      'spacing',
      'separatorThickness',
      'separatorExtent',
      'fontSize',
      'lineHeight',
      'duration',
      'pressedScale',
      'hoverOpacity',
      'focusOpacity',
      'pressedOpacity',
      'disabledOpacity',
      'iconColor',
      'titleColor',
      'actionColor',
      'textColor',
      'overlayColor',
      'separatorColor',
      'curve',
      'clip',
      'showDividers',
    };
    if (j.keys.any((k) => !fields.contains(k))) {
      throw const FormatException('不支持的容器字段');
    }
    return EditorSurfaceFields()
      ..paddingLeft = number(j['paddingLeft'], min: 0, max: 1000)
      ..paddingTop = number(j['paddingTop'], min: 0, max: 1000)
      ..paddingRight = number(j['paddingRight'], min: 0, max: 1000)
      ..paddingBottom = number(j['paddingBottom'], min: 0, max: 1000)
      ..titlePadding = number(j['titlePadding'], min: 0, max: 1000)
      ..outsideTitlePadding = number(
        j['outsideTitlePadding'],
        min: 0,
        max: 1000,
      )
      ..titleSpacing = number(j['titleSpacing'], min: 0, max: 1000)
      ..outsideTitleSpacing = number(
        j['outsideTitleSpacing'],
        min: 0,
        max: 1000,
      )
      ..actionSpacing = number(j['actionSpacing'], min: 0, max: 1000)
      ..titleFontSize = number(j['titleFontSize'], min: 0, max: 1000)
      ..actionFontSize = number(j['actionFontSize'], min: 0, max: 1000)
      ..padding = number(j['padding'], min: 0, max: 1000)
      ..contentPadding = number(j['contentPadding'], min: 0, max: 1000)
      ..radius = number(j['radius'], min: 0, max: 1000)
      ..itemRadius = number(j['itemRadius'], min: 0, max: 1000)
      ..headerHeight = number(j['headerHeight'], min: 0, max: 1000)
      ..iconSize = number(j['iconSize'], min: 0, max: 1000)
      ..spacing = number(j['spacing'], min: 0, max: 1000)
      ..separatorThickness = number(j['separatorThickness'], min: 0, max: 1000)
      ..separatorExtent = number(j['separatorExtent'], min: 0, max: 1000)
      ..fontSize = number(j['fontSize'], min: 0, max: 1000)
      ..lineHeight = number(j['lineHeight'], min: 0, max: 3)
      ..duration = number(j['duration'], min: 0, max: 5000)
      ..pressedScale = number(j['pressedScale'], min: 0, max: 3)
      ..hoverOpacity = number(j['hoverOpacity'], min: 0, max: 1)
      ..focusOpacity = number(j['focusOpacity'], min: 0, max: 1)
      ..pressedOpacity = number(j['pressedOpacity'], min: 0, max: 1)
      ..disabledOpacity = number(j['disabledOpacity'], min: 0, max: 1)
      ..iconColor = j['iconColor'] == null
          ? null
          : EditorColor.fromJson(j['iconColor'] as Map<String, dynamic>)
      ..titleColor = j['titleColor'] == null
          ? null
          : EditorColor.fromJson(j['titleColor'] as Map<String, dynamic>)
      ..actionColor = j['actionColor'] == null
          ? null
          : EditorColor.fromJson(j['actionColor'] as Map<String, dynamic>)
      ..textColor = j['textColor'] == null
          ? null
          : EditorColor.fromJson(j['textColor'] as Map<String, dynamic>)
      ..overlayColor = j['overlayColor'] == null
          ? null
          : EditorColor.fromJson(j['overlayColor'] as Map<String, dynamic>)
      ..separatorColor = j['separatorColor'] == null
          ? null
          : EditorColor.fromJson(j['separatorColor'] as Map<String, dynamic>)
      ..curve = j['curve'] as String?
      ..clip = j['clip'] as String?
      ..showDividers = j['showDividers'] as bool?;
  }

  EdgeInsets? resolvedPadding(EdgeInsets base) =>
      padding == null &&
          paddingLeft == null &&
          paddingTop == null &&
          paddingRight == null &&
          paddingBottom == null
      ? null
      : EdgeInsets.fromLTRB(
          paddingLeft ?? padding ?? base.left,
          paddingTop ?? padding ?? base.top,
          paddingRight ?? padding ?? base.right,
          paddingBottom ?? padding ?? base.bottom,
        );
  EdgeInsets? get insets => padding == null ? null : EdgeInsets.all(padding!);
  EdgeInsets? get contentInsets =>
      contentPadding == null ? null : EdgeInsets.all(contentPadding!);
  BorderRadius? get borderRadius =>
      radius == null ? null : BorderRadius.circular(radius!);
  Duration? get animationDuration =>
      duration == null ? null : Duration(milliseconds: duration!.round());
  Curve? get animationCurve => editorControlCurve(curve);
  Clip? get clipping => switch (clip) {
    'none' => Clip.none,
    'hardEdge' => Clip.hardEdge,
    'antiAlias' => Clip.antiAlias,
    _ => null,
  };
}
