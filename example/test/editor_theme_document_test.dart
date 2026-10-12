import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/editor/editor_global_fields.dart';

void main() {
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
