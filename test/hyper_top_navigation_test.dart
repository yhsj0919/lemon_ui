import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  Widget app(
    Widget child, {
    HyperThemeData? theme,
    HyperDeviceType device = HyperDeviceType.desktop,
  }) => MaterialApp(
    home: HyperDeviceDetector(
      deviceType: device,
      builder: (context, type, _) => HyperTheme(
        data: theme ?? HyperThemeData.light(),
        duration: Duration.zero,
        child: Scaffold(body: child),
      ),
    ),
  );
  const items = [
    HyperMenuItem(id: 'home', label: '概览'),
    HyperMenuItem(
      id: 'file',
      label: '文件',
      children: [
        HyperMenuItem(id: 'new', label: '新建', description: '打开独立窗口'),
        HyperMenuItem(
          id: 'settings',
          label: '设置',
          children: [
            HyperMenuItem(
              id: 'appearance',
              label: '外观',
              children: [
                HyperMenuItem(id: 'dark', label: '暗色', description: '夜间显示'),
              ],
            ),
          ],
        ),
        HyperMenuItem(id: 'disabled', label: '不可用', enabled: false),
      ],
    ),
  ];
  for (final device in HyperDeviceType.values) {
    testWidgets('$device 顶层标题和描述随文字缩放增高', (tester) async {
      await tester.pumpWidget(
        app(
          const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: HyperTopNavigation(
              items: [
                HyperMenuItem(
                  id: 'overview',
                  label: '概览',
                  description: '当前组件预览',
                ),
              ],
            ),
          ),
          device: device,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final button = tester.widget<HyperButton>(find.byType(HyperButton));
      expect(
        tester.getSize(find.byType(HyperButton)).height,
        greaterThan(button.style!.minimumSize!.height),
      );
    });
  }
  testWidgets('多级菜单、描述和禁用项复用 Menu，选择后关闭', (tester) async {
    String? selected;
    await tester.pumpWidget(
      app(HyperTopNavigation(items: items, onSelected: (id) => selected = id)),
    );
    await tester.tap(find.text('文件'));
    await tester.pumpAndSettle();
    expect(find.text('打开独立窗口'), findsOneWidget);
    await tester.tap(find.text('不可用'));
    expect(selected, isNull);
    await tester.tap(find.text('设置'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('外观'));
    await tester.pumpAndSettle();
    expect(find.text('夜间显示'), findsOneWidget);
    await tester.tap(find.text('暗色'));
    await tester.pumpAndSettle();
    expect(selected, 'dark');
    expect(find.text('暗色'), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('全局、嵌套局部和实例逐字段覆盖，选中后代标记顶层', (tester) async {
    final theme = HyperThemeData.light().copyWith(
      topNavigationTheme: HyperTopNavigationThemeData(
        style: HyperTopNavigationStyle(
          itemStyle: HyperButtonStyle(foregroundColor: Colors.orange),
          descriptionStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
    await tester.pumpWidget(
      app(
        HyperTopNavigationTheme(
          data: const HyperTopNavigationThemeData(
            style: HyperTopNavigationStyle(itemSpacing: 17),
          ),
          child: HyperTopNavigationTheme(
            data: const HyperTopNavigationThemeData(
              style: HyperTopNavigationStyle(
                descriptionStyle: TextStyle(color: Colors.purple),
              ),
            ),
            child: HyperTopNavigation(
              items: items,
              selectedId: 'dark',
              onSelected: (_) {},
              style: HyperTopNavigationStyle(
                selectedItemStyle: HyperButtonStyle(
                  foregroundColor: Colors.red,
                ),
              ),
            ),
          ),
        ),
        theme: theme,
      ),
    );
    final button = tester.widget<HyperButton>(
      find.byKey(const ValueKey('hyper-top-navigation-file')),
    );
    expect(button.style!.foregroundColor, Colors.red);
    final local = HyperTopNavigationTheme.of(
      tester.element(find.byType(HyperTopNavigation)),
    );
    expect(local.style!.itemSpacing, 17);
    expect(local.style!.itemStyle!.foregroundColor, Colors.orange);
    expect(local.style!.descriptionStyle!.fontWeight, FontWeight.bold);
    expect(local.style!.descriptionStyle!.color, Colors.purple);
    expect(tester.takeException(), isNull);
  });
  for (final device in HyperDeviceType.values) {
    testWidgets('$device 尺寸来自独立主题且支持文字放大及 RTL', (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 300));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final base = HyperThemeData.light();
      final scheme = base.sizes.resolve(device);
      final changed = scheme.copyWith(
        topNavigation: scheme.topNavigation.copyWith(
          height: 70,
          itemSpacing: 12,
        ),
      );
      final sizes = switch (device) {
        HyperDeviceType.phone => base.sizes.copyWith(phone: changed),
        HyperDeviceType.tablet => base.sizes.copyWith(tablet: changed),
        HyperDeviceType.desktop => base.sizes.copyWith(desktop: changed),
        HyperDeviceType.watch => base.sizes.copyWith(watch: changed),
      };
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) => MediaQuery(
              data: MediaQuery.of(context)
                  .copyWith(textScaler: TextScaler.linear(2)),
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: HyperTopNavigation(items: items, onSelected: (_) {}),
              ),
            ),
          ),
          theme: base.copyWith(sizes: sizes),
          device: device,
        ),
      );
      final button = tester.widget<HyperButton>(
        find.byKey(const ValueKey('hyper-top-navigation-home')),
      );
      expect(button.style!.minimumSize!.height, 70);
      expect(tester.takeException(), isNull);
    });
  }
  test('新主题和尺寸参与复制、相等及插值', () {
    final base = HyperThemeData.light();
    const style = HyperTopNavigationStyle(
      itemSpacing: 20,
      descriptionGap: 8,
      descriptionStyle: TextStyle(fontSize: 12),
    );
    final modified = base.copyWith(
      topNavigationTheme: const HyperTopNavigationThemeData(style: style),
      sizes: base.sizes.copyWith(
        desktop: base.sizes.desktop.copyWith(
          topNavigation: base.sizes.desktop.topNavigation.copyWith(height: 72),
        ),
      ),
    );
    expect(modified.copyWith(), modified);
    expect(base.lerp(modified, .5).sizes.desktop.topNavigation.height, 52);
    expect(
      HyperTopNavigationStyle.lerp(
        style,
        style.copyWith(itemSpacing: 40),
        .5,
      ).itemSpacing,
      30,
    );
    expect(
      HyperMenuStyle.lerp(
        const HyperMenuStyle(descriptionGap: 2),
        const HyperMenuStyle(descriptionGap: 6),
        .5,
      ).descriptionGap,
      4,
    );
  });
}
