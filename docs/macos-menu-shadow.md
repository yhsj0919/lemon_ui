# macOS 27 菜单默认外阴影

`HyperMotion.lift` 仅复用主投影，不继承菜单轮廓层，避免在子卡片圆角外露出硬边。
上浮主题与实例的显式阴影列表仍完整保留。

用户于 2026-11-03 指定菜单默认阴影采用 macOS 27 官方参数，此项覆盖原有 HiUI 候选依据。

来源为 [Apple Design Resources](https://developer.apple.com/design/resources/)
链接的 [Apple macOS 27 UI Kit（Sketch）](https://www.sketch.com/s/57153a31-3379-4737-8ac6-dbfd6525f052)，
读取版本 `1DjRw4`，文档 ID `4065968f-6cac-4af5-91ca-05335903782e`。
数据来自 `document.json` 的共享图层样式：

- `Liquid Glass/Light/Menus`，ID `5AB88478-3FCE-48B6-B3F4-21B3C645B327`。
- `Liquid Glass/Dark/Menus`，ID `D1171326-FB5F-41CE-9E47-23F318F691F7`。

只读取启用且 `isInnerShadow == false` 的两层，混合模式均为 normal、图层不透明度均为 1。

| 外阴影 | 颜色 | alpha | offsetX | offsetY | blurRadius | spread |
| --- | --- | --- | --- | --- | --- | --- |
| 主投影（亮暗相同） | 黑色 | 0.30 | 0 | 4 | 24 | 0 |
| 浅色轮廓 | 黑色 | 0.20 | 0 | 0 | 0 | 0.5 |
| 深色轮廓 | 黑色 | 0.80 | 0 | 0 | 0 | 0.5 |

以上为官方设计文件坐标单位，以 1:1 映射至 Flutter 逻辑像素，颜色保持黑色，
不依赖主题 scrim 色。`blurRadius` 映射至 `BoxShadow.blurRadius`，
而非直接赋给 `MaskFilter` 的 sigma；不同渲染器的模糊核可能不同。
该映射是跨渲染器实现，不宣称与原生 AppKit 逐像素一致，未从截图物理像素反推参数。
轮廓的 0.5 为官方默认规格，编辑器的整数像素规则不要求改写主题原始值。

公共 `HyperOverlayMaterial` 提供同一配方，供 Menu/Select 等共用浮层、普通表面默认投影
及材质降级表面使用。显式全局/局部材质自带阴影、Card 主题阴影及实例阴影仍沿原有路径优先，
空列表仍表示关闭。此次仅采用外阴影，不复制官方玻璃内阴影、背景、圆角或其他系统尺寸。

高透毛玻璃通过 `usesDefaultShadows` 区分内置阴影与显式配方阴影。
未传 `boxShadow` 时，菜单公共表面使用上述语义默认；传入阴影（包括空列表）则保留配方。
编辑器未配置材质阴影时保留继承标记；历史配置中已保存的阴影仍按显式覆盖处理。
