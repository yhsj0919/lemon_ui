import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';

void main() {
  test('状态阴影保存、变体继承和空列表关闭', () {
    final doc = EditorThemeDocument();
    doc.light.button.hoveredShadow.shadows = [EditorShadow(blur: 12)];
    doc.light.button.pressedShadow.shadows = [];
    doc.light.field.focusedShadow.shadows = [
      EditorShadow(dx: 0, dy: 0, blur: 0, spread: 3),
    ];
    final restored = EditorThemeDocument.decode(doc.encode());
    expect(restored.encode(), doc.encode());
    final theme = restored.resolve(false);
    for (final variant in HyperButtonVariant.values) {
      final style = theme.buttonTheme.resolve(variant);
      expect(style.hoveredBoxShadow, hasLength(1));
      expect(style.pressedBoxShadow, isEmpty);
    }
    expect(theme.textFieldTheme.focused.boxShadow!.single.spreadRadius, 3);
    expect(restored.resolve(true).textFieldTheme.focused.boxShadow, isNull);
  });
  test('按钮状态阴影复制、插值、相等和不可变', () {
    final list = [const BoxShadow(blurRadius: 12)];
    final a = HyperButtonStyle(hoveredBoxShadow: list, pressedBoxShadow: []);
    list.clear();
    expect(a.hoveredBoxShadow, hasLength(1));
    expect(a.copyWith(), a);
    expect(a.copyWith(hoveredBoxShadow: null).hoveredBoxShadow, isNull);
    expect(a.copyWith(pressedBoxShadow: null), isNot(a));
    final b = a.copyWith(hoveredBoxShadow: [const BoxShadow(blurRadius: 20)]);
    expect(
      HyperButtonStyle.lerp(a, b, .5).hoveredBoxShadow!.single.blurRadius,
      16,
    );
  });
}
