import 'editor_button_fields.dart';

import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'editor_theme_document.dart';

class EditorChipMetrics {
  double? height;
  double? horizontalPadding;
  double? radius;
  double? iconSize;
  double? iconSpacing;
  double? avatarSize;
  double? deleteIconSize;
  double? deleteTargetWidth;

  Map<String, Object?> toJson() => {
    if (height != null) 'height': height,
    if (horizontalPadding != null) 'horizontalPadding': horizontalPadding,
    if (radius != null) 'radius': radius,
    if (iconSize != null) 'iconSize': iconSize,
    if (iconSpacing != null) 'iconSpacing': iconSpacing,
    if (avatarSize != null) 'avatarSize': avatarSize,
    if (deleteIconSize != null) 'deleteIconSize': deleteIconSize,
    if (deleteTargetWidth != null) 'deleteTargetWidth': deleteTargetWidth,
  };
  static EditorChipMetrics fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'height',
        'horizontalPadding',
        'radius',
        'iconSize',
        'iconSpacing',
        'avatarSize',
        'deleteIconSize',
        'deleteTargetWidth',
      }.contains(k),
    )) {
      throw const FormatException('不支持的标签属性');
    }
    return EditorChipMetrics()
      ..height = number(j['height'], min: 0, max: 300)
      ..horizontalPadding = number(j['horizontalPadding'], min: 0, max: 300)
      ..radius = number(j['radius'], min: 0, max: 300)
      ..iconSize = number(j['iconSize'], min: 0, max: 300)
      ..iconSpacing = number(j['iconSpacing'], min: 0, max: 300)
      ..avatarSize = number(j['avatarSize'], min: 0, max: 300)
      ..deleteIconSize = number(j['deleteIconSize'], min: 0, max: 300)
      ..deleteTargetWidth = number(j['deleteTargetWidth'], min: 0, max: 300);
  }
}

class EditorChipVisual {
  String? colorVariant, foregroundMode;
  EditorColor? baseColor;
  double? backgroundFade, borderFade, foregroundFade;
  bool? showCheckmark;
  String? checkPlacement, checkIcon, deleteIcon;
  double? fontSize;
  double? avatarOpacity;
  double? checkmarkScale;
  double? durationMilliseconds;
  double? borderWidth;
  EditorColor? foreground;
  EditorColor? overlay;
  EditorColor? borderColor;
  EditorColor? checkColor;
  EditorColor? avatarColor;
  Map<String, Object?> toJson() => {
    if (colorVariant != null) 'colorVariant': colorVariant,
    if (foregroundMode != null) 'foregroundMode': foregroundMode,
    if (baseColor != null) 'baseColor': baseColor!.toJson(),
    if (backgroundFade != null) 'backgroundFade': backgroundFade,
    if (borderFade != null) 'borderFade': borderFade,
    if (foregroundFade != null) 'foregroundFade': foregroundFade,
    if (showCheckmark != null) 'showCheckmark': showCheckmark,
    if (checkPlacement != null) 'checkPlacement': checkPlacement,
    if (checkIcon != null) 'checkIcon': checkIcon,
    if (deleteIcon != null) 'deleteIcon': deleteIcon,
    if (fontSize != null) 'fontSize': fontSize,
    if (avatarOpacity != null) 'avatarOpacity': avatarOpacity,
    if (checkmarkScale != null) 'checkmarkScale': checkmarkScale,
    if (durationMilliseconds != null)
      'durationMilliseconds': durationMilliseconds,
    if (borderWidth != null) 'borderWidth': borderWidth,
    if (foreground != null) 'foreground': foreground!.toJson(),
    if (overlay != null) 'overlay': overlay!.toJson(),
    if (borderColor != null) 'borderColor': borderColor!.toJson(),
    if (checkColor != null) 'checkColor': checkColor!.toJson(),
    if (avatarColor != null) 'avatarColor': avatarColor!.toJson(),
  };
  static EditorChipVisual fromJson(Map<String, dynamic> j) {
    if (j.keys.any(
      (k) => !{
        'colorVariant',
        'foregroundMode',
        'baseColor',
        'backgroundFade',
        'borderFade',
        'foregroundFade',
        'showCheckmark',
        'checkPlacement',
        'checkIcon',
        'deleteIcon',
        'fontSize',
        'avatarOpacity',
        'checkmarkScale',
        'durationMilliseconds',
        'borderWidth',
        'foreground',
        'overlay',
        'borderColor',
        'checkColor',
        'avatarColor',
      }.contains(k),
    )) {
      throw const FormatException('不支持的标签属性');
    }
    if (j['showCheckmark'] != null && j['showCheckmark'] is! bool) {
      throw const FormatException('无效选中标记');
    }
    if (j['checkPlacement'] != null &&
        !HyperChipCheckmarkPlacement.values.any(
          (v) => v.name == j['checkPlacement'],
        )) {
      throw const FormatException('无效标记位置');
    }
    for (final key in ['checkIcon', 'deleteIcon']) {
      if (j[key] != null &&
          !['check', 'star', 'close', 'cancel', 'delete'].contains(j[key])) {
        throw const FormatException('无效图标');
      }
    }
    if (j['colorVariant'] != null &&
        !HyperChipColorVariant.values.any((v) => v.name == j['colorVariant'])) {
      throw const FormatException('无效标签配色');
    }
    if (j['foregroundMode'] != null &&
        !HyperChipForegroundMode.values.any(
          (v) => v.name == j['foregroundMode'],
        )) {
      throw const FormatException('无效前景策略');
    }
    return EditorChipVisual()
      ..colorVariant = j['colorVariant'] as String?
      ..foregroundMode = j['foregroundMode'] as String?
      ..baseColor = j['baseColor'] == null
          ? null
          : EditorColor.fromJson(j['baseColor'] as Map<String, dynamic>)
      ..backgroundFade = number(j['backgroundFade'], min: 0, max: 1)
      ..borderFade = number(j['borderFade'], min: 0, max: 1)
      ..foregroundFade = number(j['foregroundFade'], min: 0, max: 1)
      ..showCheckmark = j['showCheckmark'] as bool?
      ..checkPlacement = j['checkPlacement'] as String?
      ..checkIcon = j['checkIcon'] as String?
      ..deleteIcon = j['deleteIcon'] as String?
      ..fontSize = number(j['fontSize'], min: 8, max: 300)
      ..avatarOpacity = number(j['avatarOpacity'], min: 0, max: 1)
      ..checkmarkScale = number(j['checkmarkScale'], min: 0, max: 3)
      ..durationMilliseconds = number(
        j['durationMilliseconds'],
        min: 0,
        max: 5000,
      )
      ..borderWidth = number(j['borderWidth'], min: 0, max: 300)
      ..foreground = j['foreground'] == null
          ? null
          : EditorColor.fromJson(j['foreground'] as Map<String, dynamic>)
      ..overlay = j['overlay'] == null
          ? null
          : EditorColor.fromJson(j['overlay'] as Map<String, dynamic>)
      ..borderColor = j['borderColor'] == null
          ? null
          : EditorColor.fromJson(j['borderColor'] as Map<String, dynamic>)
      ..checkColor = j['checkColor'] == null
          ? null
          : EditorColor.fromJson(j['checkColor'] as Map<String, dynamic>)
      ..avatarColor = j['avatarColor'] == null
          ? null
          : EditorColor.fromJson(j['avatarColor'] as Map<String, dynamic>);
  }
}

