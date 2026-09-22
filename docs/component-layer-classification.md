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

- `HyperMenuBar`：菜单分类与桌面专项共用。
- `HyperSplitButton`：按钮分类与桌面专项共用。
- `HyperHoverRegion`、`HyperFocusRing`、`HyperShortcutScope`：桌面专项与交互辅助共用。
- `HyperDragRegion`：普通拖动区域与窗口拖动语义通过明确参数或专用适配层区分。
- `HyperMasterDetail`、`HyperNavigationSplitView`：通用大屏布局与平板专项共用。
- `HyperCircularSlider`、`HyperCircularProgressIndicator`：通用版本提供基础能力，手表只提供尺寸和交互适配。
- `HyperWindowSwitcher`：桌面单窗口阶段只提供界面，多窗口阶段再接入真实窗口模型。
- `HyperChartLegend` 作为正式图表图例；原 `HyperLegend` 不再单独实现。
- `HyperDescriptions` 作为正式描述列表；原 `HyperDescriptionList` 作为兼容命名候选，不重复实现。
- `HyperAsyncButton` 不单独实现，由 `HyperButton` 的统一异步回调覆盖。

## 三、基础控件

### B0：基础设施与已完成核心

这是所有后续控件的底座，优先级最高。

- 主题与值对象：`HyperTheme`、`HyperThemeData`、`HyperColorScheme`、`HyperContrastThemeData`、`HyperContrastTheme`、`HyperTextTheme`、`HyperSizeScheme`、`HyperMotionThemeData`、`HyperDeviceThemeData`、`HyperOverlayThemeData`。
- 材质与装饰：`HyperFill`、`HyperBorder`、`HyperShadow`、`HyperMaterialQuality`、`HyperSurfaceMaterial`、`HyperMaterialThemeData`、`HyperMaterialTheme`。
- 状态与设备：`HyperControlState`、`HyperStateValue<T>`、`HyperAsyncState<T>`、`HyperAsyncConcurrency`、`HyperDeviceType`、`HyperDeviceDetector`。
- 交互与辅助：`HyperPressable`、`HyperGestureRegion`、`HyperHoverRegion`、`HyperFocusScope`、`HyperFocusRing`、`HyperAccessibleTapTarget`、`HyperSemantics`。
- 当前已完成的视觉核心：`HyperContainer`、`HyperMaterialSurface`、`HyperText`、`HyperIcon`、`HyperDivider`、`HyperProgressIndicator`、`HyperLinearProgressIndicator`、`HyperCircularProgressIndicator`、`HyperButton`、`HyperIconButton`、`HyperCheckbox`、`HyperRadio<T>`、`HyperSwitch`。

### B1：文字、图标、表面与轻量布局

这些控件先于输入、列表、弹层和导航实现。

- 内容：`HyperText`、`HyperSelectableText`、`HyperRichText`、`HyperIcon`、`HyperIconLabel`、`HyperLabel`、`HyperCaption`、`HyperLink`、`HyperKbd`、`HyperTag`、`HyperStatusIndicator`、`HyperAvatar`、`HyperAvatarGroup`、`HyperInitialsAvatar`、`HyperPlaceholder`。
- 表面：`HyperSurface`、`HyperCard`、`HyperPanel`、`HyperSection`、`HyperGroupBox`、`HyperDivider`、`HyperVerticalDivider`、`HyperBadge`、`HyperBadgeAnchor`。
- 间距与约束：`HyperSpacer`、`HyperGap`、`HyperAspectRatio`、`HyperConstrainedBox`、`HyperSafeArea`。
- 常用布局：`HyperRow`、`HyperColumn`、`HyperWrap`、`HyperStack`、`HyperGrid`、`HyperScrollable`、`HyperScrollbar`。
- 响应式构建：`HyperResponsiveBuilder`、`HyperBreakpointBuilder`、`HyperOrientationBuilder`、`HyperDeviceBuilder`。

### B2：基础操作、选择与调节

