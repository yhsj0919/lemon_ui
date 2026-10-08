# Lemon UI 主题与尺寸架构

## LoadingOverlay（2026-10-03）

全局 loadingOverlayTheme、局部 HyperLoadingOverlayTheme 和实例 Style 逐字段合并，
中央内容宽度、留白、圆角和间距由四端 sizes.loadingOverlay 管理。
默认指示器复用 HyperCircularProgress 与进度主题，不另存一套设备进度尺寸。
统一材质质量和降级从 HyperMaterialTheme 继承，显式 Style 可局部覆盖。
纯计时模型只负责 showDelay 与 minimumVisibleDuration；组件管理遮罩显隐及 child 的交互隔离，
父级管理任务、取消、导航、外部布局与区域外交互。计时与动画相互独立，减少动画不缩短业务保留时间。

## Alert / Banner（2026-10-03）

alertTheme / bannerTheme 及 sizes.alert / sizes.banner 独立存储，
局部通过 HyperAlertTheme / HyperBannerTheme 覆盖，不读取对方主题。
HyperNoticeStyle 仅共用字段结构，支持通用与四种状态覆盖，实例 Style 最后应用。
共用内部 HyperNoticeBody 的内容、图标、操作与显隐布局；状态和关闭由父级控制。
材质默认继承 HyperMaterialTheme，渲染与降级复用 HyperMaterialSurface。
显示、隐藏、颜色与布局变化使用 Motion 和系统减少动画策略，显隐过渡可替换。
Banner 不创建浮层或自动吸顶；定位、宽度和外边距由父级管理。

## 统一高级材质策略（2026-10-03）

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

`HyperEmptyState` 只展示空内容，不管理网络、加载、重试或业务状态。默认中性图标
与“暂无内容”标题；`illustration` 优先于图标，`showIllustration: false` 可隐藏装饰；
`titleWidget`、`descriptionWidget` 可替换默认文本，`content` 放置额外内容，
`actions` 接受现有按钮等 Widget 并自动换行。外层最大内容宽度只约束当前组件，
父布局仍决定可用区域。装饰插图不创建重复朗读条目，文字与操作保持原有语义。
全局 `emptyStateTheme`、局部 `HyperEmptyStateTheme`、实例 `HyperEmptyStateStyle`
管理图标、颜色、排版、对齐、间距、背景填充、边框、圆角、阴影和过渡。
四端尺寸集中在 `HyperSizeScheme.emptyState`；文字复用当前端 titleMedium 与
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

`HyperDropdownMenu<T>` 是受控单选入口：调用方传入 `value` 和 `onChanged`，
禁用选项不可触发选择。锚点复用 `HyperButton` 的尺寸与样式，弹出的选项复用
`HyperMenu` 的焦点导航、主题和浮层材质；方向键可从锚点打开，选择或按 Escape
关闭后将焦点返回按钮自身。`HyperButton.focusNode` 支持这种组合场景，节点由调用方释放。
锚点宽度、箭头尺寸和间距来自四端 `HyperDropdownMenuSize`；前景、箭头和选中底色
由全局 `dropdownMenuTheme`、局部 `HyperDropdownMenuTheme` 与实例
`HyperDropdownMenuStyle` 逐层覆盖。显式 `buttonStyle` 和 `menuStyle` 最后覆盖各自底层控件。

`HyperPopupListTile<T>` 将 `HyperListTile` 与锚定模态选项列表组合。整行显示
当前值和上下双箭头，打开时使用语义遮罩；弹窗以尾部上下箭头图标为锚点，并在上下空间不足时翻转、限制在安全区域。弹窗复用 `HyperMenu` 的焦点、禁用和选中
状态。弹窗选项行高默认取当前端 `HyperListTileSize.minHeight`，紧凑行取
`compactMinHeight`，`menuStyle.itemHeight` 可显式覆盖。宽度按选项文字和图标测量，
由四端 `HyperPopupListTileSize` 限制最小和最大值，实例可覆盖边界或指定固定宽度。
弹窗表面内边距与选项文字内边距独立；选项左右内边距由四端 `HyperPopupListTileSize.itemHorizontalPadding` 管理，默认均为 16 逻辑像素，可通过 `menuStyle.padding` 显式覆盖。默认选中和悬停背景铺满整行，外框负责裁剪圆角。
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
├─ dropdownMenu: HyperDropdownMenuSize
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

## NotificationCenter（2026-10-04）

notificationCenterTheme 与 sizes.notificationCenter 独立强类型存储，支持 copyWith、合并、插值和值相等。中心只绘制标题、计数、组标题和布局，不自建表面；notificationTheme 子主题管理卡片，emptyStateStyle 管理空状态，buttonTheme 管理中心生成的操作。材质继承统一基础设施。

父级持有 entries 和业务操作，中心仅发出单条/批量回调。Snapshot 固定输入列表、校验 id 唯一性并按首次出现组别排列，不做日期推断或异步数据存储。默认有限高度内使用惰性 ListView；shrinkWrap 嵌入布局仅用于少量内容。默认空状态过渡继承 Motion，可通过 transitionBuilder 替换。

## Collapsible / Accordion（2026-10-05）

collapsibleTheme / accordionTheme 与 sizes.collapsible / sizes.accordion 独立强类型存储。面板解析通用、展开/收起、禁用后，再合并实例 Style；组只管理展开规则、项间距和可选分隔线，itemTheme 管理子面板视觉。两者不读取 Card 主题。

父级持有 expanded / expandedIds，纯 HyperAccordionSelection 验证唯一 id、互斥模式和有效展开集合。内容生命周期底座负责连续反向动画、完全关闭后的卸载或保留、收起时即时交互隔离。动画使用 Motion 与减少动画策略，公开 transitionBuilder 可替换内容视觉；横向内容的宽度约束由调用方负责。

表面继承统一材质配方、质量及减少透明度配置，渲染降级复用 HyperMaterialSurface，不自建默认材质开关。

## Pagination（2026-10-05）

paginationTheme 与 sizes.pagination 独立强类型存储，支持复制、合并、插值和值相等。分页主题只管理自身间距、导航图标和文案，以及普通、选中、导航按钮的 HyperButtonStyle；按钮状态、焦点、键盘、材质与动画复用按钮职责，不自建交互或材质路径。当前页禁用重复请求并保留明确选中配方。

HyperPaginationModel 负责输入合法性、页码窗口与省略号；组件仅发出 onPageChanged，调用方负责数据加载和页数变化后的当前页修正。Wrap 适应可用宽度，不改变设备分类。数据为空使用 currentPage 0，非空页码从 1 起始。

## StepIndicator / StepperNavigation（2026-10-05）

stepIndicatorTheme / stepperNavigationTheme 与 sizes.stepIndicator / sizes.stepperNavigation 各自独立存储。HyperStepStyle、HyperStepSize 共用字段结构，公共 Body 只接收已选主题解析函数与当前尺寸，不自行判断设备类别或读取另一组件主题。

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
