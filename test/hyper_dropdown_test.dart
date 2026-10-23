import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('advanced dropdown actually transmits the background', (
    tester,
  ) async {
    final channels = <int>[];
    for (final quality in [
      HyperMaterialQuality.advanced,
      HyperMaterialQuality.standard,
    ]) {
      final boundaryKey = GlobalKey();
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundaryKey,
          child: MaterialApp(
            key: ValueKey(quality),
            home: HyperTheme(
              duration: Duration.zero,
              data: HyperThemeData.light().copyWith(
                materialTheme: HyperMaterialThemeData(quality: quality),
              ),
              child: Scaffold(
                backgroundColor: Colors.cyan,
                body: Center(
                  child: HyperDropdown(
                    presentation: HyperSelectPresentation.anchored,
                    panelBuilder: (context, close) =>
                        const SizedBox(height: 100, child: Text('背景透出检查')),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('请选择'));
      await tester.pumpAndSettle();
      final panel = tester.getRect(
        find
            .ancestor(of: find.text('背景透出检查'), matching: find.byType(HyperCard))
            .first,
      );
      await tester.runAsync(() async {
        final image =
            await (boundaryKey.currentContext!.findRenderObject()
                    as RenderRepaintBoundary)
                .toImage(pixelRatio: 1);
        final bytes = (await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        ))!;
        channels.add(
          bytes.getUint8(
            ((panel.bottom - 20).floor() * image.width +
                    panel.center.dx.floor()) *
                4,
          ),
        );
        image.dispose();
      });
    }
    expect(
      channels.first,
      lessThan(channels.last - 20),
      reason: '高级玻璃应透出青色背景，普通降级配方为实色',
    );
  });
  testWidgets(
    'dropdown follows global and local advanced material while open',
    (tester) async {
      var advanced = true;
      late StateSetter update;
      HyperMaterialThemeData? panelTheme;
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            duration: Duration.zero,
            data: HyperThemeData.light().copyWith(
              materialTheme: const HyperMaterialThemeData(
                quality: HyperMaterialQuality.advanced,
              ),
            ),
            child: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  update = setState;
                  return HyperMaterialTheme(
                    data: HyperMaterialThemeData(
                      quality: advanced
                          ? HyperMaterialQuality.advanced
                          : HyperMaterialQuality.standard,
                    ),
                    child: Center(
                      child: HyperDropdown(
                        presentation: HyperSelectPresentation.anchored,
                        panelBuilder: (context, close) {
                          panelTheme = HyperMaterialTheme.of(context);
                          return const SizedBox(
                            height: 100,
                            child: Text('材质继承检查'),
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('请选择'));
      await tester.pumpAndSettle();
      expect(panelTheme!.quality, HyperMaterialQuality.advanced);
      final panelCard = find
          .ancestor(of: find.text('材质继承检查'), matching: find.byType(HyperCard))
          .first;
      Iterable<BackdropFilter> filters() => tester.widgetList<BackdropFilter>(
        find.descendant(of: panelCard, matching: find.byType(BackdropFilter)),
      );
      expect(filters().any((filter) => filter.enabled), isTrue);
      update(() => advanced = false);
      await tester.pumpAndSettle();
      expect(panelTheme!.quality, HyperMaterialQuality.standard);
      expect(filters().every((filter) => !filter.enabled), isTrue);
      update(() => advanced = true);
      await tester.pumpAndSettle();
      expect(filters().any((filter) => filter.enabled), isTrue);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('自定义下拉任意内容可交互关闭并复用表面', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: Center(
              child: HyperDropdown(
                presentation: HyperSelectPresentation.anchored,
                surfaceStyle: HyperCardStyle(boxShadow: []),
                panelBuilder: (context, close) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('自由内容'),
                    HyperButton.text(
                      label: const Text('完成筛选'),
                      onPressed: close,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    expect(find.text('自由内容'), findsOneWidget);
    expect(
      tester.widget<HyperCard>(find.byType(HyperCard)).style!.boxShadow,
      isEmpty,
    );
    await tester.tap(find.text('完成筛选'));
    await tester.pumpAndSettle();
    expect(find.text('自由内容'), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('禁用下拉不打开，受控开合通知调用者', (tester) async {
    bool? requested;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperDropdown(
              isOpen: false,
              onOpenChanged: (value) => requested = value,
              panelBuilder: (context, close) => const Text('面板'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    expect(requested, isTrue);
    expect(find.text('面板'), findsNothing);
  });
  testWidgets('底部弹窗中的自定义内容可关闭', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperDropdown(
              presentation: HyperSelectPresentation.bottomSheet,
              panelBuilder: (context, close) =>
                  HyperButton.text(label: const Text('关闭面板'), onPressed: close),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    expect(find.text('关闭面板'), findsOneWidget);
    await tester.tap(find.text('关闭面板'));
    await tester.pumpAndSettle();
    expect(find.text('关闭面板'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
