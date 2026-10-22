# 图表（未确认）

底层使用 fl_chart。数据模型、采样、键盘导航、排名及 K 线绘制参考用户指定的本地
`E:/lemon_shadcn/lib/src/components/charts`，没有引入该项目的主题依赖。

## 使用

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

## 主题与来源

四端几何集中在 `HyperSizeScheme.chart`，提供 copyWith、插值和值相等。
首版沿用用户指定本地实现的候选几何（D 级参考，逻辑像素），四端独立保存，暂未取得
官方图表规格，不宣称为 HIUI 或 HyperOS 精确还原。排名布局优先复用同端最小交互尺寸、
菜单与间距语义。配色继承全局语义色，可用强类型 palette 覆盖。

全局 `HyperThemeData.chartTheme`、局部 `HyperChartTheme`、实例 `HyperChartStyle` 依次合并。
嵌套图例配置仅覆盖非空字段。提示表面复用 `resolveHyperMenuSurface`，继承公共材质、
边框与阴影；`tooltipStyle` 的空阴影列表可显式关闭阴影。
动效时长继承全局 Motion，遵守系统减少动画。

Demo 和主题编辑器入口均在“未确认”。编辑器像素设置按整数显示、步进和保存；
未覆盖值继续继承，历史小数配置可导入。图表设置按绘图区、坐标、折线、柱体、饼图、
图例、交互与提示表面分组。编辑器首版开放常用几何和透明度；自定义 Widget、调色板和
提示材质等完整能力通过代码中的强类型主题配置。

## 性能与边界

折线默认按每系列最多 1000 点进行 LTTB 采样；可通过 `maxRenderedPoints` 和
`samplingStrategy` 调整或关闭。空值断点可能额外保留，1000 不是包含断点的硬上限。
源数据视为不可变快照；传入更新数据后重建索引和采样缓存，鼠标移动复用缓存。
范围、标签和原始下标有缓存；自动横轴刻度按绘图区容量收敛，避免为每个原始点绘制刻度。

提示回调保留原始数据对象和下标，但命中针对当前绘制的采样点，不承诺逐个命中未绘制的点。
当前没有实现视口缩放后的分级采样、后台 isolate 预处理或数据源分页；大数据首次索引仍同步执行。
Demo 提供一年日/小时/分钟数据入口，属于性能测试场景，不代表已经取得发布模式性能结论。

引导线与标签靠近饼图定位，不随容器宽度延伸到两端；线宽继承同端
`sizes.divider.thickness`，独立于折线图线宽。左右两侧分别避让，空间不足时省略多余标签；长文字最多两行省略。
当前自定义的是标签文字，不支持任意 Widget 引导线标签。
提示在绘图区内避让，不跨越绘图区边界。图表横纵方向目前针对柱状图，未实现折线坐标轴转置。

## 验证

组件测试覆盖主题优先级、图例四方布局与隐藏、强类型提示、采样后的原始数据下标、
数据替换、公共提示表面覆盖，以及 280 逻辑像素宽度下 1.0 / 1.3 / 2.0 倍文字缩放。
这些测试不替代真实设备上的帧耗时、内存和大数据缩放压测。
