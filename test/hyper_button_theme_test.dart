import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('按钮样式支持继承、显式清除和恢复继承', () {
    final base = HyperButtonStyle(
      background: const HyperFill.color(Colors.orange),
      border: const BorderSide(width: 2),
      boxShadow: const [BoxShadow(blurRadius: 8)],
      height: 48,
    );
    final cleared = base.merge(
      HyperButtonStyle(
        background: const HyperFill.none(),
        border: BorderSide.none,
        boxShadow: const [],
        height: 0,
      ),
    );
    expect(cleared.background, const HyperFill.none());
    expect(cleared.border, BorderSide.none);
    expect(cleared.boxShadow, isEmpty);
    expect(cleared.height, 0);
    expect(base.copyWith(background: null).background, isNull);
    expect(base.copyWith().background, base.background);
  });

  test('公共样式与指定变体逐字段合并', () {
    final theme = HyperButtonThemeData(
      style: HyperButtonStyle(height: 48, iconSize: 22),
      outlined: HyperButtonStyle(
        background: const HyperFill.none(),
        material: const HyperSurfaceMaterial.frostedGlass(),
        border: const BorderSide(width: 1),
      ),
    );
    final style = theme.resolve(HyperButtonVariant.outlined);
    expect(style.height, 48);
    expect(style.iconSize, 22);
    expect(style.background, const HyperFill.none());
    expect(style.material?.kind, HyperSurfaceMaterialKind.frostedGlass);
    expect(style.border, const BorderSide(width: 1));
  });

  test('插值保留明确尺寸和圆角', () {
    final start = HyperButtonStyle(
      height: 40,
      borderRadius: BorderRadius.circular(8),
    );
    final end = HyperButtonStyle(
      height: 56,
      borderRadius: BorderRadius.circular(24),
    );
    final middle = HyperButtonStyle.lerp(start, end, .5);
    expect(middle.height, 48);
    expect(middle.borderRadius, BorderRadius.circular(16));
  });

  testWidgets('局部按钮主题只覆盖当前子树', (tester) async {
    final global = HyperThemeData.light().copyWith(
      buttonTheme: HyperButtonThemeData(
        style: HyperButtonStyle(height: 48, iconSize: 20),
      ),
    );
    late HyperButtonStyle outside;
    late HyperButtonStyle inside;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: global,
          duration: Duration.zero,
          child: Builder(
            builder: (context) {
              outside = HyperButtonTheme.of(context)
                  .resolve(HyperButtonVariant.filled);
              return HyperButtonTheme(
                data: HyperButtonThemeData(
                  style: HyperButtonStyle(iconSize: 24),
                ),
                child: HyperButtonTheme(
                  data: HyperButtonThemeData(
                    style: HyperButtonStyle(height: 60),
                  ),
                  child: Builder(
                    builder: (context) {
                      inside = HyperButtonTheme.of(context)
                          .resolve(HyperButtonVariant.filled);
                      return const SizedBox();
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
    expect(outside.height, 48);
    expect(inside.height, 60);
    expect(inside.iconSize, 24);
  });
}
