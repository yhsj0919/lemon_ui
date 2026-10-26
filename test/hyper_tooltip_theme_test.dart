import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('tooltip has no default border or material highlight', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: const Scaffold(
            body: Center(
              child: HyperTooltip(
                message: 'Tip',
                waitDuration: Duration.zero,
                child: SizedBox(key: Key('anchor'), width: 40, height: 40),
              ),
            ),
          ),
        ),
      ),
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byKey(const Key('anchor'))));
    await tester.pumpAndSettle();
    final card = tester.widget<HyperCard>(find.byType(HyperCard).last);
    expect(card.style!.border, const Border());
    expect(card.style!.materialEdge, false);
    await mouse.removePointer();
    await tester.pumpAndSettle();
  });
  test('提示全局配置支持复制、插值和值相等', () {
    final base = HyperThemeData.light();
    const setting = HyperTooltipThemeData(
      appearance: HyperTooltipAppearance.theme,
      foregroundColor: Colors.red,
    );
    final configured = base.copyWith(tooltipTheme: setting);
    expect(configured.tooltipTheme, setting);
    expect(configured, isNot(base));
    expect(configured.copyWith(), configured);
    expect(configured.lerp(base, 0).tooltipTheme.foregroundColor, Colors.red);
    expect(
      configured.lerp(base, 0).tooltipTheme.appearance,
      HyperTooltipAppearance.theme,
    );
    expect(
      setting
          .merge(const HyperTooltipThemeData(foregroundColor: Colors.blue))
          .appearance,
      HyperTooltipAppearance.theme,
    );
  });
}
