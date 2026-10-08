import 'dart:async';

import 'package:flutter/foundation.dart';

/// 内部纯计时模型；只管理显示窗口，不持有任务或交互状态。
class HyperLoadingVisibility extends ChangeNotifier {
  HyperLoadingVisibility({DateTime Function()? now})
    : _now = now ?? DateTime.now;
  final DateTime Function() _now;
  Timer? _timer;
  bool _loading = false;
  bool _visible = false;
  Duration _delay = Duration.zero;
  Duration _minimum = Duration.zero;
  DateTime? _requestedAt;
  DateTime? _shownAt;
  bool get visible => _visible;

  void update({
    required bool loading,
    required Duration showDelay,
    required Duration minimumVisibleDuration,
  }) {
    if (showDelay.isNegative || minimumVisibleDuration.isNegative) {
      throw ArgumentError('加载显示延迟和最短显示时间不能为负数。');
    }
    if (_loading == loading &&
        _delay == showDelay &&
        _minimum == minimumVisibleDuration) {
      return;
    }
    if (loading && !_loading) _requestedAt = _now();
    _loading = loading;
    _delay = showDelay;
    _minimum = minimumVisibleDuration;
    _timer?.cancel();
    if (loading) {
      if (_visible) return;
      final remaining = _delay - _now().difference(_requestedAt!);
      _schedule(remaining, () {
        _shownAt = _now();
        _setVisible(true);
      });
    } else {
      _requestedAt = null;
      if (!_visible) return;
      _schedule(
        _minimum - _now().difference(_shownAt!),
        () => _setVisible(false),
      );
    }
  }

  void _schedule(Duration remaining, VoidCallback action) {
    if (remaining <= Duration.zero) {
      action();
    } else {
      _timer = Timer(remaining, action);
    }
  }

  void _setVisible(bool value) {
    if (_visible == value) return;
    _visible = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
