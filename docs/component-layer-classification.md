# Lemon UI 控件分层与实现优先级

本文档对 [全量控件目录](component-catalog.md) 中的规划项进行实现分层。全量目录继续负责记录所有控件及完成状态；本文档只负责判断哪些能力应先实现，以及高级控件依赖哪些基础能力。

## 一、分层定义

### 基础控件

满足以下一项或多项：

- 能作为多个高级控件的公共积木。
- 状态模型简单，可主要由 Flutter 原生控件组合完成。
- 不依赖业务数据源、复杂 Overlay、多窗口或平台插件。
- 是普通页面、表单、列表和导航的高频组成部分。

基础不代表 API 可以随意简化。每个基础控件仍需具有独立主题、实例覆盖、设备尺寸、交互、语义、Demo 和测试。

### 高级控件

满足以下一项或多项：

- 由多个基础控件组合而成，并管理复杂状态或数据模型。
- 依赖 Overlay、焦点协调、拖放、虚拟化、路由或异步数据源。
- 面向特定平台、窗口形态、媒体能力或圆形手表。
- 属于图表、编辑器、复杂选择器、数据网格等专业领域组件。

高级控件后置不等于删除。必须先稳定其依赖的基础控件，避免高级控件反向迫使公共样式发生破坏性变化。

## 二、重复项合并规则

下列名称在全量目录的不同场景中重复出现，只实现一个正式控件，通过变体、组合或适配策略覆盖场景：

- 同一数据语义和交互模型、只改变方向/内容/状态/视觉形态的条目按一个控件家族维护；规划清单只保留主控件，子名称写成构造器或配置变体。已有公开兼容入口可继续转发，但不再作为独立控件或独立主题规划。

