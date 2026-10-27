import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/menu/hyper_menu_surface.dart';

void main() {
  for (final mode in ['default', 'local', 'instance']) {
    testWidgets('错误浮层公共表面与阴影覆盖：$mode', (tester) async {
      const shadow = BoxShadow(color: Colors.red, blurRadius: 19);
      final theme = HyperThemeData.light();
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: theme,
            child: HyperCardTheme(
              data: HyperCardThemeData(
                style: HyperCardStyle(
                  borderRadius: BorderRadius.all(Radius.circular(9)),
                ),
              ),
              child: HyperTextFieldTheme(
                data: HyperTextFieldThemeData(
                  style: HyperTextFieldStyle(
                    errorPopupStyle: mode == 'local'
                        ? HyperCardStyle(boxShadow: [shadow])
                        : null,
                  ),
                ),
                child: Scaffold(
                  body: Center(
                    child: SizedBox(
                      width: 320,
                      child: HyperTextField(
                        errorText: '详情',
                        style: mode == 'instance'
                            ? HyperTextFieldStyle(
                                errorPopupStyle: HyperCardStyle(boxShadow: []),
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byIcon(HyperIcons.circleAlert));
      await tester.pumpAndSettle();
      final card = tester.widget<HyperCard>(find.byType(HyperCard));
      final context = tester.element(find.byType(HyperCard));
      final sizes = HyperTheme.sizesOf(context);
      final expected = resolveHyperMenuSurface(
        context,
        radius: sizes.menu.surfaceRadius,
        padding: EdgeInsets.all(sizes.textField.horizontalPadding),
        style: mode == 'local'
            ? HyperCardStyle(boxShadow: [shadow])
            : mode == 'instance'
            ? HyperCardStyle(boxShadow: [])
            : null,
      );
      expect(card.style!.material, expected.material);
      expect(card.style!.borderRadius, expected.borderRadius);
      if (mode == 'default') {
        expect(card.style!.material!.boxShadow, isNotEmpty);
        expect(card.style!.material!.fallback!.boxShadow, isNotEmpty);
      } else {
        expect(card.style!.boxShadow, mode == 'local' ? [shadow] : isEmpty);
      }
      expect(find.text('详情'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  }
}
