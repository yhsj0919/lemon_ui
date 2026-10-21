import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/steps/hyper_steps_body.dart';

const items = [
  HyperStepItem(id: 'current', title: Text('当前步骤')),
  HyperStepItem(id: 'next', title: Text('下一步骤')),
  HyperStepItem(id: 'disabled', title: Text('禁用步骤'), enabled: false),
];

Widget app(Widget child, {HyperThemeData? theme, double scale = 1}) =>
    MaterialApp(
      home: HyperTheme(
        duration: Duration.zero,
        data: theme ?? HyperThemeData.light(),
        child: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(width: 240, child: child),
            ),
          ),
        ),
      ),
    );

void main() {
  test('导航变体状态主题参与复制、合并、插值和全局主题', () {
    const a = HyperStepIndicatorThemeData(
      style: HyperStepStyle(nodeSize: 20),
      error: HyperStepStyle(foregroundColor: Colors.red),
      navigationError: HyperStepStyle(nodeSize: 30),
    );
    final b = a.copyWith(navigationError: HyperStepStyle(nodeSize: 50));
    expect(a.resolve(HyperStepStatus.error).nodeSize, 20);
    expect(a.resolve(HyperStepStatus.error, navigation: true).nodeSize, 30);
    expect(
      a.resolve(HyperStepStatus.error, navigation: true).foregroundColor,
      Colors.red,
    );
    expect(
      HyperStepIndicatorThemeData.lerp(a, b, .5).navigationError!.nodeSize,
      40,
    );
    expect(a, a.copyWith());
    expect(a.hashCode, a.copyWith().hashCode);
    final theme = HyperThemeData.light().copyWith(stepIndicatorTheme: a);
    expect(
      theme
          .lerp(theme.copyWith(stepIndicatorTheme: b), .5)
          .stepIndicatorTheme
          .navigationError!
          .nodeSize,
      40,
    );
  });

  testWidgets('公共、导航局部与实例覆盖按顺序生效', (tester) async {
    final theme = HyperThemeData.light().copyWith(
      stepIndicatorTheme: const HyperStepIndicatorThemeData(
        style: HyperStepStyle(nodeSize: 35),
        navigationStyle: HyperStepStyle(iconSize: 17),
      ),
    );
    await tester.pumpWidget(
      app(
        const HyperStepIndicatorTheme(
          data: HyperStepIndicatorThemeData(
            navigationCurrent: HyperStepStyle(nodeSize: 42),
          ),
          child: HyperStepIndicator.navigation(items: items, currentStep: 0),
        ),
        theme: theme,
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<HyperStepIndicator>(find.byType(HyperStepIndicator))
          .isNavigation,
      isTrue,
    );
    var body = tester.widget<HyperStepsBody>(find.byType(HyperStepsBody));
    expect(body.resolveTheme(HyperStepStatus.current).nodeSize, 42);
    expect(body.resolveTheme(HyperStepStatus.pending).nodeSize, 35);
    expect(body.resolveTheme(HyperStepStatus.pending).iconSize, 17);
    await tester.pumpWidget(
      app(
        const HyperStepIndicator.navigation(
          items: items,
          currentStep: 0,
          style: HyperStepStyle(nodeSize: 48),
        ),
        theme: theme,
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is AnimatedContainer &&
            w.constraints?.minWidth == 48 &&
            w.constraints?.minHeight == 48,
      ),
      findsNWidgets(3),
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('导航模式保留受控点击、禁用与键盘语义', (tester) async {
    final selected = <int>[];
    await tester.pumpWidget(
      app(
        HyperStepIndicator.navigation(
          items: items,
          currentStep: 0,
          onStepChanged: selected.add,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('当前步骤'));
    await tester.tap(find.text('禁用步骤'));
    expect(selected, isEmpty);
    await tester.tap(find.text('下一步骤'));
    expect(selected, [1]);
    Focus.of(tester.element(find.text('下一步骤'))).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(selected, [1, 1]);
    await tester.pumpWidget(
      app(
        HyperStepIndicator.navigation(
          items: items,
          currentStep: 0,
          enabled: false,
          onStepChanged: selected.add,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('下一步骤'));
    expect(selected, [1, 1]);
    expect(tester.takeException(), isNull);
  });

  for (final scale in [1.0, 1.3, 2.0]) {
    for (final direction in Axis.values) {
      testWidgets('导航窄宽 $direction 与文字缩放 $scale', (tester) async {
        await tester.pumpWidget(
          app(
            HyperStepIndicator.navigation(
              items: items,
              currentStep: 0,
              direction: direction,
            ),
            scale: scale,
          ),
        );
        await tester.pumpAndSettle();
        expect(find.text('下一步骤'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
