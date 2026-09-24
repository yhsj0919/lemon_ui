# Desktop 尺寸与样式审查：HIUI 对照

审查日期：2026-09-23。小米 [HIUI 组件总览](https://xiaomi.github.io/hiui/components/overview/)与 [XiaoMi/hiui 源码](https://github.com/XiaoMi/hiui/tree/f056c80e792aa8c0ca1ef0cdac8244abd7c58940)是 desktop 默认规格的主要参考。已核实的值见下表；未核实的值不凭截图估算。

## 已核实并校准

| 角色 | HIUI 默认值 | Lemon UI 原值 → 当前值 | 依据 |
| --- | --- | --- | --- |
| 语义字阶 | h1 32、h2 24、h3 18、h4 16、h5 14、h6 12；常规正文 14/22 | 所有端共用 → desktop 独立字阶 | [文字 token](https://github.com/XiaoMi/hiui/blob/f056c80e792aa8c0ca1ef0cdac8244abd7c58940/packages/core/core-css/src/styles/tokens/text.scss)、[normal 别名](https://github.com/XiaoMi/hiui/blob/f056c80e792aa8c0ca1ef0cdac8244abd7c58940/packages/core/core-css/src/styles/themes/text.scss) |
| Button 默认 md | 高 32、最小宽 72、左右内边距 12、字号 14、圆角 6 | 36/52/14/14/10 → 32/72/12/14/6 | [默认 md](https://github.com/XiaoMi/hiui/blob/f056c80e792aa8c0ca1ef0cdac8244abd7c58940/packages/ui/button/src/Button.tsx)、[尺寸](https://github.com/XiaoMi/hiui/blob/f056c80e792aa8c0ca1ef0cdac8244abd7c58940/packages/ui/button/src/styles/solid.scss)、[圆角](https://github.com/XiaoMi/hiui/blob/f056c80e792aa8c0ca1ef0cdac8244abd7c58940/packages/ui/button/src/styles/base.scss) |
| Card 默认 md | 圆角 8；标题左右 20、上下 13；标题 14 | 12、16/16 → 8、20/13 | [默认 md](https://github.com/XiaoMi/hiui/blob/f056c80e792aa8c0ca1ef0cdac8244abd7c58940/packages/ui/card/src/Card.tsx)、[Card 样式](https://github.com/XiaoMi/hiui/blob/f056c80e792aa8c0ca1ef0cdac8244abd7c58940/packages/ui/card/src/styles/card.scss) |
| Side Menu 菜单行 | 行高 32、文字 14、图标 16、圆角 6 | 44/14/20/10 → 32/14/16/6 | [Side Menu 样式](https://github.com/XiaoMi/hiui/blob/f056c80e792aa8c0ca1ef0cdac8244abd7c58940/packages/ui/menu/src/styles/side-menu.scss) |
| Sidebar 折叠宽 | 64 | 72 → 64 | [Sidebar 样式](https://github.com/XiaoMi/hiui/blob/f056c80e792aa8c0ca1ef0cdac8244abd7c58940/packages/ui/menu/src/styles/sidebar.scss) |
| Layout Sider 默认展开宽 | 180 | 256 → 180；Demo 宽屏侧栏通过实例 Style 读取 Drawer 的桌面默认宽度 304，容纳较长菜单内容 | [Sider 源码](https://github.com/XiaoMi/hiui/blob/f056c80e792aa8c0ca1ef0cdac8244abd7c58940/packages/ui/layout/src/Sider.tsx) |
| Layout Content 水平留白 | 左右各 16 | 桌面页面水平边距 24 → 16；Demo 页面从主题读取 | [Content 样式](https://github.com/XiaoMi/hiui/blob/f056c80e792aa8c0ca1ef0cdac8244abd7c58940/packages/ui/layout/src/styles/content.scss) |

`HyperCard` 保持自由内容表面职责，主体留白由内容布局决定；HIUI Card 的自动 body 内边距不直接移植。`HyperTypographyThemeData` 集中管理四端字阶，按钮、列表项和侧栏字号从已解析的文字主题读取。Demo 页面同样遵循字阶，只有演示实例覆盖时显式写字号。

## 已确认的问题

| 优先级 | 当前实现 | 影响与修正方向 |
| --- | --- | --- |
| 后续 | 字阶已按四端解析，颜色仍由同一套 `HyperColorScheme.fromSeed` 生成。见 [主题入口](../lib/src/theme/core/hyper_theme_data.dart)。 | 颜色本轮暂不调整；后续对照 HIUI 色彩层级。 |
| 高 | [顶栏解析](../lib/src/components/app_bar/hyper_app_bar_resolved.dart)在未指定材质时统一构造柔光玻璃，含 20 的模糊参数；desktop 只在 [尺寸方案](../lib/src/theme/size/hyper_size_scheme.dart)里改高度。 | desktop 默认表面没有独立的 HIUI 样式入口。应对照 HIUI [Page Header](https://github.com/XiaoMi/hiui/tree/master/packages/ui/page-header)和 [Layout](https://github.com/XiaoMi/hiui/tree/master/packages/ui/layout)确认桌面顶栏的布局、表面与状态，再决定 desktop 默认材质；用户显式材质仍须完整保留。 |
| 已处理 | 桌面字号曾分散在排版与组件尺寸中。 | 现由四端语义字阶模板统一提供；组件尺寸只负责布局。 |
| 中 | 默认颜色由 `#3482FF` 和 Flutter `ColorScheme.fromSeed` 生成，背景及文字色另有项目常量。见 [颜色方案](../lib/src/theme/color/hyper_color_scheme.dart)。 | 这套色彩不是从 HIUI token 映射得到，不能据此认定 desktop 的画布、表面、文字、边框、选中及悬停层级符合 HIUI。先建立 HIUI 到 Lemon UI 语义色的映射，再决定是否需要 desktop 专属配色。 |

## 尚待直接参考的数值

以下是暂未确认有相同 HIUI 组件职责的项目值。桌面顶栏的普通页面标题可参考 [Page Header](https://github.com/XiaoMi/hiui/blob/f056c80e792aa8c0ca1ef0cdac8244abd7c58940/packages/ui/page-header/src/styles/page-header.scss) 的 18/24，但该组件不包含滚动折叠行为。

| 角色 | 项目现值 | HIUI 对照入口 |
| --- | --- | --- |
| 通用控件档位 | 28 / 36 / 44 / 52 / 60；不是 HIUI Button 默认高度，按钮有独立规格 | [Input](https://github.com/XiaoMi/hiui/tree/master/packages/ui/input) |
| 卡片主体 | 默认内容内边距 0；自由内容由页面布局负责 | [Card](https://github.com/XiaoMi/hiui/tree/master/packages/ui/card) |
| 列表 | 最小行高 48、紧凑 40；标题与描述分别由桌面字阶提供 14、12 | [List](https://github.com/XiaoMi/hiui/tree/master/packages/ui/list)、[Table](https://github.com/XiaoMi/hiui/tree/master/packages/ui/table) |
| 侧栏弹层 | 弹层宽 256；展开宽已校准为 180，弹层与折叠悬浮菜单职责不同 | [Menu](https://github.com/XiaoMi/hiui/tree/master/packages/ui/menu) |
| 表面 | 基础表面圆角 14、浮层圆角 18 | [HiUI 设计指南](https://xiaomi.github.io/hiui/design/introduction/)、[Popover](https://github.com/XiaoMi/hiui/tree/master/packages/ui/popover) |

HIUI 是 Web 实现；以上 CSS px 与 Flutter 逻辑像素按 1:1 作为桌面默认规格，最终显示仍取决于系统缩放。没有直接对应的 `HyperAppBar` 大标题折叠、`HyperDrawer`、标题在外的卡片及带描述列表，需用户提供规范或标注逻辑尺寸后校准。颜色此次不调整。
