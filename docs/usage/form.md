# 表单

Form Demo 位于“表单 → 表单 Form”，展示竖排、横排和无标题布局。表单与操作区的默认样式及行为已确认；各字段控件仍沿用自身的确认状态。

```dart
final controller = HyperFormController(); // 在拥有它的 State.dispose 中释放。

HyperForm(
  controller: controller,
  layout: HyperFieldLayout.horizontal,
  child: HyperFormSection(
    children: [
      HyperTextFormField(
        name: 'name',
        label: '姓名',
        hintText: '请输入姓名',
        requiredIndicator: true,
        validator: (value) => value == null || value.trim().isEmpty
            ? '请输入姓名' : null,
      ),
      HyperFormField<DateTime>(
        name: 'date',
        label: '预约日期',
        fieldBuilder: (field) => HyperDatePicker(
          value: field.value,
          onChanged: field.enabled ? field.didChange : null,
        ),
      ),
      HyperButton.filled(
        onPressed: () async {
          await controller.submit((values) async {
            // 提交 values；异常保留输入，可由 HyperFormErrorSummary 展示。
          });
        },
        child: const Text('提交'),
      ),
      HyperFormErrorSummary(controller: controller),
    ],
  ),
)
```

`horizontal` 为标签在左、控件在右；窄宽会重排。`labelHidden` 隐藏可见标签，仍应提供 label 或 semanticLabel 作为语义名称。`HyperFormSection(columns: 2)` 可组合多列，空间不足时减少列数；字段行高随内容增长。

`requiredIndicator` 只绘制星号；是否为空由明确的 validator 决定，false 和 0 不自动视为空。`asyncValidator` 在完整校验时运行；跨字段规则放在 controller.crossValidators，通过稳定 name 返回错误。默认仅提交时校验；原生 autovalidateMode 管理同步自动校验，异步与跨字段规则通过 controller.validate/submit 显式执行。

`controller.values` 为当前具名字段的不可变快照，`value<T>(name)` 返回当前值。`dirtyFields/touchedFields/isDirty` 可用于提示，`markClean()` 只更新修改比较基准；`reset()` 恢复 initialValue 并清理错误。集合有默认快照，自定义可变对象须配套提供 valueSnapshot 和 valueEquals。

通用字段 builder 负责把 value、didChange、enabled 和 focusNode 接到基础控件。布局默认只显示一份错误；需要输入框原生错误图标时，文本字段显式设置 errorDisplay: HyperFieldErrorDisplay.trailingIcon。其它没有错误插槽的控件降级为下方错误，不覆盖其尾部按钮。

全局覆盖使用 theme.copyWith(formTheme: ..., fieldTheme: ..., sizes: theme.sizes.copyWith(desktop: ...))；局部使用 HyperFormTheme/HyperFieldTheme，实例 Style 只覆盖显式字段。编辑器入口提供标签、布局、说明与错误的字体、颜色和间距；不改变子控件自己的表面。
# 选择类字段适配器

## 自动完成与动态列表

`HyperAutocompleteFormField<T>` 和 `HyperMultiAutocompleteFormField<T>` 分别保存单值与
不可变集合，支持 options、异步 source、selectedOptions、labelBuilder 和 createValue。
下拉的 HyperSelectFormField / HyperMultiSelectFormField 也提供这些数据源入口。
输入查询文本与选择值分开；只有选择或创建选项才更新表单值。

`HyperFormListField<T>` 将重复录入整体注册为 `List<T>`，支持 minimumItems、maximumItems、
itemValidator、列表 validator 和 asyncValidator。createItem 生成新增项，itemBuilder 接收
HyperFormListItem（index、value、enabled、onChanged、remove、errorText）。
行内使用普通受控输入，不另行注册同名 FormField；把 enabled 与 errorText 传给输入。
删除保留其他行的 Widget 状态，重置会重建条目以恢复初始输入。集合结构不可变；
自定义业务对象应使用不可变值对象，通过 onChanged 返回新值。
默认“添加一项”按钮可通过 addLabel 替换；每项的删除操作与布局由 itemBuilder 组合。
数量下限限制删除，上限限制新增；列表校验逐项检查并在错误摘要中标明首个错误的项号。
页面、Dialog 和底部弹窗的 Form Demo 均包含联系人列表。

## Slider 字段

`HyperSliderFormField` 与 `HyperRangeSliderFormField` 复用现有 HyperSlider 和
HyperRangeSlider，分别注册 double 与 RangeValues 值；拖动更新值，重置恢复初始值。
未指定初始值时使用 min 或完整的 min/max 范围。范围必须有限且有序，初始值须落在范围内。
支持 min/max、divisions、snapToDivisions、showDivisionPoints、variant、拖动开始/结束回调，
以及 sliderStyle。提示文字通过 labelBuilder / labelsBuilder 随当前值构建。
单值字段将 Form 的焦点节点传给 Slider；范围字段的键盘交互沿用现有范围 Slider。
禁用字段不能拖动且跳过校验；横排及无标题布局沿用右侧错误提示。

## 多选字段

