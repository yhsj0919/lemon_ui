# 日期、时间与日历

公开控件包括 `HyperDatePicker`、`HyperTimePicker`、`HyperDateTimePicker`、`HyperDateTimeRangePicker` 和 `HyperCalendar`。Picker 浮层复用 Select 的设备呈现与表面主题；desktop 默认锚定呈现，phone/tablet 默认底部面板。可用 `presentation` 明确覆盖。

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

样式通过各控件的 `style` 覆盖，选择面板表面可用 `surfaceStyle` 覆盖；全局基础尺寸由 `HyperThemeData.sizes` 管理。对应实现位于 `lib/src/components/date_time_picker` 和 `lib/src/components/calendar`。
