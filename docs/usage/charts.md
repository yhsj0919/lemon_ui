# 图表

2026-10-23：用户已确认样式与行为，Demo 与主题编辑器入口归入“文字与内容”，页面 ID 保持 `hyper-charts`。

底层使用 fl_chart。数据模型、采样、键盘导航、排名及 K 线绘制参考用户指定的本地
`E:/lemon_shadcn/lib/src/components/charts`，没有引入该项目的主题依赖。

## 使用

折线、面积、阶梯、柱状、散点、饼图/环形图和雷达图的默认鼠标提示采用加粗标题与两列数据：类型名称和颜色标记靠左，数值按系列图例颜色靠右，标题及列之间保留主题间距。`tooltipWidgetBuilder` 仍优先替换整个内容，`tooltipStyle` 管理公共浮层表面。

内置图例与外部图例共用显隐控制路径。折线（含面积、阶梯）、柱状图的所有构造器、
散点、饼图/环形图和雷达图支持 `legendController`、`legendIds` 和 `onLegendChanged`。

```dart
// State 中创建，dispose 时由调用方释放。
final legendController = HyperChartLegendController();
List<HyperChartLegendEntry> legendItems = const [];

// 图表可放在页面任何位置。
HyperLineChart(
  series: series,
  showLegend: false,
  legendIds: const ['visits', 'sales'], // 与系列一一对应
  legendController: legendController,
  onLegendChanged: (items) => setState(() => legendItems = items),
);

// 在标题栏、侧栏等任意位置绘制；不要求位于图表子树内。
Wrap(children: [
  for (final item in legendItems)
    TextButton(
      onPressed: () => legendController.toggle(item.id),
      child: Text(item.label, style: TextStyle(
        color: item.hidden ? Colors.grey : item.color,
      )),
    ),
]);
```

回调返回不可修改的图例快照，每项包含 `id`、当前图表内的 `index`、`label`、解析后
的 `color` 与 `hidden`。首次提供，以及名称、颜色、顺序、标识或显隐变化时，在帧结束后
回调；单纯父组件重建不会重复通知，允许回调内 `setState`。关闭内置图例仍会回调。

多个图表传入同一个控制器，相同 ID 联动，图表顺序可以不同。推荐提供稳定、唯一的
`legendIds`，尤其是名称重复、重命名或动态重排时；未指定时使用名称，重复名称退回
带下标的标识。显式 ID 的数量必须匹配图例数量，且在单个图表内唯一。

控制器提供 `toggle(id)`、`setVisible(id, visible)`、`isHidden(id)`、`hiddenIds`
以及 `showAll()`；不会因某个图表卸载而清除共享状态。内置图例点击也会更新该控制器。
外部可隐藏全部数据并恢复；饼图、散点和雷达图保留原内置点击至少显示一项的行为。
控制器只负责显隐，不负责选中、高亮或图表视口。排行与 K 线目前没有系列图例，未增加
不对应其数据结构的图例回调。Demo 的“外部图例”展示独立绘制和双图共享。

```dart
HyperLineChart(
  series: [
    HyperLineSeries(name: '访问量', points: [
      HyperLinePoint(x: 0, y: 12),
      HyperLinePoint(x: 1, y: 24),
    ]),
  ],
  style: HyperChartStyle(
    legend: HyperChartLegendOptions(
      position: HyperChartLegendPosition.right,
      direction: Axis.vertical,
    ),
  ),
  tooltipWidgetBuilder: (context, data) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(data.xLabel),
      for (final item in data.items)
        Text('${item.hit.series.name}: ${item.formattedValue}'),
    ],
  ),
)
```

- 折线、面积、阶梯图：`HyperLineChart` / `.area` / `.step`。
  横轴可用 `HyperChartAxis(labelRotation: -45)` 设置倾斜角度（度）；按文字缩放后的
  实际宽高预留空间，绘图区两侧为完整标签留白。自动标签统一计算间隔，
  不临时删除单个刻度，不强制追加末尾刻度；倾斜文字不使用省略号。
- 分组、堆叠柱状图：`HyperBarChart` / `.stacked` / `.horizontal` / `.horizontalStacked`。
- 饼图和环形图：`HyperPieChart` / `.donut`。`showLeaderLabels` 开启外部引导线，
  `leaderLabelFormatter` 接收原始扇区与百分比，自定义标签文字。
