import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('固定与自适应宽度切换的中间帧不插值无界约束', (tester) async {
    double? width;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, setState) {
                  update = setState;
                  return HyperButton.filled(
                    onPressed: () {},
                    style: HyperButtonStyle(width: width),
                    child: const Text('宽度切换'),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    for (final next in <double?>[160, null, 100, null]) {
      update(() => width = next);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));
      expect(tester.takeException(), isNull);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    }
  });
  test('三档宽度独立覆盖、清空和插值', () {
    final base = const HyperSizeScheme.desktop().button;
    final changed = base.copyWith(
      smallMinimumWidth: 84.0,
      largeMinimumWidth: 120.0,
      smallWidth: 100.0,
      width: 140.0,
      largeWidth: 180.0,
    );
    expect(changed.minimumWidthFor(HyperButtonSizeVariant.small), 84);
    expect(
      changed.minimumWidthFor(HyperButtonSizeVariant.medium),
      base.minimumSize.width,
    );
    expect(changed.widthFor(HyperButtonSizeVariant.large), 180);
    expect(changed.copyWith(width: null).width, isNull);
    expect(changed.copyWith(), changed);
    final midpoint = HyperButtonSize.lerp(
      changed,
      changed.copyWith(width: 180.0, smallWidth: 140.0),
      .5,
    );
    expect(midpoint.width, 160);
    expect(midpoint.smallWidth, 120);
    for (final sizes in [
      const HyperSizeScheme.phone(),
      const HyperSizeScheme.tablet(),
      const HyperSizeScheme.desktop(),
      const HyperSizeScheme.watch(),
    ]) {
      expect(
        sizes.button
            .copyWith(minimumSize: const Size(200, 50))
            .minimumWidthFor(HyperButtonSizeVariant.small),
        sizes.button.minimumWidthFor(HyperButtonSizeVariant.small),
      );
    }
  });
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('三档按钮消费真实尺寸，文字缩放 $scale 不裁切', (tester) async {
      final device = const HyperSizeScheme.desktop();
      final theme = HyperThemeData.light().copyWith(
        sizes: HyperSizeThemeData(
          desktop: device.copyWith(
            button: device.button.copyWith(
              smallWidth: 110.0,
              width: 140.0,
              largeWidth: 180.0,
              smallMinimumWidth: 80.0,
              minimumSize: const Size(90, 36),
              largeMinimumWidth: 100.0,
              smallHeight: 28,
              largeHeight: 48,
            ),
          ),
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: HyperDeviceDetector(
            deviceType: HyperDeviceType.desktop,
            builder: (context, device, child) => HyperTheme(
              data: theme,
              child: MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                child: const Scaffold(
                  body: SizedBox(
                    width: 240,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        HyperButton.filled(
                          onPressed: null,
                          size: HyperButtonSizeVariant.small,
                          child: Text('按钮'),
                        ),
                        HyperButton.filled(
                          onPressed: null,
                          size: HyperButtonSizeVariant.medium,
                          child: Text('按钮'),
                        ),
                        HyperButton.filled(
                          onPressed: null,
                          size: HyperButtonSizeVariant.large,
                          child: Text('按钮'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      final buttons = find.byType(HyperButton);
      for (var i = 0; i < 3; i++) {
        final visual = find
            .descendant(
              of: buttons.at(i),
              matching: find.byWidgetPredicate(
                (w) => w is AnimatedContainer && w.decoration != null,
              ),
            )
            .first;
        expect(tester.getSize(visual).width, [110.0, 140.0, 180.0][i]);
        expect(
          tester.getSize(visual).height,
          greaterThanOrEqualTo([28.0, 36.0, 48.0][i]),
        );
        final text = find.descendant(
          of: buttons.at(i),
          matching: find.text('按钮'),
        );
        expect(
          tester.getRect(visual).contains(tester.getRect(text).center),
          isTrue,
        );
        expect(
          tester.getRect(text).top,
          greaterThanOrEqualTo(tester.getRect(visual).top),
        );
        expect(
          tester.getRect(text).bottom,
          lessThanOrEqualTo(tester.getRect(visual).bottom),
        );
      }
      expect(tester.takeException(), isNull);
    });
  }
}
