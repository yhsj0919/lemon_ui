import 'dart:async';

import 'package:flutter/widgets.dart';

import 'hyper_message_style.dart';

/// queue 串行；stack 实时显示，满额淘汰最旧项；stackQueue 满额后排队。
enum HyperMessageMode { queue, stack, stackQueue }

enum HyperMessageCloseReason {
  timeout,
  dismissed,
  action,
  superseded,
  hostDisposed,
}

class HyperMessageHandle {
  HyperMessageHandle._(this._dismiss);
  final void Function(HyperMessageCloseReason) _dismiss;
  final _completion = Completer<HyperMessageCloseReason>();
  Future<HyperMessageCloseReason> get closed => _completion.future;
  void close([
    HyperMessageCloseReason reason = HyperMessageCloseReason.dismissed,
  ]) => _dismiss(reason);
}

/// 单条提示的内容与关闭状态，计时和动画由宿主中的独立呈现单元负责。
class HyperMessageRequest {
  HyperMessageRequest._({
    required this.content,
    required this.toast,
    required this.mode,
    required this.duration,
    this.icon,
    this.action,
    this.semanticLabel,
    this.style,
    required this.handle,
  });
  final Widget content;
  final bool toast;
  final HyperMessageMode mode;
  final Duration duration;
  final Widget? icon;
  final Widget? action;
  final String? semanticLabel;
  final HyperMessageStyle? style;
  final HyperMessageHandle handle;
  HyperMessageCloseReason? _reason;
  bool _presented = false;
  HyperMessageCloseReason? get closeReason => _reason;
}

/// 每个窗口独立管理提示；Toast 和 Snackbar 各自拥有显示名额，互不阻塞。
class HyperSnackbarController extends ChangeNotifier {
  HyperSnackbarController({
    HyperMessageMode toastMode = HyperMessageMode.stack,
    HyperMessageMode snackbarMode = HyperMessageMode.queue,
    int maxVisible = 3,
  }) : _maxVisible = maxVisible {
    if (maxVisible < 1) throw ArgumentError.value(maxVisible, 'maxVisible');
    _toastMode = toastMode;
    _snackbarMode = snackbarMode;
  }
  final List<HyperMessageRequest> _requests = [];
  final Set<HyperMessageRequest> _active = {};
  bool _disposed = false;
  Object? _owner;
  late HyperMessageMode _toastMode;
  late HyperMessageMode _snackbarMode;
  int _maxVisible;
  HyperMessageMode get toastMode => _toastMode;
  HyperMessageMode get snackbarMode => _snackbarMode;
  int get maxVisible => _maxVisible;
  HyperMessageRequest? get current => visible.isEmpty ? null : visible.first;
  int get pendingCount => _requests.length;

  /// 包括尚在退出的可见项；退出项不挡住实时 stack 的新提示。
  List<HyperMessageRequest> get visible =>
      List.unmodifiable(_requests.where(_active.contains));
  int get waitingCount => _requests.length - _active.length;

  /// 宿主配置默认模式；已创建请求保留原模式。名额上限立即生效。
  void configure({
    required HyperMessageMode toastMode,
    required HyperMessageMode snackbarMode,
    required int maxVisible,
  }) {
    if (_disposed) throw StateError('提示队列已经销毁。');
    if (maxVisible < 1) throw ArgumentError.value(maxVisible, 'maxVisible');
    if (_toastMode == toastMode &&
        _snackbarMode == snackbarMode &&
        _maxVisible == maxVisible) {
      return;
    }
    _toastMode = toastMode;
    _snackbarMode = snackbarMode;
    _maxVisible = maxVisible;
    for (final toast in [true, false]) {
      final live = _live(toast);
      while (live.length > maxVisible) {
        _retire(live.removeAt(0));
      }
    }
    _promote();
    notifyListeners();
  }

  HyperMessageHandle show({
    required Widget content,
    bool toast = false,
    HyperMessageMode? mode,
    Duration duration = const Duration(seconds: 3),
    Widget? icon,
    Widget? action,
    String? semanticLabel,
    HyperMessageStyle? style,
  }) {
    if (_disposed) throw StateError('提示队列已经销毁。');
    if (duration.isNegative) throw ArgumentError.value(duration, 'duration');
    if (toast && action != null) {
      throw ArgumentError('Toast 不提供交互操作，请使用 Snackbar。');
    }
    late HyperMessageRequest request;
    final handle = HyperMessageHandle._((reason) => _close(request, reason));
    request = HyperMessageRequest._(
      content: content,
      toast: toast,
      mode: mode ?? (toast ? _toastMode : _snackbarMode),
      duration: duration,
      icon: icon,
      action: action,
      semanticLabel: semanticLabel,
      style: style,
      handle: handle,
    );
    _requests.add(request);
    if (request.mode == HyperMessageMode.stack) {
      final live = _live(toast);
      while (live.length >= _maxVisible) {
        _retire(live.removeAt(0));
      }
      _active.add(request);
    } else {
      _promote();
    }
    notifyListeners();
    return handle;
  }

  List<HyperMessageRequest> _live(bool toast) => _requests
      .where(
        (request) =>
            request.toast == toast &&
            _active.contains(request) &&
            request._reason == null,
      )
      .toList();

  void _retire(HyperMessageRequest request) {
    request._reason ??= HyperMessageCloseReason.superseded;
    // 尚未绘制的突发提示直接完成，避免积累大量无意义的退出动画。
    if (!request._presented) _finish(request);
  }

  void _promote() {
    final blocked = <bool>{};
    for (final request in _requests) {
      if (_active.contains(request) || blocked.contains(request.toast)) {
        continue;
      }
      final occupied = _active
          .where((entry) => entry.toast == request.toast)
          .length;
      final capacity = request.mode == HyperMessageMode.queue ? 1 : _maxVisible;
      if (occupied < capacity) {
        _active.add(request);
      } else {
        blocked.add(request.toast);
      }
    }
  }

  void _close(HyperMessageRequest request, HyperMessageCloseReason reason) {
    if (!_requests.contains(request) || request._reason != null) return;
    request._reason = reason;
    if (!_active.contains(request)) _finish(request);
    notifyListeners();
  }

  /// 宿主实际创建呈现单元时登记，区分未绘制项与正在退出项。
  void markPresented(HyperMessageRequest request) {
    if (_active.contains(request)) request._presented = true;
  }

  void _finish(HyperMessageRequest request) {
    _active.remove(request);
    _requests.remove(request);
    request.handle._completion.complete(request._reason!);
  }

  /// 单项退出结束后释放名额，推进相应类型的等待队列。
  void complete(HyperMessageRequest request) {
    if (!_active.contains(request) || request._reason == null) return;
    _finish(request);
    _promote();
    notifyListeners();
  }

  void clear() {
    for (final request in _requests.toList()) {
      _close(request, HyperMessageCloseReason.dismissed);
    }
  }

  void attach(Object owner) {
    if (_disposed) throw StateError('提示队列已经销毁。');
    if (_owner != null && _owner != owner) throw StateError('一个提示队列只能连接一个宿主。');
    _owner = owner;
  }

  void detach(Object owner) {
    if (_owner != owner) return;
    _owner = null;
    _finishAll();
    if (!_disposed) notifyListeners();
  }

  void _finishAll() {
    for (final request in _requests) {
      request.handle._completion.complete(HyperMessageCloseReason.hostDisposed);
    }
    _requests.clear();
    _active.clear();
  }

  @override
  void dispose() {
    if (_owner != null) throw StateError('请先移除宿主，再销毁外部提示队列。');
    _finishAll();
    _disposed = true;
    super.dispose();
  }
}
