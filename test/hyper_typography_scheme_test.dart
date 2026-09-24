import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('默认字号对应明确使用场景', () {
    const typography = HyperTypographyScheme();

    expect(typography.pageTitle, 32);
    expect(typography.sectionTitle, 24);
    expect(typography.body, 16);
    expect(typography.control, 16);
    expect(typography.caption, 12);
  });

  test('copyWith 只修改指定字号且不执行倍率缩放', () {
    const original = HyperTypographyScheme();
    final changed = original.copyWith(body: 17);

    expect(changed.body, 17);
    expect(changed.bodyLarge, original.bodyLarge);
    expect(changed.pageTitle, original.pageTitle);
  });

  test('主题中替换字号方案会同步 TextTheme', () {
    final original = HyperThemeData.light();
    final typography = original.typography.copyWith(body: 18, control: 17);
    final changed = original.copyWith(typography: typography);

    expect(changed.textTheme.bodyMedium?.fontSize, 18);
    expect(changed.textTheme.labelLarge?.fontSize, 17);
    expect(changed.textTheme.bodyMedium?.fontFamily, isNotNull);
  });

  test('字号方案支持精确插值', () {
    const start = HyperTypographyScheme();
    final end = start.copyWith(pageTitle: 40);
    final middle = HyperTypographyScheme.lerp(start, end, .5);

    expect(middle.pageTitle, 36);
    expect(middle.body, start.body);
  });

  test('能够应用到 Flutter TextTheme', () {
    const typography = HyperTypographyScheme();
    final textTheme = typography.applyTo(ThemeData().textTheme);

    expect(textTheme.headlineLarge?.fontSize, typography.pageTitle);
    expect(textTheme.headlineMedium?.fontSize, typography.sectionTitle);
    expect(textTheme.bodySmall?.fontSize, typography.bodySmall);
  });

  testWidgets('桌面字阶由主题按真实设备解析，手机规格不变', (tester) async {
    final data = HyperThemeData.light();
    late HyperThemeData resolved;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperDeviceDetector(
          deviceType: HyperDeviceType.desktop,
          builder: (context, _, _) => HyperTheme(
            data: data,
            duration: Duration.zero,
            child: Builder(
              builder: (context) {
                resolved = HyperTheme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      ),
    );
    expect(resolved.typography.body, 14);
    expect(resolved.textTheme.bodyMedium?.fontSize, 14);
    expect(data.typographyTheme.phone.body, 16);

    final changed = data.copyWith(
      typographyTheme: data.typographyTheme.copyWith(
        desktop: data.typographyTheme.desktop.copyWith(body: 16),
      ),
    );
    expect(changed.typographyTheme.desktop.body, 16);
    expect(changed.typographyTheme.phone.body, 16);
  });
}
