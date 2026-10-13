import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/editor/editor_text_field_fields.dart';

void main() {
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
