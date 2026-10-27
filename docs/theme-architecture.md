## 文件选择的默认平台能力（2026-10-27）

用户明确要求文件选择能力直接集成主包。`HyperFilePicker` 与 `HyperFileFormField`
的 `pick` 改为可选，默认通过 `HyperFileDialog` 打开系统或浏览器文件窗口；默认
拖放由主包统一接入 desktop_drop，`enableDrop` 可关闭，自定义 `pick` / `dropBuilder`
仍优先。原生过滤与选择后校验共用扩展名规范化，文件夹及不可读拖入项逐项拒绝。
拖放命中使用窗口真实 DPR，内容保留预览 DPR。文件内容通过 `HyperFileSelection.readAsBytes`
按需读取，默认不加载整份文件；上传网络请求仍归业务。Demo 与编辑器移除插件直接调用，
由主包提供默认适配及文件导入、保存接口，不改变组件样式、主题尺寸或页面分类。

## 主题工厂文字样式解析（2026-10-27）

`fromSeed` 与 `fromMaterial` 在应用 Hyper 字阶前，统一将主题根文字样式的
`inherit` 设为 false，并补齐 Flutter 文本输入要求的默认 alphabetic 基线，
避免回退主题与种子主题动画插值时继承属性不一致触发断言。
保留传入文字样式的行高、字重等字段，不补入额外 Material 几何，不改写控件尺寸。
保留主题动画，不在 Demo 中禁用过渡。

## 手机菜单贴边选中背景（2026-10-27）

按用户提供的系统菜单参考图，phone 的菜单项背景横向铺满面板，默认
`sizes.menu.surfacePadding = 0`、`itemRadius = 0`；文字仍保留 `padding`。
这是参考图明确的贴边关系，不从截图物理像素反推逻辑尺寸。其他端保持原规格。
新增可选尺寸字段 `surfacePadding`，未指定时兼容回退 `padding`；全局尺寸、
局部菜单主题及实例 Style 仍可显式覆盖。列表项浮窗自然宽度同步读取此字段。

同日用户进一步指定 phone 选中态仅使用主题主色文字及对勾，选中背景透明；
desktop 保持原文字色与淡色选中背景。按真实设备类别解析默认配色，
全局、局部和实例的显式菜单颜色覆盖仍优先。

同日按用户反馈，phone 菜单默认按内容收缩，`sizes.menu.width` 作为宽度上限；
显式菜单宽度覆盖仍按指定宽度显示。面板左右留白保持零，上下留白由
`sizes.menu.surfaceVerticalPadding = 8` 提供（用户明确指定，逻辑像素）。
分隔线上下间距按用户指定为各 4（`groupSpacing = 8`），同组菜单项间距仍为零。
显式 `surfacePadding` 仍覆盖四边，`surfaceStyle.padding` 最后覆盖。

手机菜单使用有界的真实布局测量各行，再以最宽行统一菜单项宽度；分隔线与
间隔不参与自然宽度计算。不再手动估算文字或自定义首尾内容的宽度，也不做
intrinsic 测量，兼容 `LayoutBuilder`，保留主题宽度上限与显式宽度覆盖。
列表项浮窗按用户明确要求保持 phone 四边留白为零，desktop 保持既有留白；
其传入的四边留白有意覆盖普通菜单的上下留白，显式主题和实例覆盖仍优先。

## 列表项选项呈现（2026-10-27）

用户明确要求 `HyperPopupListTile` 在手机端也默认显示锚点浮窗，故其 `presentation`
默认值为 `anchored`；该列表项不套用普通表单选择器的手机底部弹窗默认策略。
调用方仍可显式指定 `adaptive`、`bottomSheet` 或 `fullScreen`。
模态路径由公共选择呈现器提供唯一表面，内部 `HyperMenu(showSurface: false)` 仅展示选项，
菜单主题与实例的 `surfaceStyle` 传给外层呈现器，保留显式阴影、材质和边框覆盖。
列表项 Demo 使用 `HyperListGroup` 按用途分组，不重复嵌套卡片表面。

## 锚定面板（2026-10-27，已确认）

`HyperPopover` 是带默认表面的公开锚定面板；`HyperAnchoredOverlay` 保留为无表面的
定位、开合基础设施。面板复用 `resolveHyperMenuSurface`，材质质量、降级和安全过渡
由公共设施负责。`popoverTheme`、局部 `HyperPopoverTheme` 与实例 `HyperPopoverStyle`
逐字段合并，表面复用 `HyperCardStyle`，显式空阴影列表优先于配方。

四端默认圆角、内边距和锚点间距直接读取当前端 `sizes.menu` 与 `sizes.overlaySpacing`，
来源为 D 级同端既有浮层语义，不新增设备常量或跨端倍率。编辑器独立保存 popover 的
按设备尺寸与按亮暗外观覆盖，支持继承恢复、保存和导入。用户于同日明确要求将
当前“未确认”控件转为正式，Demo 与编辑器同步归入“交互基础”，页面 ID 保持 `hyper-popover`。
具体接口与待验证项见 [锚定面板](usage/popover.md)。

## 通知业务边界与导航表面（2026-10-16）

2026-10-22：抽屉新增四边 margin，由当前端 sizes.drawer.margin 提供默认值，HyperDrawerStyle.margin 支持全局、局部和实例覆盖；默认零边距不变。此留白属于 Scaffold 抽屉表面的滑动几何，表面宽度不包含边距，四边留白参与父约束收缩和关闭手势范围。四角复用 surfaceStyle.borderRadius，不新增重复 Style 字段；四端可用 sizes.drawer.borderRadius 配置，null 保留旧 radius 按抽屉起止方向解析的贴边圆角。普通与高级表面继续共用 HyperNavigationSurface，未新增材质或降级路径。边距过渡跟随 Motion 并遵守减少动画；Demo 使用显式开关展示示例几何，默认仍继承主题。

顶部导航的下拉菜单复用 HyperMenu，编辑器将面板与菜单项分开：面板宽度、最大高度、外层内边距和表面配置保存在 topNavigationPanel，菜单项布局、文字与状态配色保存在 topNavigationMenu；顶部按钮覆盖保持独立。
菜单新增 itemVerticalPadding，进入 HyperMenuSize 四端规格以及 HyperMenuStyle 的主题、局部和实例覆盖。默认值暂由同端既有 menu.padding 的一半推导（phone/tablet 6、desktop 4、watch 2 逻辑像素），用于在描述内容增高后保留上下留白；这是既有语义尺寸的推导值，待视觉确认，不是新增官方规格。itemHeight 继续表示最小高度，内容随文字缩放增高，不裁切。

菜单与折叠侧栏子菜单的面板内边距只由表面层应用一次，滚动内容不重复增加同一留白。菜单的 surfacePadding 与侧栏的 horizontalPadding 提供默认值，显式 surfaceStyle.padding / popupCardStyle.padding 直接替换；Card 的默认内容内边距不再叠加到菜单。顶部导航复用菜单，因此同时遵守此规则。

桌面折叠侧栏子菜单默认宽度从 256 收紧为 192 逻辑像素，复用当前同端 menu.width 的既有规格；这是同类菜单的语义对齐，不是截图物理像素换算或新官方规格。其他设备规格与显式 popupWidth 覆盖保持原有配置。

侧栏前置图标和展开箭头独立管理尺寸及默认、选中、祖先选中、禁用配色。expandIconSize 四端初值沿用该端既有 sidebar.iconSize，不新增视觉规格；编辑范围位于“导航项”，共用尺寸只在通用设置显示，颜色在当前状态下编辑。未覆盖图标颜色时继承对应状态的文字颜色。
列表项的 leadingSize 是首部占位尺寸，leadingIconSize 是可选绘制尺寸，未指定时保留传入图标自身的主题规格；leadingColor 可独立覆盖。Icon 与 HyperIcon 通过各自的主题接收这两个绘制覆盖，仍尊重调用方图标实例的显式值。

通知中心的分组、计数、已读管理和批量操作属于业务组合，已移至 example；公共组件仅保留 HyperNotification。
移除 notificationCenterTheme 和 sizes.notificationCenter，旧编辑器覆盖仅兼容导入，不再驱动组件主题。

TabBar 具有强类型 tabBarTheme，按 segmented / separated / underline 覆盖；局部 HyperTabBarTheme 与实例 Style 最后合并。
侧栏、面包屑、抽屉和空状态的表面使用强类型 HyperCardStyle 字段复用配方结构，不读取 Card 的组件主题。
非浮层导航表面复用 HyperNavigationSurface；浮层继续使用 resolveHyperMenuSurface，保持各自责任边界。
HyperMaterialSurface 的显式 border / boxShadow 优先于材质配方；空阴影列表同时关闭高级与降级阴影。
空实色材质配方的未指定背景继承组件语义色，HyperFill.none 仍表示显式透明。

抽屉新增四端 radius 规格，默认 16 逻辑像素用于保留当前 Flutter Material 3 Drawer 的既有圆角（本机 SDK drawer.dart 的 _DrawerDefaultsM3.shape/endShape），不是新的 HyperOS 官方视觉值。旧的只指定 width 的 HyperDrawerSize 仍接受，radius 为空时从统一默认尺寸主题回退。

# Lemon UI 主题与尺寸架构

## 图表（2026-10-23，已确认）

2026-10-23：折线族增加数据坐标视口控制器和原生后台数据准备接口。它们属于数据与交互
职责，不引入设备尺寸常量或视觉主题字段。当前范围采样及多级缓存使用原始快照下标，
用户于 2026-10-23 明确确认样式与行为，Demo 与主题编辑器同步归入“文字与内容”，页面 ID 保持 `hyper-charts`。

新增 `sizes.chart` 四端规格与 `chartTheme` 强类型主题；局部 `HyperChartTheme`、实例
`HyperChartStyle` 只合并显式字段。绘图参考用户指定的 lemon_shadcn，提示表面统一走
菜单表面解析，未更改已有控件默认值。候选尺寸来源与功能边界见 [图表](usage/charts.md)。

## Result 与空状态合并（2026-10-21）

`HyperResult.empty` 与其他结果状态共用布局、动画和 `HyperMaterialSurface`。空状态主题统一为 `resultTheme.empty`，尺寸统一为 `sizes.result.empty`；未指定变体尺寸时继承 `sizes.result`。全局、局部和实例均使用 Result 的强类型接口。

编辑器保留页面和文档字段 id，输出到合并后的主题与尺寸变体。显式边框和空阴影列表由统一材质表面解析。

## Cascader（2026-10-20，未确认）

HyperCascader 的锚定呈现直接复用 HyperMenu 多级浮层，悬停或点击在右侧展开子级，
父级保留可见；异步分支的加载、错误和重试在对应子浮层中处理，不混入祖先路径按钮。
手机模态呈现复用 HyperWheelPicker 实现联动草稿，确认后提交；标题与主色清空同排。
滚轮尺寸继承 sizes.wheelPicker，列间距继承 menu.padding，最小列宽复用同端最小交互尺寸；
wheelStyle / clearButtonStyle 纳入 cascaderTheme、局部主题及实例的合并/插值/值相等。
平板与手表模态呈现保留单页逐级导航，顶部只提供当前层返回按钮。
组件复用 HyperDropdown 的触发与呈现、HyperMenu 的选项与键盘导航和
HyperButton 的路径操作。全局 cascaderTheme、局部 HyperCascaderTheme 与实例
HyperCascaderStyle 逐字段合并；selectStyle / navigationStyle 分别复用现有强类型样式。
所有默认几何取解析后的 sizes.select、selection、menu、button 和 navigationItemSpacing，
不在组件内分设备保存常量，也不为相同语义重复添加设备规格。默认来源为 D 级项目语义组合，
尚未取得同代官方级联选择器的直接尺寸，待用户视觉确认。

锚定面板通过公共 HyperDropdown 的 resolveHyperMenuSurface，手机和平板复用
BottomSheet 的唯一表面，手表全屏；材质配置与安全过渡由公共基础设施负责。
异步模型只保存浏览路径与分支缓存，选择始终归调用方；数据源替换销毁旧模型，
关闭面板停止路径恢复，旧分支结果不改变当前导航。实现与验证边界见 [级联选择](usage/cascader.md)。

## TreeSelect（2026-10-20，未确认）

HyperTreeSelect 复用 HyperDropdown 的锚定呈现与公共下拉表面解析，树内容复用
HyperTreeView 的行状态、键盘导航、异步加载与重试。展开箭头独立于节点选择，
leafOnly 通过树适配层约束可选项；phone/tablet 使用底部弹窗，watch 使用全屏页面。
尺寸继承 sizes.select、selection、treeView 与 button，不增加重复的设备尺寸。
treeSelectTheme、局部 HyperTreeSelectTheme 与实例 HyperTreeSelectStyle 按强类型字段
合并、插值并参与值相等；节点 value 唯一性和动态加载结果由公共 HyperTreeController
校验。默认外观来自 D 级既有语义组合，官方精确尺寸与目标截图待确认。
实现边界见 [树形选择](usage/tree-select.md)。

## 选择面板统一布局（2026-10-19）

