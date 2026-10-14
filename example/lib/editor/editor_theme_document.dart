import 'editor_basic_control_fields.dart';
import 'editor_tag_fields.dart';
import 'editor_chip_fields.dart';
import 'editor_select_fields.dart';
import 'editor_text_field_fields.dart';

import 'dart:convert';

import 'editor_global_fields.dart';
import 'editor_button_fields.dart';

import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

void _checkFields(Map<String, dynamic> json, Set<String> fields) {
  final unknown = json.keys.where((key) => !fields.contains(key)).toList();
  if (unknown.isNotEmpty) {
    throw FormatException('本版不支持主题字段：${unknown.join(', ')}');
  }
}

/// 颜色保留语义引用，避免全局色修改后组件停留在旧色值。
class EditorColor {
  const EditorColor({this.semantic, this.argb});
  final String? semantic;
  final int? argb;
  Color resolve(HyperColorScheme colors) => switch (semantic) {
    'primary' => colors.primary,
    'surface' => colors.surface,
    'textPrimary' => colors.textPrimary,
    'outline' => colors.outline,
    _ => Color(argb!),
  };
  Map<String, Object?> toJson() => {
    if (semantic != null) 'semantic': semantic,
    if (argb != null) 'argb': argb,
  };
  factory EditorColor.fromJson(Map<String, dynamic> json) {
    _checkFields(json, {'semantic', 'argb'});
    final semantic = json['semantic'] as String?;
    final argb = json['argb'] as int?;
    if ((semantic == null) == (argb == null) ||
        (semantic != null &&
            ![
              'primary',
              'surface',
              'textPrimary',
              'outline',
            ].contains(semantic)) ||
        (argb != null && (argb < 0 || argb > 0xffffffff))) {
      throw const FormatException('颜色需要有效的语义引用或 ARGB 色值');
    }
    return EditorColor(semantic: semantic, argb: argb);
  }
}

/// 第一版可编辑的组件外观覆盖；未设置的字段不写入文件。
class EditorComponent {
  EditorComponent({this.background, this.foreground, this.shadows});
  EditorColor? background, foreground;
  EditorFillKind? fillKind;
  EditorGradient? gradient;
  EditorBorder border = EditorBorder();
  List<EditorShadow>? shadows;
  final hoveredShadow = EditorComponentShadow();
  final pressedShadow = EditorComponentShadow();
  final disabledShadow = EditorComponentShadow();
  final focusedShadow = EditorComponentShadow();
  EditorBadgeVisual badgeStyle = EditorBadgeVisual();
  EditorDividerVisual dividerStyle = EditorDividerVisual();
  EditorProgressVisual progressStyle = EditorProgressVisual();
  EditorRadioVisual radioStyle = EditorRadioVisual();
  EditorCheckboxVisual checkboxStyle = EditorCheckboxVisual();
  EditorSwitchVisual switchStyle = EditorSwitchVisual();
  EditorTagVisual tagStyle = EditorTagVisual();
  EditorChipVisual chipStyle = EditorChipVisual();
  EditorSelectVisual selectStyle = EditorSelectVisual();
  EditorTextFieldVisual textFieldStyle = EditorTextFieldVisual();
  EditorButtonVisual buttonStyle = EditorButtonVisual();
  Map<String, Object?> toJson() => {
    if (dividerStyle.toJson().isNotEmpty) 'dividerStyle': dividerStyle.toJson(),
    if (progressStyle.toJson().isNotEmpty)
      'progressStyle': progressStyle.toJson(),
    if (radioStyle.toJson().isNotEmpty) 'radioStyle': radioStyle.toJson(),
    if (checkboxStyle.toJson().isNotEmpty)
      'checkboxStyle': checkboxStyle.toJson(),
    if (switchStyle.toJson().isNotEmpty) 'switchStyle': switchStyle.toJson(),
    if (badgeStyle.toJson().isNotEmpty) 'badgeStyle': badgeStyle.toJson(),
    if (tagStyle.toJson().isNotEmpty) 'tagStyle': tagStyle.toJson(),
    if (chipStyle.toJson().isNotEmpty) 'chipStyle': chipStyle.toJson(),
    if (selectStyle.toJson().isNotEmpty) 'selectStyle': selectStyle.toJson(),
    if (fillKind != null) 'fillKind': fillKind!.name,
    if (gradient != null) 'gradient': gradient!.toJson(),
    if (border.toJson().isNotEmpty) 'border': border.toJson(),
    if (textFieldStyle.toJson().isNotEmpty)
      'textFieldStyle': textFieldStyle.toJson(),
    if (buttonStyle.toJson().isNotEmpty) 'buttonStyle': buttonStyle.toJson(),
    if (background != null) 'background': background!.toJson(),
    if (foreground != null) 'foreground': foreground!.toJson(),
    if (hoveredShadow.shadows != null)
      'hoveredShadows': [for (final s in hoveredShadow.shadows!) s.toJson()],
    if (pressedShadow.shadows != null)
      'pressedShadows': [for (final s in pressedShadow.shadows!) s.toJson()],
    if (disabledShadow.shadows != null)
      'disabledShadows': [for (final s in disabledShadow.shadows!) s.toJson()],
    if (focusedShadow.shadows != null)
      'focusedShadows': [for (final s in focusedShadow.shadows!) s.toJson()],
    if (shadows != null) 'shadows': [for (final s in shadows!) s.toJson()],
  };
  factory EditorComponent.fromJson(Map<String, dynamic> json) {
    _checkFields(json, {
      'badgeStyle',
      'dividerStyle',
      'progressStyle',
      'radioStyle',
      'checkboxStyle',
      'switchStyle',
      'tagStyle',
      'chipStyle',
      'selectStyle',
      'background',
      'foreground',
      'shadows',
      'hoveredShadows',
      'pressedShadows',
      'disabledShadows',
      'focusedShadows',
      'buttonStyle',
      'textFieldStyle',
      'fillKind',
      'gradient',
      'border',
    });
    if (json['fillKind'] != null &&
        !EditorFillKind.values.any((v) => v.name == json['fillKind'])) {
      throw const FormatException('不支持的背景类型');
    }
    return EditorComponent(
        background: json['background'] == null
            ? null
            : EditorColor.fromJson(json['background'] as Map<String, dynamic>),
        foreground: json['foreground'] == null
            ? null
            : EditorColor.fromJson(json['foreground'] as Map<String, dynamic>),
        shadows: (json['shadows'] as List<dynamic>?)
            ?.map(
              (dynamic s) => EditorShadow.fromJson(s as Map<String, dynamic>),
            )
            .toList(),
      )
      ..hoveredShadow.shadows = (json['hoveredShadows'] as List<dynamic>?)
          ?.map((s) => EditorShadow.fromJson(s as Map<String, dynamic>))
          .toList()
      ..pressedShadow.shadows = (json['pressedShadows'] as List<dynamic>?)
          ?.map((s) => EditorShadow.fromJson(s as Map<String, dynamic>))
          .toList()
      ..disabledShadow.shadows = (json['disabledShadows'] as List<dynamic>?)
          ?.map((s) => EditorShadow.fromJson(s as Map<String, dynamic>))
          .toList()
      ..focusedShadow.shadows = (json['focusedShadows'] as List<dynamic>?)
          ?.map((s) => EditorShadow.fromJson(s as Map<String, dynamic>))
          .toList()
      ..badgeStyle = EditorBadgeVisual.fromJson(
        (json['badgeStyle'] as Map<String, dynamic>?) ?? {},
      )
      ..dividerStyle = EditorDividerVisual.fromJson(
        (json['dividerStyle'] as Map<String, dynamic>?) ?? {},
      )
      ..progressStyle = EditorProgressVisual.fromJson(
        (json['progressStyle'] as Map<String, dynamic>?) ?? {},
      )
      ..radioStyle = EditorRadioVisual.fromJson(
        (json['radioStyle'] as Map<String, dynamic>?) ?? {},
      )
      ..checkboxStyle = EditorCheckboxVisual.fromJson(
        (json['checkboxStyle'] as Map<String, dynamic>?) ?? {},
      )
      ..switchStyle = EditorSwitchVisual.fromJson(
        (json['switchStyle'] as Map<String, dynamic>?) ?? {},
      )
      ..tagStyle = EditorTagVisual.fromJson(
        (json['tagStyle'] as Map<String, dynamic>?) ?? {},
      )
      ..chipStyle = EditorChipVisual.fromJson(
        (json['chipStyle'] as Map<String, dynamic>?) ?? {},
      )
      ..selectStyle = EditorSelectVisual.fromJson(
        (json['selectStyle'] as Map<String, dynamic>?) ?? {},
      )
      ..fillKind = json['fillKind'] == null
          ? null
          : EditorFillKind.values.byName(json['fillKind'] as String)
      ..gradient = json['gradient'] == null
          ? null
          : EditorGradient.fromJson(json['gradient'] as Map<String, dynamic>)
      ..border = EditorBorder.fromJson(
        (json['border'] as Map<String, dynamic>?) ?? {},
      )
      ..textFieldStyle = EditorTextFieldVisual.fromJson(
        (json['textFieldStyle'] as Map<String, dynamic>?) ?? {},
      )
      ..buttonStyle = EditorButtonVisual.fromJson(
        (json['buttonStyle'] as Map<String, dynamic>?) ?? {},
      );
  }
}

