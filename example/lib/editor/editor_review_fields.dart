import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'editor_theme_document.dart';
import 'editor_basic_control_fields.dart';
import 'editor_dimension_limits.dart';

/// Explicit editor overrides shared by feedback and navigation workspaces.
/// Dimensions are stored per device, visual values per appearance.
class EditorReviewFields {
  double? dotRadius, dotBorderWidth;
  double? expandIconSize;
  double? collapsedIconSize;
  double? collapsedRowGap;
  EditorColor? expandIconColor;
  EditorColor? dotBorderColor;
  String? materialKind;
  double? materialBlurX, materialBlurY;
  double? surfaceRadius;
  double? borderWidth;
  double? collapsedHeight;
  double? mediumExpandedHeight;
  double? expandedHeight;
  double? titleHorizontalPadding;
  double? titleTextStyleSize;
  double? titleTextStyleWeight;
  double? expandedTitleTextStyleSize;
  double? expandedTitleTextStyleWeight;
  double? width;
  double? paddingLeft;
  double? paddingTop;
  double? paddingRight;
  double? paddingBottom;
  double? spacing;
  double? groupSpacing;
  double? titleStyleSize;
  double? titleStyleWeight;
  double? groupStyleSize;
  double? groupStyleWeight;
  double? countStyleSize;
  double? countStyleWeight;
  double? duration;
  double? radius;
  double? iconSize;
  double? unreadSize;
  double? closeIconSize;
  double? closeButtonSize;
  double? titleSpacing;
  double? actionSpacing;
  double? actionRunSpacing;
  double? contentStyleSize;
  double? contentStyleWeight;
  double? timeStyleSize;
  double? timeStyleWeight;
  double? hoverOpacity;
  double? focusOpacity;
  double? pressedOpacity;
  double? disabledOpacity;
  double? maxContentWidth;
  double? textStyleSize;
  double? textStyleWeight;
  double? showDelay;
  double? minimumVisibleDuration;
  double? maxWidth;
  double? landscapeMaxWidth;
  double? dragHandleRadius;
  double? dragHandlePaddingLeft;
  double? dragHandlePaddingTop;
  double? dragHandlePaddingRight;
  double? dragHandlePaddingBottom;
  double? insetPaddingLeft;
  double? insetPaddingTop;
  double? insetPaddingRight;
  double? insetPaddingBottom;
  double? illustrationSize;
  double? contentSpacing;
  double? descriptionStyleSize;
  double? descriptionStyleWeight;
  double? lineHeight;
  double? lineWidth;
  double? circleSize;
  double? blockWidth;
  double? blockHeight;
  double? shimmerWidth;
  double? shimmerAngle;
  double? pulseMinOpacity;
  double? transitionDuration;
  double? collapsedWidth;
  double? itemHeight;
  double? itemSpacing;
  double? rowGap;
  double? indent;
  double? sectionSpacing;
  double? horizontalPadding;
  double? popupWidth;
  double? itemRadius;
  double? groupTitleStyleSize;
  double? groupTitleStyleWeight;
  double? itemTextStyleSize;
  double? itemTextStyleWeight;
  double? descriptionTextStyleSize;
  double? descriptionTextStyleWeight;
  double? height;
  double? segmentedRadius;
  double? separatedRadius;
  double? underlineThickness;
  double? nodeSize;
  double? connectorThickness;
  double? interactionRadius;
  double? indexStyleSize;
  double? indexStyleWeight;
  double? minWidth;
  double? runSpacing;
  double? ellipsisStyleSize;
  double? ellipsisStyleWeight;
  double? dotSize;
  double? selectedWidth;
  double? counterStyleSize;
  double? counterStyleWeight;
  double? itemHorizontalPadding;
  double? itemMaxWidth;
  double? separatorSize;
  double? separatorSpacing;
  double? iconSpacing;
  double? descriptionGap;
  EditorColor? borderColor;
  EditorColor? titleTextStyleColor;
  EditorColor? expandedTitleTextStyleColor;
  EditorColor? backgroundColor;
  EditorColor? foregroundColor;
  EditorColor? titleStyleColor;
  EditorColor? groupStyleColor;
  EditorColor? countStyleColor;
  EditorColor? contentStyleColor;
  EditorColor? timeStyleColor;
  EditorColor? background;
  EditorColor? iconColor;
  EditorColor? unreadColor;
  EditorColor? closeIconColor;
  EditorColor? overlayColor;
  EditorColor? textStyleColor;
  EditorColor? contentBackground;
  EditorColor? dragHandleColor;
  EditorColor? barrierColor;
  EditorColor? descriptionStyleColor;
  EditorColor? highlightColor;
  EditorColor? groupTitleStyleColor;
  EditorColor? itemTextStyleColor;
  EditorColor? descriptionTextStyleColor;
  EditorColor? selectedForegroundColor;
  EditorColor? selectedBackgroundColor;
  EditorColor? ancestorSelectedForegroundColor;
  EditorColor? ancestorSelectedBackgroundColor;
  EditorColor? disabledColor;
  EditorColor? indexStyleColor;
  EditorColor? nodeFill;
  EditorColor? connectorColor;
  EditorColor? ellipsisStyleColor;
  EditorColor? counterStyleColor;
  EditorColor? dotFill;
  EditorColor? selectedDotFill;
  EditorColor? focusColor;
  EditorColor? highlightBackgroundColor;
  EditorColor? disabledBackgroundColor;
  EditorColor? highlightForegroundColor;
  EditorColor? separatorColor;
  String? curve;
  String? effect;
  String? actionsAlignment;
  String? textAlign;
  final shadow = EditorComponentShadow();
  Map<String, Object?> toJson() => {
    if (expandIconSize != null) 'expandIconSize': expandIconSize,
    if (collapsedIconSize != null) 'collapsedIconSize': collapsedIconSize,
    if (collapsedRowGap != null) 'collapsedRowGap': collapsedRowGap,
    if (expandIconColor != null) 'expandIconColor': expandIconColor!.toJson(),
    if (dotRadius != null) 'dotRadius': dotRadius,
    if (dotBorderWidth != null) 'dotBorderWidth': dotBorderWidth,
    if (dotBorderColor != null) 'dotBorderColor': dotBorderColor!.toJson(),
    if (materialKind != null) 'materialKind': materialKind,
    if (materialBlurX != null) 'materialBlurX': materialBlurX,
    if (materialBlurY != null) 'materialBlurY': materialBlurY,
    if (surfaceRadius != null) 'surfaceRadius': surfaceRadius,
    if (borderWidth != null) 'borderWidth': borderWidth,
    if (collapsedHeight != null) 'collapsedHeight': collapsedHeight,
    if (mediumExpandedHeight != null)
      'mediumExpandedHeight': mediumExpandedHeight,
    if (expandedHeight != null) 'expandedHeight': expandedHeight,
    if (titleHorizontalPadding != null)
      'titleHorizontalPadding': titleHorizontalPadding,
    if (titleTextStyleSize != null) 'titleTextStyleSize': titleTextStyleSize,
    if (titleTextStyleWeight != null)
      'titleTextStyleWeight': titleTextStyleWeight,
    if (expandedTitleTextStyleSize != null)
      'expandedTitleTextStyleSize': expandedTitleTextStyleSize,
    if (expandedTitleTextStyleWeight != null)
      'expandedTitleTextStyleWeight': expandedTitleTextStyleWeight,
    if (width != null) 'width': width,
    if (paddingLeft != null) 'paddingLeft': paddingLeft,
    if (paddingTop != null) 'paddingTop': paddingTop,
    if (paddingRight != null) 'paddingRight': paddingRight,
    if (paddingBottom != null) 'paddingBottom': paddingBottom,
    if (spacing != null) 'spacing': spacing,
    if (groupSpacing != null) 'groupSpacing': groupSpacing,
    if (titleStyleSize != null) 'titleStyleSize': titleStyleSize,
    if (titleStyleWeight != null) 'titleStyleWeight': titleStyleWeight,
    if (groupStyleSize != null) 'groupStyleSize': groupStyleSize,
    if (groupStyleWeight != null) 'groupStyleWeight': groupStyleWeight,
    if (countStyleSize != null) 'countStyleSize': countStyleSize,
    if (countStyleWeight != null) 'countStyleWeight': countStyleWeight,
    if (duration != null) 'duration': duration,
    if (radius != null) 'radius': radius,
    if (iconSize != null) 'iconSize': iconSize,
    if (unreadSize != null) 'unreadSize': unreadSize,
    if (closeIconSize != null) 'closeIconSize': closeIconSize,
    if (closeButtonSize != null) 'closeButtonSize': closeButtonSize,
    if (titleSpacing != null) 'titleSpacing': titleSpacing,
    if (actionSpacing != null) 'actionSpacing': actionSpacing,
    if (actionRunSpacing != null) 'actionRunSpacing': actionRunSpacing,
    if (contentStyleSize != null) 'contentStyleSize': contentStyleSize,
    if (contentStyleWeight != null) 'contentStyleWeight': contentStyleWeight,
    if (timeStyleSize != null) 'timeStyleSize': timeStyleSize,
    if (timeStyleWeight != null) 'timeStyleWeight': timeStyleWeight,
    if (hoverOpacity != null) 'hoverOpacity': hoverOpacity,
    if (focusOpacity != null) 'focusOpacity': focusOpacity,
    if (pressedOpacity != null) 'pressedOpacity': pressedOpacity,
    if (disabledOpacity != null) 'disabledOpacity': disabledOpacity,
    if (maxContentWidth != null) 'maxContentWidth': maxContentWidth,
    if (textStyleSize != null) 'textStyleSize': textStyleSize,
    if (textStyleWeight != null) 'textStyleWeight': textStyleWeight,
    if (showDelay != null) 'showDelay': showDelay,
    if (minimumVisibleDuration != null)
      'minimumVisibleDuration': minimumVisibleDuration,
    if (maxWidth != null) 'maxWidth': maxWidth,
    if (landscapeMaxWidth != null) 'landscapeMaxWidth': landscapeMaxWidth,
    if (dragHandleRadius != null) 'dragHandleRadius': dragHandleRadius,
    if (dragHandlePaddingLeft != null)
      'dragHandlePaddingLeft': dragHandlePaddingLeft,
    if (dragHandlePaddingTop != null)
      'dragHandlePaddingTop': dragHandlePaddingTop,
    if (dragHandlePaddingRight != null)
      'dragHandlePaddingRight': dragHandlePaddingRight,
    if (dragHandlePaddingBottom != null)
      'dragHandlePaddingBottom': dragHandlePaddingBottom,
    if (insetPaddingLeft != null) 'insetPaddingLeft': insetPaddingLeft,
    if (insetPaddingTop != null) 'insetPaddingTop': insetPaddingTop,
    if (insetPaddingRight != null) 'insetPaddingRight': insetPaddingRight,
    if (insetPaddingBottom != null) 'insetPaddingBottom': insetPaddingBottom,
    if (illustrationSize != null) 'illustrationSize': illustrationSize,
    if (contentSpacing != null) 'contentSpacing': contentSpacing,
    if (descriptionStyleSize != null)
      'descriptionStyleSize': descriptionStyleSize,
    if (descriptionStyleWeight != null)
      'descriptionStyleWeight': descriptionStyleWeight,
    if (lineHeight != null) 'lineHeight': lineHeight,
    if (lineWidth != null) 'lineWidth': lineWidth,
    if (circleSize != null) 'circleSize': circleSize,
    if (blockWidth != null) 'blockWidth': blockWidth,
    if (blockHeight != null) 'blockHeight': blockHeight,
    if (shimmerWidth != null) 'shimmerWidth': shimmerWidth,
    if (shimmerAngle != null) 'shimmerAngle': shimmerAngle,
    if (pulseMinOpacity != null) 'pulseMinOpacity': pulseMinOpacity,
    if (transitionDuration != null) 'transitionDuration': transitionDuration,
    if (collapsedWidth != null) 'collapsedWidth': collapsedWidth,
    if (itemHeight != null) 'itemHeight': itemHeight,
    if (itemSpacing != null) 'itemSpacing': itemSpacing,
    if (rowGap != null) 'rowGap': rowGap,
    if (indent != null) 'indent': indent,
    if (sectionSpacing != null) 'sectionSpacing': sectionSpacing,
    if (horizontalPadding != null) 'horizontalPadding': horizontalPadding,
    if (popupWidth != null) 'popupWidth': popupWidth,
    if (itemRadius != null) 'itemRadius': itemRadius,
    if (groupTitleStyleSize != null) 'groupTitleStyleSize': groupTitleStyleSize,
    if (groupTitleStyleWeight != null)
      'groupTitleStyleWeight': groupTitleStyleWeight,
    if (itemTextStyleSize != null) 'itemTextStyleSize': itemTextStyleSize,
    if (itemTextStyleWeight != null) 'itemTextStyleWeight': itemTextStyleWeight,
    if (descriptionTextStyleSize != null)
      'descriptionTextStyleSize': descriptionTextStyleSize,
    if (descriptionTextStyleWeight != null)
      'descriptionTextStyleWeight': descriptionTextStyleWeight,
    if (height != null) 'height': height,
    if (segmentedRadius != null) 'segmentedRadius': segmentedRadius,
    if (separatedRadius != null) 'separatedRadius': separatedRadius,
    if (underlineThickness != null) 'underlineThickness': underlineThickness,
    if (nodeSize != null) 'nodeSize': nodeSize,
    if (connectorThickness != null) 'connectorThickness': connectorThickness,
    if (interactionRadius != null) 'interactionRadius': interactionRadius,
    if (indexStyleSize != null) 'indexStyleSize': indexStyleSize,
    if (indexStyleWeight != null) 'indexStyleWeight': indexStyleWeight,
    if (minWidth != null) 'minWidth': minWidth,
    if (runSpacing != null) 'runSpacing': runSpacing,
    if (ellipsisStyleSize != null) 'ellipsisStyleSize': ellipsisStyleSize,
    if (ellipsisStyleWeight != null) 'ellipsisStyleWeight': ellipsisStyleWeight,
    if (dotSize != null) 'dotSize': dotSize,
    if (selectedWidth != null) 'selectedWidth': selectedWidth,
    if (counterStyleSize != null) 'counterStyleSize': counterStyleSize,
    if (counterStyleWeight != null) 'counterStyleWeight': counterStyleWeight,
    if (itemHorizontalPadding != null)
      'itemHorizontalPadding': itemHorizontalPadding,
    if (itemMaxWidth != null) 'itemMaxWidth': itemMaxWidth,
    if (separatorSize != null) 'separatorSize': separatorSize,
    if (separatorSpacing != null) 'separatorSpacing': separatorSpacing,
    if (iconSpacing != null) 'iconSpacing': iconSpacing,
    if (descriptionGap != null) 'descriptionGap': descriptionGap,
    if (borderColor != null) 'borderColor': borderColor!.toJson(),
    if (titleTextStyleColor != null)
      'titleTextStyleColor': titleTextStyleColor!.toJson(),
    if (expandedTitleTextStyleColor != null)
      'expandedTitleTextStyleColor': expandedTitleTextStyleColor!.toJson(),
    if (backgroundColor != null) 'backgroundColor': backgroundColor!.toJson(),
    if (foregroundColor != null) 'foregroundColor': foregroundColor!.toJson(),
    if (titleStyleColor != null) 'titleStyleColor': titleStyleColor!.toJson(),
    if (groupStyleColor != null) 'groupStyleColor': groupStyleColor!.toJson(),
    if (countStyleColor != null) 'countStyleColor': countStyleColor!.toJson(),
    if (contentStyleColor != null)
      'contentStyleColor': contentStyleColor!.toJson(),
    if (timeStyleColor != null) 'timeStyleColor': timeStyleColor!.toJson(),
    if (background != null) 'background': background!.toJson(),
    if (iconColor != null) 'iconColor': iconColor!.toJson(),
    if (unreadColor != null) 'unreadColor': unreadColor!.toJson(),
    if (closeIconColor != null) 'closeIconColor': closeIconColor!.toJson(),
    if (overlayColor != null) 'overlayColor': overlayColor!.toJson(),
    if (textStyleColor != null) 'textStyleColor': textStyleColor!.toJson(),
    if (contentBackground != null)
      'contentBackground': contentBackground!.toJson(),
    if (dragHandleColor != null) 'dragHandleColor': dragHandleColor!.toJson(),
    if (barrierColor != null) 'barrierColor': barrierColor!.toJson(),
    if (descriptionStyleColor != null)
      'descriptionStyleColor': descriptionStyleColor!.toJson(),
    if (highlightColor != null) 'highlightColor': highlightColor!.toJson(),
    if (groupTitleStyleColor != null)
      'groupTitleStyleColor': groupTitleStyleColor!.toJson(),
    if (itemTextStyleColor != null)
      'itemTextStyleColor': itemTextStyleColor!.toJson(),
    if (descriptionTextStyleColor != null)
      'descriptionTextStyleColor': descriptionTextStyleColor!.toJson(),
    if (selectedForegroundColor != null)
      'selectedForegroundColor': selectedForegroundColor!.toJson(),
    if (selectedBackgroundColor != null)
      'selectedBackgroundColor': selectedBackgroundColor!.toJson(),
    if (ancestorSelectedForegroundColor != null)
      'ancestorSelectedForegroundColor': ancestorSelectedForegroundColor!
          .toJson(),
    if (ancestorSelectedBackgroundColor != null)
      'ancestorSelectedBackgroundColor': ancestorSelectedBackgroundColor!
          .toJson(),
    if (disabledColor != null) 'disabledColor': disabledColor!.toJson(),
    if (indexStyleColor != null) 'indexStyleColor': indexStyleColor!.toJson(),
    if (nodeFill != null) 'nodeFill': nodeFill!.toJson(),
    if (connectorColor != null) 'connectorColor': connectorColor!.toJson(),
    if (ellipsisStyleColor != null)
      'ellipsisStyleColor': ellipsisStyleColor!.toJson(),
    if (counterStyleColor != null)
      'counterStyleColor': counterStyleColor!.toJson(),
    if (dotFill != null) 'dotFill': dotFill!.toJson(),
    if (selectedDotFill != null) 'selectedDotFill': selectedDotFill!.toJson(),
    if (focusColor != null) 'focusColor': focusColor!.toJson(),
    if (highlightBackgroundColor != null)
      'highlightBackgroundColor': highlightBackgroundColor!.toJson(),
    if (disabledBackgroundColor != null)
      'disabledBackgroundColor': disabledBackgroundColor!.toJson(),
    if (highlightForegroundColor != null)
      'highlightForegroundColor': highlightForegroundColor!.toJson(),
    if (separatorColor != null) 'separatorColor': separatorColor!.toJson(),
    if (curve != null) 'curve': curve,
    if (effect != null) 'effect': effect,
    if (actionsAlignment != null) 'actionsAlignment': actionsAlignment,
    if (textAlign != null) 'textAlign': textAlign,
    if (shadow.shadows != null)
      'shadows': shadow.shadows!.map((s) => s.toJson()).toList(),
  };
  static EditorReviewFields fromJson(Map<String, dynamic> j) {
    const keys = {
      'dotRadius',
      'expandIconSize',
      'collapsedIconSize',
      'collapsedRowGap',
      'expandIconColor',
      'dotBorderWidth',
      'dotBorderColor',
      'materialKind',
      'materialBlurX',
      'materialBlurY',
      'surfaceRadius',
      'borderWidth',
      'collapsedHeight',
      'mediumExpandedHeight',
      'expandedHeight',
      'titleHorizontalPadding',
      'titleTextStyleSize',
      'titleTextStyleWeight',
      'expandedTitleTextStyleSize',
      'expandedTitleTextStyleWeight',
      'width',
      'paddingLeft',
      'paddingTop',
      'paddingRight',
      'paddingBottom',
      'spacing',
      'groupSpacing',
      'titleStyleSize',
      'titleStyleWeight',
      'groupStyleSize',
      'groupStyleWeight',
      'countStyleSize',
      'countStyleWeight',
      'duration',
      'radius',
      'iconSize',
      'unreadSize',
      'closeIconSize',
      'closeButtonSize',
      'titleSpacing',
      'actionSpacing',
      'actionRunSpacing',
      'contentStyleSize',
      'contentStyleWeight',
      'timeStyleSize',
      'timeStyleWeight',
      'hoverOpacity',
      'focusOpacity',
      'pressedOpacity',
      'disabledOpacity',
      'maxContentWidth',
      'textStyleSize',
      'textStyleWeight',
      'showDelay',
      'minimumVisibleDuration',
      'maxWidth',
      'landscapeMaxWidth',
      'dragHandleRadius',
      'dragHandlePaddingLeft',
      'dragHandlePaddingTop',
      'dragHandlePaddingRight',
      'dragHandlePaddingBottom',
      'insetPaddingLeft',
      'insetPaddingTop',
      'insetPaddingRight',
      'insetPaddingBottom',
      'illustrationSize',
      'contentSpacing',
      'descriptionStyleSize',
      'descriptionStyleWeight',
      'lineHeight',
      'lineWidth',
      'circleSize',
      'blockWidth',
      'blockHeight',
      'shimmerWidth',
      'shimmerAngle',
      'pulseMinOpacity',
      'transitionDuration',
      'collapsedWidth',
      'itemHeight',
      'itemSpacing',
      'rowGap',
      'indent',
      'sectionSpacing',
      'horizontalPadding',
      'popupWidth',
      'itemRadius',
      'groupTitleStyleSize',
      'groupTitleStyleWeight',
      'itemTextStyleSize',
      'itemTextStyleWeight',
      'descriptionTextStyleSize',
      'descriptionTextStyleWeight',
      'height',
      'segmentedRadius',
      'separatedRadius',
      'underlineThickness',
      'nodeSize',
      'connectorThickness',
      'interactionRadius',
      'indexStyleSize',
      'indexStyleWeight',
      'minWidth',
      'runSpacing',
      'ellipsisStyleSize',
      'ellipsisStyleWeight',
      'dotSize',
      'selectedWidth',
      'counterStyleSize',
      'counterStyleWeight',
      'itemHorizontalPadding',
      'itemMaxWidth',
      'separatorSize',
      'separatorSpacing',
      'iconSpacing',
      'descriptionGap',
      'borderColor',
      'titleTextStyleColor',
      'expandedTitleTextStyleColor',
      'backgroundColor',
      'foregroundColor',
      'titleStyleColor',
      'groupStyleColor',
      'countStyleColor',
      'contentStyleColor',
      'timeStyleColor',
      'background',
      'iconColor',
      'unreadColor',
      'closeIconColor',
      'overlayColor',
      'textStyleColor',
      'contentBackground',
      'dragHandleColor',
      'barrierColor',
      'descriptionStyleColor',
      'highlightColor',
      'groupTitleStyleColor',
      'itemTextStyleColor',
      'descriptionTextStyleColor',
      'selectedForegroundColor',
      'selectedBackgroundColor',
      'ancestorSelectedForegroundColor',
      'ancestorSelectedBackgroundColor',
      'disabledColor',
      'indexStyleColor',
      'nodeFill',
      'connectorColor',
      'ellipsisStyleColor',
      'counterStyleColor',
      'dotFill',
      'selectedDotFill',
      'focusColor',
      'highlightBackgroundColor',
      'disabledBackgroundColor',
      'highlightForegroundColor',
      'separatorColor',
      'curve',
      'effect',
      'actionsAlignment',
      'textAlign',
      'shadows',
    };
    if (j.keys.any((k) => !keys.contains(k))) {
      throw const FormatException('未知反馈或导航设置');
    }
    for (final entry in {
      'materialKind': HyperSurfaceMaterialKind.values
          .map((x) => x.name)
          .toSet(),
      'curve': {'linear', 'easeInOut', 'fastOutSlowIn'},
      'effect': {'shimmer', 'pulse', 'none'},
      'actionsAlignment': WrapAlignment.values.map((x) => x.name).toSet(),
      'textAlign': TextAlign.values.map((x) => x.name).toSet(),
    }.entries) {
      final value = j[entry.key];
      if (value != null && !entry.value.contains(value)) {
        throw FormatException('无效设置：${entry.key}');
      }
    }
    final result = EditorReviewFields()
      ..expandIconSize = number(j['expandIconSize'], min: 0)
      ..collapsedIconSize = number(j['collapsedIconSize'], min: 0)
      ..collapsedRowGap = number(j['collapsedRowGap'], min: 0)
      ..expandIconColor = j['expandIconColor'] == null
          ? null
          : EditorColor.fromJson(j['expandIconColor'] as Map<String, dynamic>)
      ..dotRadius = number(j['dotRadius'], min: 0)
      ..dotBorderWidth = number(j['dotBorderWidth'], min: 0)
      ..dotBorderColor = j['dotBorderColor'] == null
          ? null
          : EditorColor.fromJson(j['dotBorderColor'] as Map<String, dynamic>)
      ..materialKind = j['materialKind'] as String?
      ..materialBlurX = number(j['materialBlurX'], min: 0)
      ..materialBlurY = number(j['materialBlurY'], min: 0)
      ..surfaceRadius = number(j['surfaceRadius'], min: 0)
      ..borderWidth = number(j['borderWidth'], min: 0)
      ..collapsedHeight = number(j['collapsedHeight'], min: 0)
      ..mediumExpandedHeight = number(j['mediumExpandedHeight'], min: 0)
      ..expandedHeight = number(j['expandedHeight'], min: 0)
      ..titleHorizontalPadding = number(j['titleHorizontalPadding'], min: 0)
      ..titleTextStyleSize = number(j['titleTextStyleSize'], min: 0)
      ..titleTextStyleWeight = number(j['titleTextStyleWeight'], min: 0)
      ..expandedTitleTextStyleSize = number(
        j['expandedTitleTextStyleSize'],
        min: 0,
      )
      ..expandedTitleTextStyleWeight = number(
        j['expandedTitleTextStyleWeight'],
        min: 0,
      )
      ..width = number(j['width'], min: 0)
      ..paddingLeft = number(j['paddingLeft'], min: 0)
      ..paddingTop = number(j['paddingTop'], min: 0)
      ..paddingRight = number(j['paddingRight'], min: 0)
      ..paddingBottom = number(j['paddingBottom'], min: 0)
      ..spacing = number(j['spacing'], min: 0)
      ..groupSpacing = number(j['groupSpacing'], min: 0)
      ..titleStyleSize = number(j['titleStyleSize'], min: 0)
      ..titleStyleWeight = number(j['titleStyleWeight'], min: 0)
      ..groupStyleSize = number(j['groupStyleSize'], min: 0)
      ..groupStyleWeight = number(j['groupStyleWeight'], min: 0)
      ..countStyleSize = number(j['countStyleSize'], min: 0)
      ..countStyleWeight = number(j['countStyleWeight'], min: 0)
      ..duration = number(j['duration'], min: 0)
      ..radius = number(j['radius'], min: 0)
      ..iconSize = number(j['iconSize'], min: 0)
      ..unreadSize = number(j['unreadSize'], min: 0)
      ..closeIconSize = number(j['closeIconSize'], min: 0)
      ..closeButtonSize = number(j['closeButtonSize'], min: 0)
      ..titleSpacing = number(j['titleSpacing'], min: 0)
      ..actionSpacing = number(j['actionSpacing'], min: 0)
      ..actionRunSpacing = number(j['actionRunSpacing'], min: 0)
      ..contentStyleSize = number(j['contentStyleSize'], min: 0)
      ..contentStyleWeight = number(j['contentStyleWeight'], min: 0)
      ..timeStyleSize = number(j['timeStyleSize'], min: 0)
      ..timeStyleWeight = number(j['timeStyleWeight'], min: 0)
      ..hoverOpacity = number(j['hoverOpacity'], min: 0, max: 1)
      ..focusOpacity = number(j['focusOpacity'], min: 0, max: 1)
      ..pressedOpacity = number(j['pressedOpacity'], min: 0, max: 1)
      ..disabledOpacity = number(j['disabledOpacity'], min: 0, max: 1)
      ..maxContentWidth = number(j['maxContentWidth'], min: 0)
      ..textStyleSize = number(j['textStyleSize'], min: 0)
      ..textStyleWeight = number(j['textStyleWeight'], min: 0)
      ..showDelay = number(j['showDelay'], min: 0)
      ..minimumVisibleDuration = number(j['minimumVisibleDuration'], min: 0)
      ..maxWidth = number(j['maxWidth'], min: 0)
      ..landscapeMaxWidth = number(j['landscapeMaxWidth'], min: 0)
      ..dragHandleRadius = number(j['dragHandleRadius'], min: 0)
      ..dragHandlePaddingLeft = number(j['dragHandlePaddingLeft'], min: 0)
      ..dragHandlePaddingTop = number(j['dragHandlePaddingTop'], min: 0)
      ..dragHandlePaddingRight = number(j['dragHandlePaddingRight'], min: 0)
      ..dragHandlePaddingBottom = number(j['dragHandlePaddingBottom'], min: 0)
      ..insetPaddingLeft = number(j['insetPaddingLeft'], min: 0)
      ..insetPaddingTop = number(j['insetPaddingTop'], min: 0)
      ..insetPaddingRight = number(j['insetPaddingRight'], min: 0)
      ..insetPaddingBottom = number(j['insetPaddingBottom'], min: 0)
      ..illustrationSize = number(j['illustrationSize'], min: 0)
      ..contentSpacing = number(j['contentSpacing'], min: 0)
      ..descriptionStyleSize = number(j['descriptionStyleSize'], min: 0)
      ..descriptionStyleWeight = number(j['descriptionStyleWeight'], min: 0)
      ..lineHeight = number(j['lineHeight'], min: 0)
      ..lineWidth = number(j['lineWidth'], min: 0)
      ..circleSize = number(j['circleSize'], min: 0)
      ..blockWidth = number(j['blockWidth'], min: 0)
      ..blockHeight = number(j['blockHeight'], min: 0)
      ..shimmerWidth = number(j['shimmerWidth'], min: 0)
      ..shimmerAngle = number(j['shimmerAngle'], min: -360)
      ..pulseMinOpacity = number(j['pulseMinOpacity'], min: 0, max: 1)
      ..transitionDuration = number(j['transitionDuration'], min: 0)
      ..collapsedWidth = number(j['collapsedWidth'], min: 0)
      ..itemHeight = number(j['itemHeight'], min: 0)
      ..itemSpacing = number(j['itemSpacing'], min: 0)
      ..rowGap = number(j['rowGap'], min: 0)
      ..indent = number(j['indent'], min: 0)
      ..sectionSpacing = number(j['sectionSpacing'], min: 0)
      ..horizontalPadding = number(j['horizontalPadding'], min: 0)
      ..popupWidth = number(j['popupWidth'], min: 0)
      ..itemRadius = number(j['itemRadius'], min: 0)
      ..groupTitleStyleSize = number(j['groupTitleStyleSize'], min: 0)
      ..groupTitleStyleWeight = number(j['groupTitleStyleWeight'], min: 0)
      ..itemTextStyleSize = number(j['itemTextStyleSize'], min: 0)
      ..itemTextStyleWeight = number(j['itemTextStyleWeight'], min: 0)
      ..descriptionTextStyleSize = number(j['descriptionTextStyleSize'], min: 0)
      ..descriptionTextStyleWeight = number(
        j['descriptionTextStyleWeight'],
        min: 0,
      )
      ..height = number(j['height'], min: 0)
      ..segmentedRadius = number(j['segmentedRadius'], min: 0)
      ..separatedRadius = number(j['separatedRadius'], min: 0)
      ..underlineThickness = number(j['underlineThickness'], min: 0)
      ..nodeSize = number(j['nodeSize'], min: 0)
      ..connectorThickness = number(j['connectorThickness'], min: 0)
      ..interactionRadius = number(j['interactionRadius'], min: 0)
      ..indexStyleSize = number(j['indexStyleSize'], min: 0)
      ..indexStyleWeight = number(j['indexStyleWeight'], min: 0)
      ..minWidth = number(j['minWidth'], min: 0)
      ..runSpacing = number(j['runSpacing'], min: 0)
      ..ellipsisStyleSize = number(j['ellipsisStyleSize'], min: 0)
      ..ellipsisStyleWeight = number(j['ellipsisStyleWeight'], min: 0)
      ..dotSize = number(j['dotSize'], min: 0)
      ..selectedWidth = number(j['selectedWidth'], min: 0)
      ..counterStyleSize = number(j['counterStyleSize'], min: 0)
      ..counterStyleWeight = number(j['counterStyleWeight'], min: 0)
      ..itemHorizontalPadding = number(j['itemHorizontalPadding'], min: 0)
      ..itemMaxWidth = number(j['itemMaxWidth'], min: 0)
      ..separatorSize = number(j['separatorSize'], min: 0)
      ..separatorSpacing = number(j['separatorSpacing'], min: 0)
      ..iconSpacing = number(j['iconSpacing'], min: 0)
      ..descriptionGap = number(j['descriptionGap'], min: 0)
      ..borderColor = j['borderColor'] == null
          ? null
          : EditorColor.fromJson(j['borderColor'] as Map<String, dynamic>)
      ..titleTextStyleColor = j['titleTextStyleColor'] == null
          ? null
          : EditorColor.fromJson(
              j['titleTextStyleColor'] as Map<String, dynamic>,
            )
      ..expandedTitleTextStyleColor = j['expandedTitleTextStyleColor'] == null
          ? null
          : EditorColor.fromJson(
              j['expandedTitleTextStyleColor'] as Map<String, dynamic>,
            )
      ..backgroundColor = j['backgroundColor'] == null
          ? null
          : EditorColor.fromJson(j['backgroundColor'] as Map<String, dynamic>)
      ..foregroundColor = j['foregroundColor'] == null
          ? null
          : EditorColor.fromJson(j['foregroundColor'] as Map<String, dynamic>)
      ..titleStyleColor = j['titleStyleColor'] == null
          ? null
          : EditorColor.fromJson(j['titleStyleColor'] as Map<String, dynamic>)
      ..groupStyleColor = j['groupStyleColor'] == null
          ? null
          : EditorColor.fromJson(j['groupStyleColor'] as Map<String, dynamic>)
      ..countStyleColor = j['countStyleColor'] == null
          ? null
          : EditorColor.fromJson(j['countStyleColor'] as Map<String, dynamic>)
      ..contentStyleColor = j['contentStyleColor'] == null
          ? null
          : EditorColor.fromJson(j['contentStyleColor'] as Map<String, dynamic>)
      ..timeStyleColor = j['timeStyleColor'] == null
          ? null
          : EditorColor.fromJson(j['timeStyleColor'] as Map<String, dynamic>)
      ..background = j['background'] == null
          ? null
          : EditorColor.fromJson(j['background'] as Map<String, dynamic>)
      ..iconColor = j['iconColor'] == null
          ? null
          : EditorColor.fromJson(j['iconColor'] as Map<String, dynamic>)
      ..unreadColor = j['unreadColor'] == null
          ? null
          : EditorColor.fromJson(j['unreadColor'] as Map<String, dynamic>)
      ..closeIconColor = j['closeIconColor'] == null
          ? null
          : EditorColor.fromJson(j['closeIconColor'] as Map<String, dynamic>)
      ..overlayColor = j['overlayColor'] == null
          ? null
          : EditorColor.fromJson(j['overlayColor'] as Map<String, dynamic>)
      ..textStyleColor = j['textStyleColor'] == null
          ? null
          : EditorColor.fromJson(j['textStyleColor'] as Map<String, dynamic>)
      ..contentBackground = j['contentBackground'] == null
          ? null
          : EditorColor.fromJson(j['contentBackground'] as Map<String, dynamic>)
      ..dragHandleColor = j['dragHandleColor'] == null
          ? null
          : EditorColor.fromJson(j['dragHandleColor'] as Map<String, dynamic>)
      ..barrierColor = j['barrierColor'] == null
          ? null
          : EditorColor.fromJson(j['barrierColor'] as Map<String, dynamic>)
      ..descriptionStyleColor = j['descriptionStyleColor'] == null
          ? null
          : EditorColor.fromJson(
              j['descriptionStyleColor'] as Map<String, dynamic>,
            )
      ..highlightColor = j['highlightColor'] == null
          ? null
          : EditorColor.fromJson(j['highlightColor'] as Map<String, dynamic>)
      ..groupTitleStyleColor = j['groupTitleStyleColor'] == null
          ? null
          : EditorColor.fromJson(
              j['groupTitleStyleColor'] as Map<String, dynamic>,
            )
      ..itemTextStyleColor = j['itemTextStyleColor'] == null
          ? null
          : EditorColor.fromJson(
              j['itemTextStyleColor'] as Map<String, dynamic>,
            )
      ..descriptionTextStyleColor = j['descriptionTextStyleColor'] == null
          ? null
          : EditorColor.fromJson(
              j['descriptionTextStyleColor'] as Map<String, dynamic>,
            )
      ..selectedForegroundColor = j['selectedForegroundColor'] == null
          ? null
          : EditorColor.fromJson(
              j['selectedForegroundColor'] as Map<String, dynamic>,
            )
      ..selectedBackgroundColor = j['selectedBackgroundColor'] == null
          ? null
          : EditorColor.fromJson(
              j['selectedBackgroundColor'] as Map<String, dynamic>,
            )
      ..ancestorSelectedForegroundColor =
          j['ancestorSelectedForegroundColor'] == null
          ? null
          : EditorColor.fromJson(
              j['ancestorSelectedForegroundColor'] as Map<String, dynamic>,
            )
      ..ancestorSelectedBackgroundColor =
          j['ancestorSelectedBackgroundColor'] == null
          ? null
          : EditorColor.fromJson(
              j['ancestorSelectedBackgroundColor'] as Map<String, dynamic>,
            )
      ..disabledColor = j['disabledColor'] == null
          ? null
          : EditorColor.fromJson(j['disabledColor'] as Map<String, dynamic>)
      ..indexStyleColor = j['indexStyleColor'] == null
          ? null
          : EditorColor.fromJson(j['indexStyleColor'] as Map<String, dynamic>)
      ..nodeFill = j['nodeFill'] == null
          ? null
          : EditorColor.fromJson(j['nodeFill'] as Map<String, dynamic>)
      ..connectorColor = j['connectorColor'] == null
          ? null
          : EditorColor.fromJson(j['connectorColor'] as Map<String, dynamic>)
      ..ellipsisStyleColor = j['ellipsisStyleColor'] == null
          ? null
          : EditorColor.fromJson(
              j['ellipsisStyleColor'] as Map<String, dynamic>,
            )
      ..counterStyleColor = j['counterStyleColor'] == null
          ? null
          : EditorColor.fromJson(j['counterStyleColor'] as Map<String, dynamic>)
      ..dotFill = j['dotFill'] == null
          ? null
          : EditorColor.fromJson(j['dotFill'] as Map<String, dynamic>)
      ..selectedDotFill = j['selectedDotFill'] == null
          ? null
          : EditorColor.fromJson(j['selectedDotFill'] as Map<String, dynamic>)
      ..focusColor = j['focusColor'] == null
          ? null
          : EditorColor.fromJson(j['focusColor'] as Map<String, dynamic>)
      ..highlightBackgroundColor = j['highlightBackgroundColor'] == null
          ? null
          : EditorColor.fromJson(
              j['highlightBackgroundColor'] as Map<String, dynamic>,
            )
      ..disabledBackgroundColor = j['disabledBackgroundColor'] == null
          ? null
          : EditorColor.fromJson(
              j['disabledBackgroundColor'] as Map<String, dynamic>,
            )
      ..highlightForegroundColor = j['highlightForegroundColor'] == null
          ? null
          : EditorColor.fromJson(
              j['highlightForegroundColor'] as Map<String, dynamic>,
            )
      ..separatorColor = j['separatorColor'] == null
          ? null
          : EditorColor.fromJson(j['separatorColor'] as Map<String, dynamic>)
      ..curve = j['curve'] as String?
      ..effect = j['effect'] as String?
      ..actionsAlignment = j['actionsAlignment'] as String?
      ..textAlign = j['textAlign'] as String?;
    result.shadow.shadows = (j['shadows'] as List?)
        ?.map((v) => EditorShadow.fromJson(v as Map<String, dynamic>))
        .toList();
    return result;
  }
}

