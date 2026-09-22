# Lemon UI 全量控件目录

本文档用于规划 Lemon UI 的长期控件范围，方便按类别逐项设计、实现和验收。公开控件统一使用 `Hyper` 前缀，基础名称优先采用 Flutter 原生命名。

控件的基础层、高级层和优先实现顺序见 [控件分层与实现优先级](component-layer-classification.md)。本目录只维护完整范围和完成状态，避免在两份文档中重复维护状态。

目录同时考虑手机、平板、桌面和手表。设备专属组件只在相应平台或窗口形态下启用；通用组件保持同一套公开 API，通过各自主题和默认布局适配设备。

## 标记说明

- `[ ]`：尚未实现。
- `[~]`：实现中或仅完成基础版本。
- `[x]`：API、主题、示例、测试和文档均已完成。
- 通用：手机、平板、桌面和手表均可使用。
- 大屏：主要用于平板和桌面。
- 桌面：针对鼠标、键盘、窗口和高信息密度场景。
- 手表：针对小屏、圆屏、表冠和低功耗场景。

每个正式控件原则上都应具备：独立控件文件、独立主题文件、总主题注册、Example 展示、交互测试、主题优先级测试和必要的 Golden 测试。

## 一、主题、样式与基础类型

这些类型不一定直接绘制 UI，但属于所有控件共同依赖的公开基础能力。

- [x] `HyperTheme`：全局和局部主题作用域。
- [x] `HyperThemeData`：总主题数据。
- [x] `HyperColorScheme`：语义颜色体系。
- [x] `HyperContrastThemeData`：standard、adaptive 和 inverted 全局前景反色策略。
- [x] `HyperContrastTheme`：局部子树反色策略覆盖。
- [ ] `HyperTextTheme`：字体和文本层级。
- [x] `HyperSizeScheme`：明确数值的尺寸预设，不使用倍率缩放。
- [x] `HyperMotionThemeData`：动画时长、曲线和弹簧。
- [x] `HyperMaterialQuality`：明确选择 standard 或 advanced 材质质量，不进行隐式设备降级。
- [x] `HyperSurfaceMaterial`：solid、translucent、frostedGlass 和 softLightGlass 表面材质配方。
- [x] `HyperMaterialThemeData`：全局材质默认值、玻璃参数和普通材质降级策略。
- [x] `HyperMaterialTheme`：仅覆盖当前子树的局部材质作用域。
- [ ] `HyperOverlayThemeData`：悬浮层公共规则。
- [ ] `HyperDeviceThemeData`：各设备类型的默认值。
- [x] `HyperFill`：纯色、渐变和显式无填充。
- [ ] `HyperBorder`：边框描述。
- [ ] `HyperShadow`：阴影描述和显式无阴影。
- [ ] `HyperShape`：统一形状描述，可从 Flutter `ShapeBorder` 建立并支持自定义路径。
- [ ] `HyperRoundedShape`：普通圆角矩形及各角独立配置。
- [ ] `HyperContinuousShape`：连续圆角和超椭圆风格。
- [ ] `HyperStadiumShape`：胶囊形状。
- [ ] `HyperCircleShape`：圆形和椭圆形状。
- [ ] `HyperBeveledShape`：斜切角形状。
- [ ] `HyperPolygonShape`：三角形、菱形、五边形、六边形及任意规则或自定义多边形。
- [ ] `HyperStarShape`：可配置角数、内外半径和旋转角度的星形。
- [ ] `HyperArrowShape`：单向、双向及可配置箭头形状。
- [ ] `HyperNotchedShape`：内凹、外凸、票券孔和组合缺口形状。
- [ ] `HyperWaveShape`：波浪、锯齿和重复边缘形状。
- [ ] `HyperSymbolShape`：心形、气泡、水滴、盾牌等常用符号轮廓。
- [ ] `HyperCustomShape`：显式 `Path`、路径构建器或矢量路径数据提供的任意异形。
- [ ] `HyperShapeMorph`：在常规形状、多边形、符号轮廓和任意路径之间执行可控变形。
- [ ] `HyperShapeTween`：形状动画补间，支持同构插值、路径归一化和离散回退。
- [x] `HyperStateValue<T>`：按交互状态解析属性。
- [ ] `HyperAsyncState<T>`：idle、loading、success、error。
- [ ] `HyperAsyncConcurrency`：异步并发策略。
- [x] `HyperDeviceType`：phone、tablet、desktop、watch。
- [x] `HyperDeviceDetector`：提供离散设备类型探测能力，由 `HyperTheme` 统一协调，并允许显式覆盖或自定义解析。
- [x] `HyperControlState`：hovered、pressed、secondaryPressed、tertiaryPressed、longPressed、focused、selected、disabled 等。
- [ ] `HyperThemeInspector`：Debug 模式查看属性最终值及来源。

## 二、容器、表面与装饰

- [x] `HyperContainer`：尺寸、约束、内外边距、对齐、背景、渐变、边框、圆角和阴影。
- [x] `HyperMaterialSurface`：按材质质量绘制普通、半透明或可降级玻璃表面。
- [ ] `HyperSurface`：具有语义层级的基础表面。
- [ ] `HyperCard`：内容卡片。
- [ ] `HyperPanel`：页面或工具区域面板。
- [ ] `HyperSection`：带标题、说明和内容的分区。
- [ ] `HyperGroupBox`：带边界和标题的内容分组。
- [x] `HyperDivider`：支持横向、纵向、纯色、渐变、实线、虚线、点线、明确尺寸和独立主题。
- [ ] `HyperVerticalDivider`：垂直分隔线便捷控件。
- [ ] `HyperSpacer`：语义间距。
- [ ] `HyperGap`：明确尺寸的间隔。
- [ ] `HyperClip`：按 `HyperShape` 统一裁切，支持常规形状、参数化几何图形和任意异形路径。
- [ ] `HyperAspectRatio`：比例容器。
- [ ] `HyperConstrainedBox`：主题友好的约束容器。
- [ ] `HyperSafeArea`：设备安全区域。
- [ ] `HyperBlur`：使用统一材质性能规则的可降级背景模糊。
- [ ] `HyperGlass`：基于 `HyperSurfaceMaterial` 的玻璃表面便捷控件，不建立第二套玻璃主题。
- [ ] `HyperGradientBorder`：渐变边框。
- [ ] `HyperDashedBorder`：虚线边框。
- [ ] `HyperHighlight`：高光和状态覆盖层。
- [ ] `HyperBadge`：角标、数量和状态标记。
- [ ] `HyperBadgeAnchor`：按明确偏移将角标定位到目标控件，不持有角标视觉主题。
- [ ] `HyperBannerBadge`：角落横幅标记。