/// 按钮六种变体使用独立的强类型外观字段。
class EditorButtonVariants {
  EditorComponent filled = EditorComponent(),
      tonal = EditorComponent(),
      outlined = EditorComponent(),
      ghost = EditorComponent(),
      text = EditorComponent(),
      gradient = EditorComponent();
  EditorComponent forVariant(HyperButtonVariant variant) => switch (variant) {
    HyperButtonVariant.filled => filled,
    HyperButtonVariant.tonal => tonal,
    HyperButtonVariant.outlined => outlined,
    HyperButtonVariant.ghost => ghost,
    HyperButtonVariant.text => text,
    HyperButtonVariant.gradient => gradient,
  };
  Map<String, Object?> toJson() => {
    for (final variant in HyperButtonVariant.values)
      if (forVariant(variant).toJson().isNotEmpty)
        variant.name: forVariant(variant).toJson(),
  };
  factory EditorButtonVariants.fromJson(Map<String, dynamic> json) {
    _checkFields(json, HyperButtonVariant.values.map((v) => v.name).toSet());
    EditorComponent read(String name) =>
        EditorComponent.fromJson((json[name] as Map<String, dynamic>?) ?? {});
    return EditorButtonVariants()
      ..filled = read('filled')
      ..tonal = read('tonal')
      ..outlined = read('outlined')
      ..ghost = read('ghost')
      ..text = read('text')
      ..gradient = read('gradient');
  }
  EditorButtonVariants();
}

class EditorComponentShadow {
  List<EditorShadow>? shadows;
}

class EditorShadow {
  EditorShadow({
    this.color = const EditorColor(semantic: 'primary'),
    this.opacity = .2,
    this.dx = 0,
    this.dy = 4,
    this.blur = 16,
    this.spread = 0,
  });
  EditorColor color;
  double opacity, dx, dy, blur, spread;
  BoxShadow resolve(HyperColorScheme colors) {
    final resolved = color.resolve(colors);
    return BoxShadow(
      color: resolved.withValues(alpha: resolved.a * opacity),
      offset: Offset(dx, dy),
      blurRadius: blur,
      spreadRadius: spread,
    );
  }

  Map<String, Object?> toJson() => {
    'color': color.toJson(),
    'opacity': opacity,
    'dx': dx,
    'dy': dy,
    'blur': blur,
    'spread': spread,
  };
  factory EditorShadow.fromJson(Map<String, dynamic> j) {
    _checkFields(j, {'color', 'opacity', 'dx', 'dy', 'blur', 'spread'});
    return EditorShadow(
      color: EditorColor.fromJson(j['color'] as Map<String, dynamic>),
      opacity: number(j['opacity'], min: 0, max: 1)!,
      dx: number(j['dx'])!,
      dy: number(j['dy'])!,
      blur: number(j['blur'], min: 0)!,
      spread: number(j['spread'])!,
    );
  }
}