- `HyperMenuBar`：菜单分类与桌面专项共用。
- `HyperSplitButton`：按钮分类与桌面专项共用。
- `HyperHoverRegion`、`HyperFocusRing`、`HyperShortcutScope`：桌面专项与交互辅助共用。
- `HyperDragRegion`：普通拖动区域与窗口拖动语义通过明确参数或专用适配层区分。
- `HyperMasterDetail`、`HyperNavigationSplitView`：通用大屏布局与平板专项共用。
- `HyperCircularSlider`、`HyperCircularProgress`：通用版本提供基础能力，手表只提供尺寸和交互适配。
- `HyperWindowSwitcher`：桌面单窗口阶段只提供界面，多窗口阶段再接入真实窗口模型。
- `HyperChartLegend` 作为正式图表图例；原 `HyperLegend` 不再单独实现。
- `HyperDescriptionList` 是当前正式公开 API；`HyperDescriptions` 只是规划过的命名，不额外建立别名或重复实现。
- `HyperAsyncButton` 不单独实现，由 `HyperButton` 的统一异步回调覆盖。
- 按钮的 `.filled`、`.tonal`、`.outlined`、`.ghost`、`.text`、`.gradient` 等构造器是 `HyperButton` / `HyperIconButton` 的外观入口；Chip 的 action/choice/filter/input 是 `HyperChip` 的语义构造器。
- `HyperInitialsAvatar` 由 `HyperAvatar.text` 覆盖；`HyperVerticalDivider` 使用 `HyperDivider.vertical`；`HyperOverflowMarquee` 对应 `HyperScrollingText` 的溢出滚动能力。
- `HyperDropdown` 是自定义锚定面板容器，选择数据模型复用 `HyperSelect`；它不是另一个下拉选项模型。
- `HyperDatePicker`、`HyperTimePicker` 是基于 `HyperDateTimePicker` 的便捷包装；`HyperDateTimeRangePicker` 是独立范围控件。
- `HyperCard` 覆盖有标题和 action 的卡片布局；`HyperTitledCard` 是快捷布局入口，不作为第二种卡片主题体系。
- `HyperTextField` 覆盖单行/多行字段布局；`HyperTextArea` 是多行内容增长预设。FormField 对应项只是绑定适配器。
- `HyperAppBar` 覆盖普通、medium、large 和滚动折叠形态；`HyperSliverAppBar` 仅为 Sliver 布局适配入口。
- `HyperListTile` 通过 leading、subtitle、trailing、onTap 与控制器槽位覆盖导航、复选、单选、开关和弹出选择行；`HyperNavigationListTile`、`HyperCheckboxListTile`、`HyperRadioListTile`、`HyperSwitchListTile` 保留为预设/兼容包装，不各自建立主题体系。
- `HyperButton` 覆盖 filled、tonal、outlined、ghost、text、gradient、floating、extended、back、close 等款式；异步为回调状态，图标按钮和菜单按钮分别作为紧凑内容及菜单动作适配。
- `HyperSlider` 覆盖单值、范围、竖向、缓冲进度和 capsule 外观；`HyperCapsuleSlider` 因整块拖动区域和独立上下图标操作保留专用交互入口。
- `HyperNumberInput` 覆盖计数器/步进器款式；`HyperWheelPicker<T>` 覆盖数字滚轮作为类型特化，不另规划 `HyperNumberPicker`。
- `HyperTextField` 的键盘类型、遮蔽、格式化器和清除选项覆盖密码、数字、邮件、电话及 URL 输入变体；多格 PIN/OTP 保留为不同布局控件。
- `HyperText` 的语义样式覆盖 Label、Caption 和 SelectableText；`HyperLink` 保留独立点击与链接语义。
- `HyperProgress` 以 linear、circular、infinite 作为形态/运行模式；环形、线形和不确定进度 API 共享同一进度主题。
- `HyperImage` 同时覆盖 asset、file、memory、network 来源以及占位/错误状态；不另建 `HyperNetworkImage`。
- `HyperAdaptiveScaffold` 以设备策略覆盖 mobile、tablet、desktop、watch 页面框架；平台专属页面可以组合，不另建一套同职责 Scaffold。
- `HyperCarousel` 覆盖轮播/Swiper 的手势和分页展示；`HyperCarouselView`、`HyperSwiper` 不另建平行组件，底层分页能力共用。
- `HyperCollapsible` 表达单块展开；`HyperAccordion` 管理多项展开集合与互斥规则，是其组合，保留独立接口。
- `HyperDurationPicker` 以 mode 覆盖 timer/countdown 配置；范围时间选择仍由 `HyperDateTimeRangePicker` 表达。
- `HyperCircularProgress`、`HyperArcProgressIndicator`、`HyperWatchProgressIndicator` 共用进度数据与语义，圆弧和设备差异作为形态/尺寸策略。
- `HyperCircularProgress`、`HyperLinearProgress`、`HyperInfiniteProgress` 是进度展示 API；`HyperProgress` 提供统一入口，不额外重复实现一套视觉。
- `HyperBlendedAvatar` 是 `HyperAvatarGroup` 的 blended 布局渲染器，不作为独立头像控件规划；现有公开类继续兼容。
- `HyperColorPickerField` 和 `HyperColorPickerDialog` 是 `HyperColorPicker` 的表单触发与浮层呈现适配，不新增不同语义的颜色选择器。
- `HyperColorSwatchPicker` 不单独实现；色板能力包含在 `HyperColorPicker` 的 palette 中。
- `HyperDatePickerDialog` 和 `HyperTimePickerDialog` 由日期/时间 Picker 的呈现策略覆盖；`HyperAlertDialog`、`HyperConfirmDialog`、`HyperInputDialog`、`HyperSelectionDialog<T>` 和 `HyperFullScreenDialog` 由 `HyperDialog` 的内容与布局组合覆盖，不作为独立控件规划。
- 已统一：空内容使用 `HyperResult.empty`；横幅使用 `HyperAlert.banner`；步骤导航使用 `HyperStepIndicator.navigation`。主题与四端尺寸归入各自组件的变体字段。

当前公开且有实现的控件按目录索引维护于 [已实现控件索引](implemented-components.md)。规划分层清单不表示该项尚未实现；状态以全量目录及索引为准。

## 三、基础控件

### B0：基础设施与已完成核心

这是所有后续控件的底座，优先级最高。

