# 折叠区域与手风琴

`HyperCollapsible` 管理单项的尺寸裁切、标题触发、箭头和内容显隐。`HyperAccordion` 管理多个面板的互斥或多项展开规则。两者均受控，不保存业务展开状态。

~~~dart
HyperCollapsible(
  expanded: true,
  header: const Text('高级设置'),
  leading: const Icon(Icons.settings_outlined),
  onExpandedChanged: (expanded) {},
  child: const Text('设置内容'),
)
~~~

页面在 onExpandedChanged 后更新 expanded。未提供回调时标题为静态展示，不会自行切换。leading、trailing 和 header 接受任意 Widget；showIndicator 可隐藏箭头。enabled 禁用标题和内容交互，focusNode 与 autofocus 作用于可交互标题；标题复用 HyperPressable 键盘能力，并提供展开语义。

## 内容生命周期与横向折叠

maintainState 默认 true：完全收起后保持子树，隐藏内容不占据父级布局空间，内部 Ticker 停止。开始收起时内容立即退出指针、焦点和语义。设为 false 时，关闭动画结束后卸载内容；再次展开会重新创建子树。

无 header 时只提供受控内容区域。axis 默认 vertical，也支持 horizontal。父约束必须允许动画方向改变尺寸；固定高度或紧宽约束可能阻止对应方向的收缩。横向内容若要保持稳定宽度，调用方应给内容明确宽度。

~~~dart
const HyperCollapsible(
  expanded: true,
  axis: Axis.horizontal,
  child: SizedBox(width: 240, child: Text('横向内容区域')),
)
~~~

## 手风琴

~~~dart
HyperAccordion(
  mode: HyperAccordionMode.single,
  expandedIds: const {'general'},
  onExpandedChanged: (ids) {},
  items: const [
    HyperAccordionItem(id: 'general', header: Text('常规'), child: Text('常规设置')),
    HyperAccordionItem(id: 'privacy', header: Text('隐私'), child: Text('隐私设置')),
    HyperAccordionItem(id: 'disabled', header: Text('禁用'), child: Text('不可操作'), enabled: false),
  ],
)
~~~

single 模式最多展开一项，也允许全部关闭；multiple 模式独立切换各项。稳定 id 在同一组内必须唯一。重复 id、single 模式同时指定多个有效展开 id 会抛出 ArgumentError。删除后不存在的 id 不参与解析，也不会回写调用方集合。禁用项不会发出切换请求，但外部仍可控制其展示状态。

组无回调时为静态受控展示。所有输出集合不可修改；页面可直接保存回调结果。内容较少时可放在外部 ListView 中，手风琴本身不创建滚动区域。

## 主题与材质

~~~dart
HyperAccordionTheme(
  data: const HyperAccordionThemeData(
    style: HyperAccordionStyle(
      showDividers: true,
      itemTheme: HyperCollapsibleThemeData(
        expanded: HyperCollapsibleStyle(headerStyle: TextStyle(fontWeight: FontWeight.bold)),
        style: HyperCollapsibleStyle(indicatorIcon: Icons.keyboard_arrow_down),
      ),
    ),
  ),
  child: const HyperAccordion(
    mode: HyperAccordionMode.multiple,
    expandedIds: {'one'},
    items: [HyperAccordionItem(id: 'one', header: Text('详情'), child: Text('详情内容'))],
  ),
)
~~~

全局 collapsibleTheme / accordionTheme、局部对应 Theme 和实例 Style 逐字段覆盖。面板按通用、展开/收起、禁用顺序合并，实例 Style 最后覆盖。Accordion itemTheme 作用于各面板；item.style 是条目实例覆盖。

面板可配置背景、材质、质量、透明度策略、边框、圆角、标题和内容内边距、标题最小高度、文字、图标、状态色层与动画。标题高度是最小值，长标题可增高，不压缩字体。组主题配置项间距和可选分隔线；颜色与厚度可改。

材质默认继承 HyperMaterialTheme，渲染与降级交给统一 HyperMaterialSurface。默认不增加悬停阴影。展开/收起使用 Motion standard 时长及曲线，系统减少动画时即时切换。`transitionBuilder(context, value, axis, child)` 可替换内容动画，生命周期和交互隔离仍由组件管理。

默认视觉来自同端已确认语义规格的 D 级推导，尚未运行设备、Widget 或截图对照。尺寸集中在四端 sizes.collapsible / sizes.accordion。

- [Demo](../../example/lib/pages/container/hyper_collapsible_page.dart)
- [尺寸来源](../size-specification.md)
- [Flutter 尺寸动画约束说明](https://api.flutter.dev/flutter/widgets/SizeTransition-class.html)