下拉、自动完成和日期时间编辑面板共用 hyper_selection_layout.dart 的内边距及动作区。
左右留白取当前端 menu.padding；编辑面板上下留白取 dialog.padding，纯选项列表取
menu.padding。此为 D 级既有语义规格组合，不新增设备常量。显式 menu.surfacePadding
及 surfaceStyle.padding 仍优先。清空为文字按钮，取消为描边，确定/完成为实色；
圆角、文字和尺寸均继承按钮主题，动作区不足宽度时自动换行。
手机下拉和自动完成不再在底部弹窗内绘制 HyperCard，表面覆盖转交同一个外层弹窗；
桌面仍沿用 resolveHyperMenuSurface，保留材质质量及空阴影等显式覆盖。

## NumberInput（2026-10-19，未确认）

首版数字输入为 HyperTextField 与 HyperIconButton 的组合，继承 textFieldTheme、
iconButtonTheme 和 sizes.textField 的四端规格，不增加独立重复的输入表面默认值。
步进按钮尺寸从当前端 textField.minimumHeight 的一半推导，实例 stepperStyle 可覆盖；
输入表面、文字、状态和材质通过 HyperTextFieldStyle 覆盖。来源为 D 级同端语义推导，
尚待用户视觉确认，未声明为官方 NumberInput 尺寸。
编辑器“未确认”提供独立预览入口，外观参数继续在文本输入框与图标按钮主题中管理。
数字范围、步长和精度属于实例交互约束，不写入全局视觉主题。

## 高级材质与透明度动画

录屏对照确认：整个模糊表面置于 Fade/Opacity 的离屏层内时，部分桌面后端在动画中无法采样真实背景，达到完全不透明后才恢复模糊。混合模式修改不能单独解决背景采样隔离。内部材质容器与浮层统一使用 `hyper_backdrop_safe_opacity.dart`：高级质量且未减少透明度时，先关闭背景滤镜并使用降级配方淡入，再保持外层完全不透明，连续恢复背景、模糊、染色、边框和阴影参数；关闭按同一进度反向运行。`materialTheme.transitionFadeFraction` 配置两阶段占比（默认 .6），动画提供临时 `transitionProgress`，嵌套动画取较小恢复进度，避免祖先淡入未结束时提前开启模糊。布局与内容状态保留；普通质量维持淡入淡出。自定义 transitionBuilder 仍由调用者管理，模糊表面不得整体包在分数透明度的离屏层内。