- 主题与值对象：`HyperTheme`、`HyperThemeData`、`HyperColorScheme`、`HyperContrastThemeData`、`HyperContrastTheme`、`HyperTextTheme`、`HyperSizeScheme`、`HyperMotionThemeData`、`HyperDeviceThemeData`、`HyperOverlayThemeData`。
- 材质与装饰：`HyperFill`、`HyperBorder`、`HyperShadow`、`HyperMaterialQuality`、`HyperSurfaceMaterial`、`HyperMaterialThemeData`、`HyperMaterialTheme`。
- 状态与设备：`HyperControlState`、`HyperStateValue<T>`、`HyperAsyncState<T>`、`HyperAsyncConcurrency`、`HyperDeviceType`、`HyperDeviceDetector`。
- 交互与辅助：`HyperPressable`、`HyperGestureRegion`、`HyperHoverRegion`、`HyperFocusScope`、`HyperFocusRing`、`HyperAccessibleTapTarget`、`HyperSemantics`。
- 当前已完成的视觉核心：`HyperContainer`、`HyperMaterialSurface`、`HyperText`、`HyperIcon`、`HyperDivider`、`HyperProgress`、`HyperLinearProgress`、`HyperCircularProgress`、`HyperButton`、`HyperIconButton`、`HyperCheckbox`、`HyperRadio<T>`、`HyperSwitch`。

### B1：文字、图标、表面与轻量布局

这些控件先于输入、列表、弹层和导航实现。

- 内容：`HyperText`、`HyperRichText`、`HyperIcon`、`HyperIconLabel`、`HyperLink`、`HyperKbd`、`HyperTag`、`HyperStatusIndicator`、`HyperAvatar`、`HyperAvatarGroup`、`HyperPlaceholder`。SelectableText、Label、Caption 为 HyperText 的选择/排版预设；InitialsAvatar 为 HyperAvatar 的 text 模式。
- 表面：`HyperSurface`、`HyperCard`、`HyperPanel`、`HyperSection`、`HyperGroupBox`、`HyperDivider`、`HyperBadge`、`HyperBadgeAnchor`。TitledCard、VerticalDivider 分别作为 Card 标题布局和 Divider 方向变体。
- 间距与约束：`HyperSpacer`、`HyperGap`、`HyperAspectRatio`、`HyperConstrainedBox`、`HyperSafeArea`。
- 常用布局：`HyperRow`、`HyperColumn`、`HyperWrap`、`HyperStack`、`HyperGrid`、`HyperWidgetGroup`、`HyperScrollable`、`HyperScrollbar`。
- 响应式构建：`HyperResponsiveBuilder`，通过空间、断点、方向和稳定设备类别策略选择布局。

### B2：基础操作、选择与调节

- 按钮：`HyperButton`、`HyperIconButton`、`HyperButtonBar`、`HyperSegmentedButton`、`HyperActionChip`、`HyperCopyButton`。Floating/Extended/Back/Close/Toggle 按钮作为 HyperButton 预设或状态；按钮分组复用 WidgetGroup。
- 选择组合：`HyperRadioGroup<T>`、`HyperChip`、`HyperToggleGroup<T>`。Checkbox/Radio/Switch ListTile 是 ListTile 控制槽预设；Choice/Filter/Input Chip 是 HyperChip 构造器。
- 基础数值调节：`HyperSlider`、`HyperCapsuleSlider`、`HyperNumberInput`、`HyperLevelIndicator`。范围、方向和缓冲值作为 Slider 变体；步进/计数作为 NumberInput 预设。CapsuleSlider 保留独立交互入口。
- 常用状态切换：`HyperFavoriteButton`、`HyperLikeButton`、`HyperRating`。

### B3：进度、提示与页面状态

- 进度：`HyperProgress`、`HyperWormProgressIndicator`、`HyperLoadingSpinner`。Linear/Circular/Infinite、ActivityIndicator/ActivityRing/ProgressRing 归为形态和运行模式，不建立平行数据/主题体系。
- 页面状态：`HyperAsyncView<T>`、`HyperResult`、`HyperRetry`。Empty/Error 是 Result 状态预设；旧入口作为兼容包装。
- 轻量反馈：`HyperAlert`、`HyperLoadingOverlay`、`HyperSkeleton`、`HyperCountdown`、`HyperConnectionStatus`、`HyperOfflineBanner`。Banner 是 Alert 的区域横幅布局变体。
- 基础状态展示：`HyperTimeline`、`HyperStepIndicator`、`HyperMetric`、`HyperStatCard`、`HyperDotIndicator`、`HyperTracker`。