- 按钮：`HyperCloseButton`、`HyperBackButton`、`HyperToggleButton`、`HyperButtonBar`、`HyperButtonGroup`、`HyperSegmentedButton`、`HyperActionChip`、`HyperCopyButton`。
- 选择组合：`HyperCheckboxListTile`、`HyperRadioGroup<T>`、`HyperRadioListTile<T>`、`HyperSwitchListTile`、`HyperChip`、`HyperChoiceChip`、`HyperFilterChip`、`HyperInputChip`、`HyperToggleGroup<T>`、`HyperSelectionTile<T>`。
- 基础数值调节：`HyperSlider`、`HyperRangeSlider`、`HyperVerticalSlider`、`HyperStepper`、`HyperCounter`、`HyperLevelIndicator`。
- 常用状态切换：`HyperFavoriteButton`、`HyperLikeButton`、`HyperRating`。

### B3：进度、提示与页面状态

- 进度：`HyperProgressIndicator`、`HyperLinearProgressIndicator`、`HyperWormProgressIndicator`、`HyperCircularProgressIndicator`、`HyperLoadingSpinner`、`HyperActivityIndicator`、`HyperActivityRing`、`HyperProgressRing`。
- 页面状态：`HyperAsyncView<T>`、`HyperEmptyState`、`HyperErrorView`、`HyperResult`、`HyperRetry`。
- 轻量反馈：`HyperAlert`、`HyperBanner`、`HyperLoadingOverlay`、`HyperSkeleton`、`HyperShimmer`、`HyperCountdown`、`HyperConnectionStatus`、`HyperOfflineBanner`。
- 基础状态展示：`HyperTimeline`、`HyperStepIndicator`、`HyperMetric`、`HyperStatCard`、`HyperDotIndicator`、`HyperTracker`。

### B4：文本输入与表单底座

- 输入核心：`HyperEditableText`、`HyperTextField`、`HyperTextFormField`、`HyperTextArea`、`HyperSearchField`、`HyperPasswordField`、`HyperNumberField`。
- 便捷输入：`HyperEmailField`、`HyperPhoneField`、`HyperUrlField`、`HyperPinInput`、`HyperOtpInput`、`HyperSearchBar`。
- 表单底座：`HyperForm`、`HyperFormField<T>`、`HyperFormScope`、`HyperFormController`、`HyperFormSection`、`HyperFormGroup`、`HyperFieldLabel`、`HyperFieldMessage`、`HyperValidationMessage`、`HyperFormActions`、`HyperFormSummary`、`HyperAsyncValidator<T>`。
- 输入组合协议：`HyperInputGroup`、`HyperInputGroupAddon`、`HyperOption<T>`。

### B5：列表、内容单元与基础数据展示

- 列表：`HyperListView`、`HyperListTile`、`HyperItem`、`HyperItemGroup`、`HyperSettingsTile`、`HyperActionTile`、`HyperNavigationListTile`、`HyperUserTile`、`HyperMediaTile`、`HyperExpandableTile`。
- 集合：`HyperGroupedList`、`HyperReorderableList`、`HyperRefreshIndicator`、`HyperSliverAppBar`、`HyperSliverList`、`HyperSliverGrid`、`HyperStickyHeader`。
- 数据展示：`HyperTable`、`HyperKeyValueTable`、`HyperDescriptions`、`HyperTreeView<T>`。
- 设置组合：`HyperPreferences`、`HyperPreferenceGroup`、`HyperPreferenceTile`、`HyperSwitchPreference`、`HyperCheckboxPreference`、`HyperRadioPreference<T>`、`HyperSliderPreference`、`HyperDropdownPreference<T>`、`HyperNavigationPreference`、`HyperTextFieldPreference`、`HyperColorPreference`、`HyperAboutPreference`。

### B6：Overlay、菜单与对话框底座

这一组仍属于基础层，但必须在 B0 至 B5 稳定后实现。

- Overlay 核心：`HyperOverlayScope`、`HyperOverlayPresentation`、`HyperOverlayController<T>`、`HyperOverlayAnchor`、`HyperAnchoredOverlay`、`HyperModalBarrier`。
- 提示与菜单：`HyperTooltip`、`HyperMenu`、`HyperMenuItem`、`HyperContextMenu`、`HyperDropdownMenu<T>`、`HyperPopup`、`HyperPopover`。
- 页面浮层：`HyperActionSheet`、`HyperBottomSheet`、`HyperModalBottomSheet`、`HyperSideSheet`。
- 对话框：`HyperDialog`、`HyperAlertDialog`、`HyperConfirmDialog`、`HyperInputDialog`、`HyperSelectionDialog<T>`、`HyperDialogActions`、`HyperProgressDialog`。
- 队列反馈：`HyperToast`、`HyperSnackbar`、`HyperSnackbarHost`、`HyperNotification`、`HyperNotificationCenter`。

