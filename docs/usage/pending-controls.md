# 新增基础控件（2026-10-26，未确认）

本批实现评分、穿梭框、可调整分栏、可移动对话框，以及底部／侧向导航栏。它们正常公开导出、交互和参与主题配置；默认样式与行为等待用户确认，Demo 和主题编辑器均先登记在“未确认”。

## 评分

`HyperRating(value: value, onChanged: ...)` 是受控评分；`count` 指定星形数量，`step` 默认半星，支持 `readOnly`、禁用、横向/纵向和 `allowClear`。指针悬停仅预览，点击才提交；键盘方向键按步长调整，Home/Delete 清零，End 满分，横向支持 RTL。`itemBuilder` 可替换星形内容。

`HyperRatingFormField` 接入统一 Form 的校验、重置和保存。`ratingTheme`、局部 `HyperRatingTheme` 和 `HyperRatingStyle` 可覆盖星形、间距、命中区域、状态颜色与动效。

`gap` 是相邻星形布局框的实际间距，评分方向上的命中坐标与星形尺寸一致。`hitExtent` 只扩展垂直于评分方向的命中范围，不会扩大星形间距。悬停只预览；点击、键盘或外部值确认时清理旧预览，鼠标移出仅撤销未确认的悬停效果，不改写已保存的受控值。

## 穿梭框

`HyperTransfer<T>(options: ..., value: Set<T>, onChanged: ...)` 由调用方持有目标集合，内部只持有两侧搜索词及勾选状态。选项为 `HyperTransferOption<T>`，value 必须唯一，支持标签、描述、leading 和单项禁用。搜索匹配标签与描述；全选只操作当前过滤结果中的可用项，移动只提交已勾选可用项。

目标集合中的未知 value 会显示为只读占位，不会因选项刷新被静默删除；调用方可自行补齐远程标签。选项或受控值变化时清理失效勾选。`HyperTransferFormField<T>` 接入统一 Form。

面板从当前端菜单期望宽度、选择器面板高度、表单间距、卡片表面和列表项语义组合。宽度不足时上下排列，不改变设备类别。`panelHeight` 是期望高度，必要时增高以容纳缩放后的标题、搜索和至少一行选项。面板自己的列表滚动，整体布局由父级负责。

`transferTheme` / `HyperTransferTheme` / `HyperTransferStyle` 支持面板布局、标题/空结果文字、搜索框、列表项、操作按钮与表面覆盖。表面使用公共 `HyperNavigationSurface`，默认继承统一材质，显式边框、背景和空阴影列表保持优先。

选项圆角继承同端 `sizes.menu.itemRadius`，勾选底色默认使用主色的 8% 不透明度。表头与选项统一使用圆角方形复选框，视觉尺寸继承 `sizes.menu.iconSize`；表头保留最小交互尺寸，选项由整行提供命中区。`itemRadius`、`selectedItemColor` 和 `checkboxStyle` 支持全局、局部与实例覆盖。

## 可调整分栏

`HyperResizable` 接受至少两个 `HyperResizablePane`，父级必须提供有限宽高。Pane 支持初始权重、最小/最大逻辑尺寸、可折叠与折叠尺寸。`direction` 控制水平或垂直布局。拖动只调整相邻两栏，合法范围同时考虑两侧最小和最大值；最小尺寸总和超过宿主时整个组滚动，不能通过越过约束消除溢出。

`HyperResizableController` 管理权重与折叠状态，外部创建的控制器由调用方销毁。`setWeights` 的数量须与 panes 匹配；权重有限、非负且至少一个大于零。`setCollapsed` 仅对可折叠 Pane 生效。双击或 Enter/Space 切换相邻可折叠面板；分隔条聚焦后方向键每次一逻辑像素，Shift 使用当前表单间距加速。横向拖动和键盘支持 RTL。

拖动连续跟随指针；折叠与恢复、分隔线颜色使用 Motion，系统减少动画优先。`handleBuilder` 可替换分隔条。`resizableTheme` / `HyperResizableTheme` / `HyperResizableStyle` 管理命中区、线宽、状态色和过渡。

## 可移动对话框

使用 `showHyperMovableDialog` 打开 `HyperMovableDialog`。路由复用 `showHyperDialog`，内容与表面复用 `HyperDialog`，没有独立的 Card 弹窗配方或材质降级路径。只有标题可拖动，正文仍可输入、选择文字与滚动。聚焦标题后方向键移动、Shift 加速、Home 或双击复位。

