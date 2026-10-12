# 颜色选择器

`HyperColorPicker` 是受控控件：将 `onChanged` 的颜色写入状态后重建。

```dart
HyperColorPicker(
  value: const Color(0xFF3482FF),
  onChanged: (color) {},
)
```

圆形色盘的角度控制色相，距圆心的距离控制饱和度；右侧竖向滑块控制明度，下方横向滑块控制不透明度。明度轨道从黑色渐变到当前色相与饱和度的最亮颜色，透明度轨道在棋盘格上从透明渐变到不透明，无独立颜色预览块。明度变化同步显示在色盘上，支持完整 RGB 颜色范围。颜色区域支持方向键调整。`onChanged: null` 禁用编辑，`showAlpha: false` 隐藏透明度滑块并保留原有透明度。

HEX 输入支持 `#RRGGBB` 和 `#AARRGGBB`，八位输入完成后应用，六位输入按回车应用。透明度位在最前面；`HyperColorPicker.parseHex` 可单独解析色值。

中心默认有半径 12% 的无彩色区，明度最大时可直接选到纯白；半径 90% 以外为纯色区。色相接近六个标准色 3° 内会吸附，明度与透明度接近端点 2% 内会吸附到端点。快捷色点提供黑、白及六个标准纯色，并保留当前透明度。

`centerRadiusFraction`、`pureColorRadiusFraction`、`hueSnapDegrees`、`endpointSnapThreshold` 可通过 Style 或主题调整。将前两项设为 0、1 恢复连续饱和度；将吸附阈值设为 0 关闭吸附。

弹窗使用 `showHyperColorPickerDialog(context: context, initialColor: color)`，确认返回 `Color`，取消或关闭返回 `null`。弹窗草稿不直接改变外部颜色。可通过 `pickerStyle` 和 `dialogStyle` 分别覆盖选色器与弹窗，默认复用两者的全局及局部主题，导航范围遵循 `HyperNavigatorScope`。`HyperColorPickerDialog` 可用于自定义路由。

表单使用 `HyperColorPickerField(value: color, onChanged: ...)`，显示色块与 ARGB 色值。点击展开锚定浮层，选色立即更新；点击外部或 Esc 关闭。浮层跟随字段位置，空间不足时自动翻转或限制在安全区域内。`onChanged: null` 或 `enabled: false` 禁用字段。`buttonStyle`、`panelStyle`、`pickerStyle` 分别覆盖字段按钮、浮层卡片与取色器，其默认尺寸及视觉直接复用对应 Hyper 主题。

表单浮层与 Menu/Select 共用表面解析，继承 `menuTheme.style.surfaceStyle` 的阴影及材质，未显式配置时使用统一浮层配方；`panelStyle` 最后覆盖。材质质量与降级沿用统一材质主题。

四端规格使用 `HyperSizeScheme.colorPicker`。全局外观使用 `HyperThemeData.colorPickerTheme`，局部使用 `HyperColorPickerTheme`，实例使用 `HyperColorPickerStyle`。可调整宽度、颜色区域高度、圆角、间距、选择标记、边框、预览高度，以及滑块和输入框样式。

父级管理外部留白和滚动。Demo 和主题编辑器入口位于“选择控件”分类。

当前默认尺寸从同端已有菜单、按钮及图标语义规格推导（来源级别 D），尚未完成官方颜色选择器规格及截图对照验证。
# 设备呈现

`HyperColorPickerField.presentation` 默认是 `HyperSelectPresentation.adaptive`：电脑端跟随浮层，手机和平板底部弹窗，手表独立全屏页面。可以显式传入 `anchored`、`trailing`、`bottomSheet` 或 `fullScreen`，与设备默认值无关。跟随浮层实时调用 `onChanged`；模态面板先修改临时颜色，确定提交，取消或返回不提交。字段宽度和箭头规格继承下拉选择器主题，实例 `buttonStyle` 可以覆盖；`panelStyle` 调整跟随浮层表面，模态表面继承 BottomSheet / AppBar 主题。