### B4：文本输入与表单底座

- 输入核心：`HyperEditableText`、`HyperTextField`、`HyperTextFormField`、`HyperTextArea`、`HyperNumberInput`。Search/Password 为 TextField 配置模式。
- 便捷输入：`HyperPinInput`、`HyperOtpInput`、`HyperSearchBar`。Email/Phone/URL/Password/Numeric 是 TextField 配置变体。
- 表单底座：`HyperForm`、`HyperFormField<T>`、`HyperFormScope`、`HyperFormController`、`HyperFormSection`、`HyperFormGroup`、`HyperFieldLabel`、`HyperFieldMessage`、`HyperValidationMessage`、`HyperFormActions`、`HyperFormSummary`、`HyperAsyncValidator<T>`。
- 输入组合协议：`HyperInputGroup`、`HyperInputGroupAddon`、`HyperOption<T>`。

### B5：列表、内容单元与基础数据展示

- 列表：`HyperListView`、`HyperListTile`、`HyperItem`、`HyperItemGroup`、`HyperSettingsTile`、`HyperActionTile`、`HyperUserTile`、`HyperMediaTile`、`HyperExpandableTile`。导航/复选/单选/开关行是 HyperListTile 预设。
- 集合：`HyperGroupedList`、`HyperReorderableList`、`HyperRefreshIndicator`、`HyperSliverAppBar`、`HyperSliverList`、`HyperSliverGrid`、`HyperStickyHeader`。
- 数据展示：`HyperTable`、`HyperKeyValueTable`、`HyperDescriptionList`、`HyperTreeView<T>`。
- 设置组合：`HyperPreferences`、`HyperPreferenceGroup`、`HyperPreferenceTile`、`HyperSwitchPreference`、`HyperCheckboxPreference`、`HyperRadioPreference<T>`、`HyperSliderPreference`、`HyperDropdownPreference<T>`、`HyperNavigationPreference`、`HyperTextFieldPreference`、`HyperColorPreference`、`HyperAboutPreference`。

### B6：Overlay、菜单与对话框底座

这一组仍属于基础层，但必须在 B0 至 B5 稳定后实现。

- Overlay 核心：`HyperOverlayScope`、`HyperOverlayPresentation`、`HyperOverlayController<T>`、`HyperOverlayAnchor`、`HyperAnchoredOverlay`、`HyperModalBarrier`。
- 提示与菜单：`HyperTooltip`、`HyperMenu`、`HyperMenuItem`、`HyperContextMenu`、`HyperSelect<T>`、`HyperPopup`、`HyperPopover`。
- 页面浮层：`HyperBottomSheet`、`HyperSideSheet`。ActionSheet 为 BottomSheet 的 action 内容预设；模态调用统一使用 `showHyperBottomSheet`。
- 对话框：`HyperDialog`、`HyperDialogActions`、`HyperProgressDialog`。
- 队列反馈：`HyperToast`、`HyperSnackbar`、`HyperSnackbarHost`、`HyperNotification`。

### B7：页面结构与基础导航

- 页面结构：`HyperScaffold`、`HyperAdaptiveScaffold`、`HyperAppBar`、`HyperBottomAppBar`。Mobile/Tablet/Watch Scaffold 是设备策略预设。
- 导航：`HyperNavigationBar`、`HyperNavigationRail`、`HyperDrawer`、`HyperSidebar`。Destination 是目标数据/配置，不独立计作控件；Bar/Rail/Drawer 保留不同布局职责。
- 页内切换：`HyperTabBar`、`HyperTabBarView`、`HyperPageView`、`HyperPageIndicator`、`HyperBreadcrumb`、`HyperPagination`。SegmentedNavigation 由 TabBar.segmented/SegmentedButton 覆盖；PageDots 是 PageIndicator 的圆点款式。
- 路由：`HyperRouteTransition`、`HyperNavigationObserver`。
- 基础自适应页面：`HyperMobileScaffold`、`HyperTabletScaffold`、`HyperNavigationSplitView`、`HyperMasterDetail`。

## 四、高级控件

### A1：高级视觉、形状与动画

