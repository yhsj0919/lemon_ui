/// 分割线与闭合边框共用的线段布局；绘制方式由几何形状决定。
Iterable<({double start, double end})> hyperPatternSegments({
  required double extent,
  required double dashLength,
  required double gap,
  double? dotDiameter,
}) sync* {
  if (!extent.isFinite || extent < 0) return;
  final length = dotDiameter == null ? dashLength : 0.0;
  final step = (dotDiameter ?? dashLength) + gap;
  for (
    var start = 0.0;
    start <= extent;
    start += step > 0 ? step : extent + 1
  ) {
    yield (start: start, end: (start + length).clamp(0.0, extent));
  }
}
