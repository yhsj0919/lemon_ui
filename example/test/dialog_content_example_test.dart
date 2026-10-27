import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/feedback/hyper_dialog_page.dart';

void main() {
  for (final size in [const Size(1280, 800), const Size(360, 640)]) {
    testWidgets('content dialog scrolls independently at $size', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: MediaQuery(
              data: MediaQueryData(
                size: size,
                textScaler: TextScaler.linear(size.width < 400 ? 2 : 1),
              ),
              child: const Material(child: HyperDialogPage()),
            ),
          ),
        ),
      );
      await tester.scrollUntilVisible(
        find.text('打开订单详情'),
        300,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pump(const Duration(milliseconds: 600));
      await tester.ensureVisible(find.text('打开订单详情'));
      await tester.pump(const Duration(milliseconds: 600));
      await tester.tap(find.text('打开订单详情'));
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('订单详情'), findsOneWidget);
      expect(find.text('商品 1'), findsOneWidget);
      final surface = find
          .descendant(
            of: find.byType(HyperDialog),
            matching: find.byType(HyperMaterialSurface),
          )
          .first;
      expect(tester.getSize(surface).width, lessThanOrEqualTo(960));
      expect(tester.getSize(surface).width, lessThan(size.width));
      await tester.drag(find.byType(ListView).last, const Offset(0, -6000));
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('商品 30'), findsOneWidget);
      expect(find.text('订单详情'), findsOneWidget);
      await tester.tap(find.text('关闭详情'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
      await tester.pump();
      expect(find.byType(HyperDialog), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