- 形状：`HyperShape`、`HyperRoundedShape`、`HyperContinuousShape`、`HyperStadiumShape`、`HyperCircleShape`、`HyperBeveledShape`、`HyperPolygonShape`、`HyperStarShape`、`HyperArrowShape`、`HyperNotchedShape`、`HyperWaveShape`、`HyperSymbolShape`、`HyperCustomShape`。
- 形变：`HyperShapeMorph`、`HyperShapeTween`。
- 高级装饰：`HyperClip`、`HyperBlur`、`HyperGlass`、`HyperGradientBorder`、`HyperDashedBorder`、`HyperHighlight`、`HyperBannerBadge`、`HyperCornerBadge`。
- 动画工具：`HyperAnimatedValueBuilder<T>`、`HyperRepeatedAnimationBuilder`、`HyperNumberTicker`、`HyperEntranceAnimation`、`HyperLoopAnimation`、`HyperDeferredDuringTransition`。
- 效果：`HyperOverscrollEffect`、`HyperPressEffect`、`HyperRippleEffect`、`HyperScaleEffect`、`HyperFadeEffect`、`HyperSlideEffect`、`HyperSharedAxisTransition`、`HyperHero`。

### A2：高级布局、集合与桌面交互

- 布局：`HyperFlow`、`HyperResponsiveGrid`、`HyperMasonryGrid`、`HyperStaggeredGrid`、`HyperSplitView`、`HyperResizablePanel`、`HyperResizablePane`、`HyperCollapsiblePane`、`HyperScaledBox`。
- 集合：`HyperSwipeAction`、`HyperSwipeActions`、`HyperPagedList`、`HyperInfiniteList`、`HyperPullToRefresh`、`HyperRefreshTrigger`。CarouselView/Swiper 作为 HyperCarousel 的布局/手势模式。
- 折叠：`HyperAccordion`、`HyperCollapsible`、`HyperCollapsibleTrigger`、`HyperCollapsibleContent`。
- 高级手势：`HyperLongPressRegion`、`HyperDragRegion`、`HyperSwipeRegion`、`HyperPinchRegion`、`HyperDismissible`、`HyperReorderable`、`HyperHapticFeedback`、`HyperSelectionMarquee`、`HyperResizeHandle`。

### A3：高级输入、选择器与日期时间

- 输入与建议：`HyperAutocomplete<T>`、`HyperSelect<T>`、`HyperComboBox<T>`、`HyperSearchAnchor`、`HyperTagInput<T>`、`HyperMentionInput<T>`、`HyperFormattedInput`、`HyperFormattedInputController`、`HyperImageInput`、`HyperSortableInput<T>`、`HyperObjectInput<T>`、`HyperInlineEdit<T>`。
- 复杂选择：`HyperColorPicker`、`HyperWheelPicker<T>`、`HyperItemPicker<T>`、`HyperMultipleChoice<T>`、`HyperMultiSelect<T>`、`HyperCheckboxGroup<T>`、`HyperCascader<T>`、`HyperTransfer<T>`、`HyperAsyncOptionSource<T>`。色板并入 ColorPicker；数字滚轮是 WheelPicker<int> 特化；MultiSelect 并入 Select/Autocomplete 的多选模式。
- 高级调节：`HyperDial`、`HyperKnob`、`HyperCircularSlider`、`HyperRangeDial`、`HyperScrubber`。ProgressSlider 使用 Slider 的 buffer/进度预设。
- 日期时间：`HyperDateTimePicker`、`HyperDateTimeRangePicker`、`HyperCalendar`、`HyperAgenda`、`HyperSchedule`、`HyperTimezonePicker`。DatePicker/TimePicker 为单值 Picker 模式；CalendarView/Grid 为 Calendar 视图；Timer/Countdown 为 DurationPicker 模式；TimeRangePicker 为 DateTimeRangePicker 的 time 模式。

### A4：高级 Overlay、菜单、导航与模态

