# 数字输入

`HyperNumberInput` 默认保留尾部上下箭头，通过 `layout` 切换前减后加：

```dart
HyperNumberInput(
  value: quantity,
  minimum: 0,
  maximum: 10,
  layout: HyperNumberInputLayout.leadingTrailing,
  onChanged: (value) => setState(() => quantity = value),
)
```

`trailingVertical` 为尾部上下箭头；`leadingTrailing` 为前端减号、尾端加号，随文字方向镜像。
前减后加通过 `HyperWidgetGroup` 连续组合三个区域；按钮默认使用方形悬停、按下反馈，
外侧圆角由控件组统一裁切。聚焦、错误和禁用边框显示在整组外侧，中间输入框不重复绘制表面。
状态配置与普通输入框复用同一解析器；输入框继续管理焦点、输入、错误提示和清空。
组合布局只向内部输入框传递实例显式覆盖及透明表面配置，基础主题不会作为实例样式
重复覆盖聚焦和禁用状态。尾部箭头布局由输入框自行解析状态背景与材质。
布局通过实例 `layout`、局部 `HyperNumberInputTheme`、全局 `numberInputTheme` 依次解析。
两版共用范围限制、精度、清空、失焦整理和上下方向键逻辑，禁用与只读时步进按钮不响应。
切换布局不替换文本控制器或输入框状态。

步进按钮外观依次合并默认规格、主题 `stepperStyle` 和实例 `stepperStyle`。
输入框仍由 `HyperTextFieldTheme` 和实例 `style` 配置。
前后按钮宽高读取当前输入框高度／最小高度，保持方形；图标读取 `iconSize`，颜色使用输入框图标色，
未覆盖时继承次要文字色。四端没有独立的组件尺寸常量。
以上是 D 级现有输入框操作区语义组合，逻辑像素，属于待用户确认的默认外观。

Demo 保留两版；编辑器的“按钮布局”按当前设备保存，恢复继承不会改写其他端配置。