## 三、布局与响应式

- [ ] `HyperScaffold`：页面基本结构。
- [ ] `HyperAdaptiveScaffold`：按窗口选择手机、平板、桌面和手表布局。
- [ ] `HyperResponsiveBuilder`：按可用空间构建布局。
- [ ] `HyperBreakpointBuilder`：按断点构建布局。
- [ ] `HyperOrientationBuilder`：按方向构建布局。
- [ ] `HyperDeviceBuilder`：按设备策略构建布局。
- [ ] `HyperRow`：带统一间距的水平布局。
- [ ] `HyperColumn`：带统一间距的垂直布局。
- [ ] `HyperWrap`：自动换行布局。
- [ ] `HyperStack`：层叠布局便捷封装。
- [ ] `HyperFlow`：自定义流式布局。
- [ ] `HyperGrid`：通用网格。
- [ ] `HyperResponsiveGrid`：响应式网格。
- [ ] `HyperMasonryGrid`：瀑布流网格。
- [ ] `HyperStaggeredGrid`：交错网格。
- [ ] `HyperSplitView`：双栏或多栏分割布局。
- [ ] `HyperMasterDetail`：主从布局。
- [ ] `HyperResizablePanel`：可调整大小的面板。
- [ ] `HyperResizablePane`：可拖拽分隔的窗格。
- [ ] `HyperCollapsiblePane`：可折叠窗格。
- [ ] `HyperPageView`：页面切换容器。
- [ ] `HyperCarouselView`：卡片式分页布局。
- [ ] `HyperScrollable`：统一滚动行为容器。
- [ ] `HyperScrollbar`：平台适配滚动条。
- [ ] `HyperScaledBox`：显式外部整体缩放工具，不参与控件内部尺寸解析。

## 四、文字、图标与基础内容

- [x] `HyperText`：系统字体主题文本，支持十二级语义样式、控件主题、局部主题和实例覆盖。
- [ ] `HyperSelectableText`：可选择文本。
- [ ] `HyperRichText`：富文本。
- [ ] `HyperMarkdown`：可选扩展包中的 Markdown 展示。
- [ ] `HyperCodeBlock`：代码展示与复制。
- [x] `HyperIcon`：设备明确尺寸、状态样式、可变图标轴及全局/局部/实例主题覆盖。
- [ ] `HyperIconLabel`：图标文字组合。
- [ ] `HyperAvatar`：头像。
- [ ] `HyperAvatarGroup`：头像组。
- [ ] `HyperInitialsAvatar`：文字头像。
- [ ] `HyperNetworkImage`：网络图片状态封装。
- [ ] `HyperPlaceholder`：内容占位。
- [ ] `HyperLabel`：字段或内容标签。
- [ ] `HyperCaption`：辅助说明文字。
- [ ] `HyperLink`：文本链接。
- [ ] `HyperKbd`：键盘按键提示。
- [ ] `HyperTag`：标签。
- [ ] `HyperStatusIndicator`：在线、忙碌、错误等状态点。

## 五、按钮与操作

按钮统一使用 `FutureOr<void> Function()? onPressed`，同步和异步共用同一个 API。

- [~] `HyperButton`：标准按钮，已实现 `.filled`、`.tonal`、`.outlined`、`.ghost`、`.text`、`.gradient`、自动异步和环形进度；线性与背景填充进度待补充。
- [x] `HyperIconButton`：纯图标按钮，已实现 `.filled`、`.tonal`、`.outlined`、`.ghost`、独立主题、Tooltip、自动异步进度和材质；图标加文字由各 `HyperButton.xx` 构造器直接支持。
- [ ] `HyperFloatingActionButton`：浮动操作按钮。
- [ ] `HyperExtendedFloatingActionButton`：扩展浮动按钮。
- [ ] `HyperCloseButton`：关闭按钮。
- [ ] `HyperBackButton`：返回按钮。
- [ ] `HyperMenuButton`：打开菜单的按钮。
- [ ] `HyperDropdownButton`：下拉操作按钮。
- [ ] `HyperSplitButton`：主操作和菜单组合按钮。
- [ ] `HyperToggleButton`：可切换按钮。
- [ ] `HyperButtonBar`：按钮排列。
- [ ] `HyperButtonGroup`：关联按钮组。
- [ ] `HyperSegmentedButton`：分段按钮。
- [ ] `HyperActionChip`：轻量操作标签。
- [ ] `HyperFloatingToolbar`：浮动工具按钮组。
- [ ] `HyperCopyButton`：复制内容按钮。
- [ ] `HyperAsyncButton`：不单独建立；由 `HyperButton` 的统一回调模式覆盖。

## 六、选择、开关与选项

- [x] `HyperCheckbox`：复选框，支持未选中、选中和半选中三态，并提供 `.circle`、`.rounded` 外形变体。
- [ ] `HyperCheckboxListTile`：带说明的复选项。
- [x] `HyperRadio<T>`：默认 MIUIX 勾线样式，并提供 `.checkmark`、`.circle`、`.filled` 变体；支持分组值、取消选择及独立背景、边框、圆角、阴影配置。
- [ ] `HyperRadioGroup<T>`：单选组。
- [ ] `HyperRadioListTile<T>`：带说明的单选项。
- [x] `HyperSwitch`：开关，已实现点击、键盘、实时拖动、禁用、减少动画、MIUIX 比例与滑块交互放大，并支持全局/局部/实例配置轨道和滑块的颜色、圆角、尺寸、偏移及动画。
- [ ] `HyperSwitchListTile`：带说明的开关项。
- [ ] `HyperChip`：通用 Chip。
- [ ] `HyperChoiceChip`：单选 Chip。
- [ ] `HyperFilterChip`：筛选 Chip。
- [ ] `HyperInputChip`：可删除输入 Chip。
- [ ] `HyperToggleGroup<T>`：多项切换组。
- [ ] `HyperSelectionTile<T>`：通用选择项。
- [ ] `HyperColorPicker`：颜色选择器。
- [ ] `HyperColorSwatchPicker`：色板选择器。
- [ ] `HyperRating`：星级或图标评分。
- [ ] `HyperFavoriteButton`：收藏切换。
- [ ] `HyperLikeButton`：点赞切换。

## 七、数值、范围与调节

