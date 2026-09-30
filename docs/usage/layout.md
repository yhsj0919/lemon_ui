# 布局与容器

[返回目录](README.md)

## HyperScaffold 页面骨架

~~~dart
HyperScaffold(
  appBar: const HyperAppBar(title: Text('设置')),
  body: const Center(child: HyperText('页面内容')),
  drawer: const HyperDrawer(child: Text('抽屉内容')),
  bottomBar: const SizedBox(height: 48, child: Center(child: Text('底部区域'))),
)
~~~

body 必填；appBar、drawer/endDrawer、bottomBar、floatingActionButton 为插槽。
HyperScaffold.openDrawer(context) / openEndDrawer(context) 要在 Scaffold 的子上下文调用；
使用 Builder 获取该上下文。resizeToAvoidBottomInset 控制键盘避让。
全局 scaffoldTheme、局部 HyperScaffoldTheme、实例 HyperScaffoldStyle。
[源码](../../lib/src/components/scaffold/hyper_scaffold.dart)。

## HyperAppBar / HyperSliverAppBar 顶栏

~~~dart
HyperAppBar.large(
  title: const Text('设置'),
  actions: [
    HyperIconButton.ghost(
      icon: const Icon(Icons.search),
      onPressed: () {},
      tooltip: '搜索',
    ),
  ],
)
~~~

HyperAppBar 默认标准高度；.medium / .large 为较大标题变体。
leading 自定义返回区，automaticallyImplyLeading 控制自动返回/抽屉入口。
可直接作为 HyperScaffold.appBar；它不是 PreferredSizeWidget，放入原生 Scaffold.appBar 时需用 PreferredSize 包装。
在 HyperScaffold 中，medium/large 会按页面滚动布局转换为可收起顶栏。
HyperSliverAppBar 放入 CustomScrollView.slivers：

~~~dart
CustomScrollView(
  slivers: const [
    HyperSliverAppBar(title: Text('文档')),
    SliverToBoxAdapter(child: Text('列表内容')),
  ],
)
~~~

全局 appBarTheme、局部 HyperAppBarTheme、实例 HyperAppBarStyle 共用视觉配置；
Sliver 变体通过 HyperAppBarVariant 选择。
[固定顶栏](../../lib/src/components/app_bar/hyper_app_bar.dart) ·
[滚动顶栏](../../lib/src/components/app_bar/hyper_sliver_app_bar.dart)。

## HyperContainer 通用容器

~~~dart
HyperContainer(
  padding: const EdgeInsets.all(16),
  background: const HyperFill.color(Color(0xFFF1F3F5)),
  borderRadius: BorderRadius.circular(12),
  child: const HyperText('自由组合内容'),
)
~~~

支持尺寸/constraints、alignment、padding、margin、背景 HyperFill、
border、boxShadow 与裁剪。背景可为 none、纯色、渐变。
全局 containerTheme、局部 HyperContainerTheme；当前容器通过直接参数覆盖，
没有 HyperContainerStyle。animationDuration/animationCurve 控制视觉变化。
[源码](../../lib/src/components/container/hyper_container.dart)。

## HyperCard 卡片

~~~dart
HyperCard(
  onTap: () {},
  child: const Padding(
    padding: EdgeInsets.all(16),
    child: HyperText('可点击卡片'),
  ),
)
~~~

默认自由内容不自动增加业务内边距；需要留白用 Padding 或 style。
onTap 为空时为普通展示卡片；enabled、focusNode、semanticLabel 用于交互。
width/height/alignment 是直接布局参数。
全局 cardTheme、局部 HyperCardTheme、实例 HyperCardStyle 配置填充、材质、边框、
阴影、圆角及状态视觉。
[源码](../../lib/src/components/card/hyper_card.dart)。

## HyperTitledCard 带标题卡片

~~~dart
HyperTitledCard(
  title: const Text('通知'),
  action: HyperButton.text(label: const Text('管理'), onPressed: () {}),
  titlePosition: HyperCardTitlePosition.outside,
  child: const Padding(
    padding: EdgeInsets.all(16),
    child: Text('通知内容'),
  ),
)
~~~

title/child 必填；标题可在外侧或内部，titlePosition 选择位置。
style 是标题布局的 HyperTitledCardStyle；cardStyle 是内部 HyperCardStyle。
全局 titledCardTheme、局部 HyperTitledCardTheme。
[源码](../../lib/src/components/card/hyper_titled_card.dart)。

## HyperDrawer 抽屉

~~~dart
HyperDrawer(
  header: const Text('工作空间'),
  footer: const Text('版本信息'),
  child: HyperSidebar(
    items: const [HyperSidebarItem(id: 'home', label: '首页')],
    selectedId: 'home',
    onSelected: (id) {},
  ),
)
~~~

放进 HyperScaffold 或 Scaffold 的 drawer/endDrawer；内容可包含导航侧栏。
header/footer 固定区域，child 为主体；自行组合滚动内容。
全局 drawerTheme、局部 HyperDrawerTheme、实例 HyperDrawerStyle。
[源码](../../lib/src/components/drawer/hyper_drawer.dart)。

## HyperWidgetGroup 混合控件组

~~~dart
HyperWidgetGroup(
  connected: true,
  showSeparators: true,
  children: [
    HyperWidgetGroupItem(
      width: 80,
      child: HyperButton.ghost(label: const Text('返回'), onPressed: () {}),
    ),
    HyperButton.ghost(label: const Text('当前页'), onPressed: () {}),
    HyperButton.ghost(label: const Text('下一页'), onPressed: () {}),
  ],
)
~~~

- connected: true 由组接管外框，内置按钮去掉边框、独立圆角和阴影；默认项高度跟随基础按钮。
- false 为自由混合排列，各子组件保留自己的样式；任意第三方 Widget 不会自动被改写。
- HyperWidgetGroupItem.width 指定宽度，flex 指定比例；二者互斥，flex 需要有限主轴约束。
- direction 可为纵向；mainAxisSize 与对齐控制排列。纵向统一宽度由父约束/子项 width 组合。
- showSeparators 使用默认线，separatorBuilder 可完全替换；spacing 可形成空白分隔。
- group style 配置 itemHeight、width、外框、圆角、背景、padding、分隔线及 itemBorderRadius；
  单项 borderRadius 可分别指定外侧大圆角与内侧小圆角。
- 组不管理选中集合；使用 HyperSegmentedButton 做互斥/多选操作。

全局 widgetGroupTheme、局部 HyperWidgetGroupTheme、实例 HyperWidgetGroupStyle。
[源码](../../lib/src/components/widget_group/hyper_widget_group.dart) ·
[Demo](../../example/lib/pages/container/hyper_widget_group_page.dart)。