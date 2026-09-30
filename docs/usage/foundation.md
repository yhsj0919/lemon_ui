# 交互与材质基础设施

[返回目录](README.md)

这些是用于组合新组件的公开基础设施；普通业务优先使用现成按钮、菜单、滑块。

## HyperAnchoredOverlay 锚定浮层

~~~dart
HyperAnchoredOverlay(
  anchor: const Text('点击展开'),
  overlayBuilder: (context, close) => HyperCard(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: HyperButton.ghost(label: const Text('关闭'), onPressed: close),
    ),
  ),
  placement: HyperOverlayPlacement.bottomStart,
)
~~~

anchor 是真实锚点，浮层随锚点变化定位；trigger 选择 tap/hover/manual。
placement 支持 bottomStart/bottomEnd/topStart/sideStart/sideEnd，
空间不足时翻转并限制在安全区域。spacing 控制与锚点间隔。
isOpen/onOpenChanged 是受控开合接口，未提供 isOpen 时由组件管理。
overlayBuilder 提供 close；浮层不默认决定表面材质，使用 Card/MaterialSurface 组合。

自带点击行为的按钮应使用 .builder，避免重复触发：

~~~dart
HyperAnchoredOverlay.builder(
  anchorBuilder: (context, toggle, isOpen) => HyperButton.tonal(
    label: Text(isOpen ? '收起' : '展开'),
    onPressed: toggle,
  ),
  overlayBuilder: (context, close) => HyperCard(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: HyperButton.text(label: const Text('完成'), onPressed: close),
    ),
  ),
)
~~~

transition 选择 fadeScale/fade，transitionBuilder 可替换入场效果，
参数为 context、Animation<double>、child。anchorPosition 可细化锚点位置。
不要把浮层测量与业务定位拆成多个重复 OverlayEntry。
[源码](../../lib/src/components/overlay/hyper_anchored_overlay.dart)。

## HyperPressable 自定义可交互内容

~~~dart
HyperPressable(
  onTap: () {},
  semanticLabel: '自定义操作',
  builder: (context, states, child) => Container(
    padding: const EdgeInsets.all(12),
    color: states.contains(HyperControlState.pressed)
      ? Colors.grey.shade300 : Colors.grey.shade100,
    child: child,
  ),
  child: const Text('操作'),
)
~~~

builder 收到当前 hovered/focused/pressed/disabled 等状态。
支持点击、双击、长按、右键、拖动、鼠标进入/离开和焦点回调；
使用 states 提供外部状态，onStatesChanged 监听变化。
enabled 禁用；focusNode/autofocus、mouseCursor、behavior、semanticLabel 配置交互。
它负责输入和状态，不自动绘制背景、状态层或水波纹；可在 builder 内用动画组件过渡。
[源码](../../lib/src/interaction/hyper_pressable.dart)。

## HyperElasticOverscrollRegion 越界反馈

~~~dart
HyperElasticOverscrollRegion(
  axis: Axis.horizontal,
  maxExtent: 12,
  resistance: 10,
  child: HyperSlider(value: .5, onChanged: (value) {}),
)
~~~

包住拖动控件即可添加越界阻尼；不改变子组件业务值，也不接管其正常手势。
maxExtent 是最大位移（逻辑像素），resistance 越大越难拉动；
maxScale 默认 1，不拉伸轨道。spring 控制松手归位弹簧。
enabled 控制开关，transformHitTests 决定位移是否作用于命中坐标。
不要对已内置越界反馈的组件重复包 Region。

手动集成时使用 HyperElasticOverscrollController 与 HyperElasticOverscrollTransform：

1. 在 State 中以 vsync 创建 controller（State 使用 TickerProviderStateMixin）。
2. onPanUpdate 计算有符号越界距离，起点外为负、终点外为正；
   调用 controller.pull(overshoot, maxExtent: ..., resistance: ...)。
3. 松手调用 release(spring: ...)，减少动画时传 disabled: true。
4. Transform 传 controller、axis、maxExtent、child，只负责可见变换。
5. State.dispose 中 dispose controller；业务进度仍自行 clamp 到合法范围。

具体 pull 签名以源码为准，不要用位移反向写入进度值。
[源码](../../lib/src/motion/hyper_elastic_overscroll.dart)。

## HyperMaterialSurface 材质表面

~~~dart
HyperMaterialSurface(
  material: const HyperSurfaceMaterial.frostedGlass(
    blurSigmaX: 16,
    blurSigmaY: 16,
    tint: Color(0x44FFFFFF),
  ),
  borderRadius: BorderRadius.circular(16),
  clipBehavior: Clip.antiAlias,
  padding: const EdgeInsets.all(16),
  child: const Text('磨砂表面'),
)
~~~

material 使用 HyperSurfaceMaterial.solid/translucent/frostedGlass 等配方；
纯色/渐变填充使用 HyperFill。quality、reduceTransparency 可显式覆盖材质质量与降级。
模糊需要背后有实际内容，纯背景下不会凭空产生纹理；避免在长列表中滥用高成本模糊。
全局 materialTheme、局部 HyperMaterialTheme 管理配方解析。
width/height/padding/margin/alignment 属于当前表面布局参数。
[表面源码](../../lib/src/components/surface/hyper_material_surface.dart) ·
[材质配方](../../lib/src/foundation/hyper_surface_material.dart)。

## 状态、反色与动效词汇

- HyperControlState / HyperStateValue：以强类型状态集合解析配置，避免字符串状态表。
- HyperContrastTheme / HyperContrastMode：配置受支持组件的前景反色策略，
  不会自动改写任意子 Widget 中写死的颜色。
- HyperMotionThemeData / HyperMotionTheme：全局或局部过渡节奏与弹簧；
  自定义动效同样需要遵守 MediaQuery.disableAnimations。
- HyperFill.none/color/gradient：强类型背景填充，none 表示明确关闭填充。
- 所有公开基础类型与主题入口见 [lib/lemon_ui.dart](../../lib/lemon_ui.dart)。