class EditorReviewCollection {
  EditorReviewFields tabBarUnderlineSelected = EditorReviewFields();
  EditorReviewFields tabBarUnderlineItem = EditorReviewFields();
  EditorReviewFields tabBarUnderline = EditorReviewFields();
  EditorReviewFields tabBarSeparatedSelected = EditorReviewFields();
  EditorReviewFields tabBarSeparatedItem = EditorReviewFields();
  EditorReviewFields tabBarSeparated = EditorReviewFields();
  EditorReviewFields tabBarSegmentedSelected = EditorReviewFields();
  EditorReviewFields tabBarSegmentedItem = EditorReviewFields();
  EditorReviewFields tabBarSegmented = EditorReviewFields();
  EditorReviewFields tabBarSelected = EditorReviewFields();
  EditorReviewFields tabBarItem = EditorReviewFields();
  EditorReviewFields breadcrumbDisabled = EditorReviewFields();
  EditorReviewFields breadcrumbHighlight = EditorReviewFields();
  EditorReviewFields topNavigationPanel = EditorReviewFields();
  EditorReviewFields topNavigationMenu = EditorReviewFields();
  EditorReviewFields sidebarPopup = EditorReviewFields();
  EditorReviewFields sidebarDisabled = EditorReviewFields();
  EditorReviewFields sidebarAncestor = EditorReviewFields();
  EditorReviewFields sidebarSelected = EditorReviewFields();
  EditorReviewFields sidebarItem = EditorReviewFields();
  EditorReviewFields topNavigationSelected = EditorReviewFields();
  EditorReviewFields topNavigationDefault = EditorReviewFields();
  EditorReviewFields paginationNavigation = EditorReviewFields();
  EditorReviewFields paginationSelected = EditorReviewFields();
  EditorReviewFields paginationDefault = EditorReviewFields();
  EditorReviewFields tooltip = EditorReviewFields();
  EditorReviewFields appBar = EditorReviewFields();
  EditorReviewFields drawer = EditorReviewFields();
  // Legacy editor documents are accepted, but this business-only override is no longer applied.
  EditorReviewFields notificationCenter = EditorReviewFields();
  EditorReviewFields notification = EditorReviewFields();
  EditorReviewFields notificationRead = EditorReviewFields();
  EditorReviewFields notificationUnread = EditorReviewFields();
  EditorReviewFields notificationHovered = EditorReviewFields();
  EditorReviewFields notificationFocused = EditorReviewFields();
  EditorReviewFields notificationPressed = EditorReviewFields();
  EditorReviewFields notificationDisabled = EditorReviewFields();
  EditorReviewFields loadingOverlay = EditorReviewFields();
  EditorReviewFields alert = EditorReviewFields();
  EditorReviewFields alertInfo = EditorReviewFields();
  EditorReviewFields alertSuccess = EditorReviewFields();
  EditorReviewFields alertWarning = EditorReviewFields();
  EditorReviewFields alertError = EditorReviewFields();
  EditorReviewFields banner = EditorReviewFields();
  EditorReviewFields bannerInfo = EditorReviewFields();
  EditorReviewFields bannerSuccess = EditorReviewFields();
  EditorReviewFields bannerWarning = EditorReviewFields();
  EditorReviewFields bannerError = EditorReviewFields();
  EditorReviewFields bottomSheet = EditorReviewFields();
  EditorReviewFields toast = EditorReviewFields();
  EditorReviewFields snackbar = EditorReviewFields();
  EditorReviewFields dialog = EditorReviewFields();
  EditorReviewFields emptyState = EditorReviewFields();
  EditorReviewFields skeleton = EditorReviewFields();
  EditorReviewFields sidebar = EditorReviewFields();
  EditorReviewFields tabBar = EditorReviewFields();
  EditorReviewFields stepIndicator = EditorReviewFields();
  EditorReviewFields stepIndicatorPending = EditorReviewFields();
  EditorReviewFields stepIndicatorCurrent = EditorReviewFields();
  EditorReviewFields stepIndicatorCompleted = EditorReviewFields();
  EditorReviewFields stepIndicatorError = EditorReviewFields();
  EditorReviewFields stepIndicatorDisabled = EditorReviewFields();
  EditorReviewFields stepperNavigation = EditorReviewFields();
  EditorReviewFields stepperNavigationPending = EditorReviewFields();
  EditorReviewFields stepperNavigationCurrent = EditorReviewFields();
  EditorReviewFields stepperNavigationCompleted = EditorReviewFields();
  EditorReviewFields stepperNavigationError = EditorReviewFields();
  EditorReviewFields stepperNavigationDisabled = EditorReviewFields();
  EditorReviewFields pagination = EditorReviewFields();
  EditorReviewFields pageIndicator = EditorReviewFields();
  EditorReviewFields breadcrumb = EditorReviewFields();
  EditorReviewFields topNavigation = EditorReviewFields();
  EditorReviewFields object(String name) => switch (name) {
    'appBar' => appBar,
    'drawer' => drawer,
    'notificationCenter' => notificationCenter,
    'notification' => notification,
    'notificationRead' => notificationRead,
    'notificationUnread' => notificationUnread,
    'notificationHovered' => notificationHovered,
    'notificationFocused' => notificationFocused,
    'notificationPressed' => notificationPressed,
    'notificationDisabled' => notificationDisabled,
    'loadingOverlay' => loadingOverlay,
    'alert' => alert,
    'alertInfo' => alertInfo,
    'alertSuccess' => alertSuccess,
    'alertWarning' => alertWarning,
    'alertError' => alertError,
    'banner' => banner,
    'bannerInfo' => bannerInfo,
    'bannerSuccess' => bannerSuccess,
    'bannerWarning' => bannerWarning,
    'bannerError' => bannerError,
    'bottomSheet' => bottomSheet,
    'toast' => toast,
    'snackbar' => snackbar,
    'dialog' => dialog,
    'emptyState' => emptyState,
    'skeleton' => skeleton,
    'sidebar' => sidebar,
    'tabBar' => tabBar,
    'stepIndicator' => stepIndicator,
    'stepIndicatorPending' => stepIndicatorPending,
    'stepIndicatorCurrent' => stepIndicatorCurrent,
    'stepIndicatorCompleted' => stepIndicatorCompleted,
    'stepIndicatorError' => stepIndicatorError,
    'stepIndicatorDisabled' => stepIndicatorDisabled,
    'stepperNavigation' => stepperNavigation,
    'stepperNavigationPending' => stepperNavigationPending,
    'stepperNavigationCurrent' => stepperNavigationCurrent,
    'stepperNavigationCompleted' => stepperNavigationCompleted,
    'stepperNavigationError' => stepperNavigationError,
    'stepperNavigationDisabled' => stepperNavigationDisabled,
    'pagination' => pagination,
    'pageIndicator' => pageIndicator,
    'breadcrumb' => breadcrumb,
    'tooltip' => tooltip,
    'paginationDefault' => paginationDefault,
    'paginationSelected' => paginationSelected,
    'paginationNavigation' => paginationNavigation,
    'topNavigationDefault' => topNavigationDefault,
    'topNavigationSelected' => topNavigationSelected,
    'sidebarItem' => sidebarItem,
    'sidebarSelected' => sidebarSelected,
    'sidebarAncestor' => sidebarAncestor,
    'sidebarDisabled' => sidebarDisabled,
    'sidebarPopup' => sidebarPopup,
    'topNavigationPanel' => topNavigationPanel,
    'topNavigationMenu' => topNavigationMenu,
    'breadcrumbHighlight' => breadcrumbHighlight,
    'breadcrumbDisabled' => breadcrumbDisabled,
    'tabBarItem' => tabBarItem,
    'tabBarSelected' => tabBarSelected,
    'tabBarSegmented' => tabBarSegmented,
    'tabBarSegmentedItem' => tabBarSegmentedItem,
    'tabBarSegmentedSelected' => tabBarSegmentedSelected,
    'tabBarSeparated' => tabBarSeparated,
    'tabBarSeparatedItem' => tabBarSeparatedItem,
    'tabBarSeparatedSelected' => tabBarSeparatedSelected,
    'tabBarUnderline' => tabBarUnderline,
    'tabBarUnderlineItem' => tabBarUnderlineItem,
    'tabBarUnderlineSelected' => tabBarUnderlineSelected,
    'topNavigation' => topNavigation,
    _ => throw StateError('Unknown review object: $name'),
  };
  void reset(String name) {
    switch (name) {
      case 'appBar':
        appBar = EditorReviewFields();
      case 'drawer':
        drawer = EditorReviewFields();
      case 'notificationCenter':
        notificationCenter = EditorReviewFields();
      case 'notification':
        notification = EditorReviewFields();
      case 'notificationRead':
        notificationRead = EditorReviewFields();
      case 'notificationUnread':
        notificationUnread = EditorReviewFields();
      case 'notificationHovered':
        notificationHovered = EditorReviewFields();
      case 'notificationFocused':
        notificationFocused = EditorReviewFields();
      case 'notificationPressed':
        notificationPressed = EditorReviewFields();
      case 'notificationDisabled':
        notificationDisabled = EditorReviewFields();
      case 'loadingOverlay':
        loadingOverlay = EditorReviewFields();
      case 'alert':
        alert = EditorReviewFields();
      case 'alertInfo':
        alertInfo = EditorReviewFields();
      case 'alertSuccess':
        alertSuccess = EditorReviewFields();
      case 'alertWarning':
        alertWarning = EditorReviewFields();
      case 'alertError':
        alertError = EditorReviewFields();
      case 'banner':
        banner = EditorReviewFields();
      case 'bannerInfo':
        bannerInfo = EditorReviewFields();
      case 'bannerSuccess':
        bannerSuccess = EditorReviewFields();
      case 'bannerWarning':
        bannerWarning = EditorReviewFields();
      case 'bannerError':
        bannerError = EditorReviewFields();
      case 'bottomSheet':
        bottomSheet = EditorReviewFields();
      case 'toast':
        toast = EditorReviewFields();
      case 'snackbar':
        snackbar = EditorReviewFields();
      case 'dialog':
        dialog = EditorReviewFields();
      case 'emptyState':
        emptyState = EditorReviewFields();
      case 'skeleton':
        skeleton = EditorReviewFields();
      case 'sidebar':
        sidebar = EditorReviewFields();
      case 'tabBar':
        tabBar = EditorReviewFields();
      case 'stepIndicator':
        stepIndicator = EditorReviewFields();
      case 'stepIndicatorPending':
        stepIndicatorPending = EditorReviewFields();
      case 'stepIndicatorCurrent':
        stepIndicatorCurrent = EditorReviewFields();
      case 'stepIndicatorCompleted':
        stepIndicatorCompleted = EditorReviewFields();
      case 'stepIndicatorError':
        stepIndicatorError = EditorReviewFields();
      case 'stepIndicatorDisabled':
        stepIndicatorDisabled = EditorReviewFields();
      case 'stepperNavigation':
        stepperNavigation = EditorReviewFields();
      case 'stepperNavigationPending':
        stepperNavigationPending = EditorReviewFields();
      case 'stepperNavigationCurrent':
        stepperNavigationCurrent = EditorReviewFields();
      case 'stepperNavigationCompleted':
        stepperNavigationCompleted = EditorReviewFields();
      case 'stepperNavigationError':
        stepperNavigationError = EditorReviewFields();
      case 'stepperNavigationDisabled':
        stepperNavigationDisabled = EditorReviewFields();
      case 'pagination':
        pagination = EditorReviewFields();
      case 'pageIndicator':
        pageIndicator = EditorReviewFields();
      case 'breadcrumb':
        breadcrumb = EditorReviewFields();
      case 'tooltip':
        tooltip = EditorReviewFields();
      case 'paginationDefault':
        paginationDefault = EditorReviewFields();
      case 'paginationSelected':
        paginationSelected = EditorReviewFields();
      case 'paginationNavigation':
        paginationNavigation = EditorReviewFields();
      case 'topNavigationDefault':
        topNavigationDefault = EditorReviewFields();
      case 'topNavigationSelected':
        topNavigationSelected = EditorReviewFields();
      case 'sidebarItem':
        sidebarItem = EditorReviewFields();
        break;
      case 'sidebarSelected':
        sidebarSelected = EditorReviewFields();
        break;
      case 'sidebarAncestor':
        sidebarAncestor = EditorReviewFields();
        break;
      case 'sidebarDisabled':
        sidebarDisabled = EditorReviewFields();
        break;
      case 'sidebarPopup':
        sidebarPopup = EditorReviewFields();
        break;
      case 'topNavigationMenu':
        topNavigationMenu = EditorReviewFields();
        break;
      case 'topNavigationPanel':
        topNavigationPanel = EditorReviewFields();
        break;
      case 'breadcrumbHighlight':
        breadcrumbHighlight = EditorReviewFields();
        break;
      case 'breadcrumbDisabled':
        breadcrumbDisabled = EditorReviewFields();
        break;
      case 'tabBarItem':
        tabBarItem = EditorReviewFields();
        break;
      case 'tabBarSelected':
        tabBarSelected = EditorReviewFields();
        break;
      case 'tabBarSegmented':
        tabBarSegmented = EditorReviewFields();
        break;
      case 'tabBarSegmentedItem':
        tabBarSegmentedItem = EditorReviewFields();
        break;
      case 'tabBarSegmentedSelected':
        tabBarSegmentedSelected = EditorReviewFields();
        break;
      case 'tabBarSeparated':
        tabBarSeparated = EditorReviewFields();
        break;
      case 'tabBarSeparatedItem':
        tabBarSeparatedItem = EditorReviewFields();
        break;
      case 'tabBarSeparatedSelected':
        tabBarSeparatedSelected = EditorReviewFields();
        break;
      case 'tabBarUnderline':
        tabBarUnderline = EditorReviewFields();
        break;
      case 'tabBarUnderlineItem':
        tabBarUnderlineItem = EditorReviewFields();
        break;
      case 'tabBarUnderlineSelected':
        tabBarUnderlineSelected = EditorReviewFields();
        break;
      case 'topNavigation':
        topNavigation = EditorReviewFields();
      default:
        throw StateError('Unknown review object: $name');
    }
  }

