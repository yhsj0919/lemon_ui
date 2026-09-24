import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget app(Widget child) => MaterialApp(
  home: HyperTheme(
    data: HyperThemeData.light(),
    duration: Duration.zero,
    child: Scaffold(body: child),
  ),
);

void main() {
  testWidgets('退场动画结束后才移除浮层，重新打开可打断退场', (tester) async {
    await tester.pumpWidget(
      app(
        HyperAnchoredOverlay(
          anchor: const SizedBox(width: 80, height: 40, child: Text('动画锚点')),
          overlayBuilder: (context, close) =>
              TextButton(onPressed: close, child: const Text('动画浮层')),
        ),
      ),
    );

    await tester.tap(find.text('动画锚点'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('动画浮层'));
    await tester.pump();
    expect(find.text('动画浮层'), findsOneWidget);
    expect(
      tester
          .widget<IgnorePointer>(
            find
                .ancestor(
                  of: find.text('动画浮层'),
                  matching: find.byType(IgnorePointer),
                )
                .first,
          )
          .ignoring,
      isTrue,
    );

    await tester.tap(find.text('动画锚点'));
    await tester.pumpAndSettle();
    expect(find.text('动画浮层'), findsOneWidget);

    await tester.tap(find.text('动画锚点'));
    await tester.pump();
    expect(find.text('动画浮层'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.text('动画浮层'), findsNothing);
  });

  testWidgets('关闭系统动画时浮层即时开合', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: Scaffold(
              body: HyperAnchoredOverlay(
                transition: HyperOverlayTransition.fade,
                anchor: const Text('无动画锚点'),
                overlayBuilder: (context, close) =>
                    TextButton(onPressed: close, child: const Text('无动画浮层')),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('无动画锚点'));
    await tester.pump();
    await tester.pump();
    expect(find.text('无动画浮层'), findsOneWidget);
    await tester.tap(find.text('无动画浮层'));
    await tester.pump();
    await tester.pump();
    expect(find.text('无动画浮层'), findsNothing);
  });

  testWidgets('自定义过渡完全替换内置过渡', (tester) async {
    Animation<double>? progress;
    await tester.pumpWidget(
      app(
        HyperAnchoredOverlay(
          anchor: const Text('自定义锚点'),
          transitionBuilder: (context, animation, child) {
            progress = animation;
            return FadeTransition(
              key: const Key('custom-transition'),
              opacity: animation,
              child: child,
            );
          },
          overlayBuilder: (context, close) => const Text('自定义浮层'),
        ),
      ),
    );

    await tester.tap(find.text('自定义锚点'));
    await tester.pump();
    await tester.pump();
    expect(find.byKey(const Key('custom-transition')), findsOneWidget);
    expect(
      find.descendant(
        of: find.byKey(const Key('custom-transition')),
        matching: find.byType(ScaleTransition),
      ),
      findsNothing,
    );
    await tester.pumpAndSettle();
    expect(progress!.value, 1);
  });

  testWidgets('点击打开，外部点击和 Escape 关闭', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      app(
        Stack(
          children: [
            Positioned(
              left: 100,
              top: 100,
              child: HyperAnchoredOverlay(
                anchor: const SizedBox(
                  width: 80,
                  height: 40,
                  child: Text('锚点'),
                ),
                overlayBuilder: (context, close) =>
                    const SizedBox(width: 120, height: 80, child: Text('浮层内容')),
              ),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('锚点'));
    await tester.pumpAndSettle();
    expect(find.text('浮层内容'), findsOneWidget);
    expect(tester.getTopLeft(find.text('浮层内容')), const Offset(100, 140));

    await tester.tapAt(const Offset(350, 400));
    await tester.pumpAndSettle();
    expect(find.text('浮层内容'), findsNothing);

    await tester.tap(find.text('锚点'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.text('浮层内容'), findsNothing);
  });

  testWidgets('窗口边缘自动翻转并保持内容在可见区域', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      app(
        Stack(
          children: [
            Positioned(
              left: 310,
              top: 640,
              child: HyperAnchoredOverlay(
                anchor: const SizedBox(
                  width: 80,
                  height: 40,
                  child: Text('边缘锚点'),
                ),
                overlayBuilder: (context, close) => const SizedBox(
                  width: 120,
                  height: 100,
                  child: Text('避让内容'),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('边缘锚点'));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text('避让内容')), const Offset(280, 540));
  });

  testWidgets('侧向浮层在右侧空间不足时翻到锚点左侧', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      app(
        Stack(
          children: [
            Positioned(
              left: 340,
              top: 100,
              child: HyperAnchoredOverlay(
                placement: HyperOverlayPlacement.sideEnd,
                anchor: const SizedBox(
                  width: 50,
                  height: 40,
                  child: Text('侧向锚点'),
                ),
                overlayBuilder: (context, close) =>
                    const SizedBox(width: 120, height: 80, child: Text('侧向内容')),
              ),
            ),
          ],
        ),
      ),
    );

    await tester.tap(find.text('侧向锚点'));
    await tester.pumpAndSettle();
    expect(tester.getTopLeft(find.text('侧向内容')), const Offset(220, 100));
  });

  testWidgets('内容跟随滚动中的锚点', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final controller = ScrollController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      app(
        ListView(
          controller: controller,
          children: [
            const SizedBox(height: 200),
            HyperAnchoredOverlay(
              anchor: const SizedBox(height: 40, child: Text('滚动锚点')),
              overlayBuilder: (context, close) =>
                  const SizedBox(width: 120, height: 80, child: Text('跟随内容')),
            ),
            const SizedBox(height: 1000),
          ],
        ),
      ),
    );

    await tester.tap(find.text('滚动锚点'));
    await tester.pumpAndSettle();
    final before = tester.getTopLeft(find.text('跟随内容'));
    controller.jumpTo(50);
    await tester.pumpAndSettle();
    final after = tester.getTopLeft(find.text('跟随内容'));
    expect(after.dy, before.dy - 50);
  });

  testWidgets('悬停时鼠标移入浮层保持打开，离开后关闭', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      app(
        Stack(
          children: [
            Positioned(
              left: 80,
              top: 100,
              child: HyperAnchoredOverlay(
                trigger: HyperOverlayTrigger.hover,
                anchor: const SizedBox(
                  width: 80,
                  height: 40,
                  child: Text('悬停锚点'),
                ),
                overlayBuilder: (context, close) =>
                    const SizedBox(width: 120, height: 80, child: Text('悬停内容')),
              ),
            ),
          ],
        ),
      ),
    );

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(const Offset(100, 120));
    await tester.pumpAndSettle();
    expect(find.text('悬停内容'), findsOneWidget);

    await mouse.moveTo(const Offset(110, 170));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('悬停内容'), findsOneWidget);

    await mouse.moveTo(const Offset(300, 300));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pumpAndSettle();
    expect(find.text('悬停内容'), findsNothing);
    await mouse.removePointer();
  });

  testWidgets('受控开合由调用方同步状态', (tester) async {
    var opened = false;
    await tester.pumpWidget(
      app(
        StatefulBuilder(
          builder: (context, update) => Column(
            children: [
              HyperAnchoredOverlay(
                trigger: HyperOverlayTrigger.manual,
                isOpen: opened,
                onOpenChanged: (value) => update(() => opened = value),
                anchor: const SizedBox(
                  width: 80,
                  height: 40,
                  child: Text('受控锚点'),
                ),
                overlayBuilder: (context, close) =>
                    TextButton(onPressed: close, child: const Text('关闭受控浮层')),
              ),
              TextButton(
                onPressed: () => update(() => opened = true),
                child: const Text('外部打开'),
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.text('外部打开'));
    await tester.pumpAndSettle();
    expect(opened, isTrue);
    expect(find.text('关闭受控浮层'), findsOneWidget);
    await tester.tap(find.text('关闭受控浮层'));
    await tester.pumpAndSettle();
    expect(opened, isFalse);
    expect(find.text('关闭受控浮层'), findsNothing);
  });
}
