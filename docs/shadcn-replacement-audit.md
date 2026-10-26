# 本地 shadcn 替代差距审计

核对日期：2026-10-26。范围：`E:/lemon_shadcn/lib`、其 package_config 实际解析的 `D:/Develop/PubCache/hosted/pub.dev/shadcn_flutter-0.0.55/lib`，以及本库公开入口和组件源码。不是 React shadcn/ui，也不是线上最新版。

这是源码与公开 API 的静态对照，未运行交互回归或视觉验收。已有实现不等于完全行为兼容，也不等于用户已确认样式；“未确认”组件照常计入已有能力。不用主题类、Style、模型、包装入口重复计数。

## 结论

lemon_ui 已无 shadcn_flutter 直接依赖。常规表单、菜单、反馈、数据表格和图表已有替代基础，但还不能覆盖本地 shadcn 的完整组件能力。完全替换要同时处理缺失组件、已有组件的行为差距和应用侧上游 API 迁移。

## 一、缺少专门实现的组件/能力家族

以下“缺少”表示当前公开组件中未发现对应的专用实现；Flutter 基础控件仍可作为实现基础。

| 家族 | 本地参照 | 需要补齐的职责 |
| --- | --- | --- |
| 命令面板 | AppCommand / Command | 命令搜索、分类、键盘选择与执行、空结果 |
| OTP/PIN | AppInputOtp / InputOTP | 多格输入、粘贴分发、焦点移动、删除、完成回调 |
| 电话输入 | AppPhoneInput / PhoneInput | 国家区号、国家选择、号码格式处理 |
| 结构化输入 | AppFormattedInput / AppObjectInput | 固定片段与可编辑片段、双向对象转换、片段焦点与校验；普通 inputFormatters 不等价 |
| 通用排序与排序输入 | Sortable / AppSortableInput | 拖动排序容器、拖拽手柄、反馈、列表值与表单适配；表格行排序不覆盖此职责 |
| 轮播 | AppCarousel / Carousel | 页面控制、拖动、自动播放与过渡；已有 PageIndicator 仅负责指示器 |
| 刷新与滑动动作 | AppRefreshTrigger / AppSwiper | 下拉刷新状态、滑动揭示动作；不是 Carousel 的同义项 |
| 窗口管理 | AppWindow / Window | 窗口控制器、拖动、缩放、最大化、吸附、层级与 viewport |
| 停靠面板 | AppPinnedSheet / PinnedSheet | 常驻/停靠面板及内容区域协调 |
| 代码展示 | AppCodeSnippet / CodeSnippet | 代码区域、复制、滚动与主题 |
| 快捷键展示 | AppKeyboardDisplay / KeyboardDisplay | 平台快捷键与键帽显示；菜单 shortcut 文本不是完整替代 |
| 数字滚动 | AppNumberTicker / NumberTicker | 数值变化的连续数字过渡 |
| 活动轨迹展示 | AppTracker / Tracker | 序列状态/活动记录的专门可视化 |
| 聊天 | AppChat / ChatBubble | 消息排列、气泡及连续消息分组 |
| 国家旗帜 | CountryFlag（上游） | 国家标识资源及展示，电话输入可复用 |

## 二、已有基础，但需做行为补齐或组合适配