/// 当前设备的显式规格覆盖，默认值始终来自 Hyper 主题。
class EditorDevice {
  EditorBadgeMetrics badgeMetrics = EditorBadgeMetrics();
  EditorDividerMetrics dividerMetrics = EditorDividerMetrics();
  EditorProgressMetrics progressMetrics = EditorProgressMetrics();
  EditorRadioMetrics radioMetrics = EditorRadioMetrics();
  EditorCheckboxMetrics checkboxMetrics = EditorCheckboxMetrics();
  EditorSwitchMetrics switchMetrics = EditorSwitchMetrics();
  EditorTagMetrics tagMetrics = EditorTagMetrics();
  EditorChipMetrics chipMetrics = EditorChipMetrics();
  EditorSelectMetrics selectMetrics = EditorSelectMetrics();
  EditorTextFieldMetrics textFieldMetrics = EditorTextFieldMetrics();
  EditorButtonMetrics buttonMetrics = EditorButtonMetrics();
  EditorTypography typography = EditorTypography();
  EditorLayout layout = EditorLayout();
  double? body,
      control,
      buttonHeight,
      buttonRadius,
      cardRadius,
      fieldHeight,
      fieldRadius,
      menuHeight,
      menuRadius;
  Map<String, Object?> toJson() => {
    if (badgeMetrics.toJson().isNotEmpty) 'badgeMetrics': badgeMetrics.toJson(),
    if (dividerMetrics.toJson().isNotEmpty)
      'dividerMetrics': dividerMetrics.toJson(),
    if (progressMetrics.toJson().isNotEmpty)
      'progressMetrics': progressMetrics.toJson(),
    if (radioMetrics.toJson().isNotEmpty) 'radioMetrics': radioMetrics.toJson(),
    if (checkboxMetrics.toJson().isNotEmpty)
      'checkboxMetrics': checkboxMetrics.toJson(),
    if (switchMetrics.toJson().isNotEmpty)
      'switchMetrics': switchMetrics.toJson(),
    if (tagMetrics.toJson().isNotEmpty) 'tagMetrics': tagMetrics.toJson(),
    if (chipMetrics.toJson().isNotEmpty) 'chipMetrics': chipMetrics.toJson(),
    if (selectMetrics.toJson().isNotEmpty)
      'selectMetrics': selectMetrics.toJson(),
    if (textFieldMetrics.toJson().isNotEmpty)
      'textFieldMetrics': textFieldMetrics.toJson(),
    if (buttonMetrics.toJson().isNotEmpty)
      'buttonMetrics': buttonMetrics.toJson(),
    if (typography.toJson().isNotEmpty) 'typography': typography.toJson(),
    if (layout.toJson().isNotEmpty) 'layout': layout.toJson(),
    if (body != null) 'body': body,
    if (control != null) 'control': control,
    if (buttonHeight != null) 'buttonHeight': buttonHeight,
    if (buttonRadius != null) 'buttonRadius': buttonRadius,
    if (cardRadius != null) 'cardRadius': cardRadius,
    if (fieldHeight != null) 'fieldHeight': fieldHeight,
    if (fieldRadius != null) 'fieldRadius': fieldRadius,
    if (menuHeight != null) 'menuHeight': menuHeight,
    if (menuRadius != null) 'menuRadius': menuRadius,
  };
  factory EditorDevice.fromJson(Map<String, dynamic> j) {
    _checkFields(j, {
      'typography',
      'buttonMetrics',
      'badgeMetrics',
      'dividerMetrics',
      'progressMetrics',
      'radioMetrics',
      'checkboxMetrics',
      'switchMetrics',
      'tagMetrics',
      'chipMetrics',
      'selectMetrics',
      'textFieldMetrics',
      'layout',
      'body',
      'control',
      'buttonHeight',
      'buttonRadius',
      'cardRadius',
      'fieldHeight',
      'fieldRadius',
      'menuHeight',
      'menuRadius',
    });
    return EditorDevice()
      ..badgeMetrics = EditorBadgeMetrics.fromJson(
        (j['badgeMetrics'] as Map<String, dynamic>?) ?? {},
      )
      ..dividerMetrics = EditorDividerMetrics.fromJson(
        (j['dividerMetrics'] as Map<String, dynamic>?) ?? {},
      )
      ..progressMetrics = EditorProgressMetrics.fromJson(
        (j['progressMetrics'] as Map<String, dynamic>?) ?? {},
      )
      ..radioMetrics = EditorRadioMetrics.fromJson(
        (j['radioMetrics'] as Map<String, dynamic>?) ?? {},
      )
      ..checkboxMetrics = EditorCheckboxMetrics.fromJson(
        (j['checkboxMetrics'] as Map<String, dynamic>?) ?? {},
      )
      ..switchMetrics = EditorSwitchMetrics.fromJson(
        (j['switchMetrics'] as Map<String, dynamic>?) ?? {},
      )
      ..tagMetrics = EditorTagMetrics.fromJson(
        (j['tagMetrics'] as Map<String, dynamic>?) ?? {},
      )
      ..chipMetrics = EditorChipMetrics.fromJson(
        (j['chipMetrics'] as Map<String, dynamic>?) ?? {},
      )
      ..selectMetrics = EditorSelectMetrics.fromJson(
        (j['selectMetrics'] as Map<String, dynamic>?) ?? {},
      )
      ..textFieldMetrics = EditorTextFieldMetrics.fromJson(
        (j['textFieldMetrics'] as Map<String, dynamic>?) ?? {},
      )
      ..buttonMetrics = EditorButtonMetrics.fromJson(
        (j['buttonMetrics'] as Map<String, dynamic>?) ?? {},
      )
      ..typography = EditorTypography.fromJson(
        (j['typography'] as Map<String, dynamic>?) ?? {},
      )
      ..layout = EditorLayout.fromJson(
        (j['layout'] as Map<String, dynamic>?) ?? {},
      )
      ..body = number(j['body'], min: 8, max: 64)
      ..control = number(j['control'], min: 8, max: 64)
      ..buttonHeight = number(j['buttonHeight'], min: 20, max: 120)
      ..buttonRadius = number(j['buttonRadius'], min: 0, max: 60)
      ..cardRadius = number(j['cardRadius'], min: 0, max: 60)
      ..fieldHeight = number(j['fieldHeight'], min: 20, max: 120)
      ..fieldRadius = number(j['fieldRadius'], min: 0, max: 60)
      ..menuHeight = number(j['menuHeight'], min: 20, max: 120)
      ..menuRadius = number(j['menuRadius'], min: 0, max: 60);
  }
  EditorDevice();
}

double? number(dynamic value, {double? min, double? max}) {
  if (value == null) return null;
  if (value is! num ||
      !value.isFinite ||
      (min != null && value < min) ||
      (max != null && value > max)) {
    throw const FormatException('主题数值不合法');
  }
  return value.toDouble();
}

