import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/editor/editor_text_field_fields.dart';

void main() {
  test('新增输入文字、图标、错误浮层配置保存和设备隔离', () {
    final d = EditorThemeDocument();
    d.light.field.textFieldStyle
      ..textWeight = 600
      ..hintWeight = 500
      ..labelWeight = 700
      ..counterWeight = 300
      ..verticalAlignment = 'bottom'
      ..motionCurve = 'linear'
      ..clearIconName = 'cancel'
      ..showPasswordIconName = 'lockOpen'
      ..hidePasswordIconName = 'lock'
      ..errorIconName = 'warning'
      ..errorWeight = 500
      ..errorPlacement = 'topStart'
      ..errorTextColor = const EditorColor(argb: 0xFF123456)
      ..errorPopupBackground = const EditorColor(argb: 0xFF345678)
      ..errorPopupBorderColor = const EditorColor(argb: 0xFF654321);
    d.light.field.textFieldStyle.errorPopupShadow.shadows = [];
    d.desktop.textFieldMetrics
      ..errorFontSize = 19
      ..errorPopupRadius = 12
      ..errorPopupPadding = 15
      ..errorPopupBorderWidth = 2;
    final r = EditorThemeDocument.decode(d.encode());
    expect(r.encode(), d.encode());
    final style = r.resolve(false).textFieldTheme.style;
    expect(style.textStyle!.fontWeight, FontWeight.w600);
    expect(style.hintStyle!.fontWeight, FontWeight.w500);
    expect(style.labelStyle!.fontWeight, FontWeight.w700);
    expect(style.counterStyle!.fontWeight, FontWeight.w300);
    expect(style.textAlignVertical, TextAlignVertical.bottom);
    expect(style.curve, Curves.linear);
    expect(style.clearIcon, Icons.cancel_outlined);
    expect(style.errorIcon, Icons.warning_amber_outlined);
    expect(style.errorPlacement, HyperOverlayPlacement.topStart);
    expect(style.errorTextStyle!.fontSize, 19);
    expect(style.errorTextStyle!.fontWeight, FontWeight.w500);
    expect(style.errorTextStyle!.color, const Color(0xFF123456));
    expect(style.errorPopupStyle!.padding, const EdgeInsets.all(15));
    expect(style.errorPopupStyle!.boxShadow, isEmpty);
    expect(style.errorPopupStyle!.borderRadius, BorderRadius.circular(12));
    expect(style.errorPopupStyle!.background!.color, const Color(0xFF345678));
    expect(style.errorPopupStyle!.border!.top.width, 2);
    expect(style.errorPopupStyle!.border!.top.color, const Color(0xFF654321));
    expect(
      r
          .resolve(false, deviceType: HyperDeviceType.phone)
          .textFieldTheme
          .style
          .errorTextStyle!
          .fontSize,
      isNull,
    );
    expect(
      () => EditorTextFieldVisual.fromJson({'errorPlacement': 'wrong'}),
      throwsFormatException,
    );
  });
  test('输入框保存回读、四端隔离和亮暗状态覆盖', () {
    final doc = EditorThemeDocument();
    doc.desktop.textFieldMetrics.horizontalPadding = 23;
    doc.desktop.textFieldMetrics.actionWidth = 37;
    doc.desktop.textFieldMetrics.errorMaxWidth = 440;
    doc.light.field.textFieldStyle
      ..focusBorderColor = const EditorColor(semantic: 'primary')
      ..disabledForegroundColor = const EditorColor(argb: 0xff123456)
      ..hintFontSize = 18
      ..cursorWidth = 3
      ..durationMilliseconds = 320;
    final restored = EditorThemeDocument.decode(doc.encode());
    expect(restored.encode(), doc.encode());
    final theme = restored.resolve(false);
    final desktop = theme.sizes.resolve(HyperDeviceType.desktop).textField;
    expect(desktop.horizontalPadding, 23);
    expect(desktop.actionWidth, 37);
    expect(desktop.errorMaxWidth, 440);
    expect(
      theme.sizes.resolve(HyperDeviceType.phone).textField,
      EditorThemeDocument()
          .resolve(false)
          .sizes
          .resolve(HyperDeviceType.phone)
          .textField,
    );
    expect(theme.textFieldTheme.focused.borderColor, theme.colors.primary);
    expect(
      theme.textFieldTheme.disabled.foregroundColor,
      const Color(0xff123456),
    );
    expect(theme.textFieldTheme.style.hintStyle!.fontSize, 18);
    expect(theme.textFieldTheme.style.cursorWidth, 3);
    expect(
      theme.textFieldTheme.style.duration,
      const Duration(milliseconds: 320),
    );
    expect(
      restored.resolve(true).textFieldTheme,
      EditorThemeDocument().resolve(true).textFieldTheme,
    );
    restored.light.field.textFieldStyle = EditorTextFieldVisual();
    restored.desktop.textFieldMetrics = EditorTextFieldMetrics();
    expect(
      restored.resolve(false).textFieldTheme,
      EditorThemeDocument().resolve(false).textFieldTheme,
    );
    expect(
      restored.resolve(false).sizes.resolve(HyperDeviceType.desktop).textField,
      EditorThemeDocument()
          .resolve(false)
          .sizes
          .resolve(HyperDeviceType.desktop)
          .textField,
    );
  });
  test('拒绝无效输入框字段与尺寸', () {
    expect(
      () => EditorTextFieldVisual.fromJson({'cursorWidth': -1}),
      throwsFormatException,
    );
    expect(
      () => EditorTextFieldVisual.fromJson({'hintFontSize': 0}),
      throwsFormatException,
    );
    expect(
      () => EditorTextFieldMetrics.fromJson({'actionWidth': double.nan}),
      throwsFormatException,
    );
    expect(
      () => EditorTextFieldMetrics.fromJson({'unknown': 1}),
      throwsFormatException,
    );
  });
}
