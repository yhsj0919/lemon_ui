import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

const _boundaryKey = ValueKey('table-surface-review');
const _snapshotLabel = String.fromEnvironment(
  'TABLE_SNAPSHOT_LABEL',
  defaultValue: 'current',
);

Future<ui.Image> _capture(WidgetTester tester, String name) async {
  final boundary = tester.renderObject<RenderRepaintBoundary>(
    find.byKey(_boundaryKey),
  );
  final image = (await tester.runAsync(() => boundary.toImage(pixelRatio: 1)))!;
  final png = await tester.runAsync(
    () => image.toByteData(format: ui.ImageByteFormat.png),
  );
  final dir = Directory('.dart_tool/table-review')..createSync(recursive: true);
  File('${dir.path}/$_snapshotLabel-$name.png')
      .writeAsBytesSync(png!.buffer.asUint8List());
  return image;
}

Future<Color> _pixel(WidgetTester tester, ui.Image image, Offset point) async {
  final bytes = (await tester.runAsync(
    () => image.toByteData(format: ui.ImageByteFormat.rawRgba),
  ))!;
  final index = (point.dy.round() * image.width + point.dx.round()) * 4;
  return Color.fromARGB(
    bytes.getUint8(index + 3),
    bytes.getUint8(index),
    bytes.getUint8(index + 1),
    bytes.getUint8(index + 2),
  );
}

