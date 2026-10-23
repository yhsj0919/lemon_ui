part of 'hyper_line_chart.dart';

/// 可复用的只读数据快照，预先完成范围、索引及全量视图采样。
/// 原生平台通过 compute 在工作 isolate 准备；Web 使用 Flutter compute 的同线程实现。
@immutable
class HyperLineChartDataset {
  const HyperLineChartDataset._(
    this.series,
    this._index,
    this._samples,
    this._levels,
    this.maxRenderedPoints,
    this.nullPolicy,
    this.samplingStrategy,
  );
  final List<HyperLineSeries> series;
  final _HyperLineIndex _index;
  final Map<HyperLineSeries, List<HyperLinePoint>> _samples;
  final Map<HyperLineSeries, List<List<HyperLinePoint>>> _levels;
  final int? maxRenderedPoints;
  final HyperChartNullPolicy nullPolicy;
  final HyperChartSamplingStrategy samplingStrategy;
  int get pointCount =>
      series.fold(0, (count, series) => count + series.points.length);
  HyperChartRange? get domain => _index.valid.isEmpty
      ? null
      : HyperChartRange(
          _index.minX,
          _index.maxX > _index.minX ? _index.maxX : _index.minX + 1,
        );

  /// 传入快照的 series 与 preparedData，一份结果可在多个图表中复用。
  static Future<HyperLineChartDataset> prepare(
    List<HyperLineSeries> series, {
    int? maxRenderedPoints = 1000,
    HyperChartNullPolicy nullPolicy = HyperChartNullPolicy.gap,
    HyperChartSamplingStrategy samplingStrategy =
        HyperChartSamplingStrategy.largestTriangleThreeBuckets,
  }) {
    if (maxRenderedPoints != null && maxRenderedPoints < 3) {
      throw ArgumentError.value(maxRenderedPoints, 'maxRenderedPoints');
    }
    return compute(
      _prepareHyperLineDataset,
      _HyperLinePrepareRequest(
        series,
        maxRenderedPoints,
        nullPolicy,
        samplingStrategy,
      ),
      debugLabel: 'HyperLineChart.prepare',
    );
  }

  /// 同时在工作 isolate 生成和预处理数据，避免先在 UI 线程创建大列表。
  /// builder 需为可跨 isolate 发送的纯函数，推荐顶层函数或静态方法。
  static Future<HyperLineChartDataset> generate<T>(
    T input,
    List<HyperLineSeries> Function(T) builder, {
    int? maxRenderedPoints = 1000,
    HyperChartNullPolicy nullPolicy = HyperChartNullPolicy.gap,
    HyperChartSamplingStrategy samplingStrategy =
        HyperChartSamplingStrategy.largestTriangleThreeBuckets,
  }) {
    if (maxRenderedPoints != null && maxRenderedPoints < 3) {
      throw ArgumentError.value(maxRenderedPoints, 'maxRenderedPoints');
    }
    return compute(
      _generateHyperLineDataset<T>,
      _GeneratedLineRequest(
        input,
        builder,
        maxRenderedPoints,
        nullPolicy,
        samplingStrategy,
      ),
      debugLabel: 'HyperLineChart.generate',
    );
  }
}

class _GeneratedLineRequest<T> {
  _GeneratedLineRequest(
    this.input,
    this.builder,
    this.limit,
    this.nullPolicy,
    this.strategy,
  );
  final T input;
  final List<HyperLineSeries> Function(T) builder;
  final int? limit;
  final HyperChartNullPolicy nullPolicy;
  final HyperChartSamplingStrategy strategy;
}

HyperLineChartDataset _generateHyperLineDataset<T>(
  _GeneratedLineRequest<T> request,
) => _prepareHyperLineDataset(
  _HyperLinePrepareRequest(
    request.builder(request.input),
    request.limit,
    request.nullPolicy,
    request.strategy,
  ),
);

class _HyperLinePrepareRequest {
  _HyperLinePrepareRequest(
    this.series,
    this.limit,
    this.nullPolicy,
    this.strategy,
  );
  final List<HyperLineSeries> series;
  final int? limit;
  final HyperChartNullPolicy nullPolicy;
  final HyperChartSamplingStrategy strategy;
}

HyperLineChartDataset _prepareHyperLineDataset(
  _HyperLinePrepareRequest request,
) {
  final series = List<HyperLineSeries>.unmodifiable(
    request.series.map((item) {
      for (final point in item.points) {
        if (!point.x.isFinite || (point.y != null && !point.y!.isFinite)) {
          throw ArgumentError('图表数据必须是有限数值');
        }
      }
      return HyperLineSeries(
        name: item.name,
        points: List.unmodifiable(item.points),
        color: item.color,
        width: item.width,
        showPoints: item.showPoints,
      );
    }),
  );
  final index = _HyperLineIndex(series);
  final samples = Map<HyperLineSeries, List<HyperLinePoint>>.unmodifiable({
    for (final item in series)
      item: List<HyperLinePoint>.unmodifiable(
        _sampleHyperLinePoints(
          item.points,
          request.limit,
          request.nullPolicy,
          request.strategy,
        ),
      ),
  });
  final levels = <HyperLineSeries, List<List<HyperLinePoint>>>{};
  for (final item in series) {
    final tiers = <List<HyperLinePoint>>[samples[item]!];
    // 四倍递增控制缓存总量；每层从原始点独立采样，避免级联累积误差。
    if (request.limit != null &&
        request.strategy != HyperChartSamplingStrategy.none &&
        index.sorted[item] == true) {
      for (
        var budget = request.limit! * 4;
        budget < item.points.length;
        budget *= 4
      ) {
        tiers.add(
          List.unmodifiable(
            _sampleHyperLinePoints(
              item.points,
              budget,
              request.nullPolicy,
              request.strategy,
            ),
          ),
        );
      }
    }
    tiers.add(item.points);
    levels[item] = List.unmodifiable(tiers);
  }
  return HyperLineChartDataset._(
    series,
    index,
    samples,
    Map.unmodifiable(levels),
    request.limit,
    request.nullPolicy,
    request.strategy,
  );
}
