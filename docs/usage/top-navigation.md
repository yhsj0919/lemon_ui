# 顶部导航

`HyperTopNavigation` 横向排列顶层入口，子项复用 `HyperMenu`，支持任意层级、描述、图标和禁用状态。所有层级的 id 必须唯一。父项展开菜单，叶项通过 `onSelected` 请求切换；应用保存 `selectedId` 并管理页面内容。选中的后代会使所属顶层入口显示选中样式。

```dart
HyperTopNavigation(
  selectedId: 'buttons',
  onSelected: (id) {},
  items: const [
    HyperMenuItem(id: 'all', label: '完整 Demo'),
    HyperMenuItem(
      id: 'components',
      label: '组件',
      children: [
        HyperMenuItem(
          id: 'buttons',
          label: '按钮',
          description: '操作按钮及其交互状态',
        ),
      ],
    ),
  ],
)
```

全局 `HyperThemeData.topNavigationTheme`、局部 `HyperTopNavigationTheme` 和实例 `HyperTopNavigationStyle` 逐字段合并。`itemStyle` 配置顶层按钮，`selectedItemStyle` 覆盖选中按钮，`menuStyle` 配置各级菜单。描述文字可设置 `descriptionStyle` 和 `descriptionGap`。菜单描述同样可直接用于 `HyperMenuItem`。

四端尺寸统一来自 `HyperSizeScheme.topNavigation`，菜单尺寸继续来自 `sizes.menu`。默认顶层尺寸由同端现有 Button 规格推导，菜单直接复用已有实现，属于项目语义推导（D 级，逻辑像素），尚未做官方视觉对照。空间不足时顶层横向滚动；外部背景、留白和内容区域由父布局管理。

展开箭头遵守 Motion 和减少动画设置；`transitionBuilder` 可替换浮层过渡。菜单复用已有键盘导航、浮层关闭规则及统一材质。

源码见 [组件](../../lib/src/components/top_navigation/hyper_top_navigation.dart)、[Style](../../lib/src/components/top_navigation/hyper_top_navigation_style.dart)；完整示例见 [Demo](../../example/lib/pages/framework/hyper_top_navigation_page.dart)。
