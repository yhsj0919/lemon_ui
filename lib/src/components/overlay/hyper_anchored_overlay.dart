import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/core/hyper_theme.dart';
import '../../theme/motion/hyper_motion_theme.dart';

/// 锚定浮层的触发方式；受控模式可直接传入 [HyperAnchoredOverlay.isOpen]。
enum HyperOverlayTrigger { tap, hover, manual }

/// 浮层的进出场方式；时长和曲线由全局 Motion 主题提供。
enum HyperOverlayTransition { fadeScale, fade }

/// 浮层相对于锚点的首选方向，空间不足时自动翻转并保持在安全区域内。
enum HyperOverlayPlacement {
  bottomStart,
  bottomEnd,
  topStart,
  sideStart,
  sideEnd,
}

/// 根据当前开合状态构建浮层内容；调用 [close] 可主动关闭。
typedef HyperOverlayBuilder = Widget Function(
  BuildContext context,
  VoidCallback close,
);

/// 构建自带点击行为的锚点；调用 toggle 开合浮层。
typedef HyperOverlayAnchorBuilder = Widget Function(
  BuildContext context,
  VoidCallback toggle,
  bool isOpen,
);

/// 自定义进出场动画。animation 从 0（关闭）变化到 1（打开）。
typedef HyperOverlayTransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget child,
);

/// 将任意内容锚定到任意控件，不预设浮层表面样式。
///
/// 默认点击锚点开合；悬停和受控开合适用于侧栏子菜单等场景。
/// 不要求页面使用 HyperScaffold，直接复用最近的 Flutter Overlay。
class HyperAnchoredOverlay extends StatefulWidget {
  const HyperAnchoredOverlay({
    super.key,
    required this.anchor,
    required this.overlayBuilder,
    this.trigger = HyperOverlayTrigger.tap,
    this.placement = HyperOverlayPlacement.bottomStart,
    this.spacing,
    this.transition = HyperOverlayTransition.fadeScale,
    this.transitionBuilder,
    this.isOpen,
    this.onOpenChanged,
    this.anchorPosition,
  }) : anchorBuilder = null;

  /// 使用任意交互控件作为锚点，免于额外管理开合状态。
  const HyperAnchoredOverlay.builder({
    super.key,
    required this.anchorBuilder,
    required this.overlayBuilder,
    this.placement = HyperOverlayPlacement.bottomStart,
    this.spacing,
    this.transition = HyperOverlayTransition.fadeScale,
    this.transitionBuilder,
    this.isOpen,
    this.onOpenChanged,
    this.anchorPosition,
  }) : anchor = null,
       trigger = HyperOverlayTrigger.manual;

  final Widget? anchor;
  final HyperOverlayAnchorBuilder? anchorBuilder;
  final HyperOverlayBuilder overlayBuilder;
  final HyperOverlayTrigger trigger;
  final HyperOverlayPlacement placement;

  /// 锚点和浮层之间的逻辑像素间距。
  final double? spacing;

  /// 内置过渡方式；提供 [transitionBuilder] 时由自定义动画完全替代。
  final HyperOverlayTransition transition;
  final HyperOverlayTransitionBuilder? transitionBuilder;

  /// 非 null 时由调用方控制开合；否则组件自行管理。
  final bool? isOpen;
  final ValueChanged<bool>? onOpenChanged;

  /// 锚点子控件内的局部坐标；右键菜单可在指针处定位。
  final Offset? anchorPosition;

  @override
  State<HyperAnchoredOverlay> createState() => _HyperAnchoredOverlayState();
}

