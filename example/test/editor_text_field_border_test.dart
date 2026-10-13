import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/editor/editor_button_fields.dart';

void main() {
  test('五态边框独立保存，状态优先级与关闭边框', () {
    final doc = EditorThemeDocument();
    doc.light.field.border
      ..kind = EditorBorderKind.solid
      ..width = 1;
    final v = doc.light.field.textFieldStyle;
    v.hoveredBorder
      ..kind = EditorBorderKind.solid
      ..width = 2;
    v.focusedBorder
      ..kind = EditorBorderKind.solid
      ..width = 3
      ..color = const EditorColor(argb: 0xff112233);
    v.errorBorder
      ..kind = EditorBorderKind.solid
      ..width = 4;
    v.disabledBorder.kind = EditorBorderKind.none;
    final restored = EditorThemeDocument.decode(doc.encode());
    expect(restored.encode(), doc.encode());
    final theme = restored.resolve(false),
        field = restored.resolve(false).textFieldTheme;
    BoxBorder border(Set<HyperControlState> states) =>
        field.resolve(states).border!;
    expect(border({}).top.width, 1);
    expect(border({HyperControlState.hovered}).top.width, 2);
    expect(border({HyperControlState.focused}).top.width, 3);
    expect(
      border({HyperControlState.focused}).top.color,
      const Color(0xff112233),
    );
    expect(
      border({HyperControlState.focused, HyperControlState.error}).top.width,
      4,
    );
    expect(border({HyperControlState.error}).top.color, theme.colors.error);
    expect(
      border({HyperControlState.error, HyperControlState.disabled}).top,
      BorderSide.none,
    );
    expect(restored.resolve(true).textFieldTheme.style.border, isNull);
  });
  test('默认显式形态不遮盖聚焦和错误的语义颜色，旧颜色配置继续生效', () {
    final doc = EditorThemeDocument();
    doc.light.field.border.kind = EditorBorderKind.dashed;
    final theme = doc.resolve(false);
    final f = theme.textFieldTheme;
    expect(f.focused.border, isNotNull);
    expect(f.error.border, isNotNull);
    doc.light.field.textFieldStyle.focusBorderColor = const EditorColor(
      argb: 0xff123456,
    );
    final loaded = EditorThemeDocument.decode(doc.encode());
    expect(
      loaded.resolve(false).textFieldTheme.focused.borderColor,
      const Color(0xff123456),
    );
    loaded.light.field.textFieldStyle.focusedBorder.width = 0;
    expect(
      (loaded.resolve(false).textFieldTheme.focused.border! as Border).top,
      BorderSide.none,
    );
  });
}