- [ ] `HyperSlider`：单值滑块。
- [ ] `HyperRangeSlider`：范围滑块。
- [ ] `HyperProgressSlider`：可拖动进度条。
- [ ] `HyperVerticalSlider`：垂直滑块。
- [ ] `HyperStepper`：步进调节。
- [ ] `HyperCounter`：加减计数器。
- [ ] `HyperNumberPicker`：数字选择器。
- [ ] `HyperWheelPicker<T>`：滚轮选择器。
- [ ] `HyperDial`：旋钮盘。
- [ ] `HyperKnob`：旋钮控件。
- [ ] `HyperCircularSlider`：环形滑块。
- [ ] `HyperRangeDial`：环形范围选择。
- [ ] `HyperLevelIndicator`：音量、亮度等等级显示。
- [ ] `HyperScrubber`：媒体时间轴拖动。

## 八、文本输入与编辑

- [ ] `HyperTextField`：单行文本输入。
- [ ] `HyperTextFormField`：表单文本字段。
- [ ] `HyperTextArea`：多行文本输入。
- [ ] `HyperSearchField`：搜索输入。
- [ ] `HyperPasswordField`：密码输入。
- [ ] `HyperNumberField`：数值输入。
- [ ] `HyperEmailField`：邮件输入便捷配置。
- [ ] `HyperPhoneField`：电话号码输入便捷配置。
- [ ] `HyperUrlField`：URL 输入便捷配置。
- [ ] `HyperPinInput`：PIN 输入。
- [ ] `HyperOtpInput`：验证码输入。
- [ ] `HyperAutocomplete<T>`：自动完成。
- [ ] `HyperDropdownField<T>`：下拉选择字段。
- [ ] `HyperComboBox<T>`：输入与选择组合。
- [ ] `HyperEditableText`：低层级可编辑文本封装。
- [ ] `HyperSearchBar`：搜索栏。
- [ ] `HyperSearchAnchor`：搜索浮层锚点。
- [ ] `HyperTagInput<T>`：标签输入。
- [ ] `HyperMentionInput<T>`：提及输入。
- [ ] `HyperRichTextEditor`：可选扩展包中的富文本编辑器。

## 九、表单体系

- [ ] `HyperForm`：字段注册、校验、提交和错误定位。
- [ ] `HyperFormField<T>`：通用字段基础类。
- [ ] `HyperFormSection`：表单分区。
- [ ] `HyperFormGroup`：关联字段组。
- [ ] `HyperFieldLabel`：标签、必填标记和帮助入口。
- [ ] `HyperFieldMessage`：helper、validating、success、warning 和 error 共用区域。
- [ ] `HyperValidationMessage`：校验信息。
- [ ] `HyperFormActions`：提交、重置和取消区域。
- [ ] `HyperFormSummary`：表单错误摘要。
- [ ] `HyperAsyncValidator<T>`：异步校验协议。
- [ ] `HyperFormController`：受控表单管理。
- [ ] `HyperFormScope`：表单上下文。

## 十、日期、时间与日程

- [ ] `HyperDatePicker`：日期选择器。
- [ ] `HyperDateRangePicker`：日期范围选择器。
- [ ] `HyperTimePicker`：时间选择器。
- [ ] `HyperDateTimePicker`：日期时间选择器。
- [ ] `HyperDurationPicker`：时长选择器。
- [ ] `HyperTimerPicker`：计时器设置。
- [ ] `HyperCalendar`：月历。
- [ ] `HyperCalendarView`：日、周、月视图。
- [ ] `HyperCalendarGrid`：日期网格。
- [ ] `HyperAgenda`：日程列表。
- [ ] `HyperSchedule`：时间段排程。
- [ ] `HyperTimeRangePicker`：时间范围选择。
- [ ] `HyperTimezonePicker`：时区选择。
- [ ] `HyperCountdownPicker`：倒计时设置。

## 十一、列表、集合与内容单元

- [ ] `HyperListView`：统一列表默认行为。
- [x] `HyperListTile`：MIUIX 风格的首部、正文、尾部基础列表项，不附加业务语义。
- [x] `HyperNavigationListTile`：进入下一级页面的列表项，统一提供描述区和 chevron。
- [x] `HyperCheckboxListTile`：整行复选列表项，由行交互承载点击热区并对齐尾部可见外框。
- [x] `HyperRadioListTile`：整行单选列表项，由行交互承载点击热区并对齐尾部圆环。
- [ ] `HyperSettingsTile`：设置项。
- [ ] `HyperActionTile`：操作列表项。
- [ ] `HyperUserTile`：用户信息项。
- [ ] `HyperMediaTile`：媒体信息项。
- [ ] `HyperExpandableTile`：可展开列表项。
- [ ] `HyperSwipeAction`：列表项侧滑操作。
- [ ] `HyperReorderableList`：可排序列表。
- [ ] `HyperGroupedList`：分组列表。
- [ ] `HyperPagedList`：分页列表。
- [ ] `HyperInfiniteList`：无限滚动列表。
- [ ] `HyperRefreshIndicator`：下拉刷新。
- [ ] `HyperPullToRefresh`：完整刷新容器。
- [ ] `HyperSliverAppBar`：滚动标题栏。
- [ ] `HyperSliverList`：主题化 Sliver 列表。
- [ ] `HyperSliverGrid`：主题化 Sliver 网格。
- [ ] `HyperStickyHeader`：吸顶分组标题。

## 十二、数据展示

- [ ] `HyperTable`：基础表格。
- [ ] `HyperDataTable`：排序、选择和操作的数据表格。
- [ ] `HyperPaginatedDataTable`：分页数据表格。
- [ ] `HyperDataGrid`：高密度可编辑数据网格。
- [ ] `HyperTreeView<T>`：树形结构。
- [ ] `HyperTreeTable<T>`：树形表格。
- [ ] `HyperKeyValueTable`：键值信息表。
- [ ] `HyperDescriptionList`：描述列表。
- [ ] `HyperTimeline`：时间线。
- [ ] `HyperStepIndicator`：步骤状态展示。
- [ ] `HyperMetric`：指标卡。
- [ ] `HyperStatCard`：统计卡片。
- [ ] `HyperChartContainer`：图表承载和状态框架。
- [ ] `HyperLegend`：图例。
- [ ] `HyperSparkline`：迷你趋势线。
- [ ] `HyperGauge`：仪表盘。
- [ ] `HyperAsyncView<T>`：异步数据状态切换。
- [ ] `HyperEmptyState`：空状态。
- [ ] `HyperErrorView`：错误状态。
- [ ] `HyperResult`：成功、失败和结果页面。

## 十三、导航

