import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:lemon_ui_example/editor/editor_table_fields.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/gallery/gallery_registry.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'table settings round-trip with separate appearance and device ownership',
    () {
      final doc = EditorThemeDocument();
      doc.desktop.tableMetrics.rowHeight = 60;
      doc.desktop.tableMetrics.treeIndent = 24;
      doc.phone.tableMetrics.rowHeight = 68;
      doc.light.tableVisual.selectedBackground = const EditorColor(
        argb: 0xff123456,
      );
      final restored = EditorThemeDocument.decode(doc.encode());
      final desktop = restored.resolve(false);
      expect(desktop.sizes.desktop.table.rowHeight, 60);
      expect(desktop.sizes.phone.table.rowHeight, 68);
      expect(desktop.sizes.desktop.table.treeIndent, 24);
      expect(
        desktop.tableTheme.style.selectedBackground,
        const Color(0xff123456),
      );
      expect(
        restored.resolve(true).tableTheme.style.selectedBackground,
        isNull,
      );
      expect(restored.encode(), doc.encode());
      restored.desktop.tableMetrics = EditorTableMetrics();
      expect(
        restored.resolve(false).sizes.desktop.table.rowHeight,
        HyperThemeData.light().sizes.desktop.table.rowHeight,
      );
    },
  );
  test('table gallery entry remains unconfirmed', () {
    final section = gallerySections.singleWhere(
      (s) => s.items.any((i) => i.id == 'hyper-table'),
    );
    expect(section.title, '未确认');
  });
  testWidgets('table workspace builds and pixel edits write integers', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1600, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-table');
    await tester.pumpAndSettle();
    final panel = find.byKey(const ValueKey('editor-panel-数据表格 · 未确认'));
    expect(panel, findsOneWidget);
    final field = find.byKey(const ValueKey('editor-number-单元格最小高度'));
    final scroll = find
        .descendant(of: panel, matching: find.byType(Scrollable))
        .first;
    await tester.scrollUntilVisible(field, 200, scrollable: scroll);
    tester
        .widget<HyperSlider>(
          find.descendant(of: field, matching: find.byType(HyperSlider)),
        )
        .onChanged!(60.4);
    await tester.pumpAndSettle();
    final table = find
        .byWidgetPredicate((widget) => widget is HyperTable)
        .first;
    expect(
      HyperTheme.of(tester.element(table)).sizes.desktop.table.rowHeight,
      60,
    );
    expect(tester.takeException(), isNull);
  });
}
