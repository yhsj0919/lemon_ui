# 高透毛玻璃

`HyperSurfaceMaterial.clearFrostedGlass()` 是统一材质系统的内置可选配方。
配方来自项目内彩色、白色背景的视觉确认；属于项目设计值，并非 HyperOS / HIUI 官方规格。

```dart
HyperMaterialSurface(
  material: const HyperSurfaceMaterial.clearFrostedGlass(edgeEnabled: true),
  padding: const EdgeInsets.all(24),
  child: const Text('高透毛玻璃'),
)
```

质量和减少透明度由 `HyperMaterialTheme` 统一管理。高级质量使用 15 的背景模糊、
低透明度渐变填充、单线方向高光和外侧阴影；普通质量或减少透明度使用不透明 fallback。
未更改全局原有默认配方，主题编辑器的“背景材质 → 配方”可选择此材质。

可通过构造参数或 `copyWith` 覆盖背景、模糊、染色、边框、高光渐变、阴影及 fallback。
`edgeEnabled` 为 null 时按用途默认：普通控件关闭，Dialog / BottomSheet / Menu / Select 浮层开启。
`edgeEnabled: true` 主动开启，`false` 关闭；全局与单控件编辑器均提供“高光描边”选择。
`edgeGradient: null` 也可关闭高光；`boxShadow: []` 关闭阴影；实例显式 `border` 优先于材质高光。
`outsideShadow` 控制是否裁去表面内部的阴影。完全透明需要同时关闭填充、模糊、高光和阴影，
且仅在允许透明度的高级质量下生效。

毛玻璃、柔光玻璃和高透毛玻璃可共用方向高光。普通填充与半透明填充不添加。
公共表面、Card、Button 和 IconButton 使用同一高光绘制路径；Menu / Select 浮层通过
公共 Card 表面继承。组件或配方已有边框时，仅使用该边框；显式空边框也关闭高光。
聚焦、错误等状态边框因此不会再叠加材质高光。

Demo id 保持 `hyper-clear-glass`，位于正式表面分类，包含彩色与白色滚动背景和配方调节。
本次集成未构建或运行截图对照；公共绘制路径的最终效果仍需运行检查。

## 控件独立选择

无需设置全局配方，卡片可直接指定：

```dart
HyperCard(
  style: HyperCardStyle(
    material: const HyperSurfaceMaterial.clearFrostedGlass(),
  ),
  child: const Text('独立高透毛玻璃'),
)
```

卡片、容器、控件组和折叠面板工作区均可单独选择配方并保存导入。
显式选择使用该配方的默认值，不从全局同名配方复制覆盖；恢复继承后才跟随组件默认。
容器使用 `material` 参数，控件组使用 `HyperWidgetGroupStyle.material`。
材质质量与减少透明度继续统一解析，需要局部质量时使用 `HyperMaterialTheme`。
中性容器和控件组未选择配方时保持原有默认外观。
