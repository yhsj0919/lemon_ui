# Lemon UI 主题与尺寸架构

本文冻结 Lemon UI 的主题、设备适配和组件默认值架构。新增组件、主题重构、Demo 和测试均须遵守本文；主题类随组件增加而变大是集中式强类型设计系统的预期成本，不再作为拆散主题的理由。

## 一、总体目标

Lemon UI 提供一套完整可用的 HyperOS 默认主题。使用者可以保持业务组件代码不变，仅通过 `copyWith` 覆盖与默认主题不同的部分，快速替换整套颜色、材质、排版或多端尺寸。

```text
HyperOS 内置默认主题
→ 用户全局主题
→ 当前子树局部主题
→ 当前组件实例 Style
```

后一级只覆盖明确提供的字段，其余字段继续继承前一级。

## 二、统一主题入口

普通应用只需要提供 `HyperTheme`：

```dart
HyperTheme(
  data: HyperThemeData.light(),
  child: const App(),
)
```

设备类型最终由主题作用域统一协调。Windows、Linux 和 macOS 固定为 desktop；
只有 Android 和 iOS 在启动时区分 phone、tablet 或 watch。测试、预览和特殊设备可以显式指定：

```dart
HyperTheme(
  data: HyperThemeData.light(),
  deviceType: HyperDeviceType.desktop,
  child: const App(),
)
```

业务层不应为了选择控件尺寸编写 `switch (deviceType)`，也不应为四类设备分别构建四套页面。

设备类型表示真实设备类别，不表示当前页面宽窄。自动结果在应用或窗口作用域首次建立时确定，普通窗口缩放、桌面窄窗口和移动端分屏都不得改变设备类型。当前约束只用于独立的页面形态或窗口尺寸等级：桌面窄窗口仍使用 desktop 控件尺寸，但页面可以切换为 compact 布局；平板进入窄分屏后仍使用 tablet 控件尺寸。

## 三、主题职责分离

`HyperThemeData` 集中持有以下强类型主题：

- `colors`：语义颜色。
- `typography`：字体族、语义字号、字重、行高和字间距。
- `sizes`：手机、平板、桌面和手表的全部尺寸方案。
- `motion`：动画时长和曲线。
- `materialTheme`：材质质量和透明度策略。
- 各组件 `ThemeData`：组件视觉、变体和状态配方。

视觉、尺寸和排版相互独立。替换颜色不得改变尺寸，替换尺寸不得改变颜色；设备相关字号由统一排版主题解析，不得写在组件实现中。

## 四、集中式多端尺寸

`HyperSizeThemeData` 保存四套明确方案：

```text
HyperSizeThemeData
├─ phone: HyperSizeScheme
├─ tablet: HyperSizeScheme
├─ desktop: HyperSizeScheme
└─ watch: HyperSizeScheme
```

`HyperThemeData.sizes` 始终表示这份四端全局配置。组件通过
`HyperTheme.sizesOf(context)` 读取作用域建立时已解析的当前端方案，
不得自行查询平台或窗口尺寸。

`HyperSizeScheme` 除页面边距、区块间距、最小命中区域等公共尺寸外，还持有各组件的强类型尺寸对象：

```text
HyperSizeScheme
├─ button: HyperButtonSize
├─ iconButton: HyperIconButtonSize
├─ progressIndicator: HyperProgressIndicatorSize
├─ switchSize: HyperSwitchSize
├─ checkbox: HyperCheckboxSize
├─ radio: HyperRadioSize
└─ 后续组件尺寸
```

组件尺寸值对象必须不可变，并实现 `copyWith`、值相等和需要时的 `lerp`。设备规格使用明确值，不通过手机尺寸乘倍率生成其他平台尺寸。

### 组件实现边界

- 组件内部不得保存 phone、tablet、desktop 或 watch 的尺寸常量。
- 组件内部不得通过 `switch (deviceType)` 选择尺寸。
- 同一个默认尺寸只能在尺寸主题中存在一份；Demo、测试和组件实现不得复制为另一套默认来源。
- 组件只读取主题已经解析出的当前设备尺寸，并负责布局、绘制、状态、交互、动画和语义。
- 全局尺寸主题负责四端差异；局部主题和实例 Style 只覆盖当前解析结果。

## 五、系统级 `copyWith`

公共主题覆盖统一采用 Flutter 风格的 `copyWith`：

