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
      doc.light.tableVisual.selectedForeground = const EditorColor(
        argb: 0xfffedcba,
      );
      doc.light.tableVisual.hoverLift = true;
      doc.light.tableVisual.embedded = true;
      doc.light.tableVisual.striped = false;
      doc.light.tableVisual.showColumnResizeHandles = true;
      final restored = EditorThemeDocument.decode(doc.encode());
      final desktop = restored.resolve(false);
      expect(desktop.tableTheme.style.hoverLift, isTrue);
      expect(
        desktop.tableTheme.style.selectedForeground,
        const Color(0xfffedcba),
      );
      expect(
        restored.resolve(true).tableTheme.style.selectedForeground,
        isNull,
      );
      expect(desktop.tableTheme.style.embedded, isTrue);
      expect(restored.resolve(true).tableTheme.style.embedded, isNull);
      expect(desktop.tableTheme.style.striped, isFalse);
      expect(desktop.tableTheme.style.showColumnResizeHandles, isTrue);
      expect(restored.resolve(true).tableTheme.style.hoverLift, isNull);
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
  test('confirmed table gallery entry belongs to content', () {
    final section = gallerySections.singleWhere(
      (s) => s.items.any((i) => i.id == 'hyper-table'),
    );
    expect(section.title, '文字与内容');
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
    final panel = find.byKey(const ValueKey('editor-panel-数据表格'));
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
    final embedded = find.byKey(const ValueKey('editor-select-内嵌模式'));
    await tester.scrollUntilVisible(embedded, 200, scrollable: scroll);
    final selector = find.descendant(
      of: embedded,
      matching: find.byType(HyperSelect<String>),
    );
    tester.widget<HyperSelect<String>>(selector).onChanged!('true');
    await tester.pumpAndSettle();
    HyperMaterialSurface surface() => tester.widget<HyperMaterialSurface>(
      find
          .descendant(of: table, matching: find.byType(HyperMaterialSurface))
          .first,
    );
    expect(surface().border, const Border());
    expect(surface().borderRadius, BorderRadius.zero);
    tester.widget<HyperSelect<String>>(selector).onChanged!('false');
    await tester.pumpAndSettle();
    expect(surface().border!.dimensions.horizontal, greaterThan(0));
    expect(surface().borderRadius, isNot(BorderRadius.zero));
    final stateSelector = find.byKey(const ValueKey('editor-select-状态覆盖'));
    tester.state<ScrollableState>(scroll).position.jumpTo(0);
    await tester.pump();
    await tester.scrollUntilVisible(stateSelector, 200, scrollable: scroll);
    tester
        .widget<HyperSelect<String>>(
          find.descendant(
            of: stateSelector,
            matching: find.byType(HyperSelect<String>),
          ),
        )
        .onChanged!('selected');
    await tester.pumpAndSettle();
    final foreground = find.byKey(const ValueKey('editor-color-选中行文字与图标'));
    await tester.scrollUntilVisible(foreground, 200, scrollable: scroll);
    tester
        .widget<HyperColorPickerField>(
          find.descendant(
            of: foreground,
            matching: find.byType(HyperColorPickerField),
          ),
        )
        .onChanged!(Colors.yellow);
    await tester.pumpAndSettle();
    final solidSelection = find
        .ancestor(
          of: find.text('实例覆盖 · 实色选中背景'),
          matching: find.byType(HyperButton),
        )
        .first;
    tester.widget<HyperButton>(solidSelection).onPressed!();
    await tester.pumpAndSettle();
    expect(
      HyperTheme.of(tester.element(table)).tableTheme.style.selectedForeground!
          .toARGB32(),
      Colors.yellow.toARGB32(),
    );
    expect(
      tester
          .widget<Text>(
            find.descendant(of: table, matching: find.text('项目 1')).first,
          )
          .style!
          .color!
          .toARGB32(),
      Colors.yellow.toARGB32(),
    );
    expect(tester.takeException(), isNull);
  });
}
