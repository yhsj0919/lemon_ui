import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

const longText =
    'A very long single line of text that overflows the available width many times.';
Future<void> render(
  WidgetTester tester, {
  String text = longText,
  HyperTextScrollTrigger trigger = HyperTextScrollTrigger.automatic,
  HyperTextScrollMode mode = HyperTextScrollMode.pingPong,
  Duration? duration = const Duration(seconds: 1),
  double speed = 40,
  double scale = 1,
  bool reduced = false,
  TextDirection direction = TextDirection.ltr,
  double width = 100,
}) => tester.pumpWidget(
  MaterialApp(
    home: MediaQuery(
      data: MediaQueryData(
        textScaler: TextScaler.linear(scale),
        disableAnimations: reduced,
      ),
      child: Directionality(
        textDirection: direction,
        child: Center(
          child: SizedBox(
            width: width,
            child: HyperScrollingText(
              text,
              trigger: trigger,
              mode: mode,
              duration: duration,
              speed: speed,
              pauseDuration: Duration.zero,
            ),
          ),
        ),
      ),
    ),
  ),
);
double offset(WidgetTester tester) {
  final transform = find.byKey(const ValueKey('hyper-scrolling-text-offset'));
  if (transform.evaluate().isNotEmpty) {
    return tester.widget<Transform>(transform).transform.storage[12].abs();
  }
  return tester.state<ScrollableState>(find.byType(Scrollable)).position.pixels;
}

void main() {
  testWidgets('往返与循环按同一速度移动，长度不改变速度', (tester) async {
    for (final mode in HyperTextScrollMode.values) {
      for (final text in [longText, longText + longText]) {
        await render(tester, mode: mode, text: text, duration: null, speed: 40);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400));
        expect(offset(tester), closeTo(16, .01));
        await tester.pumpWidget(const SizedBox());
      }
    }
  });
  testWidgets('HyperText滚动构造复用主题与滚动行为', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Center(
          child: SizedBox(
            width: 100,
            child: HyperText.scrolling(
              longText,
              mode: HyperTextScrollMode.loop,
              style: TextStyle(fontSize: 20, color: Colors.red),
              duration: Duration(seconds: 1),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(offset(tester), greaterThan(0));
    expect(find.byType(HyperScrollingText), findsOneWidget);
    expect(
      tester.widget<Text>(find.text(longText).first).style?.color,
      Colors.red,
    );
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('循环不叠加隐式动画，悬停结束仍平滑复位', (tester) async {
    await render(
      tester,
      mode: HyperTextScrollMode.loop,
      trigger: HyperTextScrollTrigger.hover,
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byType(HyperScrollingText)));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    final moving = offset(tester);
    expect(moving, greaterThan(0));
    expect(
      find.descendant(
        of: find.byType(HyperScrollingText),
        matching: find.byType(TweenAnimationBuilder<double>),
      ),
      findsNothing,
    );
    await mouse.moveTo(Offset.zero);
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    expect(offset(tester), greaterThan(0));
    expect(offset(tester), lessThan(moving));
    await tester.pump(const Duration(milliseconds: 120));
    expect(offset(tester), 0);
    await mouse.removePointer();
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('循环周期与实际副本间距一致，衔接不偏移', (tester) async {
    await render(tester, mode: HyperTextScrollMode.loop);
    await tester.pump();
    final copies = find.byType(HyperText);
    final spacing =
        tester.getTopLeft(copies.at(1)).dx - tester.getTopLeft(copies.at(0)).dx;
    await tester.pump(const Duration(milliseconds: 500));
    expect(offset(tester) * 2, closeTo(spacing, .001));
    expect(find.byType(Scrollable), findsNothing);
    await tester.pump(const Duration(milliseconds: 499));
    final before = tester.getTopLeft(copies.at(1)).dx;
    await tester.pump(const Duration(milliseconds: 2));
    final after = tester.getTopLeft(copies.at(0)).dx;
    expect(before - after, closeTo(spacing * .002, .01));
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('单向循环副本衔接，周期结束回到同一画面', (tester) async {
    for (final direction in TextDirection.values) {
      await render(
        tester,
        mode: HyperTextScrollMode.loop,
        direction: direction,
      );
      await tester.pump();
      expect(find.text(longText), findsNWidgets(2));
      final start = offset(tester);
      await tester.pump(const Duration(milliseconds: 400));
      final middle = offset(tester);
      await tester.pump(const Duration(milliseconds: 400));
      expect(offset(tester), greaterThan(middle));
      await tester.pump(const Duration(milliseconds: 200));
      expect(offset(tester), closeTo(start, .01));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    }
    await render(
      tester,
      mode: HyperTextScrollMode.loop,
      text: 'short',
      width: 700,
    );
    expect(find.text('short'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('溢出自动往返，短文字静止', (tester) async {
    await render(tester);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(offset(tester), greaterThan(0));
    await tester.pump(const Duration(milliseconds: 600));
    final end = offset(tester);
    await tester.pump(const Duration(milliseconds: 400));
    expect(offset(tester), lessThan(end));
    await render(tester, text: 'short');
    await tester.pump(const Duration(seconds: 2));
    expect(offset(tester), 0);
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('悬停启动，离开复位，重新移入从头开始', (tester) async {
    await render(tester, trigger: HyperTextScrollTrigger.hover);
    await tester.pump(const Duration(milliseconds: 200));
    expect(offset(tester), 0);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byType(HyperScrollingText)));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(offset(tester), greaterThan(0));
    await mouse.moveTo(Offset.zero);
    await tester.pump();

    await tester.pump(const Duration(milliseconds: 300));
    expect(offset(tester), 0);
    await mouse.moveTo(tester.getCenter(find.byType(HyperScrollingText)));
    await tester.pump();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));
    expect(offset(tester), greaterThan(0));
    await mouse.removePointer();
    await tester.pumpWidget(const SizedBox());
  });
  testWidgets('系统缩放、窄宽与RTL保留完整内容，减少动画停止位移', (tester) async {
    for (final scale in [1.0, 1.3, 2.0]) {
      await render(
        tester,
        scale: scale,
        reduced: true,
        direction: TextDirection.rtl,
        width: 40,
      );
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(offset(tester), 0);
      expect(find.text(longText), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
    await tester.pumpWidget(const SizedBox());
  });
}
