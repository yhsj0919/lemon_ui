import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget _host(
  Widget child, {
  HyperMenuThemeData menu = const HyperMenuThemeData(),
}) => MaterialApp(
  home: HyperDeviceDetector(
    deviceType: HyperDeviceType.desktop,
    builder: (_, _, child) => HyperTheme(
      data: HyperThemeData.light().copyWith(menuTheme: menu),
      child: child!,
    ),
    child: Scaffold(body: Center(child: child)),
  ),
);

void main() {
  test(
    'menu trigger theme supports copy, merge, interpolation and equality',
    () {
      final base = HyperMenuThemeData(
        buttonStyle: HyperButtonStyle(height: 32, foregroundColor: Colors.red),
      );
      final changed = base.copyWith(buttonStyle: HyperButtonStyle(height: 48));
      expect(changed.buttonStyle!.foregroundColor, Colors.red);
      expect(base.merge(changed), changed);
      expect(base.merge(null), base);
      expect(
        HyperMenuThemeData.lerp(base, changed, .5).buttonStyle!.height,
        40,
      );
      expect(changed, isNot(base));
      expect(
        base.hashCode,
        HyperMenuThemeData(
          buttonStyle: HyperButtonStyle(
            height: 32,
            foregroundColor: Colors.red,
          ),
        ).hashCode,
      );
      final theme = HyperThemeData.light().copyWith(menuTheme: base);
      expect(theme.menuTheme, base);
      expect(
        theme
            .lerp(theme.copyWith(menuTheme: changed), .5)
            .menuTheme
            .buttonStyle!
            .height,
        40,
      );
    },
  );

  for (final variant in HyperButtonVariant.values) {
    testWidgets('menu trigger inherits and merges styles for $variant', (
      tester,
    ) async {
      for (final overridden in [false, true]) {
        await tester.pumpWidget(
          _host(
            HyperMenuTheme(
              data: HyperMenuThemeData(
                buttonStyle: HyperButtonStyle(foregroundColor: Colors.green),
              ),
              child: HyperMenuButton(
                variant: variant,
                buttonStyle: overridden ? HyperButtonStyle(height: 44) : null,
                items: const [HyperMenuItem(id: 'a', label: '选项')],
                child: const Text('打开菜单'),
              ),
            ),
            menu: HyperMenuThemeData(
              buttonStyle: HyperButtonStyle(
                height: 36,
                foregroundColor: Colors.red,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final button = tester.widget<HyperButton>(find.byType(HyperButton));
        expect(button.style!.height, overridden ? 44 : 36);
        expect(button.style!.foregroundColor, Colors.green);
      }
      await tester.tap(find.text('打开菜单'));
      await tester.pumpAndSettle();
      expect(find.text('选项'), findsOneWidget);
      await tester.tap(find.text('选项'));
      await tester.pumpAndSettle();
      expect(find.text('选项'), findsNothing);
    });
  }

  for (final override in [null, Colors.orange]) {
    testWidgets(
      'desktop menu selected foreground uses primary or override $override',
      (tester) async {
        await tester.pumpWidget(
          _host(
            HyperMenuTheme(
              data: HyperMenuThemeData(
                style: HyperMenuStyle(selectedForegroundColor: override),
              ),
              child: const HyperMenu(
                selectedId: 'a',
                items: [HyperMenuItem(id: 'a', label: '已选中')],
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final label = find.text('已选中');
        final context = tester.element(label);
        final text = tester.widget<Text>(label);
        final style = DefaultTextStyle.of(context).style.merge(text.style);
        expect(style.color, override ?? HyperTheme.of(context).colors.primary);
      },
    );
  }
}