`HyperMovableDialogController` 管理相对初始对齐位置的偏移。拖动和程序化移动限制在有界宿主内，宿主大小或键盘遮挡变化后重新校正。关闭和重新打开可复用同一控制器保持位置；控制器由调用方销毁。

`movableDialogTheme` / `HyperMovableDialogTheme` / `HyperMovableDialogStyle` 通过强类型 `dialogStyle` 覆盖公共对话框表面、内容和过渡，`mouseCursor` 覆盖标题鼠标样式。实例的空阴影列表仍能关闭阴影。仅对公共表面施加平移，不对高级模糊表面新增分数透明度层。

## 底部／侧向导航栏

`HyperNavigationBar<T>` 接受唯一 value 的 `HyperNavigationDestination<T>` 列表，以及受控 `selectedValue` / `onSelected`。水平方向用于底部导航，垂直方向用于侧向导航；布局方向是调用方配置，不按窗口宽度重新识别设备。它不管理路由，也不取代已有的多级 Sidebar。

每项支持普通/选中图标和禁用。可显示全部、仅选中或不显示标签，标签可在图标下方或旁边。仅选中模式保留标签占位，避免选择时突然改变高度。横向默认等宽，窄空间滚动；侧向容器由父级限定宽高。点击后可用方向键切换并跳过禁用项，Home/End 到首尾；支持 RTL。

`navigationBarTheme` / `HyperNavigationBarTheme` / `HyperNavigationBarStyle` 覆盖布局、图标、标签、默认/选中按钮样式与表面。表面复用公共导航材质路径，项目状态和动作继承现有按钮主题，文字跟随系统 TextScaler。

## 尺寸来源与验证边界

交互参照本地 `E:/lemon_shadcn` 的 Rating、Transfer、Resizable、MovableDialog 和 NavigationBar 封装，并核对其实际 `shadcn_flutter 0.0.55` 导出。HIUI 的 desktop 审核参考沿用项目固定源码快照 `f056c80e792aa8c0ca1ef0cdac8244abd7c58940`，官方仓库为 <https://github.com/XiaoMi/hiui>。本次未取得这五类控件完整、可直接采用的同代官方像素规范，不以第三方默认值或截图物理像素推算新规格。

默认几何为 D 级同端语义组合：评分读取 `sizes.icon`、`sizes.button.iconSpacing` 和最小交互尺寸；穿梭框读取 `sizes.menu`、`sizes.selection`、`sizes.form`、`sizes.card`、`sizes.listTile`；分栏读取 `sizes.divider` 和 `sizes.form.gap`；对话框读取既有 `sizes.dialog`；导航读取 `sizes.icon`、`sizes.button`、`sizes.form` 和 `sizes.card`。全部取当前已解析端，无组件内设备 switch 或跨端倍率。没有新增无来源的四端常量；单位均为 Flutter 逻辑像素。

新增 Style、ThemeData 均提供 copyWith、merge、插值与值相等，加入全局主题的复制/插值/相等/哈希。编辑器像素写入整数，颜色按亮暗外观、尺寸按设备保存；恢复继承保留原规格。动态几何编辑边界集中在 `editor_dimension_limits.dart`。默认时长/曲线继承全局 Motion。

已覆盖受控交互、禁用、只读、键盘、RTL 路径、约束、数据刷新、Form、主题往返、对话框材质与显式关闭阴影，以及窄宽和文字 1.0/1.3/2.0 倍布局。实际目标设备的字体、渲染效果与最终视觉仍待用户测试确认，不宣称与官方截图精确一致。

2026-10-26 用户指定评分默认星形 24、横向命中高度 32 逻辑像素，四端统一进入 sizes.rating（HyperRatingSize），局部与实例 Style 仍优先。该值来源为用户明确要求，不宣称为官方规格；间距继续继承同端按钮图标间距。

最大化/还原采用两阶段过渡：尺寸与位置先按全局 Motion.standardDuration/standardCurve 动画，此期间公共材质 transitionProgress 固定为 0，复用统一降级配方并关闭背景滤镜；几何完成后按 Motion.fastDuration 恢复材质。输入正文通过稳定键保留状态。系统减少动画时两个阶段立即完成。
