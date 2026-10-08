import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_message_surface.dart';
import 'hyper_snackbar_controller.dart';

typedef HyperMessageTransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget child,
);

/// 一个窗口的提示宿主。每条提示独立计时、过渡与暂停。
class HyperSnackbarHost extends StatefulWidget {
  const HyperSnackbarHost({
    super.key,
    required this.child,
    this.controller,
    this.alignment = Alignment.bottomCenter,
    this.padding,
    this.toastMode = HyperMessageMode.stack,
    this.snackbarMode = HyperMessageMode.queue,
    this.maxVisible = 3,
    this.stackSpacing,
    this.transitionBuilder,
  }) : assert(maxVisible > 0),
       assert(stackSpacing == null || stackSpacing >= 0);
  final Widget child;
  final HyperSnackbarController? controller;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final HyperMessageMode toastMode;
  final HyperMessageMode snackbarMode;

  /// 每种类型的名额上限；queue 固定只显示一条。退出项暂时保留至过渡结束。
  final int maxVisible;
  final double? stackSpacing;
  final HyperMessageTransitionBuilder? transitionBuilder;
  static HyperSnackbarController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<_Scope>();
    if (scope == null) {
      throw FlutterError('请在页面外包裹 HyperSnackbarHost，并使用宿主下方的 context。');
    }
    return scope.controller;
  }

  @override
  State<HyperSnackbarHost> createState() => _HyperSnackbarHostState();
}

class _HyperSnackbarHostState extends State<HyperSnackbarHost> {
  final _portal = OverlayPortalController();
  late HyperSnackbarController _controller;
  List<HyperMessageRequest> _visible = [];
  bool _scheduled = false;

  @override
  void initState() {
    super.initState();
    _attach();
    _schedule();
  }

  void _configure() => _controller.configure(
    toastMode: widget.toastMode,
    snackbarMode: widget.snackbarMode,
    maxVisible: widget.maxVisible,
  );
  void _attach() {
    _controller = widget.controller ?? HyperSnackbarController();
    _controller.attach(this);
    _configure();
    _controller.addListener(_schedule);
  }

  void _detach(bool owned) {
    _controller.removeListener(_schedule);
    _controller.detach(this);
    if (owned) _controller.dispose();
  }

