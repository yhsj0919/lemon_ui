import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget app(Widget child) => MaterialApp(
  home: HyperTheme(
    data: HyperThemeData.light(),
    duration: Duration.zero,
    child: Scaffold(body: child),
  ),
);

void main() {
  test('侧栏图标与首部绘制尺寸支持完整强类型覆盖契约', () {
    const style = HyperSidebarStyle(
      iconSize: 28,
      expandIconSize: 10,
      iconColor: Colors.red,
      selectedIconColor: Colors.orange,
      ancestorSelectedIconColor: Colors.blue,
      disabledIconColor: Colors.grey,
      expandIconColor: Colors.green,
      selectedExpandIconColor: Colors.yellow,
      ancestorSelectedExpandIconColor: Colors.purple,
      disabledExpandIconColor: Colors.black,
    );
    expect(style.copyWith(), style);
    expect(const HyperSidebarStyle().merge(style), style);
    expect(HyperSidebarStyle.lerp(style, style, .5), style);
    expect(style.copyWith().hashCode, style.hashCode);
    final size = const HyperSizeThemeData().desktop.sidebar;
    expect(
      HyperSidebarSize.lerp(
        size.copyWith(expandIconSize: 10),
        size.copyWith(expandIconSize: 20),
        .5,
      ).expandIconSize,
      15,
    );
    const list = HyperListTileStyle(
      leadingColor: Colors.red,
      leadingIconSize: 28,
    );
    expect(list.copyWith(), list);
    expect(const HyperListTileStyle().merge(list), list);
    expect(HyperListTileStyle.lerp(list, list, .5), list);
    final tile = const HyperSizeThemeData().desktop.listTile;
    expect(
      HyperListTileSize.lerp(
        tile.copyWith(leadingIconSize: 20),
        tile.copyWith(leadingIconSize: 30),
        .5,
      ).leadingIconSize,
      25,
    );
    expect(
      tile.copyWith(leadingIconSize: 20).copyWith(),
      tile.copyWith(leadingIconSize: 20),
    );
  });

  testWidgets('Icon 与 HyperIcon 的绘制尺寸和颜色均接收列表首部配置', (tester) async {
    for (final icon in [const Icon(Icons.star), const HyperIcon(Icons.star)]) {
      await tester.pumpWidget(
        app(
          Center(
            child: SizedBox(
              width: 320,
              child: HyperListTile(
                leading: icon,
                title: const Text('标题'),
                style: const HyperListTileStyle(
                  leadingSize: 32,
                  leadingIconSize: 30,
                  leadingColor: Colors.purple,
                ),
              ),
            ),
          ),
        ),
      );
      final painted = tester.widget<Icon>(find.byIcon(Icons.star));
      final inherited = IconTheme.of(tester.element(find.byIcon(Icons.star)));
      expect(painted.size ?? inherited.size, 30);
      expect(painted.color ?? inherited.color, Colors.purple);
      expect(tester.getSize(find.byIcon(Icons.star)), const Size(30, 30));
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('侧栏前置图标和展开箭头独立配置，并支持选中祖先及禁用颜色', (tester) async {
    for (final selected in ['parent', 'child', null]) {
      await tester.pumpWidget(
        app(
          HyperSidebar(
            selectedId: selected,
            selectParentWhenChildSelected: true,
            expandedIds: const {'parent'},
            items: const [
              HyperSidebarItem(
                id: 'parent',
                label: '父级',
                icon: HyperIcon(Icons.folder),
                children: [
                  HyperSidebarItem(
                    id: 'child',
                    label: '子项',
                    icon: Icon(Icons.star),
                  ),
                ],
              ),
              HyperSidebarItem(
                id: 'disabled',
                label: '禁用',
                enabled: false,
                icon: HyperIcon(Icons.lock),
              ),
            ],
            style: const HyperSidebarStyle(
              iconSize: 28,
              expandIconSize: 10,
              iconColor: Colors.red,
              selectedIconColor: Colors.orange,
              ancestorSelectedIconColor: Colors.blue,
              disabledIconColor: Colors.grey,
              expandIconColor: Colors.green,
              selectedExpandIconColor: Colors.yellow,
              ancestorSelectedExpandIconColor: Colors.purple,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final leading = tester.widget<Icon>(find.byIcon(Icons.folder));
      final arrow = tester.widget<Icon>(find.byIcon(Icons.chevron_right).first);
      expect(leading.size, 28);
      expect(arrow.size, 10);
      expect(
        leading.color,
        selected == 'parent'
            ? Colors.orange
            : selected == 'child'
            ? Colors.blue
            : Colors.red,
      );
      expect(
        arrow.color,
        selected == 'parent'
            ? Colors.yellow
            : selected == 'child'
            ? Colors.purple
            : Colors.green,
      );
      expect(tester.widget<Icon>(find.byIcon(Icons.lock)).color, Colors.grey);
      expect(tester.takeException(), isNull);
    }
    await tester.pumpWidget(
      app(
        const HyperSidebar(
          collapsed: true,
          items: [
            HyperSidebarItem(
              id: 'home',
              label: '首页',
              icon: HyperIcon(Icons.home),
            ),
          ],
          style: HyperSidebarStyle(
            iconSize: 16,
            collapsedIconSize: 28,
            iconColor: Colors.red,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.widget<Icon>(find.byIcon(Icons.home)).size, 28);
    expect(tester.widget<Icon>(find.byIcon(Icons.home)).color, Colors.red);
    await tester.pumpWidget(
      app(
        const HyperSidebar(
          items: [
            HyperSidebarItem(
              id: 'parent',
              label: '父级',
              icon: HyperIcon(Icons.folder),
              children: [HyperSidebarItem(id: 'child', label: '子项')],
            ),
          ],
          style: HyperSidebarStyle(iconSize: 0, expandIconSize: 0),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.folder), findsNothing);
    expect(find.byIcon(Icons.chevron_right), findsNothing);
    expect(find.text('父级'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('独立图标尺寸在窄侧栏与系统文字缩放下不溢出', (tester) async {
    for (final scale in [1.0, 1.3, 2.0]) {
      await tester.pumpWidget(
        app(
          MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: HyperSidebar(
                items: [
                  HyperSidebarItem(
                    id: 'parent',
                    label: '较长的资源库名称',
                    icon: HyperIcon(Icons.folder),
                    children: [HyperSidebarItem(id: 'child', label: '子项')],
                  ),
                ],
                style: HyperSidebarStyle(
                  width: 180,
                  iconSize: 28,
                  expandIconSize: 10,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.getSize(find.byIcon(Icons.folder)), const Size(28, 28));
      expect(
        tester.getSize(find.byIcon(Icons.chevron_right)),
        const Size(10, 10),
      );
      expect(tester.takeException(), isNull);
    }
  });
}
