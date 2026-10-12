# 下拉选择与自动填充

`HyperSelect<T>` 在弹出的面板内搜索，`HyperAutocomplete<T>` 在主输入框搜索。
二者共用选项、异步查询、分页与呈现规则；选中值始终由应用控制。

## 单选与取消选择

~~~dart
HyperSelect<String>(
  options: const [
    HyperSelectOption(value: 'compact', label: '紧凑布局'),
    HyperSelectOption(value: 'comfortable', label: '舒适布局'),
    HyperSelectOption(value: 'experimental', label: '实验布局', enabled: false),
  ],
  value: null,
  searchable: true,
  allowDeselect: true,
  onChanged: (value) {},
)
~~~

`value` 为 `T?`，`onChanged` 接收 `T?`。启用 `allowDeselect` 后再次点击当前选项返回 null；默认关闭。
单选完成关闭面板。应用须保存回调值并重建；空回调或 `enabled: false` 禁用整个控件。
`HyperSelectOption` 支持 `leading`、`trailing`、`enabled`；选中对勾优先展示。
选项 value 必须非空、页内唯一且保持稳定，标签可以重复。对象值应实现稳定的相等与 hashCode。

## 多选与溢出

~~~dart
HyperSelect<String>.multiple(
  options: const [
    HyperSelectOption(value: 'one', label: '第一项'),
    HyperSelectOption(value: 'two', label: '第二项'),
  ],
  values: const {'one', 'two'},
  onSelectionChanged: (values) {},
  maximumSelection: 4,
  searchable: true,
)
~~~

多选通过 `Set<T>` 控制；选中后面板保持打开，点击选中项或 Chip 删除可取消。
主控件按实际 Chip 宽度显示前缀，剩余用 `+N` 表示；点击 `+N` 打开选项面板，选中状态由选项上的对号表示。
紧凑标签摘要不额外添加 Tab 停靠点；键盘删除可在完整面板操作，自动填充也支持 Backspace。
弹层不重复展示已选 Chip；「完成」关闭，「清空」保留禁用选项。
`maximumSelection` 只限制新增，不阻止取消；禁用项不能选中或删除。
标签只负责展示，不作为选项身份。已选值不在当前页时，已知标签保留；
初始跨页值可通过 `selectedOptions` 提供标签和禁用信息，或用 `labelBuilder` 返回标签。
未找到标签时回退到 value.toString，不会因搜索过滤而清掉已选值。

## 自动填充

~~~dart
HyperAutocomplete<String>.multiple(
  options: const [
    HyperSelectOption(value: 'Beijing', label: '北京'),
    HyperSelectOption(value: 'Shanghai', label: '上海'),
  ],
  values: const {'Beijing'},
  onSelectionChanged: (values) {},
  placeholder: '输入城市名称',
)
~~~

静态数据按标签做不区分大小写的包含搜索；主输入框保持编辑焦点。
中文输入组合态不发出搜索请求，提交输入后按 `searchDebounce` 防抖。
上下键移动选项，Enter 选择，Esc 关闭；多选空输入框按 Backspace 删除最后一个可删除项。
关闭时单选输入恢复当前选中值，不会把任意文字自动写入 value。
默认只接受已有选项。自由值须显式提供 `createValue: (text) => ...`；
无可选匹配项时 Enter 提交自由值，转换与业务校验由应用负责。

## 异步搜索与分页

~~~dart
HyperAutocomplete<int>(
  value: 37,
  onChanged: (value) {},
  labelBuilder: (value) => '成员 $value',
  source: HyperSelectSource<int>.async(
    pagination: HyperSelectPagination.page,
    pageSize: 20,
    loader: (query) async => HyperSelectPage<int>(
      options: const [HyperSelectOption(value: 37, label: '成员 37')],
      hasMore: false,
    ),
  ),
)
~~~

`options` 与 `source` 只能提供一个。建议在 State 中持有稳定的 source 实例，
避免每次重建换一个数据源而清掉查询缓存。
loader 接收 `HyperSelectQuery`：`text`、从 1 开始的 `page`、`cursor` 和 `pageSize`。
返回 `HyperSelectPage(options, hasMore, nextCursor)`：

| pagination | 请求及返回约定 |
| --- | --- |
| none | 单次请求，不分页 |
| page | 首次 page=1；点击「加载更多」递增 page |
| cursor | 首次 cursor=null；有后续页时返回非空、未使用过的 nextCursor |

