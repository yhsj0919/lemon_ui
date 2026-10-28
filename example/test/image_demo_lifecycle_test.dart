import 'package:lemon_ui_example/pages/content/image_demo_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/content/hyper_image_page.dart';

void main() {
  testWidgets(
    'leaving image demo during simulated loading reports no uncaught error',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: const Scaffold(body: HyperImagePage()),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pumpWidget(const SizedBox());
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 600));
      }
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'simulated failure reaches the image UI and retry decodes successfully',
    (tester) async {
      final provider = DemoImageProvider(failFirst: true);
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: SizedBox(
                width: 240,
                height: 180,
                child: HyperImage(
                  image: provider,
                  semanticLabel: 'demo result',
                ),
              ),
            ),
          ),
        ),
      );
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 600));
      }
      expect(find.text('图片加载失败'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('重试'));
      await tester.pump();
      for (var i = 0; i < 5; i++) {
        await tester.pump(const Duration(milliseconds: 600));
      }
      for (var i = 0; i < 3; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 50)),
        );
        await tester.pump(const Duration(milliseconds: 300));
      }
      expect(find.text('图片加载失败'), findsNothing);
      expect(find.bySemanticsLabel('demo result'), findsOneWidget);
      expect(find.byType(HyperProgress), findsNothing);
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    },
  );
}