- [ ] `HyperAppBar`：顶部应用栏，提供 `.large` 与 `.small` 等明确变体。
- [ ] `HyperNavigationBar`：底部导航栏，提供普通与 `.floating` 形态。
- [ ] `HyperNavigationDestination`：普通与浮动底部导航共用的目标项。
- [ ] `HyperNavigationRail`：侧边导航轨道，支持折叠与展开布局。
- [ ] `HyperNavigationRailDestination`：侧边导航轨道目标项。
- [ ] `HyperNavigationDrawer`：导航抽屉。
- [ ] `HyperDrawer`：通用抽屉。
- [ ] `HyperSidebar`：桌面和平板侧栏。
- [ ] `HyperTabBar`：标签栏，提供 `.standard` 与 `.contour` 形态。
- [ ] `HyperTabBarView`：标签内容。
- [ ] `HyperSegmentedNavigation`：分段导航。
- [ ] `HyperBreadcrumb`：面包屑。
- [ ] `HyperPagination`：页码导航。
- [ ] `HyperPageIndicator`：页面指示器。
- [ ] `HyperStepperNavigation`：步骤导航。
- [ ] `HyperBottomAppBar`：底部应用栏。
- [ ] `HyperNavigationSplitView`：侧栏与内容区域。
- [ ] `HyperRouteTransition`：统一路由转场。
- [ ] `HyperNavigationObserver`：悬浮层和焦点联动的导航观察器。

## 十四、菜单、弹出层与选择浮层

- [ ] `HyperOverlayScope`：统一悬浮层宿主。
- [ ] `HyperOverlayPresentation`：显式选择应用内 overlay 或窗口级呈现；窗口模式随多窗口阶段实现。
- [ ] `HyperOverlayController<T>`：一次悬浮层的控制器。
- [ ] `HyperOverlayAnchor`：锚定浮层目标。
- [ ] `HyperTooltip`：工具提示，提供 `.plain` 与 `.rich` 形态。
- [ ] `HyperMenu`：菜单。
- [ ] `HyperCascadingMenu`：桌面悬浮子菜单与移动端层级变换共用数据模型的级联菜单。
- [ ] `HyperMenuItem`：菜单项。
- [ ] `HyperMenuBar`：桌面菜单栏。
- [ ] `HyperContextMenu`：右键或长按菜单。
- [ ] `HyperDropdownMenu<T>`：下拉菜单。
- [ ] `HyperPopup`：通用弹出层。
- [ ] `HyperPopover`：带锚点的内容浮层。
- [ ] `HyperCommandPalette`：命令面板。
- [ ] `HyperActionSheet`：移动端操作面板。
- [ ] `HyperBottomSheet`：底部面板。
- [ ] `HyperModalBottomSheet`：模态底部面板。
- [ ] `HyperSideSheet`：侧边面板。
- [ ] `HyperDatePickerDialog`：日期选择浮层。
- [ ] `HyperTimePickerDialog`：时间选择浮层。
- [ ] `HyperColorPickerDialog`：颜色选择浮层。

## 十五、对话框与模态界面

- [ ] `HyperDialog`：标准对话框。
- [ ] `HyperAlertDialog`：警告对话框。
- [ ] `HyperConfirmDialog`：确认对话框。
- [ ] `HyperInputDialog`：输入对话框。
- [ ] `HyperSelectionDialog<T>`：选项对话框。
- [ ] `HyperFullScreenDialog`：全屏对话框。
- [ ] `HyperAboutDialog`：关于对话框。
- [ ] `HyperLicensePage`：许可证页面。
- [ ] `HyperProgressDialog`：阻塞进度对话框。
- [ ] `HyperDialogActions`：对话框操作区。
- [ ] `HyperModalBarrier`：统一模态遮罩。

## 十六、提示、反馈与状态

- [ ] `HyperToast`：短暂轻提示。
- [ ] `HyperSnackbar`：带操作的底部提示。
- [ ] `HyperSnackbarHost`：管理 Snackbar 队列、呈现位置和生命周期。
- [ ] `HyperBanner`：页面内横幅提示。
- [ ] `HyperNotification`：通知卡片。
- [ ] `HyperNotificationCenter`：应用内通知列表。
- [ ] `HyperAlert`：内联提示块。
- [ ] `HyperLoadingOverlay`：区域或页面加载遮罩。
- [x] `HyperProgressIndicator`：统一进度入口，通过 `.linear` 和 `.circular` 转发到对应轻量实现。
- [x] `HyperLinearProgressIndicator`：支持确定/不确定进度、明确尺寸、圆角、语义、减少动画和三级主题覆盖。
- [ ] `HyperWormProgressIndicator`：类似蚯蚓伸缩、移动的线性进度，支持确定和不确定进度。
- [~] `HyperCircularProgressIndicator`：确定/不确定进度、设备尺寸、端点、语义、减少动画和三级主题覆盖已完成；`.infinite` 轨道点形态待补充。
- [ ] `HyperLoadingSpinner`：加载旋转器。
- [ ] `HyperActivityIndicator`：活动指示器。
- [ ] `HyperActivityRing`：活动圆环。
- [ ] `HyperProgressRing`：环形进度。
- [ ] `HyperCountdown`：倒计时显示。
- [ ] `HyperSkeleton`：骨架占位。
- [ ] `HyperShimmer`：闪烁加载效果。
- [ ] `HyperRetry`：错误与重试组合。
- [ ] `HyperConnectionStatus`：网络连接状态。
- [ ] `HyperOfflineBanner`：离线提示。

## 十七、媒体与文件

- [ ] `HyperImage`：统一图片加载、占位和错误状态。
- [ ] `HyperImageViewer`：缩放和拖动查看图片。
- [ ] `HyperGallery`：图片或媒体画廊。
- [ ] `HyperCarousel`：轮播。
- [ ] `HyperVideoPlayer`：视频播放界面。
- [ ] `HyperAudioPlayer`：音频播放界面。
- [ ] `HyperMediaController`：播放控制条。
- [ ] `HyperPlaybackButton`：播放和暂停按钮。
- [ ] `HyperVolumeSlider`：音量滑块。
- [ ] `HyperBrightnessSlider`：亮度滑块。
- [ ] `HyperSeekBar`：播放进度定位。
- [ ] `HyperWaveform`：音频波形。
- [ ] `HyperThumbnail`：文件或媒体缩略图。
- [ ] `HyperFileTile`：文件列表项。
- [ ] `HyperFilePickerField`：文件选择字段。
- [ ] `HyperDropZone`：桌面拖放区域。
- [ ] `HyperUpload`：上传状态和操作。
- [ ] `HyperDownload`：下载状态和操作。

## 十八、系统控制与设备状态

