import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('选择器触发样式和独立尺寸优先级，浮层显式空阴影', (tester) async {
    final theme = HyperThemeData.light();
    await tester.pumpWidget(
      MaterialApp(
        home: HyperDeviceDetector(
          deviceType: HyperDeviceType.desktop,
          builder: (context, device, child) => child!,
          child: HyperTheme(
            data: theme.copyWith(
              selectTheme: HyperSelectThemeData(
                style: HyperSelectStyle(
                  buttonStyle: HyperButtonStyle(
                    background: HyperFill.color(Colors.red),
                  ),
                  selectionStyle: HyperSelectionStyle(
                    surfaceStyle: HyperCardStyle(boxShadow: []),
                  ),
                ),
              ),
              sizes: theme.sizes.copyWith(
                desktop: theme.sizes.desktop.copyWith(
                  select: theme.sizes.desktop.select.copyWith(
                    minimumHeight: 44,
                    paddingHorizontal: 18,
                    paddingVertical: 7,
                    radius: 12,
                    minimumTapTargetSize: 48,
                    itemHeight: 47,
                    popupSpacing: 11,
                    surfaceRadius: 17,
                  ),
                ),
              ),
            ),
            child: const Scaffold(body: Center(child: _SelectSample())),
          ),
        ),
      ),
    );
    final button = tester.widget<HyperButton>(find.byType(HyperButton));
    expect(button.style!.background!.color, Colors.green);
    expect(button.style!.minimumSize!.height, 44);
    expect(
      button.style!.padding,
      const EdgeInsets.symmetric(horizontal: 18, vertical: 7),
    );
    expect(button.style!.borderRadius, BorderRadius.circular(12));
    expect(button.style!.minimumTapTargetSize, const Size.square(48));
    await tester.pumpAndSettle();
    await tester.tap(find.text('请选择'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
    final card = tester.widget<HyperCard>(find.byType(HyperCard));
    expect(card.style!.boxShadow, isEmpty);
    expect(card.style!.borderRadius, BorderRadius.circular(17));
    expect(find.text('选项一'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  test('选择器触发主题与面板尺寸支持复制插值和值相等', () {
    final a = HyperSelectStyle(
      buttonStyle: HyperButtonStyle(hoveredOffset: const Offset(0, -2)),
    );
    final b = a.copyWith(
      buttonStyle: HyperButtonStyle(hoveredOffset: const Offset(0, -4)),
    );
    expect(a.copyWith(), a);
    expect(
      HyperSelectStyle.lerp(a, b, .5).buttonStyle!.hoveredOffset,
      const Offset(0, -3),
    );
    final sizes = HyperThemeData.light().sizes.desktop.select;
    final x = sizes.copyWith(
      popupSpacing: 4,
      itemHeight: 40,
      surfaceRadius: 10,
    );
    final y = x.copyWith(popupSpacing: 8, itemHeight: 48, surfaceRadius: 18);
    expect(x.copyWith(), x);
    final mid = HyperSelectSize.lerp(x, y, .5);
    expect(mid.popupSpacing, 6);
    expect(mid.itemHeight, 44);
    expect(mid.surfaceRadius, 14);
    expect(x, isNot(y));
  });
}

class _SelectSample extends StatelessWidget {
  const _SelectSample();
  @override
  Widget build(BuildContext context) => HyperSelect<String>(
    options: const [HyperSelectOption(value: 'one', label: '选项一')],
    value: null,
    onChanged: (_) {},
    buttonStyle: HyperButtonStyle(background: HyperFill.color(Colors.green)),
  );
}
