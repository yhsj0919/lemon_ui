import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/painting/hyper_box_decoration.dart';

Widget host(
  Widget child, {
  HyperThemeData? theme,
  bool reduced = false,
  double textScale = 1,
}) => MaterialApp(
  home: HyperTheme(
    data: theme ?? HyperThemeData.light(),
    duration: Duration.zero,
    child: MediaQuery(
      data: MediaQueryData(
        disableAnimations: reduced,
        textScaler: TextScaler.linear(textScale),
      ),
      child: Scaffold(body: Center(child: child)),
    ),
  ),
);
List<Transform> transforms(WidgetTester tester) => tester
    .widgetList<Transform>(
      find.descendant(
        of: find.byType(HyperMotion),
        matching: find.byType(Transform),
      ),
    )
    .toList();
HyperBoxDecoration shadow(WidgetTester tester) => tester
    .widgetList<DecoratedBox>(
      find.descendant(
        of: find.byType(HyperMotion),
        matching: find.byType(DecoratedBox),
      ),
    )
    .map((w) => w.decoration)
    .whereType<HyperBoxDecoration>()
    .first;
void main() {
  test('showShadow participates in style value operations', () {
    const base = HyperLiftStyle(showShadow: false);
    expect(base.copyWith(), base);
    expect(base.copyWith().hashCode, base.hashCode);
    expect(base.merge(const HyperLiftStyle(showShadow: true)).showShadow, true);
    expect(
      HyperLiftStyle.lerp(
        base,
        const HyperLiftStyle(showShadow: true),
        .75,
      ).showShadow,
      true,
    );
    expect(base, isNot(const HyperLiftStyle(showShadow: true)));
  });
  testWidgets('shadow override is independent of surface and adds no fill', (
    tester,
  ) async {
    final states = WidgetStatesController({WidgetState.hovered});
    Widget view(bool? showShadow, {bool? themedShadow}) => host(
      HyperLiftTheme(
        data: HyperLiftThemeData(
          style: HyperLiftStyle(showShadow: themedShadow),
        ),
        child: HyperMotion.lift(
          surface: false,
          showShadow: showShadow,
          statesController: states,
          child: const SizedBox(width: 120, height: 80),
        ),
      ),
    );
    await tester.pumpWidget(view(true));
    await tester.pumpAndSettle();
    expect(shadow(tester).boxShadow, isNotEmpty);
    expect(shadow(tester).color, isNull);
    expect(shadow(tester).gradient, isNull);
    await tester.pumpWidget(view(false, themedShadow: true));
    await tester.pumpAndSettle();
    expect(shadow(tester).boxShadow, isEmpty);
    await tester.pumpWidget(view(null, themedShadow: true));
    await tester.pumpAndSettle();
    expect(shadow(tester).boxShadow, isNotEmpty);
    await tester.pumpWidget(const SizedBox());
    states.dispose();
  });
  test('surface participates in style merge, interpolation and equality', () {
    const base = HyperLiftStyle(surface: false);
    expect(base.copyWith(), base);
    expect(base.copyWith().hashCode, base.hashCode);
    expect(base.merge(const HyperLiftStyle(surface: true)).surface, isTrue);
    expect(
      HyperLiftStyle.lerp(
        base,
        const HyperLiftStyle(surface: true),
        .75,
      ).surface,
      isTrue,
    );
  });
  testWidgets(
    'surface false preserves child state, transforms and child shadows',
    (tester) async {
      final states = WidgetStatesController({WidgetState.hovered});
      final childKey = GlobalKey();
      Widget view(bool? surface) => host(
        HyperLiftTheme(
          data: const HyperLiftThemeData(style: HyperLiftStyle(surface: false)),
          child: HyperMotion.lift(
            surface: surface,
            statesController: states,
            child: DecoratedBox(
              key: childKey,
              decoration: const BoxDecoration(
                boxShadow: [BoxShadow(blurRadius: 5)],
              ),
              child: const SizedBox(width: 120, height: 80),
            ),
          ),
        ),
      );
      await tester.pumpWidget(view(null));
      await tester.pumpAndSettle();
      final element = childKey.currentContext;
      expect(shadow(tester).boxShadow, isEmpty);
      expect(transforms(tester).first.transform.entry(1, 3), -2);
      expect(transforms(tester)[1].transform.entry(0, 0), closeTo(1.008, 1e-9));
      expect(
        (tester.widget<DecoratedBox>(find.byKey(childKey)).decoration
                as BoxDecoration)
            .boxShadow,
        isNotEmpty,
      );
      await tester.pumpWidget(view(true));
      await tester.pumpAndSettle();
      expect(shadow(tester).boxShadow, isNotEmpty);
      expect(childKey.currentContext, same(element));
      await tester.pumpWidget(view(false));
      await tester.pump(const Duration(milliseconds: 30));
      expect(shadow(tester).boxShadow, isEmpty);
      expect(childKey.currentContext, same(element));
      await tester.pumpWidget(const SizedBox());
      states.dispose();
    },
  );
  testWidgets(
    'hover lifts continuously; pressing restores; wrapper preserves taps and layout',
    (tester) async {
      var taps = 0, builds = 0;
      const key = ValueKey('lift-content');
      await tester.pumpWidget(
        host(
          HyperMotion.lift(
            child: Builder(
              builder: (context) {
                builds++;
                return GestureDetector(
                  onTap: () => taps++,
                  child: const SizedBox(
                    key: key,
                    width: 180,
                    height: 100,
                    child: ColoredBox(color: Colors.blue),
                  ),
                );
              },
            ),
          ),
        ),
      );
      final beforeBuilds = builds;
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.byKey(key)));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));
      final mid = transforms(tester).first.transform.entry(1, 3);
      expect(mid, inExclusiveRange(-2.0, 0.0));
      await mouse.moveTo(Offset.zero);
      await tester.pump();
      expect(
        transforms(tester).first.transform.entry(1, 3),
        closeTo(mid, 1e-9),
      );
      await tester.pump(const Duration(milliseconds: 60));
      expect(
        transforms(tester).first.transform.entry(1, 3),
        inExclusiveRange(mid, 0.0),
      );
      await mouse.moveTo(tester.getCenter(find.byKey(key)));
      await tester.pumpAndSettle();
      expect(transforms(tester).first.transform.entry(1, 3), -2);
      expect(transforms(tester)[1].transform.entry(0, 0), closeTo(1.008, 1e-9));
      expect(shadow(tester).boxShadow, isNotEmpty);
      expect(tester.getSize(find.byKey(key)), const Size(180, 100));
      expect(builds, beforeBuilds);
      final pointer = await tester.startGesture(
        tester.getCenter(find.byKey(key)),
      );
      await tester.pumpAndSettle();
      expect(transforms(tester).first.transform.entry(1, 3), 0);
      expect(transforms(tester)[1].transform.entry(0, 0), closeTo(.995, 1e-9));
      await pointer.up();
      await tester.pumpAndSettle();
      expect(taps, 1);
      await mouse.moveTo(Offset.zero);
      await tester.pumpAndSettle();
      expect(transforms(tester).first.transform.entry(1, 3), 0);
      expect(shadow(tester).boxShadow, isEmpty);
      await mouse.removePointer();
    },
  );
  testWidgets(
    'touch cancel, disabled wrapper and external state controller recover cleanly',
    (tester) async {
      final states = WidgetStatesController();
      var taps = 0;
      Widget lift(bool enabled) => HyperMotion.lift(
        enabled: enabled,
        statesController: states,
        child: GestureDetector(
          onTap: () => taps++,
          child: const SizedBox(
            width: 180,
            height: 100,
            child: ColoredBox(color: Colors.blue),
          ),
        ),
      );
      await tester.pumpWidget(host(lift(true)));
      final touch = await tester.startGesture(
        tester.getCenter(find.byType(HyperMotion)),
      );
      await tester.pumpAndSettle();
      expect(states.value, contains(WidgetState.pressed));
      expect(transforms(tester)[1].transform.entry(0, 0), closeTo(.995, 1e-9));
      await touch.cancel();
      await tester.pumpAndSettle();
      expect(states.value, isNot(contains(WidgetState.pressed)));
      expect(taps, 0);
      states.update(WidgetState.hovered, true);
      await tester.pumpAndSettle();
      expect(transforms(tester).first.transform.entry(1, 3), -2);
      await tester.pumpWidget(host(lift(false)));
      await tester.pumpAndSettle();
      expect(transforms(tester).first.transform.entry(1, 3), 0);
      await tester.tap(find.byType(HyperMotion));
      await tester.pumpAndSettle();
      expect(taps, 1);
      await tester.pumpWidget(const SizedBox());
      states.dispose();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'focus follows child; keyboard activation remains owned by child',
    (tester) async {
      final node = FocusNode();
      final states = WidgetStatesController();
      var taps = 0;
      await tester.pumpWidget(
        host(
          HyperMotion.lift(
            statesController: states,
            child: TextButton(
              focusNode: node,
              onPressed: () => taps++,
              child: const Text('action'),
            ),
          ),
        ),
      );
      node.requestFocus();
      await tester.pumpAndSettle();
      expect(states.value, contains(WidgetState.focused));
      expect(transforms(tester).first.transform.entry(1, 3), -2);
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(taps, 1);
      await tester.pumpWidget(const SizedBox());
      node.dispose();
      states.dispose();
    },
  );
  testWidgets(
    'reduce motion suppresses translation and scale without removing child',
    (tester) async {
      final states = WidgetStatesController({WidgetState.hovered});
      await tester.pumpWidget(
        host(
          HyperMotion.lift(
            statesController: states,
            child: const Text('content'),
          ),
          reduced: true,
        ),
      );
      await tester.pump();
      expect(transforms(tester).first.transform.entry(1, 3), 0);
      expect(transforms(tester)[1].transform.entry(0, 0), 1);
      expect(find.text('content'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      states.dispose();
    },
  );
  testWidgets(
    'global, local, instance overrides merge and explicit empty shadows win',
    (tester) async {
      late HyperLiftStyle resolved;
      final base = HyperThemeData.light();
      final theme = base.copyWith(
        motion: base.motion.copyWith(
          lift: const HyperLiftThemeData(
            style: HyperLiftStyle(hoverScale: 1.02, pressedScale: .99),
          ),
        ),
      );
      await tester.pumpWidget(
        host(
          HyperLiftTheme(
            data: const HyperLiftThemeData(
              style: HyperLiftStyle(hoverOffset: Offset(0, -6)),
            ),
            child: Builder(
              builder: (context) {
                resolved = resolveHyperLiftStyle(
                  context,
                  const HyperLiftStyle(hoverShadows: []),
                );
                return const SizedBox();
              },
            ),
          ),
          theme: theme,
        ),
      );
      expect(resolved.hoverScale, 1.02);
      expect(resolved.pressedScale, .99);
      expect(resolved.hoverOffset, const Offset(0, -6));
      expect(resolved.hoverShadows, isEmpty);
      for (final device in HyperDeviceType.values) {
        final s = base.sizes.resolve(device);
        expect(s.motionLift.hoverOffset, const Offset(0, -2));
        final changed = s.copyWith(
          motionLift: s.motionLift.copyWith(hoverOffset: const Offset(0, -4)),
        );
        expect(HyperSizeScheme.lerp(s, changed, 1), changed);
      }
      final changed = base.motion.copyWith(lift: theme.motion.lift);
      expect(HyperMotionThemeData.lerp(base.motion, changed, 1), changed);
      expect(const HyperLiftStyle().copyWith(), const HyperLiftStyle());
    },
  );
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('narrow lift keeps accessible text layout at $scale', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(
          const SizedBox(
            width: 100,
            child: HyperMotion.lift(
              child: HyperCard(child: Text('多行文字内容，跟随系统文字缩放。')),
            ),
          ),
          textScale: scale,
        ),
      );
      expect(tester.takeException(), isNull);
    });
  }
}
