import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget app(Widget child, {HyperThemeData? data}) => MaterialApp(
  home: HyperTheme(
    data: data ?? HyperThemeData.light(),
    duration: Duration.zero,
    child: Scaffold(body: child),
  ),
);

const menu = [
  HyperSidebarItem(
    id: 'library',
    label: '资源库',
    icon: Icon(Icons.folder_outlined),
    children: [
      HyperSidebarItem(
        id: 'saved',
        label: '收藏',
        icon: Icon(Icons.star_border),
        badge: Text('3'),
      ),
    ],
  ),
  HyperSidebarItem(
    id: 'disabled',
    label: '已禁用',
    icon: Icon(Icons.lock_outline),
    enabled: false,
  ),
];

Widget themeWidthTransition(BuildContext context, double width, Widget child) =>
    SizedBox(
      key: const Key('theme-width-transition'),
      width: width,
      child: child,
    );

Widget localContentTransition(
  BuildContext context,
  double visibility,
  Widget child,
) => Opacity(
  key: const Key('local-content-transition'),
  opacity: visibility,
  child: child,
);

Widget instanceChildrenTransition(
  BuildContext context,
  Animation<double> animation,
  Widget child,
) => SizeTransition(
  key: const Key('instance-children-transition'),
  sizeFactor: animation,
  child: child,
);

Widget themeChildrenTransition(
  BuildContext context,
  Animation<double> animation,
  Widget child,
) => SizeTransition(
  key: const Key('theme-children-transition'),
  sizeFactor: animation,
  child: child,
);

Widget customPopupTransition(
  BuildContext context,
  Animation<double> animation,
  Widget child,
) => FadeTransition(opacity: animation, child: child);