### B7：页面结构与基础导航

- 页面结构：`HyperScaffold`、`HyperAdaptiveScaffold`、`HyperAppBar`、`HyperBottomAppBar`。
- 导航：`HyperNavigationBar`、`HyperNavigationDestination`、`HyperNavigationRail`、`HyperNavigationRailDestination`、`HyperNavigationDrawer`、`HyperDrawer`、`HyperSidebar`。
- 页内切换：`HyperTabBar`、`HyperTabBarView`、`HyperSegmentedNavigation`、`HyperPageView`、`HyperPageIndicator`、`HyperBreadcrumb`、`HyperPagination`。
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

- 布局：`HyperFlow`、`HyperResponsiveGrid`、`HyperMasonryGrid`、`HyperStaggeredGrid`、`HyperSplitView`、`HyperResizablePanel`、`HyperResizablePane`、`HyperCollapsiblePane`、`HyperCarouselView`、`HyperScaledBox`。
- 集合：`HyperSwipeAction`、`HyperSwipeActions`、`HyperPagedList`、`HyperInfiniteList`、`HyperPullToRefresh`、`HyperRefreshTrigger`、`HyperSwiper`。
- 折叠：`HyperAccordion`、`HyperCollapsible`、`HyperCollapsibleTrigger`、`HyperCollapsibleContent`。
- 高级手势：`HyperLongPressRegion`、`HyperDragRegion`、`HyperSwipeRegion`、`HyperPinchRegion`、`HyperDismissible`、`HyperReorderable`、`HyperHapticFeedback`、`HyperSelectionMarquee`、`HyperResizeHandle`。

### A3：高级输入、选择器与日期时间

- 输入与建议：`HyperAutocomplete<T>`、`HyperDropdownField<T>`、`HyperComboBox<T>`、`HyperSearchAnchor`、`HyperTagInput<T>`、`HyperMentionInput<T>`、`HyperFormattedInput`、`HyperFormattedInputController`、`HyperImageInput`、`HyperSortableInput<T>`、`HyperObjectInput<T>`、`HyperInlineEdit<T>`。
- 复杂选择：`HyperColorPicker`、`HyperColorSwatchPicker`、`HyperNumberPicker`、`HyperWheelPicker<T>`、`HyperItemPicker<T>`、`HyperMultipleChoice<T>`、`HyperMultiSelect<T>`、`HyperCheckboxGroup<T>`、`HyperCascader<T>`、`HyperTransfer<T>`、`HyperAsyncOptionSource<T>`。
- 高级调节：`HyperProgressSlider`、`HyperDial`、`HyperKnob`、`HyperCircularSlider`、`HyperRangeDial`、`HyperScrubber`。
- 日期时间：`HyperDatePicker`、`HyperDateRangePicker`、`HyperTimePicker`、`HyperDateTimePicker`、`HyperDurationPicker`、`HyperTimerPicker`、`HyperCalendar`、`HyperCalendarView`、`HyperCalendarGrid`、`HyperAgenda`、`HyperSchedule`、`HyperTimeRangePicker`、`HyperTimezonePicker`、`HyperCountdownPicker`、`HyperDatePickerDialog`、`HyperTimePickerDialog`、`HyperColorPickerDialog`。

### A4：高级 Overlay、菜单、导航与模态

- 菜单：`HyperMenuButton`、`HyperDropdownButton`、`HyperSplitButton`、`HyperMenuBar`、`HyperCascadingMenu`、`HyperCommandPalette`、`HyperNavigationMenu`。
- 高级浮层：`HyperHoverCard`、`HyperExpandableOverlay`、`HyperPointerTooltip`、`HyperInstantTooltip`、`HyperPopupSwitchCoordinator`、`HyperPinnedSheet`。
- 高级对话框：`HyperFullScreenDialog`、`HyperAboutDialog`、`HyperLicensePage`、`HyperMovableDialog`。
- 高级导航：`HyperFloatingActionButton`、`HyperExtendedFloatingActionButton`、`HyperFloatingToolbar`、`HyperNavigationSplitView` 的三栏模式、`HyperStepperNavigation`、`HyperContentSwitcher`。