/// 亮暗方案独立编辑，共享一套四端布局规格。
class EditorMode {
  String? fontFamily;
  final materialAppearance = EditorComponent();
  EditorColor? materialTint, materialBorder;
  double? materialBorderWidth;
  EditorBehavior behavior = EditorBehavior();
  EditorPalette palette = EditorPalette();
  int? seed;
  HyperSurfaceMaterialKind? material;
  double? opacity, blur, blurY;
  final button = EditorComponent();
  EditorButtonVariants buttonVariants = EditorButtonVariants();
  final tag = EditorComponent();
  final tagEmphasized = EditorComponent();
  final tagDisabled = EditorComponent();
  final chip = EditorComponent();
  final chipSelected = EditorComponent();
  final chipHovered = EditorComponent();
  final chipFocused = EditorComponent();
  final chipPressed = EditorComponent();
  final chipDisabled = EditorComponent();
  final badge = EditorComponent();
  final divider = EditorComponent();
  final progress = EditorComponent();
  final progressLinear = EditorComponent();
  final progressCircular = EditorComponent();
  final progressInfinite = EditorComponent();
  final radio = EditorComponent();
  final radioCheckmark = EditorComponent();
  final radioCircle = EditorComponent();
  final radioFilled = EditorComponent();
  final checkbox = EditorComponent();
  final checkboxCircle = EditorComponent();
  final checkboxRounded = EditorComponent();
  final switchControl = EditorComponent();
  final card = EditorComponent();
  final field = EditorComponent();
  final menu = EditorComponent();
  final select = EditorComponent(), selectAnchor = EditorComponent();
  Map<String, Object?> toJson() => {
    if (fontFamily != null) 'fontFamily': fontFamily,
    if (materialAppearance.toJson().isNotEmpty)
      'materialAppearance': materialAppearance.toJson(),
    if (materialTint != null) 'materialTint': materialTint!.toJson(),
    if (materialBorder != null) 'materialBorder': materialBorder!.toJson(),
    if (materialBorderWidth != null) 'materialBorderWidth': materialBorderWidth,
    if (behavior.toJson().isNotEmpty) 'behavior': behavior.toJson(),
    if (palette.toJson().isNotEmpty) 'palette': palette.toJson(),
    if (seed != null && seed != 0xff3482ff) 'seed': seed,
    if (material != null) 'material': material!.name,
    if (opacity != null) 'opacity': opacity,
    if (blur != null) 'blur': blur,
    if (blurY != null) 'blurY': blurY,
    if (button.toJson().isNotEmpty) 'button': button.toJson(),
    if (buttonVariants.toJson().isNotEmpty)
      'buttonVariants': buttonVariants.toJson(),
    if (tag.toJson().isNotEmpty) 'tag': tag.toJson(),
    if (tagEmphasized.toJson().isNotEmpty)
      'tagEmphasized': tagEmphasized.toJson(),
    if (tagDisabled.toJson().isNotEmpty) 'tagDisabled': tagDisabled.toJson(),
    if (chip.toJson().isNotEmpty) 'chip': chip.toJson(),
    if (chipSelected.toJson().isNotEmpty) 'chipSelected': chipSelected.toJson(),
    if (chipHovered.toJson().isNotEmpty) 'chipHovered': chipHovered.toJson(),
    if (chipFocused.toJson().isNotEmpty) 'chipFocused': chipFocused.toJson(),
    if (chipPressed.toJson().isNotEmpty) 'chipPressed': chipPressed.toJson(),
    if (chipDisabled.toJson().isNotEmpty) 'chipDisabled': chipDisabled.toJson(),
    if (badge.toJson().isNotEmpty) 'badge': badge.toJson(),
    if (divider.toJson().isNotEmpty) 'divider': divider.toJson(),
    if (progress.toJson().isNotEmpty) 'progress': progress.toJson(),
    if (progressLinear.toJson().isNotEmpty)
      'progressLinear': progressLinear.toJson(),
    if (progressCircular.toJson().isNotEmpty)
      'progressCircular': progressCircular.toJson(),
    if (progressInfinite.toJson().isNotEmpty)
      'progressInfinite': progressInfinite.toJson(),
    if (radio.toJson().isNotEmpty) 'radio': radio.toJson(),
    if (radioCheckmark.toJson().isNotEmpty)
      'radioCheckmark': radioCheckmark.toJson(),
    if (radioCircle.toJson().isNotEmpty) 'radioCircle': radioCircle.toJson(),
    if (radioFilled.toJson().isNotEmpty) 'radioFilled': radioFilled.toJson(),
    if (checkbox.toJson().isNotEmpty) 'checkbox': checkbox.toJson(),
    if (checkboxCircle.toJson().isNotEmpty)
      'checkboxCircle': checkboxCircle.toJson(),
    if (checkboxRounded.toJson().isNotEmpty)
      'checkboxRounded': checkboxRounded.toJson(),
    if (switchControl.toJson().isNotEmpty)
      'switchControl': switchControl.toJson(),
    if (card.toJson().isNotEmpty) 'card': card.toJson(),
    if (field.toJson().isNotEmpty) 'field': field.toJson(),
    if (select.toJson().isNotEmpty) 'select': select.toJson(),
    if (selectAnchor.toJson().isNotEmpty) 'selectAnchor': selectAnchor.toJson(),
    if (menu.toJson().isNotEmpty) 'menu': menu.toJson(),
  };
  EditorMode();
  factory EditorMode.fromJson(Map<String, dynamic> j) {
    _checkFields(j, {
      'fontFamily',
      'materialAppearance',
      'materialTint',
      'materialBorder',
      'materialBorderWidth',
      'palette',
      'behavior',
      'seed',
      'material',
      'opacity',
      'blur',
      'blurY',
      'button',
      'buttonVariants',
      'tag',
      'tagEmphasized',
      'tagDisabled',
      'chip',
      'chipSelected',
      'chipHovered',
      'chipFocused',
      'chipPressed',
      'chipDisabled',
      'badge',
      'divider',
      'progress',
      'progressLinear',
      'progressCircular',
      'progressInfinite',
      'radio',
      'radioCheckmark',
      'radioCircle',
      'radioFilled',
      'checkbox',
      'checkboxCircle',
      'checkboxRounded',
      'switchControl',
      'card',
      'field',
      'select',
      'selectAnchor',
      'menu',
    });
    final result = EditorMode()
      ..buttonVariants = EditorButtonVariants.fromJson(
        (j['buttonVariants'] as Map<String, dynamic>?) ?? {},
      )
      ..behavior = EditorBehavior.fromJson(
        (j['behavior'] as Map<String, dynamic>?) ?? {},
      )
      ..palette = EditorPalette.fromJson(
        (j['palette'] as Map<String, dynamic>?) ?? {},
      )
      ..fontFamily = j['fontFamily'] as String?
      ..materialTint = j['materialTint'] == null
          ? null
          : EditorColor.fromJson(j['materialTint'] as Map<String, dynamic>)
      ..materialBorder = j['materialBorder'] == null
          ? null
          : EditorColor.fromJson(j['materialBorder'] as Map<String, dynamic>)
      ..materialBorderWidth = number(j['materialBorderWidth'], min: 0, max: 20)
      ..seed = j['seed'] as int?
      ..material = j['material'] == null
          ? null
          : HyperSurfaceMaterialKind.values.byName(j['material'] as String)
      ..opacity = number(j['opacity'], min: 0, max: 1)
      ..blur = number(j['blur'], min: 0, max: 80)
      ..blurY = number(j['blurY'], min: 0, max: 80);
    if (result.seed != null &&
        (result.seed! < 0 || result.seed! > 0xffffffff)) {
      throw const FormatException('主题色色值不合法');
    }
    void read(String key, EditorComponent target) {
      if (j[key] == null) return;
      final value = EditorComponent.fromJson(j[key] as Map<String, dynamic>);
      target.background = value.background;
      target.foreground = value.foreground;
      target.shadows = value.shadows;
      target.hoveredShadow.shadows = value.hoveredShadow.shadows;
      target.pressedShadow.shadows = value.pressedShadow.shadows;
      target.disabledShadow.shadows = value.disabledShadow.shadows;
      target.focusedShadow.shadows = value.focusedShadow.shadows;
      target.buttonStyle = value.buttonStyle;
      target.textFieldStyle = value.textFieldStyle;
      target.selectStyle = value.selectStyle;
      target.badgeStyle = value.badgeStyle;
      target.dividerStyle = value.dividerStyle;
      target.progressStyle = value.progressStyle;
      target.radioStyle = value.radioStyle;
      target.checkboxStyle = value.checkboxStyle;
      target.switchStyle = value.switchStyle;
      target.tagStyle = value.tagStyle;
      target.chipStyle = value.chipStyle;
      target.fillKind = value.fillKind;
      target.gradient = value.gradient;
      target.border = value.border;
    }

    read('materialAppearance', result.materialAppearance);
    read('button', result.button);
    read('tag', result.tag);
    read('tagEmphasized', result.tagEmphasized);
    read('tagDisabled', result.tagDisabled);
    read('chip', result.chip);
    read('chipSelected', result.chipSelected);
    read('chipHovered', result.chipHovered);
    read('chipFocused', result.chipFocused);
    read('chipPressed', result.chipPressed);
    read('chipDisabled', result.chipDisabled);
    read('badge', result.badge);
    read('divider', result.divider);
    read('progress', result.progress);
    read('progressLinear', result.progressLinear);
    read('progressCircular', result.progressCircular);
    read('progressInfinite', result.progressInfinite);
    read('radio', result.radio);
    read('radioCheckmark', result.radioCheckmark);
    read('radioCircle', result.radioCircle);
    read('radioFilled', result.radioFilled);
    read('checkbox', result.checkbox);
    read('checkboxCircle', result.checkboxCircle);
    read('checkboxRounded', result.checkboxRounded);
    read('switchControl', result.switchControl);
    read('card', result.card);
    read('field', result.field);
    read('menu', result.menu);
    read('select', result.select);
    read('selectAnchor', result.selectAnchor);
    return result;
  }
}