- `HyperScatterChart`、`HyperRadarChart`、`HyperRankBarChart`、`HyperCandlestickChart`。
- `tooltipWidgetBuilder` 自定义跟随指针的内容，各图使用各自的强类型命中数据。
  排名图通过行内容 builder 自定义显示，当前没有跟随提示接口。
- `HyperChartLegendOptions` 配置上、下、左、右位置、横纵排列、对齐和图例项 builder。
  `HyperChartLegend` 也可独立组合；独立使用时通过 `HyperChartLayout` 配置排列。
  图例点击隐藏/显示数据；排名图和 K 线没有多系列图例。
- `HyperChartExportBoundary` 和控制器导出 PNG 字节，由应用自行保存、分享或下载。
  导出前完成一次重绘，捕获整个边界，默认排除鼠标提示框；`capturePng(includeTooltip: true)`
  可显式包含提示。导出后保留原悬停状态。`pixelRatio` 控制物理像素倍率，默认 2；
  Demo 的测试导出会直接显示实际 PNG，以核对完整范围，预览使用等比缩放。

## 主题与来源

四端几何集中在 `HyperSizeScheme.chart`，提供 copyWith、插值和值相等。
首版沿用用户指定本地实现的候选几何（D 级参考，逻辑像素），四端独立保存，暂未取得
官方图表规格，不宣称为 HIUI 或 HyperOS 精确还原。排名布局优先复用同端最小交互尺寸、
菜单与间距语义。配色继承全局语义色，可用强类型 palette 覆盖。

全局 `HyperThemeData.chartTheme`、局部 `HyperChartTheme`、实例 `HyperChartStyle` 依次合并。
嵌套图例配置仅覆盖非空字段。提示表面复用 `resolveHyperMenuSurface`，继承公共材质、
边框与阴影；`tooltipStyle` 的空阴影列表可显式关闭阴影。
动效时长继承全局 Motion，遵守系统减少动画。

Demo 和主题编辑器入口均在“文字与内容”。编辑器像素设置按整数显示、步进和保存；
未覆盖值继续继承，历史小数配置可导入。图表设置按绘图区、坐标、折线、柱体、饼图、
图例、交互与提示表面分组。编辑器首版开放常用几何和透明度；自定义 Widget、调色板和
提示材质等完整能力通过代码中的强类型主题配置。

## 性能与边界

折线默认按每系列最多 1000 点进行 LTTB 采样；可通过 `maxRenderedPoints` 和
`samplingStrategy` 调整或关闭。空值断点可能额外保留，1000 不是包含断点的硬上限。
源数据视为不可变快照；传入更新数据后重建索引和采样缓存，鼠标移动复用缓存。
范围、标签和原始下标有缓存；自动横轴刻度按绘图区容量收敛，避免为每个原始点绘制刻度。

提示回调保留原始数据对象和下标，但命中针对当前绘制的采样点，不承诺逐个命中未绘制的点。
`HyperLineChartDataset.prepare(series)` 可提前生成只读快照、索引和多级采样缓存。
原生平台通过 Flutter compute 在工作 isolate 执行；Web 的 compute 仍在同一事件循环执行，
不能据此宣称 Web 有后台线程。使用 `generate(input, builder)` 可将大列表生成也移入同一个
工作 isolate；builder 推荐顶层函数或静态纯函数，不捕获 Widget、BuildContext 或平台资源。

```dart
final data = await HyperLineChartDataset.prepare(series);
if (data.domain == null) return; // 空数据由调用方展示空状态。
final viewport = HyperChartViewportController(
  domain: data.domain!,
  minimumSpan: 1, // 数据坐标中的最小跨度，由业务决定。
);
// 在 Widget 中：
HyperLineChart(
  series: data.series,
  preparedData: data,
  viewportController: viewport,
  panEnabled: true,
);
// 交互入口：
viewport.zoom(2);       // 放大两倍。
viewport.pan(10);       // 在数据坐标中向后平移。
viewport.reset();       // 恢复整个 domain。
// Widget 所有者销毁时调用 viewport.dispose()。
```