  @override
  void didUpdateWidget(HyperSnackbarHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _detach(oldWidget.controller == null);
      _visible = [];
      _portal.hide();
      _attach();
    } else {
      _configure();
    }
    _schedule();
  }

  void _schedule() {
    if (!mounted || _scheduled) return;
    _scheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduled = false;
      if (!mounted) return;
      final previous = _visible.toSet();
      for (final request in _controller.visible) {
        if (!previous.contains(request) && request.closeReason != null) {
          _controller.complete(request);
        }
      }
      setState(() => _visible = _controller.visible);
      if (_visible.isEmpty) {
        _portal.hide();
      } else {
        _portal.show();
      }
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  Widget _overlay(BuildContext context) {
    final alignment = widget.alignment.resolve(Directionality.of(context));
    // 新消息靠近指定边缘：底部新项在下方，顶部新项在上方。
    final entries = alignment.y < 0 ? _visible.reversed.toList() : _visible;
    final crossAxis = alignment.x < 0
        ? CrossAxisAlignment.start
        : alignment.x > 0
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.center;
    return Positioned.fill(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: SafeArea(
          child: Padding(
            padding:
                widget.padding ??
                EdgeInsets.all(
                  HyperTheme.sizesOf(context).pageHorizontalPadding,
                ),
            child: Align(
              alignment: widget.alignment,
              child: IgnorePointer(
                ignoring: entries.every(
                  (entry) => entry.toast || entry.closeReason != null,
                ),
                child: SingleChildScrollView(
                  reverse: alignment.y > 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: crossAxis,
                    children: [
                      for (var i = 0; i < entries.length; i++)
                        _MessageItem(
                          key: ObjectKey(entries[i]),
                          request: entries[i],
                          controller: _controller,
                          transitionBuilder: widget.transitionBuilder,
                          spacing: i == entries.length - 1
                              ? 0
                              : widget.stackSpacing,
                          hasFollowing: i != entries.length - 1,
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _Scope(
    controller: _controller,
    child: OverlayPortal(
      controller: _portal,
      overlayChildBuilder: _overlay,
      child: widget.child,
    ),
  );
  @override
  void dispose() {
    _detach(widget.controller == null);
    super.dispose();
  }
}

/// 单项生命周期：串行和堆叠均走这一条路径，不复用其他提示的计时器。
class _MessageItem extends StatefulWidget {
  const _MessageItem({
    super.key,
    required this.request,
    required this.controller,
    required this.hasFollowing,
    this.spacing,
    this.transitionBuilder,
  });
  final HyperMessageRequest request;
  final HyperSnackbarController controller;
  final bool hasFollowing;
  final double? spacing;
  final HyperMessageTransitionBuilder? transitionBuilder;
  @override
  State<_MessageItem> createState() => _MessageItemState();
}

class _MessageItemState extends State<_MessageItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animation = AnimationController(vsync: this)
    ..addStatusListener(_status);
  CurvedAnimation? _curved;
  Timer? _timer;
  final Stopwatch _elapsed = Stopwatch();
  Duration _remaining = Duration.zero;
  bool _started = false;
  bool _entered = false;
  bool _closing = false;
  bool _completed = false;
  bool _hovered = false;
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    widget.controller.markPresented(widget.request);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final style = resolveMessageStyle(
      context,
      widget.request.toast,
      widget.request.style,
    );
    final reduced = MediaQuery.disableAnimationsOf(context);
    _animation.duration = reduced
        ? Duration.zero
        : style.animationStyle!.duration;
    _animation.reverseDuration = reduced
        ? Duration.zero
        : style.animationStyle!.reverseDuration;
    if (!_started) {
      _started = true;
      _curved = CurvedAnimation(
        parent: _animation,
        curve: style.animationStyle!.curve!,
        reverseCurve: style.animationStyle!.reverseCurve!,
      );
      _remaining = widget.request.duration;
      if (widget.request.closeReason != null) {
        _close();
      } else {
        _animation.forward();
      }
    } else if (reduced && _animation.isAnimating) {
      if (_closing) {
        _animation.reverse();
      } else {
        _animation.forward();
      }
    }
    _updateTimer();
  }

  @override
  void didUpdateWidget(_MessageItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.request.closeReason != null) _close();
  }

  void _status(AnimationStatus status) {
    if (status == AnimationStatus.completed && !_closing) {
      _entered = true;
      _updateTimer();
    }
    if (status == AnimationStatus.dismissed && _closing) _complete();
  }

  void _complete() {
    if (_completed) return;
    _completed = true;
    // 完成可能发生在零时长动画或依赖更新期间，避免在构建中通知祖先。
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) widget.controller.complete(widget.request);
    });
    WidgetsBinding.instance.ensureVisualUpdate();
  }

  void _close() {
    if (_closing) return;
    _closing = true;
    _timer?.cancel();
    _elapsed.stop();
    if (_animation.isDismissed) {
      _complete();
    } else {
      _animation.reverse();
    }
  }

  void _updateTimer() {
    _timer?.cancel();
    if (_elapsed.isRunning) {
      _remaining -= _elapsed.elapsed;
      _elapsed.stop();
      _elapsed.reset();
    }
    final request = widget.request;
    if (!_entered ||
        _closing ||
        request.closeReason != null ||
        request.duration == Duration.zero) {
      return;
    }
    if (_hovered ||
        _focused ||
        (request.action != null &&
            MediaQuery.accessibleNavigationOf(context))) {
      return;
    }
    _elapsed.start();
    _timer = Timer(
      _remaining.isNegative ? Duration.zero : _remaining,
      () => request.handle.close(HyperMessageCloseReason.timeout),
    );
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;
    final style = resolveMessageStyle(context, request.toast, request.style);
    final body = HyperMessageSurface(
      content: request.content,
      icon: request.icon,
      action: request.action,
      semanticLabel: request.semanticLabel,
      style: style,
    );
    return SizeTransition(
      sizeFactor: _curved!,
      alignment: Alignment.topLeft,
      child: Padding(
        padding: EdgeInsets.only(
          bottom: widget.hasFollowing ? (widget.spacing ?? style.spacing!) : 0,
        ),
        child: IgnorePointer(
          ignoring: request.toast || request.closeReason != null,
          child: MouseRegion(
            onEnter: (_) {
              _hovered = true;
              _updateTimer();
            },
            onExit: (_) {
              _hovered = false;
              _updateTimer();
            },
            child: Focus(
              onFocusChange: (focused) {
                _focused = focused;
                _updateTimer();
              },
              child: AnimatedBuilder(
                animation: _animation,
                child: body,
                builder: (context, child) {
                  if (widget.transitionBuilder != null) {
                    return widget.transitionBuilder!(
                      context,
                      _animation,
                      child!,
                    );
                  }
                  final value = _curved!.value;
                  return Opacity(
                    opacity: value.clamp(0, 1),
                    child: FractionalTranslation(
                      translation: style.entryOffset! * (1 - value),
                      child: child,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _curved?.dispose();
    _animation.dispose();
    super.dispose();
  }
}

class _Scope extends InheritedWidget {
  const _Scope({required this.controller, required super.child});
  final HyperSnackbarController controller;
  @override
  bool updateShouldNotify(_Scope oldWidget) =>
      oldWidget.controller != controller;
}
