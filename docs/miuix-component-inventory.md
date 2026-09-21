# MIUIX 控件清单、合并关系与手机规格

本文以 [compose-miuix-ui/miuix](https://github.com/compose-miuix-ui/miuix) 的
`main` 分支提交 `39c40f99844227b853f0049a0933b1f3ae6c00ba` 为参考快照。
审查范围包括 `basic`、`layout`、`overlay` 和 `window`。

本文只冻结以下内容：

- MIUIX 已有的公开控件形态。
- 能从源码明确确认的手机端默认尺寸和视觉规则。
- 它们与 Lemon UI 现有规划的合并关系。

本文不要求照搬 Compose API、Modifier 链、内部状态结构或绘制实现。Lemon UI
仍优先使用 Flutter 原生控件自由组合，遵守独立主题、显式属性、无倍率缩放和
实例属性优先的既有规则。

## 一、合并原则

1. MIUIX 的手机规格作为 Lemon UI 手机方案的首选视觉基准；实机截图与源码冲突时，以实机复核后更新本文。
2. MIUIX 没有平板、桌面和手表完整规格时，不按比例缩放手机值，继续使用 `HyperSizeScheme` 的离散方案。
3. 同一交互模型的外观差异使用 `.xx` 命名构造器、variant 或 style 表达，不新增重复控件。
4. 仅用于承载、定位或状态管理的类型归入现有基础设施，不伪装成独立视觉控件。
5. MIUIX 内部布局组件不直接公开；只有调用方确实需要替换内容结构时才提供 builder 或独立布局控件。
6. MIUIX 的 Overlay 与 Window 两套入口映射为同一内容控件加显式呈现策略，避免复制两套视觉主题。
7. 下列手机数值都是 Flutter 逻辑尺寸的候选默认值，不是缩放基数；实例传入值必须原样使用。
8. MIUIX原始奇数尺寸保留在参考表中；Hyper正式默认值必须按偶数规范重新校准，不机械照搬。

## 二、完整控件对照

### 基础内容、表面和数据

| MIUIX | Lemon UI 规划 | 合并结果 |
| --- | --- | --- |
| `Text` | `HyperText`、`HyperRichText` | 已覆盖；保留 Flutter 原生文本语义 |
| `Icon` | `HyperIcon` | 已覆盖 |
| `Surface` | `HyperSurface`、`HyperMaterialSurface` | 合并；普通表面与材质配方分工 |
| `Card` | `HyperCard` | 已覆盖；不继承 `HyperSurfaceTheme` 的全部视觉属性 |
| `BasicComponent` | `HyperListTile`、`HyperSettingsTile`、`HyperSelectionTile` | 不新增万能控件；只复用 start/end/bottom 插槽规则 |
| `SmallTitle` | `HyperSection`、`HyperCaption` | 合并为分区标题形态，不新增 `HyperSmallTitle` |
| `Divider` | `HyperDivider`、`HyperVerticalDivider` | 已覆盖 |
| `Badge` | `HyperBadge` | 已覆盖 |
| `BadgedBox` | `HyperBadgeAnchor` | **补充**；负责 Badge 相对目标的定位，不持有 Badge 视觉主题 |
| `ColorPalette` | `HyperColorSwatchPicker` | 已覆盖 |
| `ColorPicker` | `HyperColorPicker` | 已覆盖 |
| HSV / OkHSV / OkLab / OkLch picker 与 channel slider | `HyperColorPicker.xx`、内部通道滑块 | 合并为变体和内部实现，不新增十余个顶层控件 |

### 操作、选择和调节

| MIUIX | Lemon UI 规划 | 合并结果 |
| --- | --- | --- |
| `Button`、`TextButton` | `HyperButton.filled`、`.text` 等 | 已覆盖；变体共用一个按钮主题 |
| `IconButton` | `HyperIconButton` | 已实现 |
| `FloatingActionButton` | `HyperFloatingActionButton`、扩展形态 | 已覆盖 |
| `FloatingToolbar` | `HyperFloatingToolbar` | 已覆盖 |
| `Checkbox` | `HyperCheckbox` | 已覆盖 |
| `RadioButton` | `HyperRadio<T>` | 已覆盖 MIUIX 勾线样式，并补充跨平台常见圆形变体；名称按 Flutter |
| `Switch` | `HyperSwitch` | 已实现并采用 MIUIX 手机比例 |
| `Slider` | `HyperSlider` | 已覆盖 |
| `VerticalSlider` | `HyperVerticalSlider` | 已覆盖 |
| `RangeSlider` | `HyperRangeSlider` | 已覆盖 |
| `NumberPicker` | `HyperNumberPicker`、`HyperWheelPicker<T>` | 合并；数字便捷入口建立在滚轮选择器上 |
| `DropdownImpl`、`SpinnerItemImpl` | `HyperDropdownMenu<T>`、`HyperDropdownField<T>` | 已覆盖；MIUIX 的 Impl 不进入公开命名 |

### 输入、反馈和进度

| MIUIX | Lemon UI 规划 | 合并结果 |
| --- | --- | --- |
| `TextField` | `HyperTextField`、`HyperTextFormField`、`HyperTextArea` | 已覆盖；单行/多行共享编辑核心 |
| `SearchBar`、`InputField` | `HyperSearchBar`、`HyperSearchField` | 已覆盖；InputField 为内部插槽 |
| `SnackbarHost`、`Snackbar` | `HyperSnackbarHost`、`HyperSnackbar` | **补充 Host**；内容与队列/呈现职责分离 |
| `LinearProgressIndicator` | `HyperLinearProgressIndicator` | 已覆盖 |
| `CircularProgressIndicator` | `HyperCircularProgressIndicator` | 已覆盖 |
| `InfiniteProgressIndicator` | `HyperCircularProgressIndicator.infinite` | **补充变体**；不建立重复顶层控件 |
| MIUIX 线性不确定动画 | `HyperLinearProgressIndicator.indeterminate`、`HyperWormProgressIndicator` | 合并；普通不确定与蚯蚓强调样式分开 |
| `PullToRefresh` | `HyperPullToRefresh`、`HyperRefreshIndicator` | 已覆盖 |

### 导航、页面和滚动

| MIUIX | Lemon UI 规划 | 合并结果 |
| --- | --- | --- |
| `Scaffold` | `HyperScaffold`、`HyperAdaptiveScaffold` | 已覆盖 |
| `TopAppBar`、`SmallTopAppBar` | `HyperAppBar.large`、`.small` | 合并为变体 |
| `NavigationBar` | `HyperNavigationBar` | 已覆盖 |
| `FloatingNavigationBar` | `HyperNavigationBar.floating` | **补充变体** |
| `FloatingNavigationBarItem` | `HyperNavigationDestination` | **补充配套项**；普通和浮动导航共用 |
| `NavigationRail`、`NavigationRailItem` | `HyperNavigationRail`、`HyperNavigationRailDestination` | 补充配套 Destination；支持折叠与展开 |
| `TabRow`、`TabRowWithContour` | `HyperTabBar` 的 standard / contour 变体 | 合并，不新增另一套 Tab 控件 |
| `BreadcrumbBar` | `HyperBreadcrumb` | 已覆盖 |
| `VerticalScrollBar`、`HorizontalScrollBar` | `HyperScrollbar` | 合并为 axis 属性 |

### 弹层、菜单和多窗口

| MIUIX | Lemon UI 规划 | 合并结果 |
| --- | --- | --- |
| `TooltipBox`、Plain / Rich Tooltip | `HyperTooltip.plain`、`.rich` | 补充明确变体，共用主题骨架 |
| `ListPopup` | `HyperMenu`、`HyperDropdownMenu<T>`、`HyperPopup` | 按语义合并，不公开 Impl 名称 |
| Cascading List Popup | `HyperCascadingMenu` | **补充**；桌面悬浮子菜单与移动端层级变换共用数据模型 |
| Dialog content + Overlay/Window Dialog | `HyperDialog` + `HyperOverlayPresentation` | 已覆盖内容；补充显式 overlay/window 呈现策略 |
| BottomSheet content + Overlay/Window BottomSheet | `HyperBottomSheet` + 呈现策略 | 已覆盖 |
| Overlay/Window ListPopup | `HyperPopup` + 呈现策略 | 合并 |
| Overlay/Window CascadingListPopup | `HyperCascadingMenu` + 呈现策略 | 合并 |
| `CascadingMorphContent`、`MorphHeaderRow` | `HyperContentMorph` 或菜单内部转场 | 不立即公开；先作为级联菜单内部动画能力 |

## 三、MIUIX 手机端基准尺寸

以下只记录源码中可明确确认、且对实现有直接价值的默认值。未列出的尺寸不得凭感觉推导。

| 控件 | MIUIX 手机基准 |
| --- | --- |
| Button | 最小宽 58，高 40，圆角 16，水平内边距 16，垂直内边距 13 |
| IconButton | 最小 40×40，胶囊/圆形半径 40 |
| FloatingActionButton | 最小 60×60，阴影高度 4 |
| Card | 圆角 16，默认内容内边距 0 |
| Checkbox | 视觉尺寸 26×26 |
| RadioButton | 视觉尺寸 26×26 |
| Switch | 轨道 49×28，滑块 20×20，关闭/开启起点 4/25，交互缩放 1.127 |
| Badge | 点状 6，带内容最小高度 16，内容水平内边距 4 |
| Divider | 厚度 0.75 |
| Icon | 默认 24 |
| Slider | 最小高度 28，关键点半径 3.855 |
| NumberPicker | 单项高度 45 |
| LinearProgress | 高度 6，圆角为高度一半 |
| CircularProgress | 尺寸 30，描边 4，圆头 |
| InfiniteProgress | 尺寸 20，描边 2，轨道点 2 |
| PullToRefresh 指示器 | 圆环尺寸 20 |
| TextField | 圆角 16，水平/垂直内容边距 16，聚焦边框 2，浮动标签 10，普通标签 17 |
| SearchBar | 输入区最小高 45，字号 17，外边距水平 12；前后图标间距为 16/8 |
| Dropdown | 最小高 56、最小宽 200、勾选图标 20、普通图标最小 26、文字最大宽 216 |
| ListPopup | 最小宽 200、常规最大宽 288、最小高 50、圆角 16 |
| Breadcrumb item | 高 32、水平内边距 10、最大宽 160；Bar 内边距水平 12/垂直 8 |
| TabRow | 高 42、圆角 12、单项宽 76–98、项间距 9 |
| Contour TabRow | 高 45、圆角 8、单项宽 62–84、项间距/轮廓内边距 5 |
| NavigationBar item | 高 64、图标 26、标签字号 12、图标顶部与底部留白各 8 |
| FloatingNavigationBar | 外侧水平边距 36、内部水平 12、项间距 12、图标 28、图标内边距 10、阴影 1 |
| NavigationRail | 折叠宽 80、展开宽 240、图标 28、标签 12、展开标签 16、展开项圆角 16 |
| TopAppBar | 收起高度 52、小标题中心区 50；标题边距 26，导航/操作边距 16 |
| Snackbar | 最小高 48、圆角 16、内容内边距 12、左右外边距 12；操作区胶囊半径 50 |
| PlainTooltip | 与目标间距 8、箭头 16×8、最大宽 200、圆角 12、内边距 12×8 |
| RichTooltip | 最大宽 320、圆角 16、内边距 16；操作圆角 8、内边距 12×6 |
| Dialog | 最大宽 420、圆角 32、外边距 12、内边距 24 |
| BottomSheet | 圆角 28、最大宽 640、内部水平边距 24；拖动柄高 4、承载区高 24 |
| FloatingToolbar | 胶囊圆角 50，外侧内边距水平 12/垂直 8 |
| SmallTitle | 内边距水平 28/垂直 8 |
| ScrollBar | 滑块宽 3.64、末端边距 3.46、最短 36、拖动宽 6、命中宽 48 |

## 四、从手机扩展到其他终端

禁止使用“手机值 × 系数”。每个控件实现时建立如下明确表格：

| 终端 | 处理规则 |
| --- | --- |
| phone | 优先采用本文件的 MIUIX 基准，再用 HyperOS 实机校准 |
| tablet | 保留手机视觉语言，增加页面留白和适当命中区；具体数值逐控件明确 |
| desktop | 降低行高和空白，提高信息密度；鼠标命中区与视觉尺寸分离 |
| watch | 保证圆屏安全区和触控面积；必要时改变布局结构，不压缩手机布局 |

每个控件的尺寸解析顺序保持：

```text
实例明确值
→ HyperXxxThemeData 当前终端值
→ HyperSizeScheme 当前终端语义尺寸
→ 控件内置终端默认值
```

MIUIX 数值只进入 phone 的控件内置默认值或 phone 主题预设，不进入
`HyperSizeScheme` 的倍率计算，也不会自动影响其他控件。

`HyperSwitch` 同样不得把手机尺寸原样用于桌面：手机和平板将MIUIX原始49×28
校准为48×28、滑块20、偏移4/24；桌面采用44×24、滑块18、偏移4/22；手表采用44×26、滑块22、
偏移2/20。各组数值独立定义，不通过比例计算。

### Button 专项对比与四端冻结值

MIUIX Button 的结构很轻：一个 squircle 表面、一层点击处理和一个居中 `Row`。
默认手机规格是最小 58×40、圆角 16、水平内边距 16、垂直内边距 13、按钮字号
17。普通、主要、禁用状态分别提供容器色和内容色。全局 Miuix indication 使用
矩形状态层，hover、focus、press 的增量透明度分别为 0.06、0.08、0.10，并使用
不同进入/退出弹簧；`SinkFeedback` 的 0.94 缩放和 `TiltFeedback` 属于可选反馈，
不是 Button 内部强制结构。

修订前 `HyperButton` 与参考值的差异如下，保留这张表用于说明本次调整原因：

| 项目 | MIUIX 手机 | 当前 Hyper 手机 | 当前 Hyper 桌面 |
| --- | ---: | ---: | ---: |
| 最小视觉宽度 | 58 | 0，由内容决定 | 0，由内容决定 |
| 视觉高度 | 40 | 48 | 40 |
| 圆角 | 16 | 16 | 10 |
| 内容内边距 | 16×13 | 20×12 | 16×8 |
| 按钮字号 | 17 | 未在按钮默认样式中显式指定 | 未在按钮默认样式中显式指定 |
| 图标尺寸 | 任意 content | 24 | 20 |
| 图标文字间距 | 未规定 | 8 | 8 |
| loading 尺寸 | MIUIX Button 未内置 | 18 | 18 |
| 状态层 | hover .06 / focus .08 / press .10 | hover .07 / press .12，未绘制 focus | 同手机逻辑 |
| 禁用配色 | 容器与内容分别配置 | 只明确改变内容色 | 同手机逻辑 |

本次修订后 `HyperButton` 采用以下控件专属默认值，不直接沿用通用
`controlHeightMd`。表内数值是独立选择的明确值，不存在倍率关系：

| 终端 | 最小视觉尺寸 | 最小命中 | 圆角 | 内容内边距 | 字号 | 图标 | 图标间距 | loading |
| --- | --- | --- | ---: | --- | ---: | ---: | ---: | ---: |
| 手机 | 58×40 | 48×48 | 16 | 水平16、垂直12 | 16 | 24 | 8 | 18 |
| 平板 | 64×44 | 48×48 | 16 | 水平18、垂直12 | 16 | 24 | 8 | 18 |
| 桌面 | 52×36 | 36×36 | 10 | 水平14、垂直8 | 14 | 18 | 6 | 16 |
| 手表 | 52×40 | 48×48 | 20或胶囊 | 水平14、垂直10 | 16 | 20 | 6 | 18 |

按钮专项规则：

1. `minimumSize` 是视觉最小尺寸，`minimumTapTargetSize` 是外部命中尺寸，两者不得混用。
2. 手机默认值按 MIUIX；桌面按钮必须更矮、更窄、字体和图标更小，不能原样复制手机值。
3. 桌面默认按钮高 36；32 仅用于表格行内操作、工具栏和高密度属性面板，强调操作或触摸屏桌面可选 40/48 档位。
4. 按钮必须显式设置默认 `textStyle`，不能无意继承页面正文样式。
   默认字号要明确，行高保持可配置；材质和颜色变化不得参与文字布局。
5. enabled、disabled、hovered、focused、pressed、loading 的背景和前景都必须能由 `HyperButtonStyle`/主题明确解析。
6. 默认状态层采用 Hyper 自己的规则，不使用 Material splash；手机参考 0.06/0.08/0.10，桌面可使用更克制的明确值。
7. 上浮、下沉和倾斜属于可组合反馈策略，不增加按钮包装层，也不写死进每个变体。
8. loading 替换内容时保留原内容占位，视觉尺寸和布局不得跳动。
9. `filled`、`tonal`、`outlined`、`ghost`、`text`、`gradient` 只改变对应变体样式，不改变设备尺寸方案。
10. 任意 `child` 与图标文字便捷入口共享同一外框和状态逻辑，不按子控件类型增加隐含间距。

## 五、需要补入总计划的项目

在现有目录中新增或明确以下条目：

- `HyperBadgeAnchor`。
- `HyperSnackbarHost`。
- `HyperNavigationDestination`。
- `HyperNavigationRailDestination`。
- `HyperCascadingMenu`。
- `HyperOverlayPresentation`：overlay、window；窗口模式在多窗口阶段正式实现。
- `HyperNavigationBar.floating`。
- `HyperCircularProgressIndicator.infinite`。
- `HyperTooltip.plain` 与 `.rich`。
- `HyperAppBar.large` 与 `.small`。
- `HyperTabBar.standard` 与 `.contour`。

这些项目只进入规划，不改变当前实现顺序。后续仍按照
`initial-implementation-plan.md` 一步一个控件实现，并为每一步提供可见 Demo。

## 六、实现前检查项

实现存在 MIUIX 对照的控件时必须：

1. 先核对本快照以及当时 MIUIX 最新源码，记录参考提交。
2. 把手机尺寸逐字段写进对应 `HyperXxxStyle` 或默认解析，不依赖 Material 默认值。
3. 为平板、桌面和手表分别给出明确值或明确说明沿用哪一值，禁止倍率换算。
4. 尺寸、圆角、颜色、边框、阴影、内边距、字体和动画只公开该控件实际需要的字段。
5. 默认外观可以参考 MIUIX，但实现优先使用 Flutter 原生组件、`Container`、绘制和至多必要的一层裁切。
6. 验证实例、局部控件主题、全局控件主题、设备主题四级行为。
7. Demo 同时展示默认手机规格、当前设备规格和显式覆盖效果。
8. 不复制 MIUIX 的私有实现，也不让 MIUIX 的通用组件主题污染多个 Hyper 控件。
