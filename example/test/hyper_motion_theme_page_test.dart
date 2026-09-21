import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/foundation/hyper_motion_theme_page.dart';

void main() {
  testWidgets('三档动画可播放并切换减少动画', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperMotionThemePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('快速 120ms'), findsOneWidget);
    expect(find.textContaining('标准 240ms'), findsOneWidget);
    expect(find.textContaining('强调 360ms'), findsOneWidget);

    await tester.tap(find.text('模拟减少动画'));
    await tester.pumpAndSettle();
    expect(find.textContaining('实际 0ms'), findsNWidgets(3));

    await tester.tap(find.text('播放动画'));
    await tester.pump();
    final tracks = tester.widgetList<AnimatedPositionedDirectional>(
      find.byType(AnimatedPositionedDirectional),
    );
    expect(tracks, hasLength(3));
    expect(tracks.every((track) => track.duration == Duration.zero), isTrue);
  });
}
