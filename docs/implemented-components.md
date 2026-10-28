# 当前已实现控件索引

本页按 `lib/lemon_ui.dart` 的公开导出与 `lib/src/components` 实际实现核对，更新时间：2026-10-21。只列用户可直接使用的 UI 控件；主题、Style、尺寸、数据模型、Form 适配器和内部绘制辅助类不作为重复控件计数。目录状态仍需结合 Demo、测试、使用文档和设备审核台账判断。

## 动效包装（未确认）

`HyperMotion.lift`：悬停/聚焦上浮、微缩放、阴影及按下回压；包装子控件，不增加激活语义。

## 基础与布局

`HyperContainer`、`HyperMaterialSurface`、`HyperCard`、`HyperTitledCard`、`HyperDivider`、`HyperScaffold`、`HyperAppBar`、`HyperSliverAppBar`、`HyperDrawer`、`HyperSidebar`、`HyperWidgetGroup`、`HyperListTile`、`HyperNavigationListTile`、`HyperCheckboxListTile`、`HyperRadioListTile`、`HyperSwitchListTile`、`HyperPopupListTile`。

## 内容与操作

`HyperText`、`HyperScrollingText`、`HyperIcon`、`HyperAvatar`、`HyperAvatarGroup`、`HyperBadge`、`HyperBadgeAnchor`、`HyperTag`、`HyperButton`、`HyperIconButton`、`HyperChip`、`HyperSegmentedButton`、`HyperCheckbox`、`HyperRadio<T>`、`HyperSwitch`、`HyperSlider`、`HyperRangeSlider`、`HyperVerticalSlider`、`HyperCapsuleSlider`、`HyperProgress`、`HyperSkeleton`。

## 输入与选择

`HyperTextField`、`HyperTextArea`、`HyperNumberInput`、`HyperSelect<T>`、`HyperDropdown`、`HyperAutocomplete<T>`、`HyperCascader<T>`、`HyperTreeSelect<T>`、`HyperColorPicker`、`HyperDateTimePicker`、`HyperDateTimeRangePicker`、`HyperDatePicker`、`HyperTimePicker`、`HyperCalendar`、`HyperWheelPicker<T>`、`HyperFilePicker`。

`HyperDatePicker` 和 `HyperTimePicker` 是 `HyperDateTimePicker` 的薄封装入口；日期时间范围选择有独立的 `HyperDateTimeRangePicker`。`HyperDropdown` 接收自定义面板，选择数据由调用方管理；选项选择使用 `HyperSelect`。颜色选择家族还公开 `HyperColorPickerField` 和 `HyperColorPickerDialog` 两个触发/呈现适配入口。

## 导航、浮层与反馈

`HyperTable<T>`、`HyperTabBar`、`HyperTabBarView`、`HyperBreadcrumb`、`HyperPagination`、`HyperPageIndicator`、`HyperStepIndicator`、`HyperMenu`、`HyperMenuButton`、`HyperContextMenu`、`HyperAnchoredOverlay`、`HyperTooltip`、`HyperDialog`、`HyperBottomSheet`、`HyperToast`、`HyperSnackbar`、`HyperSnackbarHost`、`HyperAlert`、`HyperLoadingOverlay`、`HyperNotification`、`HyperCollapsible`、`HyperAccordion`、`HyperTimeline`、`HyperDescriptionList`、`HyperTreeView<T>`、`HyperResult`。

## 表单 API

Form 及其组合 API 包括 `HyperForm`、`HyperFormField<T>`、`HyperFormActions`、`HyperFormSection`、`HyperFormListField` 和 `HyperFormModal`。Form 适配器不重复算作独立视觉控件；当前公开适配包括文本、多行文本、单选/多选、滑块、日期时间/范围、数字、Autocomplete、文件、Cascader 和 TreeSelect 字段适配器。

## 合并与名称对应

| 目录中出现的名称 | 当前归属 |
| --- | --- |
| `HyperInitialsAvatar` | `HyperAvatar` 的 `text` 内容模式 |
| `HyperVerticalDivider` | `HyperDivider.vertical` |
| `HyperAsyncButton` | `HyperButton` 的异步 `onPressed` |
| `HyperSelectableText` | `HyperText` 的选择配置；不是独立控件 |
| `HyperOverflowMarquee` | `HyperScrollingText` |
| `HyperDatePicker`、`HyperTimePicker` | `HyperDateTimePicker` 的模式入口 |
| `HyperDateRangePicker` | 规划名；日期时间/日期范围由 `HyperDateTimeRangePicker` 提供 |
| `HyperDatePickerDialog`、`HyperTimePickerDialog` | 日期/时间 Picker 的呈现配置已覆盖，不单独规划对话框控件 |
| `HyperAlertDialog`、`HyperConfirmDialog`、`HyperInputDialog`、`HyperSelectionDialog<T>`、`HyperFullScreenDialog` | `HyperDialog` 的内容与布局组合，不单独规划对话框控件 |
| `HyperDescriptions` | 未采用的规划名；当前正式 API 是 `HyperDescriptionList` |
| `HyperBlendedAvatar` | `HyperAvatarGroup` 的 blended 布局渲染器；保留公开符号，但不作为独立头像控件计数 |
| `HyperColorPickerField`、`HyperColorPickerDialog` | `HyperColorPicker` 的字段触发器与弹窗呈现适配，不是不同选择器 |
| `HyperColorSwatchPicker` | 色板属于 `HyperColorPicker` 内置 palette，不另建选择器 |
| `HyperLinearProgress`、`HyperCircularProgress`、`HyperInfiniteProgress` | 统一进度家族的独立形态 API；统一主题和配置归 `HyperProgress` 管理 |
| 通知中心 | Example/业务组合；库导出单条 `HyperNotification` |
| Button / IconButton 的外观构造器、Chip 的 action/choice/filter/input、Checkbox/Radio 的外形变体 | 各自主控件的构造器或变体，不单独计数 |

