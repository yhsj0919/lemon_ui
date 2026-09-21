import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  Widget app(Widget child) => MaterialApp(
    home: HyperTheme(
      data: HyperThemeData.light(sizes: const HyperSizeScheme.desktop()),
      duration: Duration.zero,
      child: Center(child: child),
    ),
  );

  testWidgets('三态按未选中、选中、半选中顺序循环', (tester) async {
    bool? value = false;
    await tester.pumpWidget(
      app(
        StatefulBuilder(
          builder: (context, setState) => HyperCheckbox(
            value: value,
            tristate: true,
            onChanged: (next) => setState(() => value = next),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(HyperCheckbox));
    await tester.pump();
    expect(value, isTrue);
    await tester.tap(find.byType(HyperCheckbox));
    await tester.pump();
    expect(value, isNull);
    await tester.tap(find.byType(HyperCheckbox));
    await tester.pump();
    expect(value, isFalse);
  });

  testWidgets('半选中使用自绘标记且桌面视觉尺寸为22', (tester) async {
    await tester.pumpWidget(
      app(const HyperCheckbox(value: null, tristate: true, onChanged: null)),
    );
    expect(find.byType(CustomPaint), findsWidgets);
    expect(
      tester.getSize(find.byType(AnimatedContainer)),
      const Size.square(22),
    );
  });

  testWidgets('实例可以明确覆盖圆角', (tester) async {
    const radius = BorderRadius.all(Radius.circular(4));
    await tester.pumpWidget(
      app(
        HyperCheckbox(
          value: true,
          onChanged: (_) {},
          style: HyperCheckboxStyle(borderRadius: radius),
        ),
      ),
    );
    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    expect((container.decoration! as BoxDecoration).borderRadius, radius);
  });

  testWidgets('rounded在桌面使用4像素圆角', (tester) async {
    await tester.pumpWidget(
      app(const HyperCheckbox.rounded(value: true, onChanged: null)),
    );

    final visual = find.byKey(const ValueKey('hyper_checkbox_visual'));
    final container = tester.widget<AnimatedContainer>(visual);
    expect(tester.getSize(visual), const Size.square(22));
    expect(
      (container.decoration! as BoxDecoration).borderRadius,
      BorderRadius.circular(4),
    );
  });

  testWidgets('变体主题只覆盖rounded', (tester) async {
    const roundedRadius = BorderRadius.all(Radius.circular(2));
    await tester.pumpWidget(
      app(
        HyperCheckboxTheme(
          data: HyperCheckboxThemeData(
            rounded: HyperCheckboxStyle(borderRadius: roundedRadius),
          ),
          child: const HyperCheckbox.rounded(value: true, onChanged: null),
        ),
      ),
    );

    final container = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey('hyper_checkbox_visual')),
    );
    expect(
      (container.decoration! as BoxDecoration).borderRadius,
      roundedRadius,
    );
  });

  testWidgets('状态变化播放路径动画', (tester) async {
    bool? value = false;
    await tester.pumpWidget(
      app(
        StatefulBuilder(
          builder: (context, setState) => HyperCheckbox(
            value: value,
            onChanged: (next) => setState(() => value = next),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(HyperCheckbox));
    await tester.pump();
    expect(tester.hasRunningAnimations, isTrue);
    await tester.pumpAndSettle();
    expect(tester.hasRunningAnimations, isFalse);
  });
}
