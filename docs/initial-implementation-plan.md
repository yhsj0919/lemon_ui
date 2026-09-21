# Lemon UI 前期实现计划

本文档冻结第一阶段需要实现的公共属性、基础类型和开发顺序。目标是从最简单的能力开始，每完成一步便停下来评审，再继续下一步，不批量铺开控件。

所有阶段同时遵守 [自定义契约](customization-contract.md)：不得使用公开第三方别名、不得按子控件类型特判布局，并且每个控件都要提供可检查的自定义入口和布局契约。

涉及材质、形状、按钮、导航、设置项和悬浮层时参考 [Miuix 参考审查](miuix-reference-review.md) 与 [MIUIX 控件清单、合并关系与手机规格](miuix-component-inventory.md)。手机规格优先采用经源码确认的 MIUIX 值；实现方式仍服从 Flutter 与本项目主题原则。

## 一、公共属性的基本原则

公共属性分为三层：

1. 全局基础主题：只提供跨控件真正通用的默认值。
2. 控件独立主题：提供该类控件自己的详细视觉属性。
3. 控件实例属性：精确控制当前控件，优先级最高。

```text
控件实例属性
→ HyperXxxThemeData
→ HyperThemeData 基础默认值
→ HyperDefaults 内置默认值
```

每个属性独立解析。实例只设置高度时，其他属性仍从控件主题和全局主题继承。所有尺寸均为明确的 Flutter 逻辑尺寸；尺寸预设可以选择一组固定值，但禁止使用任何倍率缩放。

## 二、统一属性名称和类型

控件只公开自身实际支持的属性，不要求每个控件包含以下全部字段。相同含义在不同控件中必须使用相同名称和类型。

### 视觉属性

| 属性 | 类型 | 说明 |
| --- | --- | --- |
| `background` | `HyperFill?` | 纯色、渐变或显式无背景 |
| `foregroundColor` | `Color?` | 主要前景色 |
| `iconColor` | `Color?` | 图标颜色；未指定时可回退到前景色 |
| `textStyle` | `TextStyle?` | 当前控件主要文字样式 |
| `border` | `BoxBorder?` | 使用 Flutter 原生边框类型 |
| `borderRadius` | `BorderRadiusGeometry?` | 使用 Flutter 原生圆角类型 |
| `boxShadow` | `List<BoxShadow>?` | `null` 表示继承，空列表表示显式无阴影 |
| `opacity` | `double?` | 仅适合拥有整体透明度的控件 |
| `clipBehavior` | `Clip?` | 仅适合拥有裁切边界的控件 |

### 布局属性

| 属性 | 类型 | 说明 |
| --- | --- | --- |
| `width` | `double?` | 明确宽度，不参与倍率缩放 |
| `height` | `double?` | 明确高度，不参与倍率缩放 |
| `constraints` | `BoxConstraints?` | 最小和最大尺寸约束 |
| `padding` | `EdgeInsetsGeometry?` | 控件内部间距 |
| `margin` | `EdgeInsetsGeometry?` | 仅容器、表面等适合管理外部间距的控件提供 |
| `alignment` | `AlignmentGeometry?` | 内容对齐 |
| `size` | 控件独立枚举 | small、medium、large 等明确数值预设 |

### 动画属性

| 属性 | 类型 | 说明 |
| --- | --- | --- |
| `animationDuration` | `Duration?` | 当前控件样式变化时长 |
| `animationCurve` | `Curve?` | 当前控件样式变化曲线 |
| `animate` | `bool?` | 仅在确实需要单独关闭动画时提供 |

动画属性仍受系统“减少动画”设置约束。关闭动画只改变过渡过程，不改变最终属性值。

### 交互属性

遵循 Flutter 原生命名：`enabled`、`focusNode`、`autofocus`、`mouseCursor`、`onHover`、`onFocusChange`、`semanticLabel`。

