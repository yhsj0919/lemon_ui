import 'dart:convert';

import 'editor_global_fields.dart';

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
  List<EditorShadow>? shadows;
  Map<String, Object?> toJson() => {
    if (background != null) 'background': background!.toJson(),
    if (foreground != null) 'foreground': foreground!.toJson(),
    if (shadows != null) 'shadows': [for (final s in shadows!) s.toJson()],
  };
  factory EditorComponent.fromJson(Map<String, dynamic> json) {
    _checkFields(json, {'background', 'foreground', 'shadows'});
    return EditorComponent(
      background: json['background'] == null
          ? null
          : EditorColor.fromJson(json['background'] as Map<String, dynamic>),
      foreground: json['foreground'] == null
          ? null
          : EditorColor.fromJson(json['foreground'] as Map<String, dynamic>),
      shadows: (json['shadows'] as List<dynamic>?)
          ?.map((dynamic s) => EditorShadow.fromJson(s as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// 阴影保留语义颜色引用和独立透明度。
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
  final card = EditorComponent();
  final field = EditorComponent();
  final menu = EditorComponent();
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
    if (card.toJson().isNotEmpty) 'card': card.toJson(),
    if (field.toJson().isNotEmpty) 'field': field.toJson(),
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
      'card',
      'field',
      'menu',
    });
    final result = EditorMode()
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
    }

    read('materialAppearance', result.materialAppearance);
    read('button', result.button);
    read('card', result.card);
    read('field', result.field);
    read('menu', result.menu);
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
    return d;
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
          button: s.button.copyWith(
            minimumSize: Size(
              s.button.minimumSize.width,
              d.buttonHeight ?? s.button.minimumSize.height,
            ),
            radius: d.buttonRadius,
          ),
          card: s.card.copyWith(radius: d.cardRadius),
          textField: s.textField.copyWith(
            minimumHeight: d.fieldHeight,
            radius: d.fieldRadius,
          ),
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
    HyperFill? background(EditorComponent c) => c.background == null
        ? null
        : HyperFill.color(c.background!.resolve(colors));
    final b = m.button, c = m.card, f = m.field, n = m.menu;
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
        style: (theme.buttonTheme.style ?? HyperButtonStyle()).merge(
          HyperButtonStyle(
            background: background(b),
            foregroundColor: b.foreground?.resolve(colors),
            boxShadow: b.shadows?.map((s) => s.resolve(colors)).toList(),
          ),
        ),
      ),
      cardTheme: theme.cardTheme.copyWith(
        style: (theme.cardTheme.style ?? HyperCardStyle()).merge(
          HyperCardStyle(
            background: background(c),
            foregroundColor: c.foreground?.resolve(colors),
            boxShadow: c.shadows?.map((s) => s.resolve(colors)).toList(),
          ),
        ),
      ),
      textFieldTheme: theme.textFieldTheme.copyWith(
        style: theme.textFieldTheme.style.merge(
          HyperTextFieldStyle(
            background: background(f),
            foregroundColor: f.foreground?.resolve(colors),
            boxShadow: f.shadows?.map((s) => s.resolve(colors)).toList(),
          ),
        ),
      ),
      menuTheme: theme.menuTheme.copyWith(
        style: HyperMenuStyle(
          foregroundColor: n.foreground?.resolve(colors),
          surfaceStyle: HyperCardStyle(
            background: background(n),
            boxShadow: n.shadows?.map((s) => s.resolve(colors)).toList(),
          ),
        ),
      ),
    );
    return theme;
  }
}