```dart
final base = HyperThemeData.light();

final custom = base.copyWith(
  colors: base.colors.copyWith(
    primary: const Color(0xFF6750A4),
  ),
  sizes: base.sizes.copyWith(
    desktop: base.sizes.desktop.copyWith(
      button: base.sizes.desktop.button.copyWith(
        minimumSize: const Size(52, 40),
      ),
    ),
  ),
  buttonTheme: base.buttonTheme.copyWith(
    filled: HyperButtonStyle(
      background: const HyperFill.color(Color(0xFF6750A4)),
    ),
  ),
);
```

不再建立面向使用者的 `Overrides`、字符串 Map、动态注册表或另一套补丁 API。内部解析可以使用 `merge`，但系统级自定义入口统一为 `copyWith`。

`null` 统一表示继续继承。需要清除属性时使用明确值，例如 `BorderSide.none` 或空阴影列表；不能让同一个 `null` 同时表示继承和删除。

## 六、全局、局部和实例覆盖

全局主题保存完整的多端尺寸和组件视觉主题。局部组件主题只作用于当前子树，不保存四套设备配置，也不重新判断设备：

```dart
HyperButtonTheme(
  data: HyperButtonThemeData(
    style: HyperButtonStyle(height: 44),
  ),
  child: child,
)
```

实例 Style 以调用方便为优先，可以同时覆盖尺寸和视觉：

```dart
HyperButton.filled(
  onPressed: submit,
  style: HyperButtonStyle(
    height: 48,
    background: const HyperFill.color(Colors.green),
  ),
  child: const Text('提交'),
)
```

以 Button 为例，固定解析顺序为：

```text
当前设备的 HyperButtonSize
→ 全局 HyperButtonThemeData 公共样式
→ 全局所选变体样式
→ 局部 HyperButtonTheme
→ 实例 HyperButtonStyle
```

## 七、强类型命名

统一采用以下命名职责：

- `HyperThemeData`：完整应用主题。
- `HyperSizeThemeData`：四端尺寸集合。
- `HyperSizeScheme`：某一设备的完整尺寸方案。
- `HyperXxxThemeData`：组件视觉、变体和状态主题。
- `HyperXxxStyle`：组件局部或实例覆盖值。
- `HyperXxxSize`：组件尺寸值对象。
- `HyperXxxTheme`：局部主题 Widget。

不得使用 `Map<String, dynamic>`、字符串键或万能组件样式代替明确类型。保留自动补全、编译期检查、重构能力和值语义。

## 八、组件实现规则

- 组件以 Flutter 原生 Widget 自由组合为优先；只有基础组件无法准确表达时才局部自绘。
- `HyperText` 等包装控件保持轻量，只负责语义样式、主题接入和参数转发，不承担额外布局或视觉偏移。
- 插槽对 `Text`、Hyper 控件和任意外部 Widget 使用相同约束，不通过 runtimeType 特判子控件。
- 异步状态、交互状态和内容变化默认保持组件外部尺寸稳定。
- 所有动画读取统一 Motion 主题并遵守 `MediaQuery.disableAnimations`。
- 所有必要的键盘、焦点、RTL、文字缩放和 Semantics 行为必须保留。

## 九、根因与责任边界

缺陷修复前必须确认真实来源。现象出现在某个组件中，不代表缺陷属于该组件；字体、子控件、父约束、主题、尺寸系统、状态或绘制问题应在各自责任层修复。

不得在表现问题的组件中持续增加固定偏移、Transform、类型特判、重复包装或兼容补丁。Demo 不承担修复职责，不得通过替换 child、手写 Padding 或页面专用参数绕过公共问题。修复完成后必须清理试探性代码和失效路径。

## 十、测试契约

主题测试至少覆盖：

- 手机、平板、桌面和手表的默认规格。
- `copyWith` 只改变目标字段，未修改字段保持不变。
- 设备解析选择正确的 `HyperSizeScheme`。
- 颜色变化不影响尺寸，尺寸变化不影响颜色。
- 全局、局部和实例覆盖的固定优先级。

组件测试优先验证最终 RenderBox 尺寸、几何位置、颜色、边框和交互状态，不只断言中间配置对象或包装层。Demo 负责展示默认、主题和实例覆盖效果，但不是组件细节测试的替代品。

## 十一、冻结决策

以下决策不因主题类或尺寸类逐渐增大而重新讨论：

1. 主题采用集中式强类型结构。
2. 主题和尺寸值对象统一提供 `copyWith`。
3. 所有设备尺寸集中管理，组件不持有设备尺寸。
4. 视觉主题、尺寸主题和排版主题相互独立。
5. 全局主题管理多端规格，局部主题只覆盖当前环境。
6. 组件只消费解析结果并实现自身行为。
7. 主题类随组件增加而变大是可接受且可预测的成本。
