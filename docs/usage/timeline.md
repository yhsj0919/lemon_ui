# 时间线

`HyperTimeline` 提供垂直记录展示、时间、标题、正文和节点，支持起始侧、结束侧与交错布局。不会解析时间、排序或推断记录状态。

~~~dart
const HyperTimeline(
  items: [
    HyperTimelineItem(
      id: 'created', time: Text('10:20'), title: Text('订单创建'),
      content: Text('等待处理。'), status: HyperTimelineStatus.success,
    ),
    HyperTimelineItem(
      id: 'shipping', time: Text('11:30'), title: Text('正在配送'),
      content: Text('配送员正在前往目的地。'), status: HyperTimelineStatus.active,
    ),
  ],
)
~~~

## 顺序与布局

items 按输入顺序呈现；reverse 只反转展示顺序，不修改输入。每项需要稳定且唯一的 id，重复 id 会抛出 ArgumentError。空列表不绘制内容。

alignment.start 默认轨道位于逻辑起始侧，正文在其后；end 位于结束侧；alternate 保持中央轨道，正文依展示顺序交错。逻辑方向遵循 Directionality，RTL 自动调整两侧布局。

~~~dart
const HyperTimeline(
  alignment: HyperTimelineAlignment.alternate,
  reverse: true,
  items: [
    HyperTimelineItem(id: 1, title: Text('准备'), time: Text('昨天')),
    HyperTimelineItem(id: 2, title: Text('发布'), time: Text('今天')),
  ],
)
~~~

普通布局时间位于标题上方；交错布局时间移到对侧。opposite 可提供独立对侧内容，优先于交错布局的时间。只要任意项目有 opposite，整组就保留对侧列，避免轨道在不同行之间移动。

时间线需要有限宽度，高度随内容自然增长；本组件不内置滚动区域。少量内容可放在页面 ListView 中。双侧布局会缩小正文可用宽度，窄屏可显式选择普通单侧布局。

## 节点和状态

normal、active、success、warning、error、disabled 提供默认语义颜色。disabled 仅表示记录外观，不禁用调用方内容中的操作组件；业务交互仍由调用方管理。

默认节点为圆点；node 可替换任意 Widget。自定义节点从 iconSize 获取默认槽位尺寸，可通过单项 Style.nodeSize 覆盖。轨道按全组最大节点尺寸预留宽度，混合大小节点仍居中于同一根连接线。node 的背景、形状和内部布局由传入组件负责，默认圆点才读取 nodeFill / nodeBorder / nodeBorderRadius / material。

~~~dart
const HyperTimeline(
  items: [
    HyperTimelineItem(
      id: 'custom',
      title: Text('自定义节点'),
      node: Icon(Icons.local_shipping_outlined),
      status: HyperTimelineStatus.active,
      style: HyperTimelineStyle(nodeSize: 24),
      content: Text('标题和正文都支持自定义组件。'),
    ),
  ],
)
~~~

节点到下一条记录之间的连接线归当前项所有，末尾不绘制连接线。time、title、content、opposite 接受任意 Widget；日期格式、时区及操作由页面负责。semanticLabel 可提供额外可访问性描述。

## 主题、材质和动画

~~~dart
HyperTimelineTheme(
  data: const HyperTimelineThemeData(
    active: HyperTimelineStyle(
      nodeFill: HyperFill.color(Colors.teal),
      lineColor: Colors.teal,
    ),
    style: HyperTimelineStyle(titleStyle: TextStyle(fontWeight: FontWeight.bold)),
  ),
  child: const HyperTimeline(
    items: [HyperTimelineItem(id: 1, title: Text('发布'), status: HyperTimelineStatus.active)],
  ),
)
~~~

全局 timelineTheme、局部 HyperTimelineTheme、组件 Style 和单项 Style 依次覆盖；主题通用字段后合并对应状态。时间、标题、正文样式，节点、线条、间距、材质和动画均可配置。

圆点材质继承统一 HyperMaterialTheme，显式 Style 可覆盖配方、质量及透明度策略，渲染与降级复用 HyperMaterialSurface。默认时间线没有外层背景和悬停效果。

颜色、文字和节点尺寸使用 Motion fast 过渡，遵守系统减少动画设置。transitionBuilder 替换自定义节点的 AnimatedSwitcher 过渡；自定义节点使用不同 Widget 类型或显式 Key 可触发切换。普通记录增删、反转和重排不提供独立编排动画。

四端规格集中在 sizes.timeline；默认视觉为 D 级同端语义规格推导，未运行设备、Widget 或截图对照验证。

- [Demo](../../example/lib/pages/content/hyper_timeline_page.dart)
- [尺寸来源](../size-specification.md)