### A5：高级数据、图表和专业内容

- 数据：`HyperDataTable`、`HyperPaginatedDataTable`、`HyperDataGrid`、`HyperTreeTable<T>`、`HyperChartContainer`、`HyperSparkline`、`HyperGauge`。
- 图表基础：`HyperChartThemeData`、`HyperChartAxis`、`HyperChartReferenceLine`、`HyperChartSelection`、`HyperChartLegend`、`HyperChartCard`、`HyperAsyncChart<T>`。
- 图表类型：`HyperBarChart`、`HyperLineChart`、`HyperPieChart`、`HyperScatterChart`、`HyperRadarChart`、`HyperCandlestickChart`、`HyperRankBarChart`、`HyperHeatmap`、`HyperTreemap`。
- 图表导出：`HyperChartExportBoundary`、`HyperChartExportController`。
- 专业内容：`HyperMarkdown`、`HyperCodeBlock`、`HyperRichTextEditor`、`HyperChat`、`HyperChatBubble`、`HyperOverflowMarquee`。

### A6：媒体、文件与系统控制

- 图片：`HyperNetworkImage`、`HyperImage`、`HyperImageViewer`、`HyperGallery`、`HyperCarousel`、`HyperThumbnail`。
- 音视频：`HyperVideoPlayer`、`HyperAudioPlayer`、`HyperMediaController`、`HyperPlaybackButton`、`HyperVolumeSlider`、`HyperBrightnessSlider`、`HyperSeekBar`、`HyperWaveform`。
- 文件：`HyperFileTile`、`HyperFilePickerField`、`HyperDropZone`、`HyperUpload`、`HyperDownload`。
- 系统界面：`HyperQuickSettingsTile`、`HyperControlCenter`、`HyperDeviceControl`、`HyperConnectivityTile`、`HyperBluetoothTile`、`HyperWifiTile`、`HyperAirplaneModeTile`、`HyperBatteryIndicator`、`HyperSignalIndicator`、`HyperVolumeControl`、`HyperBrightnessControl`、`HyperMediaSession`、`HyperDeviceCard`、`HyperPermissionPrompt`、`HyperBiometricPrompt`。

### A7：桌面、窗口、平板与折叠屏专项

- 桌面外壳：`HyperWindowFrame`、`HyperTitleBar`、`HyperWindowButton`、`HyperWindowCaption`、`HyperToolbar`、`HyperStatusBar`、`HyperCommandBar`、`HyperRibbon`、`HyperDock`、`HyperInspectorPanel`、`HyperPropertyGrid`、`HyperTreeSidebar`、`HyperDesktopTabs`、`HyperTabStrip`、`HyperContextMenuRegion`、`HyperShortcutScope`、`HyperShortcutHint`、`HyperWindowSwitcher`、`HyperTaskbar`。
- 多窗口：`HyperWindowScope`、`HyperWindowManager`、`HyperWindowController`、`HyperWindowHandle`、`HyperWindowHost`、`HyperWindowBuilder`、`HyperWindowConfiguration`、`HyperWindowBounds`、`HyperWindowState`、`HyperWindowPlacement`、`HyperWindowEventListener`、`HyperWindowCloseGuard`、`HyperWindowRouter`、`HyperWindowOverlayScope`、`HyperWindowThemeScope`、`HyperWindowFocusScope`、`HyperWindowList`、`HyperNewWindowButton`、`HyperMoveToWindowMenu`、`HyperWindowTabTransfer`、`HyperScreenPicker`、`HyperScreenInfo`。
- 手机专项组合：`HyperBottomNavigation`、`HyperBottomActionBar`、`HyperSwipeBackRegion`、`HyperPullDownPanel`、`HyperMobileAppBar`、`HyperKeyboardAvoider`、`HyperSafeBottomBar`、`HyperMobileContextMenu`、`HyperMobileSelectionToolbar`、`HyperPageDots`、`HyperEdgePanel`。
- 平板与折叠屏：`HyperThreePaneScaffold`、`HyperAdaptiveSidebar`、`HyperFloatingPanel`、`HyperTabletToolbar`、`HyperDetailPane`、`HyperSupportingPane`、`HyperFoldAwareLayout`、`HyperTwoPageLayout`、`HyperDragAndDropRegion`、`HyperPointerAdaptiveRegion`。

