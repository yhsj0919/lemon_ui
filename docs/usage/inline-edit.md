# 行内编辑

`HyperInlineEdit<T>` 在展示值和编辑器之间切换，负责草稿、校验、保存与取消。默认双击、长按或聚焦后按 Enter / Space / F2 开始；Escape 取消，保存中禁止重复提交和取消。单行文本 Enter 提交，多行 Enter 换行，输入法组合输入期间不提交。

```dart
HyperInlineEdit.text(
  value: name,
  validator: (value) => value.trim().isEmpty ? '名称不能为空' : null,
  onSaved: (value) async {
    await repository.saveName(value);
    if (mounted) setState(() => name = value);
  },
)
```

`multiline: true` 使用可增长的多行输入。`activation: HyperInlineEditActivation.tap` 改为单击激活。默认展示态最小高度继承当前端文本输入框，内容可因文字缩放增高；外部宽度由父布局管理。展示态默认手形光标，可通过 `HyperInlineEditStyle.mouseCursor` 改为文本光标等；禁用时使用普通箭头。`showActions: false` 隐藏保存/取消按钮，使用失焦、区域外点击和键盘完成编辑；Demo 主要采用这一模式，并在固定区域内滚动以保持页面高度。

紧凑描述列表中，统一行高与输入框高度独立。为多行文本设置显式 `inputStyle.height` 时，该高度作为编辑视口：表面保持固定，内容在框内滚动。底层 `HyperTextField(expands: true, maxLines: null)` 也可在有界父布局中使用；不要通过裁切整个输入框来限制多行内容。像素尺寸需包含边框；文字缩放时统一行高至少容纳文字与边框。

## 自定义编辑器

```dart
HyperInlineEdit<bool>(
  value: enabled,
  saveOnBlur: false,
  displayBuilder: (_, value) => HyperText(value ? '开启' : '关闭'),
  editorBuilder: (_, details) => HyperSwitch(
    value: details.value,
    onChanged: details.onChanged,
  ),
  onSaved: (value) => setState(() => enabled = value),
)
```

`details` 提供草稿、`onChanged`、`submit`、`cancel`、初始 `focusNode`、`saving`、`errorText` 和解析后的 `style`。自定义输入应使用该焦点节点，并在保存时遵守 `saving`。值应不可变，集合修改时创建新集合；必要时用 `valuesEqual` 指定相等规则。

对于选择即完成的控件，可设置 `commitOnChanged: true` 和 `showActions: false`。它仍先校验并等待保存成功，不会绕过失败处理。

打开会暂时转移焦点的对话框或选择面板时，通过 `await details.runOverlay(() async { ... })` 包裹整个面板交互，在其中更新草稿、提交；操作期间暂缓失焦保存，关闭后恢复编辑焦点。独立浮层不是编辑区的普通后代，不能假定其焦点天然属于编辑会话。组件不自行创建或绘制这些浮层；使用 HyperDialog、HyperDropdown 等已有公共呈现路径。

## 直接弹窗编辑

内容无法放进页面时使用 `HyperInlineEdit<T>.dialog`：传入 `value`、`displayBuilder`、`dialogBuilder` 和 `onSaved`。激活后页面继续显示摘要，`dialogBuilder(context, value)` 返回所选值，再经统一校验和保存；返回 null 表示取消，不调用 saver。`editorBuilder` 与 `dialogBuilder` 二选一。

弹窗由调用方用 `showHyperDialog` / `HyperDialog` 组成，复用其主题、材质和公共表面。取消按钮、Esc 和关闭弹窗均应返回 null；只有明确确认才返回编辑结果。弹窗模式不会因页面焦点转移而自动确认。失败在摘要下面显示错误，可再次激活重试；外部值变化、禁用或销毁后忽略过期弹窗结果。Demo 提供完整的多行内容弹窗编辑示例。

## 数据与失败

父级 `value` 是权威值；`onSaved` 成功时由父级更新。取消丢弃草稿，未变化的值不调用 saver。保存抛错后保留草稿、显示 `saveErrorText`，可再次保存；`onSaveError` 用于接收原始异常。

失焦和点击区域外默认提交，编辑器和操作按钮之间切换焦点不提交。区域外点击由组件自己的 TapRegion 处理，因此空白区域不需要主动接收焦点。校验失败默认继续编辑；可用 `invalidBlurBehavior: HyperInlineEditInvalidBlurBehavior.cancel` 在失焦校验失败时放弃草稿。保存失败仍保留草稿。

外部值变化或禁用会终止当前编辑会话；旧保存结果和旧 details 回调不能结束或更改新会话。组件销毁后忽略异步 UI 回调。已发出的网络请求由调用方管理，组件终止会话不能撤销其业务副作用。

## 主题与设计依据

全局 `inlineEditTheme`、局部 `HyperInlineEditTheme` 和实例 `HyperInlineEditStyle` 按顺序逐字段合并。可覆盖展示文字、错误文字、文本编辑器 Style、操作按钮 Style 和切换时长/曲线；`transitionBuilder` 可替换默认过渡。自定义编辑器负责使用 details 中相应样式，传入内容自己的显式样式仍由调用方控制。

默认不额外绘制容器表面。输入、按钮继承各自主题及统一材质配置；展示高度继承 `sizes.textField.minimumHeight`，操作间距继承 `sizes.form.gap`，错误间距继承 `sizes.form.messageSpacing`。四端均使用解析后的规格，没有新增设备常量；外边距由父布局负责。

来源等级为 D 级同端语义组合：交互参考本地 lemon_shadcn 的草稿/保存流程，视觉复用已有 HyperText / TextField / Button / Form 规格，没有声称取得官方行内编辑专用尺寸。单位为 Flutter 逻辑像素。默认只做尺寸过渡，时长/曲线继承 Motion，系统减少动画优先；不会为输入表面新增分数透明度离屏层。

2026-10-26 用户明确确认样式与行为，Demo 与主题编辑器入口均移入“输入控件”，页面 id 为 `hyper-inline-edit`。有默认、校验、多行、异步失败重试、自定义控件、禁用、局部主题与实例 Style 示例。展示与错误配色支持编辑器亮暗配置、保存、导入及恢复继承。样式与行为已确认；保持原页面 id 和主题存储字段。

已验证：草稿隔离、键盘、输入法组合、校验、异步保存去重/失败/销毁、外部更新、操作区焦点、浮层保护、主题合并和减少动画；窄宽下验证文字倍率 1.0、1.3、2.0。尚未进行目标设备截图逐像素对照。
