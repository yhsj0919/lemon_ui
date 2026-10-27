# 锚定面板

`HyperPopover` 提供锚点与内容之间的交互和默认浮层表面；`HyperAnchoredOverlay`
保留为无表面的定位、开合基础设施，Menu、Select 等已有组件继续自行解析表面。

使用 `HyperPopover.builder(anchorBuilder: ..., contentBuilder: ...)` 将 toggle 交给按钮，
或传入 `anchor`，使用默认点击与可选 hover 触发。`isOpen` / `onOpenChanged` 支持受控模式，
内容回调获得 close。支持方向、间距、锚点坐标和可替换过渡。

```dart
HyperPopover.builder(
  anchorBuilder: (context, toggle, isOpen) => HyperButton.tonal(
    onPressed: toggle,
    label: const Text('打开面板'),
  ),
  contentBuilder: (context, close) => HyperButton.text(
    onPressed: close,
    label: const Text('完成'),
  ),
)
```

全局 `popoverTheme`、局部 `HyperPopoverTheme`、实例 `HyperPopoverStyle` 按显式字段合并。

需要结果时可使用泛型和统一关闭入口，`HyperAnchoredOverlay<T>` 同样支持：

```dart
HyperPopover<String>(
  anchor: const Text('打开'),
  onResult: (result) => debugPrint('结果：$result'),
  contentBuilder: (context, close) => HyperButton.text(
    onPressed: () => HyperOverlay.close<String>(context, '确认'),
    label: const Text('确认并关闭'),
  ),
)
```

onResult 在浮层发起关闭时通知，不等待退场动画；外部点击、Escape 或旧 close 回调
产生 null。受控模式仍由 onOpenChanged 更新 isOpen，close 返回 true 表示已发出请求，
不表示父组件已接受。父组件直接改 isOpen 不触发结果通知；内容退场动画保持不变。
`surfaceStyle` 复用 `HyperCardStyle` 的背景、材质、内边距、圆角、边框、阴影及约束。
空阴影列表显式关闭阴影；实色材质可替换玻璃。材质质量和减少透明度由统一材质主题决定。

默认表面通过 `resolveHyperMenuSurface` 解析，沿用公共浮层玻璃与阴影配方。
四端圆角和内边距分别读取解析后的 `sizes.menu.surfaceRadius`、`sizes.menu.padding`，
锚点间距读取 `sizes.overlaySpacing`；没有新增跨端倍率或组件内部设备常量。
来源为 D 级项目现有同端菜单/浮层语义组合，单位为逻辑像素，未新增官方视觉规格。
用户于 2026-10-27 明确确认转为正式，Demo 与编辑器归入“交互基础”，页面 ID 保持 `hyper-popover`。

内置过渡复用安全材质淡入及全局 Motion，遵守减少动画。自定义过渡应复用
`HyperBackdropSafeFade`，不能直接把高级模糊包在分数透明度 FadeTransition 中。
内容布局由调用方管理，文字继续跟随系统 TextScaler。
