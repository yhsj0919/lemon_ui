import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('Windows 默认使用系统中文 UI 字体', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);

    final theme = HyperThemeData.light();

    expect(theme.textTheme.bodyMedium?.fontFamily, 'Microsoft YaHei UI');
    expect(
      theme.textTheme.bodyMedium?.fontFamilyFallback,
      contains('Microsoft YaHei'),
    );
  });

  test('默认主题提供显式逻辑尺寸且不进行倍率缩放', () {
    final theme = HyperThemeData.light();
    expect(theme.sizes.phone.controlHeightMd, 48);
    expect(
      theme.sizes.phone.controlPadding,
      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    );
    expect(theme.sizes.phone.controlRadius, 16);

    final changed = theme.copyWith(
      sizes: theme.sizes.copyWith(
        phone: theme.sizes.phone.copyWith(controlHeightMd: 64),
      ),
    );
    expect(changed.sizes.phone.controlHeightMd, 64);
    expect(
      changed.sizes.phone.controlPadding,
      theme.sizes.phone.controlPadding,
    );
  });

  test('主题插值包含基础尺寸与组件主题', () {
    final start = HyperThemeData.light();
    final end = start.copyWith(
      sizes: start.sizes.copyWith(
        phone: start.sizes.phone.copyWith(
          controlHeightMd: 64,
          controlRadius: 24,
        ),
      ),
      containerTheme: HyperContainerThemeData(
        padding: const EdgeInsets.all(24),
      ),
    );
    final middle = start.lerp(end, .5);
    expect(middle.sizes.phone.controlHeightMd, 56);
    expect(middle.sizes.phone.controlRadius, 20);
    expect(middle.containerTheme.padding, const EdgeInsets.all(24));
  });

  testWidgets('无显式主题时从 Material 主题生成安全默认值', (tester) async {
    const primary = Color(0xFF123456);
    late HyperThemeData resolved;
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(colorSchemeSeed: primary),
        home: Builder(
          builder: (context) {
            resolved = HyperTheme.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
    expect(
      resolved.colors.primary,
      ThemeData(colorSchemeSeed: primary).colorScheme.primary,
    );
  });

  testWidgets('局部主题只覆盖子树并同步 Material 主题', (tester) async {
    final outer = HyperThemeData.light();
    final inner = outer.copyWith(
      sizes: outer.sizes.copyWith(
        tablet: outer.sizes.tablet.copyWith(controlHeightMd: 72),
      ),
    );
    late double outerBefore;
    late double innerValue;
    late double outerAfter;
    late Color materialPrimary;

    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: outer,
          duration: Duration.zero,
          child: Builder(
            builder: (context) {
              outerBefore = HyperTheme.sizesOf(context).controlHeightMd;
              materialPrimary = Theme.of(context).colorScheme.primary;
              return Column(
                children: [
                  HyperTheme(
                    data: inner,
                    duration: Duration.zero,
                    child: Builder(
                      builder: (context) {
                        innerValue = HyperTheme.sizesOf(context)
                            .controlHeightMd;
                        return const SizedBox();
                      },
                    ),
                  ),
                  Builder(
                    builder: (context) {
                      outerAfter = HyperTheme.sizesOf(context).controlHeightMd;
                      return const SizedBox();
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );

    expect(outerBefore, 52);
    expect(innerValue, 72);
    expect(outerAfter, 52);
    expect(materialPrimary, outer.colors.primary);
  });
}
