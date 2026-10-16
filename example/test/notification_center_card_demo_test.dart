import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/feedback/hyper_notification_center_page.dart';

void main() {
  testWidgets('每条通知绘制自己的卡片背景，不包装整块列表卡片', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final theme = HyperThemeData.light();
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: theme,
          child: const Scaffold(body: HyperNotificationCenterPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HyperCard), findsNothing);
    expect(find.byType(HyperNotification), findsNWidgets(4));
    for (final notification in find.byType(HyperNotification).evaluate()) {
      final surfaces = find.descendant(
        of: find.byWidget(notification.widget),
        matching: find.byWidgetPredicate(
          (widget) =>
              widget is AnimatedContainer &&
              widget.decoration is BoxDecoration &&
              (widget.decoration! as BoxDecoration).color ==
                  theme.colors.surfaceElevated,
        ),
      );
      expect(surfaces, findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });
}
