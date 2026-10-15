/// 统一非空语义标签，防止自定义格式化只在部分数值返回空字符串。
String hyperFormatSliderSemanticValue(
  double value,
  double min,
  double max,
  String Function(double)? formatter,
) {
  final custom = formatter?.call(value);
  if (custom != null && custom.isNotEmpty) return custom;
  final current = value.clamp(min, max);
  final fraction = max == min ? 0 : (current - min) / (max - min);
  return '${(fraction * 100).round()}%';
}

/// 未提供回调时保留 Flutter 自带的完整语义格式和步进逻辑。
String Function(double)? hyperSliderSemanticFormatter(
  String Function(double)? formatter,
  double min,
  double max,
) => formatter == null
    ? null
    : (value) => hyperFormatSliderSemanticValue(value, min, max, formatter);

/// 胶囊滑块的键盘步进与无障碍数值共用同一计算，默认读出百分比。
class HyperSliderSemanticsValues {
  HyperSliderSemanticsValues({
    required double value,
    required double min,
    required double max,
    String Function(double)? formatter,
  }) : assert(max >= min),
       current = value.clamp(min, max),
       increased = step(value, min, max, true),
       decreased = step(value, min, max, false) {
    String format(double number) =>
        hyperFormatSliderSemanticValue(number, min, max, formatter);
    label = format(current);
    increasedLabel = format(increased);
    decreasedLabel = format(decreased);
  }

  final double current, increased, decreased;
  late final String label, increasedLabel, decreasedLabel;

  static double step(double value, double min, double max, bool increase) {
    final delta = (max - min) / 20;
    return (value + (increase ? delta : -delta)).clamp(min, max);
  }
}
