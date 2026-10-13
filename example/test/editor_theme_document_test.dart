import 'dart:convert';

import 'package:lemon_ui_example/editor/editor_button_fields.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/editor/editor_global_fields.dart';

void main() {
  test('三种渐变类型保存恢复并映射真实 Flutter 参数', () {
    for (final kind in EditorGradientKind.values) {
      final doc = EditorThemeDocument();
      doc.light.card.fillKind = EditorFillKind.gradient;
      doc.light.card.gradient = EditorGradient(
        colors: [
          const EditorColor(semantic: 'primary'),
          const EditorColor(argb: 0x800000ff),
        ],
        stops: [0, 1],
        kind: kind,
        centerX: .2,
        centerY: -.3,
        radius: .8,
        angle: 30,
        startAngle: 20,
        endAngle: 300,
      );
      final restored = EditorThemeDocument.decode(doc.encode());
      expect(restored.encode(), doc.encode());
      final value = restored
          .resolve(false)
          .cardTheme
          .style!
          .background!
          .gradient!;
      expect(value.colors.first, restored.resolve(false).colors.primary);
      switch (kind) {
        case EditorGradientKind.linear:
          expect(value, isA<LinearGradient>());
        case EditorGradientKind.radial:
          expect((value as RadialGradient).center, const Alignment(.2, -.3));
          expect(value.radius, .8);
        case EditorGradientKind.sweep:
          expect((value as SweepGradient).center, const Alignment(.2, -.3));
          expect(value.startAngle, closeTo(.34906585, .00001));
          expect(value.endAngle, closeTo(5.23598775, .00001));
          expect(
            (value.transform as GradientRotation).radians,
            closeTo(.52359878, .00001),
          );
      }
      final inherited = EditorGradient.fromGradient(value)
          .resolve(restored.resolve(false).colors);
      expect(inherited.colors, value.colors);
      expect(inherited.runtimeType, value.runtimeType);
    }
  });
  test('旧渐变默认为线性，新增参数拒绝无效范围', () {
    final json = EditorGradient(
      colors: [
        const EditorColor(argb: 0xff000000),
        const EditorColor(argb: 0xffffffff),
      ],
      stops: [0, 1],
    ).toJson();
    expect(EditorGradient.fromJson(json).kind, EditorGradientKind.linear);
    for (final fields in <Map<String, Object>>[
      {'kind': 'unknown'},
      {'radius': 0},
      {'centerX': 2},
      {'startAngle': 90, 'endAngle': 90},
      {'startAngle': 0, 'endAngle': .01},
    ]) {
      expect(
        () => EditorGradient.fromJson({...json, ...fields}),
        throwsFormatException,
      );
    }
  });
  test('按钮三档高度、宽度与内边距保存恢复，设备之间独立', () {
    final doc = EditorThemeDocument();
    doc.desktop.buttonHeight = 36;
    doc.desktop.buttonMetrics
      ..smallHeight = 28
      ..largeHeight = 48
      ..minimumWidth = 90
      ..smallMinimumWidth = 80
      ..largeMinimumWidth = 100
      ..smallWidth = 110
      ..width = 140
      ..largeWidth = 180
      ..smallPaddingVertical = 2
      ..paddingVertical = 4
      ..largePaddingVertical = 8;
    final restored = EditorThemeDocument.decode(doc.encode());
    expect(restored.encode(), doc.encode());
    final button = restored.resolve(false).sizes.desktop.button;
    expect(HyperButtonSizeVariant.values.map(button.heightFor), [28, 36, 48]);
    expect(HyperButtonSizeVariant.values.map(button.minimumWidthFor), [
      80,
      90,
      100,
    ]);
    expect(HyperButtonSizeVariant.values.map(button.widthFor), [110, 140, 180]);
    expect(restored.resolve(false).sizes.phone.button.width, isNull);
    restored.desktop.buttonMetrics.width = null;
    expect(restored.resolve(false).sizes.desktop.button.width, isNull);
    expect(restored.resolve(false).sizes.desktop.button.smallWidth, 110);
  });
  test('各组件填充类型与虚线边框保存恢复，实例属性可覆盖', () {
    final doc = EditorThemeDocument();
    final gradient = EditorGradient(
      colors: [
        const EditorColor(semantic: 'primary'),
        const EditorColor(argb: 0x80ff0000),
      ],
      stops: [0, 1],
      angle: 45,
    );
    for (final component in [
      doc.light.card,
      doc.light.field,
      doc.light.menu,
      ...HyperButtonVariant.values.map(doc.light.buttonVariants.forVariant),
    ]) {
      component.fillKind = EditorFillKind.gradient;
      component.gradient = gradient;
      component.border.kind = EditorBorderKind.dashed;
      component.border.width = 2;
      component.border.color = const EditorColor(argb: 0xffff0000);
      component.border.dashLength = 8;
      component.border.gapLength = 3;
    }
    final restored = EditorThemeDocument.decode(doc.encode());
    expect(restored.encode(), doc.encode());
    final theme = restored.resolve(false);
    expect(theme.cardTheme.style!.background!.gradient, isA<LinearGradient>());
    expect(theme.textFieldTheme.style.border, isA<HyperLineBorder>());
    expect(theme.menuTheme.style!.surfaceStyle!.border, isA<HyperLineBorder>());
    for (final variant in HyperButtonVariant.values) {
      expect(
        theme.buttonTheme.resolve(variant).background!.gradient,
        isA<LinearGradient>(),
      );
      expect(
        (theme.buttonTheme.resolve(variant).boxBorder as HyperLineBorder)
            .line
            .dashLength,
        8,
      );
    }
    restored.light.buttonVariants.text.fillKind = EditorFillKind.none;
    restored.light.card.fillKind = EditorFillKind.solid;
    restored.light.card.background = const EditorColor(argb: 0xff123456);
    restored.light.field.fillKind = EditorFillKind.none;
    restored.light.menu.border.kind = EditorBorderKind.none;
    final changed = restored.resolve(false);
    expect(
      changed.buttonTheme.resolve(HyperButtonVariant.text).background!.isNone,
      isTrue,
    );
    expect(changed.cardTheme.style!.background!.color, const Color(0xff123456));
    expect(changed.textFieldTheme.style.background!.isNone, isTrue);
    expect(changed.menuTheme.style!.surfaceStyle!.border, const Border());
    restored.light.card.border.width = 0;
    expect(restored.resolve(false).cardTheme.style!.border, const Border());
  });
  test('按钮通用背景显式类型由各变体继承，独立覆盖优先', () {
    final doc = EditorThemeDocument();
    doc.light.button.fillKind = EditorFillKind.gradient;
    doc.light.button.gradient = EditorGradient(
      colors: [
        const EditorColor(semantic: 'primary'),
        const EditorColor(semantic: 'surface'),
      ],
      stops: [0, 1],
    );
    doc.light.buttonVariants.ghost.fillKind = EditorFillKind.none;
    final theme = doc.resolve(false);
    expect(
      theme.buttonTheme.resolve(HyperButtonVariant.filled).background!.gradient,
      isNotNull,
    );
    expect(
      theme.buttonTheme.resolve(HyperButtonVariant.text).background!.gradient,
      isNotNull,
    );
    expect(
      theme.buttonTheme.resolve(HyperButtonVariant.ghost).background!.isNone,
      isTrue,
    );
  });
  test('按钮渐变保存恢复，语义颜色跟随主题且不影响其他变体', () {
    final doc = EditorThemeDocument();
    doc.light.buttonVariants.gradient.buttonStyle.gradient = EditorGradient(
      colors: [
        const EditorColor(semantic: 'primary'),
        const EditorColor(argb: 0x80ff0000),
        const EditorColor(argb: 0xff000000),
      ],
      stops: [0, .3, 1],
      angle: 90,
    );
    final restored = EditorThemeDocument.decode(doc.encode());
    expect(restored.encode(), doc.encode());
    final theme = restored.resolve(false);
    final gradient =
        theme.buttonTheme
                .resolve(HyperButtonVariant.gradient)
                .background!
                .gradient
            as LinearGradient;
    expect(gradient.colors, [
      theme.colors.primary,
      const Color(0x80ff0000),
      Colors.black,
    ]);
    expect(gradient.stops, [0, .3, 1]);
    expect(gradient.end.resolve(TextDirection.ltr).y, closeTo(1, .00001));
    expect(
      theme.buttonTheme.resolve(HyperButtonVariant.filled).background?.gradient,
      isNull,
    );
    expect(
      restored
          .resolve(true)
          .buttonTheme
          .resolve(HyperButtonVariant.gradient)
          .background
          ?.gradient,
      isNot(gradient),
    );
    restored.light.seed = 0xff00aa88;
    expect(
      restored
          .resolve(false)
          .buttonTheme
          .resolve(HyperButtonVariant.gradient)
          .background!
          .gradient!
          .colors
          .first,
      restored.resolve(false).colors.primary,
    );
    restored.light.buttonVariants.gradient.buttonStyle.gradient = null;
    expect(
      restored
          .resolve(false)
          .buttonTheme
          .resolve(HyperButtonVariant.gradient)
          .background,
      isNull,
    );
  });
  test('渐变导入拒绝乱序、越界和不足两个节点', () {
    for (final stops in [
      [.8, .2],
      [0, 2],
      [0],
    ]) {
      expect(
        () => EditorGradient.fromJson({
          'colors': List.generate(stops.length, (_) => {'argb': 0xff000000}),
          'stops': stops,
        }),
        throwsFormatException,
      );
    }
  });
  test('全局材质零宽度关闭边框，保存恢复后仍保持关闭', () {
    final doc = EditorThemeDocument();
    doc.light.material = HyperSurfaceMaterialKind.frostedGlass;
    doc.light.materialBorderWidth = 0;
    doc.light.materialBorder = const EditorColor(argb: 0xffff0000);
    final restored = EditorThemeDocument.decode(doc.encode());
    expect(
      restored.resolve(false).materialTheme.material!.border,
      BorderSide.none,
    );
    restored.light.materialBorderWidth = 2;
    expect(
      restored.resolve(false).materialTheme.material!.border,
      const BorderSide(color: Color(0xffff0000), width: 2),
    );
  });
  test('按钮边框宽度零关闭边框，正值绘制，清空恢复继承', () {
    final doc = EditorThemeDocument();
    doc.light.button.buttonStyle.borderWidth = 0;
    doc.light.button.buttonStyle.borderColor = const EditorColor(
      argb: 0xffff0000,
    );
    final restored = EditorThemeDocument.decode(doc.encode());
    for (final variant in HyperButtonVariant.values) {
      expect(
        restored.resolve(false).buttonTheme.resolve(variant).border,
        BorderSide.none,
      );
    }
    restored.light.button.buttonStyle.borderWidth = 2;
    expect(
      restored
          .resolve(false)
          .buttonTheme
          .resolve(HyperButtonVariant.outlined)
          .border,
      const BorderSide(color: Color(0xffff0000), width: 2),
    );
    restored.light.button.buttonStyle.borderWidth = null;
    restored.light.button.buttonStyle.borderColor = null;
    expect(
      restored
          .resolve(false)
          .buttonTheme
          .resolve(HyperButtonVariant.outlined)
          .border,
      HyperThemeData.light().buttonTheme
          .resolve(HyperButtonVariant.outlined)
          .border,
    );
  });
  test('真实按钮属性保存恢复并区分变体和设备', () {
    final doc = EditorThemeDocument();
    doc.light.button.buttonStyle.disabledForeground = EditorColor(
      argb: 0xff112233,
    );
    doc.light.button.buttonStyle.hoverOpacity = .15;
    doc.light.buttonVariants.filled.buttonStyle.borderColor = EditorColor(
      semantic: 'primary',
    );
    doc.light.buttonVariants.filled.buttonStyle.borderWidth = 3;
    doc.light.buttonVariants.tonal.buttonStyle.progressColor = EditorColor(
      argb: 0xffaabbcc,
    );
    doc.light.buttonVariants.tonal.buttonStyle.animationMilliseconds = 350;
    doc.phone.buttonMetrics.iconSize = 27;
    doc.phone.buttonMetrics.smallHeight = 35;
    doc.phone.buttonMetrics.paddingHorizontal = 19;
    final restored = EditorThemeDocument.decode(doc.encode());
    final theme = restored.resolve(false);
    expect(
      theme.buttonTheme
          .resolve(HyperButtonVariant.filled)
          .disabledForegroundColor,
      const Color(0xff112233),
    );
    expect(
      theme.buttonTheme.resolve(HyperButtonVariant.tonal).hoverOverlayOpacity,
      .15,
    );
    expect(theme.buttonTheme.filled!.border!.width, 3);
    expect(theme.buttonTheme.filled!.border!.color, theme.colors.primary);
    expect(theme.buttonTheme.tonal!.progressColor, const Color(0xffaabbcc));
    expect(
      theme.buttonTheme.tonal!.animationDuration,
      const Duration(milliseconds: 350),
    );
    expect(theme.sizes.phone.button.iconSize, 27);
    expect(theme.sizes.phone.button.smallHeight, 35);
    expect(
      theme.sizes.phone.button.padding.resolve(TextDirection.ltr).left,
      19,
    );
    expect(theme.sizes.desktop.button.iconSize, isNot(27));
    expect(restored.encode(), doc.encode());
  });
  test('通用按钮颜色按变体派生，不覆盖无填充或渐变语义', () {
    final doc = EditorThemeDocument();
    doc.light.button.background = EditorColor(argb: 0xffff6900);
    final theme = doc.resolve(false);
    final button = theme.buttonTheme;
    expect(button.style!.background, isNull);
    expect(button.filled!.background!.color, const Color(0xffff6900));
    expect(
      button.tonal!.background!.color,
      isNot(button.filled!.background!.color),
    );
    expect(button.outlined!.background, isNull);
    expect(button.text!.foregroundColor, const Color(0xffff6900));
    expect(button.ghost!.background, isNull);
    expect(button.gradient!.background?.gradient, isNotNull);
    doc.light.buttonVariants.tonal.background = EditorColor(argb: 0xff112233);
    expect(
      doc.resolve(false).buttonTheme.tonal!.background!.color,
      const Color(0xff112233),
    );
    expect(
      EditorThemeDocument.decode(doc.encode()).resolve(false).buttonTheme,
      doc.resolve(false).buttonTheme,
    );
  });
  test('按钮变体独立保存并恢复，未覆盖变体继续继承', () {
    final doc = EditorThemeDocument();
    doc.light.button.foreground = EditorColor(argb: 0xff112233);
    doc.light.buttonVariants.filled.background = EditorColor(argb: 0xffee1122);
    doc.light.buttonVariants.tonal.background = EditorColor(argb: 0xff22bb33);
    doc.light.buttonVariants.filled.shadows = [];
    final restored = EditorThemeDocument.decode(doc.encode());
    final theme = restored.resolve(false).buttonTheme;
    expect(theme.filled!.background!.color, const Color(0xffee1122));
    expect(theme.tonal!.background!.color, const Color(0xff22bb33));
    expect(theme.filled!.boxShadow, isEmpty);
    expect(
      theme.resolve(HyperButtonVariant.filled).foregroundColor,
      const Color(0xff112233),
    );
    expect(theme.ghost!.background, isNull);
    expect(restored.dark.buttonVariants.toJson(), isEmpty);
    expect(restored.encode(), doc.encode());
  });
  test('完整全局字段保存并通过强类型主题生效，明暗与设备独立', () {
    final doc = EditorThemeDocument();
    doc.light.palette.surfaceElevated = const Color(0xff123456);
    doc.light.palette.onWarning = const Color(0xffabcdef);
    doc.desktop.typography.pageTitle = 45;
    doc.desktop.typography.listTitleLineHeight = 1.8;
    doc.desktop.layout.pageHorizontalPadding = 30;
    doc.desktop.layout.paddingLeft = 17;
    doc.light.behavior.fastDuration = 175;
    doc.light.behavior.standardCurve = EditorCurve.linear;
    doc.light.behavior.springDamping = 40;
    doc.light.behavior.quality = HyperMaterialQuality.standard;
    doc.light.behavior.minimumContrastRatio = 7;
    doc.light.fontFamily = 'Test Font';
    doc.light.material = HyperSurfaceMaterialKind.frostedGlass;
    doc.light.materialAppearance.background = const EditorColor(
      argb: 0xff123456,
    );
    doc.light.materialTint = const EditorColor(argb: 0x33abcdef);
    doc.light.materialBorderWidth = 2;
    doc.light.materialAppearance.shadows = [EditorShadow(blur: 18)];
    doc.light.opacity = .6;
    doc.light.blur = 13;
    doc.light.blurY = 17;
    final restored = EditorThemeDocument.decode(doc.encode());
    expect(restored.encode(), doc.encode());
    final theme = restored.resolve(false);
    expect(theme.colors.surfaceElevated, const Color(0xff123456));
    expect(theme.colors.onWarning, const Color(0xffabcdef));
    expect(theme.typographyTheme.desktop.pageTitle, 45);
    expect(theme.typographyTheme.desktop.listTitleLineHeight, 1.8);
    expect(theme.sizes.desktop.pageHorizontalPadding, 30);
    expect(
      theme.sizes.desktop.controlPadding.resolve(TextDirection.ltr).left,
      17,
    );
    expect(theme.motion.fastDuration.inMilliseconds, 175);
    expect(theme.motion.standardCurve, Curves.linear);
    expect(theme.motion.spring.damping, 40);
    expect(theme.materialTheme.quality, HyperMaterialQuality.standard);
    expect(theme.contrastTheme.minimumContrastRatio, 7);
    expect(theme.textTheme.bodyMedium!.fontFamily, 'Test Font');
    expect(theme.materialTheme.material!.blurSigmaX, 13);
    expect(theme.materialTheme.material!.blurSigmaY, 17);
    expect(
      theme.materialTheme.material!.background!.color!.a,
      closeTo(.6, .01),
    );
    expect(theme.materialTheme.material!.tint, const Color(0x33abcdef));
    expect(theme.materialTheme.material!.border!.width, 2);
    expect(theme.materialTheme.material!.boxShadow.single.blurRadius, 18);
    expect(theme.typographyTheme.phone.pageTitle, isNot(45));
    expect(
      restored.resolve(true).colors.surfaceElevated,
      isNot(theme.colors.surfaceElevated),
    );
  });
  test('默认文件省略样式，显式空阴影可往返', () {
    final doc = EditorThemeDocument();
    expect(doc.toJson().containsKey('light'), isFalse);
    expect(doc.toJson()['devices'], isEmpty);
    doc.light.card.shadows = [];
    final restored = EditorThemeDocument.decode(doc.encode());
    expect(restored.resolve(false).cardTheme.style!.boxShadow, isEmpty);
    restored.light.card.shadows = null;
    expect(restored.toJson().containsKey('light'), isFalse);
  });
  test('语义颜色跟随主题色，自定义色保持固定', () {
    final doc = EditorThemeDocument();
    doc.light.button.foreground = const EditorColor(semantic: 'primary');
    doc.light.card.foreground = const EditorColor(argb: 0xffff0000);
    doc.light.seed = 0xff00aa88;
    final restored = EditorThemeDocument.decode(doc.encode());
    final theme = restored.resolve(false);
    expect(theme.buttonTheme.style!.foregroundColor, theme.colors.primary);
    expect(theme.cardTheme.style!.foregroundColor, const Color(0xffff0000));
    restored.light.seed = 0xff8844dd;
    expect(
      restored.resolve(false).buttonTheme.style!.foregroundColor,
      restored.resolve(false).colors.primary,
    );
  });
  test('四端及亮暗独立，玻璃与彩色阴影往返', () {
    final doc = EditorThemeDocument();
    doc.desktop.buttonHeight = 44;
    doc.phone.fieldHeight = 60;
    doc.light.material = HyperSurfaceMaterialKind.frostedGlass;
    doc.light.opacity = .4;
    doc.light.blur = 12;
    doc.dark.seed = 0xffee9900;
    doc.light.card.shadows = [
      EditorShadow(
        color: const EditorColor(argb: 0x803482ff),
        opacity: 1,
        dx: -2,
        dy: 6,
        blur: 24,
        spread: 3,
      ),
    ];
    final restored = EditorThemeDocument.decode(doc.encode());
    expect(restored.encode(), doc.encode());
    final light = restored.resolve(false), dark = restored.resolve(true);
    expect(light.sizes.desktop.button.minimumSize.height, 44);
    expect(light.sizes.phone.textField.minimumHeight, 60);
    expect(
      light.sizes.tablet.button.minimumSize.height,
      HyperThemeData.light().sizes.tablet.button.minimumSize.height,
    );
    expect(light.materialTheme.material!.blurSigmaX, 12);
    expect(
      light.materialTheme.material!.background!.color!.a,
      closeTo(.4, .01),
    );
    expect(dark.materialTheme.material, isNull);
    expect(
      light.cardTheme.style!.boxShadow!.first.color,
      const Color(0x803482ff),
    );
  });
  test('未知版本及错误值拒绝导入', () {
    final j = EditorThemeDocument().toJson();
    expect(
      () => EditorThemeDocument.decode(jsonEncode({...j, 'formatVersion': 9})),
      throwsFormatException,
    );
    expect(
      () => EditorThemeDocument.decode(
        jsonEncode({
          ...j,
          'light': {'opacity': 2},
        }),
      ),
      throwsFormatException,
    );
    expect(
      () => EditorColor.fromJson({'semantic': 'missing'}),
      throwsFormatException,
    );
  });
}
