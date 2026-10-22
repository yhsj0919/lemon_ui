import 'editor_table_fields.dart';
import 'editor_form_fields.dart';
import 'editor_wheel_fields.dart';
import 'editor_review_fields.dart';
import 'editor_input_fields.dart';
import 'editor_content_fields.dart';
import 'editor_surface_fields.dart';
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
              'material',
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
  EditorInputFields input = EditorInputFields();
  EditorContentFields content = EditorContentFields();
  EditorSurfaceFields surface = EditorSurfaceFields();
  EditorReviewFields material = EditorReviewFields();
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
    if (input.toJson().isNotEmpty) 'input': input.toJson(),
    if (content.toJson().isNotEmpty) 'content': content.toJson(),
    if (material.toJson().isNotEmpty) 'material': material.toJson(),
    if (surface.toJson().isNotEmpty) 'surface': surface.toJson(),
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
      'input',
      'content',
      'surface',
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
      ..material = EditorReviewFields.fromJson(
        (json['material'] as Map<String, dynamic>?) ?? {},
      )
      ..input = EditorInputFields.fromJson(
        (json['input'] as Map<String, dynamic>?) ?? {},
      )
      ..content = EditorContentFields.fromJson(
        (json['content'] as Map<String, dynamic>?) ?? {},
      )
      ..surface = EditorSurfaceFields.fromJson(
        (json['surface'] as Map<String, dynamic>?) ?? {},
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
  EditorReviewCollection reviews = EditorReviewCollection();
  EditorInputFields sliderInput = EditorInputFields();
  EditorInputFields segmentedInput = EditorInputFields();
  EditorInputFields colorPickerInput = EditorInputFields();
  EditorInputFields iconButtonInput = EditorInputFields();
  EditorContentFields treeContent = EditorContentFields();
  EditorContentFields resultContent = EditorContentFields();
  EditorContentFields descriptionContent = EditorContentFields();
  EditorContentFields timelineContent = EditorContentFields();
  EditorContentFields avatarContent = EditorContentFields();
  EditorContentFields listTileContent = EditorContentFields();
  EditorContentFields textContent = EditorContentFields();
  EditorContentFields iconContent = EditorContentFields();
  EditorSurfaceFields containerMetrics = EditorSurfaceFields();
  EditorSurfaceFields cardMetrics = EditorSurfaceFields();
  EditorSurfaceFields collapsibleMetrics = EditorSurfaceFields();
  EditorSurfaceFields groupMetrics = EditorSurfaceFields();
  EditorBadgeMetrics badgeMetrics = EditorBadgeMetrics();
  EditorDividerMetrics dividerMetrics = EditorDividerMetrics();
  EditorProgressMetrics progressMetrics = EditorProgressMetrics();
  EditorRadioMetrics radioMetrics = EditorRadioMetrics();
  EditorCheckboxMetrics checkboxMetrics = EditorCheckboxMetrics();
  EditorSwitchMetrics switchMetrics = EditorSwitchMetrics();
  EditorTagMetrics tagMetrics = EditorTagMetrics();
  EditorChipMetrics chipMetrics = EditorChipMetrics();
  EditorSelectMetrics selectMetrics = EditorSelectMetrics();
  EditorWheelMetrics wheelMetrics = EditorWheelMetrics();
  EditorWheelMetrics calendarMetrics = EditorWheelMetrics();
  EditorTableMetrics tableMetrics = EditorTableMetrics();
  EditorFormMetrics formMetrics = EditorFormMetrics();
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
    if (reviews.toJson().isNotEmpty) 'reviews': reviews.toJson(),
    if (sliderInput.toJson().isNotEmpty) 'sliderInput': sliderInput.toJson(),
    if (segmentedInput.toJson().isNotEmpty)
      'segmentedInput': segmentedInput.toJson(),
    if (colorPickerInput.toJson().isNotEmpty)
      'colorPickerInput': colorPickerInput.toJson(),
    if (iconButtonInput.toJson().isNotEmpty)
      'iconButtonInput': iconButtonInput.toJson(),
    if (treeContent.toJson().isNotEmpty) 'treeContent': treeContent.toJson(),
    if (resultContent.toJson().isNotEmpty)
      'resultContent': resultContent.toJson(),
    if (descriptionContent.toJson().isNotEmpty)
      'descriptionContent': descriptionContent.toJson(),
    if (timelineContent.toJson().isNotEmpty)
      'timelineContent': timelineContent.toJson(),
    if (avatarContent.toJson().isNotEmpty)
      'avatarContent': avatarContent.toJson(),
    if (listTileContent.toJson().isNotEmpty)
      'listTileContent': listTileContent.toJson(),
    if (textContent.toJson().isNotEmpty) 'textContent': textContent.toJson(),
    if (iconContent.toJson().isNotEmpty) 'iconContent': iconContent.toJson(),
    if (containerMetrics.toJson().isNotEmpty)
      'containerMetrics': containerMetrics.toJson(),
    if (cardMetrics.toJson().isNotEmpty) 'cardMetrics': cardMetrics.toJson(),
    if (collapsibleMetrics.toJson().isNotEmpty)
      'collapsibleMetrics': collapsibleMetrics.toJson(),
    if (groupMetrics.toJson().isNotEmpty) 'groupMetrics': groupMetrics.toJson(),
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
    if (tableMetrics.toJson().isNotEmpty) 'tableMetrics': tableMetrics.toJson(),
    if (formMetrics.toJson().isNotEmpty) 'formMetrics': formMetrics.toJson(),
    if (calendarMetrics.toJson().isNotEmpty)
      'calendarMetrics': calendarMetrics.toJson(),
    if (wheelMetrics.toJson().isNotEmpty) 'wheelMetrics': wheelMetrics.toJson(),
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
      'reviews',
      'typography',
      'buttonMetrics',
      'sliderInput',
      'segmentedInput',
      'colorPickerInput',
      'iconButtonInput',
      'treeContent',
      'resultContent',
      'descriptionContent',
      'timelineContent',
      'avatarContent',
      'listTileContent',
      'textContent',
      'iconContent',
      'containerMetrics',
      'cardMetrics',
      'collapsibleMetrics',
      'groupMetrics',
      'badgeMetrics',
      'dividerMetrics',
      'progressMetrics',
      'radioMetrics',
      'checkboxMetrics',
      'switchMetrics',
      'tagMetrics',
      'chipMetrics',
      'selectMetrics',
      'tableMetrics',
      'formMetrics',
      'calendarMetrics',
      'wheelMetrics',
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
      ..reviews = EditorReviewCollection.fromJson(
        (j['reviews'] as Map<String, dynamic>?) ?? {},
      )
      ..iconContent = EditorContentFields.fromJson(
        (j['iconContent'] as Map<String, dynamic>?) ?? {},
      )
      ..textContent = EditorContentFields.fromJson(
        (j['textContent'] as Map<String, dynamic>?) ?? {},
      )
      ..listTileContent = EditorContentFields.fromJson(
        (j['listTileContent'] as Map<String, dynamic>?) ?? {},
      )
      ..avatarContent = EditorContentFields.fromJson(
        (j['avatarContent'] as Map<String, dynamic>?) ?? {},
      )
      ..timelineContent = EditorContentFields.fromJson(
        (j['timelineContent'] as Map<String, dynamic>?) ?? {},
      )
      ..descriptionContent = EditorContentFields.fromJson(
        (j['descriptionContent'] as Map<String, dynamic>?) ?? {},
      )
      ..resultContent = EditorContentFields.fromJson(
        (j['resultContent'] as Map<String, dynamic>?) ?? {},
      )
      ..sliderInput = EditorInputFields.fromJson(
        (j['sliderInput'] as Map<String, dynamic>?) ?? {},
      )
      ..segmentedInput = EditorInputFields.fromJson(
        (j['segmentedInput'] as Map<String, dynamic>?) ?? {},
      )
      ..colorPickerInput = EditorInputFields.fromJson(
        (j['colorPickerInput'] as Map<String, dynamic>?) ?? {},
      )
      ..iconButtonInput = EditorInputFields.fromJson(
        (j['iconButtonInput'] as Map<String, dynamic>?) ?? {},
      )
      ..treeContent = EditorContentFields.fromJson(
        (j['treeContent'] as Map<String, dynamic>?) ?? {},
      )
      ..groupMetrics = EditorSurfaceFields.fromJson(
        (j['groupMetrics'] as Map<String, dynamic>?) ?? {},
      )
      ..collapsibleMetrics = EditorSurfaceFields.fromJson(
        (j['collapsibleMetrics'] as Map<String, dynamic>?) ?? {},
      )
      ..cardMetrics = EditorSurfaceFields.fromJson(
        (j['cardMetrics'] as Map<String, dynamic>?) ?? {},
      )
      ..containerMetrics = EditorSurfaceFields.fromJson(
        (j['containerMetrics'] as Map<String, dynamic>?) ?? {},
      )
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
      ..tableMetrics = EditorTableMetrics.fromJson(
        (j['tableMetrics'] as Map<String, dynamic>?) ?? {},
      )
      ..formMetrics = EditorFormMetrics.fromJson(
        (j['formMetrics'] as Map<String, dynamic>?) ?? {},
      )
      ..calendarMetrics = EditorWheelMetrics.fromJson(
        (j['calendarMetrics'] as Map<String, dynamic>?) ?? {},
      )
      ..wheelMetrics = EditorWheelMetrics.fromJson(
        (j['wheelMetrics'] as Map<String, dynamic>?) ?? {},
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
  EditorTableVisual tableVisual = EditorTableVisual();
  EditorReviewCollection reviews = EditorReviewCollection();
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
  final sliderInput = EditorComponent();
  final segmentedInput = EditorComponent();
  final segmentedGroupInput = EditorComponent();
  final segmentedSelectedInput = EditorComponent();
  final colorPickerInput = EditorComponent();
  final iconButtonInput = EditorComponent();
  final iconButtonFilledInput = EditorComponent();
  final iconButtonTonalInput = EditorComponent();
  final iconButtonOutlinedInput = EditorComponent();
  final iconButtonGhostInput = EditorComponent();
  final treeContent = EditorComponent();
  final resultContent = EditorComponent();
  final descriptionContent = EditorComponent();
  final timelineContent = EditorComponent();
  final avatarContent = EditorComponent();
  final listTileContent = EditorComponent();
  final textContent = EditorComponent();
  final iconContent = EditorComponent();
  final container = EditorComponent();
  final collapsible = EditorComponent();
  final group = EditorComponent();
  final card = EditorComponent();
  final field = EditorComponent();
  final menu = EditorComponent();
  final select = EditorComponent(), selectAnchor = EditorComponent();
  EditorWheelVisual wheel = EditorWheelVisual();
  EditorWheelVisual calendar = EditorWheelVisual();
  EditorFormVisual formFields = EditorFormVisual();
  Map<String, Object?> toJson() => {
    if (tableVisual.toJson().isNotEmpty) 'tableVisual': tableVisual.toJson(),
    if (reviews.toJson().isNotEmpty) 'reviews': reviews.toJson(),
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
    if (segmentedGroupInput.toJson().isNotEmpty)
      'segmentedGroupInput': segmentedGroupInput.toJson(),
    if (sliderInput.toJson().isNotEmpty) 'sliderInput': sliderInput.toJson(),
    if (segmentedInput.toJson().isNotEmpty)
      'segmentedInput': segmentedInput.toJson(),
    if (segmentedSelectedInput.toJson().isNotEmpty)
      'segmentedSelectedInput': segmentedSelectedInput.toJson(),
    if (colorPickerInput.toJson().isNotEmpty)
      'colorPickerInput': colorPickerInput.toJson(),
    if (iconButtonInput.toJson().isNotEmpty)
      'iconButtonInput': iconButtonInput.toJson(),
    if (iconButtonFilledInput.toJson().isNotEmpty)
      'iconButtonFilledInput': iconButtonFilledInput.toJson(),
    if (iconButtonTonalInput.toJson().isNotEmpty)
      'iconButtonTonalInput': iconButtonTonalInput.toJson(),
    if (iconButtonOutlinedInput.toJson().isNotEmpty)
      'iconButtonOutlinedInput': iconButtonOutlinedInput.toJson(),
    if (iconButtonGhostInput.toJson().isNotEmpty)
      'iconButtonGhostInput': iconButtonGhostInput.toJson(),
    if (treeContent.toJson().isNotEmpty) 'treeContent': treeContent.toJson(),
    if (resultContent.toJson().isNotEmpty)
      'resultContent': resultContent.toJson(),
    if (descriptionContent.toJson().isNotEmpty)
      'descriptionContent': descriptionContent.toJson(),
    if (timelineContent.toJson().isNotEmpty)
      'timelineContent': timelineContent.toJson(),
    if (avatarContent.toJson().isNotEmpty)
      'avatarContent': avatarContent.toJson(),
    if (listTileContent.toJson().isNotEmpty)
      'listTileContent': listTileContent.toJson(),
    if (textContent.toJson().isNotEmpty) 'textContent': textContent.toJson(),
    if (iconContent.toJson().isNotEmpty) 'iconContent': iconContent.toJson(),
    if (container.toJson().isNotEmpty) 'container': container.toJson(),
    if (collapsible.toJson().isNotEmpty) 'collapsible': collapsible.toJson(),
    if (group.toJson().isNotEmpty) 'group': group.toJson(),
    if (card.toJson().isNotEmpty) 'card': card.toJson(),
    if (field.toJson().isNotEmpty) 'field': field.toJson(),
    if (formFields.toJson().isNotEmpty) 'formFields': formFields.toJson(),
    if (calendar.toJson().isNotEmpty) 'calendar': calendar.toJson(),
    if (wheel.toJson().isNotEmpty) 'wheel': wheel.toJson(),
    if (select.toJson().isNotEmpty) 'select': select.toJson(),
    if (selectAnchor.toJson().isNotEmpty) 'selectAnchor': selectAnchor.toJson(),
    if (menu.toJson().isNotEmpty) 'menu': menu.toJson(),
  };
  EditorMode();
  factory EditorMode.fromJson(Map<String, dynamic> j) {
    _checkFields(j, {
      'reviews',
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
      'sliderInput',
      'segmentedInput',
      'segmentedGroupInput',
      'segmentedSelectedInput',
      'colorPickerInput',
      'iconButtonInput',
      'iconButtonFilledInput',
      'iconButtonTonalInput',
      'iconButtonOutlinedInput',
      'iconButtonGhostInput',
      'tableVisual',
      'treeContent',
      'resultContent',
      'descriptionContent',
      'timelineContent',
      'avatarContent',
      'listTileContent',
      'textContent',
      'iconContent',
      'container',
      'collapsible',
      'group',
      'card',
      'field',
      'select',
      'selectAnchor',
      'formFields',
      'calendar',
      'wheel',
      'menu',
    });
    final result = EditorMode()
      ..reviews = EditorReviewCollection.fromJson(
        (j['reviews'] as Map<String, dynamic>?) ?? {},
      )
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
      target.input = value.input;
      target.content = value.content;
      target.surface = value.surface;
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
    read('sliderInput', result.sliderInput);
    read('segmentedInput', result.segmentedInput);
    read('segmentedGroupInput', result.segmentedGroupInput);
    read('segmentedSelectedInput', result.segmentedSelectedInput);
    read('colorPickerInput', result.colorPickerInput);
    read('iconButtonInput', result.iconButtonInput);
    read('iconButtonFilledInput', result.iconButtonFilledInput);
    read('iconButtonTonalInput', result.iconButtonTonalInput);
    read('iconButtonOutlinedInput', result.iconButtonOutlinedInput);
    read('iconButtonGhostInput', result.iconButtonGhostInput);
    result.tableVisual = EditorTableVisual.fromJson(
      (j['tableVisual'] as Map<String, dynamic>?) ?? {},
    );
    read('treeContent', result.treeContent);
    read('resultContent', result.resultContent);
    read('descriptionContent', result.descriptionContent);
    read('timelineContent', result.timelineContent);
    read('avatarContent', result.avatarContent);
    read('listTileContent', result.listTileContent);
    read('textContent', result.textContent);
    read('iconContent', result.iconContent);
    read('container', result.container);
    read('collapsible', result.collapsible);
    read('group', result.group);
    read('card', result.card);
    read('field', result.field);
    read('menu', result.menu);
    read('select', result.select);
    read('selectAnchor', result.selectAnchor);
    result.formFields = EditorFormVisual.fromJson(
      (j['formFields'] as Map<String, dynamic>?) ?? {},
    );
    result.calendar = EditorWheelVisual.fromJson(
      (j['calendar'] as Map<String, dynamic>?) ?? {},
    );
    result.wheel = EditorWheelVisual.fromJson(
      (j['wheel'] as Map<String, dynamic>?) ?? {},
    );
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

  HyperThemeData resolve(
    bool isDark, {
    HyperDeviceType deviceType = HyperDeviceType.desktop,
  }) {
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
          table: d.tableMetrics.resolve(s.table),
          form: d.formMetrics.resolve(s.form),
          calendar: s.calendar.copyWith(
            width: d.calendarMetrics.width,
            dayMinHeight: d.calendarMetrics.itemExtent,
            spacing: d.calendarMetrics.horizontalPadding,
            radius: d.calendarMetrics.selectionRadius,
            selectionSize: d.calendarMetrics.selectionSize,
          ),
          wheelPicker: d.wheelMetrics.resolve(s.wheelPicker),
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
          slider: s.slider.copyWith(
            thumbWidth: d.sliderInput.thumbWidth,
            thumbHeight: d.sliderInput.thumbHeight,
            trackHeight: d.sliderInput.trackHeight,
            thumbRadius: d.sliderInput.thumbRadius,
            thinTrackHeight: d.sliderInput.thinTrackHeight,
            thinThumbRadius: d.sliderInput.thinThumbRadius,
            stepPointRadius: d.sliderInput.stepPointRadius,
            capsuleWidth: d.sliderInput.capsuleWidth,
            capsuleCornerRadius: d.sliderInput.capsuleCornerRadius,
            capsuleIconSize: d.sliderInput.capsuleIconSize,
            capsuleIconInset: d.sliderInput.capsuleIconInset,
            capsuleOverscrollExtent: d.sliderInput.capsuleOverscrollExtent,
          ),
          colorPicker: s.colorPicker.copyWith(
            width: d.colorPickerInput.width,
            paletteHeight: d.colorPickerInput.paletteHeight,
            radius: d.colorPickerInput.radius,
            spacing: d.colorPickerInput.spacing,
            markerRadius: d.colorPickerInput.markerRadius,
            previewHeight: d.colorPickerInput.previewHeight,
          ),
          iconButton: s.iconButton.copyWith(
            size: d.iconButtonInput.width,
            iconSize: d.iconButtonInput.iconSize,
            progressSize: d.iconButtonInput.progressSize,
            radius: d.iconButtonInput.radius,
          ),
          timeline: s.timeline.copyWith(
            nodeSize: d.timelineContent.nodeSize,
            iconSize: d.timelineContent.iconSize,
          ),
          avatar: s.avatar.copyWith(
            small: d.avatarContent.avatarSmall,
            medium: d.avatarContent.avatarMedium,
            large: d.avatarContent.avatarLarge,
          ),
          card: s.card.copyWith(
            radius: d.cardMetrics.radius ?? d.cardRadius,
            padding: d.cardMetrics.resolvedPadding(
              s.card.padding.resolve(TextDirection.ltr),
            ),
            titlePadding: d.cardMetrics.titlePadding == null
                ? null
                : EdgeInsets.all(d.cardMetrics.titlePadding!),
            outsideTitlePadding: d.cardMetrics.outsideTitlePadding == null
                ? null
                : EdgeInsets.all(d.cardMetrics.outsideTitlePadding!),
            titleSpacing: d.cardMetrics.titleSpacing,
            outsideTitleSpacing: d.cardMetrics.outsideTitleSpacing,
            actionSpacing: d.cardMetrics.actionSpacing,
          ),
          collapsible: s.collapsible.copyWith(
            radius: d.collapsibleMetrics.radius,
            headerPadding: d.collapsibleMetrics.insets,
            contentPadding: d.collapsibleMetrics.contentInsets,
            headerMinHeight: d.collapsibleMetrics.headerHeight,
            iconSize: d.collapsibleMetrics.iconSize,
            spacing: d.collapsibleMetrics.spacing,
          ),
          widgetGroup: s.widgetGroup.copyWith(
            radius: d.groupMetrics.radius,
            innerRadius: d.groupMetrics.itemRadius,
            spacing: d.groupMetrics.spacing,
            separatorExtent: d.groupMetrics.separatorExtent,
            separatorThickness: d.groupMetrics.separatorThickness,
          ),
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
                (m.material == HyperSurfaceMaterialKind.solid
                    ? 1
                    : m.material == HyperSurfaceMaterialKind.translucent
                    ? HyperSurfaceMaterial.semanticTranslucentOpacity
                    : m.material == HyperSurfaceMaterialKind.clearFrostedGlass
                    ? const HyperSurfaceMaterial.clearFrostedGlass()
                          .background!
                          .gradient!
                          .colors
                          .first
                          .a
                    : HyperSurfaceMaterial.semanticGlassOpacity),
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
          HyperSurfaceMaterialKind.clearFrostedGlass =>
            HyperSurfaceMaterial.clearFrostedGlass(
              background:
                  m.opacity == null && m.materialAppearance.background == null
                  ? const HyperSurfaceMaterial.clearFrostedGlass().background
                  : bg,
              blurSigmaX:
                  m.blur ??
                  const HyperSurfaceMaterial.clearFrostedGlass().blurSigmaX,
              blurSigmaY:
                  m.blurY ??
                  m.blur ??
                  const HyperSurfaceMaterial.clearFrostedGlass().blurSigmaX,
              boxShadow:
                  m.materialAppearance.shadows
                      ?.map((s) => s.resolve(colors))
                      .toList() ??
                  const HyperSurfaceMaterial.clearFrostedGlass().boxShadow,
            ),
          HyperSurfaceMaterialKind.softLightGlass =>
            HyperSurfaceMaterial.softLightGlass(
              background: bg,
              blurSigmaX: m.blur ?? 28,
              blurSigmaY: m.blurY ?? m.blur ?? 28,
            ),
        })?.copyWith(
          edgeEnabled: m.materialAppearance.material.materialEdgeEnabled,
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
              (m.material == HyperSurfaceMaterialKind.clearFrostedGlass
                  ? const HyperSurfaceMaterial.clearFrostedGlass().boxShadow
                  : const []),
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
      tableTheme: theme.tableTheme.merge(
        HyperTableThemeData(
          style: m.tableVisual.resolve(
            colors,
            device(deviceType).tableMetrics,
            inherited: theme.sizes.resolve(deviceType).table,
          ),
        ),
      ),
      treeViewTheme: theme.treeViewTheme.copyWith(
        style: theme.treeViewTheme.style.merge(
          HyperTreeViewStyle(
            rowHeight: device(deviceType).treeContent.rowHeight,
            rowSpacing: device(deviceType).treeContent.rowSpacing,
            indent: device(deviceType).treeContent.indent,
            iconSize: device(deviceType).treeContent.iconSize,
            contentSpacing: device(deviceType).treeContent.contentSpacing,
            foregroundColor:
                (m.treeContent.content.foregroundColor ??
                        m.treeContent.content.textStyleColor)
                    ?.resolve(colors),
            selectedForegroundColor: m
                .treeContent
                .content
                .selectedForegroundColor
                ?.resolve(colors),
            disabledColor: m.treeContent.content.disabledColor?.resolve(colors),
            focusColor: m.treeContent.content.focusColor?.resolve(colors),
            errorColor: m.treeContent.content.errorColor?.resolve(colors),
            rowBackground: m.treeContent.content.rowBackground == null
                ? null
                : HyperFill.color(
                    m.treeContent.content.rowBackground!.resolve(colors),
                  ),
            selectedBackground: m.treeContent.content.selectedBackground == null
                ? null
                : HyperFill.color(
                    m.treeContent.content.selectedBackground!.resolve(colors),
                  ),
            hoverBackground: m.treeContent.content.hoverBackground == null
                ? null
                : HyperFill.color(
                    m.treeContent.content.hoverBackground!.resolve(colors),
                  ),
            pressedBackground: m.treeContent.content.pressedBackground == null
                ? null
                : HyperFill.color(
                    m.treeContent.content.pressedBackground!.resolve(colors),
                  ),
            textStyle: TextStyle(
              fontSize: device(deviceType).treeContent.textStyleSize,
              fontWeight: m.treeContent.content.textStyleWeight == null
                  ? null
                  : FontWeight.values[(m.treeContent.content.textStyleWeight! /
                                100)
                            .round()
                            .clamp(1, 9) -
                        1],
              color: m.treeContent.content.textStyleColor?.resolve(colors),
            ),
            rowPadding: device(deviceType).treeContent.padding == null
                ? null
                : EdgeInsets.all(device(deviceType).treeContent.padding!),
            background: background(m.treeContent),
            border: m.treeContent.border.resolve(colors),
            borderRadius: device(deviceType).treeContent.radius == null
                ? null
                : BorderRadius.circular(device(deviceType).treeContent.radius!),
            rowRadius: device(deviceType).treeContent.rowRadius == null
                ? null
                : BorderRadius.circular(
                    device(deviceType).treeContent.rowRadius!,
                  ),
            duration: m.treeContent.content.animationDuration,
            curve: m.treeContent.content.animationCurve,
          ),
        ),
      ),
      resultTheme: theme.resultTheme.copyWith(
        style: theme.resultTheme.style.merge(
          HyperResultStyle(
            iconSize: device(deviceType).resultContent.iconSize,
            illustrationSize: device(deviceType).resultContent.illustrationSize,
            maxWidth: device(deviceType).resultContent.maxWidth,
            contentSpacing: device(deviceType).resultContent.contentSpacing,
            titleSpacing: device(deviceType).resultContent.titleSpacing,
            actionSpacing: device(deviceType).resultContent.actionSpacing,
            actionRunSpacing: device(deviceType).resultContent.actionRunSpacing,
            iconColor: m.resultContent.content.iconColor?.resolve(colors),
            titleStyle: TextStyle(
              fontSize: device(deviceType).resultContent.titleStyleSize,
              fontWeight: m.resultContent.content.titleStyleWeight == null
                  ? null
                  : FontWeight.values[(m
                                    .resultContent
                                    .content
                                    .titleStyleWeight! /
                                100)
                            .round()
                            .clamp(1, 9) -
                        1],
              color: m.resultContent.content.titleStyleColor?.resolve(colors),
            ),
            descriptionStyle: TextStyle(
              fontSize: device(deviceType).resultContent.descriptionStyleSize,
              fontWeight: m.resultContent.content.descriptionStyleWeight == null
                  ? null
                  : FontWeight.values[(m
                                    .resultContent
                                    .content
                                    .descriptionStyleWeight! /
                                100)
                            .round()
                            .clamp(1, 9) -
                        1],
              color: m.resultContent.content.descriptionStyleColor?.resolve(
                colors,
              ),
            ),
            padding: device(deviceType).resultContent.padding == null
                ? null
                : EdgeInsets.all(device(deviceType).resultContent.padding!),
            background: background(m.resultContent),
            border: m.resultContent.border.resolve(colors),
            borderRadius: device(deviceType).resultContent.radius == null
                ? null
                : BorderRadius.circular(
                    device(deviceType).resultContent.radius!,
                  ),
            boxShadow: m.resultContent.shadows
                ?.map((s) => s.resolve(colors))
                .toList(),
            duration: m.resultContent.content.animationDuration,
            curve: m.resultContent.content.animationCurve,
          ),
        ),
      ),
      descriptionListTheme: theme.descriptionListTheme.copyWith(
        style: theme.descriptionListTheme.style.merge(
          HyperDescriptionListStyle(
            contentHeight: device(deviceType).descriptionContent.contentHeight,
            contentHeightMode:
                m.descriptionContent.content.contentHeightMode == null
                ? null
                : HyperDescriptionContentHeightMode.values.byName(
                    m.descriptionContent.content.contentHeightMode!,
                  ),
            valueAlign: m.descriptionContent.content.valueAlign == null
                ? null
                : TextAlign.values.byName(
                    m.descriptionContent.content.valueAlign!,
                  ),
            labelAlign: m.descriptionContent.content.labelAlign == null
                ? null
                : TextAlign.values.byName(
                    m.descriptionContent.content.labelAlign!,
                  ),
            borderThickness: device(deviceType).descriptionContent.borderWidth,
            columnSpacing: device(deviceType).descriptionContent.columnSpacing,
            rowSpacing: device(deviceType).descriptionContent.rowSpacing,
            labelValueSpacing: device(deviceType)
                .descriptionContent
                .labelValueSpacing,
            minimumColumnWidth: device(deviceType)
                .descriptionContent
                .minimumColumnWidth,
            borderColor: m.descriptionContent.content.borderColor?.resolve(
              colors,
            ),
            labelBackground:
                m.descriptionContent.content.labelBackground == null
                ? null
                : HyperFill.color(
                    m.descriptionContent.content.labelBackground!.resolve(
                      colors,
                    ),
                  ),
            valueBackground:
                m.descriptionContent.content.valueBackground == null
                ? null
                : HyperFill.color(
                    m.descriptionContent.content.valueBackground!.resolve(
                      colors,
                    ),
                  ),
            labelStyle: TextStyle(
              fontSize: device(deviceType).descriptionContent.labelStyleSize,
              fontWeight: m.descriptionContent.content.labelStyleWeight == null
                  ? null
                  : FontWeight.values[(m
                                    .descriptionContent
                                    .content
                                    .labelStyleWeight! /
                                100)
                            .round()
                            .clamp(1, 9) -
                        1],
              color: m.descriptionContent.content.labelStyleColor?.resolve(
                colors,
              ),
            ),
            valueStyle: TextStyle(
              fontSize: device(deviceType).descriptionContent.valueStyleSize,
              fontWeight: m.descriptionContent.content.valueStyleWeight == null
                  ? null
                  : FontWeight.values[(m
                                    .descriptionContent
                                    .content
                                    .valueStyleWeight! /
                                100)
                            .round()
                            .clamp(1, 9) -
                        1],
              color: m.descriptionContent.content.valueStyleColor?.resolve(
                colors,
              ),
            ),
            cellPadding: device(deviceType).descriptionContent.padding == null
                ? null
                : EdgeInsets.all(
                    device(deviceType).descriptionContent.padding!,
                  ),
            background: background(m.descriptionContent),
            borderRadius: device(deviceType).descriptionContent.radius == null
                ? null
                : BorderRadius.circular(
                    device(deviceType).descriptionContent.radius!,
                  ),
            duration: m.descriptionContent.content.animationDuration,
            curve: m.descriptionContent.content.animationCurve,
          ),
        ),
      ),
      timelineTheme: theme.timelineTheme.copyWith(
        style: theme.timelineTheme.style.merge(
          HyperTimelineStyle(
            lineThickness: device(deviceType).timelineContent.lineThickness,
            nodeLineGap: device(deviceType).timelineContent.nodeLineGap,
            spacing: device(deviceType).timelineContent.spacing,
            itemSpacing: device(deviceType).timelineContent.itemSpacing,
            textSpacing: device(deviceType).timelineContent.textSpacing,
            nodeForeground: m.timelineContent.content.nodeForeground?.resolve(
              colors,
            ),
            lineColor: m.timelineContent.content.lineColor?.resolve(colors),
            nodeFill: m.timelineContent.content.nodeFill == null
                ? null
                : HyperFill.color(
                    m.timelineContent.content.nodeFill!.resolve(colors),
                  ),
            timeStyle: TextStyle(
              fontSize: device(deviceType).timelineContent.timeStyleSize,
              fontWeight: m.timelineContent.content.timeStyleWeight == null
                  ? null
                  : FontWeight.values[(m
                                    .timelineContent
                                    .content
                                    .timeStyleWeight! /
                                100)
                            .round()
                            .clamp(1, 9) -
                        1],
              color: m.timelineContent.content.timeStyleColor?.resolve(colors),
            ),
            titleStyle: TextStyle(
              fontSize: device(deviceType).timelineContent.titleStyleSize,
              fontWeight: m.timelineContent.content.titleStyleWeight == null
                  ? null
                  : FontWeight.values[(m
                                    .timelineContent
                                    .content
                                    .titleStyleWeight! /
                                100)
                            .round()
                            .clamp(1, 9) -
                        1],
              color: m.timelineContent.content.titleStyleColor?.resolve(colors),
            ),
            contentStyle: TextStyle(
              fontSize: device(deviceType).timelineContent.contentStyleSize,
              fontWeight: m.timelineContent.content.contentStyleWeight == null
                  ? null
                  : FontWeight.values[(m
                                    .timelineContent
                                    .content
                                    .contentStyleWeight! /
                                100)
                            .round()
                            .clamp(1, 9) -
                        1],
              color: m.timelineContent.content.contentStyleColor?.resolve(
                colors,
              ),
            ),
            duration: m.timelineContent.content.animationDuration,
            curve: m.timelineContent.content.animationCurve,
          ),
        ),
      ),
      avatarTheme: theme.avatarTheme.copyWith(
        groupStyle: theme.avatarTheme.groupStyle.merge(
          HyperAvatarStyle(
            overlap: device(deviceType).avatarContent.overlap,
            spacing: device(deviceType).avatarContent.spacing,
            ringWidth: device(deviceType).avatarContent.ringWidth,
            ringColor: m.avatarContent.content.ringColor?.resolve(colors),
            iconSize: device(deviceType).avatarContent.iconSize,
            radius: device(deviceType).avatarContent.radius,
            duration: m.avatarContent.content.animationDuration,
            curve: m.avatarContent.content.animationCurve,
          ),
        ),
        style: theme.avatarTheme.style.merge(
          HyperAvatarStyle(
            iconSize: device(deviceType).avatarContent.iconSize,
            overlap: device(deviceType).avatarContent.overlap,
            spacing: device(deviceType).avatarContent.spacing,
            ringWidth: device(deviceType).avatarContent.ringWidth,
            backgroundColor: m.avatarContent.content.backgroundColor?.resolve(
              colors,
            ),
            foregroundColor: m.avatarContent.content.foregroundColor?.resolve(
              colors,
            ),
            borderColor: m.avatarContent.content.borderColor?.resolve(colors),
            ringColor: m.avatarContent.content.ringColor?.resolve(colors),
            textStyle: TextStyle(
              fontSize: device(deviceType).avatarContent.textStyleSize,
              fontWeight: m.avatarContent.content.textStyleWeight == null
                  ? null
                  : FontWeight
                        .values[(m.avatarContent.content.textStyleWeight! / 100)
                            .round()
                            .clamp(1, 9) -
                        1],
              color: m.avatarContent.content.textStyleColor?.resolve(colors),
            ),
            borderWidth: device(deviceType).avatarContent.borderWidth,
            radius: device(deviceType).avatarContent.radius,
            boxShadow: m.avatarContent.shadows
                ?.map((s) => s.resolve(colors))
                .toList(),
            duration: m.avatarContent.content.animationDuration,
            curve: m.avatarContent.content.animationCurve,
          ),
        ),
      ),
      listTileTheme: theme.listTileTheme.copyWith(
        style: (theme.listTileTheme.style ?? const HyperListTileStyle()).merge(
          HyperListTileStyle(
            minHeight: device(deviceType).listTileContent.minHeight,
            leadingSize: device(deviceType).listTileContent.leadingSize,
            leadingSpacing: device(deviceType).listTileContent.leadingSpacing,
            trailingSpacing: device(deviceType).listTileContent.trailingSpacing,
            trailingIconSize: device(deviceType)
                .listTileContent
                .trailingIconSize,
            foregroundColor: m.listTileContent.content.foregroundColor?.resolve(
              colors,
            ),
            subtitleColor: m.listTileContent.content.subtitleColor?.resolve(
              colors,
            ),
            trailingColor: m.listTileContent.content.trailingColor?.resolve(
              colors,
            ),
            disabledColor: m.listTileContent.content.disabledColor?.resolve(
              colors,
            ),
            overlayColor: m.listTileContent.content.overlayColor?.resolve(
              colors,
            ),
            titleStyle: TextStyle(
              fontSize: device(deviceType).listTileContent.titleStyleSize,
              fontWeight: m.listTileContent.content.titleStyleWeight == null
                  ? null
                  : FontWeight.values[(m
                                    .listTileContent
                                    .content
                                    .titleStyleWeight! /
                                100)
                            .round()
                            .clamp(1, 9) -
                        1],
              color: m.listTileContent.content.titleStyleColor?.resolve(colors),
            ),
            subtitleStyle: TextStyle(
              fontSize: device(deviceType).listTileContent.subtitleStyleSize,
              fontWeight: m.listTileContent.content.subtitleStyleWeight == null
                  ? null
                  : FontWeight.values[(m
                                    .listTileContent
                                    .content
                                    .subtitleStyleWeight! /
                                100)
                            .round()
                            .clamp(1, 9) -
                        1],
              color: m.listTileContent.content.subtitleStyleColor?.resolve(
                colors,
              ),
            ),
            padding: device(deviceType).listTileContent.padding == null
                ? null
                : EdgeInsets.all(device(deviceType).listTileContent.padding!),
            animationDuration: m.listTileContent.content.animationDuration,
            animationCurve: m.listTileContent.content.animationCurve,
          ),
        ),
      ),
      textComponentTheme: HyperTextThemeData(
        style: (theme.textComponentTheme.style ?? const TextStyle()).merge(
          TextStyle(
            fontSize: device(deviceType).textContent.textStyleSize,
            fontWeight: m.textContent.content.textStyleWeight == null
                ? null
                : FontWeight.values[(m.textContent.content.textStyleWeight! /
                              100)
                          .round()
                          .clamp(1, 9) -
                      1],
            color: m.textContent.content.textStyleColor?.resolve(colors),
          ),
        ),
        displayLarge: theme.textComponentTheme.displayLarge,
        displayMedium: theme.textComponentTheme.displayMedium,
        displaySmall: theme.textComponentTheme.displaySmall,
        pageTitle: theme.textComponentTheme.pageTitle,
        sectionTitle: theme.textComponentTheme.sectionTitle,
        subsectionTitle: theme.textComponentTheme.subsectionTitle,
        bodyLarge: theme.textComponentTheme.bodyLarge,
        body: theme.textComponentTheme.body,
        bodySmall: theme.textComponentTheme.bodySmall,
        control: theme.textComponentTheme.control,
        label: theme.textComponentTheme.label,
        caption: theme.textComponentTheme.caption,
      ),
      iconTheme: theme.iconTheme.merge(
        HyperIconThemeData(
          style: HyperIconStyle(
            color: m.iconContent.content.foregroundColor == null
                ? null
                : HyperStateValue.all(
                    m.iconContent.content.foregroundColor!.resolve(colors),
                  ),
            size: device(deviceType).iconContent.iconExtent == null
                ? null
                : HyperStateValue.all(
                    device(deviceType).iconContent.iconExtent!,
                  ),
            fill: m.iconContent.content.iconFill == null
                ? null
                : HyperStateValue.all(m.iconContent.content.iconFill!),
            weight: m.iconContent.content.iconWeight == null
                ? null
                : HyperStateValue.all(m.iconContent.content.iconWeight!),
            grade: m.iconContent.content.iconGrade == null
                ? null
                : HyperStateValue.all(m.iconContent.content.iconGrade!),
            opticalSize: m.iconContent.content.iconOpticalSize == null
                ? null
                : HyperStateValue.all(m.iconContent.content.iconOpticalSize!),
          ),
        ),
      ),
      containerTheme: theme.containerTheme.copyWith(
        material: resolveEditorReviewMaterial(m.container.material, theme),
        background: background(m.container),
        border: m.container.border.resolve(colors),
        borderRadius: device(deviceType).containerMetrics.borderRadius,
        padding: device(deviceType).containerMetrics.insets,
        boxShadow: m.container.shadows?.map((s) => s.resolve(colors)).toList(),
        animationDuration: m.container.surface.animationDuration,
        animationCurve: m.container.surface.animationCurve,
        clipBehavior: m.container.surface.clipping,
      ),
      widgetGroupTheme: theme.widgetGroupTheme.copyWith(
        style: theme.widgetGroupTheme.style.merge(
          HyperWidgetGroupStyle(
            material: resolveEditorReviewMaterial(m.group.material, theme),
            backgroundColor: m.group.background?.resolve(colors),
            border: m.group.border.resolve(colors),
            padding: device(deviceType).groupMetrics.insets,
            separatorColor: m.group.surface.separatorColor?.resolve(colors),
            duration: m.group.surface.animationDuration,
            curve: m.group.surface.animationCurve,
            boxShadow: m.group.shadows?.map((s) => s.resolve(colors)).toList(),
          ),
        ),
      ),
      accordionTheme: theme.accordionTheme.copyWith(
        style: theme.accordionTheme.style.merge(
          HyperAccordionStyle(
            showDividers: m.collapsible.surface.showDividers,
            dividerColor: m.collapsible.surface.separatorColor?.resolve(colors),
            dividerThickness: device(deviceType)
                .collapsibleMetrics
                .separatorThickness,
          ),
        ),
      ),
      collapsibleTheme: theme.collapsibleTheme.copyWith(
        style: theme.collapsibleTheme.style.merge(
          HyperCollapsibleStyle(
            material: resolveEditorReviewMaterial(
              m.collapsible.material,
              theme,
            ),
            background: background(m.collapsible),
            border: m.collapsible.border.resolve(colors),
            headerStyle: TextStyle(
              color: m.collapsible.surface.textColor?.resolve(colors),
              fontSize: device(deviceType).collapsibleMetrics.fontSize,
              height: m.collapsible.surface.lineHeight,
            ),
            iconColor: m.collapsible.surface.iconColor?.resolve(colors),
            overlayColor: m.collapsible.surface.overlayColor?.resolve(colors),
            hoverOpacity: m.collapsible.surface.hoverOpacity,
            focusOpacity: m.collapsible.surface.focusOpacity,
            pressedOpacity: m.collapsible.surface.pressedOpacity,
            disabledOpacity: m.collapsible.surface.disabledOpacity,
            duration: m.collapsible.surface.animationDuration,
            curve: m.collapsible.surface.animationCurve,
          ),
        ),
      ),
      titledCardTheme: theme.titledCardTheme.copyWith(
        inside: (theme.titledCardTheme.inside ?? const HyperTitledCardStyle())
            .merge(
              HyperTitledCardStyle(
                actionPadding: device(deviceType).cardMetrics.actionInsets(
                  true,
                  theme.sizes
                      .resolve(deviceType)
                      .card
                      .actionPadding
                      .resolve(TextDirection.ltr),
                ),
                actionIconSize: device(deviceType)
                    .cardMetrics
                    .insideActionIconSize,
                titleTextStyle: TextStyle(
                  fontSize: device(deviceType).cardMetrics.insideTitleFontSize,
                  color: c.surface.insideTitleColor?.resolve(colors),
                ),
                actionTextStyle: TextStyle(
                  fontSize: device(deviceType).cardMetrics.insideActionFontSize,
                  color: c.surface.insideActionColor?.resolve(colors),
                ),
              ),
            ),
        outside: (theme.titledCardTheme.outside ?? const HyperTitledCardStyle())
            .merge(
              HyperTitledCardStyle(
                actionPadding: device(deviceType).cardMetrics.actionInsets(
                  false,
                  theme.sizes
                      .resolve(deviceType)
                      .card
                      .actionPadding
                      .resolve(TextDirection.ltr),
                ),
                actionIconSize: device(deviceType)
                    .cardMetrics
                    .outsideActionIconSize,
                titleTextStyle: TextStyle(
                  fontSize: device(deviceType).cardMetrics.outsideTitleFontSize,
                  color: c.surface.outsideTitleColor?.resolve(colors),
                ),
                actionTextStyle: TextStyle(
                  fontSize: device(deviceType)
                      .cardMetrics
                      .outsideActionFontSize,
                  color: c.surface.outsideActionColor?.resolve(colors),
                ),
              ),
            ),
        style: (theme.titledCardTheme.style ?? const HyperTitledCardStyle())
            .merge(
              HyperTitledCardStyle(
                titleTextStyle: TextStyle(
                  fontSize: device(deviceType).cardMetrics.titleFontSize,
                  color: c.surface.titleColor?.resolve(colors),
                ),
                actionTextStyle: TextStyle(
                  fontSize: device(deviceType).cardMetrics.actionFontSize,
                  color: c.surface.actionColor?.resolve(colors),
                ),
              ),
            ),
      ),
      cardTheme: theme.cardTheme.copyWith(
        style: (theme.cardTheme.style ?? HyperCardStyle()).merge(
          HyperCardStyle(
            material: resolveEditorReviewMaterial(c.material, theme),
            background: background(c),
            border: c.border.resolve(colors),
            foregroundColor: c.foreground?.resolve(colors),
            padding: device(deviceType).cardMetrics.resolvedPadding(
              theme.sizes
                  .resolve(deviceType)
                  .card
                  .padding
                  .resolve(TextDirection.ltr),
            ),
            overlayColor: c.surface.overlayColor?.resolve(colors),
            pressedScale: c.surface.pressedScale,
            animationDuration: c.surface.animationDuration,
            animationCurve: c.surface.animationCurve,
            clipBehavior: c.surface.clipping,
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
                    errorTextStyle: TextStyle(
                      fontSize: device(deviceType)
                          .textFieldMetrics
                          .errorFontSize,
                    ),
                    errorPopupStyle: HyperCardStyle(
                      padding:
                          device(deviceType)
                                  .textFieldMetrics
                                  .errorPopupPadding ==
                              null
                          ? null
                          : EdgeInsets.all(
                              device(deviceType)
                                  .textFieldMetrics
                                  .errorPopupPadding!,
                            ),
                      borderRadius:
                          device(deviceType)
                                  .textFieldMetrics
                                  .errorPopupRadius ==
                              null
                          ? null
                          : BorderRadius.circular(
                              device(deviceType)
                                  .textFieldMetrics
                                  .errorPopupRadius!,
                            ),
                      border:
                          device(deviceType)
                                  .textFieldMetrics
                                  .errorPopupBorderWidth ==
                              null
                          ? null
                          : Border.all(
                              width: device(deviceType)
                                  .textFieldMetrics
                                  .errorPopupBorderWidth!,
                              color:
                                  f.textFieldStyle.errorPopupBorderColor
                                      ?.resolve(colors) ??
                                  colors.outline,
                            ),
                    ),
                    background: background(f),
                    border: f.border.resolve(colors),
                    foregroundColor: f.foreground?.resolve(colors),
                    boxShadow: f.shadows
                        ?.map((s) => s.resolve(colors))
                        .toList(),
                  ),
                ),
          ),
      fieldTheme: theme.fieldTheme.copyWith(
        style: m.formFields.resolve(colors),
      ),
      calendarTheme: theme.calendarTheme.copyWith(
        style: HyperCalendarStyle(
          textStyle: m.calendar.fontSize == null
              ? null
              : TextStyle(fontSize: m.calendar.fontSize),
          foregroundColor: m.calendar.foreground?.resolve(colors),
          selectedColor: m.calendar.selection?.resolve(colors),
          selectedForegroundColor: m.calendar.selectedForeground?.resolve(
            colors,
          ),
          backgroundColor: m.calendar.background?.resolve(colors),
          disabledColor: m.calendar.disabledForeground?.resolve(colors),
        ),
      ),
      wheelPickerTheme: theme.wheelPickerTheme.copyWith(
        style: m.wheel.resolve(colors),
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
    return applyEditorReviews(
      applyEditorInputs(theme, m, device(deviceType), deviceType),
      this,
      m,
      deviceType,
    );
  }
}