| 本地参照 | 当前可用基础 | 尚需核对/补齐 |
| --- | --- | --- |
| Toggle / ToggleGroup | HyperButton、HyperChip、HyperSegmentedButton | 分段按钮已有多选和允许清空；独立 Toggle 以及任意内容分组的接口与行为不能直接视为等价 |
| Combobox / ChipInput | HyperAutocomplete.multiple、HyperSelect | 已有 createValue、选中标签与异步分页来源；核对旧库自由文本提交、标签键盘删除与输入交互后再决定扩展，不应直接判为全缺 |
| ItemPicker / MultipleChoice | HyperSelect、多选及自定义面板 | 任意卡片/网格项目的选择布局和控制器语义需要适配 |
| InputGroup | HyperTextField leading/trailing、HyperWidgetGroup | 复合输入的 addon、共享边框、焦点和错误状态需统一；单纯 Row 不能覆盖全部职责 |
| Menubar / NavigationMenu | HyperTopNavigation、HyperMenu | 普通多级顶栏已有；桌面菜单栏键盘切换、任意内容导航面板需逐项核对 |
| Popover / HoverCard | HyperAnchoredOverlay、HyperDropdown | 已有 tap/hover/manual 触发和 placement；核对悬停跨触发器/面板、开关延迟、受控接口，无需重复造底层浮层 |
| Stepper | HyperStepIndicator.navigation、HyperForm | 步骤指示与选择已有；前进/后退、逐步校验和步骤内容生命周期需组合层补齐 |
| TabPane | HyperTabBar、HyperTabBarView | 常规 Tab 已有；上游 TabPane 的拖动排序未发现对应实现 |
| 颜色高级能力 | HyperColorPicker 家族 | 基础选色已有；未发现 EyeDropper 和历史色专门实现，需核对旧调用是否使用 |
| AsyncView | HyperResult、HyperSkeleton、HyperLoadingOverlay | 状态视觉已有；统一 loading/error/empty/data、重试和旧结果保留属于可选组合封装 |
| Scrollbar / ScrollbarView | Flutter Scrollbar / RawScrollbar | 若目标是统一 Hyper 主题且业务不依赖上游，需要提供样式适配；不必重写滚动引擎 |
| 图标、国际化、页面过渡 | HyperIcon、Motion、Flutter 基础设施 | HyperIcon 不等于 AppLucideIcons/Radix/Bootstrap 图标资源；旧本地化 delegate、页面过渡与辅助扩展需单独迁移 |

## 三、已经有对应组件，不应重复开发

- 2026-10-26 新增待用户确认：HyperRating、HyperTransfer、HyperResizable、HyperMovableDialog、HyperNavigationBar（底部/侧向）；已实现并进入未确认 Demo/主题编辑器，参见 usage/pending-controls.md。功能候选完成不等于用户已确认。

- 行内编辑：HyperInlineEdit 已由用户于 2026-10-26 确认并移入正式输入分类，含单/多行、自定义控件、弹窗编辑、失焦保存、Esc 取消和描述列表组合。

- Button/IconButton、Avatar/AvatarGroup、Badge/CornerBadge、Chip/Tag、Text/SelectableText、Divider、Card、Container。
- Checkbox、Radio、Switch、Slider/RangeSlider、TextField/TextArea、NumberInput。
- Select/Autocomplete、Cascader、TreeSelect、Date/Time/RangePicker、Calendar、FilePicker、ColorPicker、Form。
- Accordion/Collapsible、Breadcrumb、Pagination、Tabs、Steps 指示、Timeline、Tree、Sidebar、Scaffold/AppBar。
- ContextMenu/DropdownMenu、Dialog、Drawer/BottomSheet、Tooltip、Toast/Snackbar、Alert、Progress、Skeleton、Empty/Result、Descriptions。
- Table/DataGrid：HyperTable 本身基于 trina_grid，公开本地/远程分页、无限加载、行选择、行列排序、列宽/可见性、编辑回调、树形子行等入口。不能因为没有 HyperDataGrid 类名而记为缺失。
- 七类图表：柱状、折线、饼图、雷达、排名条、散点、蜡烛图，以及图例、视口、导出相关入口；实现来源已有本地 lemon_shadcn 适配。

以上是功能家族对应，不是每个参数和每种状态已回归通过。

## 四、建议实施顺序

1. 常见业务缺口：OTP、独立 Toggle、InputGroup、ChipInput 行为补齐、Command；行内编辑已完成并由用户确认。
2. 桌面工作台：通用 Sortable、可排序 TabPane、Menubar 行为、Window/PinnedSheet。
3. 专用输入：PhoneInput、Formatted/ObjectInput、ItemPicker。
4. 展示与交互：Carousel、RefreshTrigger/Swiper、CodeSnippet、KeyboardDisplay、NumberTicker、Tracker、Chat。
5. 应用迁移：逐个清除 package:shadcn_flutter 和 package:lemon_shadcn 导入，替换图标、类型、控制器、主题、扩展与本地化；对实际业务流程做回归后再移除应用依赖。

实施顺序可由业务真实使用清单调整。补齐所有库能力与迁移某一个应用是不同验收范围，未扫描全部业务工程，不能宣称已经知道全部迁移调用点。

新增组件遵守 AGENTS.md：先进入 Demo 和主题编辑器的“未确认”分类；强类型主题、四端尺寸、状态过渡、整数像素编辑、无障碍文字缩放与相应验证同步完成。功能实现完成不自动迁入正式分类。