- 菜单：`HyperMenuButton`、`HyperSplitButton`、`HyperMenuBar`、`HyperCascadingMenu`、`HyperCommandPalette`、`HyperNavigationMenu`。DropdownButton 是 MenuButton 触发预设；ContextMenu 是 Menu 的右键/长按触发预设。
- 高级浮层：`HyperHoverCard`、`HyperExpandableOverlay`、`HyperPointerTooltip`、`HyperInstantTooltip`、`HyperPopupSwitchCoordinator`、`HyperPinnedSheet`。
- 高级对话框：`HyperAboutDialog`、`HyperLicensePage`、`HyperMovableDialog`。
- 高级导航：`HyperFloatingToolbar`、`HyperNavigationSplitView` 的三栏模式、`HyperContentSwitcher`。Floating/Extended action 和 StepIndicator.navigation 是 Button/StepIndicator 家族预设。

### A5：高级数据、图表和专业内容

- 数据：`HyperDataTable`、`HyperPaginatedDataTable`、`HyperDataGrid`、`HyperTreeTable<T>`、`HyperChartContainer`、`HyperSparkline`、`HyperGauge`。
- 图表基础：`HyperChartThemeData`、`HyperChartAxis`、`HyperChartReferenceLine`、`HyperChartSelection`、`HyperChartLegend`、`HyperChartCard`、`HyperAsyncChart<T>`。
- 图表类型：`HyperBarChart`、`HyperLineChart`、`HyperPieChart`、`HyperScatterChart`、`HyperRadarChart`、`HyperCandlestickChart`、`HyperRankBarChart`、`HyperHeatmap`、`HyperTreemap`。
- 图表导出：`HyperChartExportBoundary`、`HyperChartExportController`。
- 专业内容：`HyperMarkdown`、`HyperCodeBlock`、`HyperRichTextEditor`、`HyperChat`、`HyperChatBubble`、`HyperOverflowMarquee`。

### A6：媒体、文件与系统控制

- 图片：`HyperImage`、`HyperImageViewer`、`HyperGallery`、`HyperCarousel`、`HyperThumbnail`。NetworkImage 是 HyperImage 的 source 变体。
- 音视频：`HyperVideoPlayer`、`HyperAudioPlayer`、`HyperMediaController`、`HyperWaveform`。PlaybackButton、BrightnessSlider、SeekBar 是 Button/Slider 的语义预设。
- 文件：`HyperFileTile`、`HyperDropZone`、`HyperUpload`、`HyperDownload`。文件选择 UI 使用 `HyperFilePicker`，Form 接入由 `HyperFileFormField` 提供。
- 系统界面：`HyperQuickSettingsTile`、`HyperControlCenter`、`HyperDeviceControl`、`HyperConnectivityTile`、`HyperBluetoothTile`、`HyperWifiTile`、`HyperAirplaneModeTile`、`HyperBatteryIndicator`、`HyperSignalIndicator`、`HyperVolumeControl`、`HyperBrightnessControl`、`HyperMediaSession`、`HyperDeviceCard`、`HyperPermissionPrompt`、`HyperBiometricPrompt`。

### A7：桌面、窗口、平板与折叠屏专项

- 桌面外壳：`HyperWindowFrame`、`HyperTitleBar`、`HyperWindowCaption`、`HyperToolbar`、`HyperStatusBar`、`HyperCommandBar`、`HyperRibbon`、`HyperDock`、`HyperInspectorPanel`、`HyperPropertyGrid`、`HyperTreeSidebar`、`HyperDesktopTabs`、`HyperTabStrip`、`HyperContextMenuRegion`、`HyperShortcutScope`、`HyperShortcutHint`、`HyperWindowSwitcher`、`HyperTaskbar`。WindowButton 是 HyperButton 的系统窗口操作款。
- 多窗口：`HyperWindowScope`、`HyperWindowManager`、`HyperWindowController`、`HyperWindowHandle`、`HyperWindowHost`、`HyperWindowBuilder`、`HyperWindowConfiguration`、`HyperWindowBounds`、`HyperWindowState`、`HyperWindowPlacement`、`HyperWindowEventListener`、`HyperWindowCloseGuard`、`HyperWindowRouter`、`HyperWindowOverlayScope`、`HyperWindowThemeScope`、`HyperWindowFocusScope`、`HyperWindowList`、`HyperNewWindowButton`、`HyperMoveToWindowMenu`、`HyperWindowTabTransfer`、`HyperScreenPicker`、`HyperScreenInfo`。
- 手机专项组合：`HyperBottomActionBar`、`HyperSwipeBackRegion`、`HyperPullDownPanel`、`HyperKeyboardAvoider`、`HyperSafeBottomBar`、`HyperMobileSelectionToolbar`、`HyperEdgePanel`。BottomNavigation、MobileAppBar、MobileContextMenu、PageDots 归入 NavigationBar、AppBar、ContextMenu、PageIndicator 的设备/样式预设。
- 平板与折叠屏：`HyperThreePaneScaffold`、`HyperAdaptiveSidebar`、`HyperFloatingPanel`、`HyperTabletToolbar`、`HyperDetailPane`、`HyperSupportingPane`、`HyperFoldAwareLayout`、`HyperTwoPageLayout`、`HyperDragAndDropRegion`、`HyperPointerAdaptiveRegion`。

