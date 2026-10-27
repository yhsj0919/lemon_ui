import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/motion/hyper_animated_checkmark.dart';

void main() {
  for (final device in [HyperDeviceType.phone, HyperDeviceType.desktop]) {
    testWidgets('list popup preserves $device surface padding', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperDeviceDetector(
            deviceType: device,
            builder: (context, device, child) => HyperTheme(
              data: HyperThemeData.light(),
              child: Scaffold(
                body: HyperPopupListTile<String>(
                  title: const Text('popup'),
                  value: 'one',
                  options: const [HyperSelectOption(value: 'one', label: '选项')],
                  onChanged: (_) {},
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('popup'));
      await tester.pumpAndSettle();
      final panel = tester.getRect(find.byType(HyperCard));
      final item = tester.getRect(
        find.byKey(const ValueKey('hyper-menu-item-0')),
      );
      final expected = device == HyperDeviceType.phone
          ? 0.0
          : HyperSizeScheme.desktop().menu.padding;
      expect(item.top - panel.top, expected);
      expect(panel.bottom - item.bottom, expected);
      expect(item.left - panel.left, expected);
      expect(panel.right - item.right, expected);
    });
  }

  for (final modal in [false, true]) {
    testWidgets(
      'phone popup tile ${modal ? 'explicit sheet' : 'default anchored'} has one surface',
      (tester) async {
        String? selected;
        await tester.pumpWidget(
          MaterialApp(
            home: HyperDeviceDetector(
              deviceType: HyperDeviceType.phone,
              builder: (context, device, child) => HyperTheme(
                data: HyperThemeData.light(),
                child: Scaffold(
                  body: HyperPopupListTile<String>(
                    title: const Text('日志级别'),
                    value: 'info',
                    presentation: modal
                        ? HyperSelectPresentation.bottomSheet
                        : const HyperPopupListTile<String>(
                            title: Text('default'),
                            options: [],
                            value: null,
                            onChanged: null,
                          ).presentation,
                    menuStyle: HyperMenuStyle(
                      surfaceStyle: HyperCardStyle(boxShadow: const []),
                    ),
                    options: const [
                      HyperSelectOption(value: 'info', label: '信息'),
                      HyperSelectOption(value: 'debug', label: '调试'),
                    ],
                    onChanged: (value) => selected = value,
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('日志级别'));
        await tester.pumpAndSettle();
        final menu = tester.widget<HyperMenu>(find.byType(HyperMenu));
        expect(menu.showSurface, !modal);
        expect(
          find.byType(HyperBottomSheet),
          modal ? findsOneWidget : findsNothing,
        );
        if (modal) {
          expect(
            find.descendant(
              of: find.byType(HyperBottomSheet),
              matching: find.byType(HyperCard),
            ),
            findsNothing,
          );
          expect(
            tester
                .widget<HyperBottomSheet>(find.byType(HyperBottomSheet))
                .style!
                .boxShadow,
            isEmpty,
          );
        } else {
          expect(find.byType(HyperCard), findsOneWidget);
          final panel = tester.getRect(find.byType(HyperCard));
          final selectedItem = find.byKey(const ValueKey('hyper-menu-item-0'));
          final selectedRect = tester.getRect(selectedItem);
          expect(selectedRect.top, panel.top);
          expect(
            tester
                .getRect(find.byKey(const ValueKey('hyper-menu-item-1')))
                .bottom,
            panel.bottom,
          );
          expect(selectedRect.left, panel.left);
          expect(selectedRect.right, panel.right);
          final visual = tester.widget<AnimatedContainer>(selectedItem);
          expect(
            (visual.decoration! as BoxDecoration).color,
            Colors.transparent,
          );
          final theme = HyperTheme.of(tester.element(selectedItem));
          expect(
            tester.widget<Text>(find.text('信息').last).style!.color,
            theme.colors.primary,
          );
          expect(
            tester
                .widget<HyperAnimatedCheckmark>(
                  find.descendant(
                    of: selectedItem,
                    matching: find.byType(HyperAnimatedCheckmark),
                  ),
                )
                .color,
            theme.colors.primary,
          );
          expect(
            (visual.decoration! as BoxDecoration).borderRadius,
            BorderRadius.zero,
          );
        }
        await tester.tap(find.text('调试'));
        await tester.pumpAndSettle();
        expect(selected, 'debug');
        expect(find.text('调试'), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