class _HyperAnchoredOverlayState extends State<HyperAnchoredOverlay>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _portal = OverlayPortalController();
  final FocusNode _focusNode = FocusNode();
  final Object _tapGroup = Object();
  Timer? _hoverCloseTimer;
  late final AnimationController _animation = AnimationController(
    vsync: this,
    duration: Duration.zero,
  )..addStatusListener(_onAnimationStatus);
  bool _internalOpen = false;

  bool get _open => widget.isOpen ?? _internalOpen;

  @override
  void initState() {
    super.initState();
    // 首次挂载后再操作 OverlayPortal，避免在构建期间改变浮层树。
    _syncPortalAfterFrame();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final duration = HyperTheme.of(context).motion.durationFor(
      HyperMotionSpeed.fast,
      disableAnimations:
          MediaQuery.maybeOf(context)?.disableAnimations ?? false,
    );
    _animation.duration = duration;
    _animation.reverseDuration = duration;
    if (duration == Duration.zero && _animation.isAnimating) {
      _animation.value = _open ? 1 : 0;
    }
  }

  @override
  void didUpdateWidget(HyperAnchoredOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isOpen != widget.isOpen) _syncPortalAfterFrame();
    if (oldWidget.trigger != widget.trigger) _hoverCloseTimer?.cancel();
  }

  @override
  void dispose() {
    _hoverCloseTimer?.cancel();
    _animation.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _syncPortalAfterFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_open) {
        _portal.show();
        if (_animation.duration == Duration.zero) {
          _animation.value = 1;
        } else {
          _animation.forward();
        }
      } else {
        if (_animation.duration == Duration.zero) {
          _animation.value = 0;
          _portal.hide();
        } else {
          _animation.reverse();
        }
      }
    });
  }

  void _onAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.dismissed && !_open) _portal.hide();
  }

  void _setOpen(bool value) {
    _hoverCloseTimer?.cancel();
    if (_open == value) return;
    if (widget.isOpen == null) setState(() => _internalOpen = value);
    widget.onOpenChanged?.call(value);
    _syncPortalAfterFrame();
  }

  void _scheduleHoverClose() {
    _hoverCloseTimer?.cancel();
    if (widget.trigger != HyperOverlayTrigger.hover || !_open) return;
    _hoverCloseTimer = Timer(HyperTheme.of(context).motion.fastDuration, () {
      if (mounted) _setOpen(false);
    });
  }

  KeyEventResult _onKeyEvent(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (_open && event.logicalKey == LogicalKeyboardKey.escape) {
      _setOpen(false);
      return KeyEventResult.handled;
    }
    if (widget.trigger != HyperOverlayTrigger.manual &&
        (event.logicalKey == LogicalKeyboardKey.enter ||
            event.logicalKey == LogicalKeyboardKey.space)) {
      _setOpen(!_open);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    // 子浮层沿用祖先的点击区域，点击深层菜单时不会提前关闭上层浮层。
    final tapGroup = _HyperOverlayTapGroup.maybeOf(context) ?? _tapGroup;
    final motion = HyperTheme.of(context).motion;
    final opacity = _animation.drive(CurveTween(curve: motion.fastCurve));
    Widget anchor =
        widget.anchorBuilder?.call(context, () {
          _focusNode.requestFocus();
          _setOpen(!_open);
        }, _open) ??
        widget.anchor!;
    if (widget.trigger == HyperOverlayTrigger.tap) {
      anchor = Semantics(
        button: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _focusNode.requestFocus();
            _setOpen(!_open);
          },
          child: anchor,
        ),
      );
    } else if (widget.trigger == HyperOverlayTrigger.hover) {
      anchor = Semantics(
        button: true,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            _focusNode.requestFocus();
            _setOpen(!_open);
          },
          child: MouseRegion(
            onEnter: (_) {
              _hoverCloseTimer?.cancel();
              _setOpen(true);
            },
            onExit: (_) => _scheduleHoverClose(),
            child: anchor,
          ),
        ),
      );
    }

    return PopScope(
      canPop: !_open,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _open) _setOpen(false);
      },
      child: Focus(
        focusNode: _focusNode,
        onKeyEvent: _onKeyEvent,
        onFocusChange: (hasFocus) {
          if (!hasFocus && _open && widget.trigger == HyperOverlayTrigger.tap) {
            _setOpen(false);
          }
        },
        child: OverlayPortal.overlayChildLayoutBuilder(
          controller: _portal,
          overlayChildBuilder: (overlayContext, info) {
            var anchorRect = MatrixUtils.transformRect(
              info.childPaintTransform,
              Offset.zero & info.childSize,
            );
            if (widget.anchorPosition case final position?) {
              final point = MatrixUtils.transformPoint(
                info.childPaintTransform,
                position,
              );
              anchorRect = Rect.fromLTWH(point.dx, point.dy, 0, 0);
            }
            final media = MediaQuery.maybeOf(overlayContext);
            final padding = media?.viewPadding ?? EdgeInsets.zero;
            final insets = media?.viewInsets ?? EdgeInsets.zero;
            final safeBounds = Rect.fromLTRB(
              padding.left,
              padding.top,
              math.max(padding.left, info.overlaySize.width - padding.right),
              math.max(
                padding.top,
                info.overlaySize.height -
                    math.max(padding.bottom, insets.bottom),
              ),
            );
            final content = _HyperOverlayTapGroup(
              groupId: tapGroup,
              child: Builder(
                builder: (context) =>
                    widget.overlayBuilder(context, () => _setOpen(false)),
              ),
            );
            final transition = widget.transitionBuilder;
            final animatedContent = transition != null
                ? transition(overlayContext, _animation, content)
                : FadeTransition(
                    opacity: opacity,
                    child: widget.transition == HyperOverlayTransition.fade
                        ? content
                        : ScaleTransition(
                            scale: Tween<double>(
                              begin: .96,
                              end: 1,
                            ).animate(opacity),
                            alignment: Alignment.topCenter,
                            child: content,
                          ),
                  );
            return CustomSingleChildLayout(
              delegate: _HyperOverlayLayout(
                anchor: anchorRect,
                bounds: safeBounds,
                placement: widget.placement,
                spacing:
                    widget.spacing ??
                    HyperTheme.sizesOf(context).overlaySpacing,
                direction: Directionality.of(overlayContext),
              ),
              child: TapRegion(
                groupId: tapGroup,
                child: IgnorePointer(
                  ignoring: !_open,
                  child: ExcludeSemantics(
                    excluding: !_open,
                    child: MouseRegion(
                      onEnter: (_) => _hoverCloseTimer?.cancel(),
                      onExit: (_) => _scheduleHoverClose(),
                      child: animatedContent,
                    ),
                  ),
                ),
              ),
            );
          },
          child: TapRegion(
            groupId: tapGroup,
            onTapOutside: (_) {
              if (_open) _setOpen(false);
            },
            child: anchor,
          ),
        ),
      ),
    );
  }
}