`HyperMultiSelectFormField<T>` 和 `HyperCheckboxGroupFormField<T>` 使用
`Set<T>` 值；默认是空集合，清空时写入空集合。初始值和交互产生的值会复制为不可变集合，
支持按集合内容追踪修改状态和重置。

两者支持 `minimumSelection`（默认 0）、`maximumSelection`（默认无限制）和自定义
`validator`。先校验数量，再执行自定义校验；异步校验沿用 Form 的提交流程。
达到上限后仍可取消已选项；Checkbox 组禁止继续勾选新项。禁用选项和禁用字段均不响应操作。
Checkbox 组使用 `direction` 切换横排自动换行或竖排，样式由 `checkboxStyle` 覆盖。
多选下拉沿用 `searchable`、`presentation` 和 `selectStyle`。

## 日期时间字段

`HyperDateFormField`、`HyperTimeFormField`、`HyperDateTimeFormField` 和
`HyperDateTimeRangeFormField` 直接参与 Form 校验、重置及修改状态跟踪。
初始值分别为 `DateTime?`、`TimeOfDay?`、`DateTime?`、`DateTimeRange?`。
选择面板中的清空会将字段设置为 null；必填规则由 `validator` 定义。

区间字段的 `mode` 支持 `date`、`time` 和 `dateTime`，沿用一个弹窗编辑两端值。
日期支持 `firstDate` / `lastDate`，其余字段支持 `minimum` / `maximum`；
时间步长使用 `minuteInterval`，日期时间及区间可开启 `showSeconds`。
控件外观通过 `pickerStyle` 和 `surfaceStyle` 配置，表单外观使用 `style`。
呈现方式默认随真实设备类别，也可以显式设置 `presentation`。

## 弹窗表单

使用 `showHyperFormDialog` 或 `showHyperFormBottomSheet`，`builder` 直接返回字段或
`HyperFormSection`，不需要再套一层 `HyperForm`。两者复用既有弹窗表面与主题。
点击确定会执行同步、异步和跨字段校验；校验通过后执行可选的 `onSubmit(values)`，
成功关闭并返回不可变的 `Map<String, Object?>`。取消返回 null。提交异常保留输入，
并通过错误摘要展示；提交期间禁止重复点击确定和通过返回键退出。

可传入已有 `controller` 来配置跨字段校验或管理值，其生命周期仍由调用方负责；
未传时弹窗自动创建并释放。`style` 设置对应弹窗表面，`formStyle` 设置字段布局外观；
`layout`、`errorDisplay` 与普通表单一致。默认按钮文字为“取消”“确定”，可替换。

```dart
final values = await showHyperFormDialog(
  context: context,
  title: const Text('编辑资料'),
  builder: (_) => HyperTextFormField(
    name: 'name',
    label: '姓名',
    validator: (value) => value == null || value.isEmpty ? '请输入姓名' : null,
  ),
  onSubmit: (values) async {
    // 等待保存；抛出异常时弹窗保留。
  },
);
```

`HyperSelectFormField<T>`、`HyperCheckboxFormField`、`HyperRadioFormField<T>` 和
`HyperSwitchFormField` 可以直接放入 `HyperForm`，统一使用 `name`、`initialValue`、
`validator`、`asyncValidator`、`onSaved`、`onChanged` 和 `enabled`。
`requiredIndicator` 只显示必填标记，是否接受空值由校验器决定。

Select 和 Radio 使用 `HyperSelectOption<T>` 作为选项；Radio 整组注册为一个字段，
默认横排并自动换行，也可设置 `direction: Axis.vertical`。Checkbox 支持 `tristate`，
Switch 默认值为 false。视觉样式分别通过 `selectStyle`、`checkboxStyle`、
`radioStyle` 和 `switchStyle` 覆盖，字段标签及错误使用通用 `style`。
横排和无标题布局默认在控件右侧显示错误提示图标。

`HyperFormActions` 统一组合提交、重置和可选取消按钮。提交调用 controller.submit，先运行
字段与跨字段校验，再把不可变 values 交给 onSubmit；异步期间操作按钮禁用并显示加载态。
重置恢复各字段 initialValue 并清除错误，取消行为由 onCancel 提供。将 `HyperFormErrorSummary`
放在操作区附近可显示提交回调抛出的错误。按钮样式通过 `submitStyle`、`resetStyle`、
`cancelStyle` 覆盖，间距继承 Form 主题；窄宽度会自动换行。

`HyperCascaderFormField<T>` 保存不可变的完整路径 `List<T>`，支持 `nodes` 与
`loadChildren`、清空、具名提交、同步/异步校验、禁用和重置。字段 `style` 用于
标签和错误，`cascaderStyle` / `surfaceStyle` 用于控件及浮层；
浏览分支与手机滚轮草稿不会改变表单值；列表选择末级或手机点击确定后提交路径。
详见 [级联选择 Form 适配](cascader.md#form-适配)。

`HyperTreeSelectFormField<T>` 保存单个树节点值，支持 `leafOnly`、异步子节点、
同步/异步校验、禁用与重置。详见 [树形选择 Form 适配](tree-select.md#form-适配)。

