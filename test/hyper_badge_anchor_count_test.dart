import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  Widget app(Widget child) => MaterialApp(
    home: HyperTheme(
      data: HyperThemeData.light(),
      child: Center(child: child),
    ),
  );

  testWidgets(
    'count anchor uses existing count, overflow and visibility rules',
    (tester) async {
      for (final sample in [
        (128, false, true, '99+'),
        (0, true, true, '0'),
        (0, false, true, null),
        (5, false, false, null),
      ]) {
        await tester.pumpWidget(
          app(
            HyperBadgeAnchor.count(
              count: sample.$1,
              showZero: sample.$2,
              visible: sample.$3,
              child: const Icon(HyperIcons.bell),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(find.byIcon(HyperIcons.bell), findsOneWidget);
        if (sample.$4 != null) {
          expect(find.text(sample.$4!), findsOneWidget);
        } else {
          expect(
            find.descendant(
              of: find.byType(HyperBadge),
              matching: find.byType(Text),
            ),
            findsNothing,
          );
        }
      }
    },
  );

  testWidgets('count anchor forwards badge and placement overrides', (
    tester,
  ) async {
    const childKey = ValueKey('target');
    await tester.pumpWidget(
      app(
        HyperBadgeAnchor.count(
          count: 1000,
          maxCount: 999,
          semanticsLabel: '未读消息',
          badgeStyle: const HyperBadgeStyle(backgroundColor: Colors.purple),
          position: HyperBadgePosition.bottomLeft,
          offset: const Offset(-3, 4),
          duration: Duration.zero,
          child: const SizedBox(key: childKey, width: 40, height: 40),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('999+'), findsOneWidget);
    final badge = tester.widget<HyperBadge>(find.byType(HyperBadge));
    expect(badge.semanticsLabel, '未读消息');
    expect(badge.style!.backgroundColor, Colors.purple);
    final target = tester.getRect(find.byKey(childKey));
    final badgeRect = tester.getRect(find.byType(HyperBadge));
    expect(badgeRect.center.dx, closeTo(target.left - 3, .01));
    expect(badgeRect.center.dy, closeTo(target.bottom + 4, .01));
  });
}
