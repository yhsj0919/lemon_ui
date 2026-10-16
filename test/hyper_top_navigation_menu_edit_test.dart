import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

const items = [
  HyperMenuItem(
    id: 'file',
    label: '文件',
    children: [
      HyperMenuItem(id: 'new', label: '新建窗口', description: '打开一个独立工作区'),
      HyperMenuItem(id: 'settings', label: '偏好设置'),
    ],
  ),
];

void main() {
  test('菜单垂直内边距参与样式和四端尺寸的复制、插值与相等', () {
    const a = HyperMenuStyle(itemVerticalPadding: 4);
    const b = HyperMenuStyle(itemVerticalPadding: 10);
    expect(a.copyWith(itemVerticalPadding: 10), b);
    expect(a.merge(b), b);
    expect(HyperMenuStyle.lerp(a, b, .5).itemVerticalPadding, 7);
    expect(a.hashCode, const HyperMenuStyle(itemVerticalPadding: 4).hashCode);
    const sizes = HyperSizeThemeData();
    for (final device in HyperDeviceType.values) {
      final menu = sizes.resolve(device).menu;
      expect(menu.itemVerticalPadding, menu.padding / 2);
      final changed = menu.copyWith(itemVerticalPadding: 12);
      expect(changed, isNot(menu));
      expect(changed.copyWith(), changed);
      expect(
        HyperMenuSize.lerp(menu, changed, .5).itemVerticalPadding,
        (menu.itemVerticalPadding! + 12) / 2,
      );
    }
  });
  testWidgets('菜单描述增高后仍保留上下内边距，跟随系统文字缩放', (tester) async {
    for (final scale in [1.0, 1.3, 2.0]) {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperDeviceDetector(
            deviceType: HyperDeviceType.desktop,
            builder: (context, device, child) => HyperTheme(
              data: HyperThemeData.light(),
              child: MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                child: const Scaffold(
                  body: Align(
                    alignment: Alignment.topLeft,
                    child: HyperTopNavigation(items: items),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('文件'));
      await tester.pumpAndSettle();
      final item = tester.getRect(
        find.byKey(const ValueKey('hyper-menu-item-new')),
      );
      final title = tester.getRect(find.text('新建窗口'));
      final description = tester.getRect(find.text('打开一个独立工作区'));
      expect(title.top - item.top, greaterThanOrEqualTo(4));
      expect(item.bottom - description.bottom, greaterThanOrEqualTo(4));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    }
  });

  testWidgets('已打开的顶部导航面板实时接收尺寸、文字与表面覆盖', (tester) async {
    final notifier = ValueNotifier<HyperMenuStyle>(const HyperMenuStyle());
    await tester.pumpWidget(
      MaterialApp(
        home: ValueListenableBuilder<HyperMenuStyle>(
          valueListenable: notifier,
          builder: (context, menu, child) => HyperTheme(
            data: HyperThemeData.light().copyWith(
              topNavigationTheme: HyperTopNavigationThemeData(
                style: HyperTopNavigationStyle(menuStyle: menu),
              ),
            ),
            duration: Duration.zero,
            child: const Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: HyperTopNavigation(items: items),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('文件'));
    await tester.pumpAndSettle();
    notifier.value = HyperMenuStyle(
      width: 300,
      itemHeight: 60,
      padding: 20,
      surfacePadding: 12,
      itemVerticalPadding: 10,
      itemRadius: 8,
      descriptionGap: 7,
      itemTextStyle: const TextStyle(fontSize: 18),
      descriptionStyle: const TextStyle(fontSize: 14, color: Colors.purple),
      surfaceStyle: HyperCardStyle(
        background: const HyperFill.color(Colors.yellow),
        boxShadow: const [],
        border: Border.all(color: Colors.red, width: 2),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HyperMenu), findsOneWidget);
    final row = tester.getRect(
      find.byKey(const ValueKey('hyper-menu-item-new')),
    );
    final title = tester.getRect(find.text('新建窗口'));
    final description = tester.getRect(find.text('打开一个独立工作区'));
    expect(row.width, 276);
    expect(row.height, greaterThanOrEqualTo(60));
    expect(title.left - row.left, 20);
    expect(title.top - row.top, greaterThanOrEqualTo(10));
    expect(description.top - title.bottom, 7);
    expect(
      tester.widget<Text>(find.text('打开一个独立工作区')).style?.color,
      Colors.purple,
    );
    final card = tester.widget<HyperCard>(
      find
          .descendant(
            of: find.byType(HyperMenu),
            matching: find.byType(HyperCard),
          )
          .first,
    );
    expect(card.style?.background?.color, Colors.yellow);
    expect(card.style?.boxShadow, isEmpty);
    expect(card.style?.border, Border.all(color: Colors.red, width: 2));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    notifier.dispose();
  });
}