背景模糊与清晰前景保持分层。`HyperMaterialSurface`、Card、Button 和 IconButton 的背景滤镜统一使用 `BlendMode.src`，避免 Fade/Opacity 的离屏层在透明度达到 1 时移除后产生重复混合造成的观感变化。材质配方与质量不随开场动画切换；默认时长、曲线与减少动画仍由 Motion 管理。依据：[Flutter BackdropFilter.blendMode](https://api.flutter.dev/flutter/widgets/BackdropFilter/blendMode.html)。Widget 回归测试检查 .5、.99、1 三个透明度阶段的合成配置；实际模糊效果还需目标渲染后端验证。

## LoadingOverlay（2026-10-03）

全局 loadingOverlayTheme、局部 HyperLoadingOverlayTheme 和实例 Style 逐字段合并，
中央内容宽度、留白、圆角和间距由四端 sizes.loadingOverlay 管理。
默认指示器复用 HyperCircularProgress 与进度主题，不另存一套设备进度尺寸。
统一材质质量和降级从 HyperMaterialTheme 继承，显式 Style 可局部覆盖。
纯计时模型只负责 showDelay 与 minimumVisibleDuration；组件管理遮罩显隐及 child 的交互隔离，
父级管理任务、取消、导航、外部布局与区域外交互。计时与动画相互独立，减少动画不缩短业务保留时间。

## Alert / Banner（2026-10-03）

Alert 与横幅统一使用 alertTheme / HyperAlertTheme；横幅叠加 bannerStyle 及 bannerInfo 等 severity 覆盖，四端尺寸为 sizes.alert.banner。
HyperNoticeStyle 仅共用字段结构，支持通用与四种状态覆盖，实例 Style 最后应用。
共用内部 HyperNoticeBody 的内容、图标、操作与显隐布局；状态和关闭由父级控制。
材质默认继承 HyperMaterialTheme，渲染与降级复用 HyperMaterialSurface。
显示、隐藏、颜色与布局变化使用 Motion 和系统减少动画策略，显隐过渡可替换。
Banner 不创建浮层或自动吸顶；定位、宽度和外边距由父级管理。

## 统一高级材质策略（2026-10-03）

继承全局高级材质时，消费者通过 `semanticBackground` 提供组件已经解析好的背景语义。统一材质解析保留配方的背景不透明度、模糊、边框和阴影，用组件底色或渐变替换中性底色及染色层；普通降级配方同步保留组件色彩。Button / IconButton 的无填充变体不因全局材质新增背景。显式组件或实例材质保留配方自身颜色，不自动染色。状态色仍由组件主题解析，材质层不自行判断主色或错误色。

所有高级材质功能统一由 HyperThemeData.materialTheme / HyperMaterialTheme 管理质量、
默认配方与减少透明度策略；组件不得拥有独立默认的高级材质开关或降级规则。
支持材质的组件默认继承统一策略，允许通过局部主题或实例的显式字段覆盖，以局部开启或替换配方。
材质渲染和降级统一交给 HyperMaterialSurface / HyperMaterialThemeData.resolveMaterial。
浮层需要保留调用处的材质上下文。Toast / Snackbar 的 show 函数捕获配方、质量和透明度策略，
组件 ThemeData / Style 字段只是可选覆盖，不成为另一套系统级策略。

## Toast / Snackbar（2026-10-01）

toastTheme 与 snackbarTheme 独立；HyperToastTheme / HyperSnackbarTheme 局部合并，
共用强类型 HyperMessageStyle 的字段结构而不读取对方主题。四端尺寸分别存储于 sizes.toast / sizes.snackbar。
showHyperToast / showHyperSnackbar 捕获调用位置的视觉解析结果；直接 Controller.show 使用宿主主题。
HyperSnackbarHost 通过 OverlayPortal 保留宿主继承上下文，负责显示位置、安全区、键盘避让、计时和连续过渡。
Controller 管理 queue、stack、stackQueue 的名额、FIFO 等待、淘汰、取消与关闭完成，不接触 Navigator、计时或动画。
Toast 默认实时堆叠，Snackbar 默认串行；两个类型各自占用名额，避免操作提示阻塞轻提示。
宿主只有一条呈现路径，每项独立持有动画与计时；没有为旧串行模式保留单条专用补丁。
不保存静态窗口宿主；移除宿主清理请求，外部控制器保留创建方的销毁职责。
表面共用内部无主题布局，操作主题仅包装 action 子树。

## BottomSheet（2026-10-01）

HyperBottomSheet 的表面和内容与模态路由分开；showHyperBottomSheet 复用 Flutter ModalBottomSheetRoute 的拖动关闭、遮罩和焦点职责。
全局 bottomSheetTheme、局部 HyperBottomSheetTheme、打开函数 Style 与实例 Style 逐字段合并；不继承 Dialog 组件主题。
Sheet 与 Dialog 只复用内部 HyperModalContent 的无主题布局：标题、正文滚动、固定操作区和按钮子树主题。
四端最大宽度、上方圆角、正文留白、间距、关闭图标及拖动条几何集中在 HyperSizeScheme.bottomSheet。
显式 height/maxHeight 接受父约束，文字不按高度缩放；高度固定时正文填满剩余空间，footer 保留在底部。
动画用强类型 AnimationStyle 配置进出时长和曲线，默认从 Motion 推导，merge 保留未覆盖的内部字段；减少动画优先。
拖动条由 Sheet 绘制且可替换，不叠加 Material 默认拖动条或默认表面。表单与多档高度吸附不属于当前面板职责。

## Dialog（2026-10-01）

HyperDialog 管理标题、滚动正文、操作区和表面；showHyperDialog 管理模态路由、遮罩、焦点循环与返回结果。
全局 dialogTheme、局部 HyperDialogTheme 与实例 HyperDialogStyle 按显式字段合并，路由捕获调用处的 InheritedTheme。
操作区 buttonTheme 只覆盖操作区子树，不改变正文或全局按钮主题。任意 actions Widget 保留自身交互职责。
四端最大宽度、圆角、内外留白、标题与按钮间距及关闭图标尺寸集中在 HyperSizeScheme.dialog；窗口仅约束可用空间。
表面背景、材质、边框、阴影、文字、位置、按钮与路由过渡均为强类型配置，具有 copyWith、merge、lerp 和值相等。
默认过渡取 Motion fast，减少动画时关闭；路由 transitionBuilder 可替换默认淡入与轻微缩放。
后期表单弹窗只组合 Dialog 和 Form，Dialog 不持有校验或提交状态。

本文冻结 Lemon UI 的主题、设备适配和组件默认值架构。新增组件、主题重构、Demo 和测试均须遵守本文；主题类随组件增加而变大是集中式强类型设计系统的预期成本，不再作为拆散主题的理由。

默认视觉值的来源和缺少直接参考时的推导方法见 [HyperOS 风格设计基准](hyperos-design-baseline.md)。手机端参考 HyperOS；desktop 端尺寸和样式以小米 HIUI 为主要参考；平板和手表制定独立规格。第三方实现与项目暂定值不得标成官方规范。

## 一、总体目标

`HyperChip.action / choice / filter / input` 共用受控 `HyperChip`；`onPressed`
与 `onSelected` 互斥，`selected` 由调用方持有，单选互斥与多选集合归父级。
`onDeleted` 只调用删除回调，不改变选中态、不自行隐藏控件；删除按钮有独立
点击区域和键盘焦点。主体无回调时不增加无效焦点，删除入口仍可单独使用。
`HyperChipStyle.checkmarkPlacement` 默认 leading；avatarOverlay 在保留头像的同时
将选中对勾叠在头像中心，未选中时隐藏，不增加选中内容宽度。无头像时沿用 leading。
avatarReplacement 隐藏选中头像的原内容，以强类型 selectedAvatarColor / selectedAvatarShape
绘制替代表面；取消后恢复原头像。checkmarkScale 默认 1.8，只放大路径而不改变布局和描边。
Checkbox 与 Chip 的对勾路径及两阶段描画动画采用 Flutter Checkbox 的实现，
只保留主题描边与圆角端点。无额外采样、图像过滤或变换层。
对勾颜色通过 checkmarkColor 配置，头像叠加默认复用 onPrimary；调用方按头像内容
选择适合的颜色。配置参与 copyWith、merge、lerp 和值相等，沿用 Motion 与减少动画策略。
`icon` 与 `avatar` 互斥；选中对勾可关闭、替换或通过主题配置。
交互复用 `HyperPressable`，支持鼠标、触摸、Enter/Space 激活、禁用和焦点，
不创建水波纹。背景、文字、图标、头像禁用透明度和对勾使用 Motion fast 过渡；
减少动画时关闭过渡，`transitionBuilder` 可替换对勾切换效果。
全局 `chipTheme`、局部 `HyperChipTheme`、实例 `HyperChipStyle` 覆盖背景填充、
前景、状态层、边框、阴影、字体、圆角、尺寸、图标和动效。主题状态按普通、
选中、悬停、焦点、按下、禁用顺序逐字段叠加，实例最后覆盖。
四端默认值由 `HyperSizeScheme.chip` 管理，文字复用 labelMedium；可见高度
与最小交互区域分开，最小区域复用同端 minimumInteractiveDimension。
默认视觉为 D 级项目推导（基于同端按钮、Tag 与图标密度），暂无同场景官方
Chip 逻辑尺寸或目标截图的直接验证。

`HyperResult.empty` 只展示空内容，不管理网络、加载、重试或业务状态。默认中性图标
与“暂无内容”标题；`illustration` 优先于图标，`showIllustration: false` 可隐藏装饰；
`titleWidget`、`descriptionWidget` 可替换默认文本，`content` 放置额外内容，
`actions` 接受现有按钮等 Widget 并自动换行。外层最大内容宽度只约束当前组件，
父布局仍决定可用区域。装饰插图不创建重复朗读条目，文字与操作保持原有语义。
全局 `resultTheme.empty`、局部 `HyperResultTheme`、实例 `HyperResultStyle`
管理图标、颜色、排版、对齐、间距、背景填充、边框、圆角、阴影和过渡。
四端尺寸集中在 `HyperSizeScheme.result.empty`；文字复用当前端 titleMedium 与
bodySmall，背景默认无填充，容器可由使用方组合。内容变化使用 Motion 标准
过渡，系统减少动画时关闭；`transitionBuilder` 可替换插图和文字的切换效果。
无同场景可核实的官方尺寸参数，默认视觉按 D 级项目语义规格推导，待设备对照。

`HyperSkeleton` 提供矩形、`.text` 和 `.circle` 占位；全局 `skeletonTheme`、
局部 `HyperSkeletonTheme` 和实例 `HyperSkeletonStyle` 管理颜色、圆角、边框、
阴影、尺寸、循环时长、曲线、微光宽度和倾角、呼吸最低透明度、内容切换动效。
`effectBuilder` 可替换可见动画，`transitionBuilder` 可替换加载完成过渡。
`HyperSkeletonEffect.shimmer / pulse / none` 分别为微光、呼吸与静态；系统减少
动画、关闭 TickerMode、停止加载或零循环时长会停止循环。默认循环周期为全局
Motion emphasizedDuration 的 4 倍，内容过渡采用 fastDuration（项目推导）。
`.text` 在有限宽度内铺满，非有限宽度回退到当前端 lineWidth；矩形和圆形采用
对应四端默认尺寸。内容由父布局组合，不自动测量业务子树；`loading: false`
时显示传入 child，无 child 则隐藏占位。默认不为装饰形状创建朗读条目，可显式
设置 semanticsLabel。当前视觉未得到同场景 HyperOS 官方参数验证，按 D 级
项目语义规格推导；HiUI 5.0 官方发布说明已列出 Skeleton，但未获取其可核实
尺寸源码：[HiUI 5.0 发布说明](https://github.com/XiaoMi/hiui/issues/3553)。

进度统一使用 `HyperProgress.linear / circular / infinite`；全局入口为
`progressTheme`，局部主题为 `HyperProgressTheme`，实例为 `HyperProgressStyle`，
四端尺寸由 `HyperSizeScheme.progress` 管理。线性 `.thin` 保留细轨道，`.wide`
使用与同端 Slider 一致的宽胶囊轨道。宽条高度、颜色、长度、圆角和过渡均可覆盖。
`radius` 控制完整轨道外轮廓，`fillRadius` 独立控制填充端（默认轨道高度的一半，0 为直边）；
确定进度采用固定尺寸的圆角形状平移后裁剪，避免低进度挤压圆角。
Slider 默认取消 Flutter 自动添加的横向留白，显式 `SliderThemeData.padding`
仍可覆盖；单值和范围滑块的绘制与拖动映射遵守同一留白策略。

Lemon UI 提供一套完整可用的 HyperOS 默认主题。使用者可以保持业务组件代码不变，仅通过 `copyWith` 覆盖与默认主题不同的部分，快速替换整套颜色、材质、排版或多端尺寸。

```text
HyperOS 内置默认主题
→ 用户全局主题
→ 当前子树局部主题
→ 当前组件实例 Style
```

后一级只覆盖明确提供的字段，其余字段继续继承前一级。

组件自身绘制的可见元素及交互状态原则上均可配置：背景和材质、边框、阴影、
颜色、字体、圆角、间距、图标等由强类型主题提供默认值，再由局部主题和实例
`Style` 覆盖。优先复用语义颜色、字阶、材质和尺寸方案；使用方传入的内容及父布局
负责的外部布局不属于组件主题职责。

## 二、统一主题入口

普通应用只需要提供 `HyperTheme`：

```dart
HyperTheme(
  data: HyperThemeData.light(),
  child: const App(),
)
```

`HyperTheme` 在作用域内统一为滚动控件增加鼠标拖动输入，并保留平台已有的
触摸、触控板、滚轮和滚动条策略。Demo 不再逐页重复配置鼠标拖动；需要不同
交互的子树仍可通过局部 `ScrollConfiguration` 覆盖。

设备类型最终由主题作用域统一协调。Windows、Linux 和 macOS 固定为 desktop；
只有 Android 和 iOS 在启动时区分 phone、tablet 或 watch。测试、预览和特殊设备可以显式指定：

```dart
HyperTheme(
  data: HyperThemeData.light(),
  deviceType: HyperDeviceType.desktop,
  child: const App(),
)
```

业务层不应为了选择控件尺寸编写 `switch (deviceType)`，也不应为四类设备分别构建四套页面。

设备类型表示真实设备类别，不表示当前页面宽窄。自动结果在应用或窗口作用域首次建立时确定，普通窗口缩放、桌面窄窗口和移动端分屏都不得改变设备类型。当前约束只用于独立的页面形态或窗口尺寸等级：桌面窄窗口仍使用 desktop 控件尺寸，但页面可以切换为 compact 布局；平板进入窄分屏后仍使用 tablet 控件尺寸。

## 三、主题职责分离

`HyperThemeData` 集中持有以下强类型主题：

- `colors`：语义颜色。
- `typography`：当前端已解析的语义字号与列表行高；字体族、字重和其他文字样式由 `textTheme` 承载。
- `typographyTheme`：手机、平板、桌面和手表四套强类型字阶；当前端由 `HyperTheme` 解析到 `typography` 与 `textTheme`。组件布局尺寸不保存字号。
- `sizes`：手机、平板、桌面和手表的全部尺寸方案。
- `motion`：动画时长和曲线。
- `materialTheme`：统一表面材质配方、渲染质量和透明度策略。
- 各组件 `ThemeData`：组件视觉、变体和状态配方。

视觉、尺寸和排版相互独立。替换颜色不得改变尺寸，替换尺寸不得改变颜色；设备相关字号由统一排版主题解析，不得写在组件实现中。

### 统一材质契约

`HyperSurfaceMaterial` 是跨组件共用的完整配方。使用材质的控件按实例材质、
组件主题材质、`materialTheme.material` 的顺序选择来源，再由统一质量和减少透明度
策略解析。组件只绘制解析结果，不因引用位置改写背景、色调、模糊、边框、阴影或降级
配方；控件形状、内容布局和交互状态仍由各自组件负责。显式设置的组件背景可覆盖全局
材质背景。玻璃材质的滤镜只绘制背景，前景内容保持在独立的清晰图层。
内置 Hyper 主题默认采用 `advanced` 材质质量；应用可通过强类型
`materialTheme.copyWith(quality: HyperMaterialQuality.standard)` 切换到降级配方，
或设置 `reduceTransparency` 关闭透明与模糊。

`HyperAnchoredOverlay` 负责锚点定位、边缘避让、开合交互与进出场动画，不绘制表面。
`HyperTabBar` 与 `HyperTabBarView` 共用 Flutter `TabController`。默认 `.segmented` 形态共用浅灰底槽，选中项为白色块；`.separated` 形态的每个标签各自绘制圆角表面，标签之间保留间距，选中项为白色、未选中项为浅灰；`.underline` 形态采用普通下划线指示。三种形态在 Demo 中独立展示，共用当前端标签栏高度；手机端为 42dp。独立标签的 12dp 圆角和 9dp 间距参照 [MIUIX `TabRow` 候选值](https://compose-miuix-ui.github.io/miuix/components/tabrow)，底槽圆角暂取 8dp；下划线粗细沿用 Flutter 的 2dp 基准。四端尺寸由 `HyperSizeScheme.tabBar` 分别管理，字号读取 `typography.control`。悬停与按压不叠加深色覆盖层，点击不产生水波纹；选中块或指示线的切换作为状态反馈。
`HyperBreadcrumb` 展示胶囊形路径节点和箭头分隔符，路径节点通过索引回调导航；高亮索引独立于路径列表，默认末级。长路径横向滚动并自动显示高亮项，单项文字超出最大宽度时省略。尺寸由四端 `HyperSizeScheme.breadcrumb` 管理，字号由四端 `typography.breadcrumb` 管理；普通、高亮和禁用胶囊背景及文字样式通过全局 `breadcrumbTheme`、局部 `HyperBreadcrumbTheme` 和实例 `style` 显式覆盖。单项 `enabled: false` 会禁用点击并使用禁用前景和背景。手机端原型参考 [MIUIX BreadcrumbBar](https://compose-miuix-ui.github.io/miuix/components/breadcrumbbar) 的胶囊高 32dp、左右内边距 10dp、最大宽 160dp；经目标截图对照，手机端胶囊高调整为 30 逻辑像素、字号 12、分隔符两侧间距 4 逻辑像素。按各端已有密度微调后的平板、桌面、手表胶囊高分别为 34、26、30，分隔符两侧间距分别为 6、4、4 逻辑像素；这三端属于项目推导，待设备对照。

`HyperBadge` 提供点、数量、短文本和自定义内容；徽标默认配色参考 MIUIX 主题的错误色：浅色 `#E94634`、深色 `#F12522`，文字均为白色；这些颜色由 `HyperBadgeThemeData` 的亮暗默认颜色和实例样式覆盖，不改变全局错误色。数字可限制上限并显示 `99+`。点尺寸、内容高度、圆角、内边距和文字字号由四端 `HyperSizeScheme.badge` 管理。颜色、边框、阴影、文字样式及默认过渡通过全局 `badgeTheme`、局部 `HyperBadgeTheme` 与实例 `HyperBadgeStyle` 覆盖。`HyperBadgeAnchor` 接受任意 Widget 作为徽标，支持左上、上中、右上、左中、正中、右中、左下、下中、右下九宫格位置及物理坐标偏移；`alignment` 可额外指定方向感知的对齐方式；位置与偏移变化使用全局 Motion 过渡，时长和曲线可在实例替换。定位层不规定徽标视觉。手机端点尺寸与内容高度参考 [MIUIX Badge](https://compose-miuix-ui.github.io/miuix/components/badge) 候选实现，其他设备端待视觉核对。
`HyperTag` 是静态分类或状态标签，普通、强调和禁用状态通过全局 `tagTheme`、局部 `HyperTagTheme` 与实例 `HyperTagStyle` 逐字段覆盖；背景、前景、边框、阴影、字体、圆角、尺寸、图标及动画均可配置。四端默认尺寸由 `HyperSizeScheme.tag` 管理，文字读取当前端 `labelMedium` 字阶；状态过渡取全局 Motion 并遵守减少动画设置。Tag 无点击或选择语义，交互标签留给 Chip。默认视觉是项目暂定值，尚无可核实的同场景 MIUIX/HIUI 直接规格。
`HyperWidgetGroup` 排列任意 Widget，可横向或纵向使用；间距和可选分隔尺寸来自四端 `HyperSizeScheme.widgetGroup`，外层背景、边框、圆角、阴影、内边距及分隔视觉由 `widgetGroupTheme`、局部 `HyperWidgetGroupTheme` 和实例 `HyperWidgetGroupStyle` 逐字段覆盖。默认不绘制外层背景或边框，不改变子项点击、焦点或内部样式。组自身的视觉与间距变化使用全局 Motion 并遵守减少动画设置；自定义分隔内容由使用方控制其动画。默认尺寸是按项目同端紧凑布局语义推导的暂定值。
`HyperWidgetGroupItem` 为单项指定宽度或主轴 `flex` 比例；组样式的 `width` 提供明确总宽度，`itemHeight` 为子项统一高度。比例子项需要有限的主轴约束，横向放在水平滚动容器内时应明确设置组宽。`showSeparators: false` 保留空白间距，启用后使用主题线条分隔；`separatorBuilder` 可完全替换分隔内容。
`HyperSlider`、`HyperRangeSlider` 和 `HyperVerticalSlider` 共用四端 `HyperSizeScheme.slider` 与 `sliderTheme`；默认 `HyperSliderVariant.capsule` 使用厚胶囊轨道，`HyperSliderVariant.thin` 使用普通细轨道，两种尺寸都由四端方案解析。局部 `HyperSliderTheme` 和实例 `HyperSliderStyle` 可覆盖轨道、拇指、交互层、数值提示及禁用状态。手机端默认采用用户提供的 HyperOS 音量页截图的厚胶囊轨道、蓝色填充和白色圆心；[MIUIX Slider 源码](https://github.com/compose-miuix-ui/miuix/blob/main/miuix-ui/src/commonMain/kotlin/top/yukonga/miuix/kmp/basic/Slider.kt)中的 28dp 默认高度、胶囊轨道与 0.72 倍半径的圆心作为候选实现参考。单值滑块的拖动、键盘和语义交互沿用 Flutter Slider；范围滑块保留 Flutter 的键盘与语义交互，并在指针拖动中允许两端重合、越过时交换起止角色。垂直版默认从底向顶递增，可显式反转。未做同设备截图复核前不将视觉值视为精确还原。
轨道默认使选中段与未选中段等高；默认悬停状态层透明。鼠标进入整个滑块区域时只让灰色未选中轨道轻微加深，默认目标色可由 `HyperSliderStyle.hoverInactiveTrackColor` 覆盖。指针按下时白色圆心采用与 `HyperSwitch` 相同的默认交互缩放值 1.127，由 `pressedThumbScale` 覆盖，也可替换拇指形状；悬停不会放大拇指。两种过渡取全局 Motion 的快速时长与曲线，系统要求减少动画时不放大。使用方仍可通过 `overlayColor` 和形状字段指定其他交互效果。
`divisions` 指定均匀步进，默认吸附；设置 `showDivisionPoints: true` 显示刻度点，设置 `snapToDivisions: false` 则只保留刻度点并连续取值。刻度点中心沿拇指可移动区间排列，整组裁剪在胶囊轨道内；手机端刻度点半径 3.855 逻辑像素取自 MIUIX 候选值。未选中刻度的低对比度颜色按当前轨道色与语义状态层推导，并非 MIUIX 原色；颜色和半径可通过 `HyperSliderStyle` 覆盖。
`HyperCapsuleSlider` 是整块填充的竖向胶囊样式，可用于音量、亮度等连续数值；顶部和底部接受任意图标 Widget，各自的点击回调与轨道拖动相互独立。单击轨道不改变数值，拖动从当前值连续变化。拖到最上端或最下端后继续外滑，整块胶囊会以较强阻力轻微偏移并缩放，松手以全局 Motion 弹簧的质量、0.65 倍刚度和 1.5 倍阻尼快速归位；组件弹簧参数可完整替换，系统减少动画时关闭此效果。宽度、图标尺寸、内边距与最大偏移量来自四端 `HyperSizeScheme.slider`，颜色、边框、圆角、偏移量、最大缩放与弹簧参数通过全局或局部 `HyperSliderTheme` 及实例 `HyperSliderStyle` 覆盖。默认深灰底与白色填充根据用户提供的局部截图建立候选值，截图缺少设备逻辑尺寸，尚未做同条件精确对照。

胶囊滑块图标默认根据所在位置的填充色检查对比度；低于 3:1 时自动改用黑色或白色。`capsuleAutoIconContrast` 可以关闭该行为，显式设置的顶部或底部图标颜色始终优先。`capsuleTopIconTurns` 和 `capsuleBottomIconTurns` 可让图标按滑块进度旋转，填充和图标共用同一条进度动画。

越界反馈由 `HyperElasticOverscrollController` 管理阻力映射和弹簧回弹，`HyperElasticOverscrollTransform` 绘制水平或竖直方向的位移。已有拖动控件可直接包在 `HyperElasticOverscrollRegion` 中，并传入方向和最大位移；通用包装默认不缩放轨道，需要缩放时显式设置 `maxScale`。包装层监听指针，不修改子控件的进度与手势。需要自定义拖动映射的控件（如 `HyperCapsuleSlider`）直接调用控制器的 `pull` 和 `release`。包装层和胶囊滑块默认使用同一套较快的回弹；重手感由越界拖动的阻力映射提供，回弹弹簧仍可单独替换；系统减少动画时关闭越界效果。
菜单、提示等消费者通过自己的主题选择视觉和材质，不能由浮层底座改写材质配方。
内置菜单、侧栏子菜单和 Tooltip 的浮层表面默认使用统一的高级玻璃材质配方；
实例或组件主题的完整材质、全局 `materialTheme.material` 以及显式背景优先于此默认配方。
材质质量与减少透明度策略仍由 `HyperMaterialThemeData.resolveMaterial` 统一处理。
最简单的使用方式是传入 `anchor` 与 `overlayBuilder`；默认点击锚点开合，
`overlayBuilder` 获得关闭回调。侧栏子菜单可指定 `trigger: HyperOverlayTrigger.hover`
与 `placement: HyperOverlayPlacement.sideEnd`。需要由父级统一管理多个菜单时，
传入 `isOpen` 和 `onOpenChanged`；外部点击、Escape 和返回键仍走同一关闭请求。
基础浮层直接使用最近的 Flutter `Overlay`，页面无需额外安装宿主。
需要把已有按钮或其他自带点击行为的控件作为锚点时，使用
`HyperAnchoredOverlay.builder(anchorBuilder: (context, toggle, isOpen) => ..., overlayBuilder: ...)`；
锚点调用 `toggle`，内容仍可自由组合列表、网格、卡片或其他 Widget。
`placement` 提供 `topStart`、`bottomStart`/`bottomEnd`、`sideStart`/`sideEnd`；
`spacing` 默认取当前端 `HyperSizeScheme.overlaySpacing`，目前为 4 逻辑像素，使用方可以覆盖；
空间不足时自动翻转并限制在可见区域，不要求内容使用特定表面组件。
默认进出场使用淡入缩放，也可选 `HyperOverlayTransition.fade`；内置过渡的时长和曲线读取
全局 `motion.fastDuration`、`motion.fastCurve`，并遵守 `MediaQuery.disableAnimations`。
需要完全不同的效果时传入 `transitionBuilder(context, animation, child)` 替换内置过渡；
动画进度为 0 至 1，使用端可自行选择曲线，底座仍负责开合时长和浮层生命周期。
关闭请求立即停止浮层交互，退场动画结束后再从 `Overlay` 移除。

`HyperSidebar` 的分组、树形项、角标和自定义行通过 `HyperSidebarGroup`、
`HyperSidebarItem` 组合。展开项的标题与可选描述复用 `HyperListTile` 的文字规格。
选中 ID 由页面传入，展开 ID 可由组件管理或由页面受控管理；
父级是否跟随子项选中由 `selectParentWhenChildSelected` 控制，默认关闭。折叠时有子项的菜单行
使用 `HyperAnchoredOverlay` 显示悬停子菜单，浮层的表面和阴影由其中的 `HyperCard`
及其主题控制。普通卡片表面由侧栏提供默认浮层阴影；全局材质或 Card 主题显式提供
阴影时沿用原配方，侧栏主题可通过 `popupCardStyle` 覆盖。头尾保持固定，中间列表独立滚动；宽度和行规格来自四端
`HyperSidebarSize`，视觉与选中样式按全局、局部、实例 `HyperSidebarStyle` 解析。
侧栏宽度与内容淡隐切换使用全局标准动画节奏，树形子项的展开收起与箭头旋转使用全局快速节奏；
两者都遵守系统减少动画设置。`HyperSidebarStyle` 提供 `widthTransitionBuilder`、
`contentTransitionBuilder` 和 `childrenTransitionBuilder`，可由全局、局部主题或实例逐项替换
默认过渡。宽度 builder 接收当前宽度并负责约束侧栏内容；内容 builder 接收 0 至 1 的
可见度；子项 builder 接收 0 至 1 的开合动画，并负责内容出现、消失时的布局过渡。
折叠态浮窗的进出场可通过 `popupTransitionBuilder` 替换，仍由 `HyperAnchoredOverlay`
管理开合与浮层生命周期。

`HyperMenu` 负责弹出菜单的分组、多级操作项、选中与禁用状态。子项通过
`HyperMenuItem.children` 声明，父项悬停或点击展开子菜单；鼠标经过更深层级时
保持已展开的祖先菜单，切换同级项目或点击菜单外才收起对应层级。
方向键上下移动时同步移动真实焦点，右键进入子菜单、左键返回父项并恢复焦点；
Tab 遵循可用菜单项的焦点遍历，Home、End、Enter 和空格键作用于当前层。子菜单的定位、边缘翻转与开合
继续由 `HyperAnchoredOverlay` 负责，过渡可通过 `submenuTransitionBuilder` 替换。
纯鼠标悬停展开子菜单时不抢夺键盘焦点；已展开后改用方向键仍可进入该层。
菜单表面由 `HyperCard` 绘制，完整材质及显式阴影遵守 Card 与全局材质配方；普通表面提供默认
浮层阴影。菜单外框与菜单项圆角分别由四端 `HyperMenuSize.surfaceRadius` 和
`itemRadius` 管理，不随按钮圆角联动。其余菜单尺寸同样来自四端 `HyperMenuSize`，全局 `menuTheme`、局部
`HyperMenuTheme` 与实例 `HyperMenuStyle` 逐项覆盖。菜单项文字取当前端统一字阶，
不另存设备字号。

`HyperMenuButton` 组合 Hyper 按钮、锚定浮层和菜单，统一处理按钮开合与选择后关闭。
`HyperContextMenu` 包裹任意内容，右键或触摸长按时将指针或触点在目标内的局部坐标交给
`HyperAnchoredOverlay.anchorPosition` 定位；菜单键或 Shift+F10 则从目标下方打开。
这些入口共用 `HyperMenu` 的分组、多级项、主题样式和键盘导航。点击菜单外或按
Escape 关闭，子菜单仍共享同一点击区域。

`HyperTooltip` 复用锚定浮层的定位、边缘避让和 Motion 动画，表面由 `HyperCard`
绘制并参与统一材质解析。鼠标悬停延迟显示，键盘焦点进入或触摸长按立即显示；
长按松开后按 `showDuration` 延迟收起。内容只提供说明，不接收点击。可通过 `placement`、
`waitDuration`、`exitDuration` 和 `transitionBuilder` 调整行为与过渡。

`HyperSelect<T>` 是受控单选入口：调用方传入 `value` 和 `onChanged`，
禁用选项不可触发选择。锚点复用 `HyperButton` 的尺寸与样式，弹出的选项复用
`HyperMenu` 的焦点导航、主题和浮层材质；方向键可从锚点打开，选择或按 Escape
关闭后将焦点返回按钮自身。`HyperButton.focusNode` 支持这种组合场景，节点由调用方释放。
锚点宽度、箭头尺寸和间距来自四端 `HyperSelectSize`；前景、箭头和选中底色
由全局 `selectTheme`、局部 `HyperSelectTheme` 与实例
`HyperSelectStyle` 逐层覆盖。显式 `buttonStyle` 和 `menuStyle` 最后覆盖各自底层控件。

`HyperPopupListTile<T>` 将 `HyperListTile` 与锚定模态选项列表组合。整行显示
当前值和上下双箭头，打开时使用语义遮罩；弹窗以尾部上下箭头图标为锚点，并在上下空间不足时翻转、限制在安全区域。弹窗复用 `HyperMenu` 的焦点、禁用和选中
状态。弹窗选项行高默认取当前端 `HyperListTileSize.minHeight`，紧凑行取
`compactMinHeight`，`menuStyle.itemHeight` 可显式覆盖。宽度按选项文字和图标测量，
由四端 `HyperPopupListTileSize` 限制最小和最大值，实例可覆盖边界或指定固定宽度。
弹窗表面内边距与选项文字内边距独立；默认行高、内边距、圆角、选中背景和文字颜色统一继承同端 `HyperMenu` 尺寸与主题，与 Select / Autocomplete 保持一致。ListTile 的 density 只影响主列表行，不影响选项行高；`menuStyle` 可显式覆盖弹层选项。此统一基于项目现有同端菜单语义（D 级，逻辑像素），未从截图像素推导尺寸。
默认过渡从靠近列表项的弹窗角开始缩放、淡入并按打开方向逐步揭示，退场反向收起；
缩放取全局 Motion 弹簧，时长与淡入曲线取全局 Motion，减少动画时直接显示。
`transitionBuilder` 可替换默认过渡。选择后关闭并将焦点返回列表项。

## 四、集中式多端尺寸

`HyperSizeThemeData` 保存四套明确方案：

```text
HyperSizeThemeData
├─ phone: HyperSizeScheme
├─ tablet: HyperSizeScheme
├─ desktop: HyperSizeScheme
└─ watch: HyperSizeScheme
```

`HyperThemeData.sizes` 始终表示这份四端全局配置。组件通过
`HyperTheme.sizesOf(context)` 读取作用域建立时已解析的当前端方案，
不得自行查询平台或窗口尺寸。

`HyperSizeScheme` 除页面边距、区块间距、最小命中区域等公共尺寸外，还持有各组件的强类型尺寸对象：

```text
HyperSizeScheme
├─ appBar: HyperAppBarSize
├─ drawer: HyperDrawerSize
├─ sidebar: HyperSidebarSize
├─ menu: HyperMenuSize
├─ select: HyperSelectSize
├─ button: HyperButtonSize
├─ iconButton: HyperIconButtonSize
├─ progress: HyperProgressSize
├─ switchSize: HyperSwitchSize
├─ slider: HyperSliderSize
├─ checkbox: HyperCheckboxSize
├─ radio: HyperRadioSize
└─ 后续组件尺寸
```

组件尺寸值对象必须不可变，并实现 `copyWith`、值相等和需要时的 `lerp`。设备规格使用明确值，不通过手机尺寸乘倍率生成其他平台尺寸。

确定组件默认值时，先查 Flutter 的约束与交互标准，再按[设计基准](hyperos-design-baseline.md)
核实适用的 HyperOS 官方资料、目标设备和第三方 MIUIX 候选值，最后按 Lemon UI
的主题职责选值。截图用于检查最终视觉关系；设备逻辑尺寸、显示缩放或像素密度
未确认时，不从截图物理像素差推算组件的 dp 或字号。参考来源与最终取值不同时，
在尺寸规格中记录原因。

### 组件实现边界

- 组件内部不得保存 phone、tablet、desktop 或 watch 的尺寸常量。
- 组件内部不得通过 `switch (deviceType)` 选择尺寸。
- 同一个默认尺寸只能在尺寸主题中存在一份；Demo、测试和组件实现不得复制为另一套默认来源。
- 组件只读取主题已经解析出的当前设备尺寸，并负责布局、绘制、状态、交互、动画和语义。
- 全局尺寸主题负责四端差异；局部主题和实例 Style 只覆盖当前解析结果。

## 五、系统级 `copyWith`

公共主题覆盖统一采用 Flutter 风格的 `copyWith`：

```dart
final base = HyperThemeData.light();

final custom = base.copyWith(
  colors: base.colors.copyWith(
    primary: const Color(0xFF6750A4),
  ),
  sizes: base.sizes.copyWith(
    desktop: base.sizes.desktop.copyWith(
      button: base.sizes.desktop.button.copyWith(
        minimumSize: const Size(52, 40),
      ),
    ),
  ),
  buttonTheme: base.buttonTheme.copyWith(
    filled: HyperButtonStyle(
      background: const HyperFill.color(Color(0xFF6750A4)),
    ),
  ),
);
```

不再建立面向使用者的 `Overrides`、字符串 Map、动态注册表或另一套补丁 API。内部解析可以使用 `merge`，但系统级自定义入口统一为 `copyWith`。

`null` 统一表示继续继承。需要清除属性时使用明确值，例如 `BorderSide.none` 或空阴影列表；不能让同一个 `null` 同时表示继承和删除。

## 六、全局、局部和实例覆盖

全局主题保存完整的多端尺寸和组件视觉主题。局部组件主题只作用于当前子树，不保存四套设备配置，也不重新判断设备：

```dart
HyperButtonTheme(
  data: HyperButtonThemeData(
    style: HyperButtonStyle(height: 44),
  ),
  child: child,
)
```

实例 Style 以调用方便为优先，可以同时覆盖尺寸和视觉：

```dart
HyperButton.filled(
  onPressed: submit,
  style: HyperButtonStyle(
    height: 48,
    background: const HyperFill.color(Colors.green),
  ),
  child: const Text('提交'),
)
```

以 Button 为例，固定解析顺序为：

```text
当前设备的 HyperButtonSize
→ 全局 HyperButtonThemeData 公共样式
→ 全局所选变体样式
→ 局部 HyperButtonTheme
→ 实例 HyperButtonStyle
```

## 七、强类型命名

统一采用以下命名职责：

- `HyperThemeData`：完整应用主题。
- `HyperSizeThemeData`：四端尺寸集合。
- `HyperSizeScheme`：某一设备的完整尺寸方案。
- `HyperXxxThemeData`：组件视觉、变体和状态主题。
- `HyperXxxStyle`：组件局部或实例覆盖值。
- `HyperXxxSize`：组件尺寸值对象。
- `HyperXxxTheme`：局部主题 Widget。

不得使用 `Map<String, dynamic>`、字符串键或万能组件样式代替明确类型。保留自动补全、编译期检查、重构能力和值语义。

## 八、组件实现规则

组件行为和公开接口稳定后，应主动把需要跨页面统一调整的可配置项收归强类型主题模板：
设备尺寸写入四端 `HyperSizeScheme`，视觉与排版写入对应组件 `ThemeData`；局部主题和
实例 `Style` 只覆盖显式提供的字段。新增配置时同步维护 `copyWith`、插值、值相等、
Demo 和主题覆盖测试。父布局能直接控制的外边距等组合属性不因“可配置”而重复加入
组件主题。

- 组件以 Flutter 原生 Widget 自由组合为优先；只有基础组件无法准确表达时才局部自绘。
- `HyperText` 等包装控件保持轻量，只负责语义样式、主题接入和参数转发，不承担额外布局或视觉偏移。
- 插槽对 `Text`、Hyper 控件和任意外部 Widget 使用相同约束，不通过 runtimeType 特判子控件。
- 异步状态、交互状态和内容变化默认保持组件外部尺寸稳定。
- 所有动画读取统一 Motion 主题并遵守 `MediaQuery.disableAnimations`。
- 所有必要的键盘、焦点、RTL、文字缩放和 Semantics 行为必须保留。

## 九、根因与责任边界

缺陷修复前必须确认真实来源。现象出现在某个组件中，不代表缺陷属于该组件；字体、子控件、父约束、主题、尺寸系统、状态或绘制问题应在各自责任层修复。

不得在表现问题的组件中持续增加固定偏移、Transform、类型特判、重复包装或兼容补丁。Demo 不承担修复职责，不得通过替换 child、手写 Padding 或页面专用参数绕过公共问题。修复完成后必须清理试探性代码和失效路径。

## 十、测试契约

主题测试至少覆盖：

- 手机、平板、桌面和手表的默认规格。
- `copyWith` 只改变目标字段，未修改字段保持不变。
- 设备解析选择正确的 `HyperSizeScheme`。
- 颜色变化不影响尺寸，尺寸变化不影响颜色。
- 全局、局部和实例覆盖的固定优先级。

组件测试优先验证最终 RenderBox 尺寸、几何位置、颜色、边框和交互状态，不只断言中间配置对象或包装层。Demo 负责展示默认、主题和实例覆盖效果，但不是组件细节测试的替代品。

## 十一、冻结决策

以下决策不因主题类或尺寸类逐渐增大而重新讨论：

1. 主题采用集中式强类型结构。
2. 主题和尺寸值对象统一提供 `copyWith`。
3. 所有设备尺寸集中管理，组件不持有设备尺寸。
4. 视觉主题、尺寸主题和排版主题相互独立。
5. 全局主题管理多端规格，局部主题只覆盖当前环境。
6. 组件只消费解析结果并实现自身行为。
7. 主题类随组件增加而变大是可接受且可预测的成本。

HyperAvatar 与 HyperAvatarGroup 共用 avatarTheme、局部 HyperAvatarTheme 与实例 HyperAvatarStyle；四端小/中/大尺寸由 HyperSizeScheme.avatar 管理。文字取 labelLarge 字阶，图片加载中与失败时回退到自定义内容、文字或图标。头像组提供 horizontal 重叠排列、row 无重叠排列、vertical 纵向堆叠、circle5 五角环绕、centered 中心环绕、grid4/9 宫格、mosaic 紧凑拼图与 custom 自定义布局，数量上限包含溢出位置，+N 可自定义；布局位置与尺寸变化取 Motion 主题，遵守减少动画设置。在线状态与计数使用 HyperBadgeAnchor 组合。

头像组通过 groupSize 或主题 HyperAvatarStyle.groupSize 指定整体宽高，布局保持比例并居中容纳；内部头像、字体、图标、描边和间距跟随可用空间缩放。mosaicShape 支持圆形与圆角方形拼图，mosaicColumns 指定拼图列数。自定义 layoutBuilder 返回 HyperAvatarGroupGeometry，声明参考画布与正方形 slots；组件验证位置处于画布内，并按整体尺寸缩放。头像组无重叠排列间距由四端 avatar.spacing 管理（phone/tablet 6，desktop/watch 4 逻辑像素，项目暂定）。

HyperAvatarGroupLayout.blended 与 HyperBlendedAvatar 提供可选的抽象群组标识。优先使用显式 colors/blendColors，否则对每个图片头像首帧进行 32×32 色彩采样，按量化像素频率估算主色，忽略透明像素；未加载或失败时使用头像背景作为回退色。仅在图片来源变化时重建采样，离开组件后移除 ImageStream 监听并释放采样资源。该算法取统计主色，不能保证与人工判断的视觉主色相同。所有成员颜色形成首尾连续的 SweepGradient；blendRotation 与 blendGradient 可通过头像主题和实例替换。混色聚合全部成员，不使用 maxVisible 和 +N；中心可传入自定义内容。宫格与拼图输入未满时保留未占用位置，空列表不绘制头像。Demo 展示五色混合、图片取色及未满宫格。

混色默认通过 blendSoftness=0.45 向当前主题 surface 色柔化，以减少高饱和色的视觉重量；0 保留原主色，blendTintColor 可替换柔化色，显式 blendGradient 可完整替换配方。HyperAvatarGroupLayout.windmill / HyperAvatarStyle.blendVariant.windmill 使用圆角方底上的彩色花瓣风车：每个主色生成一片贝塞尔曲线花瓣，独立渐变和亮边形成旋转叠放效果，默认柔化比例为 0，保留主色；smooth 仍为 0.45。blendPadding、blendPetalBorder、blendRotation 与 blendGradient 可配置花瓣视觉，外层背景与圆角由已有主题字段管理，blendShapeBorder 可替换外框形状。配方与叶片路径为项目设计，并非已核实的 HyperOS 官方规格。Demo 保留原色、柔和与风车三种对照。风车的立体渐变使用同色相亮暗变化，默认不向白色或表面色混合。

风车花瓣内端停在圆心外侧，自然围出透明空洞。每瓣减去下一瓣的重叠区域以实现首尾循环搭接，不对圆心做裁剪、覆盖或清除。每瓣具有独立渐变、高光边缘与位于自身内部的搭接阴影；blendPetalShadowColor/Blur 可覆盖阴影，blendPetalBorder 可覆盖亮边。五瓣和七瓣的离屏像素验证确认圆心透明且花瓣区域可见。

## 分段按钮

`HyperSegmentedButton<T>` 接受 `HyperSegment<T>` 列表与受控 `selected` 集合。
默认单选且不可清空；`multiSelectionEnabled`、`emptySelectionAllowed` 分别控制
多选和清空。禁用项和整体禁用不发出回调；新集合不可修改，调用方负责更新状态。
值必须唯一，选中值必须存在于列表。选中语义与单选互斥语义附着在各按钮上，
鼠标、键盘、焦点和禁用交互复用 HyperButton/HyperPressable。

全局 `segmentedButtonTheme`、局部 `HyperSegmentedButtonTheme`、实例
`HyperSegmentedButtonStyle` 逐字段覆盖。`group` 复用 HyperWidgetGroupStyle，
`button`、`selectedButton` 复用 HyperButtonStyle；连接布局接管边框、圆角和阴影，
不允许内部按钮重新绘制接缝外框。背景填充、材质、字体、图标、状态层、动效、
分隔线与外框沿用已有强类型视觉接口。动画与减少动画策略由复用组件处理。

四端尺寸直接读取 `HyperSizeScheme.button` 与 `widgetGroup`，不增加重复设备常量。
默认基础高度与同端按钮一致；横向支持内容宽度、指定项宽度/比例和 expanded 等分，
纵向按内容收紧。默认选中背景 surfaceMuted，前景 textPrimary，采用中性色；
需要品牌强调时可通过 selectedButton 覆盖背景与前景。
本组件暂未取得同场景官方逻辑尺寸或截图验证，视觉为 D 级同端语义推导；
参考入口为 https://github.com/XiaoMi/hiui 。Demo 位于选择控件。

## 带内容的分隔线

HyperDivider / HyperDivider.vertical 的 child 接受文字、图标或自定义组件。
HyperDividerStyle.contentAlignment 为 start / center / end；start/end 在横向遵守 RTL，
纵向对应顶部/底部。contentGap 为内容两侧间距，edgeExtent 为非居中模式的短线长度。
文字、图标大小和颜色支持全局 dividerTheme、局部主题和实例 Style；copyWith、
merge、lerp、值相等均覆盖内容字段。线条与文字样式使用全局 Motion fast 连续过渡，
系统减少动画时关闭。线条装饰不朗读，child 保留原有语义和交互。

带内容时主轴需要有限约束，或者显式 length；外部留白由父布局负责。
四端 contentGap/edgeExtent/iconSize 为 D 级同端紧凑间距和图标语义推导：
phone/tablet 8/16/18，desktop 8/16/16，watch 6/12/16（Flutter 逻辑像素），
未完成同设备截图对照。原有粗细、虚线和点线尺寸保持不变。
绘制裁剪到分隔线边界，避免末端圆点越界；零步长不会产生无限绘制循环。

## 文本输入与尾部错误

HyperTextField 复用原生 TextField，不接管输入法、光标、选择区和格式化职责。
controller 与 initialValue 互斥；内部创建的 controller/focusNode 由组件释放，
外部传入的由应用释放。readOnly 不提供清空操作，enabled 禁用编辑和尾部操作。
校验由应用提供 errorText，不是 FormField；不自动执行网络验证。

错误不传入 InputDecoration.errorText，不插入底部辅助行；计数也放在尾部。
reserveErrorSpace 默认不预留错误图标位，可显式设为 true 预留；清空和密码操作有固定独立区域。
详情浮层保持稳定元素位置，错误消失先关闭浮层；尾部宽度平滑展开/收起，
图标以轻微缩放和淡入淡出切换，固定纵向占位，不因错误切换增加行高。
保留最后一条详情仅用于浮层退出动画，不保留业务校验结果。
错误文本与 invalid 语义传给屏幕阅读器，尾部错误操作支持鼠标悬停、点击和键盘激活。

全局 textFieldTheme、局部 HyperTextFieldTheme、实例 HyperTextFieldStyle 覆盖显式字段。
状态为普通→hovered→focused→error→disabled，实例最后覆盖。
背景填充/材质、边框、阴影、排版、尺寸、图标、光标、计数与错误浮层均强类型配置。
错误浮层表面复用 HyperCardStyle，errorBuilder 完全替换内容；
transitionBuilder 替换图标过渡，errorTransitionBuilder 替换浮层进出场。
动效沿用全局 Motion fast 并遵守减少动画。

四端规格由 HyperSizeScheme.textField 管理；默认最小可见高度按同端基础控件推导。
手机/平板未获取同场景 HyperOS 官方逻辑尺寸，HiUI Input 官方页面与源码入口本次未能读取，
因此数值记录为 D 级项目语义推导，不称为官方规范；需要设备对照。
默认错误状态不改变高度配置；大字号、多行、自定义内容和状态尺寸覆盖仍遵守正常布局。
用法见 usage/input.md。

## Notification 通知卡片

`HyperNotificationThemeData` 独立管理通用、已读、未读及交互状态样式；`HyperNotificationStyle` 提供强类型复制、合并、插值和值相等。尺寸集中于四端 `HyperSizeScheme.notification`。通用样式之后依次覆盖阅读状态、悬停、焦点、按压、禁用，实例覆盖最后应用。

卡片仅负责呈现与交互回调，日期格式化、数据、已读状态、显示状态和通知列表由上层管理。默认继承统一材质配方、质量及透明度策略，渲染复用 HyperMaterialSurface；不建立组件独立材质开关。状态动效来自 Motion，显隐过渡可替换。

## 通知中心（业务组合）

通知中心不再属于公共组件。示例页面自行管理分组、未读计数、列表与批量操作，复用单条 HyperNotification、按钮和空状态。旧专属 ThemeData 与 Size 模板已经移除，详见 usage/notification-center.md。

## Collapsible / Accordion（2026-10-05）

collapsibleTheme / accordionTheme 与 sizes.collapsible / sizes.accordion 独立强类型存储。面板解析通用、展开/收起、禁用后，再合并实例 Style；组只管理展开规则、项间距和可选分隔线，itemTheme 管理子面板视觉。两者不读取 Card 主题。

父级持有 expanded / expandedIds，纯 HyperAccordionSelection 验证唯一 id、互斥模式和有效展开集合。内容生命周期底座负责连续反向动画、完全关闭后的卸载或保留、收起时即时交互隔离。动画使用 Motion 与减少动画策略，公开 transitionBuilder 可替换内容视觉；横向内容的宽度约束由调用方负责。

表面继承统一材质配方、质量及减少透明度配置，渲染降级复用 HyperMaterialSurface，不自建默认材质开关。

## Pagination（2026-10-05）

paginationTheme 与 sizes.pagination 独立强类型存储，支持复制、合并、插值和值相等。分页主题只管理自身间距、导航图标和文案，以及普通、选中、导航按钮的 HyperButtonStyle；按钮状态、焦点、键盘、材质与动画复用按钮职责，不自建交互或材质路径。当前页禁用重复请求并保留明确选中配方。

HyperPaginationModel 负责输入合法性、页码窗口与省略号；组件仅发出 onPageChanged，调用方负责数据加载和页数变化后的当前页修正。Wrap 适应可用宽度，不改变设备分类。数据为空使用 currentPage 0，非空页码从 1 起始。

## StepIndicator 与 navigation 模式（2026-10-05）

步骤展示与导航统一使用 stepIndicatorTheme / HyperStepIndicatorTheme。导航叠加 navigationStyle 与对应状态字段；四端尺寸为 sizes.stepIndicator.navigation。公共 Body 接收已解析主题与尺寸，不判断设备类别。

纯 HyperStepModel 校验索引与 id，推导 pending/current/completed，并支持显式 error 和 disabled 状态。页面负责实际导航、流程校验与提交；Indicator 仅呈现，Navigation 仅发出请求。主题通用字段、状态字段、实例字段、单项字段依次合并。

统一材质策略管理节点配方、质量及减少透明度；节点渲染复用 HyperMaterialSurface。公共底座管理节点、连接线、文字及符号过渡，交互复用 HyperPressable，动画与减少动画取统一 Motion。

## Timeline（2026-10-06）

timelineTheme / sizes.timeline 独立强类型存储。全局、局部、实例和单项样式逐字段覆盖；状态主题只提供语义外观，不持有日期或业务状态。HyperTimelineModel 固定输入列表、验证唯一 id、处理展示反转与整组对侧列预留。

时间线与步骤组件是不同的数据职责和布局语义，不读取 stepIndicatorTheme；仅复用统一文字、材质与 Motion 基础设施。轨道宽度统一由当前解析后最大节点尺寸决定，以保持混合节点和对侧内容时连接线连续。父级提供有限宽度及外部滚动；反转不做日期排序。

默认圆点继承统一材质配方、质量与减少透明度，复用 HyperMaterialSurface。自定义节点由调用方负责自身视觉，时间线仅提供槽位与图标主题。

## Timeline 点线状态（2026-10-08）

按用户指定方向调整节点与连线，属于项目定制外观，不宣称来自官方规格。
四端 nodeSize、lineThickness 与 nodeLineGap 统一由 HyperSizeScheme.timeline 管理；
Style 的 nodeLineGap 可局部覆盖，highlightLine 默认 false。
开启后当前节点的出线跟随节点状态语义色，normal / disabled 保持 lineColor；
末项不绘制连线，反转只改变展示顺序。节点状态填充绘制在材质表面之上，
避免材质背景遮住状态颜色；颜色过渡沿用 Motion 与减少动画设置。

## 描述列表（2026-10-08）

HyperDescriptionList 的全局视觉使用 descriptionListTheme，四端尺寸使用 HyperSizeScheme.descriptionList。局部主题与实例 Style 覆盖当前解析结果，item Style 仅参与单项视觉与标签布局。响应式列数依据父级有限宽度，不重新判断设备；跨度按实际列数限制，空尾列不扩张前项。自然行高用于少量描述信息，不承担大数据虚拟滚动。材质沿用统一 HyperMaterialTheme 与 HyperMaterialSurface，动效沿用 Motion 和系统减少动画。

## Result（2026-10-09）

HyperResult 展示调用方控制的 neutral/success/error/warning/info 状态，不管理加载、请求、重试、导航与自动关闭。全局 resultTheme、局部 HyperResultTheme 和实例 Style 逐字段合并，状态 Style 叠加通用 Style；文字字段深合并。四端 sizes.result 管理基础尺寸，空内容使用其 empty 变体。材质、质量与降级继承统一 HyperMaterialTheme，表面复用 HyperMaterialSurface；前景边框与外部阴影不会被材质遮盖。默认过渡沿用 Motion 与减少动画策略，transitionBuilder 可替换内容过渡。父级负责页面滚动与安全区。

## PageIndicator（2026-10-09）

全局 pageIndicatorTheme、局部 HyperPageIndicatorTheme 与实例 Style 逐字段合并；四端 sizes.pageIndicator 独立管理点径、选中宽度、间距和内边距。PageView 使用零起始索引，因此 currentIndex 独立于 Pagination 的一开始页码。纯模型只验证数据与计算有限窗口，不读取设备、修改当前页或绑定控制器。可点击模式复用 HyperPressable，触控槽位继承当前统一 minimumInteractiveDimension；只读与数字模式不创建无效焦点。材质与降级统一由 HyperMaterialTheme/HyperMaterialSurface 管理，外层边框和阴影独立于材质填充。默认 Motion 与减少动画设置覆盖圆点尺寸、填充及数字过渡。

## 统一导航行间距与 Tree（2026-10-10）

HyperSizeScheme.navigationItemSpacing 默认 4，作为菜单、Sidebar 和树的行间距语义值；对应 menu.itemSpacing、sidebar.rowGap、treeView.rowSpacing 可空覆盖，null 继承公共语义，0 显式紧贴。Sidebar.itemSpacing 是行内图标/文字间距，不能混同。全局尺寸通过强类型 copyWith 修改公共语义即可同时影响三个组件；局部和实例 Style 优先。

HyperTreeController<T> 管理展开、单选、子节点缓存和异步加载状态；视图只负责布局、交互和反馈，不承担网络协议或导航。请求按 id 去重并登记后通知，数据替换用 generation 忽略旧响应，销毁后不写入或通知。请求结果全局验证 id 后一次性写入，失败可重试，空结果成为叶节点。children 的静态快照与加载缓存独立，加载完成不会反转用户收起意图。

全局 treeViewTheme、局部 HyperTreeViewTheme 与实例 Style 按字段覆盖；四端 sizes.treeView 独立存储。材质与降级复用统一基础设施，动效沿用 Motion/减少动画，展开过渡与反馈过渡均可替换。父级负责有限宽度、外部滚动与控制器生命周期。本阶段为自然高度的中小规模树，不承诺虚拟滚动。

## Select / Autocomplete（2026-10-10）

2026-10-11：Menu 与 Select 的浮层表面统一由 hyper_menu_surface 解析，恢复原菜单玻璃配方及阴影。
组合面板只嵌入 Menu 内容，外层负责唯一表面；高级质量、透明度和降级继续由统一材质主题管理。

共用 HyperSelectField 宿主、HyperSelectOptionsController 查询模型和 HyperSelectPanel；模型不管理编辑器、业务选择与路由。Dropdown 在面板内搜索，Autocomplete 在主输入框搜索，模态时同步编辑器。共用 selectionTheme / HyperSelectionTheme，Autocomplete 独立 autocompleteTheme；Dropdown 的 selectionStyle 嵌入现有 DropdownMenuStyle。配置强类型合并、插值、相等；四端额外尺寸统一存储于 sizes.selection。输入、按钮、Chip、菜单、表面、模态路由和高级材质沿用现有基础设施。Menu 外部导航控制器允许编辑器保留焦点，selectedIds 统一多选的视觉和语义。

选择受控，分页/查询不清除选中值；标签缓存只保留当前结果和已选值。异步请求按 generation 忽略过期结果，追加失败不提交页面，游标须前进且不循环。来源替换时销毁旧控制器，视图卸载后关闭所属模态路由。adaptive 依据稳定真实设备类别解析，不按窗口尺寸重分类；显式 presentation 优先。PopupListTile 保留原尾部布局/弹出动效，模态复用共用 presenter，避免新增重复列表控件。

## 顶部导航（2026-10-12）

HyperTopNavigation 复用 HyperMenuItem 的树结构与 HyperMenu 多级浮层，叶项通过受控 selectedId / onSelected 请求切换，父项只展开菜单。选中后代映射到顶层选中提示。全局 topNavigationTheme、局部 HyperTopNavigationTheme 与实例 Style 逐字段合并；四端 sizes.topNavigation 独立管理顶层尺寸，子菜单继续使用 sizes.menu。顶层按钮、浮层、材质、焦点和动画复用现有基础设施。Menu 项新增 description，描述文字及间距可通过 Menu Style / Size 配置，各级菜单一致继承。

默认顶层尺寸由同端现有 Button 规格推导，属于项目语义推导（D 级，逻辑像素）；子菜单直接沿用现有 Menu。未依据截图物理像素反推尺寸，尚未完成官方视觉对照。外部表面、布局和页面内容由调用方管理，空间不足时顶层横向滚动。

## 共享虚线边框

分割线和 HyperDashedBorder 共用 hyperPatternSegments 计算线段和点线间隔；直线矩形与闭合圆角路径分别消费同一分段结果，不再重复计算。Button 通过 Style.boxBorder、TextField 通过 Style.border、Card / Menu 通过表面 Style.border 配置统一 BoxBorder。显式空 Border 关闭边框。自定义 BoxBorder 插值走 ShapeBorder.lerp，标准边框继续复用 Flutter BoxBorder.lerp；HyperBoxDecoration 仅适配自定义边框的插值，背景、渐变、圆角与阴影沿用 Flutter 插值，避免动画期间把虚线退化为实线或抛异常。

## 共用 HyperLine 与按钮尺寸档位

HyperLine 是与 HyperFill 配合的不可变线条样式对象，统一填充、粗细、线型、线段长度、间隔与端部圆角，支持 copyWith、插值和值相等。HyperDivider.line / HyperDividerStyle.line 和 HyperLine.toBorder() 复用同一对象；HyperDividerPattern 保留为 HyperLinePattern 的类型别名，旧参数继续转换为共用线条。HyperDashedBorder 仅保留便捷构造入口，绘制与插值集中于 HyperLineBorder，分段算法不重复。HyperLine 演示登记未确认；展示尺寸和默认颜色直接沿用 Divider 的同端语义规格（D 级、逻辑像素），没有改变现有默认外观。

HyperButtonSize 的三档最小宽度与可选固定宽度集中于四端 sizes.button；新增默认最小宽度沿用对应设备已存在的按钮最小宽度，未引入组件内设备常量。实例 Style.width / minimumSize 优先。固定和自适应模式的约束由布局直接解析，AnimatedSize 负责实际有限布局尺寸过渡，避免 AnimatedContainer 在有限与无界 BoxConstraints 间插值；颜色、边框、阴影过渡保留现有 Motion 配置。

## Button 交互变换（2026-10-13）

HyperButtonStyle 的 hoveredOffset / focusedOffset / pressedOffset 与 hoveredScale / focusedScale / pressedScale 是显式状态覆盖，默认全部为空。位移 0、缩放 1 表示原始绘制；不存设备尺寸常量。变换放在 HyperPressable 的可视子树内，Transform.transformHitTests 为 false，布局与命中区域保持原位。按下状态优先，禁用与系统减少动画时恢复原始绘制。时长和曲线使用已有按钮样式与 Motion。减少动画时跳过 AnimatedSize，避免零时长尺寸动画在布局过程中重入。

## Select 工作区规格（2026-10-13）

HyperSelectSize 的可选 popupSpacing、itemHeight、itemPadding、itemSpacing、itemRadius、surfaceRadius 用于四端选择器独立规格；未设置时继承同端公共浮层和菜单语义。全局与局部 HyperSelectThemeData.style.buttonStyle 覆盖触发按钮，实例 buttonStyle 最后覆盖。Select 将当前设备规格转换为 selectionStyle.menuStyle 后逐层合并，选项面板沿用公共表面解析和统一材质降级。Autocomplete 不读取这些 Select 专属菜单规格。默认值保持现有语义来源，未新增独立设备常量。

## 多选紧凑标签与局部锚点（2026-10-13）

Select / Autocomplete 的摘要 Chip 和 +N 共用按外层已解析规格推导的紧凑样式，避免重复的独立触控留白撑高输入框；实例 Chip Style 仍优先。标签区不足以放下完整首项时，按实际文字缩放后的首字宽度、内边距和删除区域决定能否显示缩略首项与计数；更窄时只显示计数，保留最小输入宽度。干布局与实际布局使用同一条件。PopupListTile 的坐标、边界和弹窗路由统一使用 HyperNavigatorScope 选中的 Navigator / Overlay，跨路由保留调用处主题，避免嵌套预览中的锚点偏移。

TextField 的 minimumHeight 是外部表面最小高度；普通边框厚度从内部最小约束中扣除，尾部操作与前缀只使用内容区高度，避免重复叠加边框及留白。默认输入与占位行高明确保留控制文本语义，避免继承 Material 正文行高；显式 TextStyle 仍优先。Select / Autocomplete 文本变化与光标变化分开处理；鼠标选择关闭释放焦点，键盘关闭恢复触发焦点，关闭回调重复通知不再次修改焦点。

TextField 的表面最小高度由外层 ConstrainedBox 管理，单行文本区域通过 Align 居中，多行默认顶对齐，显式 textAlignVertical 优先；不把表面最小高度传入原生 InputDecorator 的内部约束，避免其布局高度与对齐计算高度不一致。Autocomplete 默认输入表面使用当前主题 surface（亮色为白色），显式 TextField 局部背景、Autocomplete inputStyle 与实例 inputStyle 仍可覆盖。

Select 与 Autocomplete 的多选摘要标签统一从 textField 内容区规格推导紧凑高度，不再分别读取按钮与输入框留白。缩略标签的最小宽度包含至少一个实际字形和省略号及删除区域；无法容纳时仅显示数量，避免空标签只剩删除图标。测试同时比较两种标签的实际高度和自动填充表面的垂直中心。

Select 的可选设备触发圆角 select.radius 同时作为 Autocomplete 单选与多选触发输入框的默认圆角；未设置时继续继承 TextField 圆角。Autocomplete 主题 inputStyle 和实例 inputStyle 的显式圆角优先；模态面板内的搜索框不读取触发圆角。

PopupListTile 关闭后的焦点恢复依据打开来源：鼠标和触摸打开的面板关闭后释放触发行焦点，键盘方向键、Enter 或 Space 打开时恢复触发焦点。不以桌面传统高亮模式代替实际输入来源。锚定面板与底部弹窗共用该策略，延迟恢复前检查 mounted 与是否已重新打开，避免覆盖下一次交互。

## HyperDropdown 自定义内容下拉（已确认）

panelBuilder(context, close) 提供任意面板内容，组件只管理触发、开合、设备呈现、边界与表面。过滤数据、选择和多级业务由调用方管理；可组合 HyperMenu 的子菜单。默认样式及设备规格复用 Select / Selection 主题，局部与实例显式覆盖优先；面板复用 resolveHyperMenuSurface 及统一材质降级。Desktop 使用锚定浮层，其他设备复用 Select 呈现解析。用户明确确认后，Demo 已移入正式“选择控件”分类，页面 id hyper-dropdown 保持不变，工作区复用 Select 配置入口；未进行目标截图视觉还原。

Tag 与 Chip 的标签配色由 foundation/hyper_label_palette.dart 统一解析，组件各自通过强类型 Style 公开基色、配色方式和背景/边框/前景减淡比例。Tag 的 background 与 boxBorder 分别复用 HyperFill 和公共线条边框；原 backgroundColor、borderColor、borderWidth 保持兼容，显式背景颜色覆盖上层填充。Tag 全局、局部主题和实例覆盖保留原有优先级，尺寸继续由 HyperSizeScheme.tag 管理。


## 基础控件工作区与中央几何扩展（2026-10-14）

Badge / Divider / Progress / Radio / Checkbox / Switch 的编辑覆盖见 [主题编辑器](theme-editor.md)。颜色与动效按亮暗外观存储，尺寸仍通过四端 HyperSizeScheme 的强类型 copyWith 统一管理，编辑器没有在组件中保存设备规格。Radio 增加可选命中、标记及圆角几何；Checkbox 增加可选命中与圆形圆角；Switch 增加可选命中、圆角和滑块偏移；Progress 增加可选线性长度、轨道/填充圆角和无限线宽；Divider 增加可选长度、两端缩进与圆角。字段为空时保留原默认推导，无跨端倍率或新机型规格。copyWith、插值、值相等和哈希纳入四端纯主题回归检查。

Divider 的稀疏 TextStyle 覆盖现在按字段合并，字重/行高覆盖不会丢失默认字体和颜色。组件默认文字缩放策略不变；新增设置尚未完成渲染或设备审核。

带内容分割线只绘制一个完整线条表面，内容与两侧 contentGap 的区域在绘制时透明裁切；不使用背景色遮挡，不把渐变和虚线相位按两段重新起算。所有内容位置沿完整线条的渐变坐标采样，不自动镜像；对称配色由使用方添加颜色节点实现。布局仍使用内容实际尺寸并遵守文字缩放。


## Windows UI 无障碍安全边界（2026-10-15，临时）

用户授权先排除无障碍以规避 AXTree 原生崩溃。`HyperSemanticsGuard` 位于库公共 UI 层，由 HyperTheme 的 UI 根和可独立使用的滑块统一应用，Demo 与业务应用复用；不是编辑器专用处理，也不修改主题视觉数据、组件尺寸或交互状态。实际宿主为原生 Windows 时排除组件语义，Web 与其他宿主保留。范围内的键盘焦点、快捷键、鼠标和触摸保留。

普通 / 范围滑块内部 OverlayPortal 的指示器以局部 Overlay 留在排除边界内，纵向滑块复用普通滑块路径；胶囊滑块直接使用同一排除边界。已存在边界下不重复添加 ExcludeSemantics。排除依据是实际宿主，不是预览设备或窗口形态。

原因与清理条件见 [主题编辑器说明](theme-editor.md) 的上游 #190357 / #175041 引用；SDK 修复后须通过 Windows 原生路由、连续拖动、提示浮层及读屏回归才能恢复。当前验证仅包含语义属性及 RenderBox 的排除/指针可达性测试，未运行设备或 Widget 测试，不代表原生闪退已验证消失。


## 滑块手势与外部状态竞争（2026-10-15）

普通、纵向、胶囊及范围滑块在有效拖动期间使用本地临时值，onChanged 仍持续通知，播放器等外部值更新不抢占手势。松手时 onChangeEnd 使用最终本地值，之后恢复受控更新，不回放拖动中缓存的外部值。范围滑块保留原有越过交换角色的计算；禁用或修改范围 / 步进配置时取消旧临时值。胶囊的绘制进度、图标进度和语义值使用同一个当前显示值。状态仅负责交互，不纳入视觉 ThemeData 或新增定时器。

播放器 seek 的异步确认与旧位置上报过滤由业务负责，组件不推测播放引擎的请求完成时机。Demo 增加持续上报的位置流复现，见 [使用方式](usage/selection.md)。单元检查覆盖拖动与外部状态竞争；Widget 回归已编写但本轮未执行，未启动设备。

侧边导航的 `collapsedIconSize` 独立于展开态 `iconSize` 和箭头 `expandIconSize`，四端初值复用各端现有图标规格，未依据参考截图的物理像素改写默认尺寸。编辑器在导航项通用设置提供“折叠态图标尺寸”，按设备保存并遵循条目与折叠栏的几何上限。

按用户确认，侧栏折叠态图标默认24逻辑像素，折叠态条目独立间距 `collapsedRowGap` 默认8（按用户指定调整），展开态行间距不变；局部主题与实例可分别覆盖。

## 日期与时间选择器（未确认，2026-10-19）

`HyperDatePicker`、`HyperTimePicker` 和 `HyperDateTimePicker` 共用受控的日期时间编辑核心。
日期为公历年/月/日分项，时间为时/分分项；面板中保留草稿，只有确认才回调，取消、返回和点外部关闭不提交。
当前精度为分钟，不包括范围选择、秒、农历与时区换算。日期返回本地零点，日期时间返回本地民用时间；调用方负责业务时区。
默认日期范围 1900-01-01 至 2100-12-31，仅为初版可浏览范围，不是视觉规格。
闰年、大小月、范围端点、分钟步进共同限制可选项；切换年月先收敛到当月末日，再收敛到业务范围。
分钟间隔必须为 60 的正整数约数。范围与步进没有交集时抛出 ArgumentError，避免提交不可用值。

当前是现有选择器的组合控件，不引入独立的绘制配方或设备尺寸常量。
默认尺寸、排版、交互、动效与表面分别继承 Select / Selection、Button、统一 Motion 与材质主题。
全局、局部使用现有强类型主题，实例 `style` 使用 HyperSelectStyle，`surfaceStyle` 使用 HyperCardStyle。
尺寸由 HyperSizeScheme 对应四端规格统一解析；内部纵向间隔复用同端 menu.padding。
外层复用 HyperDropdown 和 resolveHyperMenuSurface，显式空阴影列表优先；默认按真实设备呈现，desktop 锚定、phone/tablet 底部、watch 全屏。
主题编辑器在“未确认”分类提供入口，当前复用 Select 工作区，不另存一套与 Select 相同的配置。

视觉来源为 D 级同端既有语义规格，尚未得到用户样式确认。
2026-10-19 核对了小米官方组件目录 https://dev.mi.com/xiaomihyperos/documentation/detail?pId=1874 ，其列出日期与时间 picker，但没有可直接移植的 Flutter 布局尺寸；HiUI 官方仓库 https://github.com/XiaoMi/hiui 的发布记录确认有 date-picker/time-picker，当前未获得可核实的同状态尺寸源码，不声称复刻 HiUI 或 HyperOS 日期面板。
日历网格、滚轮与各端专用外观可在后续样式确认阶段替换，共享数据职责及受控提交接口保持独立。

## 滚轮选择器（未确认，2026-10-19）

`HyperWheelPicker<T>` 是单列、受控的有限选项滚轮；父组件负责多列联动、日期合法性和确认提交。
`items/value/labelBuilder/onChanged` 定义数据；`onChanged` 随中心项改变通知，`onChangeEnd` 在发生改变的滚动停止后通知。外部更新值或替换列表只同步显示，不反向回调；空列表保留空视口并关闭交互。值不在列表时展示第一项，不自动提交；调用方应提供唯一值。
支持触摸/鼠标拖动、鼠标滚轮、相邻项点击、上下键、Home/End 和可选循环。使用 Flutter `ListWheelScrollView`、`FixedExtentScrollController`、`FixedExtentScrollPhysics` 的约束与吸附，不自建手势物理。循环跨界返回真实值。可见行数为正奇数，默认五行，这是项目初始布局选择，不是小米官方规范。

全局 `wheelPickerTheme`、局部 `HyperWheelPickerTheme`、实例 `HyperWheelPickerStyle` 逐字段合并；四端规格集中在 `HyperSizeScheme.wheelPicker`，均包含 copyWith、插值与值相等。背景、选中区域颜色与边框、文字与选中文字、禁用颜色、曲率、透视、密度、淡化比例及切换动效可覆盖。`selectionOverlayBuilder` 可替换选中区域。滚轮本身为内嵌编辑内容，没有浮层表面或独立高级材质配方；未来表单浮层仍须使用统一菜单/模态基础设施。

四端默认尺寸为 D 级同端语义推导（逻辑像素），不是截图物理像素换算：
- phone：行最小高度 48（controlHeightMd），宽 280（select.width），文字水平内边距 12（menu.padding），选中圆角 12（menu.itemRadius）。
- tablet：行最小高度 52（controlHeightMd），宽 280、内边距 12、圆角 12（同端 Select/Menu）。
- desktop：行最小高度 44（controlHeightMd），宽 192、内边距 8、圆角 6（同端 Select/Menu）。
- watch：行最小高度 48（controlHeightMd），宽 200、内边距 4、圆角 10（同端 Select/Menu）。
文字继承当前端 bodyLarge；默认选中 textPrimary、未选中 textSecondary、区域底色 surfaceMuted。曲率 2、透视 .003、密度 1 和非选中透明度 1 保留 Flutter ListWheelScrollView 当前 SDK 默认值。切换动画使用 Motion fast，系统减少动画时程序化切换立即完成。

每行以原始 TextScaler 测量默认与选中字体下全部标签的实际换行高度，取所需最大值与主题最小高度的较大者；不截断系统非线性缩放。文字缩放、宽度和行高改变后重新对齐当前选中项。父级仍应提供能容纳文字的可用视口，滚轮不会关闭缩放以适应过小的固定高度。

2026-10-19 查阅小米 Vela 官方 picker 文档 https://iot.mi.com/vela/quickapp/zh/components/form/picker.html ，确认普通/时间滚动选择器的行为与文字、选中背景配置角色；其 30px/20px 字号属于 Vela 文档，未直接作为 Flutter 默认值。HiUI picker README https://github.com/XiaoMi/hiui/blob/master/packages/ui/picker/README.md 未提供可核实的滚轮视觉参数。手机、桌面和手表的目标状态实机对照与视觉确认仍待完成。

编辑器“未确认”入口按通用/默认/选中/禁用状态组织，文字和布局在前、表面在底部；设备尺寸与亮暗外观分别保存。像素滑块及持续时间写入整数，圆角范围随宽度和行最小高度动态变化，历史小数导入保持兼容。操作边界统一记于 editor_dimension_limits.dart，不能回写为组件默认值。

2026-10-19 调整：desktop 滚轮行最小高度由 44 改为同端 menu.itemHeight 的 32 逻辑像素（D 级语义推导，待确认）。新增非选中项 unselectedScale（0–1，默认 1），选中保持 1，使用 Motion 连续过渡；不缩小布局或命中尺寸。编辑器补齐字重、非选中缩放与透明度、直径比、透视、挤压比例、选中区域边框和切换曲线；非像素参数保留小数。

2026-10-19 鼠标滚轮平滑修复：Flutter ScrollPosition.pointerScroll 默认先 forcePixels，再 goBallistic，连续离散输入会反复瞬移和吸附。滚轮视口提前通过 pointerSignalResolver 接收垂直滚轮信号，累积目标项并使用现有 Motion/实例 duration、curve 驱动到整项；事件保留完整原生命中路径，触摸拖动与点击职责不变。外部同步及开始拖动清理累积目标。减少动画仍立即完成。回归覆盖首个信号与动画中连续信号没有即时像素跳变，以及结束吸附、拖动、点击、循环和键盘。

2026-10-19 鼠标滚轮步进修正：之前将 PointerScrollEvent 的逻辑像素除以行高后累计取整，导致相同输入在 32px 行高下可能交替跨一项/两项。现每个非零垂直滚轮信号按方向移动一项，连续信号累计整数目标并沿用平滑动画；停止或外部同步后清理目标。Flutter 未提供硬件刻度数量，系统将多个刻度合并为一个事件时无法从像素值可靠还原刻度，此策略明确按事件计步。测试覆盖不同增量、正反方向及动画中连续输入。

## 独立日历（未确认，2026-10-19）

HyperCalendar 为内嵌公历单日选择，HyperCalendar.range 为包含首尾的日期区间选择。
区间首次点击只在组件中保留起点，第二次点击提交有序 DateTimeRange，支持反向、同日与跨月。
firstDate/lastDate 默认 1900-01-01 至 2100-12-31；只比较民用日期，不进行时区转换。selectableDayPredicate 可禁用日期，区间不能跨过禁用日；遇到被阻断区间时以第二次点击作为新的起点。清空/提交由调用方管理，不自带浮层、确认按钮或业务表单状态。
周起点和日期文字默认跟随 MaterialLocalizations；默认当前月份来自选中值或当前日期，initialMonth 可指定。按钮复用 HyperButton 原生焦点、键盘和 Motion 过渡；导航和标题采用 Wrap，日期行测量保留原始 TextScaler，窄宽、大字可增高，不关闭缩放。
全局 calendarTheme、局部 HyperCalendarTheme、实例 HyperCalendarStyle 逐字段覆盖；四端尺寸由 HyperSizeScheme.calendar 管理，支持 copyWith、lerp 和值相等。普通和区间使用同一日期语义及主题，区间只改变选择行为。
当前视觉来源 D 级项目推导，尚无目标截图或同状态官方参数验证：日期最小高度沿用同端 controlHeightMd（desktop 沿用 menu.itemHeight=32）；phone/tablet 宽度分别 336/364 为七列对应 controlHeightMd 的布局推导，desktop 280 和 watch 200 复用同端菜单宽度。间距 phone/tablet/desktop 为现有 spaceXs=4，watch spaceXxs=2；圆角复用同端菜单项。所有值为逻辑像素，非官方日历 token，待实机确认。背景默认透明，不创建独立材质配方。
Demo 与编辑器先注册“未确认”；编辑配置保留四端尺寸和亮暗外观归属，暂复用编辑数据 DTO 字段形状，解析到独立的强类型 calendarTheme / sizes.calendar，不读取 wheelPicker 主题。

2026-10-19 双月面板：HyperCalendarPanels.adaptive/single/doubleMonth 提供公开呈现配置，默认普通日历单月，区间日历 desktop 双月、其他真实设备类别单月。共享同一 month/pending/range 状态和单月绘制函数，两个面板展示连续月份，跨面板端点仍通过同一合法性校验。width 表示单面板宽度，间距复用 calendar.spacing；父约束不足时 Wrap 纵向排列，不重分类设备。达到 lastDate 所在月时只显示合法月份，不生成超出上限的第二个月。Demo 增加显式双月区间，仍留在未确认。

2026-10-19 基础日期时间选择器完成组合：HyperDatePicker 面板使用单月 HyperCalendar（含年月导航），HyperTimePicker 使用并排时/分 HyperWheelPicker，HyperDateTimePicker 在同一可滚动面板中组合单日日历和时分滚轮。不再保留年/月/日/时/分多层 Select 面板路径。日历与滚轮分别继承 calendarTheme / wheelPickerTheme，触发器与浮层继续复用 Select/Selection 强类型主题和统一菜单表面；面板默认宽度从当前端 calendar.width 解析，实例 selectionStyle 可覆盖。
选择过程只改变本地草稿，确认返回分钟精度的本地 DateTime/TimeOfDay，取消与外部关闭不提交。日期变更保留时分，再按当前边界收敛，时/分可选项同步过滤；分钟步进和日期上下限继续统一由 _Bounds 处理。日期时间范围选择尚未加入。
组合回归覆盖日历选闰日确认、滚轮取消重开、跨日边界时分过滤、三档文字缩放滚动至操作区、phone/tablet/watch 呈现以及实例空阴影。

2026-10-19 桌面日期时间面板采用紧凑数字编辑：真实 desktop 的时/分使用 HyperTextField 与 HyperButton 增减按钮，支持数字输入、上下方向键和分钟步进；phone/tablet/watch 保留 HyperWheelPicker。数字输入立即将解析值收敛到当前可选列表，失焦/提交时规范化为两位数字；空输入保留上一个有效草稿，按钮在上下限禁用。不另存设备尺寸，输入与按钮复用当前端强类型主题，外层日历与确认流程保持不变。

2026-10-19 桌面时间数字输入参考本地 E:/lemon_shadcn/lib/src/components/forms/app_time_stepper_picker.dart 的 _TimeUnitControl 与 _AppNumberInputState：采用 Stack 中普通输入框加 PositionedDirectional 末端增减区域，避免依赖 trailing 附件的额外间距。数字内容预留 actionWidth，上下按钮直角，标签单独对齐、取消为描边。仅迁移结构，尺寸与排版继续来自 HyperTextField/HyperIconButton 当前端主题，未复制参考项目 72/44/24px 等固定规格。保留当前 API 的非空提交类型与范围边界，不新增会破坏调用方类型的清空提交。

2026-10-19 移动日期编辑改为横排滚轮：非 desktop 呈现不再组合日历，按 date/time/dateTime 模式分别显示年月日、时分、年月日时分；showSeconds 可开启秒列（DateTime 与区间 API，默认 false 保持分钟兼容，TimeOfDay 包装不暴露秒）。Demo 日期时间示例开启秒列。所有列共享草稿与上下限，切换年月先收敛到当月末；分钟步进与秒端点一起过滤。窄宽/文字放大时允许横向滚动，不关闭缩放。列内边距复用同端 menu.padding 的一半，最小列宽用实际 TextScaler 测量四位年份加对应留白；列宽随可用宽度均分，布局不重新分类真实设备。

## Form / Field（未确认，2026-10-19）

用户确认 docs/form-specification.md 的方向后实现 HyperForm、HyperFormController、HyperFormField<T>、HyperField、HyperTextFormField、HyperFormSection 与 HyperFormErrorSummary。
Form 保留原生 FormField 的 save/reset/validate，Controller 维护具名值、dirty/touched、异步与跨字段校验、版本失效、提交错误及重复提交合并。字段卸载解除注册；重置和编辑使旧校验结果失效。自定义值通过 valueSnapshot/valueEquals 提供业务快照和比较；默认递归冻结 List/Map/Set，value<T> 保留原字段类型。提交异常不删除输入，错误摘要完整换行。
布局 vertical / horizontal / labelHidden 表示标签与控件的关系；窄约束无法容纳横排时重排竖排，真实设备类别不变。labelHidden 不绘制标签占位，语义名称仍保留。多列由 HyperFormSection.columns 独立组合，按可用宽度和字段最小几何关系重排。基础字段不绘制默认背景或额外卡片。
全局 formTheme/fieldTheme、局部 HyperFormTheme/HyperFieldTheme、实例 HyperFieldStyle 逐字段解析；sizes.form 集中管理四端标签宽度、对象间距和控件最小可用宽度。字段局部主题保留稀疏覆盖，避免全局 Field 样式反向覆盖 Form 实例配置。主题和尺寸具备 copyWith、lerp、值相等与哈希。
错误 auto 采用有标题竖排 inline，否则 below；trailingIcon 只有适配器使用子控件原生 errorText 插槽时才交给子控件，通用 builder 没有插槽时降级 below，不以 Stack 遮挡尾部操作。HyperTextFormField 的 trailingIcon 复用 HyperTextField 原有错误入口，普通布局由 HyperField 展示一次。

默认规格来源为 D 级项目候选，使用用户指定的本地 lemon_shadcn 的字段关系作结构参考，单位均为逻辑像素，不是 HyperOS 官方 token：
- phone/tablet：标签列宽与控件最低可用宽度 120（AppFieldConfig.labelWidth 的可审阅起点），标签间距12、字段间距16、说明间距6复用同端语义留白。
- desktop：标签列宽/控件最低宽度96（同端 select.width=192 的半宽用于短字段标签与布局重排），间距8/12/4复用同端菜单与语义留白。
- watch：标签列宽/控件最低宽度80 为窄视口候选布局边界，间距8/8/4复用同端语义留白，待实机验证。默认竖排，不保证横排标签永远适合所有内容。
这些都是可通过主题修改的初始布局参数，不从参考截图物理像素推导。所有文字使用当前端 bodyMedium/bodySmall/titleMedium，保留系统 TextScaler，不编辑文字行高倍率。

Gallery 预留“表单”正式分类；Form Demo 与编辑入口暂位于“未确认”，id hyper-form 保持稳定。编辑器采用独立 EditorFormMetrics/EditorFormVisual 保存四端尺寸与亮暗外观，恢复继承和历史配置导入兼容；像素滑块写入整数，公共操作上限位于 editor_dimension_limits.dart。
阶段一采用通用 builder 完整接入现有 Select/DatePicker/Checkbox，提供专门 HyperTextFormField 文本适配。其余专用命名 FormField 包装属于第二阶段，不阻塞表单组合使用。


## HyperTable（2026-10-21；2026-10-22 用户确认）

对外使用 HyperTable<T>、HyperTableColumn<T>、HyperTableController、HyperTableQuery/Page 与强类型事件；TrinaGrid 状态管理器不公开。全局 tableTheme、局部 HyperTableTheme 和实例 HyperTableStyle 逐字段合并，文本深合并；四端默认规格由 sizes.table 集中管理。公开样式及尺寸支持 copyWith、插值和值相等。

编辑器 tableMetrics 属于四端设备规格，tableVisual 属于亮暗外观；保留统一保存、导入、恢复继承和撤销机制。Gallery 与编辑器登记在未确认，id hyper-table。列布局、行状态和表面分别组织，不将交替行配色混作交互状态。

行底色由同一表面路径绘制，固定列与主体共享悬停身份；Motion 与减少动画设置统一处理状态过渡。表格表面继承统一材质质量及降级，行右键/长按菜单使用 HyperContextMenu，表头菜单与编辑控件使用公共 Hyper 组件。未搬运旧版悬停缩放、覆盖滚动条或补丁。

本地/分页/无限加载分别处理数据，远程排序和刷新使旧请求失效。树形按稳定 key 展开，子级缓存与请求代次防止刷新前结果覆盖新数据；分页以根节点计数，排序保留父子关系。行拖动只用于本地未分页且未排序的平面数据，避免把展示位置误当业务全量顺序。

## InlineEdit（2026-10-26，用户已确认）

行内编辑全局 inlineEditTheme、局部 HyperInlineEditTheme 与实例 HyperInlineEditStyle 逐字段合并，包含文字、输入、操作按钮和动效覆盖；支持 copyWith、插值及值相等。四端最小高度复用 sizes.textField，间距复用 sizes.form，不保存组件端内常量。默认表面由子控件主题及统一材质系统负责，默认过渡只动画尺寸，减少动画优先。设计来源为 D 级既有语义组合，细节见 usage/inline-edit.md。

## 评分、穿梭框、分栏、可移动对话框与导航栏（2026-10-26，未确认）

新增 ratingTheme、transferTheme、resizableTheme、movableDialogTheme、navigationBarTheme 强类型全局主题，局部 Theme 和实例 Style 只覆盖显式字段；复制、插值、值相等和哈希保持完整。默认四端几何复用当前已解析的 icon/button/form/divider/menu/selection/card/dialog 等语义规格，不在组件内分设备保存常量。编辑器设备尺寸与亮暗颜色分开保存。详见 usage/pending-controls.md。

HyperDialog 新增 surfaceBuilder，只包装已完成材质、边框、阴影与圆角解析的表面；可移动对话框以此复用公共路径，仅施加平移。路由继续使用 showHyperDialog 的调用处主题捕获和安全材质过渡，空阴影与显式边框优先。