只有可交互控件才提供这些属性。手势和语义由统一基础设施处理，不复制到纯展示控件。

### 内容属性

- 单个主要内容使用 `child`。
- 多个内容使用 `children`。
- 延迟创建使用 `builder` 或带明确语义的 `itemBuilder`。
- 前后内容使用 `leading` 和 `trailing`。
- 标题和说明使用 `title`、`subtitle` 或 `description`，按 Flutter 对应控件习惯选择。

## 三、显式关闭语义

`null` 默认表示未指定并继续继承。需要移除主题效果时必须提供明确值：

```dart
background: HyperFill.none()
border: const Border()
boxShadow: const []
padding: EdgeInsets.zero
```

第一阶段只为确实需要三态语义的背景提供 `HyperFill`。其他属性优先使用 Flutter 原生类型的中性值，避免过早建立大量包装类型。

## 四、第一阶段全局主题属性

`HyperThemeData` 前期只实现以下基础字段：

```dart
class HyperThemeData {
  final Brightness brightness;
  final HyperColorScheme colors;
  final TextTheme textTheme;
  final BorderRadiusGeometry borderRadius;
  final double controlHeight;
  final EdgeInsetsGeometry controlPadding;
  final Duration animationDuration;
  final Curve animationCurve;
  final HyperContainerThemeData containerTheme;
}
```

- `controlHeight` 是未指定高度时的公共默认值，不是缩放基数。
- `borderRadius` 是未指定圆角时的公共默认值，不会乘任何系数。
- 各控件主题可以覆盖这些默认值。
- 控件实例显式值始终优先。
- 后续每实现一个新控件，再向总主题增加对应的 `HyperXxxThemeData`，不提前放入空字段。

## 五、第一批基础类型

### 1. `HyperFill`

第一步只实现这个最小值对象：

```dart
sealed class HyperFill {
  const HyperFill();

  const factory HyperFill.none() = HyperNoFill;
  const factory HyperFill.color(Color color) = HyperColorFill;
  const factory HyperFill.gradient(Gradient gradient) = HyperGradientFill;
}
```

必须支持显式无背景、纯色、Flutter 原生 `Gradient`、相等比较以及插值。暂时不加入纹理、图片、Shader、模糊和动态渐变。

### 2. `HyperColorScheme`

前期只保留最基本语义色：

```text
primary / onPrimary
background / onBackground
surface / onSurface
outline
disabled
error / onError
success / onSuccess
warning / onWarning
```

支持 light、dark、fromSeed、copyWith 和 lerp。

### 3. `HyperContainerThemeData`

第一版字段：

```dart
class HyperContainerThemeData {
  final HyperFill? background;
  final BoxBorder? border;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final AlignmentGeometry? alignment;
  final BoxConstraints? constraints;
  final Duration? animationDuration;
  final Curve? animationCurve;
  final Clip? clipBehavior;
}
```

必须不可变，并提供 `copyWith` 和 `lerp`。

### 4. `HyperThemeData` 与 `HyperTheme`

必须支持：

- 无配置时生成完整可用的默认主题。
- light、dark 和 fromSeed。
- 根部全局主题。
- 嵌套局部主题逐字段覆盖。
- `HyperTheme.of(context)` 和 `HyperTheme.maybeOf(context)`。
- Flutter `ThemeData` 缺失 Hyper 主题时的安全回退。
- 动态主题切换插值。

第一版不实现设备专属主题、完整组件注册表或主题编辑器。

## 六、第一个可视控件：`HyperContainer`

`HyperContainer` 用于验证整个主题和视觉属性体系，不承担交互、Overlay 或异步能力。

第一版公开 API：

```dart
class HyperContainer extends StatelessWidget {
  const HyperContainer({
    super.key,
    this.child,
    this.background,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.padding,
    this.margin,
    this.alignment,
    this.width,
    this.height,
    this.constraints,
    this.animationDuration,
    this.animationCurve,
    this.clipBehavior,
  });
}
```