  Map<String, Object?> toJson() => {
    if (tabBarUnderlineSelected.toJson().isNotEmpty)
      'tabBarUnderlineSelected': tabBarUnderlineSelected.toJson(),
    if (tabBarUnderlineItem.toJson().isNotEmpty)
      'tabBarUnderlineItem': tabBarUnderlineItem.toJson(),
    if (tabBarUnderline.toJson().isNotEmpty)
      'tabBarUnderline': tabBarUnderline.toJson(),
    if (tabBarSeparatedSelected.toJson().isNotEmpty)
      'tabBarSeparatedSelected': tabBarSeparatedSelected.toJson(),
    if (tabBarSeparatedItem.toJson().isNotEmpty)
      'tabBarSeparatedItem': tabBarSeparatedItem.toJson(),
    if (tabBarSeparated.toJson().isNotEmpty)
      'tabBarSeparated': tabBarSeparated.toJson(),
    if (tabBarSegmentedSelected.toJson().isNotEmpty)
      'tabBarSegmentedSelected': tabBarSegmentedSelected.toJson(),
    if (tabBarSegmentedItem.toJson().isNotEmpty)
      'tabBarSegmentedItem': tabBarSegmentedItem.toJson(),
    if (tabBarSegmented.toJson().isNotEmpty)
      'tabBarSegmented': tabBarSegmented.toJson(),
    if (tabBarSelected.toJson().isNotEmpty)
      'tabBarSelected': tabBarSelected.toJson(),
    if (tabBarItem.toJson().isNotEmpty) 'tabBarItem': tabBarItem.toJson(),
    if (breadcrumbDisabled.toJson().isNotEmpty)
      'breadcrumbDisabled': breadcrumbDisabled.toJson(),
    if (breadcrumbHighlight.toJson().isNotEmpty)
      'breadcrumbHighlight': breadcrumbHighlight.toJson(),
    if (topNavigationMenu.toJson().isNotEmpty)
      'topNavigationMenu': topNavigationMenu.toJson(),
    if (topNavigationPanel.toJson().isNotEmpty)
      'topNavigationPanel': topNavigationPanel.toJson(),
    if (sidebarPopup.toJson().isNotEmpty) 'sidebarPopup': sidebarPopup.toJson(),
    if (sidebarDisabled.toJson().isNotEmpty)
      'sidebarDisabled': sidebarDisabled.toJson(),
    if (sidebarAncestor.toJson().isNotEmpty)
      'sidebarAncestor': sidebarAncestor.toJson(),
    if (sidebarSelected.toJson().isNotEmpty)
      'sidebarSelected': sidebarSelected.toJson(),
    if (sidebarItem.toJson().isNotEmpty) 'sidebarItem': sidebarItem.toJson(),
    if (topNavigationSelected.toJson().isNotEmpty)
      'topNavigationSelected': topNavigationSelected.toJson(),
    if (topNavigationDefault.toJson().isNotEmpty)
      'topNavigationDefault': topNavigationDefault.toJson(),
    if (paginationNavigation.toJson().isNotEmpty)
      'paginationNavigation': paginationNavigation.toJson(),
    if (paginationSelected.toJson().isNotEmpty)
      'paginationSelected': paginationSelected.toJson(),
    if (paginationDefault.toJson().isNotEmpty)
      'paginationDefault': paginationDefault.toJson(),
    if (tooltip.toJson().isNotEmpty) 'tooltip': tooltip.toJson(),
    if (appBar.toJson().isNotEmpty) 'appBar': appBar.toJson(),
    if (drawer.toJson().isNotEmpty) 'drawer': drawer.toJson(),
    if (notificationCenter.toJson().isNotEmpty)
      'notificationCenter': notificationCenter.toJson(),
    if (notification.toJson().isNotEmpty) 'notification': notification.toJson(),
    if (notificationRead.toJson().isNotEmpty)
      'notificationRead': notificationRead.toJson(),
    if (notificationUnread.toJson().isNotEmpty)
      'notificationUnread': notificationUnread.toJson(),
    if (notificationHovered.toJson().isNotEmpty)
      'notificationHovered': notificationHovered.toJson(),
    if (notificationFocused.toJson().isNotEmpty)
      'notificationFocused': notificationFocused.toJson(),
    if (notificationPressed.toJson().isNotEmpty)
      'notificationPressed': notificationPressed.toJson(),
    if (notificationDisabled.toJson().isNotEmpty)
      'notificationDisabled': notificationDisabled.toJson(),
    if (loadingOverlay.toJson().isNotEmpty)
      'loadingOverlay': loadingOverlay.toJson(),
    if (alert.toJson().isNotEmpty) 'alert': alert.toJson(),
    if (alertInfo.toJson().isNotEmpty) 'alertInfo': alertInfo.toJson(),
    if (alertSuccess.toJson().isNotEmpty) 'alertSuccess': alertSuccess.toJson(),
    if (alertWarning.toJson().isNotEmpty) 'alertWarning': alertWarning.toJson(),
    if (alertError.toJson().isNotEmpty) 'alertError': alertError.toJson(),
    if (banner.toJson().isNotEmpty) 'banner': banner.toJson(),
    if (bannerInfo.toJson().isNotEmpty) 'bannerInfo': bannerInfo.toJson(),
    if (bannerSuccess.toJson().isNotEmpty)
      'bannerSuccess': bannerSuccess.toJson(),
    if (bannerWarning.toJson().isNotEmpty)
      'bannerWarning': bannerWarning.toJson(),
    if (bannerError.toJson().isNotEmpty) 'bannerError': bannerError.toJson(),
    if (bottomSheet.toJson().isNotEmpty) 'bottomSheet': bottomSheet.toJson(),
    if (toast.toJson().isNotEmpty) 'toast': toast.toJson(),
    if (snackbar.toJson().isNotEmpty) 'snackbar': snackbar.toJson(),
    if (dialog.toJson().isNotEmpty) 'dialog': dialog.toJson(),
    if (emptyState.toJson().isNotEmpty) 'emptyState': emptyState.toJson(),
    if (skeleton.toJson().isNotEmpty) 'skeleton': skeleton.toJson(),
    if (sidebar.toJson().isNotEmpty) 'sidebar': sidebar.toJson(),
    if (tabBar.toJson().isNotEmpty) 'tabBar': tabBar.toJson(),
    if (stepIndicator.toJson().isNotEmpty)
      'stepIndicator': stepIndicator.toJson(),
    if (stepIndicatorPending.toJson().isNotEmpty)
      'stepIndicatorPending': stepIndicatorPending.toJson(),
    if (stepIndicatorCurrent.toJson().isNotEmpty)
      'stepIndicatorCurrent': stepIndicatorCurrent.toJson(),
    if (stepIndicatorCompleted.toJson().isNotEmpty)
      'stepIndicatorCompleted': stepIndicatorCompleted.toJson(),
    if (stepIndicatorError.toJson().isNotEmpty)
      'stepIndicatorError': stepIndicatorError.toJson(),
    if (stepIndicatorDisabled.toJson().isNotEmpty)
      'stepIndicatorDisabled': stepIndicatorDisabled.toJson(),
    if (stepperNavigation.toJson().isNotEmpty)
      'stepperNavigation': stepperNavigation.toJson(),
    if (stepperNavigationPending.toJson().isNotEmpty)
      'stepperNavigationPending': stepperNavigationPending.toJson(),
    if (stepperNavigationCurrent.toJson().isNotEmpty)
      'stepperNavigationCurrent': stepperNavigationCurrent.toJson(),
    if (stepperNavigationCompleted.toJson().isNotEmpty)
      'stepperNavigationCompleted': stepperNavigationCompleted.toJson(),
    if (stepperNavigationError.toJson().isNotEmpty)
      'stepperNavigationError': stepperNavigationError.toJson(),
    if (stepperNavigationDisabled.toJson().isNotEmpty)
      'stepperNavigationDisabled': stepperNavigationDisabled.toJson(),
    if (pagination.toJson().isNotEmpty) 'pagination': pagination.toJson(),
    if (pageIndicator.toJson().isNotEmpty)
      'pageIndicator': pageIndicator.toJson(),
    if (breadcrumb.toJson().isNotEmpty) 'breadcrumb': breadcrumb.toJson(),
    if (topNavigation.toJson().isNotEmpty)
      'topNavigation': topNavigation.toJson(),
  };
  static EditorReviewCollection fromJson(Map<String, dynamic> j) {
    const keys = {
      'tabBarUnderlineSelected',
      'tabBarUnderlineItem',
      'tabBarUnderline',
      'tabBarSeparatedSelected',
      'tabBarSeparatedItem',
      'tabBarSeparated',
      'tabBarSegmentedSelected',
      'tabBarSegmentedItem',
      'tabBarSegmented',
      'tabBarSelected',
      'tabBarItem',
      'breadcrumbDisabled',
      'breadcrumbHighlight',
      'topNavigationPanel',
      'topNavigationMenu',
      'sidebarPopup',
      'sidebarDisabled',
      'sidebarAncestor',
      'sidebarSelected',
      'sidebarItem',
      'topNavigationSelected',
      'topNavigationDefault',
      'paginationNavigation',
      'paginationSelected',
      'paginationDefault',
      'tooltip',
      'appBar',
      'drawer',
      'notificationCenter',
      'notification',
      'notificationRead',
      'notificationUnread',
      'notificationHovered',
      'notificationFocused',
      'notificationPressed',
      'notificationDisabled',
      'loadingOverlay',
      'alert',
      'alertInfo',
      'alertSuccess',
      'alertWarning',
      'alertError',
      'banner',
      'bannerInfo',
      'bannerSuccess',
      'bannerWarning',
      'bannerError',
      'bottomSheet',
      'toast',
      'snackbar',
      'dialog',
      'emptyState',
      'skeleton',
      'sidebar',
      'tabBar',
      'stepIndicator',
      'stepIndicatorPending',
      'stepIndicatorCurrent',
      'stepIndicatorCompleted',
      'stepIndicatorError',
      'stepIndicatorDisabled',
      'stepperNavigation',
      'stepperNavigationPending',
      'stepperNavigationCurrent',
      'stepperNavigationCompleted',
      'stepperNavigationError',
      'stepperNavigationDisabled',
      'pagination',
      'pageIndicator',
      'breadcrumb',
      'topNavigation',
    };
    if (j.keys.any((k) => !keys.contains(k))) {
      throw const FormatException('未知反馈或导航对象');
    }
    return EditorReviewCollection()
      ..tabBarUnderlineSelected = EditorReviewFields.fromJson(
        (j['tabBarUnderlineSelected'] as Map<String, dynamic>?) ?? {},
      )
      ..tabBarUnderlineItem = EditorReviewFields.fromJson(
        (j['tabBarUnderlineItem'] as Map<String, dynamic>?) ?? {},
      )
      ..tabBarUnderline = EditorReviewFields.fromJson(
        (j['tabBarUnderline'] as Map<String, dynamic>?) ?? {},
      )
      ..tabBarSeparatedSelected = EditorReviewFields.fromJson(
        (j['tabBarSeparatedSelected'] as Map<String, dynamic>?) ?? {},
      )
      ..tabBarSeparatedItem = EditorReviewFields.fromJson(
        (j['tabBarSeparatedItem'] as Map<String, dynamic>?) ?? {},
      )
      ..tabBarSeparated = EditorReviewFields.fromJson(
        (j['tabBarSeparated'] as Map<String, dynamic>?) ?? {},
      )
      ..tabBarSegmentedSelected = EditorReviewFields.fromJson(
        (j['tabBarSegmentedSelected'] as Map<String, dynamic>?) ?? {},
      )
      ..tabBarSegmentedItem = EditorReviewFields.fromJson(
        (j['tabBarSegmentedItem'] as Map<String, dynamic>?) ?? {},
      )
      ..tabBarSegmented = EditorReviewFields.fromJson(
        (j['tabBarSegmented'] as Map<String, dynamic>?) ?? {},
      )
      ..tabBarSelected = EditorReviewFields.fromJson(
        (j['tabBarSelected'] as Map<String, dynamic>?) ?? {},
      )
      ..tabBarItem = EditorReviewFields.fromJson(
        (j['tabBarItem'] as Map<String, dynamic>?) ?? {},
      )
      ..breadcrumbDisabled = EditorReviewFields.fromJson(
        (j['breadcrumbDisabled'] as Map<String, dynamic>?) ?? {},
      )
      ..breadcrumbHighlight = EditorReviewFields.fromJson(
        (j['breadcrumbHighlight'] as Map<String, dynamic>?) ?? {},
      )
      ..topNavigationMenu = EditorReviewFields.fromJson(
        (j['topNavigationMenu'] as Map<String, dynamic>?) ?? {},
      )
      ..topNavigationPanel = EditorReviewFields.fromJson(
        (j['topNavigationPanel'] as Map<String, dynamic>?) ?? {},
      )
      ..sidebarPopup = EditorReviewFields.fromJson(
        (j['sidebarPopup'] as Map<String, dynamic>?) ?? {},
      )
      ..sidebarDisabled = EditorReviewFields.fromJson(
        (j['sidebarDisabled'] as Map<String, dynamic>?) ?? {},
      )
      ..sidebarAncestor = EditorReviewFields.fromJson(
        (j['sidebarAncestor'] as Map<String, dynamic>?) ?? {},
      )
      ..sidebarSelected = EditorReviewFields.fromJson(
        (j['sidebarSelected'] as Map<String, dynamic>?) ?? {},
      )
      ..sidebarItem = EditorReviewFields.fromJson(
        (j['sidebarItem'] as Map<String, dynamic>?) ?? {},
      )
      ..topNavigationSelected = EditorReviewFields.fromJson(
        (j['topNavigationSelected'] as Map<String, dynamic>?) ?? {},
      )
      ..topNavigationDefault = EditorReviewFields.fromJson(
        (j['topNavigationDefault'] as Map<String, dynamic>?) ?? {},
      )
      ..paginationNavigation = EditorReviewFields.fromJson(
        (j['paginationNavigation'] as Map<String, dynamic>?) ?? {},
      )
      ..paginationSelected = EditorReviewFields.fromJson(
        (j['paginationSelected'] as Map<String, dynamic>?) ?? {},
      )
      ..paginationDefault = EditorReviewFields.fromJson(
        (j['paginationDefault'] as Map<String, dynamic>?) ?? {},
      )
      ..tooltip = EditorReviewFields.fromJson(
        (j['tooltip'] as Map<String, dynamic>?) ?? {},
      )
      ..appBar = EditorReviewFields.fromJson(
        (j['appBar'] as Map<String, dynamic>?) ?? {},
      )
      ..drawer = EditorReviewFields.fromJson(
        (j['drawer'] as Map<String, dynamic>?) ?? {},
      )
      ..notificationCenter = EditorReviewFields.fromJson(
        (j['notificationCenter'] as Map<String, dynamic>?) ?? {},
      )
      ..notification = EditorReviewFields.fromJson(
        (j['notification'] as Map<String, dynamic>?) ?? {},
      )
      ..notificationRead = EditorReviewFields.fromJson(
        (j['notificationRead'] as Map<String, dynamic>?) ?? {},
      )
      ..notificationUnread = EditorReviewFields.fromJson(
        (j['notificationUnread'] as Map<String, dynamic>?) ?? {},
      )
      ..notificationHovered = EditorReviewFields.fromJson(
        (j['notificationHovered'] as Map<String, dynamic>?) ?? {},
      )
      ..notificationFocused = EditorReviewFields.fromJson(
        (j['notificationFocused'] as Map<String, dynamic>?) ?? {},
      )
      ..notificationPressed = EditorReviewFields.fromJson(
        (j['notificationPressed'] as Map<String, dynamic>?) ?? {},
      )
      ..notificationDisabled = EditorReviewFields.fromJson(
        (j['notificationDisabled'] as Map<String, dynamic>?) ?? {},
      )
      ..loadingOverlay = EditorReviewFields.fromJson(
        (j['loadingOverlay'] as Map<String, dynamic>?) ?? {},
      )
      ..alert = EditorReviewFields.fromJson(
        (j['alert'] as Map<String, dynamic>?) ?? {},
      )
      ..alertInfo = EditorReviewFields.fromJson(
        (j['alertInfo'] as Map<String, dynamic>?) ?? {},
      )
      ..alertSuccess = EditorReviewFields.fromJson(
        (j['alertSuccess'] as Map<String, dynamic>?) ?? {},
      )
      ..alertWarning = EditorReviewFields.fromJson(
        (j['alertWarning'] as Map<String, dynamic>?) ?? {},
      )
      ..alertError = EditorReviewFields.fromJson(
        (j['alertError'] as Map<String, dynamic>?) ?? {},
      )
      ..banner = EditorReviewFields.fromJson(
        (j['banner'] as Map<String, dynamic>?) ?? {},
      )
      ..bannerInfo = EditorReviewFields.fromJson(
        (j['bannerInfo'] as Map<String, dynamic>?) ?? {},
      )
      ..bannerSuccess = EditorReviewFields.fromJson(
        (j['bannerSuccess'] as Map<String, dynamic>?) ?? {},
      )
      ..bannerWarning = EditorReviewFields.fromJson(
        (j['bannerWarning'] as Map<String, dynamic>?) ?? {},
      )
      ..bannerError = EditorReviewFields.fromJson(
        (j['bannerError'] as Map<String, dynamic>?) ?? {},
      )
      ..bottomSheet = EditorReviewFields.fromJson(
        (j['bottomSheet'] as Map<String, dynamic>?) ?? {},
      )
      ..toast = EditorReviewFields.fromJson(
        (j['toast'] as Map<String, dynamic>?) ?? {},
      )
      ..snackbar = EditorReviewFields.fromJson(
        (j['snackbar'] as Map<String, dynamic>?) ?? {},
      )
      ..dialog = EditorReviewFields.fromJson(
        (j['dialog'] as Map<String, dynamic>?) ?? {},
      )
      ..emptyState = EditorReviewFields.fromJson(
        (j['emptyState'] as Map<String, dynamic>?) ?? {},
      )
      ..skeleton = EditorReviewFields.fromJson(
        (j['skeleton'] as Map<String, dynamic>?) ?? {},
      )
      ..sidebar = EditorReviewFields.fromJson(
        (j['sidebar'] as Map<String, dynamic>?) ?? {},
      )
      ..tabBar = EditorReviewFields.fromJson(
        (j['tabBar'] as Map<String, dynamic>?) ?? {},
      )
      ..stepIndicator = EditorReviewFields.fromJson(
        (j['stepIndicator'] as Map<String, dynamic>?) ?? {},
      )
      ..stepIndicatorPending = EditorReviewFields.fromJson(
        (j['stepIndicatorPending'] as Map<String, dynamic>?) ?? {},
      )
      ..stepIndicatorCurrent = EditorReviewFields.fromJson(
        (j['stepIndicatorCurrent'] as Map<String, dynamic>?) ?? {},
      )
      ..stepIndicatorCompleted = EditorReviewFields.fromJson(
        (j['stepIndicatorCompleted'] as Map<String, dynamic>?) ?? {},
      )
      ..stepIndicatorError = EditorReviewFields.fromJson(
        (j['stepIndicatorError'] as Map<String, dynamic>?) ?? {},
      )
      ..stepIndicatorDisabled = EditorReviewFields.fromJson(
        (j['stepIndicatorDisabled'] as Map<String, dynamic>?) ?? {},
      )
      ..stepperNavigation = EditorReviewFields.fromJson(
        (j['stepperNavigation'] as Map<String, dynamic>?) ?? {},
      )
      ..stepperNavigationPending = EditorReviewFields.fromJson(
        (j['stepperNavigationPending'] as Map<String, dynamic>?) ?? {},
      )
      ..stepperNavigationCurrent = EditorReviewFields.fromJson(
        (j['stepperNavigationCurrent'] as Map<String, dynamic>?) ?? {},
      )
      ..stepperNavigationCompleted = EditorReviewFields.fromJson(
        (j['stepperNavigationCompleted'] as Map<String, dynamic>?) ?? {},
      )
      ..stepperNavigationError = EditorReviewFields.fromJson(
        (j['stepperNavigationError'] as Map<String, dynamic>?) ?? {},
      )
      ..stepperNavigationDisabled = EditorReviewFields.fromJson(
        (j['stepperNavigationDisabled'] as Map<String, dynamic>?) ?? {},
      )
      ..pagination = EditorReviewFields.fromJson(
        (j['pagination'] as Map<String, dynamic>?) ?? {},
      )
      ..pageIndicator = EditorReviewFields.fromJson(
        (j['pageIndicator'] as Map<String, dynamic>?) ?? {},
      )
      ..breadcrumb = EditorReviewFields.fromJson(
        (j['breadcrumb'] as Map<String, dynamic>?) ?? {},
      )
      ..topNavigation = EditorReviewFields.fromJson(
        (j['topNavigation'] as Map<String, dynamic>?) ?? {},
      );
  }
}

