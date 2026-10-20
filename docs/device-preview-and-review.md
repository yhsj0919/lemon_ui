# Demo 设备预览与 UI 审核台账

更新：2026-10-11。

## 使用设备预览

运行 example，在顶部选择「真实设备 / 手机 / 平板 / 桌面 / 手表」。无需安装额外预览库。

- 真实设备：使用宿主实际设备解析和窗口，不强行改成手机；桌面窗口缩小仍是 desktop。
- 模拟设备：显式覆盖 HyperDeviceDetector，HyperTheme 重新解析对应端的尺寸和字阶。
- 画布预设：手机 390 × 844、平板 834 × 1194、桌面 1280 × 800、手表 220 × 220，单位均为逻辑像素。这些是布局测试窗口，不是某个机型的官方规格。
- 横竖屏：交换宽高，不改变所选设备类别。
- 文字缩放：1 / 1.3 / 2，检查文字增大后的换行、溢出和操作区。
- 安全区：非桌面、非手表画布模拟顶部和底部各 24 逻辑像素，不代表真实刘海形状。
- 键盘占位：模拟底部 35% 高度的 viewInsets，用于检查避让，不模拟输入法、候选栏或真实软键盘。
- 画布适配宿主可用空间，整体缩放仅供观察；组件布局仍按标注的逻辑尺寸运行。

模拟画布内部具有独立 MaterialApp / Navigator；根浮层、Dialog、Sheet 和锚定菜单都在该画布内布局。
切换设备时建议先关闭弹窗，重新展开核对 adaptive 的呈现方式。真实设备模式不覆盖字体缩放、安全区或键盘。

桌面鼠标预览不会变成触摸输入；宿主字体、渲染器、系统状态栏、软键盘、平台插件和性能仍须实机检查。
手表预览为方形布局检查，暂不模拟圆屏裁切和表冠。模拟预览不能代替实机审核。

## 审核状态规则

实现进度与 UI 审核分开维护：目录的 [x] 表示实现完成，**不代表任意一端的 UI 已审核**。

| 状态 | 含义 |
| --- | --- |
| 未创建 | 尚无对应实现 |
| 创建中未审核 | 只有基础版本或实现未完成 |
| 已创建未审核 | 已有实现，但缺少该端、该版本的明确对照验收记录 |
| 模拟预览已审核 | 已按指定画布和状态对照，并记录审核人、版本与结果 |
| 实机已审核 | 已按指定设备、系统版本、缩放和状态实机验收 |
| 规格已审核 | 只核对来源及主题数值，不等同于渲染或交互已验收 |

组件修改了视觉、布局、浮层或交互后，应重新审核受影响端；不得仅根据 analyze 或主题测试标记 UI 通过。
每次实际审核记录：组件、端、提交/版本、逻辑尺寸、缩放、输入方式、材质质量、状态、截图路径、审核人、日期和结论。
以前聊天中对某一局部效果的确认保留为历史反馈；未记录设备和状态范围的确认，不升级为完整四端验收。

## 有证据的既有规格审核

| 范围 | 状态 | 记录与限制 |
| --- | --- | --- |
| desktop 字阶、Button、Card 标题、Side Menu、Sidebar、Layout 留白 | 规格已审核 | [HIUI 核对记录](hiui-desktop-audit.md)，2026-09-23；不表示当前版本 UI 或全组件已审核 |
| 手机默认值来源 | 候选/项目推导 | [HyperOS 基准](hyperos-design-baseline.md)；文档区分 A/B/C/D，不能把第三方或 D 级值记为官方审核 |
| 本次四端预览工具 | 已创建未审核 | 已完成静态检查与纯数据测试；未启动设备、未运行 Widget 测试、未做渲染对照 |

## 已创建组件的四端 UI 状态

以下按 [组件目录](component-catalog.md) 的已实现与基础版本条目建立基线。没有充分的当前版本四端验收证据，统一先登记为未审核；后续逐项更新，不追认未知结果。基础主题类型列在目录中，其审核主要针对组合结果。

