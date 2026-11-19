import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/pending/hyper_global_message_page.dart';

void main() {
  testWidgets(
    'global message demo switches presentations and disposes safely',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: const Scaffold(body: HyperGlobalMessagePage()),
          ),
        ),
      );
      for (final presentation in HyperMessagePresentation.values) {
        tester
            .widget<HyperSelect<HyperMessagePresentation>>(
              find.byType(HyperSelect<HyperMessagePresentation>),
            )
            .onChanged!(presentation);
        await tester.pumpAndSettle();
        await tester.tap(find.text('弹出消息'));
        await tester.pumpAndSettle();
        expect(find.text('操作已完成'), findsOneWidget);
        if (presentation == HyperMessagePresentation.notification) {
          expect(find.byType(HyperNotification), findsOneWidget);
        }
        await tester.tap(find.text('清空消息'));
        await tester.pumpAndSettle();
        expect(find.text('操作已完成'), findsNothing);
      }
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    },
  );
}
