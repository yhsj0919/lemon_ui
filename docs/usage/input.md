# 文本输入

[返回目录](README.md)

## HyperTextField 基本输入

~~~dart
HyperTextField(
  label: '名称',
  hintText: '输入名称',
  initialValue: 'Lemon',
  showClearButton: true,
  onChanged: (value) {
    // 更新业务状态；使用 controller 时也能直接读取最新值。
  },
)
~~~

controller 和 initialValue 互斥。initialValue 只在内部控制器首次建立时使用，
后续要修改文本请使用 TextEditingController；不要每次 build 新建 controller。

由应用传入的 controller / focusNode 由应用 dispose；未传入时组件负责创建和释放。
切换外部 controller 回内部时保留原文本和选择区；更换为另一个外部 controller 时
以新的 controller 为准。程序调用 controller.text / value 不自动触发 onChanged，
清空按钮会主动调用 onChanged('')。

enabled: false 禁用输入与尾部操作；readOnly: true 允许选择复制但不编辑，
清空操作隐藏，密码查看可保留。leading/trailing 为自定义内容，应用负责其自身业务行为。
键盘与编辑行为通过 keyboardType、textInputAction、onSubmitted、onEditingComplete、
inputFormatters、autofillHints、textCapitalization、textDirection 配置。

## 尾部错误提示：不增加辅助文字行

~~~dart
HyperTextField(
  label: '邮箱',
  hintText: 'name@example.com',
  keyboardType: TextInputType.emailAddress,
  errorText: '邮箱格式不正确，请检查地址',
  leading: const Icon(Icons.mail_outline),
  showClearButton: true,
)
~~~

errorText 为非空文字时显示尾部错误图标，边框和光标进入错误状态。
组件不把错误传给 InputDecoration.errorText，也不在输入框下方绘制错误文字，
因此默认错误状态不引入新的行高。错误详情只显示在锚定浮层中。

- 默认 reserveErrorSpace: false，无错误时不占用错误图标位置；错误出现才占用尾部宽度。
- 设置 true 可预留尾部位置，避免错误出现时改变文本可用宽度；两种模式都不添加下方行。
- 鼠标悬停、点击图标、键盘 Enter/Space 可展开提示，点击外部或 Escape 关闭。
- 错误消失/替换会关闭详情，清空与密码按钮有独立区域。
- 屏幕阅读器可读到错误文本与 invalid 验证语义。
- errorBuilder(context, errorText) 可完全替换浮层内容。
- 校验由应用负责；本组件不是 FormField，不直接调用 FormState.validate。

大字号、多行输入、额外 label、自定义尾部内容，以及显式配置不同状态尺寸，
仍可改变自身布局高度；“保持高度”指默认错误出现/消失不插入辅助文字行，
不强行压缩系统无障碍字阶。当前未做设备渲染对照。

## 密码、清空与计数

~~~dart
HyperTextField(
  label: '密码',
  obscureText: true,
  showPasswordToggle: true,
  showClearButton: true,
  maxLength: 32,
  showCounter: true,
  autofillHints: const [AutofillHints.newPassword],
)
~~~

obscureText 仅允许 maxLines: 1；默认显示查看按钮，showPasswordToggle: false 关闭。
密码模式关闭拼写纠正与输入建议。计数显示在尾部，遵循扩展字素簇（emoji 不按字节数计）。
maxLength 限制由原生 TextField 执行，maxLengthEnforcement 可控制输入法组合期间的处理。
底部默认计数被关闭，不因字数或错误额外添加行；showCounter 需要同时设置 maxLength。

## 多行与自定义主题

~~~dart
HyperTextFieldTheme(
  data: const HyperTextFieldThemeData(
    focused: HyperTextFieldStyle(borderColor: Colors.teal),
    error: HyperTextFieldStyle(
      borderColor: Colors.deepOrange,
      errorIconColor: Colors.deepOrange,
    ),
  ),
  child: const HyperTextField(
    label: '备注',
    minLines: 3,
    maxLines: 5,
    hintText: '输入备注',
    style: HyperTextFieldStyle(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      errorIcon: Icons.info_outline,
    ),
  ),
)
~~~

minLines / maxLines 遵守 Flutter 约束；maxLines: null 可随内容增长，需要合适父布局。
全局 textFieldTheme、局部 HyperTextFieldTheme、实例 HyperTextFieldStyle 逐字段覆盖。
主题按普通、hovered、focused、error、disabled 叠加，实例最后覆盖。

Style 可配置背景 HyperFill、材质、边框、阴影、圆角、期望高度、最小高度、内边距、字体、图标、
按钮宽度、光标和计数样式。foregroundColor 决定编辑文字颜色；
material 非空时采用其背景配方，否则使用 background 填充。

单行默认垂直居中，多行默认顶部对齐；textAlignVertical 可显式覆盖。
内边距由 Hyper 主题直接控制，不叠加 Material 的紧凑密度压缩。
尾部按钮自身的图标留白计入内容内边距，避免重复增加到边框的距离。

errorIcon / errorIconColor、errorTextStyle、errorMaxWidth、errorPlacement、
errorPopupStyle 分别配置提示图标与浮层；errorPopupStyle 复用 HyperCardStyle。
错误出现/消失时，尾部宽度平滑展开/收起，图标轻微缩放并淡入淡出，保持高度。
duration/curve 配置表面、尾部宽度和图标过渡，transitionBuilder 替换图标切换，
errorTransitionBuilder 替换浮层入场；遵守系统减少动画。
四端尺寸位于 HyperSizeScheme.textField。

## 高度、圆角和边框

~~~dart
const HyperTextField(
  hintText: '输入内容',
  style: HyperTextFieldStyle(
    height: 28,
    borderRadius: BorderRadius.all(Radius.circular(4)),
    borderColor: Colors.teal,
    borderWidth: 1,
  ),
)
~~~

height 是输入框表面的期望高度，不包含上方 label。降低高度时先减少上下内边距，
保留字号、行高和系统文字缩放；文字、图标或多行内容放不下时，实际高度会自然撑高。
不设置 height 时，继续使用主题 minimumHeight 和 padding。自定义前后缀也可能撑高输入框。

[组件源码](../../lib/src/components/text_field/hyper_text_field.dart) ·
[Style](../../lib/src/components/text_field/hyper_text_field_style.dart) ·
[ThemeData](../../lib/src/components/text_field/hyper_text_field_theme.dart) ·
[交互与校验 Demo](../../example/lib/pages/selection/hyper_text_field_page.dart)。
