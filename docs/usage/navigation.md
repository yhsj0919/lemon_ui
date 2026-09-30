# 导航与列表

[返回目录](README.md)

## HyperTab / HyperTabBar / HyperTabBarView 标签导航

~~~dart
DefaultTabController(
  length: 2,
  child: SizedBox(
    height: 240,
    child: Column(
      children: const [
        HyperTabBar(tabs: [
          HyperTab(text: '声音'),
          HyperTab(text: '触感'),
        ]),
        Expanded(child: HyperTabBarView(children: [
          Center(child: Text('声音内容')),
          Center(child: Text('触感内容')),
        ])),
      ],
    ),
  ),
)
~~~

默认 segmented 为底槽；.separated 是独立圆角标签；.underline 为下划线变体。
isScrollable 让较多标签水平滚动，onTap 通知点击。
TabBar 与 View 共用 DefaultTabController，或显式传入同一个 TabController；
长度必须匹配，自建 controller 由应用 dispose。
View 必须有有限高度，放 Column 中通常用 Expanded。
底层导航和滚动由 Flutter TabBar/TabBarView 实现，三种外观由库配置；
不是 HyperSegmentedButton 的操作选择集合。
当前没有 HyperTabBarTheme/Style；配置使用 HyperSizeScheme.tabBar、
全局字体与 Material TabBarTheme（具体支持字段以实现为准）。
[源码](../../lib/src/components/tab/hyper_tab_bar.dart)。

## HyperBreadcrumb 面包屑

~~~dart
HyperBreadcrumb(
  items: const [
    HyperBreadcrumbItem(path: '/', label: '内部存储'),
    HyperBreadcrumbItem(path: '/docs', label: '文档'),
    HyperBreadcrumbItem(path: '/docs/work', label: '工作'),
  ],
  onItemTap: (index) {},
)
~~~

回调为项索引，使用 items[index].path 导航；应用更新整个路径列表。
highlightIndex 默认最后一项；单项 enabled 可禁用，整体 enabled 禁用全部。
controller 可控制滚动，physics 可替换滚动策略。
全局 breadcrumbTheme、局部 HyperBreadcrumbTheme、实例 HyperBreadcrumbStyle
配置胶囊、字体、分隔符、颜色和间距。
[源码](../../lib/src/components/breadcrumb/hyper_breadcrumb.dart)。

## HyperSidebar 侧栏导航

~~~dart
HyperSidebar(
  items: const [
    HyperSidebarItem(id: 'home', label: '首页', icon: Icon(Icons.home_outlined)),
    HyperSidebarItem(
      id: 'docs',
      label: '文档',
      children: [
        HyperSidebarItem(id: 'recent', label: '最近访问'),
        HyperSidebarItem(id: 'archive', label: '归档', enabled: false),
      ],
    ),
  ],
  selectedId: 'home',
  onSelected: (id) {},
)
~~~

items 是平铺/树形数据，groups 使用 HyperSidebarGroup 分组，所有 id 保持唯一。
selectedId 受控；onSelected 由应用执行路由并更新值。
collapsed 控制窄侧栏；expandedIds/onExpandedIdsChanged 管理展开集合。
header/footer 为插槽，badge 为单项附加内容。
selectableParent 与 selectParentWhenChildSelected 控制父项选择关系；
builder 可使用 defaultItem 包装原有交互，而不是重新实现全部键盘逻辑。
全局 sidebarTheme、局部 HyperSidebarTheme、实例 HyperSidebarStyle。
[源码](../../lib/src/components/sidebar/hyper_sidebar.dart) ·
[数据模型](../../lib/src/components/sidebar/hyper_sidebar_model.dart)。

## HyperListTile 通用列表行

~~~dart
HyperListTile(
  title: const Text('同步设置'),
  subtitle: const Text('管理自动同步'),
  leading: const Icon(Icons.sync),
  trailing: const Icon(Icons.chevron_right),
  onTap: () {},
)
~~~

title 必填，subtitle/leading/trailing 均为 Widget；onTap 空时只展示。
density 选择行密度；enabled、autofocus、focusNode、semanticLabel 配置交互。
全局 listTileTheme、局部 HyperListTileTheme、实例 HyperListTileStyle。
[源码](../../lib/src/components/list_tile/hyper_list_tile.dart)。

## HyperNavigationListTile 导航行

~~~dart
HyperNavigationListTile(
  title: const Text('存储空间'),
  subtitle: const Text('查看空间使用情况'),
  onTap: () {},
)
~~~

适用于进入下一级页面，默认导航外观由组件处理，应用负责路由。
description 提供辅助信息，leading 可加图标。
[源码](../../lib/src/components/list_tile/hyper_navigation_list_tile.dart)。

## HyperCheckboxListTile 整行复选

~~~dart
HyperCheckboxListTile(
  title: const Text('自动备份'),
  value: true,
  onChanged: (value) {},
)
~~~

整行与复选框共用受控状态，tristate 允许空值；
variant 使用 HyperCheckboxVariant。style 改行，checkboxStyle 改内部控件。
[源码](../../lib/src/components/list_tile/hyper_checkbox_list_tile.dart)。

## HyperRadioListTile 整行单选

~~~dart
HyperRadioListTile<String>(
  title: const Text('标准模式'),
  value: 'standard',
  groupValue: 'standard',
  onChanged: (value) {},
)
~~~

value/groupValue 确定是否选中，应用统一管理组值；toggleable 可取消。
variant 使用 HyperRadioVariant；style 改行，radioStyle 改内部控件。
[源码](../../lib/src/components/list_tile/hyper_radio_list_tile.dart)。

## HyperSwitchListTile 整行开关

~~~dart
HyperSwitchListTile(
  title: const Text('通知'),
  subtitle: const Text('允许消息提醒'),
  value: true,
  onChanged: (value) {},
)
~~~

整行与开关更新同一值；style 改行，switchStyle 改内部控件。
以上选择行可通过 enabled 或空回调禁用，避免另套一个会重复修改状态的 GestureDetector。
[源码](../../lib/src/components/list_tile/hyper_switch_list_tile.dart)。

## HyperPopupListTile 弹出选择行

~~~dart
HyperPopupListTile<String>(
  title: const Text('显示模式'),
  options: const [
    HyperDropdownOption(value: 'auto', label: '自动'),
    HyperDropdownOption(value: 'light', label: '浅色'),
  ],
  value: 'auto',
  onChanged: (value) {},
)
~~~

使用 HyperDropdownOption<T>；placeholder 显示空值提示。
弹出位置跟随行内部上下箭头锚点；minPopupWidth/maxPopupWidth 限制自适应宽度。
style 管理列表行，menuStyle 管理菜单，transitionBuilder 替换展开效果。
对应四端弹出行尺寸在 HyperSizeScheme.popupListTile。
[源码](../../lib/src/components/list_tile/hyper_popup_list_tile.dart)。