Future<void> _mount(
  WidgetTester tester, {
  bool dark = false,
  HyperTableStyle? style,
}) async {
  await tester.binding.setSurfaceSize(const Size(1120, 600));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  var theme = dark ? HyperThemeData.dark() : HyperThemeData.light();
  final font = File('C:/Windows/Fonts/segoeui.ttf');
  if (font.existsSync()) {
    await (FontLoader('TableReview')
          ..addFont(Future.value(ByteData.sublistView(font.readAsBytesSync()))))
        .load();
    theme = theme.copyWith(
      textTheme: theme.textTheme.apply(fontFamily: 'TableReview'),
    );
  }
  final icons = File(
    '${Platform.environment['FLUTTER_ROOT']}/bin/cache/artifacts/material_fonts/materialicons-regular.otf',
  );
  if (icons.existsSync()) {
    await (FontLoader(
          'MaterialIcons',
        )..addFont(Future.value(ByteData.sublistView(icons.readAsBytesSync()))))
        .load();
  }
  await tester.pumpWidget(
    MaterialApp(
      home: HyperDeviceDetector(
        deviceType: HyperDeviceType.desktop,
        builder: (context, device, child) => HyperTheme(
          data: theme,
          duration: Duration.zero,
          child: Scaffold(
            body: Center(
              child: RepaintBoundary(
                key: _boundaryKey,
                child: SizedBox(
                  width: 1000,
                  height: 420,
                  child: HyperTable<int>(
                    style: style,
                    columns: [
                      HyperTableColumn(
                        id: 'id',
                        title: 'ID',
                        value: (r) => r,
                        width: 96,
                        pin: HyperTableColumnPin.start,
                      ),
                      HyperTableColumn(
                        id: 'name',
                        title: 'Name',
                        value: (r) => 'R$r',
                        width: 360,
                      ),
                      HyperTableColumn(
                        id: 'detail',
                        title: 'Detail',
                        value: (r) => 'Detail $r',
                        width: 360,
                      ),
                      HyperTableColumn(
                        id: 'last',
                        title: 'Last',
                        value: (r) => 'Last $r',
                        width: 140,
                        pin: HyperTableColumnPin.end,
                      ),
                    ],
                    rows: List.generate(8, (i) => i + 1),
                    rowKey: (r) => r,
                    selectionMode: HyperTableSelectionMode.multiple,
                    onSelectionChanged: (_) {},
                    reorderableRows: true,
                    onRowsReordered: (_) {},
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets(
    'header covers control columns and gutter; text aligns with cells',
    (tester) async {
      await _mount(tester);
      final normal = await _capture(tester, 'normal');
      final header = await _pixel(tester, normal, const Offset(600, 5));
      for (final x in [8.0, 48.0, 180.0, 990.0]) {
        expect(
          await _pixel(tester, normal, Offset(x, 5)),
          header,
          reason: 'Header background at x=$x',
        );
      }
      expect(
        tester.getTopLeft(find.text('Name')).dx,
        tester.getTopLeft(find.text('R1')).dx,
      );
      expect(find.text('null'), findsNothing);
      expect(
        tester.getTopLeft(find.text('ID')).dx,
        lessThan(tester.getTopLeft(find.text('Name')).dx),
      );
      expect(tester.takeException(), isNull);
      normal.dispose();
    },
  );

  testWidgets(
    'translucent header is painted once across fixed and body columns',
    (tester) async {
      const headerColor = Color(0x80804020);
      await _mount(
        tester,
        style: const HyperTableStyle(headerBackground: headerColor),
      );
      final image = await _capture(tester, 'translucent-header');
      final expected = Color.alphaBlend(
        headerColor,
        HyperThemeData.light().colors.surface,
      );
      for (final x in [8.0, 48.0, 180.0, 600.0, 990.0]) {
        expect(
          (await _pixel(tester, image, Offset(x, 5))).toARGB32(),
          expected.toARGB32(),
        );
      }
      image.dispose();
    },
  );

  for (final dark in [false, true]) {
    testWidgets(
      'hover differs from stripes without a dark intermediate flash ($dark)',
      (tester) async {
        await _mount(tester, dark: dark);
        final origin = tester.getTopLeft(find.byKey(_boundaryKey));
        final row1Y = tester.getCenter(find.text('R1')).dy - origin.dy;
        final row2Y = tester.getCenter(find.text('R2')).dy - origin.dy;
        final normal = await _capture(
          tester,
          dark ? 'dark-normal' : 'light-normal',
        );
        final base = await _pixel(tester, normal, Offset(600, row1Y));
        final stripe = await _pixel(tester, normal, Offset(600, row2Y));
        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: const Offset(1100, 580));
        addTearDown(mouse.removePointer);
        await mouse.moveTo(origin + Offset(600, row1Y));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 30));
        final middle = await _capture(
          tester,
          dark ? 'dark-middle' : 'light-middle',
        );
        await tester.pumpAndSettle();
        final hovered = await _capture(
          tester,
          dark ? 'dark-hover' : 'light-hover',
        );
        final hover = await _pixel(tester, hovered, Offset(600, row1Y));
        expect(
          hover,
          isNot(stripe),
          reason: 'Hover and alternate row need different colors',
        );
        final mid = await _pixel(tester, middle, Offset(600, row1Y));
        for (final component in [
          (base.r, hover.r, mid.r),
          (base.g, hover.g, mid.g),
          (base.b, hover.b, mid.b),
        ]) {
          final lower = component.$1 < component.$2
              ? component.$1
              : component.$2;
          final upper = component.$1 > component.$2
              ? component.$1
              : component.$2;
          expect(
            component.$3,
            inInclusiveRange(lower - 1 / 255, upper + 1 / 255),
          );
        }
        for (final x in [132.0, 960.0]) {
          expect(
            await _pixel(tester, hovered, Offset(x, row1Y)),
            hover,
            reason: 'Fixed and scrolling segments must share row color',
          );
        }
        // Crossing into a fixed segment keeps the same row hovered.
        await mouse.moveTo(origin + Offset(132, row1Y));
        await tester.pumpAndSettle();
        final crossed = await _capture(
          tester,
          dark ? 'dark-crossed' : 'light-crossed',
        );
        expect(await _pixel(tester, crossed, Offset(600, row1Y)), hover);
        // Moving onto the striped row fades out the previous state and fades
        // in the same hover color over the stable alternate-row background.
        await mouse.moveTo(origin + Offset(600, row2Y));
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 30));
        final moving = await _capture(
          tester,
          dark ? 'dark-moving' : 'light-moving',
        );
        final leaving = await _pixel(tester, moving, Offset(600, row1Y));
        for (final component in [
          (base.r, hover.r, leaving.r),
          (base.g, hover.g, leaving.g),
          (base.b, hover.b, leaving.b),
        ]) {
          expect(
            component.$3,
            inInclusiveRange(
              (component.$1 < component.$2 ? component.$1 : component.$2) -
                  1 / 255,
              (component.$1 > component.$2 ? component.$1 : component.$2) +
                  1 / 255,
            ),
          );
        }
        await tester.pumpAndSettle();
        final alternateHovered = await _capture(
          tester,
          dark ? 'dark-stripe-hover' : 'light-stripe-hover',
        );
        expect(
          await _pixel(tester, alternateHovered, Offset(600, row2Y)),
          hover,
        );
        expect(
          await _pixel(tester, alternateHovered, Offset(600, row1Y)),
          base,
        );
        crossed.dispose();
        moving.dispose();
        alternateHovered.dispose();
        expect(tester.takeException(), isNull);
        normal.dispose();
        middle.dispose();
        hovered.dispose();
      },
    );
  }
}
