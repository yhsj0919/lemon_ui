import 'package:flutter/material.dart';

import '../slider/hyper_slider.dart';
import '../slider/hyper_slider_style.dart';
import 'hyper_form.dart';

void _checkBounds(double min, double max, int? divisions) {
  if (!min.isFinite ||
      !max.isFinite ||
      max < min ||
      (divisions != null && divisions <= 0)) {
    throw ArgumentError('滑块范围必须有限、有序，分段数量必须为正');
  }
}

double _initial(double? value, double min, double max, int? divisions) {
  _checkBounds(min, max, divisions);
  final result = value ?? min;
  if (!result.isFinite || result < min || result > max) {
    throw ArgumentError.value(value, 'initialValue', '必须位于滑块范围内');
  }
  return result;
}

RangeValues _range(RangeValues? value, double min, double max, int? divisions) {
  _checkBounds(min, max, divisions);
  final result = value ?? RangeValues(min, max);
  _initial(result.start, min, max, divisions);
  _initial(result.end, min, max, divisions);
  if (result.start > result.end) throw ArgumentError('起点不能大于终点');
  return result;
}

/// Single-value slider integrated with Form validation and reset.
class HyperSliderFormField extends HyperFormField<double> {
  HyperSliderFormField({
    super.key,
    super.name,
    super.label,
    super.semanticLabel,
    super.description,
    super.requiredIndicator,
    super.layout,
    super.errorDisplay,
    super.style,
    super.validator,
    super.asyncValidator,
    super.onSaved,
    super.onReset,
    super.onChanged,
    super.enabled,
    super.autovalidateMode,
    super.focusNode,
    double min = 0,
    double max = 1,
    int? divisions,
    bool snapToDivisions = true,
    bool showDivisionPoints = false,
    HyperSliderVariant variant = HyperSliderVariant.capsule,
    HyperSliderStyle? sliderStyle,
    double? initialValue,
    double? bufferValue,
    String Function(double)? labelBuilder,
    ValueChanged<double>? onChangeStart,
    ValueChanged<double>? onChangeEnd,
    SemanticFormatterCallback? semanticFormatterCallback,
  }) : super(
         initialValue: _initial(initialValue, min, max, divisions),
         fieldBuilder: (f) => HyperSlider(
           value: f.value ?? min,
           min: min,
           max: max,
           divisions: divisions,
           snapToDivisions: snapToDivisions,
           showDivisionPoints: showDivisionPoints,
           variant: variant,
           style: sliderStyle,
           bufferValue: bufferValue,
           label: labelBuilder?.call(f.value ?? min),
           focusNode: f.focusNode,
           semanticFormatterCallback: semanticFormatterCallback,
           onChangeStart: f.enabled ? onChangeStart : null,
           onChangeEnd: f.enabled ? onChangeEnd : null,
           onChanged: f.enabled ? f.didChange : null,
         ),
       );
}

/// Two-thumb slider registers as one RangeValues-valued form field.
class HyperRangeSliderFormField extends HyperFormField<RangeValues> {
  HyperRangeSliderFormField({
    super.key,
    super.name,
    super.label,
    super.semanticLabel,
    super.description,
    super.requiredIndicator,
    super.layout,
    super.errorDisplay,
    super.style,
    super.validator,
    super.asyncValidator,
    super.onSaved,
    super.onReset,
    super.onChanged,
    super.enabled,
    super.autovalidateMode,
    super.focusNode,
    double min = 0,
    double max = 1,
    int? divisions,
    bool snapToDivisions = true,
    bool showDivisionPoints = false,
    HyperSliderVariant variant = HyperSliderVariant.capsule,
    HyperSliderStyle? sliderStyle,
    RangeValues? initialValue,
    RangeLabels Function(RangeValues)? labelsBuilder,
    ValueChanged<RangeValues>? onChangeStart,
    ValueChanged<RangeValues>? onChangeEnd,
    SemanticFormatterCallback? semanticFormatterCallback,
  }) : super(
         initialValue: _range(initialValue, min, max, divisions),
         fieldBuilder: (f) => HyperRangeSlider(
           values: f.value ?? RangeValues(min, max),
           min: min,
           max: max,
           divisions: divisions,
           snapToDivisions: snapToDivisions,
           showDivisionPoints: showDivisionPoints,
           variant: variant,
           style: sliderStyle,
           labels: labelsBuilder?.call(f.value ?? RangeValues(min, max)),
           semanticFormatterCallback: semanticFormatterCallback,
           onChangeStart: f.enabled ? onChangeStart : null,
           onChangeEnd: f.enabled ? onChangeEnd : null,
           onChanged: f.enabled ? f.didChange : null,
         ),
       );
}
