import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget host(Widget child, {HyperThemeData? theme, bool reduced = false}) =>
    MaterialApp(
      home: HyperTheme(
        data: theme ?? HyperThemeData.light(),
        duration: Duration.zero,
        child: MediaQuery(
          data: MediaQueryData(disableAnimations: reduced),
          child: Scaffold(
            body: SizedBox(width: 640, height: 360, child: child),
          ),
        ),
      ),
    );

void main() {
  testWidgets('transparent selection composites with the table canvas', (
    tester,
  ) async {
    final theme = HyperThemeData.light();
    await tester.pumpWidget(
      host(
        HyperTable<String>(
          columns: [
            HyperTableColumn(id: 'name', title: '名称', value: (row) => row),
          ],
          rows: const ['selected'],
          rowKey: (row) => row,
          selectedKeys: const {'selected'},
          style: HyperTableStyle(
            selectedBackground: const Color(0xFF0066CC).withValues(alpha: .12),
          ),
        ),
        theme: theme,
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<Text>(find.text('selected')).style!.color,
      theme.colors.textPrimary,
    );
  });
  testWidgets('selected hover-lift uses its actual background for contrast', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        HyperTable<String>(
          columns: [
            HyperTableColumn(id: 'name', title: '名称', value: (row) => row),
          ],
          rows: const ['selected'],
          rowKey: (row) => row,
          selectedKeys: const {'selected'},
          hoverLift: true,
          style: const HyperTableStyle(
            selectedBackground: Color(0xFF0066CC),
            liftBackground: Colors.white,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    Color color() => tester.widget<Text>(find.text('selected')).style!.color!;
    expect(color(), Colors.white);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: const Offset(700, 500));
    await mouse.moveTo(tester.getCenter(find.text('selected')));
    await tester.pumpAndSettle();
    expect(color(), HyperThemeData.light().colors.textPrimary);
    await mouse.moveTo(const Offset(700, 500));
    await tester.pumpAndSettle();
    expect(color(), Colors.white);
    await mouse.removePointer();
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'paging removes row animations safely during a selection transition',
    (tester) async {
      final controller = HyperTableController();
      final columns = [
        HyperTableColumn<String>(id: 'name', title: '名称', value: (row) => row),
      ];
      Widget view(bool selected) => host(
        HyperTable<String>(
          controller: controller,
          columns: columns,
          rows: const ['first', 'second'],
          rowKey: (row) => row,
          pageSize: 1,
          paginateLocalRows: true,
          selectedKeys: selected ? const {'first'} : const {},
          style: const HyperTableStyle(
            selectedBackground: Color(0xFF0066CC),
            duration: Duration(milliseconds: 200),
          ),
        ),
      );
      await tester.pumpWidget(view(false));
      await tester.pumpAndSettle();
      await tester.pumpWidget(view(true));
      await tester.pump(const Duration(milliseconds: 50));
      controller.goToPage(2);
      await tester.pumpAndSettle();
      expect(find.text('first'), findsNothing);
      expect(find.text('second'), findsOneWidget);
      controller.goToPage(1);
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.text('first')).style!.color,
        Colors.white,
      );
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    },
  );
  test(
    'selected foreground supports copy, merge, interpolation and equality',
    () {
      const a = HyperTableStyle(selectedForeground: Color(0xFF112233));
      const b = HyperTableStyle(selectedForeground: Color(0xFF334455));
      expect(a.copyWith(), a);
      expect(a.copyWith().hashCode, a.hashCode);
      expect(a.copyWith(selectedForeground: b.selectedForeground), b);
      expect(a.merge(b), b);
      expect(
        HyperTableStyle.lerp(a, b, .5).selectedForeground,
        const Color(0xFF223344),
      );
      expect(a, isNot(b));
    },
  );
  for (final dark in [false, true]) {
    testWidgets(
      'default selected primary/container colors keep semantic contrast: $dark',
      (tester) async {
        final theme = dark ? HyperThemeData.dark() : HyperThemeData.light();
        for (final primary in [false, true]) {
          await tester.pumpWidget(
            host(
              HyperTable<String>(
                columns: [
                  HyperTableColumn(
                    id: 'name',
                    title: '名称',
                    value: (row) => row,
                  ),
                ],
                rows: const ['selected'],
                rowKey: (row) => row,
                selectedKeys: const {'selected'},
                style: HyperTableStyle(
                  selectedBackground: primary
                      ? theme.colors.primary
                      : theme.colors.primaryContainer,
                ),
              ),
              theme: theme,
            ),
          );
          await tester.pumpAndSettle();
          expect(
            tester.widget<Text>(find.text('selected')).style!.color!.toARGB32(),
            (primary ? theme.colors.onPrimary : theme.colors.onPrimaryContainer)
                .toARGB32(),
          );
        }
      },
    );
  }
  testWidgets('foreground overrides keep fixed and custom cells independent', (
    tester,
  ) async {
    final theme = HyperThemeData.light().copyWith(
      tableTheme: const HyperTableThemeData(
        style: HyperTableStyle(
          selectedBackground: Color(0xFF0066CC),
          selectedForeground: Color(0xFF00FFFF),
        ),
      ),
    );
    final columns = [
      HyperTableColumn<String>(
        id: 'name',
        title: '名称',
        value: (row) => row,
        pin: HyperTableColumnPin.start,
      ),
      HyperTableColumn<String>(
        id: 'custom',
        title: '自定义',
        value: (row) => row,
        cellBuilder: (_, row, _) =>
            Text('custom-$row', style: const TextStyle(color: Colors.red)),
      ),
    ];
    for (final mode in ['global', 'local', 'instance']) {
      Widget child = HyperTable<String>(
        columns: columns,
        rows: const ['selected', 'normal'],
        rowKey: (row) => row,
        selectedKeys: const {'selected'},
        style: mode == 'instance'
            ? const HyperTableStyle(selectedForeground: Color(0xFFFF00FF))
            : null,
      );
      if (mode != 'global') {
        child = HyperTableTheme(
          data: const HyperTableThemeData(
            style: HyperTableStyle(selectedForeground: Color(0xFFFFFF00)),
          ),
          child: child,
        );
      }
      await tester.pumpWidget(host(child, theme: theme));
      await tester.pumpAndSettle();
      final expected = mode == 'global'
          ? 0xFF00FFFF
          : mode == 'local'
          ? 0xFFFFFF00
          : 0xFFFF00FF;
      expect(
        tester.widget<Text>(find.text('selected')).style!.color!.toARGB32(),
        expected,
      );
      expect(
        tester.widget<Text>(find.text('custom-selected')).style!.color,
        Colors.red,
      );
      expect(
        tester.widget<Text>(find.text('normal')).style!.color,
        theme.colors.textPrimary,
      );
      expect(
        tester.widget<Text>(find.text('名称')).style!.color,
        theme.colors.textPrimary,
      );
      expect(tester.takeException(), isNull);
    }
  });
  for (final reduced in [false, true]) {
    testWidgets(
      'selection foreground transitions and restores with reduced motion $reduced',
      (tester) async {
        final columns = [
          HyperTableColumn<String>(
            id: 'name',
            title: '名称',
            value: (row) => row,
          ),
        ];
        Widget view(bool selected) => host(
          HyperTable<String>(
            columns: columns,
            rows: const ['row'],
            rowKey: (row) => row,
            selectedKeys: selected ? const {'row'} : const {},
            style: const HyperTableStyle(
              selectedBackground: Color(0xFF0066CC),
              duration: Duration(milliseconds: 200),
              curve: Curves.linear,
            ),
          ),
          reduced: reduced,
        );
        await tester.pumpWidget(view(false));
        await tester.pumpAndSettle();
        Color color() => tester.widget<Text>(find.text('row')).style!.color!;
        final normal = color();
        await tester.pumpWidget(view(true));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        if (!reduced) {
          expect(color(), isNot(normal));
          expect(color(), isNot(Colors.white));
        }
        await tester.pumpAndSettle();
        expect(color(), Colors.white);
        await tester.pumpWidget(view(false));
        await tester.pumpAndSettle();
        expect(color(), normal);
      },
    );
  }
  testWidgets('selected built-in drag handle follows the row foreground', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        HyperTable<String>(
          columns: [
            HyperTableColumn(id: 'name', title: '名称', value: (row) => row),
          ],
          rows: const ['selected', 'normal'],
          rowKey: (row) => row,
          selectedKeys: const {'selected'},
          reorderableRows: true,
          onRowsReordered: (_) {},
          style: const HyperTableStyle(selectedBackground: Color(0xFF0066CC)),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final icons = tester
        .widgetList<Icon>(find.byIcon(HyperIcons.gripVertical))
        .toList();
    expect(icons.first.color, Colors.white);
    expect(icons.last.color, HyperThemeData.light().colors.textPrimary);
  });
  testWidgets(
    'tree expansion loading and retry icons contrast without changing custom content',
    (tester) async {
      final pending = Completer<List<String>>();
      await tester.pumpWidget(
        host(
          HyperTable<String>(
            columns: [
              HyperTableColumn(
                id: 'name',
                title: '名称',
                value: (row) => row,
                cellBuilder: (_, row, _) => Text(
                  'custom-$row',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
            rows: const ['root'],
            rowKey: (row) => row,
            selectedKeys: const {'root'},
            hasChildren: (_) => true,
            childrenLoader: (_) => pending.future,
            style: const HyperTableStyle(selectedBackground: Color(0xFF0066CC)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      Color? iconColor(IconData icon) {
        final finder = find.byIcon(icon);
        return tester.widget<Icon>(finder).color ??
            IconTheme.of(tester.element(finder)).color;
      }

      expect(iconColor(HyperIcons.chevronRight), Colors.white);
      expect(
        tester.widget<Text>(find.text('custom-root')).style!.color,
        Colors.red,
      );
      await tester.tap(find.byIcon(HyperIcons.chevronRight));
      await tester.pump();
      await tester.pump();
      expect(
        tester.widget<HyperProgress>(find.byType(HyperProgress).first).color,
        Colors.white,
      );
      pending.completeError(StateError('retry'));
      await tester.pumpAndSettle();
      expect(iconColor(HyperIcons.refreshCw), Colors.white);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'solid blue selection uses a contrasting default cell foreground',
    (tester) async {
      await tester.pumpWidget(
        host(
          HyperTable<String>(
            columns: [
              HyperTableColumn(id: 'name', title: '名称', value: (row) => row),
            ],
            rows: const ['selected', 'normal'],
            rowKey: (row) => row,
            selectedKeys: const {'selected'},
            style: const HyperTableStyle(selectedBackground: Color(0xFF0066CC)),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.text('selected')).style!.color,
        Colors.white,
      );
      expect(
        tester.widget<Text>(find.text('normal')).style!.color,
        HyperThemeData.light().colors.textPrimary,
      );
    },
  );
}