class _HyperOverlayTapGroup extends InheritedWidget {
  const _HyperOverlayTapGroup({required this.groupId, required super.child});

  final Object groupId;

  static Object? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_HyperOverlayTapGroup>()
      ?.groupId;

  @override
  bool updateShouldNotify(_HyperOverlayTapGroup oldWidget) =>
      groupId != oldWidget.groupId;
}

class _HyperOverlayLayout extends SingleChildLayoutDelegate {
  const _HyperOverlayLayout({
    required this.anchor,
    required this.bounds,
    required this.placement,
    required this.spacing,
    required this.direction,
  });

  final Rect anchor;
  final Rect bounds;
  final HyperOverlayPlacement placement;
  final double spacing;
  final TextDirection direction;

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) =>
      BoxConstraints.loose(
        Size(math.max(0, bounds.width), math.max(0, bounds.height)),
      );

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    final ltr = direction == TextDirection.ltr;
    final start = ltr ? anchor.left : anchor.right - childSize.width;
    final end = ltr ? anchor.right - childSize.width : anchor.left;
    double x;
    double y;
    switch (placement) {
      case HyperOverlayPlacement.bottomStart || HyperOverlayPlacement.bottomEnd:
        x = placement == HyperOverlayPlacement.bottomStart ? start : end;
        final below = bounds.bottom - anchor.bottom - spacing;
        final above = anchor.top - bounds.top - spacing;
        y = below < childSize.height && above > below
            ? anchor.top - childSize.height - spacing
            : anchor.bottom + spacing;
      case HyperOverlayPlacement.topStart:
        x = start;
        final above = anchor.top - bounds.top - spacing;
        final below = bounds.bottom - anchor.bottom - spacing;
        y = above < childSize.height && below > above
            ? anchor.bottom + spacing
            : anchor.top - childSize.height - spacing;
      case HyperOverlayPlacement.sideStart || HyperOverlayPlacement.sideEnd:
        final preferRight = (placement == HyperOverlayPlacement.sideEnd) == ltr;
        final right = bounds.right - anchor.right - spacing;
        final left = anchor.left - bounds.left - spacing;
        final useRight = preferRight
            ? right >= childSize.width || right >= left
            : left < childSize.width && right > left;
        x = useRight
            ? anchor.right + spacing
            : anchor.left - childSize.width - spacing;
        y = anchor.top;
    }
    return Offset(
      x.clamp(
        bounds.left,
        math.max(bounds.left, bounds.right - childSize.width),
      ),
      y.clamp(
        bounds.top,
        math.max(bounds.top, bounds.bottom - childSize.height),
      ),
    );
  }

  @override
  bool shouldRelayout(_HyperOverlayLayout oldDelegate) =>
      anchor != oldDelegate.anchor ||
      bounds != oldDelegate.bounds ||
      placement != oldDelegate.placement ||
      spacing != oldDelegate.spacing ||
      direction != oldDelegate.direction;
}
