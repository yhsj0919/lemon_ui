import 'package:lemon_ui/lemon_ui.dart';

class EditorChartMetrics {
  double? height;
  double? barWidth;
  double? groupSpacing;
  double? axisMinReservedSize;
  double? axisMaxReservedSize;
  double? labelFontSize;
  double? radius;
  double? lineWidth;
  double? pieRadius;
  double? donutHoleRadius;
  double? pointRadius;
  double? pieSectionSpacing;
  double? legendSpacing;
  double? dataLabelMinSpacing;
  double? keyboardFocusWidth;
  Map<String, Object?> toJson() => {
    if (height != null) 'height': height,
    if (barWidth != null) 'barWidth': barWidth,
    if (groupSpacing != null) 'groupSpacing': groupSpacing,
    if (axisMinReservedSize != null) 'axisMinReservedSize': axisMinReservedSize,
    if (axisMaxReservedSize != null) 'axisMaxReservedSize': axisMaxReservedSize,
    if (labelFontSize != null) 'labelFontSize': labelFontSize,
    if (radius != null) 'radius': radius,
    if (lineWidth != null) 'lineWidth': lineWidth,
    if (pieRadius != null) 'pieRadius': pieRadius,
    if (donutHoleRadius != null) 'donutHoleRadius': donutHoleRadius,
    if (pointRadius != null) 'pointRadius': pointRadius,
    if (pieSectionSpacing != null) 'pieSectionSpacing': pieSectionSpacing,
    if (legendSpacing != null) 'legendSpacing': legendSpacing,
    if (dataLabelMinSpacing != null) 'dataLabelMinSpacing': dataLabelMinSpacing,
    if (keyboardFocusWidth != null) 'keyboardFocusWidth': keyboardFocusWidth,
  };
  static EditorChartMetrics fromJson(Map<String, dynamic> json) {
    if (json.keys.any(
      (key) => !{
        'height',
        'barWidth',
        'groupSpacing',
        'axisMinReservedSize',
        'axisMaxReservedSize',
        'labelFontSize',
        'radius',
        'lineWidth',
        'pieRadius',
        'donutHoleRadius',
        'pointRadius',
        'pieSectionSpacing',
        'legendSpacing',
        'dataLabelMinSpacing',
        'keyboardFocusWidth',
      }.contains(key),
    )) {
      throw const FormatException('未知图表尺寸字段');
    }
    return EditorChartMetrics()
      ..height = _read(json['height'])
      ..barWidth = _read(json['barWidth'])
      ..groupSpacing = _read(json['groupSpacing'])
      ..axisMinReservedSize = _read(json['axisMinReservedSize'])
      ..axisMaxReservedSize = _read(json['axisMaxReservedSize'])
      ..labelFontSize = _read(json['labelFontSize'])
      ..radius = _read(json['radius'])
      ..lineWidth = _read(json['lineWidth'])
      ..pieRadius = _read(json['pieRadius'])
      ..donutHoleRadius = _read(json['donutHoleRadius'])
      ..pointRadius = _read(json['pointRadius'])
      ..pieSectionSpacing = _read(json['pieSectionSpacing'])
      ..legendSpacing = _read(json['legendSpacing'])
      ..dataLabelMinSpacing = _read(json['dataLabelMinSpacing'])
      ..keyboardFocusWidth = _read(json['keyboardFocusWidth']);
  }

  HyperChartSize resolve(HyperChartSize base) => base.copyWith(
    height: height,
    barWidth: barWidth,
    groupSpacing: groupSpacing,
    axisMinReservedSize: axisMinReservedSize,
    axisMaxReservedSize: axisMaxReservedSize,
    labelFontSize: labelFontSize,
    radius: radius,
    lineWidth: lineWidth,
    pieRadius: pieRadius,
    donutHoleRadius: donutHoleRadius,
    pointRadius: pointRadius,
    pieSectionSpacing: pieSectionSpacing,
    legendSpacing: legendSpacing,
    dataLabelMinSpacing: dataLabelMinSpacing,
    keyboardFocusWidth: keyboardFocusWidth,
  );
}

class EditorChartVisual {
  double? gridOpacity;
  double? inactiveOpacity;
  double? hoverScale;
  double? pieLabelMinPercent;
  HyperChartLegendPosition? legendPosition;
  Map<String, Object?> toJson() => {
    if (gridOpacity != null) 'gridOpacity': gridOpacity,
    if (inactiveOpacity != null) 'inactiveOpacity': inactiveOpacity,
    if (hoverScale != null) 'hoverScale': hoverScale,
    if (pieLabelMinPercent != null) 'pieLabelMinPercent': pieLabelMinPercent,
    if (legendPosition != null) 'legendPosition': legendPosition!.name,
  };
  static EditorChartVisual fromJson(Map<String, dynamic> json) {
    if (json.keys.any(
      (key) => !{
        'gridOpacity',
        'inactiveOpacity',
        'hoverScale',
        'pieLabelMinPercent',
        'legendPosition',
      }.contains(key),
    )) {
      throw const FormatException('未知图表外观字段');
    }
    final result = EditorChartVisual()
      ..gridOpacity = _read(json['gridOpacity'])
      ..inactiveOpacity = _read(json['inactiveOpacity'])
      ..hoverScale = _read(json['hoverScale'])
      ..pieLabelMinPercent = _read(json['pieLabelMinPercent'])
      ..legendPosition = json['legendPosition'] == null
          ? null
          : HyperChartLegendPosition.values.byName(
              json['legendPosition'] as String,
            );
    if ((result.gridOpacity ?? 0) > 1 ||
        (result.inactiveOpacity ?? 0) > 1 ||
        (result.pieLabelMinPercent ?? 0) > 100 ||
        (result.hoverScale != null && result.hoverScale! < 1)) {
      throw const FormatException('图表比例超出合法范围');
    }
    return result;
  }

  HyperChartStyle resolve() => HyperChartStyle(
    gridOpacity: gridOpacity,
    inactiveOpacity: inactiveOpacity,
    hoverScale: hoverScale,
    pieLabelMinPercent: pieLabelMinPercent,
    legend: legendPosition == null
        ? null
        : HyperChartLegendOptions(position: legendPosition!),
  );
}

double? _read(Object? value) {
  if (value == null) return null;
  if (value is! num || !value.isFinite || value < 0) {
    throw const FormatException('无效图表数值');
  }
  return value.toDouble();
}