缩放和平移使用数据坐标，独立于设备类型和像素尺寸。控制器支持范围监听、指定锚点缩放、
最小跨度、边界收敛及数据域更新，可由多个图表共享。缩放后 Y 轴默认仍保留全量数据范围，
便于比较振幅；X 轴可见范围受 xAxis.min/max 的显式边界约束。
启用视口时直接绘制新范围，不对不同采样点列表做坐标补间，以免命中并不存在的原始点。
横向拖动需显式开启，不拦截页面纵向滚动；本轮未接入滚轮或捏合缩放。

对于按 X 升序的数据，缓存以四倍点数递增，每层从原始快照独立进行 LTTB 采样。
窗口通过二分取数，根据窗口内点数选择较细缓存后再压到绘制预算；小范围逐步返回原始点。
窗口两侧保留相邻点以维持跨边界线段，绘图区裁剪多余部分。当前窗口结果也会缓存，
鼠标悬停不重复采样。无序输入回退到原始顺序的线性筛选，不享受二分和分级缓存优化，
建议调用方先按 X 排序。LTTB 是近似采样，不保证保留每个局部峰值。

快照的 series 与 preparedData 应配对传入。跨 isolate 不保证与准备前对象的 identity 相同，
回调的对象身份与下标以传给图表的快照 series 为准。准备参数的 nullPolicy 与 samplingStrategy
改变时，为保持语义正确会回退当前配置的同步采样；可重新 prepare 以复用缓存。
未使用预处理接口时保留同步路径。数据源分页、对运行中工作 isolate 的主动取消及 Web Worker
暂未实现；Demo 通过请求序号丢弃过期结果，旧请求不会覆盖当前选择。

Demo 提供一年日/小时/分钟数据的异步加载、耗时显示、放大/缩小、前后平移和恢复全量入口。
耗时是当前运行模式的观察值，不代表已取得发布模式、多平台帧率与内存结论。

引导线与标签靠近饼图定位，不随容器宽度延伸到两端；线宽继承同端
`sizes.divider.thickness`，独立于折线图线宽。左右两侧分别避让，空间不足时省略多余标签；长文字最多两行省略。
当前自定义的是标签文字，不支持任意 Widget 引导线标签。
提示在绘图区内避让，不跨越绘图区边界。图表横纵方向目前针对柱状图，未实现折线坐标轴转置。

## 验证

组件测试覆盖主题优先级、图例四方布局与隐藏、强类型提示、采样后的原始数据下标、
数据替换、公共提示表面覆盖，以及 280 逻辑像素宽度下 1.0 / 1.3 / 2.0 倍文字缩放。
这些测试不替代真实设备上的帧耗时、内存和大数据缩放压测。

2026-10-23 补充：验证 525600 个分钟数据点的原生工作 isolate 生成、索引及多级缓存准备，
期间主 isolate 的定时事件仍被处理；补充范围边界、缩放后细节、原始下标、空值断点、
横向拖动、控制器释放与 Demo 过期异步结果的组合测试。

数值坐标轴使用统一的规整刻度（1 / 2 / 5 × 10 的幂次），网格与标签共用步长。折线、面积、阶梯及柱状图的数值轴默认包含并显示 0；负值会向零以下扩展。散点与 K 线默认按数据范围缩放，仍显示明确的起止刻度。通过 `HyperChartAxis(includeZero: true)` 可要求其自动范围包含 0；`false` 可关闭自动零基准。显式 `min` / `max` 优先，不强制时间轴、类目轴从零开始。

坐标角落的标签按实际文字边界避让：纵轴端点文字保持与刻度居中对齐，顶部/底部按缩放后的文字高度留出空间；横轴首尾文字仅在超出绘图区跨度时向内收，数据点和刻度位置不移动。折线的自动标签步长同时计入首尾标签最多半个文字宽度的内收空间，保持等距刻度与相邻标签间隔。此规则覆盖横向柱状图旋转后的物理轴方向。

坐标图的左右留白按绘图区两侧的实际占位统一计算：包含刻度、轴名称及柱状图末端数值；横向柱状图按旋转后的物理左右方向平衡。折线、面积、阶梯、柱状及散点共用占位解析，K 线使用对称绘图边界。饼图、环形图及雷达图保持自身中心布局；排行图保留名称、条形、数值列的内容布局。左右图例占用独立区域，绘图区在剩余区域内布局。
