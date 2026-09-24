import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  Widget app(Widget child, {HyperThemeData? theme}) => MaterialApp(
    home: HyperTheme(
      data: theme ?? HyperThemeData.light(),
      duration: Duration.zero,
      child: Scaffold(body: Center(child: child)),
    ),
  );

  testWidgets('菜单显示分组、选择状态并跳过禁用操作', (tester) async {
    final selections = <String>[];
    await tester.pumpWidget(
      app(
        HyperMenu(
          selectedId: 'open',
          onSelected: selections.add,
          groups: const [
            HyperMenuGroup(
              title: '文件',
              items: [
                HyperMenuItem(id: 'open', label: '打开'),
                HyperMenuItem(id: 'disabled', label: '删除', enabled: false),
              ],
            ),
            HyperMenuGroup(
              title: '视图',
              items: [HyperMenuItem(id: 'details', label: '详细信息')],
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('文件'), findsOneWidget);
    expect(find.text('视图'), findsOneWidget);
    expect(find.byKey(const ValueKey('hyper-menu-item-open')), findsOneWidget);
    await tester.tap(find.text('删除'));
    expect(selections, isEmpty);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(selections, ['details']);
  });

  testWidgets('桌面菜单读取尺寸主题，局部主题只覆盖显式字段', (tester) async {
    const sizes = HyperSizeThemeData(tablet: HyperSizeScheme.desktop());
    final theme = HyperThemeData.light(sizes: sizes).copyWith(
      menuTheme: const HyperMenuThemeData(
        style: HyperMenuStyle(width: 220, surfaceRadius: 10),
      ),
    );
    await tester.pumpWidget(
      app(
        HyperMenuTheme(
          data: const HyperMenuThemeData(style: HyperMenuStyle(itemHeight: 40)),
          child: const HyperMenu(
            selectedId: 'open',
            style: HyperMenuStyle(selectedBackgroundColor: Colors.orange),
            items: [HyperMenuItem(id: 'open', label: '打开')],
          ),
        ),
        theme: theme,
      ),
    );

    expect(tester.getSize(find.byType(HyperCard)).width, 220);
    expect(
      tester.widget<HyperCard>(find.byType(HyperCard)).style?.borderRadius,
      BorderRadius.circular(10),
    );
    expect(
      tester.getSize(find.byKey(const ValueKey('hyper-menu-item-open'))).height,
      40,
    );
    expect(theme.sizes.tablet.menu.itemHeight, 32);
    final itemVisual = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey('hyper-menu-item-open')),
    );
    expect((itemVisual.decoration! as BoxDecoration).color, Colors.orange);
  });

  testWidgets('菜单可放入默认点击触发的锚定浮层', (tester) async {
    await tester.pumpWidget(
      app(
        HyperAnchoredOverlay(
          anchor: const Text('操作'),
          overlayBuilder: (context, close) => HyperMenu(
            onSelected: (_) => close(),
            items: const [HyperMenuItem(id: 'open', label: '打开文件')],
          ),
        ),
      ),
    );

    await tester.tap(find.text('操作'));
    await tester.pumpAndSettle();
    expect(find.text('打开文件'), findsOneWidget);
    await tester.tap(find.text('打开文件'));
    await tester.pumpAndSettle();
    expect(find.text('打开文件'), findsNothing);
  });

  testWidgets('多级菜单通过方向键进入、返回，并仅选择叶子项', (tester) async {
    final selections = <String>[];
    await tester.pumpWidget(
      app(
        HyperMenu(
          onSelected: selections.add,
          groups: const [
            HyperMenuGroup(
              title: '文件',
              items: [
                HyperMenuItem(
                  id: 'open',
                  label: '打开',
                  children: [
                    HyperMenuItem(
                      id: 'recent',
                      label: '最近使用',
                      children: [HyperMenuItem(id: 'file', label: '示例文件')],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.text('最近使用'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.text('示例文件'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pumpAndSettle();
    expect(selections, ['file']);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(find.text('示例文件'), findsNothing);
  });

  testWidgets('方向键与 Tab 将实际焦点移到对应菜单项', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperMenu(
          items: [
            HyperMenuItem(
              id: 'parent',
              label: '父项',
              children: [
                HyperMenuItem(id: 'child', label: '子项'),
                HyperMenuItem(id: 'child_two', label: '另一子项'),
              ],
            ),
            HyperMenuItem(id: 'sibling', label: '同级项'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    FocusNode itemFocus(String label) => tester
        .widget<HyperPressable>(
          find.ancestor(
            of: find.text(label),
            matching: find.byType(HyperPressable),
          ),
        )
        .focusNode!;

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(itemFocus('父项').hasPrimaryFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(itemFocus('子项').hasPrimaryFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pumpAndSettle();
    expect(itemFocus('另一子项').hasPrimaryFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(itemFocus('父项').hasPrimaryFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(itemFocus('父项').hasPrimaryFocus, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(itemFocus('同级项').hasPrimaryFocus, isTrue);
  });

  testWidgets('嵌套浮层点击叶子项不会先关闭根浮层', (tester) async {
    final selections = <String>[];
    await tester.pumpWidget(
      app(
        HyperAnchoredOverlay(
          anchor: const Text('操作'),
          overlayBuilder: (context, close) => HyperMenu(
            onSelected: (id) {
              selections.add(id);
              close();
            },
            items: const [
              HyperMenuItem(
                id: 'parent',
                label: '更多',
                children: [HyperMenuItem(id: 'child', label: '子操作')],
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('操作'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    await tester.tap(find.text('子操作'));
    await tester.pumpAndSettle();
    expect(selections, ['child']);
    expect(find.text('更多'), findsNothing);
  });

  testWidgets('鼠标悬停父项展开子菜单', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperMenu(
          items: [
            HyperMenuItem(
              id: 'parent',
              label: '更多',
              children: [HyperMenuItem(id: 'child', label: '子操作')],
            ),
          ],
        ),
      ),
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('更多')));
    await tester.pumpAndSettle();
    expect(find.text('子操作'), findsOneWidget);
    await mouse.removePointer();
  });

  testWidgets('鼠标已打开子菜单后，右方向键仍能把焦点交给子菜单', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperMenu(
          items: [
            HyperMenuItem(
              id: 'parent',
              label: '父项',
              children: [HyperMenuItem(id: 'child', label: '子项')],
            ),
          ],
        ),
      ),
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('父项')));
    await tester.pumpAndSettle();
    expect(find.text('子项'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    final child = tester.widget<HyperPressable>(
      find.ancestor(of: find.text('子项'), matching: find.byType(HyperPressable)),
    );
    expect(child.focusNode!.hasPrimaryFocus, isTrue);
    await mouse.removePointer();
  });

  testWidgets('鼠标进入第三级后各级保持打开，点击空白关闭', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      app(
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: const EdgeInsets.all(80),
            child: HyperAnchoredOverlay(
              anchor: const Text('操作'),
              overlayBuilder: (context, close) => const HyperMenu(
                items: [
                  HyperMenuItem(
                    id: 'first',
                    label: '一级',
                    children: [
                      HyperMenuItem(
                        id: 'second',
                        label: '二级',
                        children: [HyperMenuItem(id: 'third', label: '三级')],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('操作'));
    await tester.pumpAndSettle();
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('一级')));
    await tester.pumpAndSettle();
    await mouse.moveTo(tester.getCenter(find.text('二级')));
    await tester.pumpAndSettle();
    await mouse.moveTo(tester.getCenter(find.text('三级')));
    await tester.pump(const Duration(seconds: 1));
    expect(find.text('一级'), findsOneWidget);
    expect(find.text('二级'), findsOneWidget);
    expect(find.text('三级'), findsOneWidget);
    await tester.tapAt(const Offset(1100, 700));
    await tester.pumpAndSettle();
    expect(find.text('三级'), findsNothing);
    await mouse.removePointer();
  });

  test('四端菜单尺寸与主题副本独立解析', () {
    const sizes = HyperSizeThemeData();
    expect(sizes.desktop.menu.width, 192);
    expect(sizes.desktop.menu.itemHeight, 32);
    expect(sizes.desktop.menu.groupSpacing, 8);
    expect(sizes.desktop.menu.itemRadius, 6);
    expect(sizes.desktop.menu.surfaceRadius, 8);
    expect(sizes.phone.menu.itemHeight, 48);
    final changed = sizes.copyWith(
      desktop: sizes.desktop.copyWith(
        menu: sizes.desktop.menu.copyWith(itemHeight: 36, surfaceRadius: 12),
      ),
    );
    expect(changed.desktop.menu.itemHeight, 36);
    expect(changed.desktop.menu.surfaceRadius, 12);
    expect(changed.phone.menu, sizes.phone.menu);
    expect(
      HyperMenuSize.lerp(
        sizes.desktop.menu,
        changed.desktop.menu,
        .5,
      ).itemHeight,
      34,
    );
    expect(
      HyperMenuSize.lerp(
        sizes.desktop.menu,
        changed.desktop.menu,
        .5,
      ).surfaceRadius,
      10,
    );
  });
}