TextStyle? _reviewText(
  double? size,
  double? weight,
  EditorColor? color,
  HyperColorScheme colors,
) => size == null && weight == null && color == null
    ? null
    : TextStyle(
        fontSize: size,
        fontWeight: weight == null
            ? null
            : FontWeight.values[((weight / 100).round() - 1).clamp(0, 8)],
        color: color?.resolve(colors),
      );
EdgeInsetsGeometry? _reviewInsets(
  double? left,
  double? top,
  double? right,
  double? bottom,
  EdgeInsetsGeometry base,
) {
  if (left == null && top == null && right == null && bottom == null) {
    return null;
  }
  final b = base.resolve(TextDirection.ltr);
  return EdgeInsets.fromLTRB(
    left ?? b.left,
    top ?? b.top,
    right ?? b.right,
    bottom ?? b.bottom,
  );
}

HyperThemeData applyEditorReviews(
  HyperThemeData theme,
  EditorThemeDocument document,
  EditorMode mode,
  HyperDeviceType device,
) {
  final colors = theme.colors;
  HyperSizeScheme sizes(HyperDeviceType type) {
    final s = theme.sizes.resolve(type);
    final d = document.device(type).reviews;
    return s.copyWith(
      appBar: s.appBar.copyWith(
        collapsedHeight: d.appBar.collapsedHeight,
        mediumExpandedHeight: d.appBar.mediumExpandedHeight,
        expandedHeight: d.appBar.expandedHeight,
        titleHorizontalPadding: d.appBar.titleHorizontalPadding,
      ),
      drawer: s.drawer.copyWith(width: d.drawer.width, radius: d.drawer.radius),

      notification: s.notification.copyWith(
        radius: d.notification.radius,
        padding: _reviewInsets(
          d.notification.paddingLeft,
          d.notification.paddingTop,
          d.notification.paddingRight,
          d.notification.paddingBottom,
          s.notification.padding,
        ),
        iconSize: d.notification.iconSize,
        unreadSize: d.notification.unreadSize,
        closeIconSize: d.notification.closeIconSize,
        closeButtonSize: d.notification.closeButtonSize,
        spacing: d.notification.spacing,
        titleSpacing: d.notification.titleSpacing,
        actionSpacing: d.notification.actionSpacing,
        actionRunSpacing: d.notification.actionRunSpacing,
      ),
      loadingOverlay: s.loadingOverlay.copyWith(
        radius: d.loadingOverlay.radius,
        padding: _reviewInsets(
          d.loadingOverlay.paddingLeft,
          d.loadingOverlay.paddingTop,
          d.loadingOverlay.paddingRight,
          d.loadingOverlay.paddingBottom,
          s.loadingOverlay.padding,
        ),
        maxContentWidth: d.loadingOverlay.maxContentWidth,
        spacing: d.loadingOverlay.spacing,
      ),
      alert: s.alert.copyWith(
        banner: s.alert.banner.copyWith(
          radius: d.banner.radius,
          padding: _reviewInsets(
            d.banner.paddingLeft,
            d.banner.paddingTop,
            d.banner.paddingRight,
            d.banner.paddingBottom,
            s.alert.banner.padding,
          ),
          iconSize: d.banner.iconSize,
          closeIconSize: d.banner.closeIconSize,
          closeButtonSize: d.banner.closeButtonSize,
          spacing: d.banner.spacing,
          titleSpacing: d.banner.titleSpacing,
          actionSpacing: d.banner.actionSpacing,
          actionRunSpacing: d.banner.actionRunSpacing,
        ),
        radius: d.alert.radius,
        padding: _reviewInsets(
          d.alert.paddingLeft,
          d.alert.paddingTop,
          d.alert.paddingRight,
          d.alert.paddingBottom,
          s.alert.padding,
        ),
        iconSize: d.alert.iconSize,
        closeIconSize: d.alert.closeIconSize,
        closeButtonSize: d.alert.closeButtonSize,
        spacing: d.alert.spacing,
        titleSpacing: d.alert.titleSpacing,
        actionSpacing: d.alert.actionSpacing,
        actionRunSpacing: d.alert.actionRunSpacing,
      ),

      bottomSheet: s.bottomSheet.copyWith(
        maxWidth: d.bottomSheet.maxWidth,
        landscapeMaxWidth: d.bottomSheet.landscapeMaxWidth,
        radius: d.bottomSheet.radius,
        titleSpacing: d.bottomSheet.titleSpacing,
        actionSpacing: d.bottomSheet.actionSpacing,
        actionRunSpacing: d.bottomSheet.actionRunSpacing,
        closeIconSize: d.bottomSheet.closeIconSize,
        dragHandleRadius: d.bottomSheet.dragHandleRadius,
        dragHandlePadding: _reviewInsets(
          d.bottomSheet.dragHandlePaddingLeft,
          d.bottomSheet.dragHandlePaddingTop,
          d.bottomSheet.dragHandlePaddingRight,
          d.bottomSheet.dragHandlePaddingBottom,
          s.bottomSheet.dragHandlePadding,
        ),
        padding: _reviewInsets(
          d.bottomSheet.paddingLeft,
          d.bottomSheet.paddingTop,
          d.bottomSheet.paddingRight,
          d.bottomSheet.paddingBottom,
          s.bottomSheet.padding,
        ),
      ),
      toast: s.toast.copyWith(
        maxWidth: d.toast.maxWidth,
        radius: d.toast.radius,
        padding: _reviewInsets(
          d.toast.paddingLeft,
          d.toast.paddingTop,
          d.toast.paddingRight,
          d.toast.paddingBottom,
          s.toast.padding,
        ),
        iconSize: d.toast.iconSize,
        spacing: d.toast.spacing,
      ),
      snackbar: s.snackbar.copyWith(
        maxWidth: d.snackbar.maxWidth,
        radius: d.snackbar.radius,
        padding: _reviewInsets(
          d.snackbar.paddingLeft,
          d.snackbar.paddingTop,
          d.snackbar.paddingRight,
          d.snackbar.paddingBottom,
          s.snackbar.padding,
        ),
        iconSize: d.snackbar.iconSize,
        spacing: d.snackbar.spacing,
      ),
      dialog: s.dialog.copyWith(
        maxWidth: d.dialog.maxWidth,
        radius: d.dialog.radius,
        titleSpacing: d.dialog.titleSpacing,
        actionSpacing: d.dialog.actionSpacing,
        actionRunSpacing: d.dialog.actionRunSpacing,
        closeIconSize: d.dialog.closeIconSize,
        padding: _reviewInsets(
          d.dialog.paddingLeft,
          d.dialog.paddingTop,
          d.dialog.paddingRight,
          d.dialog.paddingBottom,
          s.dialog.padding,
        ),
        insetPadding: _reviewInsets(
          d.dialog.insetPaddingLeft,
          d.dialog.insetPaddingTop,
          d.dialog.insetPaddingRight,
          d.dialog.insetPaddingBottom,
          s.dialog.insetPadding,
        ),
      ),
      result: s.result.copyWith(
        empty: s.result.empty.copyWith(
          iconSize: d.emptyState.iconSize,
          illustrationSize: d.emptyState.illustrationSize,
          maxWidth: d.emptyState.maxWidth,
          contentSpacing: d.emptyState.contentSpacing,
          titleSpacing: d.emptyState.titleSpacing,
          actionSpacing: d.emptyState.actionSpacing,
          actionRunSpacing: d.emptyState.actionRunSpacing,
          padding: _reviewInsets(
            d.emptyState.paddingLeft,
            d.emptyState.paddingTop,
            d.emptyState.paddingRight,
            d.emptyState.paddingBottom,
            s.result.empty.padding,
          ),
        ),
      ),
      skeleton: s.skeleton.copyWith(
        lineHeight: d.skeleton.lineHeight,
        lineWidth: d.skeleton.lineWidth,
        circleSize: d.skeleton.circleSize,
        blockWidth: d.skeleton.blockWidth,
        blockHeight: d.skeleton.blockHeight,
        radius: d.skeleton.radius,
      ),
      sidebar: s.sidebar.copyWith(
        width: d.sidebar.width,
        collapsedWidth: d.sidebar.collapsedWidth,
        itemHeight: d.sidebar.itemHeight,
        iconSize: d.sidebar.iconSize,
        expandIconSize: d.sidebar.expandIconSize,
        collapsedIconSize: d.sidebar.collapsedIconSize,
        collapsedRowGap: d.sidebar.collapsedRowGap,
        itemSpacing: d.sidebar.itemSpacing,
        rowGap: d.sidebar.rowGap,
        indent: d.sidebar.indent,
        sectionSpacing: d.sidebar.sectionSpacing,
        horizontalPadding: d.sidebar.horizontalPadding,
        popupWidth: d.sidebar.popupWidth,
        itemRadius: d.sidebar.itemRadius,
      ),
      tabBar: s.tabBar.copyWith(
        padding: _reviewInsets(
          d.tabBar.paddingLeft,
          d.tabBar.paddingTop,
          d.tabBar.paddingRight,
          d.tabBar.paddingBottom,
          s.tabBar.padding,
        ),
        height: d.tabBar.height,
        segmentedRadius: d.tabBar.segmentedRadius,
        separatedRadius: d.tabBar.separatedRadius,
        itemSpacing: d.tabBar.itemSpacing,
        underlineThickness: d.tabBar.underlineThickness,
      ),
      stepIndicator: s.stepIndicator.copyWith(
        navigation: s.stepIndicator.navigation.copyWith(
          nodeSize: d.stepperNavigation.nodeSize,
          iconSize: d.stepperNavigation.iconSize,
          connectorThickness: d.stepperNavigation.connectorThickness,
          spacing: d.stepperNavigation.spacing,
          titleSpacing: d.stepperNavigation.titleSpacing,
          itemSpacing: d.stepperNavigation.itemSpacing,
          interactionRadius: d.stepperNavigation.interactionRadius,
        ),
        nodeSize: d.stepIndicator.nodeSize,
        iconSize: d.stepIndicator.iconSize,
        connectorThickness: d.stepIndicator.connectorThickness,
        spacing: d.stepIndicator.spacing,
        titleSpacing: d.stepIndicator.titleSpacing,
        itemSpacing: d.stepIndicator.itemSpacing,
        interactionRadius: d.stepIndicator.interactionRadius,
      ),

      pagination: s.pagination.copyWith(
        height: d.pagination.height,
        minWidth: d.pagination.minWidth,
        radius: d.pagination.radius,
        padding: _reviewInsets(
          d.pagination.paddingLeft,
          d.pagination.paddingTop,
          d.pagination.paddingRight,
          d.pagination.paddingBottom,
          s.pagination.padding,
        ),
        iconSize: d.pagination.iconSize,
        spacing: d.pagination.spacing,
        runSpacing: d.pagination.runSpacing,
      ),
      pageIndicator: s.pageIndicator.copyWith(
        dotSize: d.pageIndicator.dotSize,
        selectedWidth: d.pageIndicator.selectedWidth,
        spacing: d.pageIndicator.spacing,
        padding: _reviewInsets(
          d.pageIndicator.paddingLeft,
          d.pageIndicator.paddingTop,
          d.pageIndicator.paddingRight,
          d.pageIndicator.paddingBottom,
          s.pageIndicator.padding,
        ),
      ),
      breadcrumb: s.breadcrumb.copyWith(
        itemHeight: d.breadcrumb.itemHeight,
        itemHorizontalPadding: d.breadcrumb.itemHorizontalPadding,
        itemMaxWidth: d.breadcrumb.itemMaxWidth,
        separatorSize: d.breadcrumb.separatorSize,
        separatorSpacing: d.breadcrumb.separatorSpacing,
      ),
      topNavigation: s.topNavigation.copyWith(
        height: d.topNavigation.height,
        radius: d.topNavigation.radius,
        padding: _reviewInsets(
          d.topNavigation.paddingLeft,
          d.topNavigation.paddingTop,
          d.topNavigation.paddingRight,
          d.topNavigation.paddingBottom,
          s.topNavigation.padding,
        ),
        iconSize: d.topNavigation.iconSize,
        iconSpacing: d.topNavigation.iconSpacing,
        itemSpacing: d.topNavigation.itemSpacing,
        descriptionGap: d.topNavigation.descriptionGap,
      ),
    );
  }

  final d = document.device(device).reviews;

  HyperCardStyle? surface(
    EditorReviewFields v,
    EditorReviewFields m, {
    Color? fallback,
    bool widthOnly = false,
  }) {
    if (v.background == null &&
        v.backgroundColor == null &&
        v.materialKind == null &&
        v.borderWidth == null &&
        v.borderColor == null &&
        v.shadow.shadows == null &&
        m.surfaceRadius == null) {
      return null;
    }
    final fill = v.background ?? v.backgroundColor;
    return HyperCardStyle(
      background: fill != null
          ? HyperFill.color(fill.resolve(colors))
          : v.materialKind != null
          ? HyperFill.color(fallback ?? colors.surface)
          : null,
      material: resolveEditorReviewMaterial(v, theme),
      border:
          (widthOnly
              ? v.borderWidth == null
              : v.borderWidth == null && v.borderColor == null)
          ? null
          : Border.all(
              width: v.borderWidth ?? 1,
              color: v.borderColor?.resolve(colors) ?? colors.outline,
            ),
      boxShadow: v.shadow.shadows?.map((s) => s.resolve(colors)).toList(),
      borderRadius: m.surfaceRadius == null
          ? null
          : BorderRadius.circular(m.surfaceRadius!),
    );
  }

  HyperTabBarStyle tabs(String name) {
    final v = mode.reviews.object(name),
        m = d.object(name),
        item = mode.reviews.object('${name}Item'),
        selected = mode.reviews.object('${name}Selected');
    return HyperTabBarStyle(
      trackStyle: surface(v, m, fallback: colors.surfaceMuted),
      itemStyle: surface(
        item,
        d.object('${name}Item'),
        fallback: colors.surfaceMuted,
      ),
      selectedItemStyle: surface(selected, d.object('${name}Selected')),
      foregroundColor: (item.foregroundColor ?? item.textStyleColor)?.resolve(
        colors,
      ),
      selectedForegroundColor:
          (selected.foregroundColor ?? selected.textStyleColor)?.resolve(
            colors,
          ),
      textStyle: _reviewText(
        d.tabBar.textStyleSize,
        item.textStyleWeight,
        null,
        colors,
      ),
      selectedTextStyle: _reviewText(
        null,
        selected.textStyleWeight,
        null,
        colors,
      ),
      dividerColor: v.separatorColor?.resolve(colors),
      indicatorColor: v.foregroundColor?.resolve(colors),
    );
  }

  HyperAppBarStyle appBar(EditorReviewFields v) {
    final m = d.appBar;
    return HyperAppBarStyle(
      surfaceStyle: surface(v, d.appBar, fallback: colors.background),
      material: resolveEditorReviewMaterial(v, theme),
      centerTitle: v.textAlign == null ? null : v.textAlign == 'center',
      titleTextStyle: _reviewText(
        m.titleTextStyleSize,
        v.titleTextStyleWeight,
        v.titleTextStyleColor,
        colors,
      ),
      expandedTitleTextStyle: _reviewText(
        m.expandedTitleTextStyleSize,
        v.expandedTitleTextStyleWeight,
        v.expandedTitleTextStyleColor,
        colors,
      ),
      backgroundColor: v.backgroundColor?.resolve(colors),
      foregroundColor: v.foregroundColor?.resolve(colors),
    );
  }

  HyperDrawerStyle drawer(EditorReviewFields v) {
    return HyperDrawerStyle(
      surfaceStyle: surface(v, d.drawer, fallback: colors.surface),
      backgroundColor: v.backgroundColor?.resolve(colors),
    );
  }

  HyperNotificationStyle notification(EditorReviewFields v) {
    final m = d.notification;
    return HyperNotificationStyle(
      material: resolveEditorReviewMaterial(v, theme),
      actionsAlignment: v.actionsAlignment == null
          ? null
          : WrapAlignment.values.byName(v.actionsAlignment!),
      titleStyle: _reviewText(
        m.titleStyleSize,
        v.titleStyleWeight,
        v.titleStyleColor,
        colors,
      ),
      contentStyle: _reviewText(
        m.contentStyleSize,
        v.contentStyleWeight,
        v.contentStyleColor,
        colors,
      ),
      timeStyle: _reviewText(
        m.timeStyleSize,
        v.timeStyleWeight,
        v.timeStyleColor,
        colors,
      ),
      background: v.background == null
          ? null
          : HyperFill.color(v.background!.resolve(colors)),
      border: v.borderWidth == null && v.borderColor == null
          ? null
          : Border.all(
              width: v.borderWidth ?? 1,
              color: v.borderColor?.resolve(colors) ?? colors.outline,
            ),
      boxShadow: v.shadow.shadows?.map((s) => s.resolve(colors)).toList(),
      iconColor: v.iconColor?.resolve(colors),
      unreadColor: v.unreadColor?.resolve(colors),
      closeIconColor: v.closeIconColor?.resolve(colors),
      overlayColor: v.overlayColor?.resolve(colors),
      hoverOpacity: v.hoverOpacity,
      focusOpacity: v.focusOpacity,
      pressedOpacity: v.pressedOpacity,
      disabledOpacity: v.disabledOpacity,
      duration: v.duration == null
          ? null
          : Duration(milliseconds: v.duration!.round()),
      curve: editorControlCurve(v.curve),
    );
  }

  HyperLoadingOverlayStyle loadingOverlay(EditorReviewFields v) {
    final m = d.loadingOverlay;
    return HyperLoadingOverlayStyle(
      material: resolveEditorReviewMaterial(v, theme),
      textStyle: _reviewText(
        m.textStyleSize,
        v.textStyleWeight,
        v.textStyleColor,
        colors,
      ),
      background: v.background == null
          ? null
          : HyperFill.color(v.background!.resolve(colors)),
      contentBackground: v.contentBackground == null
          ? null
          : HyperFill.color(v.contentBackground!.resolve(colors)),
      contentBorder: v.borderWidth == null && v.borderColor == null
          ? null
          : Border.all(
              width: v.borderWidth ?? 1,
              color: v.borderColor?.resolve(colors) ?? colors.outline,
            ),
      boxShadow: v.shadow.shadows?.map((s) => s.resolve(colors)).toList(),
      showDelay: v.showDelay == null
          ? null
          : Duration(milliseconds: v.showDelay!.round()),
      minimumVisibleDuration: v.minimumVisibleDuration == null
          ? null
          : Duration(milliseconds: v.minimumVisibleDuration!.round()),
      duration: v.duration == null
          ? null
          : Duration(milliseconds: v.duration!.round()),
      curve: editorControlCurve(v.curve),
    );
  }

  HyperNoticeStyle alert(EditorReviewFields v) {
    final m = d.alert;
    return HyperNoticeStyle(
      material: resolveEditorReviewMaterial(v, theme),
      actionsAlignment: v.actionsAlignment == null
          ? null
          : WrapAlignment.values.byName(v.actionsAlignment!),
      titleStyle: _reviewText(
        m.titleStyleSize,
        v.titleStyleWeight,
        v.titleStyleColor,
        colors,
      ),
      contentStyle: _reviewText(
        m.contentStyleSize,
        v.contentStyleWeight,
        v.contentStyleColor,
        colors,
      ),
      background: v.background == null
          ? null
          : HyperFill.color(v.background!.resolve(colors)),
      border: v.borderWidth == null && v.borderColor == null
          ? null
          : Border.all(
              width: v.borderWidth ?? 1,
              color: v.borderColor?.resolve(colors) ?? colors.outline,
            ),
      boxShadow: v.shadow.shadows?.map((s) => s.resolve(colors)).toList(),
      iconColor: v.iconColor?.resolve(colors),
      closeIconColor: v.closeIconColor?.resolve(colors),
      duration: v.duration == null
          ? null
          : Duration(milliseconds: v.duration!.round()),
      curve: editorControlCurve(v.curve),
    );
  }

  HyperNoticeStyle banner(EditorReviewFields v) {
    final m = d.banner;
    return HyperNoticeStyle(
      material: resolveEditorReviewMaterial(v, theme),
      titleStyle: _reviewText(
        m.titleStyleSize,
        v.titleStyleWeight,
        v.titleStyleColor,
        colors,
      ),
      contentStyle: _reviewText(
        m.contentStyleSize,
        v.contentStyleWeight,
        v.contentStyleColor,
        colors,
      ),
      background: v.background == null
          ? null
          : HyperFill.color(v.background!.resolve(colors)),
      border: v.borderWidth == null && v.borderColor == null
          ? null
          : Border.all(
              width: v.borderWidth ?? 1,
              color: v.borderColor?.resolve(colors) ?? colors.outline,
            ),
      boxShadow: v.shadow.shadows?.map((s) => s.resolve(colors)).toList(),
      iconColor: v.iconColor?.resolve(colors),
      closeIconColor: v.closeIconColor?.resolve(colors),
      duration: v.duration == null
          ? null
          : Duration(milliseconds: v.duration!.round()),
      curve: editorControlCurve(v.curve),
    );
  }

  HyperBottomSheetStyle bottomSheet(EditorReviewFields v) {
    final m = d.bottomSheet;
    return HyperBottomSheetStyle(
      material: resolveEditorReviewMaterial(v, theme),
      actionsAlignment: v.actionsAlignment == null
          ? null
          : WrapAlignment.values.byName(v.actionsAlignment!),
      titleStyle: _reviewText(
        m.titleStyleSize,
        v.titleStyleWeight,
        v.titleStyleColor,
        colors,
      ),
      contentStyle: _reviewText(
        m.contentStyleSize,
        v.contentStyleWeight,
        v.contentStyleColor,
        colors,
      ),
      background: v.background == null
          ? null
          : HyperFill.color(v.background!.resolve(colors)),
      border: v.borderWidth == null && v.borderColor == null
          ? null
          : Border.all(
              width: v.borderWidth ?? 1,
              color: v.borderColor?.resolve(colors) ?? colors.outline,
            ),
      boxShadow: v.shadow.shadows?.map((s) => s.resolve(colors)).toList(),
      closeIconColor: v.closeIconColor?.resolve(colors),
      dragHandleColor: v.dragHandleColor?.resolve(colors),
      barrierColor: v.barrierColor?.resolve(colors),
    );
  }

  HyperMessageStyle toast(EditorReviewFields v) {
    final m = d.toast;
    return HyperMessageStyle(
      material: resolveEditorReviewMaterial(v, theme),
      textStyle: _reviewText(
        m.textStyleSize,
        v.textStyleWeight,
        v.textStyleColor,
        colors,
      ),
      background: v.background == null
          ? null
          : HyperFill.color(v.background!.resolve(colors)),
      border: v.borderWidth == null && v.borderColor == null
          ? null
          : Border.all(
              width: v.borderWidth ?? 1,
              color: v.borderColor?.resolve(colors) ?? colors.outline,
            ),
      boxShadow: v.shadow.shadows?.map((s) => s.resolve(colors)).toList(),
      iconColor: v.iconColor?.resolve(colors),
    );
  }

  HyperMessageStyle snackbar(EditorReviewFields v) {
    final m = d.snackbar;
    return HyperMessageStyle(
      material: resolveEditorReviewMaterial(v, theme),
      textStyle: _reviewText(
        m.textStyleSize,
        v.textStyleWeight,
        v.textStyleColor,
        colors,
      ),
      background: v.background == null
          ? null
          : HyperFill.color(v.background!.resolve(colors)),
      border: v.borderWidth == null && v.borderColor == null
          ? null
          : Border.all(
              width: v.borderWidth ?? 1,
              color: v.borderColor?.resolve(colors) ?? colors.outline,
            ),
      boxShadow: v.shadow.shadows?.map((s) => s.resolve(colors)).toList(),
      iconColor: v.iconColor?.resolve(colors),
    );
  }

  HyperDialogStyle dialog(EditorReviewFields v) {
    final m = d.dialog;
    return HyperDialogStyle(
      material: resolveEditorReviewMaterial(v, theme),
      actionsAlignment: v.actionsAlignment == null
          ? null
          : WrapAlignment.values.byName(v.actionsAlignment!),
      titleStyle: _reviewText(
        m.titleStyleSize,
        v.titleStyleWeight,
        v.titleStyleColor,
        colors,
      ),
      contentStyle: _reviewText(
        m.contentStyleSize,
        v.contentStyleWeight,
        v.contentStyleColor,
        colors,
      ),
      background: v.background == null
          ? null
          : HyperFill.color(v.background!.resolve(colors)),
      border: v.borderWidth == null && v.borderColor == null
          ? null
          : Border.all(
              width: v.borderWidth ?? 1,
              color: v.borderColor?.resolve(colors) ?? colors.outline,
            ),
      boxShadow: v.shadow.shadows?.map((s) => s.resolve(colors)).toList(),
      closeIconColor: v.closeIconColor?.resolve(colors),
      barrierColor: v.barrierColor?.resolve(colors),
      duration: v.duration == null
          ? null
          : Duration(milliseconds: v.duration!.round()),
      curve: editorControlCurve(v.curve),
    );
  }

  HyperResultStyle emptyState(EditorReviewFields v) {
    final m = d.emptyState;
    final panel = surface(v, m, fallback: colors.surface);
    return HyperResultStyle(
      material: panel?.material,
      actionAlignment: v.actionsAlignment == null
          ? null
          : WrapAlignment.values.byName(v.actionsAlignment!),
      textAlign: v.textAlign == null
          ? null
          : TextAlign.values.byName(v.textAlign!),
      titleStyle: _reviewText(
        m.titleStyleSize,
        v.titleStyleWeight,
        v.titleStyleColor,
        colors,
      ),
      descriptionStyle: _reviewText(
        m.descriptionStyleSize,
        v.descriptionStyleWeight,
        v.descriptionStyleColor,
        colors,
      ),
      iconColor: v.iconColor?.resolve(colors),
      background: panel?.background,
      border: panel?.border,
      borderRadius: panel?.borderRadius,
      boxShadow: panel?.boxShadow,
      duration: v.duration == null
          ? null
          : Duration(milliseconds: v.duration!.round()),
      curve: editorControlCurve(v.curve),
    );
  }

  HyperSkeletonStyle skeleton(EditorReviewFields v) {
    return HyperSkeletonStyle(
      borderWidth: v.borderWidth,
      backgroundColor: v.backgroundColor?.resolve(colors),
      highlightColor: v.highlightColor?.resolve(colors),
      borderColor: v.borderColor?.resolve(colors),
      boxShadow: v.shadow.shadows?.map((s) => s.resolve(colors)).toList(),
      duration: v.duration == null
          ? null
          : Duration(milliseconds: v.duration!.round()),
      curve: editorControlCurve(v.curve),
      shimmerWidth: v.shimmerWidth,
      shimmerAngle: v.shimmerAngle,
      pulseMinOpacity: v.pulseMinOpacity,
      transitionDuration: v.transitionDuration == null
          ? null
          : Duration(milliseconds: v.transitionDuration!.round()),
      effect: v.effect == null
          ? null
          : HyperSkeletonEffect.values.byName(v.effect!),
    );
  }

  HyperSidebarStyle sidebar(EditorReviewFields v) {
    final m = d.sidebar;
    return HyperSidebarStyle(
      iconColor: mode.reviews.sidebarItem.iconColor?.resolve(colors),
      selectedIconColor: mode.reviews.sidebarSelected.iconColor?.resolve(
        colors,
      ),
      ancestorSelectedIconColor: mode.reviews.sidebarAncestor.iconColor
          ?.resolve(colors),
      disabledIconColor: mode.reviews.sidebarDisabled.iconColor?.resolve(
        colors,
      ),
      expandIconColor: mode.reviews.sidebarItem.expandIconColor?.resolve(
        colors,
      ),
      selectedExpandIconColor: mode.reviews.sidebarSelected.expandIconColor
          ?.resolve(colors),
      ancestorSelectedExpandIconColor: mode
          .reviews
          .sidebarAncestor
          .expandIconColor
          ?.resolve(colors),
      disabledExpandIconColor: mode.reviews.sidebarDisabled.expandIconColor
          ?.resolve(colors),
      surfaceStyle: surface(v, d.sidebar, widthOnly: true),
      itemSurfaceStyle: surface(mode.reviews.sidebarItem, d.sidebarItem),
      selectedItemSurfaceStyle: surface(
        mode.reviews.sidebarSelected,
        d.sidebarSelected,
        fallback: colors.primary.withValues(alpha: .08),
      ),
      ancestorItemSurfaceStyle: surface(
        mode.reviews.sidebarAncestor,
        d.sidebarAncestor,
        fallback: colors.primary.withValues(alpha: .05),
      ),
      disabledItemSurfaceStyle: surface(
        mode.reviews.sidebarDisabled,
        d.sidebarDisabled,
      ),
      popupCardStyle: surface(mode.reviews.sidebarPopup, d.sidebarPopup),

      groupTitleStyle: _reviewText(
        m.groupTitleStyleSize,
        v.groupTitleStyleWeight,
        v.groupTitleStyleColor,
        colors,
      ),
      itemTextStyle: _reviewText(
        m.itemTextStyleSize,
        v.itemTextStyleWeight,
        v.itemTextStyleColor,
        colors,
      ),
      descriptionTextStyle: _reviewText(
        m.descriptionTextStyleSize,
        v.descriptionTextStyleWeight,
        v.descriptionTextStyleColor,
        colors,
      ),
      backgroundColor: v.backgroundColor?.resolve(colors),
      borderColor: v.borderColor?.resolve(colors),
      foregroundColor:
          (mode.reviews.sidebarItem.foregroundColor ??
                  v.foregroundColor ??
                  v.itemTextStyleColor)
              ?.resolve(colors),
      selectedForegroundColor:
          (mode.reviews.sidebarSelected.foregroundColor ??
                  v.selectedForegroundColor)
              ?.resolve(colors),
      selectedBackgroundColor: v.selectedBackgroundColor?.resolve(colors),
      ancestorSelectedForegroundColor:
          (mode.reviews.sidebarAncestor.foregroundColor ??
                  v.ancestorSelectedForegroundColor)
              ?.resolve(colors),
      ancestorSelectedBackgroundColor: v.ancestorSelectedBackgroundColor
          ?.resolve(colors),
      disabledColor:
          (mode.reviews.sidebarDisabled.foregroundColor ?? v.disabledColor)
              ?.resolve(colors),
    );
  }

  HyperStepStyle stepIndicator(EditorReviewFields v) {
    final m = d.stepIndicator;
    return HyperStepStyle(
      boxShadow: v.shadow.shadows?.map((s) => s.resolve(colors)).toList(),
      nodeBorder: v.borderWidth == null && v.borderColor == null
          ? null
          : BorderSide(
              width: v.borderWidth ?? 1,
              color: v.borderColor?.resolve(colors) ?? colors.outline,
            ),
      nodeBorderRadius: m.surfaceRadius == null
          ? null
          : BorderRadius.circular(m.surfaceRadius!),
      material: resolveEditorReviewMaterial(v, theme),
      titleStyle: _reviewText(
        m.titleStyleSize,
        v.titleStyleWeight,
        v.titleStyleColor,
        colors,
      ),
      descriptionStyle: _reviewText(
        m.descriptionStyleSize,
        v.descriptionStyleWeight,
        v.descriptionStyleColor,
        colors,
      ),
      indexStyle: _reviewText(
        m.indexStyleSize,
        v.indexStyleWeight,
        v.indexStyleColor,
        colors,
      ),
      nodeFill: v.nodeFill == null
          ? null
          : HyperFill.color(v.nodeFill!.resolve(colors)),
      foregroundColor: v.foregroundColor?.resolve(colors),
      connectorColor: v.connectorColor?.resolve(colors),
      overlayColor: v.overlayColor?.resolve(colors),
      hoverOpacity: v.hoverOpacity,
      focusOpacity: v.focusOpacity,
      pressedOpacity: v.pressedOpacity,
      duration: v.duration == null
          ? null
          : Duration(milliseconds: v.duration!.round()),
      curve: editorControlCurve(v.curve),
    );
  }

  HyperStepStyle stepperNavigation(EditorReviewFields v) {
    final m = d.stepperNavigation;
    return HyperStepStyle(
      boxShadow: v.shadow.shadows?.map((s) => s.resolve(colors)).toList(),
      material: resolveEditorReviewMaterial(v, theme),
      titleStyle: _reviewText(
        m.titleStyleSize,
        v.titleStyleWeight,
        v.titleStyleColor,
        colors,
      ),
      descriptionStyle: _reviewText(
        m.descriptionStyleSize,
        v.descriptionStyleWeight,
        v.descriptionStyleColor,
        colors,
      ),
      indexStyle: _reviewText(
        m.indexStyleSize,
        v.indexStyleWeight,
        v.indexStyleColor,
        colors,
      ),
      nodeFill: v.nodeFill == null
          ? null
          : HyperFill.color(v.nodeFill!.resolve(colors)),
      foregroundColor: v.foregroundColor?.resolve(colors),
      connectorColor: v.connectorColor?.resolve(colors),
      overlayColor: v.overlayColor?.resolve(colors),
      hoverOpacity: v.hoverOpacity,
      focusOpacity: v.focusOpacity,
      pressedOpacity: v.pressedOpacity,
      duration: v.duration == null
          ? null
          : Duration(milliseconds: v.duration!.round()),
      curve: editorControlCurve(v.curve),
    );
  }

  HyperButtonStyle button(EditorReviewFields m, EditorReviewFields v) =>
      HyperButtonStyle(
        material: resolveEditorReviewMaterial(v, theme),
        textStyle: _reviewText(
          m.textStyleSize,
          v.textStyleWeight,
          v.textStyleColor,
          colors,
        ),
        foregroundColor: (v.foregroundColor ?? v.textStyleColor)?.resolve(
          colors,
        ),
        background: v.backgroundColor == null
            ? null
            : HyperFill.color(v.backgroundColor!.resolve(colors)),
        borderRadius: m.surfaceRadius == null
            ? null
            : BorderRadius.circular(m.surfaceRadius!),
        boxShadow: v.shadow.shadows?.map((s) => s.resolve(colors)).toList(),
        border: v.borderWidth == null && v.borderColor == null
            ? null
            : BorderSide(
                width: v.borderWidth ?? 1,
                color: v.borderColor?.resolve(colors) ?? colors.outline,
              ),
      );
  HyperPaginationStyle pagination(EditorReviewFields v) {
    final m = d.pagination;
    return HyperPaginationStyle(
      buttonStyle: button(d.paginationDefault, mode.reviews.paginationDefault),
      selectedStyle: button(
        d.paginationSelected,
        mode.reviews.paginationSelected,
      ),
      navigationStyle: button(
        d.paginationNavigation,
        mode.reviews.paginationNavigation,
      ),
      ellipsisStyle: _reviewText(
        m.ellipsisStyleSize,
        v.ellipsisStyleWeight,
        v.ellipsisStyleColor,
        colors,
      ),
    );
  }

  HyperPageIndicatorStyle pageIndicator(EditorReviewFields v) {
    final m = d.pageIndicator;
    return HyperPageIndicatorStyle(
      dotRadius: m.dotRadius == null
          ? null
          : BorderRadius.circular(m.dotRadius!),
      dotBorder: v.dotBorderWidth == null && v.dotBorderColor == null
          ? null
          : BorderSide(
              width: v.dotBorderWidth ?? 1,
              color: v.dotBorderColor?.resolve(colors) ?? colors.outline,
            ),
      material: resolveEditorReviewMaterial(v, theme),
      counterStyle: _reviewText(
        m.counterStyleSize,
        v.counterStyleWeight,
        v.counterStyleColor,
        colors,
      ),
      background: v.background == null
          ? null
          : HyperFill.color(v.background!.resolve(colors)),
      dotFill: v.dotFill == null
          ? null
          : HyperFill.color(v.dotFill!.resolve(colors)),
      selectedDotFill: v.selectedDotFill == null
          ? null
          : HyperFill.color(v.selectedDotFill!.resolve(colors)),
      border: v.borderWidth == null && v.borderColor == null
          ? null
          : Border.all(
              width: v.borderWidth ?? 1,
              color: v.borderColor?.resolve(colors) ?? colors.outline,
            ),
      borderRadius: m.surfaceRadius == null
          ? null
          : BorderRadius.circular(m.surfaceRadius!),
      boxShadow: v.shadow.shadows?.map((s) => s.resolve(colors)).toList(),
      focusColor: v.focusColor?.resolve(colors),
      disabledOpacity: v.disabledOpacity,
      duration: v.duration == null
          ? null
          : Duration(milliseconds: v.duration!.round()),
      curve: editorControlCurve(v.curve),
    );
  }

  HyperBreadcrumbStyle breadcrumb(EditorReviewFields v) {
    final m = d.breadcrumb;
    return HyperBreadcrumbStyle(
      itemStyle: surface(v, d.breadcrumb, fallback: colors.surfaceMuted),
      highlightStyle: surface(
        mode.reviews.breadcrumbHighlight,
        d.breadcrumbHighlight,
        fallback: colors.warning.withValues(alpha: .14),
      ),
      disabledStyle: surface(
        mode.reviews.breadcrumbDisabled,
        d.breadcrumbDisabled,
        fallback: colors.surfaceMuted,
      ),

      textStyle: _reviewText(
        m.textStyleSize,
        v.textStyleWeight,
        v.textStyleColor,
        colors,
      ),
      backgroundColor: v.backgroundColor?.resolve(colors),
      highlightBackgroundColor:
          (mode.reviews.breadcrumbHighlight.highlightBackgroundColor ??
                  v.highlightBackgroundColor)
              ?.resolve(colors),
      disabledBackgroundColor:
          (mode.reviews.breadcrumbDisabled.disabledBackgroundColor ??
                  v.disabledBackgroundColor)
              ?.resolve(colors),
      foregroundColor: (v.foregroundColor ?? v.textStyleColor)?.resolve(colors),
      highlightForegroundColor:
          (mode.reviews.breadcrumbHighlight.foregroundColor ??
                  mode.reviews.breadcrumbHighlight.highlightForegroundColor ??
                  v.highlightForegroundColor)
              ?.resolve(colors),
      separatorColor: v.separatorColor?.resolve(colors),
      disabledColor:
          (mode.reviews.breadcrumbDisabled.foregroundColor ?? v.disabledColor)
              ?.resolve(colors),
    );
  }

  HyperTopNavigationStyle topNavigation(EditorReviewFields v) {
    final m = d.topNavigation;
    final panel = d.topNavigationPanel, item = d.topNavigationMenu;
    final visual = mode.reviews.topNavigationMenu;
    return HyperTopNavigationStyle(
      menuStyle: HyperMenuStyle(
        width: panel.width,
        maxHeight: panel.height,
        surfacePadding: panel.horizontalPadding,
        itemHeight: item.itemHeight,
        padding: item.paddingLeft,
        itemVerticalPadding: item.paddingTop,
        itemSpacing: item.itemSpacing,
        groupSpacing: item.groupSpacing,
        itemRadius: item.itemRadius,
        iconSize: item.iconSize,
        iconSpacing: item.iconSpacing,
        descriptionGap: item.descriptionGap,
        foregroundColor: visual.foregroundColor?.resolve(colors),
        selectedForegroundColor: visual.selectedForegroundColor?.resolve(
          colors,
        ),
        selectedBackgroundColor: visual.selectedBackgroundColor?.resolve(
          colors,
        ),
        activeBackgroundColor: visual.overlayColor?.resolve(colors),
        disabledColor: visual.disabledColor?.resolve(colors),
        itemTextStyle: _reviewText(
          item.itemTextStyleSize,
          visual.itemTextStyleWeight,
          null,
          colors,
        ),
        descriptionStyle: _reviewText(
          item.descriptionStyleSize,
          visual.descriptionStyleWeight,
          visual.descriptionStyleColor,
          colors,
        ),
        groupTitleStyle: _reviewText(
          item.groupTitleStyleSize,
          visual.groupTitleStyleWeight,
          visual.groupTitleStyleColor,
          colors,
        ),
        surfaceStyle: surface(
          mode.reviews.topNavigationPanel,
          d.topNavigationPanel,
        ),
      ),
      itemStyle: button(
        d.topNavigationDefault,
        mode.reviews.topNavigationDefault,
      ),
      selectedItemStyle: button(
        d.topNavigationSelected,
        mode.reviews.topNavigationSelected,
      ),
      descriptionStyle: _reviewText(
        m.descriptionStyleSize,
        v.descriptionStyleWeight,
        v.descriptionStyleColor,
        colors,
      ),
    );
  }

  return theme.copyWith(
    tabBarTheme: theme.tabBarTheme.merge(
      HyperTabBarThemeData(
        style: tabs('tabBar'),
        segmented: tabs('tabBarSegmented'),
        separated: tabs('tabBarSeparated'),
        underline: tabs('tabBarUnderline'),
      ),
    ),
    tooltipTheme: theme.tooltipTheme.merge(
      HyperTooltipThemeData(
        foregroundColor: mode.reviews.tooltip.foregroundColor?.resolve(colors),
        style: HyperCardStyle(
          material: resolveEditorReviewMaterial(mode.reviews.tooltip, theme),
          padding: _reviewInsets(
            d.tooltip.paddingLeft,
            d.tooltip.paddingTop,
            d.tooltip.paddingRight,
            d.tooltip.paddingBottom,
            theme.sizes.resolve(device).menu.padding == 0
                ? EdgeInsets.zero
                : EdgeInsets.symmetric(
                    horizontal: theme.sizes.resolve(device).menu.padding,
                    vertical: theme.sizes.resolve(device).menu.padding / 2,
                  ),
          ),
          borderRadius: d.tooltip.surfaceRadius == null
              ? null
              : BorderRadius.circular(d.tooltip.surfaceRadius!),
          background: mode.reviews.tooltip.background == null
              ? null
              : HyperFill.color(
                  mode.reviews.tooltip.background!.resolve(colors),
                ),
          border:
              mode.reviews.tooltip.borderWidth == null &&
                  mode.reviews.tooltip.borderColor == null
              ? null
              : Border.all(
                  width: mode.reviews.tooltip.borderWidth ?? 1,
                  color:
                      mode.reviews.tooltip.borderColor?.resolve(colors) ??
                      colors.outline,
                ),
          boxShadow: mode.reviews.tooltip.shadow.shadows
              ?.map((s) => s.resolve(colors))
              .toList(),
        ),
      ),
    ),
    sizes: theme.sizes.copyWith(
      phone: sizes(HyperDeviceType.phone),
      tablet: sizes(HyperDeviceType.tablet),
      desktop: sizes(HyperDeviceType.desktop),
      watch: sizes(HyperDeviceType.watch),
    ),
    appBarTheme: theme.appBarTheme.merge(
      HyperAppBarThemeData(style: appBar(mode.reviews.appBar)),
    ),
    drawerTheme: theme.drawerTheme.merge(
      HyperDrawerThemeData(style: drawer(mode.reviews.drawer)),
    ),

    notificationTheme: theme.notificationTheme.merge(
      HyperNotificationThemeData(
        style: notification(mode.reviews.notification),
        read: notification(mode.reviews.notificationRead),
        unread: notification(mode.reviews.notificationUnread),
        hovered: notification(mode.reviews.notificationHovered),
        focused: notification(mode.reviews.notificationFocused),
        pressed: notification(mode.reviews.notificationPressed),
        disabled: notification(mode.reviews.notificationDisabled),
      ),
    ),
    loadingOverlayTheme: theme.loadingOverlayTheme.merge(
      HyperLoadingOverlayThemeData(
        style: loadingOverlay(mode.reviews.loadingOverlay),
      ),
    ),
    alertTheme: theme.alertTheme.merge(
      HyperAlertThemeData(
        style: alert(mode.reviews.alert),
        info: alert(mode.reviews.alertInfo),
        success: alert(mode.reviews.alertSuccess),
        warning: alert(mode.reviews.alertWarning),
        error: alert(mode.reviews.alertError),
        bannerStyle: banner(mode.reviews.banner),
        bannerInfo: banner(mode.reviews.bannerInfo),
        bannerSuccess: banner(mode.reviews.bannerSuccess),
        bannerWarning: banner(mode.reviews.bannerWarning),
        bannerError: banner(mode.reviews.bannerError),
      ),
    ),
    bottomSheetTheme: theme.bottomSheetTheme.merge(
      HyperBottomSheetThemeData(style: bottomSheet(mode.reviews.bottomSheet)),
    ),
    toastTheme: theme.toastTheme.merge(
      HyperToastThemeData(style: toast(mode.reviews.toast)),
    ),
    snackbarTheme: theme.snackbarTheme.merge(
      HyperSnackbarThemeData(style: snackbar(mode.reviews.snackbar)),
    ),
    dialogTheme: theme.dialogTheme.merge(
      HyperDialogThemeData(style: dialog(mode.reviews.dialog)),
    ),
    resultTheme: theme.resultTheme.copyWith(
      empty: theme.resultTheme.empty.merge(emptyState(mode.reviews.emptyState)),
    ),
    skeletonTheme: theme.skeletonTheme.merge(
      HyperSkeletonThemeData(style: skeleton(mode.reviews.skeleton)),
    ),
    sidebarTheme: theme.sidebarTheme.merge(
      HyperSidebarThemeData(style: sidebar(mode.reviews.sidebar)),
    ),
    stepIndicatorTheme: theme.stepIndicatorTheme.merge(
      HyperStepIndicatorThemeData(
        style: stepIndicator(mode.reviews.stepIndicator),
        pending: stepIndicator(mode.reviews.stepIndicatorPending),
        current: stepIndicator(mode.reviews.stepIndicatorCurrent),
        completed: stepIndicator(mode.reviews.stepIndicatorCompleted),
        error: stepIndicator(mode.reviews.stepIndicatorError),
        disabled: stepIndicator(mode.reviews.stepIndicatorDisabled),
        navigationStyle: stepperNavigation(mode.reviews.stepperNavigation),
        navigationPending: stepperNavigation(
          mode.reviews.stepperNavigationPending,
        ),
        navigationCurrent: stepperNavigation(
          mode.reviews.stepperNavigationCurrent,
        ),
        navigationCompleted: stepperNavigation(
          mode.reviews.stepperNavigationCompleted,
        ),
        navigationError: stepperNavigation(mode.reviews.stepperNavigationError),
        navigationDisabled: stepperNavigation(
          mode.reviews.stepperNavigationDisabled,
        ),
      ),
    ),
    paginationTheme: theme.paginationTheme.merge(
      HyperPaginationThemeData(style: pagination(mode.reviews.pagination)),
    ),
    pageIndicatorTheme: theme.pageIndicatorTheme.merge(
      HyperPageIndicatorThemeData(
        style: pageIndicator(mode.reviews.pageIndicator),
      ),
    ),
    breadcrumbTheme: theme.breadcrumbTheme.merge(
      HyperBreadcrumbThemeData(style: breadcrumb(mode.reviews.breadcrumb)),
    ),
    topNavigationTheme: theme.topNavigationTheme.merge(
      HyperTopNavigationThemeData(
        style: topNavigation(mode.reviews.topNavigation),
      ),
    ),
  );
}