实现要求：

- 大部分视觉使用 Flutter `Container` 或 `DecoratedBox`。
- 实例属性逐项覆盖 `HyperContainerThemeData`。
- 控件主题再逐项回退到 `HyperThemeData` 基础值。
- `width`、`height` 和约束保持精确，不进行倍率换算。
- 支持纯色、渐变和显式无背景。
- 支持主题变化动画和减少动画。
- 不加入点击、悬停、焦点、loading 或业务状态。

## 七、前期实现顺序

每个步骤完成并评审后再进入下一步。

### P0-1：`HyperFill`

状态：`[x]` 已完成。

- 新增类型和单元测试。
- 确认纯色、渐变、none 和插值语义。
- 在 Example 中只做静态色块预览。

### P0-2：`HyperColorScheme`

状态：`[x]` 已完成。

- 实现 light、dark、fromSeed、copyWith 和 lerp。
- 确认 HyperOS 风格的首套默认颜色。

### P0-3：`HyperContainerThemeData`

状态：基础实现与可交互 Demo 已完成，待用户评审。

- Demo 入口：基础能力 → HyperContainerThemeData。
- `merge` 只覆盖非空字段；`copyWith` 未传参数保留原值，显式传 null 恢复继承。
- 阴影列表复制为不可变列表，空列表用于移除阴影。
- 插值中的单侧 null 与离散属性在中点切换；主题应先解析再用于最终视觉动画。
- 当前用 Flutter 原生 Container 展示数据；已接入 P0-4 的全局主题。

- 实现字段、copyWith、lerp 和显式清除规则。
- 单元测试逐字段覆盖行为。

### P0-4：`HyperThemeData` 与 `HyperTheme`

- 状态：基础实现、可交互 Example 和测试已完成，待用户评审。
- 实现默认主题、局部主题和动态切换。
- 验证实例、控件主题、局部主题、全局主题和默认值优先级。

### P0-5：`HyperContainer`

- 状态：轻量基础实现、可交互 Example 和测试已完成，待用户评审。
- 实现第一版 API。
- 增加 Example、Widget 测试和 Golden 测试。
- 验证显式尺寸、渐变、阴影、边框和圆角。

### P0-5.5：`HyperSizeScheme`

- 状态：数据类型、总主题接入、主题外层设备探测、四终端可交互 Example 和测试已完成，待用户评审。
- 在开发下一个正式控件前实现，具体数值以 `size-specification.md` 为准。
- 提供 phone、tablet、desktop、watch 四套离散尺寸，不使用倍率换算。
- 将视觉高度与最小命中区域分开。
- 接入 `HyperThemeData`，并保留控件实例和控件主题的更高优先级。
- 提供可切换四类终端的 Example，明确显示控件高度、圆角、间距和命中区域。
- 完成后再进入状态、动画和按钮等控件开发。

### P0-6：状态与动画基础

- 状态：`HyperControlState`、`HyperStateValue<T>`、`HyperMotionThemeData`、可交互 Example 和测试已完成。
- `HyperControlState`
- `HyperStateValue<T>`
- 统一状态优先级。
- 统一动画解析和减少动画。

### P0-7：`HyperPressable`

- 状态：轻量基础实现、可交互 Example 和测试已完成，待实际使用反馈后扩展少见手势。
- 单击及 down、up、cancel 生命周期。
- 双击及 down、cancel 生命周期。
- 长按及 down、start、move、up、end、cancel 生命周期。
- 右键完整点击生命周期；中键提供 down、up、cancel。辅助按键长按在确有业务场景时再扩展。
- 悬停、按压、拖动、焦点、键盘激活、鼠标光标、语义和触觉反馈。
- 统一输出 `pressed`、`secondaryPressed`、`tertiaryPressed`、`longPressed`、`dragged`、`hovered` 和 `focused` 状态。
- 单击和双击同时配置时遵循 Flutter 手势竞技场：单击等待双击判定完成，不自行提前触发。
- 不包含具体按钮视觉。

