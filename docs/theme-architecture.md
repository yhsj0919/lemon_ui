# Lemon UI 主题与尺寸架构

本文冻结 Lemon UI 的主题、设备适配和组件默认值架构。新增组件、主题重构、Demo 和测试均须遵守本文；主题类随组件增加而变大是集中式强类型设计系统的预期成本，不再作为拆散主题的理由。

默认视觉值的来源和缺少直接参考时的推导方法见 [HyperOS 风格设计基准](hyperos-design-baseline.md)。手机端参考 HyperOS；desktop 端尺寸和样式以小米 HIUI 为主要参考；平板和手表制定独立规格。第三方实现与项目暂定值不得标成官方规范。

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

`HyperTheme` 在作用域内统一为滚动控件增加鼠标拖动输入，并保留平台已有的
触摸、触控板、滚轮和滚动条策略。Demo 不再逐页重复配置鼠标拖动；需要不同
交互的子树仍可通过局部 `ScrollConfiguration` 覆盖。

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
- `typography`：当前端已解析的语义字号与列表行高；字体族、字重和其他文字样式由 `textTheme` 承载。
- `typographyTheme`：手机、平板、桌面和手表四套强类型字阶；当前端由 `HyperTheme` 解析到 `typography` 与 `textTheme`。组件布局尺寸不保存字号。
- `sizes`：手机、平板、桌面和手表的全部尺寸方案。
- `motion`：动画时长和曲线。
- `materialTheme`：统一表面材质配方、渲染质量和透明度策略。
- 各组件 `ThemeData`：组件视觉、变体和状态配方。

视觉、尺寸和排版相互独立。替换颜色不得改变尺寸，替换尺寸不得改变颜色；设备相关字号由统一排版主题解析，不得写在组件实现中。

### 统一材质契约

`HyperSurfaceMaterial` 是跨组件共用的完整配方。使用材质的控件按实例材质、
组件主题材质、`materialTheme.material` 的顺序选择来源，再由统一质量和减少透明度
策略解析。组件只绘制解析结果，不因引用位置改写背景、色调、模糊、边框、阴影或降级
配方；控件形状、内容布局和交互状态仍由各自组件负责。显式设置的组件背景可覆盖全局
材质背景。玻璃材质的滤镜只绘制背景，前景内容保持在独立的清晰图层。
内置 Hyper 主题默认采用 `advanced` 材质质量；应用可通过强类型
`materialTheme.copyWith(quality: HyperMaterialQuality.standard)` 切换到降级配方，
或设置 `reduceTransparency` 关闭透明与模糊。