空页停止分页，即使 hasMore=true；跨页重复 value 保留原顺序并更新内容。
重复进行中的请求合并；输入变化、替换数据源或销毁后旧请求不得覆盖新结果。
请求无需被底层网络物理取消，但过期响应不会提交到组件。
首屏错误显示重试；追加页错误保留已加载项，重试同一页。
分页由「加载更多」触发。查询缓存默认按 query 开启、最多 20 组，
可用 `cachePolicy: HyperSelectCachePolicy.none` 关闭，`cacheCapacity` 调整容量。
所有加载结果被当作服务端已过滤数据，不重复本地过滤。

## 多种弹出方式

~~~dart
HyperSelect<String>(
  options: const [HyperSelectOption(value: 'auto', label: '自动')],
  value: 'auto',
  onChanged: (value) {},
  presentation: HyperSelectPresentation.bottomSheet,
)
~~~

| presentation | 行为 |
| --- | --- |
| adaptive | 桌面锚定；手机、平板、手表默认底部弹窗 |
| anchored | 主控件边缘锚定，placement 可选择方向 |
| trailing | 主控件尾部方向锚定；整行列表使用 HyperPopupListTile 的尾部定位 |
| bottomSheet | 模态底部弹窗，继承 BottomSheet 的宽度、材质和关闭行为 |
| fullScreen | 全屏页，复用 HyperScaffold / HyperAppBar |

任意设备都可显式指定任意模式；普通桌面窗口缩放不改变设备类别。
自动填充在手机弹窗内保留可编辑输入框，同步主输入内容；键盘避让由弹窗或页面处理。
列表尾部的简单单选继续使用 `HyperPopupListTile`，同样支持 `presentation` 与 `allowDeselect`，
复杂的多选、搜索和分页用上述两个字段组件。未另建重复的列表选择组件。

## 主题与布局

~~~dart
HyperSelectionTheme(
  data: HyperSelectionThemeData(
    style: HyperSelectionStyle(
      maxPanelHeight: 260,
      chipSpacing: 6,
      presentation: HyperSelectPresentation.anchored,
      searchStyle: HyperTextFieldStyle(height: 36),
      inputStyle: HyperTextFieldStyle(height: 36),
    ),
  ),
  child: HyperAutocomplete<String>(
    value: null, options: const [], onChanged: (value) {},
  ),
)
~~~

共用配置：全局 `selectionTheme` / 局部 `HyperSelectionTheme` / 实例 `selectionStyle`。
自动填充另有 `autocompleteTheme` / `HyperAutocompleteTheme`，
下拉框通过 `selectTheme.style.selectionStyle` 和 `HyperSelectStyle.selectionStyle` 覆盖。
主控件复用 Button / TextField；面板复用 Menu 的字体、行高、颜色、行间距与交互；
表面复用 Card 与统一高级材质，Chip 使用 Chip 主题。
Select 与 Menu 共用浮层表面解析，保留原菜单的默认玻璃配方、边框和阴影；
质量和减少透明度由统一材质主题管理，降级配方保留阴影。
`surfaceStyle`、`menuStyle`、`chipStyle`、`searchStyle`、`inputStyle` 都是强类型覆盖。
`transitionBuilder` 替换弹出动效，`feedbackTransitionBuilder` 替换加载/空态/错误过渡；
默认时长及曲线来自 Motion，尊重减少动画设置。
底部路由的动效由 BottomSheetTheme.animationStyle 配置。

四端共用额外尺寸位于 `sizes.selection`：面板高度上限、Chip 间距和最小输入宽度。
宽度默认沿用同端 Select 规格，`selectionStyle.width` 可覆盖；父布局仍应提供有限宽度。
当前选项列表为普通菜单布局，适用于有限页数据；超大列表虚拟化、树形选择和级联选择另行实现。
搜索和选项按自然高度共用滚动区域，不按比例压缩文字与输入框；多选操作区保留在底部。
Gallery 仅保留一个下拉/自动填充入口，基础、禁用与主题覆盖示例已合并。

[下拉源码](../../lib/src/components/select/hyper_select.dart) ·
[自动填充源码](../../lib/src/components/autocomplete/hyper_autocomplete.dart) ·
[查询模型](../../lib/src/components/select/hyper_select_model.dart) ·
[Style](../../lib/src/components/select/hyper_selection_style.dart) ·
[Demo](../../example/lib/pages/selection/hyper_select_fields_page.dart)

验证范围为静态分析、文档示例编译及纯模型/主题测试；未启动设备或 Widget 测试。