### P0-7.5：表面材质基础

- 状态：基础类型、总主题、可嵌套局部主题、材质表面、四种材质 Demo 和降级测试已完成；增强 shader 与内容采样留待后续可选能力。
- 全局 `HyperContrastThemeData` 与局部 `HyperContrastTheme` 已完成，按钮 Demo 可切换原色、自适应反色和强制反色。
- 在按钮本体前实现 `HyperSurfaceMaterial`、`HyperMaterialQuality`、`HyperMaterialThemeData` 和局部 `HyperMaterialTheme`。
- 第一版实现 solid、translucent 和 frostedGlass；softLightGlass 先建立明确配方，复杂内容采样与动态光效后续迭代。
- 普通材质为默认和最终 fallback，高级材质不得改变控件布局尺寸。
- 接入总主题，并制作普通、半透明、毛玻璃和柔光玻璃并列 Demo。
- 测试显式参数、局部覆盖、减少动画、减少透明度降级和嵌套玻璃边界。
- 完成材质基础后再继续 `HyperButton` 本体，使按钮、弹层、导航和卡片共用同一套材质能力。

### P0-8：`HyperButtonThemeData` 与 `HyperButton`

- 状态：`HyperButtonStyle`、主题、六种按钮变体、同步与自动异步回调、环形进度、图标文字、稳定尺寸 Demo 和基础测试已完成；线性与背景填充进度待补充。
- 已按 MIUIX 对照修订设备默认值：手机 58×40、平板 64×44、桌面 52×36、手表 52×40；桌面32高度仅作为后续紧凑档位。已补齐显式按钮字体、焦点状态层、禁用容器/内容色和分终端状态透明度；详细规则见 `miuix-component-inventory.md` 的 Button 专项章节。
- 普通和 `FutureOr<void>` 异步回调。
- loading 时尺寸稳定。
- `HyperButtonStyle` 统一承载主题公共样式和变体样式；实例样式属性与其字段保持同名、同类型、同语义。
- 背景、前景色、边框、阴影、字体、圆角、内边距、间距、尺寸、图标和进度视觉均可在实例与按钮主题中对应设置。
- 首批通过 `HyperButton.filled`、`.tonal`、`.outlined`、`.ghost`、`.text` 和 `.gradient` 命名构造器提供视觉变体。
- 各变体支持纯文字、可选图标文字组合和任意 `child`；纯图标由 `HyperIconButton` 承担。
- 支持环形、底部线性和背景填充等进度表现，确定进度可显式指定 `0.0` 到 `1.0`。
- 变体、内容形式和异步状态保持正交，不为每种排列组合创建新控件。
- 验证组件主题完全独立于 Container、Card 等其他组件主题。
- 提供局部 `HyperButtonTheme`，并验证它只影响子树内的按钮。

### P0-9：`HyperIconButtonThemeData` 与 `HyperIconButton`

- 状态：四种变体、独立样式与主题、Tooltip、同步/异步回调、稳定尺寸、材质 Demo 和测试已完成。
- 默认尺寸已独立为手机40、平板44、桌面36、手表40；桌面不再从通用高度或手机尺寸直接套用。
- 图标按钮不继承 `HyperButtonThemeData`，避免普通按钮全局样式改变时连带变形。
- Gallery 的移动端菜单入口已从原生 `IconButton` 替换为 `HyperIconButton.ghost`。
- 其他原生图标按钮在对应辅助组件实现时继续逐步替换；兼容性对照除外。

### P0-10：`HyperSwitchThemeData` 与 `HyperSwitch`

