import 'package:flutter/material.dart';

import '../date_time_picker/hyper_date_time_picker.dart';
import '../select/hyper_select_model.dart';
import '../select/hyper_select_style.dart';
import '../card/hyper_card_style.dart';
import 'hyper_form.dart';

/// HyperDatePicker integrated with validation, clear and reset in HyperForm.
class HyperDateFormField extends HyperFormField<DateTime> {
  HyperDateFormField({
    super.key,
    super.name,
    super.label,
    super.semanticLabel,
    super.description,
    super.requiredIndicator,
    super.layout,
    super.errorDisplay,
    super.style,
    super.initialValue,
    super.validator,
    super.asyncValidator,
    super.onSaved,
    super.onReset,
    super.onChanged,
    super.enabled,
    super.autovalidateMode,
    super.focusNode,
    HyperSelectPresentation? presentation,
    HyperSelectStyle? pickerStyle,
    HyperCardStyle? surfaceStyle,
    DateTime? firstDate,
    DateTime? lastDate,
  }) : super(
         fieldBuilder: (f) => HyperDatePicker(
           value: f.value,
           onChanged: f.enabled ? f.didChange : null,
           enabled: f.enabled,
           presentation: presentation,
           style: pickerStyle,
           surfaceStyle: surfaceStyle,
           firstDate: firstDate,
           lastDate: lastDate,
         ),
       );
}

/// HyperTimePicker integrated with validation, clear and reset in HyperForm.
class HyperTimeFormField extends HyperFormField<TimeOfDay> {
  HyperTimeFormField({
    super.key,
    super.name,
    super.label,
    super.semanticLabel,
    super.description,
    super.requiredIndicator,
    super.layout,
    super.errorDisplay,
    super.style,
    super.initialValue,
    super.validator,
    super.asyncValidator,
    super.onSaved,
    super.onReset,
    super.onChanged,
    super.enabled,
    super.autovalidateMode,
    super.focusNode,
    HyperSelectPresentation? presentation,
    HyperSelectStyle? pickerStyle,
    HyperCardStyle? surfaceStyle,
    TimeOfDay? minimum,
    TimeOfDay? maximum,
    int minuteInterval = 1,
  }) : super(
         fieldBuilder: (f) => HyperTimePicker(
           value: f.value,
           onChanged: f.enabled ? f.didChange : null,
           enabled: f.enabled,
           presentation: presentation,
           style: pickerStyle,
           surfaceStyle: surfaceStyle,
           minimum: minimum,
           maximum: maximum,
           minuteInterval: minuteInterval,
         ),
       );
}

/// HyperDateTimePicker integrated with validation, clear and reset in HyperForm.
class HyperDateTimeFormField extends HyperFormField<DateTime> {
  HyperDateTimeFormField({
    super.key,
    super.name,
    super.label,
    super.semanticLabel,
    super.description,
    super.requiredIndicator,
    super.layout,
    super.errorDisplay,
    super.style,
    super.initialValue,
    super.validator,
    super.asyncValidator,
    super.onSaved,
    super.onReset,
    super.onChanged,
    super.enabled,
    super.autovalidateMode,
    super.focusNode,
    HyperSelectPresentation? presentation,
    HyperSelectStyle? pickerStyle,
    HyperCardStyle? surfaceStyle,
    DateTime? minimum,
    DateTime? maximum,
    int minuteInterval = 1,
    bool showSeconds = false,
    String? placeholder,
    String Function(DateTime)? labelBuilder,
  }) : super(
         fieldBuilder: (f) => HyperDateTimePicker(
           value: f.value,
           onChanged: f.enabled ? f.didChange : null,
           enabled: f.enabled,
           presentation: presentation,
           style: pickerStyle,
           surfaceStyle: surfaceStyle,
           minimum: minimum,
           maximum: maximum,
           minuteInterval: minuteInterval,
           showSeconds: showSeconds,
           placeholder: placeholder,
           labelBuilder: labelBuilder,
         ),
       );
}

/// HyperDateTimeRangePicker integrated with validation, clear and reset in HyperForm.
class HyperDateTimeRangeFormField extends HyperFormField<DateTimeRange> {
  HyperDateTimeRangeFormField({
    super.key,
    super.name,
    super.label,
    super.semanticLabel,
    super.description,
    super.requiredIndicator,
    super.layout,
    super.errorDisplay,
    super.style,
    super.initialValue,
    super.validator,
    super.asyncValidator,
    super.onSaved,
    super.onReset,
    super.onChanged,
    super.enabled,
    super.autovalidateMode,
    super.focusNode,
    HyperSelectPresentation? presentation,
    HyperSelectStyle? pickerStyle,
    HyperCardStyle? surfaceStyle,
    HyperDateTimePickerMode mode = HyperDateTimePickerMode.dateTime,
    DateTime? minimum,
    DateTime? maximum,
    int minuteInterval = 1,
    bool showSeconds = false,
  }) : super(
         fieldBuilder: (f) => HyperDateTimeRangePicker(
           value: f.value,
           onChanged: f.enabled ? f.didChange : null,
           enabled: f.enabled,
           presentation: presentation,
           style: pickerStyle,
           surfaceStyle: surfaceStyle,
           mode: mode,
           minimum: minimum,
           maximum: maximum,
           minuteInterval: minuteInterval,
           showSeconds: showSeconds,
         ),
       );
}
