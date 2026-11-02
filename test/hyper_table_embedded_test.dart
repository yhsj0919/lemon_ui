import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/surface/hyper_material_edge.dart';
import 'package:trina_grid/trina_grid.dart' as trina;

final columns = [
  HyperTableColumn<int>(
    id: 'name',
    title: '编号',
    value: (row) => row,
    widthMode: HyperTableColumnWidthMode.flex,
  ),
];

Widget host(
  Widget child, {
  HyperThemeData? theme,
  double scale = 1,
  double width = 480,
  double height = 300,
}) => MaterialApp(
  home: HyperTheme(
    data: theme ?? HyperThemeData.light(),
    duration: Duration.zero,
    child: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: Scaffold(
        body: Center(
          child: SizedBox(width: width, height: height, child: child),
        ),
      ),
    ),
  ),
);

Finder get table => find.byType(HyperTable<int>);
HyperMaterialSurface surface(WidgetTester tester) =>
    tester.widget<HyperMaterialSurface>(
      find
          .descendant(of: table, matching: find.byType(HyperMaterialSurface))
          .first,
    );

void main() {
  testWidgets('native grid leaves no hairline when the table owns no border', (
    tester,
  ) async {
    const key = ValueKey('bare-table-border');
    for (final embedded in [false, true]) {
      await tester.pumpWidget(
        host(
          RepaintBoundary(
            key: key,
            child: HyperTable<int>(
              embedded: embedded,
              striped: false,
              columns: columns,
              rows: const [1, 2],
              rowKey: (row) => row,
              style: const HyperTableStyle(
                borderWidth: 0,
                radius: 0,
                borderColor: Colors.blue,
                background: Colors.white,
                headerBackground: Colors.white,
                material: HyperSurfaceMaterial.solid(),
              ),
            ),
          ),
          width: 240,
          height: 240,
        ),
      );
      await tester.pumpAndSettle();
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(key),
      );
      final image = (await tester.runAsync(
        () => boundary.toImage(pixelRatio: 1),
      ))!;
      final data = (await tester.runAsync(
        () => image.toByteData(format: ui.ImageByteFormat.rawRgba),
      ))!;
      for (final point in [(0, 120), (239, 120), (120, 0), (120, 239)]) {
        final i = (point.$2 * image.width + point.$1) * 4;
        expect(
          [data.getUint8(i), data.getUint8(i + 1), data.getUint8(i + 2)],
          [255, 255, 255],
        );
      }
      image.dispose();
    }
  });
  test('embedded flag participates in the complete style value contract', () {
    const enabled = HyperTableStyle(embedded: true);
    const disabled = HyperTableStyle(embedded: false);
    expect(enabled.copyWith(), enabled);
    expect(enabled.copyWith().hashCode, enabled.hashCode);
    expect(enabled.copyWith(embedded: false), disabled);
    expect(enabled.merge(disabled), disabled);
    expect(HyperTableStyle.lerp(enabled, disabled, .25).embedded, isTrue);
    expect(HyperTableStyle.lerp(enabled, disabled, .75).embedded, isFalse);
    expect(
      HyperTableThemeData(style: enabled)
          .merge(const HyperTableThemeData(style: disabled))
          .style,
      disabled,
    );
    expect(enabled, isNot(disabled));
  });
  for (final quality in HyperMaterialQuality.values) {
    for (final mode in ['global', 'local', 'style', 'instance']) {
      testWidgets('embedded surface suppresses outer chrome: $quality $mode', (
        tester,
      ) async {
        final theme = HyperThemeData.light().copyWith(
          materialTheme: HyperMaterialThemeData(
            quality: quality,
            material: const HyperSurfaceMaterial.frostedGlass(
              edgeEnabled: true,
              boxShadow: [BoxShadow(color: Colors.red, blurRadius: 8)],
            ),
          ),
          tableTheme: HyperTableThemeData(
            style: HyperTableStyle(
              embedded: mode == 'global',
              borderWidth: 3,
              radius: 18,
              boxShadow: const [BoxShadow(color: Colors.blue, blurRadius: 10)],
            ),
          ),
        );
        Widget child = HyperTable<int>(
          columns: columns,
          rows: const [1, 2],
          rowKey: (row) => row,
          embedded: mode == 'instance' ? true : null,
          style: mode == 'style' ? const HyperTableStyle(embedded: true) : null,
        );
        if (mode == 'local') {
          child = HyperTableTheme(
            data: const HyperTableThemeData(
              style: HyperTableStyle(embedded: true),
            ),
            child: child,
          );
        }
        await tester.pumpWidget(host(child, theme: theme));
        await tester.pumpAndSettle();
        final outer = surface(tester);
        expect(outer.border, const Border());
        expect(outer.borderRadius, BorderRadius.zero);
        expect(outer.boxShadow, isEmpty);
        expect(outer.material!.kind, HyperSurfaceMaterialKind.solid);
        final edges = tester.widgetList<HyperMaterialEdge>(
          find.descendant(of: table, matching: find.byType(HyperMaterialEdge)),
        );
        for (final edge in edges) {
          expect(
            edge.material?.resolveEdgeGradient(
              hasBorderOverride: edge.hasBorderOverride,
              defaultEnabled: edge.defaultEnabled,
            ),
            isNull,
          );
        }
        expect(
          tester
              .widgetList<BackdropFilter>(
                find.descendant(
                  of: table,
                  matching: find.byType(BackdropFilter),
                ),
              )
              .any((filter) => filter.enabled),
          isFalse,
        );
        expect(
          tester
              .widgetList<AnimatedContainer>(
                find.descendant(
                  of: table,
                  matching: find.byType(AnimatedContainer),
                ),
              )
              .any(
                (w) =>
                    w.foregroundDecoration is BoxDecoration &&
                    ((w.foregroundDecoration! as BoxDecoration).border
                                as Border?)
                            ?.bottom
                            .width ==
                        3,
              ),
          isTrue,
        );
        expect(tester.takeException(), isNull);
      });
    }
  }
  testWidgets(
    'toggling embedded restores surface settings and retains grid state',
    (tester) async {
      final theme = HyperThemeData.light().copyWith(
        tableTheme: const HyperTableThemeData(
          style: HyperTableStyle(
            embedded: true,
            radius: 17,
            borderWidth: 2,
            boxShadow: [BoxShadow(blurRadius: 7)],
          ),
        ),
      );
      Widget view(bool? embedded) => host(
        HyperTable<int>(
          columns: columns,
          rows: const [1, 2],
          rowKey: (row) => row,
          embedded: embedded,
        ),
        theme: theme,
      );
      await tester.pumpWidget(view(null));
      await tester.pumpAndSettle();
      final gridState = tester.state(find.byType(trina.TrinaGrid));
      expect(surface(tester).border, const Border());
      await tester.pumpWidget(view(false));
      await tester.pumpAndSettle();
      expect(surface(tester).borderRadius, BorderRadius.circular(17));
      expect(surface(tester).border!.dimensions.horizontal, 4);
      expect(surface(tester).boxShadow, isNotEmpty);
      expect(tester.state(find.byType(trina.TrinaGrid)), same(gridState));
      await tester.pumpWidget(view(true));
      await tester.pumpAndSettle();
      expect(surface(tester).borderRadius, BorderRadius.zero);
      expect(tester.state(find.byType(trina.TrinaGrid)), same(gridState));
      expect(tester.takeException(), isNull);
    },
  );
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('nested card owns a uniform single border at scale $scale', (
      tester,
    ) async {
      const key = ValueKey('nested-border');
      await tester.pumpWidget(
        host(
          RepaintBoundary(
            key: key,
            child: HyperCard(
              style: HyperCardStyle(
                padding: EdgeInsets.zero,
                border: Border.all(color: Colors.red, width: 2),
                borderRadius: BorderRadius.circular(10),
                clipBehavior: Clip.antiAlias,
              ),
              child: HyperTable<int>(
                columns: columns,
                rows: const [1, 2],
                rowKey: (row) => row,
                embedded: true,
                style: const HyperTableStyle(
                  background: Colors.white,
                  headerBackground: Colors.white,
                  borderColor: Colors.blue,
                  borderWidth: 4,
                ),
              ),
            ),
          ),
          width: 240,
          height: 240,
          scale: scale,
        ),
      );
      await tester.pumpAndSettle();
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(key),
      );
      final image = (await tester.runAsync(
        () => boundary.toImage(pixelRatio: 1),
      ))!;
      final data = (await tester.runAsync(
        () => image.toByteData(format: ui.ImageByteFormat.rawRgba),
      ))!;
      Color pixel(int x, int y) {
        final i = (y * image.width + x) * 4;
        return Color.fromARGB(
          data.getUint8(i + 3),
          data.getUint8(i),
          data.getUint8(i + 1),
          data.getUint8(i + 2),
        );
      }

      for (final point in [
        (0, 120),
        (1, 120),
        (238, 120),
        (239, 120),
        (120, 0),
        (120, 1),
        (120, 238),
        (120, 239),
      ]) {
        expect(pixel(point.$1, point.$2).toARGB32(), Colors.red.toARGB32());
      }
      for (final point in [(2, 210), (237, 210), (120, 2), (120, 237)]) {
        expect(
          pixel(point.$1, point.$2),
          Colors.white,
          reason: 'No inner table border should thicken the parent contour',
        );
      }
      image.dispose();
      expect(tester.takeException(), isNull);
    });
  }
}
