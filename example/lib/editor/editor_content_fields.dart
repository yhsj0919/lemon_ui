import 'package:flutter/material.dart';

import 'editor_theme_document.dart';
import 'editor_basic_control_fields.dart';

class EditorContentFields {
  double? headerActionSpacing;
  double? headerRunSpacing;
  double? titlePadding;
  double? actionPadding;
  double? contentHeight;
  double? padding;
  double? radius;
  double? duration;
  double? fontSize;
  double? fontWeight;
  double? letterSpacing;
  double? iconExtent;
  double? iconFill;
  double? iconWeight;
  double? iconGrade;
  double? iconOpticalSize;
  double? avatarSmall;
  double? avatarMedium;
  double? avatarLarge;
  double? borderWidth;
  double? rowRadius;
  double? rowHeight;
  double? rowSpacing;
  double? indent;
  double? iconSize;
  double? contentSpacing;
  double? textStyleSize;
  double? textStyleWeight;
  double? illustrationSize;
  double? maxWidth;
  double? titleSpacing;
  double? actionSpacing;
  double? actionRunSpacing;
  double? titleStyleSize;
  double? titleStyleWeight;
  double? descriptionStyleSize;
  double? descriptionStyleWeight;
  double? columnSpacing;
  double? labelValueSpacing;
  double? headerSpacing;
  double? minimumColumnWidth;
  double? labelStyleSize;
  double? labelStyleWeight;
  double? valueStyleSize;
  double? valueStyleWeight;
  double? nodeSize;
  double? lineThickness;
  double? nodeLineGap;
  double? spacing;
  double? itemSpacing;
  double? textSpacing;
  double? timeStyleSize;
  double? timeStyleWeight;
  double? contentStyleSize;
  double? contentStyleWeight;
  double? overlap;
  double? ringWidth;
  double? minHeight;
  double? leadingSize;
  double? leadingSpacing;
  double? trailingSpacing;
  double? trailingIconSize;
  double? subtitleStyleSize;
  double? subtitleStyleWeight;
  EditorColor? textStyleColor;
  EditorColor? foregroundColor;
  EditorColor? selectedForegroundColor;
  EditorColor? disabledColor;
  EditorColor? focusColor;
  EditorColor? errorColor;
  EditorColor? rowBackground;
  EditorColor? selectedBackground;
  EditorColor? hoverBackground;
  EditorColor? pressedBackground;
  EditorColor? titleStyleColor;
  EditorColor? descriptionStyleColor;
  EditorColor? iconColor;
  EditorColor? labelStyleColor;
  EditorColor? valueStyleColor;
  EditorColor? borderColor;
  EditorColor? labelBackground;
  EditorColor? valueBackground;
  EditorColor? timeStyleColor;
  EditorColor? contentStyleColor;
  EditorColor? nodeForeground;
  EditorColor? lineColor;
  EditorColor? nodeFill;
  EditorColor? backgroundColor;
  EditorColor? ringColor;
  EditorColor? subtitleStyleColor;
  EditorColor? subtitleColor;
  EditorColor? trailingColor;
  EditorColor? overlayColor;
  String? actionPlacement;
  String? titleAlign;
  String? labelAlign;
  String? valueAlign;
  String? contentHeightMode;
  String? curve;
  Map<String, Object?> toJson() => {
    if (headerActionSpacing != null) 'headerActionSpacing': headerActionSpacing,
    if (headerRunSpacing != null) 'headerRunSpacing': headerRunSpacing,
    if (titlePadding != null) 'titlePadding': titlePadding,
    if (actionPadding != null) 'actionPadding': actionPadding,
    if (contentHeight != null) 'contentHeight': contentHeight,
    if (contentHeightMode != null) 'contentHeightMode': contentHeightMode,
    if (padding != null) 'padding': padding,
    if (radius != null) 'radius': radius,
    if (duration != null) 'duration': duration,
    if (fontSize != null) 'fontSize': fontSize,
    if (fontWeight != null) 'fontWeight': fontWeight,
    if (letterSpacing != null) 'letterSpacing': letterSpacing,
    if (iconExtent != null) 'iconExtent': iconExtent,
    if (iconFill != null) 'iconFill': iconFill,
    if (iconWeight != null) 'iconWeight': iconWeight,
    if (iconGrade != null) 'iconGrade': iconGrade,
    if (iconOpticalSize != null) 'iconOpticalSize': iconOpticalSize,
    if (avatarSmall != null) 'avatarSmall': avatarSmall,
    if (avatarMedium != null) 'avatarMedium': avatarMedium,
    if (avatarLarge != null) 'avatarLarge': avatarLarge,
    if (borderWidth != null) 'borderWidth': borderWidth,
    if (rowRadius != null) 'rowRadius': rowRadius,
    if (rowHeight != null) 'rowHeight': rowHeight,
    if (rowSpacing != null) 'rowSpacing': rowSpacing,
    if (indent != null) 'indent': indent,
    if (iconSize != null) 'iconSize': iconSize,
    if (contentSpacing != null) 'contentSpacing': contentSpacing,
    if (textStyleSize != null) 'textStyleSize': textStyleSize,
    if (textStyleWeight != null) 'textStyleWeight': textStyleWeight,
    if (illustrationSize != null) 'illustrationSize': illustrationSize,
    if (maxWidth != null) 'maxWidth': maxWidth,
    if (titleSpacing != null) 'titleSpacing': titleSpacing,
    if (actionSpacing != null) 'actionSpacing': actionSpacing,
    if (actionRunSpacing != null) 'actionRunSpacing': actionRunSpacing,
    if (titleStyleSize != null) 'titleStyleSize': titleStyleSize,
    if (titleStyleWeight != null) 'titleStyleWeight': titleStyleWeight,
    if (descriptionStyleSize != null)
      'descriptionStyleSize': descriptionStyleSize,
    if (descriptionStyleWeight != null)
      'descriptionStyleWeight': descriptionStyleWeight,
    if (columnSpacing != null) 'columnSpacing': columnSpacing,
    if (labelValueSpacing != null) 'labelValueSpacing': labelValueSpacing,
    if (headerSpacing != null) 'headerSpacing': headerSpacing,
    if (minimumColumnWidth != null) 'minimumColumnWidth': minimumColumnWidth,
    if (labelStyleSize != null) 'labelStyleSize': labelStyleSize,
    if (labelStyleWeight != null) 'labelStyleWeight': labelStyleWeight,
    if (valueStyleSize != null) 'valueStyleSize': valueStyleSize,
    if (valueStyleWeight != null) 'valueStyleWeight': valueStyleWeight,
    if (nodeSize != null) 'nodeSize': nodeSize,
    if (lineThickness != null) 'lineThickness': lineThickness,
    if (nodeLineGap != null) 'nodeLineGap': nodeLineGap,
    if (spacing != null) 'spacing': spacing,
    if (itemSpacing != null) 'itemSpacing': itemSpacing,
    if (textSpacing != null) 'textSpacing': textSpacing,
    if (timeStyleSize != null) 'timeStyleSize': timeStyleSize,
    if (timeStyleWeight != null) 'timeStyleWeight': timeStyleWeight,
    if (contentStyleSize != null) 'contentStyleSize': contentStyleSize,
    if (contentStyleWeight != null) 'contentStyleWeight': contentStyleWeight,
    if (overlap != null) 'overlap': overlap,
    if (ringWidth != null) 'ringWidth': ringWidth,
    if (minHeight != null) 'minHeight': minHeight,
    if (leadingSize != null) 'leadingSize': leadingSize,
    if (leadingSpacing != null) 'leadingSpacing': leadingSpacing,
    if (trailingSpacing != null) 'trailingSpacing': trailingSpacing,
    if (trailingIconSize != null) 'trailingIconSize': trailingIconSize,
    if (subtitleStyleSize != null) 'subtitleStyleSize': subtitleStyleSize,
    if (subtitleStyleWeight != null) 'subtitleStyleWeight': subtitleStyleWeight,
    if (textStyleColor != null) 'textStyleColor': textStyleColor!.toJson(),
    if (foregroundColor != null) 'foregroundColor': foregroundColor!.toJson(),
    if (selectedForegroundColor != null)
      'selectedForegroundColor': selectedForegroundColor!.toJson(),
    if (disabledColor != null) 'disabledColor': disabledColor!.toJson(),
    if (focusColor != null) 'focusColor': focusColor!.toJson(),
    if (errorColor != null) 'errorColor': errorColor!.toJson(),
    if (rowBackground != null) 'rowBackground': rowBackground!.toJson(),
    if (selectedBackground != null)
      'selectedBackground': selectedBackground!.toJson(),
    if (hoverBackground != null) 'hoverBackground': hoverBackground!.toJson(),
    if (pressedBackground != null)
      'pressedBackground': pressedBackground!.toJson(),
    if (titleStyleColor != null) 'titleStyleColor': titleStyleColor!.toJson(),
    if (descriptionStyleColor != null)
      'descriptionStyleColor': descriptionStyleColor!.toJson(),
    if (iconColor != null) 'iconColor': iconColor!.toJson(),
    if (labelStyleColor != null) 'labelStyleColor': labelStyleColor!.toJson(),
    if (valueStyleColor != null) 'valueStyleColor': valueStyleColor!.toJson(),
    if (borderColor != null) 'borderColor': borderColor!.toJson(),
    if (labelBackground != null) 'labelBackground': labelBackground!.toJson(),
    if (valueBackground != null) 'valueBackground': valueBackground!.toJson(),
    if (timeStyleColor != null) 'timeStyleColor': timeStyleColor!.toJson(),
    if (contentStyleColor != null)
      'contentStyleColor': contentStyleColor!.toJson(),
    if (nodeForeground != null) 'nodeForeground': nodeForeground!.toJson(),
    if (lineColor != null) 'lineColor': lineColor!.toJson(),
    if (nodeFill != null) 'nodeFill': nodeFill!.toJson(),
    if (backgroundColor != null) 'backgroundColor': backgroundColor!.toJson(),
    if (ringColor != null) 'ringColor': ringColor!.toJson(),
    if (subtitleStyleColor != null)
      'subtitleStyleColor': subtitleStyleColor!.toJson(),
    if (subtitleColor != null) 'subtitleColor': subtitleColor!.toJson(),
    if (trailingColor != null) 'trailingColor': trailingColor!.toJson(),
    if (overlayColor != null) 'overlayColor': overlayColor!.toJson(),
    if (actionPlacement != null) 'actionPlacement': actionPlacement,
    if (titleAlign != null) 'titleAlign': titleAlign,
    if (labelAlign != null) 'labelAlign': labelAlign,
    if (valueAlign != null) 'valueAlign': valueAlign,
    if (curve != null) 'curve': curve,
  };
  static EditorContentFields fromJson(Map<String, dynamic> j) {
    const fields = {
      'headerActionSpacing',
      'headerRunSpacing',
      'titlePadding',
      'actionPadding',
      'contentHeight',
      'contentHeightMode',
      'padding',
      'radius',
      'duration',
      'fontSize',
      'fontWeight',
      'letterSpacing',
      'iconExtent',
      'iconFill',
      'iconWeight',
      'iconGrade',
      'iconOpticalSize',
      'avatarSmall',
      'avatarMedium',
      'avatarLarge',
      'borderWidth',
      'rowRadius',
      'rowHeight',
      'rowSpacing',
      'indent',
      'iconSize',
      'contentSpacing',
      'textStyleSize',
      'textStyleWeight',
      'illustrationSize',
      'maxWidth',
      'titleSpacing',
      'actionSpacing',
      'actionRunSpacing',
      'titleStyleSize',
      'titleStyleWeight',
      'descriptionStyleSize',
      'descriptionStyleWeight',
      'columnSpacing',
      'labelValueSpacing',
      'headerSpacing',
      'minimumColumnWidth',
      'labelStyleSize',
      'labelStyleWeight',
      'valueStyleSize',
      'valueStyleWeight',
      'nodeSize',
      'lineThickness',
      'nodeLineGap',
      'spacing',
      'itemSpacing',
      'textSpacing',
      'timeStyleSize',
      'timeStyleWeight',
      'contentStyleSize',
      'contentStyleWeight',
      'overlap',
      'ringWidth',
      'minHeight',
      'leadingSize',
      'leadingSpacing',
      'trailingSpacing',
      'trailingIconSize',
      'subtitleStyleSize',
      'subtitleStyleWeight',
      'textStyleColor',
      'foregroundColor',
      'selectedForegroundColor',
      'disabledColor',
      'focusColor',
      'errorColor',
      'rowBackground',
      'selectedBackground',
      'hoverBackground',
      'pressedBackground',
      'titleStyleColor',
      'descriptionStyleColor',
      'iconColor',
      'labelStyleColor',
      'valueStyleColor',
      'borderColor',
      'labelBackground',
      'valueBackground',
      'timeStyleColor',
      'contentStyleColor',
      'nodeForeground',
      'lineColor',
      'nodeFill',
      'backgroundColor',
      'ringColor',
      'subtitleStyleColor',
      'subtitleColor',
      'trailingColor',
      'overlayColor',
      'actionPlacement',
      'titleAlign',
      'labelAlign',
      'valueAlign',
      'curve',
    };
    if (j.keys.any((k) => !fields.contains(k))) {
      throw const FormatException('不支持的内容属性');
    }
    return EditorContentFields()
      ..headerActionSpacing = number(
        j['headerActionSpacing'],
        min: 0,
        max: 1000,
      )
      ..headerRunSpacing = number(j['headerRunSpacing'], min: 0, max: 1000)
      ..titlePadding = number(j['titlePadding'], min: 0, max: 1000)
      ..actionPadding = number(j['actionPadding'], min: 0, max: 1000)
      ..contentHeight = number(j['contentHeight'], min: 0, max: 1000)
      ..contentHeightMode = j['contentHeightMode'] as String?
      ..padding = number(j['padding'], min: 0, max: 1000)
      ..radius = number(j['radius'], min: 0, max: 1000)
      ..duration = number(j['duration'], min: 0, max: 5000)
      ..fontSize = number(j['fontSize'], min: 0, max: 1000)
      ..fontWeight = number(j['fontWeight'], min: 0, max: 1000)
      ..letterSpacing = number(j['letterSpacing'], min: -20, max: 1000)
      ..iconExtent = number(j['iconExtent'], min: 0, max: 1000)
      ..iconFill = number(j['iconFill'], min: 0, max: 1000)
      ..iconWeight = number(j['iconWeight'], min: 0, max: 1000)
      ..iconGrade = number(j['iconGrade'], min: 0, max: 1000)
      ..iconOpticalSize = number(j['iconOpticalSize'], min: 0, max: 1000)
      ..avatarSmall = number(j['avatarSmall'], min: 0, max: 1000)
      ..avatarMedium = number(j['avatarMedium'], min: 0, max: 1000)
      ..avatarLarge = number(j['avatarLarge'], min: 0, max: 1000)
      ..borderWidth = number(j['borderWidth'], min: 0, max: 1000)
      ..rowRadius = number(j['rowRadius'], min: 0, max: 1000)
      ..rowHeight = number(j['rowHeight'], min: 0, max: 1000)
      ..rowSpacing = number(j['rowSpacing'], min: 0, max: 1000)
      ..indent = number(j['indent'], min: 0, max: 1000)
      ..iconSize = number(j['iconSize'], min: 0, max: 1000)
      ..contentSpacing = number(j['contentSpacing'], min: 0, max: 1000)
      ..textStyleSize = number(j['textStyleSize'], min: 0, max: 1000)
      ..textStyleWeight = number(j['textStyleWeight'], min: 0, max: 1000)
      ..illustrationSize = number(j['illustrationSize'], min: 0, max: 1000)
      ..maxWidth = number(j['maxWidth'], min: 0, max: 1000)
      ..titleSpacing = number(j['titleSpacing'], min: 0, max: 1000)
      ..actionSpacing = number(j['actionSpacing'], min: 0, max: 1000)
      ..actionRunSpacing = number(j['actionRunSpacing'], min: 0, max: 1000)
      ..titleStyleSize = number(j['titleStyleSize'], min: 0, max: 1000)
      ..titleStyleWeight = number(j['titleStyleWeight'], min: 0, max: 1000)
      ..descriptionStyleSize = number(
        j['descriptionStyleSize'],
        min: 0,
        max: 1000,
      )
      ..descriptionStyleWeight = number(
        j['descriptionStyleWeight'],
        min: 0,
        max: 1000,
      )
      ..columnSpacing = number(j['columnSpacing'], min: 0, max: 1000)
      ..labelValueSpacing = number(j['labelValueSpacing'], min: 0, max: 1000)
      ..headerSpacing = number(j['headerSpacing'], min: 0, max: 1000)
      ..minimumColumnWidth = number(j['minimumColumnWidth'], min: 0, max: 1000)
      ..labelStyleSize = number(j['labelStyleSize'], min: 0, max: 1000)
      ..labelStyleWeight = number(j['labelStyleWeight'], min: 0, max: 1000)
      ..valueStyleSize = number(j['valueStyleSize'], min: 0, max: 1000)
      ..valueStyleWeight = number(j['valueStyleWeight'], min: 0, max: 1000)
      ..nodeSize = number(j['nodeSize'], min: 0, max: 1000)
      ..lineThickness = number(j['lineThickness'], min: 0, max: 1000)
      ..nodeLineGap = number(j['nodeLineGap'], min: 0, max: 1000)
      ..spacing = number(j['spacing'], min: 0, max: 1000)
      ..itemSpacing = number(j['itemSpacing'], min: 0, max: 1000)
      ..textSpacing = number(j['textSpacing'], min: 0, max: 1000)
      ..timeStyleSize = number(j['timeStyleSize'], min: 0, max: 1000)
      ..timeStyleWeight = number(j['timeStyleWeight'], min: 0, max: 1000)
      ..contentStyleSize = number(j['contentStyleSize'], min: 0, max: 1000)
      ..contentStyleWeight = number(j['contentStyleWeight'], min: 0, max: 1000)
      ..overlap = number(j['overlap'], min: 0, max: 1000)
      ..ringWidth = number(j['ringWidth'], min: 0, max: 1000)
      ..minHeight = number(j['minHeight'], min: 0, max: 1000)
      ..leadingSize = number(j['leadingSize'], min: 0, max: 1000)
      ..leadingSpacing = number(j['leadingSpacing'], min: 0, max: 1000)
      ..trailingSpacing = number(j['trailingSpacing'], min: 0, max: 1000)
      ..trailingIconSize = number(j['trailingIconSize'], min: 0, max: 1000)
      ..subtitleStyleSize = number(j['subtitleStyleSize'], min: 0, max: 1000)
      ..subtitleStyleWeight = number(
        j['subtitleStyleWeight'],
        min: 0,
        max: 1000,
      )
      ..textStyleColor = j['textStyleColor'] == null
          ? null
          : EditorColor.fromJson(j['textStyleColor'] as Map<String, dynamic>)
      ..foregroundColor = j['foregroundColor'] == null
          ? null
          : EditorColor.fromJson(j['foregroundColor'] as Map<String, dynamic>)
      ..selectedForegroundColor = j['selectedForegroundColor'] == null
          ? null
          : EditorColor.fromJson(
              j['selectedForegroundColor'] as Map<String, dynamic>,
            )
      ..disabledColor = j['disabledColor'] == null
          ? null
          : EditorColor.fromJson(j['disabledColor'] as Map<String, dynamic>)
      ..focusColor = j['focusColor'] == null
          ? null
          : EditorColor.fromJson(j['focusColor'] as Map<String, dynamic>)
      ..errorColor = j['errorColor'] == null
          ? null
          : EditorColor.fromJson(j['errorColor'] as Map<String, dynamic>)
      ..rowBackground = j['rowBackground'] == null
          ? null
          : EditorColor.fromJson(j['rowBackground'] as Map<String, dynamic>)
      ..selectedBackground = j['selectedBackground'] == null
          ? null
          : EditorColor.fromJson(
              j['selectedBackground'] as Map<String, dynamic>,
            )
      ..hoverBackground = j['hoverBackground'] == null
          ? null
          : EditorColor.fromJson(j['hoverBackground'] as Map<String, dynamic>)
      ..pressedBackground = j['pressedBackground'] == null
          ? null
          : EditorColor.fromJson(j['pressedBackground'] as Map<String, dynamic>)
      ..titleStyleColor = j['titleStyleColor'] == null
          ? null
          : EditorColor.fromJson(j['titleStyleColor'] as Map<String, dynamic>)
      ..descriptionStyleColor = j['descriptionStyleColor'] == null
          ? null
          : EditorColor.fromJson(
              j['descriptionStyleColor'] as Map<String, dynamic>,
            )
      ..iconColor = j['iconColor'] == null
          ? null
          : EditorColor.fromJson(j['iconColor'] as Map<String, dynamic>)
      ..labelStyleColor = j['labelStyleColor'] == null
          ? null
          : EditorColor.fromJson(j['labelStyleColor'] as Map<String, dynamic>)
      ..valueStyleColor = j['valueStyleColor'] == null
          ? null
          : EditorColor.fromJson(j['valueStyleColor'] as Map<String, dynamic>)
      ..borderColor = j['borderColor'] == null
          ? null
          : EditorColor.fromJson(j['borderColor'] as Map<String, dynamic>)
      ..labelBackground = j['labelBackground'] == null
          ? null
          : EditorColor.fromJson(j['labelBackground'] as Map<String, dynamic>)
      ..valueBackground = j['valueBackground'] == null
          ? null
          : EditorColor.fromJson(j['valueBackground'] as Map<String, dynamic>)
      ..timeStyleColor = j['timeStyleColor'] == null
          ? null
          : EditorColor.fromJson(j['timeStyleColor'] as Map<String, dynamic>)
      ..contentStyleColor = j['contentStyleColor'] == null
          ? null
          : EditorColor.fromJson(j['contentStyleColor'] as Map<String, dynamic>)
      ..nodeForeground = j['nodeForeground'] == null
          ? null
          : EditorColor.fromJson(j['nodeForeground'] as Map<String, dynamic>)
      ..lineColor = j['lineColor'] == null
          ? null
          : EditorColor.fromJson(j['lineColor'] as Map<String, dynamic>)
      ..nodeFill = j['nodeFill'] == null
          ? null
          : EditorColor.fromJson(j['nodeFill'] as Map<String, dynamic>)
      ..backgroundColor = j['backgroundColor'] == null
          ? null
          : EditorColor.fromJson(j['backgroundColor'] as Map<String, dynamic>)
      ..ringColor = j['ringColor'] == null
          ? null
          : EditorColor.fromJson(j['ringColor'] as Map<String, dynamic>)
      ..subtitleStyleColor = j['subtitleStyleColor'] == null
          ? null
          : EditorColor.fromJson(
              j['subtitleStyleColor'] as Map<String, dynamic>,
            )
      ..subtitleColor = j['subtitleColor'] == null
          ? null
          : EditorColor.fromJson(j['subtitleColor'] as Map<String, dynamic>)
      ..trailingColor = j['trailingColor'] == null
          ? null
          : EditorColor.fromJson(j['trailingColor'] as Map<String, dynamic>)
      ..overlayColor = j['overlayColor'] == null
          ? null
          : EditorColor.fromJson(j['overlayColor'] as Map<String, dynamic>)
      ..actionPlacement = j['actionPlacement'] as String?
      ..titleAlign = j['titleAlign'] as String?
      ..labelAlign = j['labelAlign'] as String?
      ..valueAlign = j['valueAlign'] as String?
      ..curve = j['curve'] as String?;
  }

  Duration? get animationDuration =>
      duration == null ? null : Duration(milliseconds: duration!.round());
  Curve? get animationCurve => editorControlCurve(curve);
}