/// 主题文件只保存编辑器开放字段的覆盖，不保存展开状态或设备画布。
class EditorThemeDocument {
  static final _defaultTheme = HyperThemeData.light();
  EditorThemeDocument({this.name = '未命名主题'});
  String name;
  EditorMode light = EditorMode(), dark = EditorMode();
  EditorDevice phone = EditorDevice(),
      tablet = EditorDevice(),
      desktop = EditorDevice(),
      watch = EditorDevice();
  EditorMode mode(bool isDark) => isDark ? dark : light;
  EditorDevice device(HyperDeviceType type) => switch (type) {
    HyperDeviceType.phone => phone,
    HyperDeviceType.tablet => tablet,
    HyperDeviceType.desktop => desktop,
    HyperDeviceType.watch => watch,
  };
  Map<String, Object?> _deviceJson(HyperDeviceType type) {
    final values = device(type).toJson();
    final base = _defaultTheme;
    final sizes = base.sizes.resolve(type);
    final typo = base.typographyTheme.resolve(type);
    final defaults = <String, double>{
      'body': typo.body,
      'control': typo.control,
      'buttonHeight': sizes.button.minimumSize.height,
      'buttonRadius': sizes.button.radius,
      'cardRadius': sizes.card.radius,
      'fieldHeight': sizes.textField.minimumHeight,
      'fieldRadius': sizes.textField.radius,
      'menuHeight': sizes.menu.itemHeight,
      'menuRadius': sizes.menu.surfaceRadius,
    };
    values.removeWhere((key, value) => value == defaults[key]);
    return values;
  }

  Map<String, Object?> toJson() => {
    'formatVersion': 1,
    'base': 'lemon-hyper-v1',
    'name': name,
    if (light.toJson().isNotEmpty) 'light': light.toJson(),
    if (dark.toJson().isNotEmpty) 'dark': dark.toJson(),
    'devices': {
      for (final type in HyperDeviceType.values)
        if (_deviceJson(type).isNotEmpty) type.name: _deviceJson(type),
    },
  };
  String encode() => const JsonEncoder.withIndent('  ').convert(toJson());
  factory EditorThemeDocument.decode(String source) {
    final j = jsonDecode(source) as Map<String, dynamic>;
    _checkFields(j, {
      'formatVersion',
      'base',
      'name',
      'light',
      'dark',
      'devices',
    });
    if (j['formatVersion'] != 1 || j['base'] != 'lemon-hyper-v1') {
      throw const FormatException('不支持的主题格式或基础版本');
    }
    final d = EditorThemeDocument(name: j['name'] as String);
    d.light = EditorMode.fromJson((j['light'] as Map<String, dynamic>?) ?? {});
    d.dark = EditorMode.fromJson((j['dark'] as Map<String, dynamic>?) ?? {});
    final devices = (j['devices'] as Map<String, dynamic>?) ?? {};
    _checkFields(devices, {'phone', 'tablet', 'desktop', 'watch'});
    d.phone = EditorDevice.fromJson(
      (devices['phone'] as Map<String, dynamic>?) ?? {},
    );
    d.tablet = EditorDevice.fromJson(
      (devices['tablet'] as Map<String, dynamic>?) ?? {},
    );
    d.desktop = EditorDevice.fromJson(
      (devices['desktop'] as Map<String, dynamic>?) ?? {},
    );
    d.watch = EditorDevice.fromJson(
      (devices['watch'] as Map<String, dynamic>?) ?? {},
    );
    for (final type in HyperDeviceType.values) {
      d
          .device(type)
          .switchMetrics
          .resolve(_defaultTheme.sizes.resolve(type).switchSize);
    }
    return d;
  }

  /// 关联尺寸同时检查；导入和编辑事务使用同一校验路径。
  void validateControlGeometry() {
    for (final type in HyperDeviceType.values) {
      device(type).switchMetrics
          .resolve(_defaultTheme.sizes.resolve(type).switchSize);
    }
  }