- [ ] `HyperQuickSettingsTile`：快捷设置项。
- [ ] `HyperControlCenter`：控制中心布局。
- [ ] `HyperDeviceControl`：设备控制卡片。
- [ ] `HyperConnectivityTile`：网络连接开关。
- [ ] `HyperBluetoothTile`：蓝牙状态与操作。
- [ ] `HyperWifiTile`：Wi-Fi 状态与操作。
- [ ] `HyperAirplaneModeTile`：飞行模式表现层。
- [ ] `HyperBatteryIndicator`：电池状态。
- [ ] `HyperSignalIndicator`：信号状态。
- [ ] `HyperVolumeControl`：系统音量控制界面。
- [ ] `HyperBrightnessControl`：系统亮度控制界面。
- [ ] `HyperMediaSession`：系统媒体会话界面。
- [ ] `HyperDeviceCard`：设备状态卡片。
- [ ] `HyperPermissionPrompt`：权限说明界面，不直接绕过平台权限 API。
- [ ] `HyperBiometricPrompt`：生物识别引导界面，不替代平台认证。

## 十九、偏好设置

- [ ] `HyperPreferences`：设置页面容器。
- [ ] `HyperPreferenceGroup`：设置分组。
- [ ] `HyperPreferenceTile`：基础设置项。
- [ ] `HyperSwitchPreference`：开关设置项。
- [ ] `HyperCheckboxPreference`：复选设置项。
- [ ] `HyperRadioPreference<T>`：单选设置项。
- [ ] `HyperSliderPreference`：滑块设置项。
- [ ] `HyperDropdownPreference<T>`：下拉设置项。
- [ ] `HyperNavigationPreference`：进入下级页面的设置项。
- [ ] `HyperTextFieldPreference`：文本设置项。
- [ ] `HyperColorPreference`：颜色设置项。
- [ ] `HyperAboutPreference`：关于信息项。

## 二十、桌面与窗口专项

- [ ] `HyperWindowFrame`：自定义窗口框架。
- [ ] `HyperTitleBar`：桌面标题栏。
- [ ] `HyperWindowButton`：最小化、最大化和关闭按钮。
- [ ] `HyperWindowCaption`：窗口标题区域。
- [ ] `HyperDragRegion`：窗口拖动区域语义封装。
- [ ] `HyperToolbar`：桌面工具栏。
- [ ] `HyperStatusBar`：桌面状态栏。
- [ ] `HyperMenuBar`：桌面应用菜单。
- [ ] `HyperCommandBar`：命令操作栏。
- [ ] `HyperRibbon`：复杂桌面命令区，可作为扩展组件。
- [ ] `HyperDock`：停靠工具区。
- [ ] `HyperInspectorPanel`：属性检查面板。
- [ ] `HyperPropertyGrid`：属性编辑表格。
- [ ] `HyperTreeSidebar`：树形侧边栏。
- [ ] `HyperDesktopTabs`：可关闭、拖动的桌面标签页。
- [ ] `HyperTabStrip`：标签条。
- [ ] `HyperSplitButton`：桌面主操作和菜单。
- [ ] `HyperContextMenuRegion`：右键菜单区域。
- [ ] `HyperShortcutScope`：快捷键作用域。
- [ ] `HyperShortcutHint`：快捷键提示。
- [ ] `HyperFocusRing`：键盘焦点环。
- [ ] `HyperHoverRegion`：悬停状态区域。
- [ ] `HyperSelectionMarquee`：框选区域。
- [ ] `HyperResizeHandle`：调整尺寸手柄。
- [ ] `HyperWindowSwitcher`：窗口或工作区切换。
- [ ] `HyperTaskbar`：应用内任务栏样式布局。

## 桌面扩展：多窗口专项（正式版阶段）

多窗口能力面向桌面系统，并为平板多场景和未来平台能力预留接口。它不进入当前 P0 基础实现，正式版前以独立里程碑落地。

- [ ] `HyperWindowScope`：单个窗口的主题、导航、焦点和 Overlay 作用域。
- [ ] `HyperWindowManager`：创建、查询、激活和关闭窗口的统一入口。
- [ ] `HyperWindowController`：控制单个窗口标题、边界、状态和生命周期。
- [ ] `HyperWindowHandle`：稳定的窗口身份和跨层引用。
- [ ] `HyperWindowHost`：承载一个独立窗口内容树。
- [ ] `HyperWindowBuilder`：根据窗口描述构建内容。
- [ ] `HyperWindowConfiguration`：窗口初始尺寸、最小最大尺寸、位置和装饰配置。
- [ ] `HyperWindowBounds`：窗口位置与尺寸值对象。
- [ ] `HyperWindowState`：normal、minimized、maximized、fullScreen 等状态。
- [ ] `HyperWindowPlacement`：居中、级联、记忆位置及指定屏幕放置策略。
- [ ] `HyperWindowEventListener`：激活、失焦、移动、缩放和关闭请求监听。
- [ ] `HyperWindowCloseGuard`：未保存内容和异步关闭确认。
- [ ] `HyperWindowRouter`：每个窗口独立导航栈。
- [ ] `HyperWindowOverlayScope`：每个窗口独立的 Dialog、Menu、Tooltip 和 Toast 宿主。
- [ ] `HyperWindowThemeScope`：窗口级主题覆盖和亮暗模式同步策略。
- [ ] `HyperWindowFocusScope`：窗口级焦点和快捷键边界。
- [ ] `HyperWindowSwitcher`：应用内窗口切换界面。
- [ ] `HyperWindowList`：窗口列表和预览。
- [ ] `HyperNewWindowButton`：打开新窗口的语义操作控件。
- [ ] `HyperMoveToWindowMenu`：把文档或任务移动到其他窗口。
- [ ] `HyperWindowTabTransfer`：标签页在窗口之间移动的协议和交互。
- [ ] `HyperScreenPicker`：多显示器目标选择。
- [ ] `HyperScreenInfo`：显示器工作区、缩放和安全区域描述。
+
+多窗口规则：
+
- 每个窗口必须拥有独立的 `BuildContext`、Navigator、FocusScope 和 Overlay，不使用跨窗口静态 Context。
- 全局主题可以共享，但窗口允许局部覆盖；一个窗口切换主题不得意外重建或污染其他窗口。
- Toast、Dialog、Menu 和 Tooltip 默认显示在发起操作的窗口，不允许自动跑到主窗口。
- 窗口关闭时必须释放对应控制器、Overlay、异步任务监听和平台资源。
- 跨窗口共享的是格式化业务状态或稳定标识，不直接共享 Widget、Element、FocusNode 或 AnimationController。
- 窗口尺寸使用 Flutter 逻辑像素，不根据设备像素比或内部密度系数二次缩放。
- 核心 `lemon_ui` 定义平台无关接口和 UI；原生窗口创建能力通过可选平台适配包接入。
- 不支持真实多窗口的平台应提供明确能力检测和单窗口降级，不伪装已经创建独立窗口。
+## 二十一、手机专项