### A8：手表和圆形 UI

- 手表通用：`HyperWatchApp`、`HyperWatchScaffold`、`HyperWatchTheme`、`HyperWatchSafeArea`、`HyperWatchLayout`、`HyperWatchListView`、`HyperWatchListTile`、`HyperWatchCard`、`HyperWatchButton`、`HyperWatchIconButton`、`HyperWatchNavigation`、`HyperWatchPageIndicator`、`HyperWatchDialog`、`HyperWatchToast`、`HyperWatchProgressIndicator`、`HyperWatchTimePicker`、`HyperWatchNumberPicker`、`HyperWatchComplication`、`HyperWatchComplicationSlot`、`HyperWatchFace`、`HyperAlwaysOnDisplay`、`HyperCrownScrollView`、`HyperCrownController`、`HyperRotaryFocus`、`HyperBezelGestureRegion`。
- 圆形布局：`HyperArcLayout`、`HyperArcPositioned`、`HyperArcPadding`、`HyperArcText`、`HyperCurvedText`、`HyperArcIcon`、`HyperCircularSafeArea`、`HyperRoundScreenClip`。
- 圆形交互：`HyperArcButton`、`HyperArcIconButton`、`HyperArcMenu`、`HyperRadialMenu`、`HyperRingMenu`、`HyperArcNavigation`、`HyperCircularNavigation`、`HyperArcTabBar`、`HyperArcListView`、`HyperCurvedListView`、`HyperRotaryListView`。
- 圆形调节与展示：`HyperArcSlider`、`HyperArcRangeSlider`、`HyperArcProgressIndicator`、`HyperSegmentedRing`、`HyperActivityRings`、`HyperArcGauge`、`HyperRadialGauge`、`HyperArcTimer`、`HyperCircularCountdown`、`HyperClockDial`、`HyperClockHand`、`HyperRadialPicker<T>`、`HyperCircularNumberPicker`、`HyperEdgeIndicator`、`HyperEdgeProgress`、`HyperEdgeNotification`。

### A9：无障碍、调试和开发工具

- 无障碍高级能力：`HyperScreenReaderAnnouncement`、`HyperHighContrastScope`、`HyperReducedMotionScope`、`HyperReducedTransparencyScope`、`HyperKeyboardListener`、`HyperDirectionalFocusTraversal`、`HyperRotaryFocusTraversal`、`HyperTooltipSemantics`。
- 调试工具：`HyperThemeInspector`、`HyperComponentGallery`、`HyperComponentPreview`、`HyperThemeEditor`、`HyperDevicePreview`、`HyperRoundWatchPreview`、`HyperStatePreview`、`HyperTextScalePreview`、`HyperGoldenFrame`、`HyperPerformanceOverlay`、`HyperHitTestOverlay`、`HyperLayoutGrid`。

## 五、基础控件推荐实现顺序

接下来只从基础层选择新控件，顺序如下：

1. `HyperText`、`HyperIcon`、`HyperDivider`、`HyperSurface`。
2. `HyperProgressIndicator`、`HyperLinearProgressIndicator`、`HyperCircularProgressIndicator`、`HyperWormProgressIndicator`。
3. `HyperSlider`、`HyperRangeSlider`、`HyperStepper`。
4. `HyperTextField`、`HyperTextArea`、`HyperFormField<T>`、`HyperForm`。
5. `HyperListTile`、三个选择类 ListTile、`HyperItem`、`HyperSection`。
6. Overlay 核心、`HyperTooltip`、`HyperMenu`、`HyperDialog`。
7. `HyperScaffold`、`HyperAppBar`、基础导航控件和自适应页面结构。

每一步仍遵守一个控件一个文件或包、独立主题、实例优先、明确尺寸、Demo 可见和测试完整的规则。未经评审，不提前实现后续高级控件。
