import 'editor_dimension_limits.dart';

import 'package:lemon_ui/lemon_ui.dart';

import 'editor_button_fields.dart';

import 'package:flutter/material.dart';

import 'editor_theme_document.dart';

/// 输入与交互控件的显式编辑值；尺寸按设备保存，视觉按亮暗保存。
class EditorInputFields {
  EditorColor? bufferColor;
  double? indicatorPaddingHorizontal;
  double? indicatorPaddingVertical;
  double? indicatorRadius;
  double? indicatorGap;
  double? thumbWidth, thumbHeight;
  double? trackHeight;
  double? thumbRadius;
  double? thinTrackHeight;
  double? thinThumbRadius;
  double? overlayRadius;
  double? thumbOutlineWidth;
  double? stepPointRadius;
  double? capsuleWidth;
  double? capsuleCornerRadius;
  double? capsuleIconSize;
  double? capsuleIconInset;
  double? capsuleOverscrollExtent;
  double? fontSize;
  double? width;
  double? height;
  double? minimumWidth;
  double? iconSize;
  double? paddingHorizontal;
  double? paddingVertical;
  double? spacing;
  double? padding;
  double? radius;
  double? itemRadius;
  double? separatorThickness;
  double? separatorExtent;
  double? minimumTapTargetSize;
  double? progressSize;
  double? progressThickness;
  double? borderWidth;
  double? paletteHeight;
  double? markerRadius;
  double? previewHeight;
  double? pressedThumbScale;
  double? capsuleOverscrollScale;
  double? capsuleTopIconTurns;
  double? capsuleBottomIconTurns;
  double? duration;
  double? centerRadiusFraction;
  double? pureColorRadiusFraction;
  double? hueSnapDegrees;
  double? endpointSnapThreshold;
  EditorColor? activeTrackColor;
  EditorColor? inactiveTrackColor;
  EditorColor? hoverInactiveTrackColor;
  EditorColor? disabledActiveTrackColor;
  EditorColor? disabledInactiveTrackColor;
  EditorColor? thumbColor;
  EditorColor? disabledThumbColor;
  EditorColor? overlayColor;
  EditorColor? valueIndicatorColor;
  EditorColor? thumbOutlineColor;
  EditorColor? activeStepPointColor;
  EditorColor? inactiveStepPointColor;
  EditorColor? capsuleBackgroundColor;
  EditorColor? capsuleFillColor;
  EditorColor? capsuleBorderColor;
  EditorColor? capsuleTopIconColor;
  EditorColor? capsuleBottomIconColor;
  EditorColor? foregroundColor;
  EditorColor? backgroundColor;
  EditorColor? borderColor;
  EditorColor? progressColor;
  EditorColor? progressTrackColor;
  EditorColor? separatorColor;
  EditorColor? checkerLightColor;
  EditorColor? checkerDarkColor;
  EditorColor? markerColor;
  int? fontWeight;
  String? curve;
  String? valueIndicatorVisibility;
  bool? capsuleAutoIconContrast;
  Map<String, Object?> toJson() => {
    if (bufferColor != null) 'bufferColor': bufferColor!.toJson(),
    if (indicatorPaddingHorizontal != null)
      'indicatorPaddingHorizontal': indicatorPaddingHorizontal,
    if (indicatorPaddingVertical != null)
      'indicatorPaddingVertical': indicatorPaddingVertical,
    if (indicatorRadius != null) 'indicatorRadius': indicatorRadius,
    if (indicatorGap != null) 'indicatorGap': indicatorGap,
    if (valueIndicatorVisibility != null)
      'valueIndicatorVisibility': valueIndicatorVisibility,
    if (thumbWidth != null) 'thumbWidth': thumbWidth,
    if (thumbHeight != null) 'thumbHeight': thumbHeight,
    if (trackHeight != null) 'trackHeight': trackHeight,
    if (thumbRadius != null) 'thumbRadius': thumbRadius,
    if (thinTrackHeight != null) 'thinTrackHeight': thinTrackHeight,
    if (thinThumbRadius != null) 'thinThumbRadius': thinThumbRadius,
    if (overlayRadius != null) 'overlayRadius': overlayRadius,
    if (thumbOutlineWidth != null) 'thumbOutlineWidth': thumbOutlineWidth,
    if (stepPointRadius != null) 'stepPointRadius': stepPointRadius,
    if (capsuleWidth != null) 'capsuleWidth': capsuleWidth,
    if (capsuleCornerRadius != null) 'capsuleCornerRadius': capsuleCornerRadius,
    if (capsuleIconSize != null) 'capsuleIconSize': capsuleIconSize,
    if (capsuleIconInset != null) 'capsuleIconInset': capsuleIconInset,
    if (capsuleOverscrollExtent != null)
      'capsuleOverscrollExtent': capsuleOverscrollExtent,
    if (fontSize != null) 'fontSize': fontSize,
    if (width != null) 'width': width,
    if (height != null) 'height': height,
    if (minimumWidth != null) 'minimumWidth': minimumWidth,
    if (iconSize != null) 'iconSize': iconSize,
    if (paddingHorizontal != null) 'paddingHorizontal': paddingHorizontal,
    if (paddingVertical != null) 'paddingVertical': paddingVertical,
    if (spacing != null) 'spacing': spacing,
    if (padding != null) 'padding': padding,
    if (radius != null) 'radius': radius,
    if (itemRadius != null) 'itemRadius': itemRadius,
    if (separatorThickness != null) 'separatorThickness': separatorThickness,
    if (separatorExtent != null) 'separatorExtent': separatorExtent,
    if (minimumTapTargetSize != null)
      'minimumTapTargetSize': minimumTapTargetSize,
    if (progressSize != null) 'progressSize': progressSize,
    if (progressThickness != null) 'progressThickness': progressThickness,
    if (borderWidth != null) 'borderWidth': borderWidth,
    if (paletteHeight != null) 'paletteHeight': paletteHeight,
    if (markerRadius != null) 'markerRadius': markerRadius,
    if (previewHeight != null) 'previewHeight': previewHeight,
    if (pressedThumbScale != null) 'pressedThumbScale': pressedThumbScale,
    if (capsuleOverscrollScale != null)
      'capsuleOverscrollScale': capsuleOverscrollScale,
    if (capsuleTopIconTurns != null) 'capsuleTopIconTurns': capsuleTopIconTurns,
    if (capsuleBottomIconTurns != null)
      'capsuleBottomIconTurns': capsuleBottomIconTurns,
    if (duration != null) 'duration': duration,
    if (centerRadiusFraction != null)
      'centerRadiusFraction': centerRadiusFraction,
    if (pureColorRadiusFraction != null)
      'pureColorRadiusFraction': pureColorRadiusFraction,
    if (hueSnapDegrees != null) 'hueSnapDegrees': hueSnapDegrees,
    if (endpointSnapThreshold != null)
      'endpointSnapThreshold': endpointSnapThreshold,
    if (activeTrackColor != null)
      'activeTrackColor': activeTrackColor!.toJson(),
    if (inactiveTrackColor != null)
      'inactiveTrackColor': inactiveTrackColor!.toJson(),
    if (hoverInactiveTrackColor != null)
      'hoverInactiveTrackColor': hoverInactiveTrackColor!.toJson(),
    if (disabledActiveTrackColor != null)
      'disabledActiveTrackColor': disabledActiveTrackColor!.toJson(),
    if (disabledInactiveTrackColor != null)
      'disabledInactiveTrackColor': disabledInactiveTrackColor!.toJson(),
    if (thumbColor != null) 'thumbColor': thumbColor!.toJson(),
    if (disabledThumbColor != null)
      'disabledThumbColor': disabledThumbColor!.toJson(),
    if (overlayColor != null) 'overlayColor': overlayColor!.toJson(),
    if (valueIndicatorColor != null)
      'valueIndicatorColor': valueIndicatorColor!.toJson(),
    if (thumbOutlineColor != null)
      'thumbOutlineColor': thumbOutlineColor!.toJson(),
    if (activeStepPointColor != null)
      'activeStepPointColor': activeStepPointColor!.toJson(),
    if (inactiveStepPointColor != null)
      'inactiveStepPointColor': inactiveStepPointColor!.toJson(),
    if (capsuleBackgroundColor != null)
      'capsuleBackgroundColor': capsuleBackgroundColor!.toJson(),
    if (capsuleFillColor != null)
      'capsuleFillColor': capsuleFillColor!.toJson(),
    if (capsuleBorderColor != null)
      'capsuleBorderColor': capsuleBorderColor!.toJson(),
    if (capsuleTopIconColor != null)
      'capsuleTopIconColor': capsuleTopIconColor!.toJson(),
    if (capsuleBottomIconColor != null)
      'capsuleBottomIconColor': capsuleBottomIconColor!.toJson(),
    if (foregroundColor != null) 'foregroundColor': foregroundColor!.toJson(),
    if (backgroundColor != null) 'backgroundColor': backgroundColor!.toJson(),
    if (borderColor != null) 'borderColor': borderColor!.toJson(),
    if (progressColor != null) 'progressColor': progressColor!.toJson(),
    if (progressTrackColor != null)
      'progressTrackColor': progressTrackColor!.toJson(),
    if (separatorColor != null) 'separatorColor': separatorColor!.toJson(),
    if (checkerLightColor != null)
      'checkerLightColor': checkerLightColor!.toJson(),
    if (checkerDarkColor != null)
      'checkerDarkColor': checkerDarkColor!.toJson(),
    if (markerColor != null) 'markerColor': markerColor!.toJson(),
    if (fontWeight != null) 'fontWeight': fontWeight,
    if (curve != null) 'curve': curve,
    if (capsuleAutoIconContrast != null)
      'capsuleAutoIconContrast': capsuleAutoIconContrast,
  };
  static EditorInputFields fromJson(Map<String, dynamic> j) {
    const keys = {
      'bufferColor',
      'indicatorPaddingHorizontal',
      'indicatorPaddingVertical',
      'indicatorRadius',
      'indicatorGap',
      'valueIndicatorVisibility',
      'thumbWidth',
      'thumbHeight',
      'trackHeight',
      'thumbRadius',
      'thinTrackHeight',
      'thinThumbRadius',
      'overlayRadius',
      'thumbOutlineWidth',
      'stepPointRadius',
      'capsuleWidth',
      'capsuleCornerRadius',
      'capsuleIconSize',
      'capsuleIconInset',
      'capsuleOverscrollExtent',
      'fontSize',
      'width',
      'height',
      'minimumWidth',
      'iconSize',
      'paddingHorizontal',
      'paddingVertical',
      'spacing',
      'padding',
      'radius',
      'itemRadius',
      'separatorThickness',
      'separatorExtent',
      'minimumTapTargetSize',
      'progressSize',
      'progressThickness',
      'borderWidth',
      'paletteHeight',
      'markerRadius',
      'previewHeight',
      'pressedThumbScale',
      'capsuleOverscrollScale',
      'capsuleTopIconTurns',
      'capsuleBottomIconTurns',
      'duration',
      'centerRadiusFraction',
      'pureColorRadiusFraction',
      'hueSnapDegrees',
      'endpointSnapThreshold',
      'activeTrackColor',
      'inactiveTrackColor',
      'hoverInactiveTrackColor',
      'disabledActiveTrackColor',
      'disabledInactiveTrackColor',
      'thumbColor',
      'disabledThumbColor',
      'overlayColor',
      'valueIndicatorColor',
      'thumbOutlineColor',
      'activeStepPointColor',
      'inactiveStepPointColor',
      'capsuleBackgroundColor',
      'capsuleFillColor',
      'capsuleBorderColor',
      'capsuleTopIconColor',
      'capsuleBottomIconColor',
      'foregroundColor',
      'backgroundColor',
      'borderColor',
      'progressColor',
      'progressTrackColor',
      'separatorColor',
      'checkerLightColor',
      'checkerDarkColor',
      'markerColor',
      'fontWeight',
      'curve',
      'capsuleAutoIconContrast',
    };
    if (j.keys.any((k) => !keys.contains(k))) {
      throw const FormatException('不支持的输入设置');
    }
    if (j['curve'] != null &&
        !{'linear', 'easeInOut', 'fastOutSlowIn'}.contains(j['curve'])) {
      throw const FormatException('不支持的过渡曲线');
    }
    if (j['valueIndicatorVisibility'] != null &&
        !{
          'onDrag',
          'alwaysVisible',
          'never',
        }.contains(j['valueIndicatorVisibility'])) {
      throw const FormatException('无效数值提示显示方式');
    }
    return EditorInputFields()
      ..bufferColor = j['bufferColor'] == null
          ? null
          : EditorColor.fromJson(j['bufferColor'] as Map<String, dynamic>)
      ..indicatorPaddingHorizontal = number(
        j['indicatorPaddingHorizontal'],
        min: 0,
        max: editorContentSpacingLimit,
      )
      ..indicatorPaddingVertical = number(
        j['indicatorPaddingVertical'],
        min: 0,
        max: editorContentSpacingLimit,
      )
      ..indicatorRadius = number(
        j['indicatorRadius'],
        min: 0,
        max: editorContentSpacingLimit,
      )
      ..indicatorGap = number(
        j['indicatorGap'],
        min: 0,
        max: editorContentSpacingLimit,
      )
      ..valueIndicatorVisibility = j['valueIndicatorVisibility'] as String?
      ..thumbWidth = number(j['thumbWidth'], min: 0, max: editorTapTargetLimit)
      ..thumbHeight = number(
        j['thumbHeight'],
        min: 0,
        max: editorTapTargetLimit,
      )
      ..trackHeight = number(
        j['trackHeight'],
        min: 0,
        max: editorWideTrackThicknessLimit,
      )
      ..thumbRadius = number(
        j['thumbRadius'],
        min: 0,
        max: editorSelectionMarkLimit / 2,
      )
      ..thinTrackHeight = number(
        j['thinTrackHeight'],
        min: 0,
        max: editorWideTrackThicknessLimit,
      )
      ..thinThumbRadius = number(
        j['thinThumbRadius'],
        min: 0,
        max: editorSelectionMarkLimit / 2,
      )
      ..overlayRadius = number(
        j['overlayRadius'],
        min: 0,
        max: editorSelectionMarkLimit,
      )
      ..thumbOutlineWidth = number(
        j['thumbOutlineWidth'],
        min: 0,
        max: editorSelectionMarkLimit / 2,
      )
      ..stepPointRadius = number(
        j['stepPointRadius'],
        min: 0,
        max: editorWideTrackThicknessLimit / 2,
      )
      ..capsuleWidth = number(
        j['capsuleWidth'],
        min: 0,
        max: editorCapsuleWidthLimit,
      )
      ..capsuleCornerRadius = number(
        j['capsuleCornerRadius'],
        min: 0,
        max: 1000,
      )
      ..capsuleIconSize = number(
        j['capsuleIconSize'],
        min: 0,
        max: editorCapsuleWidthLimit,
      )
      ..capsuleIconInset = number(
        j['capsuleIconInset'],
        min: 0,
        max: editorCapsuleWidthLimit / 2,
      )
      ..capsuleOverscrollExtent = number(
        j['capsuleOverscrollExtent'],
        min: 0,
        max: 1000,
      )
      ..fontSize = number(j['fontSize'], min: 0, max: editorContentIconLimit)
      ..width = number(j['width'], min: 0, max: editorContentWidthLimit)
      ..height = number(j['height'], min: 0, max: editorTapTargetLimit)
      ..minimumWidth = number(
        j['minimumWidth'],
        min: 0,
        max: editorContentWidthLimit,
      )
      ..iconSize = number(j['iconSize'], min: 0, max: editorTapTargetLimit)
      ..paddingHorizontal = number(
        j['paddingHorizontal'],
        min: 0,
        max: editorContentSpacingLimit,
      )
      ..paddingVertical = number(
        j['paddingVertical'],
        min: 0,
        max: editorContentSpacingLimit,
      )
      ..spacing = number(j['spacing'], min: 0, max: editorContentSpacingLimit)
      ..padding = number(j['padding'], min: 0, max: editorContentSpacingLimit)
      ..radius = number(j['radius'], min: 0, max: editorContentHeightLimit / 2)
      ..itemRadius = number(
        j['itemRadius'],
        min: 0,
        max: editorTapTargetLimit / 2,
      )
      ..separatorThickness = number(
        j['separatorThickness'],
        min: 0,
        max: editorLineThicknessLimit,
      )
      ..separatorExtent = number(
        j['separatorExtent'],
        min: 0,
        max: editorTapTargetLimit,
      )
      ..minimumTapTargetSize = number(
        j['minimumTapTargetSize'],
        min: 0,
        max: 1000,
      )
      ..progressSize = number(
        j['progressSize'],
        min: 0,
        max: editorTapTargetLimit,
      )
      ..progressThickness = number(
        j['progressThickness'],
        min: 0,
        max: editorTapTargetLimit / 2,
      )
      ..borderWidth = number(
        j['borderWidth'],
        min: 0,
        max: editorLineThicknessLimit,
      )
      ..paletteHeight = number(
        j['paletteHeight'],
        min: 0,
        max: editorContentHeightLimit,
      )
      ..markerRadius = number(
        j['markerRadius'],
        min: 0,
        max: editorContentHeightLimit / 2,
      )
      ..previewHeight = number(
        j['previewHeight'],
        min: 0,
        max: editorContentIllustrationLimit,
      )
      ..pressedThumbScale = number(j['pressedThumbScale'], min: 0, max: 10)
      ..capsuleOverscrollScale = number(
        j['capsuleOverscrollScale'],
        min: 0,
        max: 10,
      )
      ..capsuleTopIconTurns = number(j['capsuleTopIconTurns'], min: -1, max: 10)
      ..capsuleBottomIconTurns = number(
        j['capsuleBottomIconTurns'],
        min: -1,
        max: 10,
      )
      ..duration = number(j['duration'], min: 0, max: 5000)
      ..centerRadiusFraction = number(
        j['centerRadiusFraction'],
        min: 0,
        max: 10,
      )
      ..pureColorRadiusFraction = number(
        j['pureColorRadiusFraction'],
        min: 0,
        max: 10,
      )
      ..hueSnapDegrees = number(j['hueSnapDegrees'], min: 0, max: 360)
      ..endpointSnapThreshold = number(
        j['endpointSnapThreshold'],
        min: 0,
        max: 10,
      )
      ..activeTrackColor = j['activeTrackColor'] == null
          ? null
          : EditorColor.fromJson(j['activeTrackColor'] as Map<String, dynamic>)
      ..inactiveTrackColor = j['inactiveTrackColor'] == null
          ? null
          : EditorColor.fromJson(
              j['inactiveTrackColor'] as Map<String, dynamic>,
            )
      ..hoverInactiveTrackColor = j['hoverInactiveTrackColor'] == null
          ? null
          : EditorColor.fromJson(
              j['hoverInactiveTrackColor'] as Map<String, dynamic>,
            )
      ..disabledActiveTrackColor = j['disabledActiveTrackColor'] == null
          ? null
          : EditorColor.fromJson(
              j['disabledActiveTrackColor'] as Map<String, dynamic>,
            )
      ..disabledInactiveTrackColor = j['disabledInactiveTrackColor'] == null
          ? null
          : EditorColor.fromJson(
              j['disabledInactiveTrackColor'] as Map<String, dynamic>,
            )
      ..thumbColor = j['thumbColor'] == null
          ? null
          : EditorColor.fromJson(j['thumbColor'] as Map<String, dynamic>)
      ..disabledThumbColor = j['disabledThumbColor'] == null
          ? null
          : EditorColor.fromJson(
              j['disabledThumbColor'] as Map<String, dynamic>,
            )
      ..overlayColor = j['overlayColor'] == null
          ? null
          : EditorColor.fromJson(j['overlayColor'] as Map<String, dynamic>)
      ..valueIndicatorColor = j['valueIndicatorColor'] == null
          ? null
          : EditorColor.fromJson(
              j['valueIndicatorColor'] as Map<String, dynamic>,
            )
      ..thumbOutlineColor = j['thumbOutlineColor'] == null
          ? null
          : EditorColor.fromJson(j['thumbOutlineColor'] as Map<String, dynamic>)
      ..activeStepPointColor = j['activeStepPointColor'] == null
          ? null
          : EditorColor.fromJson(
              j['activeStepPointColor'] as Map<String, dynamic>,
            )
      ..inactiveStepPointColor = j['inactiveStepPointColor'] == null
          ? null
          : EditorColor.fromJson(
              j['inactiveStepPointColor'] as Map<String, dynamic>,
            )
      ..capsuleBackgroundColor = j['capsuleBackgroundColor'] == null
          ? null
          : EditorColor.fromJson(
              j['capsuleBackgroundColor'] as Map<String, dynamic>,
            )
      ..capsuleFillColor = j['capsuleFillColor'] == null
          ? null
          : EditorColor.fromJson(j['capsuleFillColor'] as Map<String, dynamic>)
      ..capsuleBorderColor = j['capsuleBorderColor'] == null
          ? null
          : EditorColor.fromJson(
              j['capsuleBorderColor'] as Map<String, dynamic>,
            )
      ..capsuleTopIconColor = j['capsuleTopIconColor'] == null
          ? null
          : EditorColor.fromJson(
              j['capsuleTopIconColor'] as Map<String, dynamic>,
            )
      ..capsuleBottomIconColor = j['capsuleBottomIconColor'] == null
          ? null
          : EditorColor.fromJson(
              j['capsuleBottomIconColor'] as Map<String, dynamic>,
            )
      ..foregroundColor = j['foregroundColor'] == null
          ? null
          : EditorColor.fromJson(j['foregroundColor'] as Map<String, dynamic>)
      ..backgroundColor = j['backgroundColor'] == null
          ? null
          : EditorColor.fromJson(j['backgroundColor'] as Map<String, dynamic>)
      ..borderColor = j['borderColor'] == null
          ? null
          : EditorColor.fromJson(j['borderColor'] as Map<String, dynamic>)
      ..progressColor = j['progressColor'] == null
          ? null
          : EditorColor.fromJson(j['progressColor'] as Map<String, dynamic>)
      ..progressTrackColor = j['progressTrackColor'] == null
          ? null
          : EditorColor.fromJson(
              j['progressTrackColor'] as Map<String, dynamic>,
            )
      ..separatorColor = j['separatorColor'] == null
          ? null
          : EditorColor.fromJson(j['separatorColor'] as Map<String, dynamic>)
      ..checkerLightColor = j['checkerLightColor'] == null
          ? null
          : EditorColor.fromJson(j['checkerLightColor'] as Map<String, dynamic>)
      ..checkerDarkColor = j['checkerDarkColor'] == null
          ? null
          : EditorColor.fromJson(j['checkerDarkColor'] as Map<String, dynamic>)
      ..markerColor = j['markerColor'] == null
          ? null
          : EditorColor.fromJson(j['markerColor'] as Map<String, dynamic>)
      ..fontWeight = number(j['fontWeight'], min: 100, max: 900)?.round()
      ..curve = j['curve'] as String?
      ..capsuleAutoIconContrast = j['capsuleAutoIconContrast'] as bool?;
  }