- [ ] `HyperMobileScaffold`：手机页面结构。
- [ ] `HyperBottomNavigation`：手机底部导航。
- [ ] `HyperBottomActionBar`：底部操作区。
- [ ] `HyperSwipeBackRegion`：侧滑返回交互区域。
- [ ] `HyperPullDownPanel`：下拉面板。
- [ ] `HyperMobileAppBar`：大标题和滚动联动标题栏。
- [ ] `HyperKeyboardAvoider`：软键盘避让布局。
- [ ] `HyperSafeBottomBar`：底部安全区操作栏。
- [ ] `HyperMobileContextMenu`：长按菜单。
- [ ] `HyperMobileSelectionToolbar`：移动端文本选择工具栏外观。
- [ ] `HyperPageDots`：页面圆点指示。
- [ ] `HyperSwipeActions`：侧滑操作。
- [ ] `HyperEdgePanel`：屏幕边缘面板。

## 二十二、平板与折叠屏专项

- [ ] `HyperTabletScaffold`：平板页面结构。
- [ ] `HyperNavigationSplitView`：侧栏、列表和详情布局。
- [ ] `HyperMasterDetail`：主从视图。
- [ ] `HyperThreePaneScaffold`：三栏布局。
- [ ] `HyperAdaptiveSidebar`：宽度变化时折叠的侧栏。
- [ ] `HyperFloatingPanel`：平板浮动面板。
- [ ] `HyperTabletToolbar`：平板工具栏。
- [ ] `HyperDetailPane`：详情面板。
- [ ] `HyperSupportingPane`：辅助内容面板。
- [ ] `HyperFoldAwareLayout`：折叠屏铰链和显示区域感知布局。
- [ ] `HyperTwoPageLayout`：双页阅读布局。
- [ ] `HyperDragAndDropRegion`：平板和桌面拖放区域。
- [ ] `HyperPointerAdaptiveRegion`：触摸、鼠标和手写笔适配区域。

## 二十三、手表通用专项

- [ ] `HyperWatchApp`：手表应用基础宿主。
- [ ] `HyperWatchScaffold`：手表页面结构。
- [ ] `HyperWatchTheme`：手表默认视觉和低功耗策略。
- [ ] `HyperWatchSafeArea`：方形和圆形表盘安全区域。
- [ ] `HyperWatchLayout`：手表内容布局。
- [ ] `HyperWatchListView`：小屏列表。
- [ ] `HyperWatchListTile`：手表列表项。
- [ ] `HyperWatchCard`：手表卡片。
- [ ] `HyperWatchButton`：大触控目标按钮。
- [ ] `HyperWatchIconButton`：手表图标按钮。
- [ ] `HyperWatchNavigation`：手表导航。
- [ ] `HyperWatchPageIndicator`：手表页面指示。
- [ ] `HyperWatchDialog`：手表确认和提示。
- [ ] `HyperWatchToast`：手表轻提示。
- [ ] `HyperWatchProgressIndicator`：手表低成本进度。
- [ ] `HyperWatchTimePicker`：手表时间选择。
- [ ] `HyperWatchNumberPicker`：手表数字滚轮。
- [ ] `HyperWatchComplication`：表盘复杂功能展示单元。
- [ ] `HyperWatchComplicationSlot`：复杂功能槽位。
- [ ] `HyperWatchFace`：应用内表盘布局基础，不替代原生表盘平台能力。
- [ ] `HyperAlwaysOnDisplay`：息屏显示视觉模式。
- [ ] `HyperCrownScrollView`：表冠控制滚动。
- [ ] `HyperCrownController`：表冠或旋钮输入抽象。
- [ ] `HyperRotaryFocus`：旋钮焦点切换。
- [ ] `HyperBezelGestureRegion`：表圈手势区域。

## 二十四、圆形手表与弧形 UI

弧形 UI 应考虑圆屏安全区域、角度方向、顺逆时针、起止角、表冠输入、触控命中范围以及文字可读性。

- [ ] `HyperArcLayout`：沿圆弧放置多个子控件。
- [ ] `HyperArcPositioned`：按角度和半径定位子控件。
- [ ] `HyperArcPadding`：以角度或弧长表达的间距。
- [ ] `HyperArcText`：沿圆弧排版文字。
- [ ] `HyperCurvedText`：曲线路径文字。
- [ ] `HyperArcIcon`：沿弧线定位并旋转图标。
- [ ] `HyperArcButton`：弧形按钮。
- [ ] `HyperArcIconButton`：弧形图标按钮。
- [ ] `HyperArcMenu`：环绕式菜单。
- [ ] `HyperRadialMenu`：从中心展开的径向菜单。
- [ ] `HyperRingMenu`：环形分段菜单。
- [ ] `HyperArcNavigation`：圆弧导航栏。
- [ ] `HyperCircularNavigation`：环形导航。
- [ ] `HyperArcTabBar`：弧形标签栏。
- [ ] `HyperArcListView`：沿圆周或圆弧滚动的列表。
- [ ] `HyperCurvedListView`：中间放大、边缘缩小的曲面列表。
- [ ] `HyperRotaryListView`：表冠驱动的列表。
- [ ] `HyperArcSlider`：圆弧滑块。
- [ ] `HyperArcRangeSlider`：圆弧范围滑块。
- [ ] `HyperCircularSlider`：完整圆环滑块。
- [ ] `HyperArcProgressIndicator`：圆弧进度。
- [ ] `HyperCircularProgressIndicator`：完整圆环进度。
- [ ] `HyperSegmentedRing`：分段圆环状态。
- [ ] `HyperActivityRings`：多层活动圆环。
- [ ] `HyperArcGauge`：圆弧仪表。
- [ ] `HyperRadialGauge`：径向仪表盘。
- [ ] `HyperArcTimer`：圆弧计时器。
- [ ] `HyperCircularCountdown`：环形倒计时。
- [ ] `HyperClockDial`：表盘刻度。
- [ ] `HyperClockHand`：时钟指针。
- [ ] `HyperRadialPicker<T>`：径向选项选择。
- [ ] `HyperCircularNumberPicker`：圆形数字选择。
- [ ] `HyperEdgeIndicator`：圆屏边缘状态指示。
- [ ] `HyperEdgeProgress`：沿屏幕边缘显示进度。
- [ ] `HyperEdgeNotification`：圆屏边缘通知效果。
- [ ] `HyperCircularSafeArea`：圆形安全边界约束。
- [ ] `HyperRoundScreenClip`：圆屏预览与裁切。