/// Keep linked dimensions legal when their containing geometry is reduced.
void constrainEditorReviewDimensions(
  String object,
  EditorReviewFields m,
  HyperSizeScheme s,
) {
  double? cap(double? value, double limit) =>
      value?.clamp(0, limit.floorToDouble()).toDouble();
  switch (object) {
    case 'topNavigationMenu':
      m.itemRadius = cap(m.itemRadius, (m.itemHeight ?? s.menu.itemHeight) / 2);
      break;
    case 'notification':
    case 'alert':
    case 'banner':
      final button = object == 'notification'
          ? s.notification.closeButtonSize
          : object == 'alert'
          ? s.alert.closeButtonSize
          : s.alert.banner.closeButtonSize;
      final icon = object == 'notification'
          ? s.notification.closeIconSize
          : object == 'alert'
          ? s.alert.closeIconSize
          : s.alert.banner.closeIconSize;
      final limit = m.closeButtonSize ?? button;
      m.closeIconSize = cap(
        m.closeIconSize ?? (icon > limit ? icon : null),
        limit,
      );
      if (object == 'notification') {
        final markLimit = m.iconSize ?? s.notification.iconSize;
        m.unreadSize = cap(
          m.unreadSize ??
              (s.notification.unreadSize > markLimit
                  ? s.notification.unreadSize
                  : null),
          markLimit,
        );
      }
      break;
    case 'pageIndicator':
      m.dotRadius = cap(
        m.dotRadius,
        (m.dotSize ?? s.pageIndicator.dotSize) / 2,
      );
      break;
    case 'stepIndicator':
    case 'stepperNavigation':
      final base = object == 'stepIndicator'
          ? s.stepIndicator
          : s.stepIndicator.navigation;
      final node = m.nodeSize ?? base.nodeSize;
      m.iconSize = cap(
        m.iconSize ?? (base.iconSize > node ? base.iconSize : null),
        node,
      );
      m.connectorThickness = cap(
        m.connectorThickness ??
            (base.connectorThickness > node / 2
                ? base.connectorThickness
                : null),
        node / 2,
      );
      m.interactionRadius = cap(m.interactionRadius, node / 2);
      break;
    case 'tabBar':
      final height = m.height ?? s.tabBar.height;
      m.segmentedRadius = cap(m.segmentedRadius, height / 2);
      m.separatedRadius = cap(m.separatedRadius, height / 2);
      m.underlineThickness = cap(m.underlineThickness, height / 2);
      break;
    case 'sidebar':
      final iconLimit = editorSidebarIconSizeLimit(
        s,
        itemHeight: m.itemHeight,
        collapsedWidth: m.collapsedWidth,
      );
      m.iconSize = cap(
        m.iconSize ??
            (s.sidebar.iconSize > iconLimit ? s.sidebar.iconSize : null),
        iconLimit,
      );
      final expandSize = s.sidebar.expandIconSize ?? s.sidebar.iconSize;
      m.expandIconSize = cap(
        m.expandIconSize ?? (expandSize > iconLimit ? expandSize : null),
        iconLimit,
      );
      final collapsedSize = s.sidebar.collapsedIconSize ?? s.sidebar.iconSize;
      m.collapsedIconSize = cap(
        m.collapsedIconSize ??
            (collapsedSize > iconLimit ? collapsedSize : null),
        iconLimit,
      );
      m.itemRadius = cap(
        m.itemRadius,
        (m.itemHeight ?? s.sidebar.itemHeight) / 2,
      );
      m.collapsedWidth = cap(
        m.collapsedWidth ??
            (s.sidebar.collapsedWidth > (m.width ?? s.sidebar.width)
                ? s.sidebar.collapsedWidth
                : null),
        m.width ?? s.sidebar.width,
      );
      break;
    case 'skeleton':
      final short =
          (m.blockWidth ?? s.skeleton.blockWidth) <
              (m.blockHeight ?? s.skeleton.blockHeight)
          ? m.blockWidth ?? s.skeleton.blockWidth
          : m.blockHeight ?? s.skeleton.blockHeight;
      m.radius = cap(m.radius, short / 2);
      break;
    case 'appBar':
      if (m.mediumExpandedHeight != null) {
        m.mediumExpandedHeight = m.mediumExpandedHeight!.clamp(
          m.collapsedHeight ?? s.appBar.collapsedHeight,
          editorContentHeightLimit,
        );
      }
      if (m.expandedHeight != null) {
        m.expandedHeight = m.expandedHeight!.clamp(
          m.mediumExpandedHeight ?? s.appBar.mediumExpandedHeight,
          editorContentHeightLimit,
        );
      }
      break;
  }
}