### A8：手表和圆形 UI

- 手表专项：`HyperWatchApp`、`HyperWatchSafeArea`、`HyperWatchLayout`、`HyperWatchComplication`、`HyperWatchComplicationSlot`、`HyperWatchFace`、`HyperAlwaysOnDisplay`、`HyperCrownScrollView`、`HyperCrownController`、`HyperRotaryFocus`、`HyperBezelGestureRegion`。按钮、列表、导航、提示、进度、日期和数字控件复用通用组件的 watch 尺寸与呈现策略。
- 圆形布局：`HyperArcLayout`、`HyperArcPositioned`、`HyperArcPadding`、`HyperArcText`、`HyperCurvedText`、`HyperArcIcon`、`HyperCircularSafeArea`、`HyperRoundScreenClip`。
- 圆形交互：`HyperArcButton`、`HyperArcIconButton`、`HyperArcMenu`、`HyperRadialMenu`、`HyperRingMenu`、`HyperArcNavigation`、`HyperCircularNavigation`、`HyperArcTabBar`、`HyperArcListView`、`HyperCurvedListView`、`HyperRotaryListView`。
- 圆形调节与展示：`HyperArcSlider`、`HyperArcRangeSlider`、`HyperArcProgressIndicator`、`HyperSegmentedRing`、`HyperActivityRings`、`HyperArcGauge`、`HyperRadialGauge`、`HyperArcTimer`、`HyperCircularCountdown`、`HyperClockDial`、`HyperClockHand`、`HyperRadialPicker<T>`、`HyperCircularNumberPicker`、`HyperEdgeIndicator`、`HyperEdgeProgress`、`HyperEdgeNotification`。

### A9：无障碍、调试和开发工具

- 无障碍高级能力：`HyperScreenReaderAnnouncement`、`HyperHighContrastScope`、`HyperReducedMotionScope`、`HyperReducedTransparencyScope`、`HyperKeyboardListener`、`HyperDirectionalFocusTraversal`、`HyperRotaryFocusTraversal`、`HyperTooltipSemantics`。
- 调试工具：`HyperThemeInspector`、`HyperComponentGallery`、`HyperComponentPreview`、`HyperThemeEditor`、`HyperDevicePreview`、`HyperRoundWatchPreview`、`HyperStatePreview`、`HyperTextScalePreview`、`HyperGoldenFrame`、`HyperPerformanceOverlay`、`HyperHitTestOverlay`、`HyperLayoutGrid`。

## 五、基础控件推荐实现顺序

接下来只从基础层选择新控件，顺序如下：

1. `HyperText`、`HyperIcon`、`HyperDivider`、`HyperSurface`。
2. `HyperProgress`、`HyperLinearProgress`、`HyperCircularProgress`、`HyperWormProgressIndicator`。
3. `HyperSlider` 家族、`HyperNumberInput`。
4. `HyperTextField`、`HyperTextArea`、`HyperFormField<T>`、`HyperForm`。
5. `HyperListTile`、三个选择类 ListTile、`HyperItem`、`HyperSection`。
6. Overlay 核心、`HyperTooltip`、`HyperMenu`、`HyperDialog`。
7. `HyperScaffold`、`HyperAppBar`、基础导航控件和自适应页面结构。

每一步仍遵守一个控件一个文件或包、独立主题、实例优先、明确尺寸、Demo 可见和测试完整的规则。未经评审，不提前实现后续高级控件。