## 二十五、交互、手势与效果

- [x] `HyperPressable`：统一单击、双击、长按、右键、中键、拖动、悬停、焦点和键盘激活。
- [ ] `HyperGestureRegion`：统一手势区域。
- [ ] `HyperHoverRegion`：鼠标悬停区域。
- [ ] `HyperFocusScope`：组件焦点作用域。
- [ ] `HyperFocusRing`：焦点视觉。
- [ ] `HyperLongPressRegion`：长按操作区域。
- [ ] `HyperDragRegion`：拖动区域。
- [ ] `HyperSwipeRegion`：滑动手势区域。
- [ ] `HyperPinchRegion`：缩放和旋转手势区域。
- [ ] `HyperDismissible`：滑动关闭。
- [ ] `HyperReorderable`：拖动排序。
- [ ] `HyperHapticFeedback`：统一触觉反馈策略。
- [ ] `HyperOverscrollEffect`：统一过度滚动效果。
- [ ] `HyperPressEffect`：按压反馈。
- [ ] `HyperRippleEffect`：仅在明确需要 Material 反馈时使用。
- [ ] `HyperScaleEffect`：显式局部视觉缩放效果，不参与尺寸系统。
- [ ] `HyperFadeEffect`：淡入淡出。
- [ ] `HyperSlideEffect`：位移动画。
- [ ] `HyperSharedAxisTransition`：共享轴转场。
- [ ] `HyperHero`：统一 Hero 默认效果。

## 二十六、无障碍与输入辅助

- [ ] `HyperSemantics`：统一语义配置。
- [ ] `HyperAccessibleTapTarget`：视觉尺寸与触控区域分离。
- [ ] `HyperScreenReaderAnnouncement`：状态播报。
- [ ] `HyperHighContrastScope`：高对比度作用域。
- [ ] `HyperReducedMotionScope`：减少动画作用域。
- [ ] `HyperReducedTransparencyScope`：减少透明效果作用域。
- [ ] `HyperKeyboardListener`：键盘事件封装。
- [ ] `HyperShortcutScope`：快捷键映射。
- [ ] `HyperDirectionalFocusTraversal`：方向键焦点导航。
- [ ] `HyperRotaryFocusTraversal`：表冠焦点导航。
- [ ] `HyperTooltipSemantics`：重要提示的语义补充。

## 二十七、开发、预览与调试组件

这些组件主要服务 Example、测试和主题开发，不一定作为稳定业务 API 发布。

- [ ] `HyperComponentGallery`：组件总览。
- [ ] `HyperComponentPreview`：单组件预览。
- [ ] `HyperThemeEditor`：运行时主题调试。
- [ ] `HyperThemeInspector`：最终属性与来源检查。
- [ ] `HyperDevicePreview`：手机、平板、桌面和手表预览。
- [ ] `HyperRoundWatchPreview`：圆形手表预览。
- [ ] `HyperStatePreview`：批量展示交互状态。
- [ ] `HyperTextScalePreview`：文字缩放预览。
- [ ] `HyperGoldenFrame`：Golden 测试统一框架。
- [ ] `HyperPerformanceOverlay`：组件效果性能调试。
- [ ] `HyperHitTestOverlay`：命中区域调试。
- [ ] `HyperLayoutGrid`：布局网格调试。

## 二十八、参考 lemon_shadcn 后补充

本节基于本地 `lemon_shadcn` 的组件清单、公开导出和 Example 进行差异审查。只吸收 Lemon UI 目录中原本缺失且具有独立语义的能力；与现有控件重合的能力合并处理，不复制其主题耦合或倍率密度系统。

### 动画与数值展示

- [ ] `HyperAnimatedValueBuilder<T>`：按统一动画主题插值任意值。
- [ ] `HyperRepeatedAnimationBuilder`：受生命周期和减少动画策略管理的重复动画。
- [ ] `HyperNumberTicker`：数字滚动和数值变化动画。
- [ ] `HyperEntranceAnimation`：统一进入动画。
- [ ] `HyperLoopAnimation`：统一脉冲、漂浮等循环动画。
- [ ] `HyperDeferredDuringTransition`：页面转场期间延迟高成本内容。

### 披露与展开

- [ ] `HyperAccordion`：互斥或多项展开的内容组。
- [ ] `HyperCollapsible`：单个可折叠区域，支持纵向和横向。
- [ ] `HyperCollapsibleTrigger`：折叠触发区域。
- [ ] `HyperCollapsibleContent`：折叠内容区域。
- [ ] `HyperHoverCard`：桌面悬停或焦点触发的信息卡。
- [ ] `HyperExpandableOverlay`：从原控件位置展开为悬浮内容，并保留原布局占位。

### 高级输入与选择

- [ ] `HyperFormattedInput`：由静态段和可编辑段组成的格式化输入。
- [ ] `HyperFormattedInputController`：格式化输入控制器。
- [ ] `HyperImageInput`：由业务注入图片选择能力的图片输入。
- [ ] `HyperSortableInput<T>`：可拖动排序的集合输入。
- [ ] `HyperObjectInput<T>`：领域对象与格式化值双向转换输入。
- [ ] `HyperItemPicker<T>`：在列表或网格中选择领域对象。
- [ ] `HyperMultipleChoice<T>`：单题单选或多选题式输入。
- [ ] `HyperMultiSelect<T>`：多选下拉或 Token 输入。
- [ ] `HyperCheckboxGroup<T>`：复选框组。
- [ ] `HyperCascader<T>`：级联选择器。
- [ ] `HyperTransfer<T>`：双栏穿梭选择器，主要用于平板和桌面。
- [ ] `HyperInlineEdit<T>`：展示态和编辑态原位切换。
- [ ] `HyperInputGroup`：多个输入框或操作的组合边界。
- [ ] `HyperInputGroupAddon`：输入组的前后附加内容。
- [ ] `HyperOption<T>`：Select、Autocomplete、Combobox 等共用的格式化选项模型。
- [ ] `HyperAsyncOptionSource<T>`：带缓存、过期结果保护和分页能力的异步选项源。

### 数据与内容展示

