import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  const contrast = HyperContrastThemeData(mode: HyperContrastMode.adaptive);

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
}
