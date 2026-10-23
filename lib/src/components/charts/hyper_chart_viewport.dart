import 'dart:math' as math;

import 'package:flutter/foundation.dart';

/// 数据坐标中的横轴范围，与屏幕像素和设备类别无关。
@immutable
class HyperChartRange {
  HyperChartRange(this.min, this.max) {
    if (!min.isFinite || !max.isFinite || max <= min || !(max - min).isFinite) {
      throw ArgumentError('图表范围必须有限且 max > min');
    }
  }
  final double min, max;
  double get span => max - min;
  @override
  bool operator ==(Object other) =>
      other is HyperChartRange && other.min == min && other.max == max;
  @override
  int get hashCode => Object.hash(min, max);
}

/// 横轴缩放、平移和重置；由使用方持有并销毁，可同步多个图表。
class HyperChartViewportController extends ChangeNotifier {
  HyperChartViewportController({
    required HyperChartRange domain,
    this.minimumSpan,
  }) : _domain = domain,
       _range = domain {
    if (minimumSpan != null && (!minimumSpan!.isFinite || minimumSpan! <= 0)) {
      throw ArgumentError.value(minimumSpan, 'minimumSpan');
    }
  }
  HyperChartRange _domain, _range;
  final double? minimumSpan;
  HyperChartRange get domain => _domain;
  HyperChartRange get range => _range;
  bool get isFullRange => _range == _domain;

  void setDomain(HyperChartRange value, {bool reset = false}) {
    if (value == _domain && !reset) return;
    final wasFull = isFullRange;
    _domain = value;
    _range = reset || wasFull ? value : _clamp(_range);
    notifyListeners();
  }

  void setRange(HyperChartRange value) {
    final next = _clamp(value);
    if (next == _range) return;
    _range = next;
    notifyListeners();
  }

  void reset() => setRange(_domain);
  void pan(double delta) {
    if (!delta.isFinite) throw ArgumentError.value(delta, 'delta');
    if (!(_range.min + delta).isFinite || !(_range.max + delta).isFinite) {
      return;
    }
    setRange(HyperChartRange(_range.min + delta, _range.max + delta));
  }

  /// factor > 1 放大；anchor 是当前可见范围内的归一化位置。
  void zoom(double factor, {double anchor = .5}) {
    if (!factor.isFinite ||
        factor <= 0 ||
        !anchor.isFinite ||
        anchor < 0 ||
        anchor > 1) {
      throw ArgumentError('缩放倍率需大于零，锚点需位于 0 到 1');
    }
    final span = (_range.span / factor).clamp(
      math.min(minimumSpan ?? double.minPositive, _domain.span),
      _domain.span,
    );
    final position = _range.min + _range.span * anchor;
    final min = position - span * anchor, max = position + span * (1 - anchor);
    if (min.isFinite && max.isFinite && max > min) {
      setRange(HyperChartRange(min, max));
    }
  }

  HyperChartRange _clamp(HyperChartRange value) {
    final span = value.span.clamp(
      math.min(minimumSpan ?? double.minPositive, _domain.span),
      _domain.span,
    );
    final min = value.min.clamp(_domain.min, _domain.max - span);
    return HyperChartRange(min, min + span);
  }
}