- [ ] `HyperTracker`：按时间或序列展示离散状态块。
- [ ] `HyperDescriptions`：响应式描述信息列表，支持键值和表格式布局。
- [ ] `HyperItem`：比 ListTile 更通用的标题、说明、前后内容单元。
- [ ] `HyperItemGroup`：关联内容单元组。
- [ ] `HyperCornerBadge`：贴附在内容角落的状态标识。
- [ ] `HyperDotIndicator`：离散状态点或轮播位置点。
- [ ] `HyperOverflowMarquee`：内容溢出时的可控跑马灯。
- [ ] `HyperChat`：聊天消息列表和布局。
- [ ] `HyperChatBubble`：聊天气泡，支持方向、尾部和圆角策略。
- [ ] `HyperPinnedSheet`：可停靠在多个阶段的拖动面板。
- [ ] `HyperRefreshTrigger`：把刷新意图与具体刷新指示器分离的触发器。
- [ ] `HyperSwiper`：手势驱动的卡片或内容切换器；与 Carousel 共用底层分页能力。

### 锚定浮层与桌面交互

- [ ] `HyperAnchoredOverlay`：点击、悬停、焦点或受控触发的通用锚定浮层。
- [ ] `HyperPointerTooltip`：跟随鼠标并自动避让窗口边缘的 Tooltip。
- [ ] `HyperInstantTooltip`：无默认等待时间的即时提示。
- [ ] `HyperMovableDialog`：可拖动和可选调整大小的桌面对话框。
- [ ] `HyperPopupSwitchCoordinator`：同组 Popup 之间的替换、互斥和焦点协调。
- [ ] `HyperNavigationMenu`：适合桌面和大屏的分组导航菜单。
- [ ] `HyperContentSwitcher`：在多个内容面板之间切换并统一动画，替代语义含糊的 Switcher 命名。

### 图表体系

- [ ] `HyperChartThemeData`：与 DataGrid、Card 等主题完全隔离的图表主题。
- [ ] `HyperChartAxis`：坐标轴、格式化和预留空间。
- [ ] `HyperChartReferenceLine`：参考线和阈值线。
- [ ] `HyperChartSelection`：Hover、键盘浏览和显式持续选中模型。
- [ ] `HyperChartLegend`：统一图例。
- [ ] `HyperChartCard`：标题、说明、操作区和固定绘图区组合。
- [ ] `HyperAsyncChart<T>`：保持尺寸稳定的 loading、error、empty 和 data 图表状态。
- [ ] `HyperBarChart`：单系列、多系列、堆叠和横向柱状图。
- [ ] `HyperLineChart`：折线、面积和阶梯图变体。
- [ ] `HyperPieChart`：饼图和环形图变体。
- [ ] `HyperScatterChart`：散点图。
- [ ] `HyperRadarChart`：雷达图。
- [ ] `HyperCandlestickChart`：K 线图。
- [ ] `HyperRankBarChart`：排名和占比条形图。
- [ ] `HyperHeatmap`：热力图。
- [ ] `HyperTreemap`：矩形树图。
- [ ] `HyperChartExportBoundary`：图表导出边界。
- [ ] `HyperChartExportController`：导出 `ui.Image` 或 PNG 字节，不处理平台文件保存。

### 合并到已有组件、不新增重复入口

- `CodeSnippet` 合并到 `HyperCodeBlock`，通过复制操作和语言标签配置完成。
- `Switcher` 使用语义更明确的 `HyperContentSwitcher`；布尔开关仍使用 `HyperSwitch`。
- `BackdropTransform` 作为 Overlay 的背景变换策略，不建立每个浮层的独立变体。
- `ScaleBackdropTransform` 属于显式浮层动画，不进入控件尺寸或密度系统。
- `ScaleEffect` 只作为显式视觉效果，不参与尺寸解析。
- `Progress`、`CircularProgress`、`LinearProgress` 继续归入现有统一进度体系。
- `SelectableText`、`Scrollbar`、`Carousel`、`Table`、`Tree`、`Window` 等沿用目录中已有入口。
- `AsyncButton` 不新增独立控件，继续由 `HyperButton.onPressed` 的 `FutureOr<void>` 统一处理。

### 明确不继承的设计

- 不引入 `lemon_shadcn` 的 `AppDensity` 或任何控件内部倍率缩放。
- 不直接别名或重新导出 shadcn_flutter 控件，Hyper 控件保持独立稳定的公开 API。
- 不让多个 Hyper 控件通过共享公开组件主题产生视觉耦合。
- 不复制其组件源码；只参考组件范围、交互场景和测试经验。
## 建议实现顺序

### 阶段 0：基础协议

- `HyperTheme`、`HyperThemeData`、颜色、文字、尺寸、动画和状态类型。
- `HyperFill`、边框、阴影和形状。
- 主题解析、`copyWith`、`lerp`、局部覆盖及 Debug 来源检查。

### 阶段 1：验证架构

- `HyperContainer`
- `HyperSurface`
- `HyperButton`
- `HyperIconButton`
- `HyperTextField`
- `HyperForm`

这批组件用于验证视觉属性独立、显式尺寸、主题优先级、动画、异步和表单尺寸稳定性。

### 阶段 2：基础交互

- Checkbox、Radio、Switch、Slider、Chip、SegmentedButton。
- Pressable、FocusRing、Tooltip 和基础 Overlay。

### 阶段 3：页面结构

- Scaffold、AppBar、NavigationBar、NavigationRail、Sidebar、TabBar。
- 手机、平板和桌面自适应页面结构。

### 阶段 4：浮层与反馈

- Menu、Popover、Dialog、BottomSheet、Toast、Snackbar。
- Progress、Skeleton、EmptyState、ErrorView。

### 阶段 5：数据与高级输入

- List、Table、Tree、PagedList、DatePicker、TimePicker、Autocomplete。

### 阶段 6：桌面专项

- WindowFrame、TitleBar、Toolbar、ContextMenu、ShortcutScope、ResizablePane。

### 阶段 7：手表专项

- WatchScaffold、WatchList、CrownScrollView、WatchNavigation。
- ArcLayout、ArcText、ArcSlider、ArcProgress、RingMenu 和圆屏安全区域。

### 阶段 8：媒体、系统控制与扩展包

- 图片、音视频、文件、系统控制、图表、富文本编辑等能力。

## 单个控件完成标准

一个控件只有同时满足以下条件才标记为 `[x]`：

- 公开 API 与 Flutter 命名习惯一致。
- 控件文件和独立主题文件完成。
- 实例属性、控件主题、全局主题和默认值优先级正确。
- 显式尺寸不受任何倍率缩放。
- 普通、禁用及适用的异步状态完整。
- 动画、减少动画和主题切换行为完整。
- 手机、平板、桌面和手表的适用策略明确。
- 键盘、鼠标、触摸、焦点、语义和 RTL 行为适用时完整。
- Example 中包含可运行、可直观看到效果的 Demo，以及全部关键状态和主题覆盖对照。
- Widget 测试、主题测试和必要的 Golden 测试通过。
- API 文档和迁移说明完整。
