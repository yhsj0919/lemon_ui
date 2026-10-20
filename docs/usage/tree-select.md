# 树形选择

`HyperTreeSelect<T>` 是受控的树节点单选控件。它复用 `HyperDropdown` 的锚定面板和
设备呈现，树行复用 `HyperTreeView` 的键盘导航、加载状态与重试。桌面端在锚点旁打开
面板，手机和平板使用底部弹窗，手表使用全屏呈现。

展开箭头与行选择分开：点击箭头浏览子节点，点击可选节点提交并关闭。设置 `leafOnly`
后，分支节点只负责展开，只有叶节点可以提交。关闭面板不会改变受控值；`allowClear`
在面板底部提供清空操作，手机标题行也显示清空入口。

```dart
final nodes = <HyperTreeSelectNode<String>>[
  HyperTreeSelectNode(
    value: 'design',
    label: '设计部',
    children: const [
      HyperTreeSelectNode(value: 'product', label: '产品设计组'),
    ],
  ),
];

HyperTreeSelect<String>(
  nodes: nodes,
  value: selectedTeam,
  leafOnly: true,
  onChanged: (value) => setState(() => selectedTeam = value),
)
```

每个节点提供稳定且全树唯一的 `value` 和显示 `label`。分支可以直接包含静态
`children`，也可以使用 `hasChildren: true` 延迟加载。提供 `loadChildren` 后，展开时
加载子节点；加载失败会在树中显示重试按钮。替换节点或加载器会丢弃旧缓存及过期请求。
没有加载器的延迟分支会呈现错误与重试状态，并保持原值不变。

```dart
HyperTreeSelectNode(
  value: 'engineering',
  label: '研发部',
  hasChildren: true,
)
```

当选择的远程值尚未出现在已加载节点中时，触发器使用 `labelBuilder` 显示文字；未提供
时显示该值的字符串形式。禁用节点不能展开或选择，`selectable: false` 可单独禁止节点
选择而保留分支展开。

## Form 适配

`HyperTreeSelectFormField<T>` 的值是单个 `T?`，可直接使用必填校验、异步校验、重置、
禁用和提交收集。清空时值为 `null`。

```dart
HyperTreeSelectFormField<String>(
  name: 'team',
  label: '团队',
  requiredIndicator: true,
  nodes: nodes,
  leafOnly: true,
  validator: (value) => value == null ? '请选择团队' : null,
)
```

## 主题与视觉来源

全局使用 `HyperThemeData.treeSelectTheme`，子树使用 `HyperTreeSelectTheme`，实例使用
`HyperTreeSelectStyle`。触发器几何继承 Select，节点尺寸与树行继承 TreeView，清空按钮
继承 Button，浮层表面沿用下拉选择器的公共表面解析与材质配置。默认值是 D 级既有
选择器、树和按钮语义规格的组合；尚未取得同代 HyperOS/HIUI 树形选择器的直接尺寸，
默认外观仍待用户确认。

详细 Demo 位于 Gallery 的“未确认”分类，包含单选、仅叶节点、异步失败重试、Form、
禁用项、局部主题和实例表面覆盖。
