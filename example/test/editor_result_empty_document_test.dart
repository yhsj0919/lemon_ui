import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';

void main() {
  test('旧空状态文档导入后输出 Result.empty 并保持亮暗和设备归属', () {
    final doc = EditorThemeDocument();
    doc.light.reviews.emptyState.iconColor = const EditorColor(
      argb: 0xFF123456,
    );
    doc.light.reviews.emptyState.shadow.shadows = [];
    doc.desktop.reviews.emptyState.iconSize = 44;
    final loaded = EditorThemeDocument.decode(doc.encode());
    final theme = loaded.resolve(false);
    final empty = theme.resultTheme.resolve(HyperResultStatus.empty);
    expect(empty.iconColor, const Color(0xFF123456));
    expect(empty.boxShadow, isEmpty);
    expect(theme.sizes.desktop.result.empty.iconSize, 44);
    expect(loaded.resolve(true).resultTheme.empty.iconColor, isNull);
    expect(loaded.encode(), doc.encode());
  });
}
