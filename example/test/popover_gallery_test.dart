import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/gallery/gallery_registry.dart';
import 'package:lemon_ui_example/pages/interaction/hyper_popover_page.dart';

void main() {
  test(
    'confirmed popover uses interaction category and config round trips',
    () {
      expect(
        gallerySections
            .singleWhere((s) => s.title == '交互基础')
            .items
            .where((i) => i.id == 'hyper-popover'),
        hasLength(1),
      );
      expect(
        gallerySections.singleWhere((s) => s.title == '未确认').items,
        isEmpty,
      );
      expect(galleryItems.where((i) => i.id == 'hyper-popover'), hasLength(1));
      expect(
        galleryItems.where((i) => i.id == 'hyper-anchored-overlay'),
        hasLength(1),
      );
      final doc = EditorThemeDocument();
      doc.desktop.reviews.popover.spacing = 9;
      doc.desktop.reviews.popover.surfaceRadius = 11;
      doc.light.reviews.popover.background = const EditorColor(
        argb: 0xff112233,
      );
      final restored = EditorThemeDocument.decode(doc.encode());
      expect(restored.encode(), doc.encode());
      final theme = restored.resolve(
        false,
        deviceType: HyperDeviceType.desktop,
      );
      expect(theme.popoverTheme.style.spacing, 9);
      expect(
        theme.popoverTheme.style.surfaceStyle!.borderRadius,
        BorderRadius.circular(11),
      );
      expect(
        theme.popoverTheme.style.surfaceStyle!.background!.color,
        const Color(0xff112233),
      );
      expect(
        restored
            .resolve(false, deviceType: HyperDeviceType.phone)
            .popoverTheme
            .style
            .spacing,
        isNull,
      );
    },
  );

  testWidgets('interaction editor navigation exposes confirmed popover', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: EditorComponentNavigation(
              page: 'hyper-popover',
              onSelected: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('锚定面板'), findsOneWidget);
    expect(find.text('未确认'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('popover demo narrow layout at $scale', (tester) async {
      tester.view.physicalSize = const Size(320, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: const Scaffold(body: HyperPopoverPage()),
            ),
          ),
        ),
      );
      await tester.tap(find.text('点击打开'));
      await tester.pumpAndSettle();
      expect(find.text('关闭浮层'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
