import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/main.dart';

void main() {
  testWidgets('宽屏显示菜单和 HyperFill 演示页', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const LemonUiExampleApp());

    final context = tester.element(find.byType(Scaffold));
    final hyper = HyperTheme.of(context);
    final material = Theme.of(context);
    expect(material.scaffoldBackgroundColor, hyper.colors.background);
    expect(material.colorScheme.primary, hyper.colors.primary);
    expect(material.appBarTheme.backgroundColor, hyper.colors.background);
    final deviceType = HyperDeviceDetector.of(context);
    expect(hyper.sizes, HyperSizeScheme.forDevice(deviceType));

    expect(find.text('Lemon UI 组件演示'), findsOneWidget);
    expect(find.text('基础能力'), findsOneWidget);
    expect(find.text('HyperFill'), findsWidgets);
    expect(find.text('HyperFill 是首个实现的基础视觉类型。'), findsOneWidget);
    expect(find.text('无填充'), findsOneWidget);
    expect(find.text('纯色'), findsOneWidget);
    expect(find.text('线性渐变'), findsOneWidget);
  });

  testWidgets('可以切换颜色方案的种子色和亮暗模式', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1000, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.tap(find.text('HyperColorScheme').first);
    await tester.pumpAndSettle();

    expect(find.text('语义颜色'), findsOneWidget);
    expect(find.text('primary'), findsOneWidget);
    expect(find.text('小米橙'), findsOneWidget);

    await tester.tap(find.text('暗色'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(ChoiceChip, '蓝色'));
    await tester.pumpAndSettle();

    final segmented = tester.widget<SegmentedButton<Brightness>>(
      find.byType(SegmentedButton<Brightness>),
    );
    expect(segmented.selected, {Brightness.dark});
    expect(
      tester.widget<ChoiceChip>(find.widgetWithText(ChoiceChip, '蓝色')).selected,
      isTrue,
    );
  });
  testWidgets('窄屏通过 Drawer 打开组件菜单', (tester) async {
    await tester.binding.setSurfaceSize(const Size(480, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.tap(find.byTooltip('打开组件菜单'));
    await tester.pumpAndSettle();

    expect(find.byType(Drawer), findsOneWidget);
    expect(find.text('Lemon UI 组件演示'), findsOneWidget);
    expect(find.text('基础能力'), findsOneWidget);
  });
}