| 组件 / 能力 | 实现 | 手机 UI | 平板 UI | 桌面 UI | 手表 UI |
| --- | --- | --- | --- | --- | --- |
| `HyperCascader<T>` | 已创建（2026-10-20，未确认） | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperTheme` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperThemeData` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperColorScheme` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperContrastThemeData` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperContrastTheme` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperTextTheme` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperSizeScheme` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperMotionThemeData` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperElasticOverscrollController` / `HyperElasticOverscrollTransform` / `HyperElasticOverscrollRegion` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperMaterialQuality` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperSurfaceMaterial` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperMaterialThemeData` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperMaterialTheme` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperFill` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperStateValue<T>` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperDeviceType` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperDeviceDetector` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperControlState` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperContainer` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperMaterialSurface` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperCard` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperTitledCard` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperDivider` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperWidgetGroup` | 创建中 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperBadge` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperBadgeAnchor` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperScaffold` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperText` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperIcon` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperAvatar` | 创建中 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperAvatarGroup` | 创建中 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperInitialsAvatar` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperTag` | 创建中 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperButton` | 创建中 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperIconButton` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperMenuButton` | 创建中 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperCheckbox` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperRadio<T>` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperSwitch` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperChip` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperSlider` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperRangeSlider` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperVerticalSlider` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperCapsuleSlider` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperTextField` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperAutocomplete<T>` | 已创建（样式与交互已由用户确认） | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperTextArea` | 已创建（默认样式与交互已由用户确认） | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperForm` | 已创建（表单默认样式与行为已由用户确认） | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperFormActions` | 已创建（默认样式与行为已由用户确认） | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperSelect<T>` | 已创建（样式与交互已由用户确认） | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperListTile` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperNavigationListTile` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperCheckboxListTile` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperRadioListTile` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperSwitchListTile` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperSliverAppBar` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperTreeView<T>` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperDescriptionList` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperTimeline` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperStepIndicator` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperEmptyState` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperResult` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperAppBar` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperDrawer` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperSidebar` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperTabBar` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperTabBarView` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperBreadcrumb` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperPagination` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperPageIndicator` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperStepperNavigation` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperTooltip` | 创建中 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperMenu` | 创建中 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperMenuItem` | 创建中 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperContextMenu` | 创建中 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperPopupListTile<T>` | 创建中 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperBottomSheet` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperDialog` / `showHyperDialog` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperToast` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperSnackbar` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperSnackbarHost` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperBanner` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperNotification` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| 通知中心组合示例（业务层） | 示例 | — | — | — | — |
| `HyperAlert` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperLoadingOverlay` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperProgress` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperLinearProgress` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperCircularProgress` | 创建中 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperSkeleton` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperPressable` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperAccordion` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperCollapsible` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperMultiSelect<T>` | 创建中 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperOption<T>` | 创建中 | 未审核 | 未审核 | 未审核 | 未审核 |
| `HyperAnchoredOverlay` | 已创建 | 未审核 | 未审核 | 未审核 | 未审核 |

## 下一轮优先审核

1. Select / Autocomplete / PopupListTile：四端选中样式、默认 item 高度、取消选择、多选 +N、搜索、分页、不同弹出方式、材质与阴影、键盘避让。
2. Menu / Dialog / BottomSheet：浮层边界、横竖屏、安全区、文字放大、内容滚动和按钮区域。
3. 其他已创建组件：逐页对照当前端主题规格，补充验收证据，再标记审核完成。

后续组件实现与修改同时维护本台账；实现完成时先记「已创建未审核」，用户明确验收对应端和状态后才更新审核结果。


## 2026-10-14：六组设置已创建，等待用户确认

Badge、Divider、Progress、Radio、Checkbox、Switch 已加入完整设置工作区，并按用户要求迁移到「未确认」分类，既有页面 id 保持不变。提供默认主题预览、四端尺寸、亮暗外观、保存导入与恢复继承。状态为「设置已创建未审核」；本轮仅数据及主题测试通过，未标记任何一端视觉验收通过。优先核对各端默认布局、文字缩放 1 / 1.3 / 2、窄宽排版、极端尺寸和状态切换，再由用户明确确认后迁移分类。