/// Explicit local recipe choice; quality and fallback remain owned by the material theme.
HyperSurfaceMaterial? resolveEditorReviewMaterial(
  EditorReviewFields v,
  HyperThemeData theme,
) {
  if (v.materialKind == null) return null;
  final kind = HyperSurfaceMaterialKind.values.byName(v.materialKind!);
  final inherited = theme.materialTheme.material;
  final recipe = inherited?.kind == kind
      ? inherited!
      : switch (kind) {
          HyperSurfaceMaterialKind.solid => const HyperSurfaceMaterial.solid(),
          HyperSurfaceMaterialKind.translucent =>
            const HyperSurfaceMaterial.translucent(),
          HyperSurfaceMaterialKind.frostedGlass =>
            const HyperSurfaceMaterial.frostedGlass(),
          HyperSurfaceMaterialKind.softLightGlass =>
            const HyperSurfaceMaterial.softLightGlass(),
        };
  final color = v.background ?? v.backgroundColor ?? v.nodeFill;
  return recipe.copyWith(
    background: color == null
        ? recipe.background
        : HyperFill.color(color.resolve(theme.colors)),
    blurSigmaX: v.materialBlurX ?? recipe.blurSigmaX,
    blurSigmaY: v.materialBlurY ?? recipe.blurSigmaY,
  );
}
