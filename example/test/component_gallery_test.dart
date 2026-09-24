import 'package:flutter/foundation.dart'
    show debugDefaultTargetPlatformOverride;
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/main.dart';

void main() {
  testWidgets('宽屏显示菜单和 HyperFill 演示页', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    addTearDown(() => debugDefaultTargetPlatformOverride = null);
    await tester.binding.setSurfaceSize(const Size(1000, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const LemonUiExampleApp());

    final context = tester.element(find.byType(HyperScaffold));
    expect(find.byType(Scaffold), findsOneWidget);
    final hyper = HyperTheme.of(context);
    final material = Theme.of(context);
    expect(material.scaffoldBackgroundColor, hyper.colors.background);
    expect(material.colorScheme.primary, hyper.colors.primary);
    expect(material.appBarTheme.backgroundColor, hyper.colors.background);
    final deviceType = HyperDeviceDetector.of(context);
    expect(HyperTheme.sizesOf(context), hyper.sizes.resolve(deviceType));

    expect(find.text('Lemon UI 组件演示'), findsOneWidget);
    expect(find.text('基础能力'), findsOneWidget);
    expect(find.text('页面框架'), findsOneWidget);
    expect(find.byType(HyperSidebar), findsOneWidget);
    expect(
      find.byKey(const ValueKey('hyper-sidebar-item-hyper-fill')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('hyper-sidebar-item-hyper-app-bar')),
      findsNothing,
    );
    expect(find.byType(ListTile), findsNothing);
    expect(find.text('HyperFill'), findsWidgets);
    expect(find.text('纯色、渐变和显式无填充。'), findsOneWidget);
    expect(find.text('HyperFill 是首个实现的基础视觉类型。'), findsOneWidget);
    expect(find.text('无填充'), findsOneWidget);
    expect(find.text('纯色'), findsOneWidget);
    expect(find.text('线性渐变'), findsOneWidget);

    final sidebar = tester.getRect(find.byType(HyperSidebar));
    final pageBar = tester.getRect(find.byType(HyperAppBar));
    expect(sidebar.left, 0);
    expect(HyperTheme.sizesOf(context).sidebar.width, 180);
    expect(sidebar.width, HyperTheme.sizesOf(context).drawer.width);
    expect(pageBar.left, sidebar.right);
    expect(tester.getTopLeft(find.text('填充')).dx, sidebar.right + 16);

    await tester.ensureVisible(find.text('页面框架'));
    await tester.tap(find.text('页面框架'));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('hyper-sidebar-item-hyper-fill')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('hyper-sidebar-item-hyper-app-bar')),
      findsOneWidget,
    );
    await tester.tap(find.text('HyperAppBar').first);
    await tester.pumpAndSettle();
    expect(find.byType(HyperSidebar), findsOneWidget);
    expect(find.text('展开顶栏'), findsWidgets);
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

    expect(find.byType(HyperDrawer), findsOneWidget);
    expect(find.byType(Drawer), findsOneWidget);
    expect(find.text('Lemon UI 组件演示'), findsOneWidget);
    expect(find.text('基础能力'), findsOneWidget);
    expect(find.byType(HyperSidebar), findsOneWidget);
    await tester.tap(find.text('HyperContainerThemeData'));
    await tester.pumpAndSettle();
    expect(find.text('容器主题：逐项覆盖与清除'), findsOneWidget);
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold).first).isDrawerOpen,
      isFalse,
    );
  });
}
