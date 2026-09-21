# compose-miuix-ui/miuix 参考审查

参考项目：[compose-miuix-ui/miuix](https://github.com/compose-miuix-ui/miuix)。

本文记录 Lemon UI 可以吸收的设计，以及因 Flutter 技术栈和本项目定制目标不同而不直接照搬的部分。完整控件对照与手机默认规格见 [MIUIX 控件清单、合并关系与手机规格](miuix-component-inventory.md)。参考不等于复制 API 或内部实现；经源码确认的手机尺寸和视觉规则可以作为 phone 默认值。

当实机截图不足以确认控件的尺寸、圆角、颜色、状态或动画时，应优先查看
MIUIX 对应控件的公开源码和示例。取值需要结合 HyperOS 实机再次校准，并沉淀
到 Lemon UI 的显式主题字段中；不能仅凭 Material 默认值补齐视觉细节。

## 一、值得借鉴的总体结构

Miuix 将能力拆分为 core、UI、preference、icons、blur、shader、squircle 和 navigation 等模块。这个边界适合 Lemon UI：

- 核心包保留主题、基础控件、交互、普通形状和普通材质。
- 高成本 shader、增强模糊和大型图标库后期作为可选包或适配层。
- 设置页组件建立在基础 UI 之上，不反向污染基础控件主题。
- 导航和多窗口可以独立演进，不要求所有应用引入完整能力。

Flutter 第一阶段仍保持单包开发，避免过早发布多个包；但目录、依赖方向和公开 API 从一开始按可拆分边界组织。

## 二、材质与模糊参考

Miuix 的模糊系统体现了以下值得保留的原则：

- 背景捕获与模糊表面分离，表面不会隐式猜测需要采样的背景范围。
- 在使用模糊、混色和 shader 前明确检测平台能力。
- 颜色处理独立表达亮度、对比度、饱和度和多个混合层。
- 支持 X/Y 不同模糊半径、噪点抖动和低层效果管线。
- 渐进模糊适合顶部栏、底部栏和边缘淡化，但明确提示它比普通均匀模糊增加 GPU 带宽。

Lemon UI 对应设计：

- `HyperBackdrop`：明确标记被采样的背景区域或 backdrop key。
- `HyperSurfaceMaterial`：描述 solid、translucent、frostedGlass 和 softLightGlass 配方。
- `HyperMaterialCapabilities`：描述 backdrop、滤镜、runtime shader 等能力，不把平台判断散落在控件中。
- `HyperBlurDirection` 或渐进模糊配置只在实际实现时公开，不提前增加无效果参数。
- 普通 Flutter `BackdropFilter` 为核心实现；增强 shader 作为后期可选能力。

不照搬 Miuix 的大量混合模式枚举。第一版只公开 Flutter 能稳定跨平台实现和测试的少量模式；低层 shader API 后期放入高级扩展包。

## 三、形状参考

Miuix 将 squircle 的背景、表面、裁切和边框分开，并提供普通圆角 fallback。Lemon UI 采用相同职责分离思想：

- 描述形状不自动开启裁切。
- 填充、裁切和描边可以分别使用同一形状。
- 连续圆角或超椭圆不可用时回退到普通圆角。
- 支持方向相关的 start/end 角和不受 RTL 影响的绝对角，但 API 使用 Flutter 原生 `BorderRadiusGeometry`、`TextDirection` 和 `ShapeBorder` 语义。
- shader 或离屏层的使用必须可检测、可关闭并有性能说明。

不直接移植 Compose Modifier 链。Flutter 中优先使用 `ShapeBorder`、`ClipPath`、`CustomPainter` 和必要的 `RenderObject`。

## 四、基础组件与插槽参考

Miuix 的 `BasicComponent` 提供 start、end、bottom 和自定义 content 插槽，证明“快速设置页组件 + 任意内容”是可行方向。Lemon UI 可以参考其槽位语义，但避免形成万能公共视觉控件：

- 后期提供设置项或列表项专用的 Hyper 控件，而不是让所有控件继承一个 `HyperBasicComponent` 主题。
- start/end/bottom 插槽对任意 Widget 使用相同约束，不识别具体子控件类型。
- 简单标题/摘要构造和任意 child 构造共享同一布局契约。
- 光学间距属于插槽公开属性或对应控件主题，不要求子控件自己添加神秘 Padding。
- 复合 preference 控件可以复用布局算法，但拥有自己的语义、状态和主题入口。

## 五、按钮参考

Miuix Button 的优点是默认最小尺寸、圆角、内容边距和状态颜色清楚，并允许任意内容组合。Lemon UI 保留这些特点，同时补齐其不覆盖的需求：

- 使用 `.filled`、`.tonal`、`.outlined`、`.ghost`、`.text` 和 `.gradient` 命名构造器，而不是要求调用方选择颜色工厂。
- `HyperButtonStyle` 和 `HyperButtonThemeData` 对应全部适用样式属性。
- 同步和异步统一使用 `FutureOr<void> Function()? onPressed`，由按钮自动管理 loading。
- loading、确定进度和失败恢复保持尺寸稳定，不要求每个页面手写状态和 `AnimatedVisibility`。
- 使用 `HyperPressable` 统一鼠标、触摸、键盘、右键、焦点和语义。
- 图标文字组合提供便捷参数，任意 child 仍作为最终自由组合入口。

手机方案采用源码确认的 58×40 最小尺寸和 16 圆角作为按钮基准；这些值必须经过
`HyperButtonThemeData` 解析，不得绕过主题写死。平板、桌面和手表分别使用明确
方案，禁止从手机数值乘倍率生成。

## 六、主题参考

Miuix 提供亮暗模式、直接颜色方案、种子色和动态色控制器。这些可以作为 `HyperColorScheme` 后续能力参考：

- 系统亮暗模式与显式亮暗覆盖。
- 从种子色生成方案。
- 后期可选的系统动态色来源。
- 颜色方案和字体方案独立配置。

Lemon UI 不把主题限制为颜色和字体。每个控件仍具有独立 `HyperXxxThemeData`，并支持全局控件主题、局部控件主题和实例逐字段覆盖。

## 七、悬浮层参考

Miuix 区分依赖 Scaffold 的跨平台 Overlay 弹层和窗口级弹层，这对 Lemon UI 的手机/桌面/多窗口规划有参考价值：

- `HyperOverlayScope` 提供统一应用内弹层宿主、焦点和关闭管理。
- 桌面与后期多窗口提供窗口级 overlay 路径。
- 弹层 API 明确选择应用内 overlay 还是平台窗口，不由控件暗中切换。
- 常规对话框和菜单不应强制应用必须换成 `HyperScaffold`；缺少显式 Scope 时可以安全使用 Flutter `Overlay`，高级能力再要求 Scope。

## 八、明确不照搬的部分

- 不照搬 Compose Modifier API 或参数命名，公开 API 优先符合 Flutter。
- 不让尺寸常量绕过控件主题；MIUIX 手机值进入可覆盖的 phone 默认值，平板、桌面和手表继续使用独立明确值。
- 不依靠颜色工厂代表全部视觉变体。
- 不要求调用方手动实现所有异步 loading 状态。
- 不把实验性 shader 作为核心包普通控件的硬依赖。
- 不因为参考库有一个通用 BasicComponent，就让卡片、设置项、列表项和表单行共享同一个全局视觉主题。

## 九、后续审查方式

实现以下控件前应再次检查 Miuix 对应组件，但只提取行为和视觉规律：

- `HyperSurface`、材质和渐进模糊。
- `HyperButton`、`HyperIconButton` 和状态反馈。
- 连续圆角、超椭圆、形状裁切与变换。
- `HyperScaffold`、导航栏、导航轨道和浮动工具栏。
- 设置项、开关项、选择项和滑块项。
- Overlay/Window 菜单、对话框、BottomSheet 和级联菜单。

每次参考都要回答：Flutter 原生已有何种能力、是否需要公开新类型、如何主题覆盖、如何降级、是否会引入隐藏布局规则，以及是否值得进入核心包。
