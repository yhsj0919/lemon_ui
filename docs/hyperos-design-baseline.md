# HyperOS 风格设计基准

本文用于在缺少单个控件截图时保持 Lemon UI 的视觉一致性。手机端参考 HyperOS 系统资料；**desktop 端的尺寸与样式以小米 [HiUI](https://github.com/XiaoMi/hiui) 为主要参考**；平板和手表按各自设备特性另定规格。本文不是小米官方完整设计规范；每个结论须区分来源和项目推导，不能把第三方实现或物理像素当成官方应用控件的逻辑尺寸。

资料核对日期：2026-09-23。系统和第三方组件库会更新，调整基准前重新核对对应版本。

## 一、来源与可信度

| 级别 | 来源 | 使用方式 |
| --- | --- | --- |
| A | 场景对应的小米官方资料：手机端用 HyperOS 规范与资源，desktop 端主要用 [HiUI 设计指南](https://xiaomi.github.io/hiui/design/introduction/)和 [XiaoMi/hiui 源码](https://github.com/XiaoMi/hiui) | 用于资料明确覆盖的场景；记录版本、设备和单位 |
| B | 已知设备与状态的系统截图、实机逻辑尺寸 | 复核视觉关系；先确认分辨率与缩放，不直接从物理像素推 dp |
| C | 第三方 [Compose Miuix 源码](https://github.com/compose-miuix-ui/miuix) | 借鉴组件层级和候选值；它不是小米官方规范，也不能代表所有 HyperOS 版本 |
| D | Lemon UI 已确认的主题值与相邻控件 | 缺少直接参考时保持内部一致；标记为项目推导，待对照验证 |

优先使用同一产品场景、系统代际、设备和组件状态的资料。HiUI 是小米的企业级中后台设计系统，不等同于 HyperOS 手机系统界面；不同版本的官方宣传页、桌面小部件规范、系统设置截图和第三方组件库不能合并成一张未经标注的“官方 token 表”。
[MIUIX 控件清单](miuix-component-inventory.md)固定了一个第三方源码快照；其中的候选规格也遵守本文的来源分级。

## 二、已核实的手机端线索

| 项目 | 来源事实 | Lemon UI 当前值或状态 | 结论 |
| --- | --- | --- | --- |
| 字体 | 小米称 [MiSans 为 HyperOS 默认系统字体](https://hyperos.mi.com/font/en/)；[官方小部件规范](https://dev.mi.com/xiaomihyperos/documentation/detail?pId=1664)推荐 MiSans | [主题](../lib/src/theme/core/hyper_theme_data.dart)按平台使用系统字体，未捆绑 MiSans | 字体一致性取决于目标设备实际解析结果；跨平台截图不能仅凭字号判断。先核对字形、字重、行高，再决定是否引入字体资产 |
| 字阶 | 第三方 [Miuix TextStyles](https://github.com/compose-miuix-ui/miuix/blob/main/miuix-ui/src/commonMain/kotlin/top/yukonga/miuix/kmp/theme/TextStyles.kt)给出标题 32/24/20/18sp、常规文字 17/16/14sp、按钮 17sp 等 | 页面标题 32、分区 24、次级 20；手机列表标题 17、按钮 16 | 现有层级大体相邻，但按钮字阶与 Miuix 候选值不同。后续按组件对照，不因“必须偶数”把 17 改成 16 或 18 |
| 卡片 | 第三方 [Miuix CardDefaults](https://github.com/compose-miuix-ui/miuix/blob/main/miuix-ui/src/commonMain/kotlin/top/yukonga/miuix/kmp/basic/Card.kt)给出 16dp 圆角、零默认内边距 | 手机 `HyperCardSize.radius = 16`、自由内容默认零内边距 | 可作为普通卡片基准；带标题卡片、浮窗与嵌套容器按各自职责选择圆角 |
| 按钮 | 第三方 [Miuix ButtonDefaults](https://github.com/compose-miuix-ui/miuix/blob/main/miuix-ui/src/commonMain/kotlin/top/yukonga/miuix/kmp/basic/Button.kt)给出最小宽 58dp、高 40dp、圆角 16dp、水平内边距 16dp | 手机按钮最小宽 58、高 48、圆角 16、水平内边距 16 | 宽度与圆角相符；高度差异要结合命中区域和截图验证，不直接批量改回 40 |
| 色彩 | 第三方 [Miuix 示例](https://github.com/compose-miuix-ui/miuix)用 `#3482FF` 作为可配置种子色示例 | 默认种子色 `#3482FF`，其余语义色由 Flutter `ColorScheme.fromSeed` 生成 | 种子色可作候选参考；生成出的整套颜色不能称作 HyperOS 原色板 |
| 动效 | [小米 HyperOS 产品页](https://www.mi.com/us/hyperos)描述设计追求舒适、流畅和多样 | 全局 Motion 默认 120/240/360ms | 产品页没有给出这些毫秒值；它们是 Lemon UI 内部节奏，需按状态对照验证并允许替换 |

**适用范围边界：**[小米小部件规范](https://dev.mi.com/xiaomihyperos/documentation/detail?pId=1664)中的 55px 圆角和 42px 安全区针对桌面小部件及指定分辨率，是物理像素；不得移植为应用 Card 的 55dp 圆角或 42dp 内边距。

## 三、无直接参考时可复用的手机端词汇

下面是**当前项目的起始词汇，不是小米官方 token**。数值只从现有主题读取，不能绕开主题系统复制到组件代码；具体组件已有已确认规格时，以该组件规格为准。

| 设计角色 | 当前主题候选 | 选用规则 |
| --- | --- | --- |
| 基础间距 | `HyperSizeScheme.space*` 的 4、8、12、16、20、24、32 | 先确定是图文间隔、内容内边距还是区块间距，再找同角色已用值；2、6 等保留给有依据的紧凑关系 |
| 容器圆角 | `HyperSizeScheme.radius*` 的 8、12、16、20、24 | 普通手机 Card 先看已确认的 16；弹出层、按钮、子容器分别比较同层级现有控件，不能把 16 强加给所有表面 |
| 文字层级 | `HyperTypographyScheme` 的页面 32、分区 24、次级 20、强调正文 18、正文 16、辅助 14、注释 12 | 按信息层级选语义字段；列表标题现为组件尺寸主题的 17，不能用正文 16 覆盖它 |
| 色彩 | `HyperColorScheme` 的语义色与各组件 ThemeData | 按背景、主文字、次文字、强调、分隔线、状态层的职责取色；不要直接散落种子色或自行推算透明度 |
| 动效 | 全局 `HyperMotionThemeData` 与组件可替换过渡 | 先沿用同类状态变化的节奏，再用目标状态对照验证；减少动画与材质降级仍由统一策略处理 |

间距、圆角与字阶是各自独立的语义系统，不能仅凭数值接近就互换。新默认值选定后应进入强类型主题和四端尺寸方案，而非留在单个 Demo 的布局常量中。

## 四、缺少直接参考时的设计方法

1. **先定义角色。**确认新组件是页面容器、卡片、列表行、按钮、浮窗还是导航结构，以及普通、选中、禁用、悬停、展开等状态。优先复用同角色的字体、颜色、间距、圆角和动效，不为每个新控件独创一套比例。
2. **从已确认的手机端语义值取候选。**文字使用 `HyperTypographyScheme` 和当前端列表字阶；间距先在现有 4dp 网格与组件尺寸主题中选；卡片、按钮和浮窗按各自层级取圆角。光学微调可以使用非网格值，但须记录原因。
3. **整组检查关系。**同时看外边距、内容内边距、标题到内容、图标与文字、圆角与容器大小、前景对比度；不要只修改截图中最醒目的一个数字。标题在卡片内外是不同排版角色，不能共用同一组间距。
4. **记录推导。**给新增或改动的默认值写明来源级别、链接或对照图、设备、状态、单位、当前值和选择理由。缺少证据时写“Lemon UI 暂定”，不写“HyperOS 官方”。
5. **成组预览。**至少在同一手机逻辑尺寸下并排检查列表页、卡片页、操作页和弹出层的亮/暗状态；若有目标截图，再按字体、圆角、留白、颜色、动效逐项对照。未做同条件对照时不宣称精准还原。

这套方法约束默认主题，不限制用户通过全局 `copyWith`、局部主题或实例 Style 明确指定另一种设计。

## 五、桌面端：以 HiUI 为主要参考

[HiUI 官方介绍](https://xiaomi.github.io/hiui/design/introduction/)明确定位为小米集团信息技术部的企业级中后台设计系统；[仓库](https://github.com/XiaoMi/hiui)提供 React 组件实现。Lemon UI 的 **desktop 主题默认尺寸与样式**以它为主要参考，包括页面布局、内容密度、标题层级、间距、圆角、颜色、表格/表单、导航和操作状态。先查同角色的 HiUI 规范与组件；缺少直接参考时复用已核实的 desktop 主题值，不把手机规格乘倍率。

| Lemon UI 角色 | HiUI 对照入口 | 核对重点 |
| --- | --- | --- |
| 页面框架与导航 | [Layout](https://github.com/XiaoMi/hiui/tree/master/packages/ui/layout)、[Menu](https://github.com/XiaoMi/hiui/tree/master/packages/ui/menu)、[Page Header](https://github.com/XiaoMi/hiui/tree/master/packages/ui/page-header) | 区域层级、侧栏展开、标题与操作区关系 |
| 容器和操作 | [Card](https://github.com/XiaoMi/hiui/tree/master/packages/ui/card)、[Button](https://github.com/XiaoMi/hiui/tree/master/packages/ui/button)、[Drawer](https://github.com/XiaoMi/hiui/tree/master/packages/ui/drawer) | 密度、留白、圆角、边界和各状态 |
| 内容和浮层 | [Table](https://github.com/XiaoMi/hiui/tree/master/packages/ui/table)、[Form](https://github.com/XiaoMi/hiui/tree/master/packages/ui/form)、[Popover](https://github.com/XiaoMi/hiui/tree/master/packages/ui/popover) | 信息层级、行高、对齐、浮层与锚点关系 |

先核对 [HiUI 文档](https://xiaomi.github.io/hiui/)和对应版本源码中的 Design Token、组件规格与示例，再把选定值映射到 Lemon UI 的 `HyperColorScheme`、`HyperTypographyScheme`、组件 `ThemeData` 和 `HyperSizeScheme.desktop`。当前实现的问题与待核对值见 [desktop 审查](hiui-desktop-audit.md)。网页 CSS 的 px 与 Flutter 逻辑像素只有在显示条件可比时才能直接对照；不能只凭同名单位移植数值。用户提供明确的目标截图或实例样式时，按该目标进行对照。

## 六、跨设备扩展

四端保留相同的角色与状态语义，分别确定具体尺寸和页面结构，不把手机数值统一乘倍率。小米的[大屏 UX 标准](https://dev.mi.com/xiaomihyperos/documentation/detail?pId=2040)要求使用 dp 保持舒适尺寸、增加内容列数、限制组件过度拉伸，并在合适场景采用侧边导航；这支持平板采用不同布局和最大宽度。desktop 端按本节以 HiUI 为主要参考，手表仍需另找适用资料。四端独立规格继续由 `HyperSizeScheme` 管理。

## 七、当前待核对项

- **字体资产与字重：**目前使用平台系统字体，跨平台字形差异会影响截图比较；先确定目标设备上的实际字体，再决定是否捆绑 MiSans。
- **手机按钮高度和字号：**与第三方 Miuix 候选值不同，保留现值直到可对照同状态截图或系统规格。
- **颜色：**当前语义色由 Material 色调算法生成，需用手机端页面对照检验层级和对比度。
- **不同容器的圆角：**普通 Card 已有 16dp 候选；标题卡片、弹出层和玻璃材质按同一页面的层级关系审查，不能套用小部件的物理像素规范。
- **桌面 HIUI 版本与组件值：**已确定来源和对照入口；具体颜色、字号、圆角、行高与间距须按选用的 HiUI 版本逐项核实，现有桌面主题尚未整体按 HIUI 重定值。

每次确认一项后，再更新对应强类型主题值和 [尺寸规范](size-specification.md)。未经确认的候选值不批量改动已有组件。