void main() {
  test('四端侧栏尺寸和强类型覆盖', () {
    const sizes = HyperSizeThemeData();
    expect(sizes.phone.sidebar.width, 280);
    expect(sizes.tablet.sidebar.width, 280);
    expect(sizes.desktop.sidebar.width, 180);
    expect(sizes.watch.sidebar.width, 200);
    final changed = sizes.copyWith(
      desktop: sizes.desktop.copyWith(
        sidebar: sizes.desktop.sidebar.copyWith(collapsedWidth: 80),
      ),
    );
    expect(changed.desktop.sidebar.collapsedWidth, 80);
    expect(changed.phone.sidebar, sizes.phone.sidebar);
    expect(
      HyperSidebarSize.lerp(
        sizes.desktop.sidebar,
        changed.desktop.sidebar,
        .5,
      ).collapsedWidth,
      72,
    );
  });

  testWidgets('选中子项展开祖先，父级默认不跟随高亮', (tester) async {
    await tester.pumpWidget(
      app(
        SizedBox(
          height: 400,
          child: HyperSidebar(items: menu, selectedId: 'saved'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('收藏'), findsOneWidget);
    final ancestor = tester.widget<Semantics>(
      find
          .ancestor(
            of: find.text('资源库'),
            matching: find.byWidgetPredicate(
              (widget) =>
                  widget is Semantics && widget.properties.selected != null,
            ),
          )
          .first,
    );
    expect(ancestor.properties.selected, isFalse);

    await tester.tap(find.text('资源库'));
    await tester.pumpAndSettle();
    expect(find.text('收藏'), findsNothing);
  });

  testWidgets('展开树的父子项与后续兄弟项保持主题行距', (tester) async {
    const gap = 10.0;
    await tester.pumpWidget(
      app(
        const SizedBox(
          height: 400,
          child: HyperSidebar(
            items: menu,
            selectedId: 'saved',
            selectParentWhenChildSelected: true,
            style: HyperSidebarStyle(rowGap: gap),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final parent = find.byKey(const ValueKey('hyper-sidebar-item-library'));
    final child = find.byKey(const ValueKey('hyper-sidebar-item-saved'));
    final sibling = find.byKey(const ValueKey('hyper-sidebar-item-disabled'));
    expect(tester.getTopLeft(child).dy - tester.getBottomLeft(parent).dy, gap);
    expect(tester.getTopLeft(sibling).dy - tester.getBottomLeft(child).dy, gap);
  });

  testWidgets('展开和收起子菜单时后续菜单行平滑位移', (tester) async {
    await tester.pumpWidget(
      app(const SizedBox(height: 400, child: HyperSidebar(items: menu))),
    );
    await tester.pumpAndSettle();
    final sibling = find.byKey(const ValueKey('hyper-sidebar-item-disabled'));
    final closedTop = tester.getTopLeft(sibling).dy;

    await tester.tap(find.text('资源库'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    final openingTop = tester.getTopLeft(sibling).dy;
    await tester.pumpAndSettle();
    final openTop = tester.getTopLeft(sibling).dy;
    expect(openingTop, greaterThan(closedTop));
    expect(openingTop, lessThan(openTop));

    await tester.tap(find.text('资源库'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 60));
    final closingTop = tester.getTopLeft(sibling).dy;
    await tester.pumpAndSettle();
    expect(closingTop, lessThan(openTop));
    expect(closingTop, greaterThan(closedTop));
    expect(tester.getTopLeft(sibling).dy, closedTop);
    expect(find.text('收藏'), findsNothing);
  });

  testWidgets('宽度、内容与子项过渡可由主题和实例分别替换', (tester) async {
    final base = HyperThemeData.light();
    final theme = base.copyWith(
      sidebarTheme: const HyperSidebarThemeData(
        style: HyperSidebarStyle(
          widthTransitionBuilder: themeWidthTransition,
          childrenTransitionBuilder: themeChildrenTransition,
        ),
      ),
    );
    await tester.pumpWidget(
      app(
        HyperSidebarTheme(
          data: const HyperSidebarThemeData(
            style: HyperSidebarStyle(
              contentTransitionBuilder: localContentTransition,
            ),
          ),
          child: const SizedBox(
            height: 400,
            child: HyperSidebar(
              items: menu,
              selectedId: 'saved',
              style: HyperSidebarStyle(
                childrenTransitionBuilder: instanceChildrenTransition,
              ),
            ),
          ),
        ),
        data: theme,
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('theme-width-transition')), findsOneWidget);
    expect(find.byKey(const Key('local-content-transition')), findsOneWidget);
    expect(
      find.byKey(const Key('instance-children-transition')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('theme-children-transition')), findsNothing);
    const style = HyperSidebarStyle(
      childrenTransitionBuilder: instanceChildrenTransition,
    );
    expect(
      style.copyWith().childrenTransitionBuilder,
      instanceChildrenTransition,
    );
    expect(
      HyperSidebarStyle.lerp(
        style,
        const HyperSidebarStyle(),
        .25,
      ).childrenTransitionBuilder,
      instanceChildrenTransition,
    );
  });

  testWidgets('展开项保留标题与描述并使用当前端列表文字规格', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperSidebar(
          items: [
            HyperSidebarItem(
              id: 'detail',
              label: '标题',
              description: '描述文本',
              icon: Icon(Icons.info_outline),
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    final tile = tester.widget<HyperListTile>(
      find.widgetWithText(HyperListTile, '标题'),
    );
    expect(find.text('描述文本'), findsOneWidget);
    final typography = HyperTheme.of(tester.element(find.byType(HyperSidebar)))
        .typography;
    expect(tile.style!.titleStyle!.fontSize, typography.listTitle);
    expect(tile.style!.subtitleStyle!.fontSize, typography.listSubtitle);
  });

  testWidgets('显式开启父级跟随选中时使用较轻背景', (tester) async {
    HyperSidebarItemState? parentState;
    final base = HyperThemeData.light();
    await tester.pumpWidget(
      app(
        HyperSidebar(
          selectedId: 'saved',
          selectParentWhenChildSelected: true,
          style: const HyperSidebarStyle(
            selectionStyle: HyperSidebarSelectionStyle.fill,
          ),
          items: [
            HyperSidebarItem(
              id: 'library',
              label: '资源库',
              icon: const Icon(Icons.folder_outlined),
              builder: (context, state, defaultItem) {
                parentState = state;
                return defaultItem;
              },
              children: menu.first.children,
            ),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(parentState!.ancestorSelected, isTrue);
    expect(parentState!.selected, isTrue);
    final selection = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey('hyper-sidebar-item-library')),
    );
    expect(
      (selection.decoration as BoxDecoration).color,
      base.colors.primary.withValues(alpha: .05),
    );
    final childSelection = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey('hyper-sidebar-item-saved')),
    );
    expect(
      (childSelection.decoration as BoxDecoration).color,
      base.colors.primary,
    );
  });

  testWidgets('外部展开状态、禁用项与自定义行', (tester) async {
    String? selected;
    Set<String>? requested;
    HyperSidebarItemState? state;
    await tester.pumpWidget(
      app(
        SizedBox(
          height: 400,
          child: HyperSidebar(
            items: [
              ...menu,
              HyperSidebarItem(
                id: 'custom',
                label: '自定义',
                builder: (context, itemState, defaultItem) {
                  state = itemState;
                  return DecoratedBox(
                    key: const Key('custom-item'),
                    decoration: const BoxDecoration(),
                    child: defaultItem,
                  );
                },
              ),
            ],
            expandedIds: const {},
            onExpandedIdsChanged: (ids) => requested = ids,
            onSelected: (id) => selected = id,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('custom-item')), findsOneWidget);
    expect(state!.enabled, isTrue);
    await tester.tap(find.text('资源库'));
    await tester.pumpAndSettle();
    expect(requested, {'library'});
    expect(find.text('收藏'), findsNothing);
    await tester.tap(find.text('已禁用'));
    await tester.pumpAndSettle();
    expect(selected, isNull);
    await tester.tap(find.text('自定义'));
    await tester.pumpAndSettle();
    expect(selected, 'custom');
  });

  testWidgets('折叠态悬停显示子项，选择后关闭浮层', (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    String? selected;
    await tester.pumpWidget(
      app(
        Align(
          alignment: Alignment.centerLeft,
          child: HyperSidebar(
            collapsed: true,
            items: menu,
            onSelected: (id) => selected = id,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HyperAnchoredOverlay), findsOneWidget);
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(
      tester.getCenter(find.byIcon(Icons.folder_outlined).first),
    );
    await tester.pumpAndSettle();
    expect(find.text('收藏'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
    final popup = tester.widget<HyperCard>(find.byType(HyperCard).last);
    expect(popup.style?.boxShadow, isNotEmpty);
    await tester.tap(find.text('收藏'));
    await tester.pumpAndSettle();
    expect(selected, 'saved');
    await mouse.removePointer();
  });

  testWidgets('折叠态浮窗过渡可由侧栏样式替换', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperSidebar(
          collapsed: true,
          items: menu,
          style: HyperSidebarStyle(
            popupTransitionBuilder: customPopupTransition,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final overlay = tester.widget<HyperAnchoredOverlay>(
      find.byType(HyperAnchoredOverlay),
    );
    expect(overlay.transitionBuilder, customPopupTransition);
  });

  testWidgets('全局材质阴影不被折叠子菜单默认阴影改写', (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final base = HyperThemeData.light();
    final theme = base.copyWith(
      materialTheme: base.materialTheme.copyWith(
        material: const HyperSurfaceMaterial.solid(
          boxShadow: [BoxShadow(color: Colors.red, blurRadius: 8)],
        ),
      ),
    );
    await tester.pumpWidget(
      app(const HyperSidebar(collapsed: true, items: menu), data: theme),
    );
    await tester.pumpAndSettle();
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(
      tester.getCenter(find.byIcon(Icons.folder_outlined).first),
    );
    await tester.pumpAndSettle();
    final popup = tester.widget<HyperCard>(find.byType(HyperCard).last);
    expect(popup.style?.boxShadow, isNull);
    await mouse.removePointer();
  });

  testWidgets('实例可明确移除折叠子菜单阴影', (tester) async {
    await tester.binding.setSurfaceSize(const Size(500, 500));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      app(
        HyperSidebar(
          collapsed: true,
          items: menu,
          style: HyperSidebarStyle(
            popupCardStyle: HyperCardStyle(boxShadow: const []),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(
      tester.getCenter(find.byIcon(Icons.folder_outlined).first),
    );
    await tester.pumpAndSettle();
    final popup = tester.widget<HyperCard>(find.byType(HyperCard).last);
    expect(popup.style?.boxShadow, isEmpty);
    await mouse.removePointer();
  });

  testWidgets('全局、局部与实例主题按明确字段覆盖', (tester) async {
    final base = HyperThemeData.light();
    final global = base.copyWith(
      sidebarTheme: const HyperSidebarThemeData(
        style: HyperSidebarStyle(
          width: 300,
          selectedBackgroundColor: Colors.green,
        ),
      ),
    );
    await tester.pumpWidget(
      app(
        HyperSidebarTheme(
          data: const HyperSidebarThemeData(
            style: HyperSidebarStyle(width: 280),
          ),
          child: const HyperSidebar(
            selectedId: 'saved',
            items: menu,
            style: HyperSidebarStyle(width: 270),
          ),
        ),
        data: global,
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.getSize(find.byType(HyperSidebar)).width, 270);
    final selection = tester.widget<AnimatedContainer>(
      find.byKey(const ValueKey('hyper-sidebar-item-saved')),
    );
    expect((selection.decoration as BoxDecoration).color, Colors.green);
  });
}