  HyperThemeData resolve(bool isDark) {
    final m = mode(isDark);
    var theme = HyperThemeData.fromSeed(
      seedColor: Color(m.seed ?? 0xff3482ff),
      brightness: isDark ? Brightness.dark : Brightness.light,
    );
    HyperSizeScheme sizes(HyperDeviceType type) {
      final s = theme.sizes.resolve(type), d = device(type);
      return d.layout.resolve(
        s.copyWith(
          button: d.buttonMetrics.resolve(
            s.button.copyWith(
              minimumSize: Size(
                s.button.minimumSize.width,
                d.buttonHeight ?? s.button.minimumSize.height,
              ),
              radius: d.buttonRadius,
            ),
          ),
          select: s.select.copyWith(
            itemHeight: d.selectMetrics.itemHeight,
            itemPadding: d.selectMetrics.itemPadding,
            itemSpacing: d.selectMetrics.itemSpacing,
            itemRadius: d.selectMetrics.itemRadius,
            surfaceRadius: d.selectMetrics.surfaceRadius,
            minimumHeight: d.selectMetrics.minimumHeight,
            paddingHorizontal: d.selectMetrics.paddingHorizontal,
            paddingVertical: d.selectMetrics.paddingVertical,
            radius: d.selectMetrics.radius,
            minimumTapTargetSize: d.selectMetrics.minimumTapTargetSize,
            popupSpacing: d.selectMetrics.popupSpacing,
            width: d.selectMetrics.width,
            arrowSize: d.selectMetrics.arrowSize,
            arrowSpacing: d.selectMetrics.arrowSpacing,
          ),
          selection: s.selection.copyWith(
            maxPanelHeight: d.selectMetrics.maxPanelHeight,
            chipSpacing: d.selectMetrics.chipSpacing,
            minimumInputWidth: d.selectMetrics.minimumInputWidth,
          ),
          badge: d.badgeMetrics.resolve(s.badge),
          divider: d.dividerMetrics.resolve(s.divider),
          progress: d.progressMetrics.resolve(s.progress),
          radio: d.radioMetrics.resolve(s.radio),
          checkbox: d.checkboxMetrics.resolve(s.checkbox),
          switchSize: d.switchMetrics.resolve(s.switchSize),
          tag: s.tag.copyWith(
            height: d.tagMetrics.height,
            horizontalPadding: d.tagMetrics.horizontalPadding,
            radius: d.tagMetrics.radius,
            iconSize: d.tagMetrics.iconSize,
            iconSpacing: d.tagMetrics.iconSpacing,
          ),
          chip: s.chip.copyWith(
            height: d.chipMetrics.height,
            horizontalPadding: d.chipMetrics.horizontalPadding,
            radius: d.chipMetrics.radius,
            iconSize: d.chipMetrics.iconSize,
            iconSpacing: d.chipMetrics.iconSpacing,
            avatarSize: d.chipMetrics.avatarSize,
            deleteIconSize: d.chipMetrics.deleteIconSize,
            deleteTargetWidth: d.chipMetrics.deleteTargetWidth,
          ),
          card: s.card.copyWith(radius: d.cardRadius),
          textField: d.textFieldMetrics
              .resolve(s.textField)
              .copyWith(minimumHeight: d.fieldHeight, radius: d.fieldRadius),
          menu: s.menu.copyWith(
            itemHeight: d.menuHeight,
            surfaceRadius: d.menuRadius,
          ),
        ),
      );
    }

    HyperTypographyScheme typo(HyperDeviceType type) {
      final d = device(type);
      return d.typography.resolve(
        theme.typographyTheme
            .resolve(type)
            .copyWith(body: d.body, control: d.control),
      );
    }

    theme = theme.copyWith(colors: m.palette.resolve(theme.colors));
    final colors = theme.colors;
    HyperFill? background(EditorComponent c) => switch (c.fillKind) {
      EditorFillKind.none => const HyperFill.none(),
      EditorFillKind.gradient => HyperFill.gradient(
        (c.gradient ??
                EditorGradient(
                  colors: [
                    const EditorColor(semantic: 'primary'),
                    const EditorColor(semantic: 'surface'),
                  ],
                  stops: [0, 1],
                ))
            .resolve(colors),
      ),
      EditorFillKind.solid => HyperFill.color(
        c.background?.resolve(colors) ?? colors.surface,
      ),
      null =>
        c.background == null
            ? null
            : HyperFill.color(c.background!.resolve(colors)),
    };
    HyperRadioStyle controlRadio(EditorComponent c) => c.radioStyle
        .resolve(colors)
        .merge(
          HyperRadioStyle(
            boxShadow: c.shadows?.map((s) => s.resolve(colors)).toList(),
          ),
        );
    HyperCheckboxStyle controlCheckbox(EditorComponent c) => c.checkboxStyle
        .resolve(colors)
        .merge(
          HyperCheckboxStyle(
            boxShadow: c.shadows?.map((s) => s.resolve(colors)).toList(),
          ),
        );
    final b = m.button, c = m.card, f = m.field, n = m.menu;
    HyperButtonStyle variantStyle(HyperButtonVariant variant) {
      final value = m.buttonVariants.forVariant(variant);
      final accent = b.fillKind == null ? b.background?.resolve(colors) : null;
      final accentStyle = accent == null
          ? HyperButtonStyle()
          : switch (variant) {
              HyperButtonVariant.filled => HyperButtonStyle(
                background: HyperFill.color(accent),
              ),
              HyperButtonVariant.tonal => HyperButtonStyle(
                background: HyperFill.color(
                  Color.alphaBlend(
                    accent.withValues(alpha: .08),
                    colors.surface,
                  ),
                ),
              ),
              HyperButtonVariant.outlined || HyperButtonVariant.text =>
                HyperButtonStyle(foregroundColor: accent),
              HyperButtonVariant.ghost => HyperButtonStyle(),
              HyperButtonVariant.gradient => HyperButtonStyle(
                background: HyperFill.gradient(
                  LinearGradient(
                    colors: [accent, Color.lerp(accent, colors.error, .45)!],
                  ),
                ),
              ),
            };
      return (theme.buttonTheme.styleFor(variant) ?? HyperButtonStyle())
          .merge(accentStyle)
          .merge(
            HyperButtonStyle(
              background: background(value),
              foregroundColor: value.foreground?.resolve(colors),
              boxShadow: value.shadows?.map((s) => s.resolve(colors)).toList(),
              boxBorder: value.border.resolve(
                colors,
                inherited: value.buttonStyle.resolve(colors).border,
              ),
            ),
          )
          .merge(value.buttonStyle.resolve(colors))
          .merge(
            HyperButtonStyle(
              hoveredBoxShadow: value.hoveredShadow.shadows
                  ?.map((s) => s.resolve(colors))
                  .toList(),
              pressedBoxShadow: value.pressedShadow.shadows
                  ?.map((s) => s.resolve(colors))
                  .toList(),
              disabledBoxShadow: value.disabledShadow.shadows
                  ?.map((s) => s.resolve(colors))
                  .toList(),
              focusedBoxShadow: value.focusedShadow.shadows
                  ?.map((s) => s.resolve(colors))
                  .toList(),
            ),
          );
    }

    final bg = HyperFill.color(
      (m.materialAppearance.background?.resolve(colors) ?? colors.surface)
          .withValues(
            alpha:
                m.opacity ??
                (m.material == HyperSurfaceMaterialKind.solid ? 1 : .75),
          ),
    );
    final material =
        (switch (m.material) {
          null => null,
          HyperSurfaceMaterialKind.solid => HyperSurfaceMaterial.solid(
            background: bg,
          ),
          HyperSurfaceMaterialKind.translucent =>
            HyperSurfaceMaterial.translucent(background: bg),
          HyperSurfaceMaterialKind.frostedGlass =>
            HyperSurfaceMaterial.frostedGlass(
              background: bg,
              blurSigmaX: m.blur ?? 20,
              blurSigmaY: m.blurY ?? m.blur ?? 20,
            ),
          HyperSurfaceMaterialKind.softLightGlass =>
            HyperSurfaceMaterial.softLightGlass(
              background: bg,
              blurSigmaX: m.blur ?? 28,
              blurSigmaY: m.blurY ?? m.blur ?? 28,
            ),
        })?.copyWith(
          tint: m.materialTint?.resolve(colors),
          border: m.materialBorder == null && m.materialBorderWidth == null
              ? null
              : m.materialBorderWidth == 0
              ? BorderSide.none
              : BorderSide(
                  color: m.materialBorder?.resolve(colors) ?? colors.outline,
                  width: m.materialBorderWidth ?? 1,
                ),
          boxShadow:
              m.materialAppearance.shadows
                  ?.map((s) => s.resolve(colors))
                  .toList() ??
              const [],
        );
    final behavior = m.behavior;
    theme = theme.copyWith(
      textTheme: m.fontFamily == null
          ? null
          : theme.textTheme.apply(fontFamily: m.fontFamily),
      motion: theme.motion.copyWith(
        fastDuration: behavior.fastDuration == null
            ? null
            : Duration(milliseconds: behavior.fastDuration!.round()),
        standardDuration: behavior.standardDuration == null
            ? null
            : Duration(milliseconds: behavior.standardDuration!.round()),
        emphasizedDuration: behavior.emphasizedDuration == null
            ? null
            : Duration(milliseconds: behavior.emphasizedDuration!.round()),
        fastCurve: behavior.fastCurve == null
            ? null
            : resolveEditorCurve(behavior.fastCurve!),
        standardCurve: behavior.standardCurve == null
            ? null
            : resolveEditorCurve(behavior.standardCurve!),
        emphasizedCurve: behavior.emphasizedCurve == null
            ? null
            : resolveEditorCurve(behavior.emphasizedCurve!),
        spring: SpringDescription(
          mass: behavior.springMass ?? theme.motion.spring.mass,
          stiffness: behavior.springStiffness ?? theme.motion.spring.stiffness,
          damping: behavior.springDamping ?? theme.motion.spring.damping,
        ),
      ),
      contrastTheme: theme.contrastTheme.copyWith(
        mode: behavior.contrastMode,
        minimumContrastRatio: behavior.minimumContrastRatio,
        lightForeground: behavior.lightForeground,
        darkForeground: behavior.darkForeground,
      ),
      sizes: theme.sizes.copyWith(
        phone: sizes(HyperDeviceType.phone),
        tablet: sizes(HyperDeviceType.tablet),
        desktop: sizes(HyperDeviceType.desktop),
        watch: sizes(HyperDeviceType.watch),
      ),
      typographyTheme: theme.typographyTheme.copyWith(
        phone: typo(HyperDeviceType.phone),
        tablet: typo(HyperDeviceType.tablet),
        desktop: typo(HyperDeviceType.desktop),
        watch: typo(HyperDeviceType.watch),
      ),
      materialTheme: theme.materialTheme.copyWith(
        material: material,
        transitionFadeFraction:
            behavior.transitionFadeFraction ??
            theme.materialTheme.transitionFadeFraction,
        reduceTransparency:
            behavior.reduceTransparency ??
            theme.materialTheme.reduceTransparency,
        quality:
            behavior.quality ??
            (m.material == null
                ? theme.materialTheme.quality
                : HyperMaterialQuality.advanced),
      ),
      buttonTheme: theme.buttonTheme.copyWith(
        filled: variantStyle(HyperButtonVariant.filled),
        tonal: variantStyle(HyperButtonVariant.tonal),
        outlined: variantStyle(HyperButtonVariant.outlined),
        ghost: variantStyle(HyperButtonVariant.ghost),
        text: variantStyle(HyperButtonVariant.text),
        gradient: variantStyle(HyperButtonVariant.gradient),
        style: (theme.buttonTheme.style ?? HyperButtonStyle())
            .merge(
              HyperButtonStyle(
                background: b.fillKind == null ? null : background(b),
                boxBorder: b.border.resolve(
                  colors,
                  inherited: b.buttonStyle.resolve(colors).border,
                ),
                foregroundColor: b.foreground?.resolve(colors),
                boxShadow: b.shadows?.map((s) => s.resolve(colors)).toList(),
              ),
            )
            .merge(b.buttonStyle.resolve(colors))
            .merge(
              HyperButtonStyle(
                hoveredBoxShadow: b.hoveredShadow.shadows
                    ?.map((s) => s.resolve(colors))
                    .toList(),
                pressedBoxShadow: b.pressedShadow.shadows
                    ?.map((s) => s.resolve(colors))
                    .toList(),
                disabledBoxShadow: b.disabledShadow.shadows
                    ?.map((s) => s.resolve(colors))
                    .toList(),
                focusedBoxShadow: b.focusedShadow.shadows
                    ?.map((s) => s.resolve(colors))
                    .toList(),
              ),
            ),
      ),
      tagTheme: theme.tagTheme.merge(
        HyperTagThemeData(
          style: resolveEditorTag(m.tag, colors, theme.contrastTheme),
          emphasized: resolveEditorTag(
            m.tagEmphasized,
            colors,
            theme.contrastTheme,
          ),
          disabled: resolveEditorTag(
            m.tagDisabled,
            colors,
            theme.contrastTheme,
          ),
        ),
      ),
      chipTheme: theme.chipTheme.merge(
        HyperChipThemeData(
          style: resolveEditorChip(m.chip, colors),
          selected: resolveEditorChip(m.chipSelected, colors),
          hovered: resolveEditorChip(m.chipHovered, colors),
          focused: resolveEditorChip(m.chipFocused, colors),
          pressed: resolveEditorChip(m.chipPressed, colors),
          disabled: resolveEditorChip(m.chipDisabled, colors),
        ),
      ),
      badgeTheme: theme.badgeTheme.copyWith(
        style: theme.badgeTheme.style
            .merge(m.badge.badgeStyle.resolve(colors))
            .merge(
              HyperBadgeStyle(
                boxShadow: m.badge.shadows
                    ?.map((s) => s.resolve(colors))
                    .toList(),
              ),
            ),
      ),
      dividerTheme: theme.dividerTheme.copyWith(
        style: theme.dividerTheme.style.merge(
          m.divider.dividerStyle.resolve(colors),
        ),
      ),
      progressTheme: theme.progressTheme.merge(
        HyperProgressThemeData(
          style: m.progress.progressStyle.resolve(colors),
          linearStyle: m.progressLinear.progressStyle.resolve(colors),
          circularStyle: m.progressCircular.progressStyle.resolve(colors),
          infiniteStyle: m.progressInfinite.progressStyle.resolve(colors),
        ),
      ),
      radioTheme: HyperRadioThemeData(
        style:
            theme.radioTheme.style?.merge(controlRadio(m.radio)) ??
            controlRadio(m.radio),
        checkmark:
            theme.radioTheme.checkmark?.merge(controlRadio(m.radioCheckmark)) ??
            controlRadio(m.radioCheckmark),
        circle:
            theme.radioTheme.circle?.merge(controlRadio(m.radioCircle)) ??
            controlRadio(m.radioCircle),
        filled:
            theme.radioTheme.filled?.merge(controlRadio(m.radioFilled)) ??
            controlRadio(m.radioFilled),
      ),
      checkboxTheme: HyperCheckboxThemeData(
        style:
            theme.checkboxTheme.style?.merge(controlCheckbox(m.checkbox)) ??
            controlCheckbox(m.checkbox),
        circle:
            theme.checkboxTheme.circle?.merge(
              controlCheckbox(m.checkboxCircle),
            ) ??
            controlCheckbox(m.checkboxCircle),
        rounded:
            theme.checkboxTheme.rounded?.merge(
              controlCheckbox(m.checkboxRounded),
            ) ??
            controlCheckbox(m.checkboxRounded),
      ),
      switchTheme: theme.switchTheme.merge(
        HyperSwitchThemeData(
          style: m.switchControl.switchStyle
              .resolve(colors)
              .merge(
                HyperSwitchStyle(
                  thumbShadow: m.switchControl.shadows
                      ?.map((s) => s.resolve(colors))
                      .toList(),
                ),
              ),
        ),
      ),
      cardTheme: theme.cardTheme.copyWith(
        style: (theme.cardTheme.style ?? HyperCardStyle()).merge(
          HyperCardStyle(
            background: background(c),
            border: c.border.resolve(colors),
            foregroundColor: c.foreground?.resolve(colors),
            boxShadow: c.shadows?.map((s) => s.resolve(colors)).toList(),
          ),
        ),
      ),
      textFieldTheme: theme.textFieldTheme
          .merge(f.textFieldStyle.resolve(colors, defaultBorder: f.border))
          .copyWith(
            focused: theme.textFieldTheme.focused
                .merge(
                  f.textFieldStyle
                      .resolve(colors, defaultBorder: f.border)
                      .focused,
                )
                .merge(
                  HyperTextFieldStyle(
                    boxShadow: f.focusedShadow.shadows
                        ?.map((s) => s.resolve(colors))
                        .toList(),
                  ),
                ),
            style: theme.textFieldTheme.style
                .merge(
                  f.textFieldStyle
                      .resolve(colors, defaultBorder: f.border)
                      .style,
                )
                .merge(
                  HyperTextFieldStyle(
                    background: background(f),
                    border: f.border.resolve(colors),
                    foregroundColor: f.foreground?.resolve(colors),
                    boxShadow: f.shadows
                        ?.map((s) => s.resolve(colors))
                        .toList(),
                  ),
                ),
          ),
      selectTheme: theme.selectTheme.copyWith(
        style: HyperSelectStyle(
          foregroundColor: m.selectAnchor.foreground?.resolve(colors),
          arrowColor: m.select.selectStyle.arrowColor?.resolve(colors),
          disabledArrowColor: m.select.selectStyle.disabledArrowColor?.resolve(
            colors,
          ),

          buttonStyle: HyperButtonStyle(
            background: background(m.selectAnchor),
            boxBorder: m.selectAnchor.border.resolve(colors),
            hoveredBoxShadow: m.selectAnchor.hoveredShadow.shadows
                ?.map((s) => s.resolve(colors))
                .toList(),
            focusedBoxShadow: m.selectAnchor.focusedShadow.shadows
                ?.map((s) => s.resolve(colors))
                .toList(),
            pressedBoxShadow: m.selectAnchor.pressedShadow.shadows
                ?.map((s) => s.resolve(colors))
                .toList(),
            disabledBoxShadow: m.selectAnchor.disabledShadow.shadows
                ?.map((s) => s.resolve(colors))
                .toList(),
            boxShadow: m.selectAnchor.shadows
                ?.map((s) => s.resolve(colors))
                .toList(),
            textStyle: m.select.selectStyle.labelFontSize == null
                ? null
                : TextStyle(fontSize: m.select.selectStyle.labelFontSize),
          ).merge(m.selectAnchor.buttonStyle.resolve(colors)),
          selectionStyle: HyperSelectionStyle(
            duration: m.select.selectStyle.durationMilliseconds == null
                ? null
                : Duration(
                    milliseconds: m.select.selectStyle.durationMilliseconds!
                        .round(),
                  ),
            searchDebounce: m.select.selectStyle.searchDebounce == null
                ? null
                : Duration(
                    milliseconds: m.select.selectStyle.searchDebounce!.round(),
                  ),
            searchStyle: HyperTextFieldStyle(
              textStyle: m.select.selectStyle.searchFontSize == null
                  ? null
                  : TextStyle(fontSize: m.select.selectStyle.searchFontSize),
              hintStyle: m.select.selectStyle.searchHintColor == null
                  ? null
                  : TextStyle(
                      color: m.select.selectStyle.searchHintColor!.resolve(
                        colors,
                      ),
                    ),
            ),
            surfaceStyle: HyperCardStyle(
              background: background(m.select),
              border: m.select.border.resolve(colors),
              boxShadow: m.select.shadows
                  ?.map((s) => s.resolve(colors))
                  .toList(),
            ),
            menuStyle: HyperMenuStyle(
              showCheckmark: m.select.selectStyle.showCheckmark,
              checkPlacement: m.select.selectStyle.checkPlacement == null
                  ? null
                  : HyperMenuCheckPlacement.values.byName(
                      m.select.selectStyle.checkPlacement!,
                    ),
              checkIcon: switch (m.select.selectStyle.checkIcon) {
                'check' => Icons.check,
                'doneAll' => Icons.done_all,
                'radio' => Icons.radio_button_checked,
                'star' => Icons.star,
                _ => null,
              },
              checkColor: m.select.selectStyle.checkColor?.resolve(colors),
              checkSize: m.select.selectStyle.checkSize,
              checkSpacing: m.select.selectStyle.checkSpacing,
              foregroundColor:
                  (m.select.selectStyle.optionForegroundColor ??
                          m.select.foreground)
                      ?.resolve(colors),
              disabledColor: m.select.selectStyle.disabledOptionColor?.resolve(
                colors,
              ),
              selectedBackgroundColor: m
                  .select
                  .selectStyle
                  .selectedBackgroundColor
                  ?.resolve(colors),
              selectedForegroundColor: m
                  .select
                  .selectStyle
                  .selectedForegroundColor
                  ?.resolve(colors),
              activeBackgroundColor: m.select.selectStyle.activeBackgroundColor
                  ?.resolve(colors),
              itemTextStyle: m.select.selectStyle.optionFontSize == null
                  ? null
                  : TextStyle(fontSize: m.select.selectStyle.optionFontSize),
            ),
          ),
        ),
      ),
      menuTheme: theme.menuTheme.copyWith(
        style: HyperMenuStyle(
          foregroundColor: n.foreground?.resolve(colors),
          surfaceStyle: HyperCardStyle(
            background: background(n),
            border: n.border.resolve(colors),
            boxShadow: n.shadows?.map((s) => s.resolve(colors)).toList(),
          ),
        ),
      ),
    );
    final shared = theme.selectTheme.style;
    final trigger = shared?.buttonStyle;
    theme = theme.copyWith(
      autocompleteTheme: theme.autocompleteTheme.copyWith(
        style: theme.autocompleteTheme.style
            .merge(shared?.selectionStyle)
            .merge(
              HyperSelectionStyle(
                inputStyle: HyperTextFieldStyle(
                  background: trigger?.background,
                  border: trigger?.boxBorder,
                  foregroundColor: shared?.foregroundColor,
                  textStyle: trigger?.textStyle,
                  hintStyle: trigger?.textStyle,
                  duration: trigger?.animationDuration,
                ),
              ),
            ),
      ),
    );
    return theme;
  }
}
