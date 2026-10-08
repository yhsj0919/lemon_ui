import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/gallery/demo_section.dart';
import 'package:lemon_ui_example/pages/framework/hyper_app_bar_page.dart';

void main() {
  testWidgets('Card 示例支持变体、玻璃开关和独立滚动', (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const Scaffold(body: HyperAppBarPage()),
        ),
      ),
    );
    expect(find.byType(DemoSection), findsNWidgets(2));
    await tester.tap(find.text('普通'));
    await tester.pumpAndSettle();
    expect(find.text('普通顶栏'), findsOneWidget);
    await tester.tap(find.text('中等展开'));
    await tester.pumpAndSettle();
    expect(find.byType(BackdropFilter), findsOneWidget);
    await tester.tap(find.text('关闭玻璃'));
    await tester.pumpAndSettle();
    expect(find.byType(BackdropFilter), findsNothing);
    final preview = find.byKey(const ValueKey('app-bar-preview'));
    final inner = tester.state<ScrollableState>(
      find.descendant(of: preview, matching: find.byType(Scrollable)),
    );
    final outer = tester.state<ScrollableState>(find.byType(Scrollable).first);
    final offset = outer.position.pixels;
    await tester.drag(preview, const Offset(0, -180));
    await tester.pumpAndSettle();
    expect(inner.position.pixels, greaterThan(0));
    expect(outer.position.pixels, offset);
    expect(tester.takeException(), isNull);
  });
}
