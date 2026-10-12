# 页面指示器

`HyperPageIndicator` 提示页面位置；圆点可选点击切换。与 `HyperPagination` 的数据页码导航不同，它主要配合轮播、引导页和 PageView，不负责自动播放、请求或页面控制器生命周期。

## 圆点与数字

~~~dart
const HyperPageIndicator(pageCount: 5, currentIndex: 1)
~~~

~~~dart
const HyperPageIndicator(
  pageCount: 30,
  currentIndex: 15,
  variant: HyperPageIndicatorVariant.number,
)
~~~

`currentIndex` 与 PageView 一致，从 0 开始；非空时必须小于 pageCount。pageCount 为 0 时只接受 currentIndex 为 0，组件不绘制内容。非法数据抛出参数或范围异常，不偷偷修正业务状态。

圆点默认最多显示 7 个，由 `maxVisibleDots` 指定正整数。超出时展示当前页附近的连续窗口，首尾处贴边。窗口不是全部页数，也不代表省略号；可搭配数字模式显示总数。回调与 `labelBuilder` 始终使用真实索引，数字默认显示一开始的位置。direction 可设置横向或纵向，布局遵循文字方向，窄容器中圆点自然换行。

## 受控切换

~~~dart
HyperPageIndicator(
  pageCount: 5,
  currentIndex: 0,
  onPageChanged: (index) { debugPrint('请求切换到 $index'); },
  labelBuilder: (index, count) => 'Page ${index + 1} of $count',
)
~~~

有回调且 enabled 为 true 时，圆点支持点击、键盘激活与焦点；点击当前页不发出重复请求。无回调为只读，enabled 为 false 关闭交互并按 disabledOpacity 淡化。数字模式仅展示，不使用切页回调。

PageView 的 onPageChanged 更新调用方的 currentIndex；圆点回调中调用 PageController.animateToPage 或 jumpToPage。控制器由调用方销毁，Gallery 提供完整联动示例。实际页面动画也应由调用方遵守减少动画设置。

只读圆点紧凑排列；可点击圆点的每个槽位扩展至统一 minimumInteractiveDimension，防止触控目标相互重叠。Style.minimumTapTargetSize 可显式覆盖，因此点击与只读模式的整体宽高可能不同。

## 主题

~~~dart
HyperPageIndicatorTheme(
  data: const HyperPageIndicatorThemeData(
    style: HyperPageIndicatorStyle(
      selectedWidth: 18,
      dotFill: HyperFill.color(Colors.grey),
      selectedDotFill: HyperFill.color(Colors.blue),
    ),
  ),
  child: const HyperPageIndicator(pageCount: 5, currentIndex: 2),
)
~~~

全局为 HyperThemeData.pageIndicatorTheme，四端为 HyperSizeScheme.pageIndicator，局部为 HyperPageIndicatorTheme。优先级为默认 → 全局 → 局部 → 实例 Style。文字逐字段合并，null 表示继承，HyperFill.none 表示显式无填充。

Style 可配置未选中/选中填充、圆点尺寸、选中宽度、间距、圆点边框与圆角、焦点色、点击区域、禁用透明度、数字字体、整体背景/材质/边框/圆角/阴影/内边距。counterBuilder 可替换数字内容。材质默认继承统一策略，实例可覆盖配方、质量及减少透明度。

每个圆点槽位按较大的选中宽度预留空间，切换不会挤动相邻点。尺寸、填充与数字变化使用 Motion，并遵守减少动画。Style 的 duration、curve、transitionBuilder 可配置数字内容过渡；圆点使用连续尺寸和填充插值。

默认视觉为 D 级同端语义推导：圆点与紧凑间距参考同端 Badge.dotSize，数字文字继承 bodySmall。未验证同代 HyperOS 指示器截图，不宣称精确还原。Demo 位于 Gallery「标签导航」分类。
