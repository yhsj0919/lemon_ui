import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('默认蓝色主背景归为深色，自适应保留白色语义前景', () {
    final theme = HyperThemeData.light();
    const blue = Color(0xFF3482FF);
    expect(ThemeData.estimateBrightnessForColor(blue), Brightness.dark);
    expect(
      theme.contrastTheme.resolve(
        foreground: Colors.white,
        background: const HyperFill.color(blue),
        canvasColor: Colors.white,
      ),
      Colors.white,
    );
    expect(
      theme.contrastTheme.resolve(
        foreground: blue,
        background: const HyperFill.color(blue),
        canvasColor: Colors.white,
      ),
      theme.contrastTheme.lightForeground,
    );
  });
  const contrast = HyperContrastThemeData(mode: HyperContrastMode.adaptive);
  test('默认自适应，充足对比度保留彩色前景', () {
    const theme = HyperContrastThemeData();
    expect(theme.mode, HyperContrastMode.adaptive);
    const color = Color(0xFF0044AA);
    expect(
      theme.resolve(
        foreground: color,
        background: const HyperFill.color(Colors.white),
        canvasColor: Colors.white,
      ),
      color,
    );
    expect(theme.copyWith(minimumContrastRatio: 7).minimumContrastRatio, 7);
    expect(theme.copyWith(minimumContrastRatio: 7), isNot(theme));
  });
  test('半透明前景以合成后的对比度判断，不保留不可读的彩色', () {
    expect(
      contrast.resolve(
        foreground: const Color(0x110044AA),
        background: const HyperFill.color(Colors.white),
        canvasColor: Colors.white,
      ),
      contrast.darkForeground,
    );
  });

  test('自适应模式为浅色背景选择深色前景', () {
    final result = contrast.resolve(
      foreground: Colors.white,
      background: const HyperFill.color(Color(0xCCFFFFFF)),
      canvasColor: Colors.white,
    );
    expect(result, contrast.darkForeground);
  });

  test('自适应模式为深色背景选择浅色前景', () {
    final result = contrast.resolve(
      foreground: Colors.black,
      background: const HyperFill.color(Color(0xDD101114)),
      canvasColor: Colors.white,
    );
    expect(result, contrast.lightForeground);
  });

  test('渐变按色标估算且显式亮度提示优先', () {
    final gradientResult = contrast.resolve(
      foreground: Colors.white,
      background: const HyperFill.gradient(
        LinearGradient(colors: [Colors.white, Color(0xFFF0F0F0)]),
      ),
      canvasColor: Colors.black,
    );
    expect(gradientResult, contrast.darkForeground);

    final hinted = contrast.resolve(
      foreground: Colors.white,
      background: const HyperFill.color(Colors.white),
      canvasColor: Colors.white,
      backgroundLuminance: 0,
    );
    expect(hinted, contrast.lightForeground);
  });

  test('标准模式保留颜色，反色模式明确翻转', () {
    expect(
      contrast.resolve(
        foreground: Colors.red,
        background: const HyperFill.color(Colors.white),
        canvasColor: Colors.white,
        mode: HyperContrastMode.standard,
      ),
      Colors.red,
    );
    expect(
      contrast.resolve(
        foreground: Colors.white,
        background: const HyperFill.color(Colors.black),
        canvasColor: Colors.black,
        mode: HyperContrastMode.inverted,
      ),
      contrast.darkForeground,
    );
  });

  testWidgets('全局自适应反色作用于浅色玻璃按钮', (tester) async {
    Color? captured;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light().copyWith(
            contrastTheme: contrast,
            materialTheme: const HyperMaterialThemeData(
              quality: HyperMaterialQuality.advanced,
            ),
          ),
          duration: Duration.zero,
          child: Center(
            child: HyperButton.filled(
              onPressed: () {},
              style: HyperButtonStyle(
                material: const HyperSurfaceMaterial.frostedGlass(
                  background: HyperFill.color(Color(0xCCFFFFFF)),
                ),
              ),
              child: Builder(
                builder: (context) {
                  captured = DefaultTextStyle.of(context).style.color;
                  return const Text('浅色玻璃');
                },
              ),
            ),
          ),
        ),
      ),
    );
    expect(captured, contrast.darkForeground);
  });
  testWidgets('不同玻璃材质保留按钮及图标按钮可读的彩色前景', (tester) async {
    const color = Color(0xFF0044AA);
    for (final material in [
      const HyperSurfaceMaterial.frostedGlass(
        background: HyperFill.color(Colors.white),
      ),
      const HyperSurfaceMaterial.softLightGlass(
        background: HyperFill.color(Colors.white),
      ),
    ]) {
      final captured = <Color?>[];
      Widget icon() => Builder(
        builder: (context) {
          captured.add(IconTheme.of(context).color);
          return const Icon(Icons.star);
        },
      );
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HyperButton.ghost(
                    onPressed: () {},
                    style: HyperButtonStyle(
                      foregroundColor: color,
                      material: material,
                    ),
                    child: icon(),
                  ),
                  HyperIconButton.ghost(
                    onPressed: () {},
                    style: HyperIconButtonStyle(
                      foregroundColor: color,
                      material: material,
                    ),
                    icon: icon(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(captured, isNotEmpty);
      expect(captured, everyElement(color));
    }
  });
}