- 状态：点击、键盘、实时横向拖动、禁用和减少动画已完成；手机和平板参考MIUIX并按偶数规范采用48×28轨道、20滑块、4/24偏移；桌面采用44×24轨道、18滑块、4/22偏移；手表使用44×26。悬浮、按下和拖动时滑块放大至1.127倍。
- 轨道与滑块的启用/禁用颜色、圆角、偏移、交互缩放和动画均可分别显式配置；默认不叠加 Material 状态色。
- 开关视觉属性由独立 `HyperSwitchStyle` 管理，支持全局主题、局部主题和实例覆盖。
- 已替换材质、按钮主题和字号 Demo 中的三个原生 `SwitchListTile`；带整行点击与说明布局留给后续 `HyperSwitchListTile`。
- 明确测试 null 继承、none 清除、空阴影、零尺寸、`copyWith` 恢复继承和逐字段状态解析。
- 明确测试六种变体的默认值、全局按钮主题、局部按钮主题和实例覆盖。
- 明确测试按钮材质在 standard、advanced、减少透明度和实例覆盖之间切换时的绘制层级与尺寸稳定性。
- 明确测试 `child` 与便捷内容参数互斥、RTL、文字放大、高对比度、减少动画及显式视觉尺寸与命中区域分离。

### P0-9：Overlay 基础

- `HyperOverlayScope`
- `HyperAnchoredOverlay`
- Tooltip 和 Menu 所需的最小定位、关闭和焦点能力。

### P0-10：`HyperTextFieldThemeData` 与 `HyperTextField`

- 复用 Flutter 文本编辑能力。
- 验证焦点、错误、异步校验和表单尺寸稳定性。

## 八、第一阶段暂不实现

- 完整组件目录中的其他控件。
- 设备专属控件、弧形手表 UI 和正式版多窗口能力。
- 模糊、Shader、纹理和复杂玻璃效果。
- 图表、数据网格和富文本编辑。
- `HyperScaledBox` 等显式全局缩放工具。
- 第三方状态管理、网络和平台插件集成。

## 九、每一步的 Demo 与评审

每个步骤都必须提供可运行、可以直接看到效果的 Demo。没有 Demo 的步骤不能标记为完成，即使代码、静态分析和单元测试已经通过。

### Demo 硬性要求

- 每个新类型或控件都必须在 `example` 中拥有独立、可定位的展示区域。
- 视觉控件必须展示默认效果、主要变体、主题效果和实例属性覆盖效果。
- 交互控件必须能真实点击、输入、聚焦、悬停或拖动，不能只放静态截图。
- 动画能力必须提供可重复触发入口，并能对照正常动画和减少动画结果。
- 异步能力必须提供成功、失败、延迟、重复触发和重试的本地模拟，不依赖网络。
- 主题能力必须能直观看到全局主题、控件主题和实例属性的不同优先级。
- 尺寸能力必须显示实际宽高或辅助标尺，证明显式尺寸没有被倍率缩放。
- 非直接视觉类型也必须通过最小可视载体展示结果，例如用色块展示 `HyperFill`，用示例控件展示状态解析。
- Demo 必须能在至少一个目标平台直接运行；控件进入稳定阶段后再补齐对应设备预览。
- Demo 本身必须有启动或关键交互测试，防止示例长期失效。
- Example 中的主控件和辅助控件都要逐步替换为已完成的 Hyper 控件。
- Hyper 同类控件尚未实现时可以临时使用 Flutter 原生控件；实现后必须在该控件的开发步骤内搜索并替换现有 Demo 用法。
- 为兼容性对照而保留的原生控件必须显式标注，不计作正式 Hyper 演示。

### 每步提交内容

每完成一个步骤，提交以下内容供确认：

- 公开 API。
- 可运行 Demo 入口和实际效果。
- 属性继承和显式覆盖对照。
- 已覆盖的自动化测试。
- 当前限制和下一步前仍需决定的问题。
- Example 中同类原生控件的搜索结果、已替换位置和有理由保留的位置。

未经确认，不批量实现后续组件或提前扩张公开 API。