## 规划中的变体归并

以下为目录的家族归类和后续变体规划。它不表示所有包装 API 已在实现层合并；现有公开控件及主题保持兼容，索引上仍按真实导出记录。

| 统一家族 | 合并的规划名称/变体 |
| --- | --- |
| `HyperButton` / `HyperIconButton` | Floating/Extended/Back/Close/Toggle 按钮、菜单触发款、图标/文字内容变体；Toggle/FAB 款仍属规划 |
| `HyperCard` | `HyperTitledCard` 标题与 action 布局（独立公开入口保留） |
| `HyperAppBar` | `HyperSliverAppBar`、`HyperMobileAppBar` 的布局/设备适配 |
| `HyperListTile` | Navigation/Checkbox/Radio/Switch 行及通用选择行 |
| `HyperSlider` | Range/Vertical/Progress/Seek/Brightness 形态；胶囊整块交互仍保留专用入口 |
| `HyperNumberInput` / `HyperWheelPicker<int>` | Counter/Stepper 按钮预设 / 数字滚轮类型特化 |
| `HyperTextField` | TextArea 多行模式与 Search/Password/Number/Email/Phone/URL 输入预设；PIN/OTP 多格布局保留独立控件 |
| `HyperProgress` | Linear/Circular/Infinite 与圆弧、活动环等形态模式 |
| `HyperImage` | Network/Asset/File/Memory 来源与缩略图预设 |
| `HyperDateTimePicker` | Date/Time 单值模式；日期/时间弹窗配置不单独建控件 |
| `HyperDateTimeRangePicker` | Date/Time 范围模式 |
| `HyperCalendar` | 日/周/月视图与网格布局模式 |
| `HyperDurationPicker` | Timer/Countdown 模式 |
| `HyperPageIndicator` | 圆点/数字及 PageDots 预设 |
| `HyperStepIndicator` | `HyperStepIndicator.navigation` 交互模式 |
| `HyperCollapsible` | `HyperAccordion` 为有独立集合状态职责的组合，保留接口 |
| `HyperAdaptiveScaffold` | Mobile/Tablet/Watch 页面框架设备预设 |
| `HyperResponsiveBuilder` | Breakpoint/Orientation/Device Builder 的统一策略参数 |
| `HyperCarousel` | CarouselView/Swiper 分页与手势预设 |
| `HyperResult` | `HyperResult.empty` 空内容状态 |
| `HyperBottomSheet` | ActionSheet 动作内容布局 |
| `HyperMenu` / `HyperMenuButton` | ContextMenu 触发方式 / DropdownButton 菜单触发方式 |
| `HyperAlert` / `HyperAlert.banner` | 同一提示内容模型的正文内/区域横幅布局 |
| `HyperToast` / `HyperSnackbar` | 同一消息呈现家族的时长、操作与位置模式 |


## 现有实现的合并审查

以下三组已完成合并，公开接口、主题与四端尺寸均使用组件变体。

| 优先级 | 现有控件 | 源码依据与建议 |
| --- | --- | --- |
| 已合并 | HyperAlert / HyperAlert.banner | 参数一致，均调用 HyperNoticeBody；主要差异是默认配方、主题和尺寸。现使用 HyperAlert.banner 与 banner 主题、尺寸变体。 |
| 已合并 | HyperStepIndicator / HyperStepIndicator.navigation | 已共用 HyperStepsBody 与步骤模型；导航版本增加 enabled 和 onStepChanged。现使用 HyperStepIndicator.navigation 与 navigation 主题、尺寸变体。 |
| 已合并 | HyperResult / HyperResult.empty | 共用结果布局、动画与材质表面，空内容使用 empty 状态主题与尺寸。 |

已经共用底层的 HyperTextArea/HyperTextField、HyperToast/HyperSnackbar、进度家族无需为减少类名再重写实现。可提供统一构造器，同时保留有用的便捷入口。

HyperAccordion 负责多项展开集合及互斥规则，属于 HyperCollapsible 的组合；Checkbox/Radio/Switch ListTile 负责整行点击、焦点、语义和尾部控件协调。它们具有独立交互职责，保留组合接口，不收成纯外观枚举。

## 核对边界

本索引表示 API 有实现且从主库公开导出，不代表每个组件都满足全目录 `[x]` 的 Demo、主题、测试和文档完成标准，也不表示用户已确认样式。逐设备视觉状态见 [设备预览与 UI 审核台账](device-preview-and-review.md)，逐项进度见 [全量控件目录](component-catalog.md)。

## 行内编辑（2026-10-26，用户已确认）

新增公开 HyperInlineEdit<T>，提供通用编辑器与 text(multiline: true/false) 入口；全局 inlineEditTheme、局部 HyperInlineEditTheme、HyperInlineEditStyle。复用文本输入、按钮和表单四端规格，不新增重复设备常量。Demo 与主题编辑器经用户确认移入输入控件分类，使用说明见 [行内编辑](usage/inline-edit.md)。

## 基础组件补齐（2026-10-26，未确认）

新增 HyperRating、HyperTransfer<T>、HyperResizable、HyperMovableDialog / showHyperMovableDialog、HyperNavigationBar<T>，以及 HyperRatingFormField / HyperTransferFormField<T>。五个 Demo 与主题编辑器均登记未确认；完整接口和验证边界见 [新增基础控件](usage/pending-controls.md)。
