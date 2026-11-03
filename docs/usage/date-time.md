# 日期、时间与日历

公开控件包括 `HyperDatePicker`、`HyperTimePicker`、`HyperDateTimePicker`、`HyperDateTimeRangePicker` 和 `HyperCalendar`。Picker 浮层复用 Select 的设备呈现与表面主题；desktop 默认锚定呈现，phone/tablet 默认底部面板。可用 `presentation` 明确覆盖。

`HyperDateTimeRangePicker` 的 `placeholder` 可自定义未选择时的提示，例如 `placeholder: '请选择统计时间范围'`。省略时保留按 `mode` 生成的默认文案；已选择范围时仍显示起止值。`HyperDateTimeRangeFormField` 透传同名参数。

## 单值选择

```dart
HyperDatePicker(
  value: selectedDate,
  firstDate: DateTime(2020),
  lastDate: DateTime(2035),
  onChanged: (value) => setState(() => selectedDate = value),
)
```

`HyperTimePicker` 使用 `TimeOfDay?`；`HyperDateTimePicker` 使用 `DateTime?`，并可通过 `mode` 选择 `date`、`time` 或 `dateTime`。选择面板以草稿编辑，确认后才回调；取消不提交草稿。日期边界包含端点。时间精度为分钟，`minuteInterval` 必须是 60 的正因数。日期时间按本地年月日和时分处理，不执行时区换算。

## 范围与内嵌日历

`HyperDateTimeRangePicker` 使用 `DateTimeRange?`，`mode` 可选择日期、时间或日期时间范围；time 模式以同一天的时分比较，不支持跨午夜。`HyperCalendar` 用于内嵌页面：普通构造器选择单日，`.range` 构造器选择包含端点的日期区间。日历日期同样按本地年月日比较。

范围选择器为空时，开始值默认取打开面板时的当前日期时间，并遵守边界与分钟步进。桌面日期日历每次打开都将开始值作为已选起点，首次点击即可选择结束日期；完成后再次点击开始重选，再点击结束日期。已有范围保留原开始值，同日范围也适用，无需调用方省略或清空结束值。时间滚轮可直接调整结束值，也可单独修改开始值。所有草稿仅在确认后提交，取消不写入默认范围。内嵌 `HyperCalendar.range` 可通过 `initialRangeStart` 显式启用预选起点，省略时仍从第一次点击开始选择。

样式通过各控件的 `style` 覆盖，选择面板表面可用 `surfaceStyle` 覆盖；全局基础尺寸由 `HyperThemeData.sizes` 管理。对应实现位于 `lib/src/components/date_time_picker` 和 `lib/src/components/calendar`。

日历范围的中间日期默认保留原浅色背景，并添加语义 `outline` 灰色描边，方便在高透明材质上辨识；起止日期仍使用主色。描边沿用现有今日标记的 1 逻辑像素规格，属于项目语义推导，不是新增官方规格。`HyperCalendarStyle.rangeBorder` 支持全局 `calendarTheme`、局部 `HyperCalendarTheme` 与实例覆盖颜色和粗细，`BorderSide.none` 或零宽显式关闭；主题编辑器“日历”的底部边框组可修改颜色，支持原有保存、导入与恢复继承。

未传入 `value` 范围时仅预选开始时间，结束值保持未选择，不自动生成同日起止范围；选择结束值前“确定”禁用。时间编辑区显示“选择结束时间”，点击后显式采用开始时间作为结束草稿并可继续调整；桌面日历直接点击结束日期即可。只有显式传入 `value` 时才初始化完整起止范围。