`HyperAnchoredOverlay` 负责锚点定位、边缘避让、开合交互与进出场动画，不绘制表面。
`HyperTabBar` 与 `HyperTabBarView` 共用 Flutter `TabController`。默认 `.segmented` 形态共用浅灰底槽，选中项为白色块；`.separated` 形态的每个标签各自绘制圆角表面，标签之间保留间距，选中项为白色、未选中项为浅灰；`.underline` 形态采用普通下划线指示。三种形态在 Demo 中独立展示，共用当前端标签栏高度；手机端为 42dp。独立标签的 12dp 圆角和 9dp 间距参照 [MIUIX `TabRow` 候选值](https://compose-miuix-ui.github.io/miuix/components/tabrow)，底槽圆角暂取 8dp；下划线粗细沿用 Flutter 的 2dp 基准。四端尺寸由 `HyperSizeScheme.tabBar` 分别管理，字号读取 `typography.control`。悬停与按压不叠加深色覆盖层，点击不产生水波纹；选中块或指示线的切换作为状态反馈。
菜单、提示等消费者通过自己的主题选择视觉和材质，不能由浮层底座改写材质配方。
内置菜单、侧栏子菜单和 Tooltip 的浮层表面默认使用统一的高级玻璃材质配方；
实例或组件主题的完整材质、全局 `materialTheme.material` 以及显式背景优先于此默认配方。
材质质量与减少透明度策略仍由 `HyperMaterialThemeData.resolveMaterial` 统一处理。
最简单的使用方式是传入 `anchor` 与 `overlayBuilder`；默认点击锚点开合，
`overlayBuilder` 获得关闭回调。侧栏子菜单可指定 `trigger: HyperOverlayTrigger.hover`
与 `placement: HyperOverlayPlacement.sideEnd`。需要由父级统一管理多个菜单时，
传入 `isOpen` 和 `onOpenChanged`；外部点击、Escape 和返回键仍走同一关闭请求。
基础浮层直接使用最近的 Flutter `Overlay`，页面无需额外安装宿主。
需要把已有按钮或其他自带点击行为的控件作为锚点时，使用
`HyperAnchoredOverlay.builder(anchorBuilder: (context, toggle, isOpen) => ..., overlayBuilder: ...)`；
锚点调用 `toggle`，内容仍可自由组合列表、网格、卡片或其他 Widget。
`placement` 提供 `topStart`、`bottomStart`/`bottomEnd`、`sideStart`/`sideEnd`；
`spacing` 默认取当前端 `HyperSizeScheme.overlaySpacing`，目前为 4 逻辑像素，使用方可以覆盖；
空间不足时自动翻转并限制在可见区域，不要求内容使用特定表面组件。
默认进出场使用淡入缩放，也可选 `HyperOverlayTransition.fade`；内置过渡的时长和曲线读取
全局 `motion.fastDuration`、`motion.fastCurve`，并遵守 `MediaQuery.disableAnimations`。
需要完全不同的效果时传入 `transitionBuilder(context, animation, child)` 替换内置过渡；
动画进度为 0 至 1，使用端可自行选择曲线，底座仍负责开合时长和浮层生命周期。
关闭请求立即停止浮层交互，退场动画结束后再从 `Overlay` 移除。

`HyperSidebar` 的分组、树形项、角标和自定义行通过 `HyperSidebarGroup`、
`HyperSidebarItem` 组合。展开项的标题与可选描述复用 `HyperListTile` 的文字规格。
选中 ID 由页面传入，展开 ID 可由组件管理或由页面受控管理；
父级是否跟随子项选中由 `selectParentWhenChildSelected` 控制，默认关闭。折叠时有子项的菜单行
使用 `HyperAnchoredOverlay` 显示悬停子菜单，浮层的表面和阴影由其中的 `HyperCard`
及其主题控制。普通卡片表面由侧栏提供默认浮层阴影；全局材质或 Card 主题显式提供
阴影时沿用原配方，侧栏主题可通过 `popupCardStyle` 覆盖。头尾保持固定，中间列表独立滚动；宽度和行规格来自四端
`HyperSidebarSize`，视觉与选中样式按全局、局部、实例 `HyperSidebarStyle` 解析。
侧栏宽度与内容淡隐切换使用全局标准动画节奏，树形子项的展开收起与箭头旋转使用全局快速节奏；
两者都遵守系统减少动画设置。`HyperSidebarStyle` 提供 `widthTransitionBuilder`、
`contentTransitionBuilder` 和 `childrenTransitionBuilder`，可由全局、局部主题或实例逐项替换
默认过渡。宽度 builder 接收当前宽度并负责约束侧栏内容；内容 builder 接收 0 至 1 的
可见度；子项 builder 接收 0 至 1 的开合动画，并负责内容出现、消失时的布局过渡。
折叠态浮窗的进出场可通过 `popupTransitionBuilder` 替换，仍由 `HyperAnchoredOverlay`
管理开合与浮层生命周期。

`HyperMenu` 负责弹出菜单的分组、多级操作项、选中与禁用状态。子项通过
`HyperMenuItem.children` 声明，父项悬停或点击展开子菜单；鼠标经过更深层级时
保持已展开的祖先菜单，切换同级项目或点击菜单外才收起对应层级。
方向键上下移动时同步移动真实焦点，右键进入子菜单、左键返回父项并恢复焦点；
Tab 遵循可用菜单项的焦点遍历，Home、End、Enter 和空格键作用于当前层。子菜单的定位、边缘翻转与开合
继续由 `HyperAnchoredOverlay` 负责，过渡可通过 `submenuTransitionBuilder` 替换。
纯鼠标悬停展开子菜单时不抢夺键盘焦点；已展开后改用方向键仍可进入该层。
菜单表面由 `HyperCard` 绘制，完整材质及显式阴影遵守 Card 与全局材质配方；普通表面提供默认
浮层阴影。菜单外框与菜单项圆角分别由四端 `HyperMenuSize.surfaceRadius` 和
`itemRadius` 管理，不随按钮圆角联动。其余菜单尺寸同样来自四端 `HyperMenuSize`，全局 `menuTheme`、局部
`HyperMenuTheme` 与实例 `HyperMenuStyle` 逐项覆盖。菜单项文字取当前端统一字阶，
不另存设备字号。

`HyperMenuButton` 组合 Hyper 按钮、锚定浮层和菜单，统一处理按钮开合与选择后关闭。
`HyperContextMenu` 包裹任意内容，右键或触摸长按时将指针或触点在目标内的局部坐标交给
`HyperAnchoredOverlay.anchorPosition` 定位；菜单键或 Shift+F10 则从目标下方打开。
这些入口共用 `HyperMenu` 的分组、多级项、主题样式和键盘导航。点击菜单外或按
Escape 关闭，子菜单仍共享同一点击区域。

`HyperTooltip` 复用锚定浮层的定位、边缘避让和 Motion 动画，表面由 `HyperCard`
绘制并参与统一材质解析。鼠标悬停延迟显示，键盘焦点进入或触摸长按立即显示；
长按松开后按 `showDuration` 延迟收起。内容只提供说明，不接收点击。可通过 `placement`、
`waitDuration`、`exitDuration` 和 `transitionBuilder` 调整行为与过渡。

`HyperDropdownMenu<T>` 是受控单选入口：调用方传入 `value` 和 `onChanged`，
禁用选项不可触发选择。锚点复用 `HyperButton` 的尺寸与样式，弹出的选项复用
`HyperMenu` 的焦点导航、主题和浮层材质；方向键可从锚点打开，选择或按 Escape
关闭后将焦点返回按钮自身。`HyperButton.focusNode` 支持这种组合场景，节点由调用方释放。
锚点宽度、箭头尺寸和间距来自四端 `HyperDropdownMenuSize`；前景、箭头和选中底色
由全局 `dropdownMenuTheme`、局部 `HyperDropdownMenuTheme` 与实例
`HyperDropdownMenuStyle` 逐层覆盖。显式 `buttonStyle` 和 `menuStyle` 最后覆盖各自底层控件。

`HyperPopupListTile<T>` 将 `HyperListTile` 与锚定模态选项列表组合。整行显示
当前值和上下双箭头，打开时使用语义遮罩；弹窗以尾部上下箭头图标为锚点，并在上下空间不足时翻转、限制在安全区域。弹窗复用 `HyperMenu` 的焦点、禁用和选中
状态。弹窗选项行高默认取当前端 `HyperListTileSize.minHeight`，紧凑行取
`compactMinHeight`，`menuStyle.itemHeight` 可显式覆盖。宽度按选项文字和图标测量，
由四端 `HyperPopupListTileSize` 限制最小和最大值，实例可覆盖边界或指定固定宽度。
弹窗表面内边距与选项文字内边距独立；选项左右内边距由四端 `HyperPopupListTileSize.itemHorizontalPadding` 管理，默认均为 16 逻辑像素，可通过 `menuStyle.padding` 显式覆盖。默认选中和悬停背景铺满整行，外框负责裁剪圆角。
默认过渡从靠近列表项的弹窗角开始缩放、淡入并按打开方向逐步揭示，退场反向收起；
缩放取全局 Motion 弹簧，时长与淡入曲线取全局 Motion，减少动画时直接显示。
`transitionBuilder` 可替换默认过渡。选择后关闭并将焦点返回列表项。

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
├─ appBar: HyperAppBarSize
├─ drawer: HyperDrawerSize
├─ sidebar: HyperSidebarSize
├─ menu: HyperMenuSize
├─ dropdownMenu: HyperDropdownMenuSize
├─ button: HyperButtonSize
├─ iconButton: HyperIconButtonSize
├─ progressIndicator: HyperProgressIndicatorSize
├─ switchSize: HyperSwitchSize
├─ checkbox: HyperCheckboxSize
├─ radio: HyperRadioSize
└─ 后续组件尺寸
```

组件尺寸值对象必须不可变，并实现 `copyWith`、值相等和需要时的 `lerp`。设备规格使用明确值，不通过手机尺寸乘倍率生成其他平台尺寸。

确定组件默认值时，先查 Flutter 的约束与交互标准，再按[设计基准](hyperos-design-baseline.md)
核实适用的 HyperOS 官方资料、目标设备和第三方 MIUIX 候选值，最后按 Lemon UI
的主题职责选值。截图用于检查最终视觉关系；设备逻辑尺寸、显示缩放或像素密度
未确认时，不从截图物理像素差推算组件的 dp 或字号。参考来源与最终取值不同时，
在尺寸规格中记录原因。

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

组件行为和公开接口稳定后，应主动把需要跨页面统一调整的可配置项收归强类型主题模板：
设备尺寸写入四端 `HyperSizeScheme`，视觉与排版写入对应组件 `ThemeData`；局部主题和
实例 `Style` 只覆盖显式提供的字段。新增配置时同步维护 `copyWith`、插值、值相等、
Demo 和主题覆盖测试。父布局能直接控制的外边距等组合属性不因“可配置”而重复加入
组件主题。

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