HyperChipStyle resolveEditorChip(
  EditorComponent a,
  HyperColorScheme c,
) => HyperChipStyle(
  colorVariant: a.chipStyle.colorVariant == null
      ? null
      : HyperChipColorVariant.values.byName(a.chipStyle.colorVariant!),
  foregroundMode: a.chipStyle.foregroundMode == null
      ? null
      : HyperChipForegroundMode.values.byName(a.chipStyle.foregroundMode!),
  baseColor: a.chipStyle.baseColor?.resolve(c),
  backgroundFade: a.chipStyle.backgroundFade,
  borderFade: a.chipStyle.borderFade,
  foregroundFade: a.chipStyle.foregroundFade,
  showCheckmark: a.chipStyle.showCheckmark,
  checkmarkPlacement: a.chipStyle.checkPlacement == null
      ? null
      : HyperChipCheckmarkPlacement.values.byName(a.chipStyle.checkPlacement!),
  checkmarkIcon: _chipIcon(a.chipStyle.checkIcon),
  deleteIcon: _chipIcon(a.chipStyle.deleteIcon),
  background: switch (a.fillKind) {
    EditorFillKind.none => const HyperFill.none(),
    EditorFillKind.gradient =>
      a.gradient == null ? null : HyperFill.gradient(a.gradient!.resolve(c)),
    _ =>
      a.background == null ? null : HyperFill.color(a.background!.resolve(c)),
  },
  foregroundColor:
      a.chipStyle.foreground?.resolve(c) ?? a.foreground?.resolve(c),
  overlayColor: a.chipStyle.overlay?.resolve(c),
  borderColor: a.chipStyle.borderColor?.resolve(c),
  borderWidth: a.chipStyle.borderWidth,
  boxBorder: a.border.resolve(
    c,
    inherited: BorderSide(
      color:
          a.chipStyle.borderColor?.resolve(c) ??
          (a.chipStyle.colorVariant != null &&
                  a.chipStyle.colorVariant != 'neutral'
              ? Color.lerp(
                  a.chipStyle.baseColor?.resolve(c) ?? c.primary,
                  c.surface,
                  a.chipStyle.borderFade ??
                      (a.chipStyle.colorVariant == 'soft' ? .65 : 0),
                )!
              : c.outline),
      width: a.chipStyle.borderWidth ?? 1,
    ),
  ),
  textStyle: a.chipStyle.fontSize == null
      ? null
      : TextStyle(fontSize: a.chipStyle.fontSize),
  avatarOpacity: a.chipStyle.avatarOpacity,
  checkmarkScale: a.chipStyle.checkmarkScale,
  checkmarkColor: a.chipStyle.checkColor?.resolve(c),
  selectedAvatarColor: a.chipStyle.avatarColor?.resolve(c),
  duration: a.chipStyle.durationMilliseconds == null
      ? null
      : Duration(milliseconds: a.chipStyle.durationMilliseconds!.round()),
  boxShadow: a.shadows?.map((s) => s.resolve(c)).toList(),
);

IconData? _chipIcon(String? value) => switch (value) {
  'check' => Icons.check,
  'star' => Icons.star,
  'close' => Icons.close,
  'cancel' => Icons.cancel_outlined,
  'delete' => Icons.delete_outline,
  _ => null,
};