  FontWeight? get weight => fontWeight == null
      ? null
      : FontWeight.values[(fontWeight! / 100).round().clamp(1, 9) - 1];
  Curve? get animationCurve => switch (curve) {
    'linear' => Curves.linear,
    'easeInOut' => Curves.easeInOut,
    'fastOutSlowIn' => Curves.fastOutSlowIn,
    _ => null,
  };
  Duration? get animationDuration =>
      duration == null ? null : Duration(milliseconds: duration!.round());
}

HyperFill? _fill(EditorComponent a, HyperColorScheme c) => switch (a.fillKind) {
  EditorFillKind.none => const HyperFill.none(),
  EditorFillKind.gradient =>
    a.gradient == null ? null : HyperFill.gradient(a.gradient!.resolve(c)),
  _ => a.background == null ? null : HyperFill.color(a.background!.resolve(c)),
};

HyperThemeData applyEditorInputs(
  HyperThemeData theme,
  EditorMode mode,
  EditorDevice device,
  HyperDeviceType type,
) {
  final c = theme.colors;
  final sizes = theme.sizes.resolve(type);
  final sm = device.sliderInput, sv = mode.sliderInput.input;
  final segment = mode.segmentedInput, selected = mode.segmentedSelectedInput;
  final group = mode.segmentedGroupInput;
  final gm = device.segmentedInput;
  HyperButtonStyle segmentStyle(EditorComponent a, {required bool selected}) =>
      HyperButtonStyle(
        foregroundColor: a.foreground?.resolve(c),
        background: _fill(a, c),
        textStyle: gm.fontSize == null && a.input.weight == null
            ? null
            : TextStyle(fontSize: gm.fontSize, fontWeight: a.input.weight),
        height: gm.height,
        minimumSize: gm.minimumWidth == null ? null : Size(gm.minimumWidth!, 0),
        iconSize: gm.iconSize,
        padding: gm.paddingHorizontal == null && gm.paddingVertical == null
            ? null
            : EdgeInsets.symmetric(
                horizontal:
                    gm.paddingHorizontal ??
                    sizes.button.padding.resolve(TextDirection.ltr).left,
                vertical:
                    gm.paddingVertical ??
                    sizes.button.padding.resolve(TextDirection.ltr).top,
              ),
        borderRadius: gm.itemRadius == null
            ? null
            : BorderRadius.circular(gm.itemRadius!),
        boxBorder: a.border.resolve(c),
        boxShadow: a.shadows?.map((v) => v.resolve(c)).toList(),
        animationDuration: a.input.animationDuration,
        animationCurve: a.input.animationCurve,
      );
  final pm = device.colorPickerInput, pv = mode.colorPickerInput.input;
  HyperIconButtonStyle iconStyle(EditorComponent a) {
    final m = device.iconButtonInput, v = a.input;
    return HyperIconButtonStyle(
      size: m.width,
      iconSize: m.iconSize,
      minimumTapTargetSize: m.minimumTapTargetSize,
      progressSize: m.progressSize,
      progressThickness: m.progressThickness,
      foregroundColor: a.foreground?.resolve(c),
      background: _fill(a, c),
      overlayColor: v.overlayColor?.resolve(c),
      progressColor: v.progressColor?.resolve(c),
      progressTrackColor: v.progressTrackColor?.resolve(c),
      borderRadius: m.radius == null ? null : BorderRadius.circular(m.radius!),
      border:
          a.border.width == null &&
              a.border.color == null &&
              a.border.kind == null
          ? null
          : BorderSide(
              width: a.border.kind == EditorBorderKind.none
                  ? 0
                  : a.border.width ?? 1,
              color: a.border.color?.resolve(c) ?? c.outline,
            ),
      boxShadow: a.shadows?.map((v) => v.resolve(c)).toList(),
    );
  }

  return theme.copyWith(
    sliderTheme: theme.sliderTheme.merge(
      HyperSliderThemeData(
        style: HyperSliderStyle(
          bufferColor: sv.bufferColor?.resolve(c),
          activeTrackColor: sv.activeTrackColor?.resolve(c),
          inactiveTrackColor: sv.inactiveTrackColor?.resolve(c),
          hoverInactiveTrackColor: sv.hoverInactiveTrackColor?.resolve(c),
          disabledActiveTrackColor: sv.disabledActiveTrackColor?.resolve(c),
          disabledInactiveTrackColor: sv.disabledInactiveTrackColor?.resolve(c),
          thumbColor: sv.thumbColor?.resolve(c),
          disabledThumbColor: sv.disabledThumbColor?.resolve(c),
          overlayColor: sv.overlayColor?.resolve(c),
          valueIndicatorColor: sv.valueIndicatorColor?.resolve(c),
          thumbOutlineColor: sv.thumbOutlineColor?.resolve(c),
          activeStepPointColor: sv.activeStepPointColor?.resolve(c),
          inactiveStepPointColor: sv.inactiveStepPointColor?.resolve(c),
          capsuleBackgroundColor: sv.capsuleBackgroundColor?.resolve(c),
          capsuleFillColor: sv.capsuleFillColor?.resolve(c),
          capsuleBorderColor: sv.capsuleBorderColor?.resolve(c),
          capsuleTopIconColor: sv.capsuleTopIconColor?.resolve(c),
          capsuleBottomIconColor: sv.capsuleBottomIconColor?.resolve(c),
          thumbShadows: mode.sliderInput.shadows
              ?.map((s) => s.resolve(c))
              .toList(),
          showValueIndicator: sv.valueIndicatorVisibility == null
              ? null
              : ShowValueIndicator.values.byName(sv.valueIndicatorVisibility!),
          valueIndicatorGap: sm.indicatorGap,
          valueIndicatorSurface: HyperCardStyle(
            padding:
                sm.indicatorPaddingHorizontal == null &&
                    sm.indicatorPaddingVertical == null
                ? null
                : EdgeInsets.symmetric(
                    horizontal:
                        sm.indicatorPaddingHorizontal ?? sizes.menu.padding,
                    vertical:
                        sm.indicatorPaddingVertical ??
                        sizes.menu.descriptionGap,
                  ),
            borderRadius: sm.indicatorRadius == null
                ? null
                : BorderRadius.circular(sm.indicatorRadius!),
            background: sv.valueIndicatorColor == null
                ? null
                : HyperFill.color(sv.valueIndicatorColor!.resolve(c)),
            boxShadow: mode.sliderInput.hoveredShadow.shadows
                ?.map((v) => v.resolve(c))
                .toList(),
          ),
          overlayRadius: sm.overlayRadius,
          thumbOutlineWidth: sm.thumbOutlineWidth,
          valueIndicatorTextStyle:
              sm.fontSize == null &&
                  sv.weight == null &&
                  sv.foregroundColor == null
              ? null
              : TextStyle(
                  fontSize: sm.fontSize,
                  fontWeight: sv.weight,
                  color: sv.foregroundColor?.resolve(c),
                ),
          pressedThumbScale: sv.pressedThumbScale,
          capsuleBorderWidth: sm.borderWidth,
          capsuleAutoIconContrast: sv.capsuleAutoIconContrast,
          capsuleTopIconTurns: sv.capsuleTopIconTurns,
          capsuleBottomIconTurns: sv.capsuleBottomIconTurns,
          capsuleOverscrollScale: sv.capsuleOverscrollScale,
          capsuleAnimationDuration: sv.animationDuration,
          capsuleAnimationCurve: sv.animationCurve,
        ),
      ),
    ),
    segmentedButtonTheme: theme.segmentedButtonTheme.merge(
      HyperSegmentedButtonThemeData(
        style: HyperSegmentedButtonStyle(
          button: segmentStyle(segment, selected: false),
          selectedButton: segmentStyle(selected, selected: true),
          group: HyperWidgetGroupStyle(
            itemHeight: gm.height,
            spacing: gm.spacing,
            padding: gm.padding == null ? null : EdgeInsets.all(gm.padding!),
            borderRadius: gm.radius == null
                ? null
                : BorderRadius.circular(gm.radius!),
            itemBorderRadius: gm.itemRadius == null
                ? null
                : BorderRadius.circular(gm.itemRadius!),
            backgroundColor: group.input.backgroundColor?.resolve(c),
            border: group.border.resolve(c),
            boxShadow: group.shadows?.map((s) => s.resolve(c)).toList(),
            separatorColor: group.input.separatorColor?.resolve(c),
            separatorThickness: gm.separatorThickness,
            separatorExtent: gm.separatorExtent,
            duration: group.input.animationDuration,
            curve: group.input.animationCurve,
          ),
        ),
      ),
    ),
    colorPickerTheme: theme.colorPickerTheme.merge(
      HyperColorPickerThemeData(
        style: HyperColorPickerStyle(
          width: pm.width,
          paletteHeight: pm.paletteHeight,
          radius: pm.radius,
          spacing: pm.spacing,
          markerRadius: pm.markerRadius,
          previewHeight: pm.previewHeight,
          centerRadiusFraction: pv.centerRadiusFraction,
          pureColorRadiusFraction: pv.pureColorRadiusFraction,
          hueSnapDegrees: pv.hueSnapDegrees,
          endpointSnapThreshold: pv.endpointSnapThreshold,
          checkerLightColor: pv.checkerLightColor?.resolve(c),
          checkerDarkColor: pv.checkerDarkColor?.resolve(c),
          markerColor: pv.markerColor?.resolve(c),
          paletteBorder: pm.borderWidth == null && pv.borderColor == null
              ? null
              : BorderSide(
                  width: pm.borderWidth ?? 1,
                  color: pv.borderColor?.resolve(c) ?? c.outline,
                ),
        ),
      ),
    ),
    iconButtonTheme: theme.iconButtonTheme.merge(
      HyperIconButtonThemeData(
        style: iconStyle(mode.iconButtonInput),
        filled: iconStyle(mode.iconButtonFilledInput),
        tonal: iconStyle(mode.iconButtonTonalInput),
        outlined: iconStyle(mode.iconButtonOutlinedInput),
        ghost: iconStyle(mode.iconButtonGhostInput),
      ),
    ),
  );
}
