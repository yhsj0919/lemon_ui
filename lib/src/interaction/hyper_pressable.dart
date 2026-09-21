import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../foundation/hyper_control_state.dart';

typedef HyperPressableBuilder = Widget Function(
  BuildContext context,
  Set<HyperControlState> states,
  Widget? child,
);

/// 无固定视觉的统一交互底座。
///
/// 仅组合 Flutter 原生手势、悬停、焦点、动作和语义能力。视觉由 [builder]
/// 根据状态自由构建。
class HyperPressable extends StatefulWidget {
  const HyperPressable({
    super.key,
    required this.builder,
    this.child,
    this.enabled = true,
    this.states = const {},
    this.onStatesChanged,
    this.onTap,
    this.onTapDown,
    this.onTapUp,
    this.onTapCancel,
    this.onDoubleTap,
    this.onDoubleTapDown,
    this.onDoubleTapCancel,
    this.onLongPress,
    this.onLongPressDown,
    this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressUp,
    this.onLongPressEnd,
    this.onLongPressCancel,
    this.onSecondaryTap,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onTertiaryTapDown,
    this.onTertiaryTapUp,
    this.onTertiaryTapCancel,
    this.onPanDown,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
    this.onHover,
    this.onEnter,
    this.onExit,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.mouseCursor = MouseCursor.defer,
    this.behavior = HitTestBehavior.opaque,
    this.enableFeedback = true,
    this.semanticLabel,
    this.semanticButton = true,
    this.excludeFromSemantics = false,
  });

  /// 根据当前控件状态构建视觉内容。
  final HyperPressableBuilder builder;

  /// 原样传给 [builder] 的可选子节点。
  final Widget? child;

  /// 是否响应手势、焦点和键盘激活。
  final bool enabled;

  /// 由调用方提供的附加状态。
  final Set<HyperControlState> states;

  /// 最终状态集合发生变化时调用。
  final ValueChanged<Set<HyperControlState>>? onStatesChanged;

  /// 主按钮单击回调。
  final GestureTapCallback? onTap;

  /// 主按钮按下回调。
  final GestureTapDownCallback? onTapDown;

  /// 主按钮抬起回调。
  final GestureTapUpCallback? onTapUp;

  /// 主按钮点击取消回调。
  final GestureTapCancelCallback? onTapCancel;

  /// 双击回调。
  final GestureTapCallback? onDoubleTap;

  /// 双击首次按下回调。
  final GestureTapDownCallback? onDoubleTapDown;

  /// 双击取消回调。
  final GestureTapCancelCallback? onDoubleTapCancel;

  /// 长按确认回调。
  final GestureLongPressCallback? onLongPress;

  /// 长按手势按下回调。
  final GestureLongPressDownCallback? onLongPressDown;

  /// 长按开始回调。
  final GestureLongPressStartCallback? onLongPressStart;

  /// 长按移动回调。
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;

  /// 长按抬起回调。
  final GestureLongPressUpCallback? onLongPressUp;

  /// 长按结束回调。
  final GestureLongPressEndCallback? onLongPressEnd;

  /// 长按取消回调。
  final GestureLongPressCancelCallback? onLongPressCancel;

  /// 鼠标右键单击回调。
  final GestureTapCallback? onSecondaryTap;

  /// 鼠标右键按下回调。
  final GestureTapDownCallback? onSecondaryTapDown;

  /// 鼠标右键抬起回调。
  final GestureTapUpCallback? onSecondaryTapUp;

  /// 鼠标右键取消回调。
  final GestureTapCancelCallback? onSecondaryTapCancel;

  /// 鼠标中键按下回调。
  final GestureTapDownCallback? onTertiaryTapDown;

  /// 鼠标中键抬起回调。
  final GestureTapUpCallback? onTertiaryTapUp;

  /// 鼠标中键取消回调。
  final GestureTapCancelCallback? onTertiaryTapCancel;

  /// 平移手势按下回调。
  final GestureDragDownCallback? onPanDown;

  /// 平移手势开始回调。
  final GestureDragStartCallback? onPanStart;

  /// 平移手势更新回调。
  final GestureDragUpdateCallback? onPanUpdate;

  /// 平移手势结束回调。
  final GestureDragEndCallback? onPanEnd;

  /// 平移手势取消回调。
  final GestureDragCancelCallback? onPanCancel;

  /// 指针在区域内移动时调用。
  final PointerHoverEventListener? onHover;

  /// 指针进入区域时调用。
  final PointerEnterEventListener? onEnter;

  /// 指针离开区域时调用。
  final PointerExitEventListener? onExit;

  /// 键盘焦点变化时调用。
  final ValueChanged<bool>? onFocusChange;

  /// 外部管理的焦点节点。
  final FocusNode? focusNode;

  /// 首次显示时是否自动获取焦点。
  final bool autofocus;

  /// 启用状态下使用的鼠标指针。
  final MouseCursor mouseCursor;

  /// 手势命中测试方式。
  final HitTestBehavior behavior;

  /// 是否触发平台点击和长按反馈。
  final bool enableFeedback;

  /// 屏幕阅读器使用的语义标签。
  final String? semanticLabel;

  /// 是否向语义树声明为按钮。
  final bool semanticButton;

  /// 是否从手势识别器的语义处理中排除。
  final bool excludeFromSemantics;

  @override
  State<HyperPressable> createState() => _HyperPressableState();
}

class _HyperPressableState extends State<HyperPressable> {
  final Set<HyperControlState> _internalStates = {};

  bool get _hasPrimaryGesture =>
      widget.onTap != null ||
      widget.onTapDown != null ||
      widget.onTapUp != null ||
      widget.onTapCancel != null ||
      widget.onDoubleTap != null ||
      widget.onLongPress != null ||
      widget.onLongPressStart != null;

  bool get _hasSecondaryGesture =>
      widget.onSecondaryTap != null ||
      widget.onSecondaryTapDown != null ||
      widget.onSecondaryTapUp != null ||
      widget.onSecondaryTapCancel != null;

  bool get _hasLongPressGesture =>
      widget.onLongPress != null ||
      widget.onLongPressDown != null ||
      widget.onLongPressStart != null ||
      widget.onLongPressMoveUpdate != null ||
      widget.onLongPressUp != null ||
      widget.onLongPressEnd != null ||
      widget.onLongPressCancel != null;

  bool get _hasTertiaryGesture =>
      widget.onTertiaryTapDown != null ||
      widget.onTertiaryTapUp != null ||
      widget.onTertiaryTapCancel != null;

  bool get _hasPanGesture =>
      widget.onPanDown != null ||
      widget.onPanStart != null ||
      widget.onPanUpdate != null ||
      widget.onPanEnd != null ||
      widget.onPanCancel != null;

  Set<HyperControlState> get _resolvedStates {
    final result = {...widget.states, ..._internalStates};
    if (!widget.enabled) result.add(HyperControlState.disabled);
    return Set.unmodifiable(result);
  }

  void _setState(HyperControlState state, bool active) {
    if (!widget.enabled) return;
    final changed = active
        ? _internalStates.add(state)
        : _internalStates.remove(state);
    if (!changed) return;
    setState(() {});
    widget.onStatesChanged?.call(_resolvedStates);
  }

  void _clearTransientStates() {
    final before = _internalStates.length;
    _internalStates.removeAll({
      HyperControlState.pressed,
      HyperControlState.secondaryPressed,
      HyperControlState.tertiaryPressed,
      HyperControlState.longPressed,
      HyperControlState.dragged,
    });
    if (_internalStates.length == before) return;
    setState(() {});
    widget.onStatesChanged?.call(_resolvedStates);
  }

  void _activate() {
    if (!widget.enabled || widget.onTap == null) return;
    if (widget.enableFeedback) Feedback.forTap(context);
    widget.onTap!();
  }

  @override
  void didUpdateWidget(HyperPressable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled && !widget.enabled) _clearTransientStates();
  }

  @override
  Widget build(BuildContext context) {
    final states = _resolvedStates;
    Widget result = widget.builder(context, states, widget.child);

    result = GestureDetector(
      behavior: widget.behavior,
      excludeFromSemantics: widget.excludeFromSemantics,
      onTap: widget.enabled && widget.onTap != null ? _activate : null,
      onTapDown: widget.enabled && _hasPrimaryGesture
          ? (details) {
              _setState(HyperControlState.pressed, true);
              widget.onTapDown?.call(details);
            }
          : null,
      onTapUp: widget.enabled && _hasPrimaryGesture
          ? (details) {
              _setState(HyperControlState.pressed, false);
              widget.onTapUp?.call(details);
            }
          : null,
      onTapCancel: widget.enabled && _hasPrimaryGesture
          ? () {
              _setState(HyperControlState.pressed, false);
              widget.onTapCancel?.call();
            }
          : null,
      onDoubleTap: widget.enabled && widget.onDoubleTap != null
          ? () {
              if (widget.enableFeedback) Feedback.forTap(context);
              widget.onDoubleTap?.call();
            }
          : null,
      onDoubleTapDown: widget.enabled ? widget.onDoubleTapDown : null,
      onDoubleTapCancel: widget.enabled ? widget.onDoubleTapCancel : null,
      onLongPressDown: widget.enabled && _hasLongPressGesture
          ? widget.onLongPressDown
          : null,
      onLongPressStart: widget.enabled && _hasLongPressGesture
          ? (details) {
              _setState(HyperControlState.longPressed, true);
              widget.onLongPressStart?.call(details);
            }
          : null,
      onLongPress: widget.enabled && widget.onLongPress != null
          ? () {
              if (widget.enableFeedback) Feedback.forLongPress(context);
              widget.onLongPress?.call();
            }
          : null,
      onLongPressMoveUpdate: widget.enabled && _hasLongPressGesture
          ? widget.onLongPressMoveUpdate
          : null,
      onLongPressUp: widget.enabled && _hasLongPressGesture
          ? () {
              _setState(HyperControlState.longPressed, false);
              _setState(HyperControlState.pressed, false);
              widget.onLongPressUp?.call();
            }
          : null,
      onLongPressEnd: widget.enabled && _hasLongPressGesture
          ? (details) {
              _setState(HyperControlState.longPressed, false);
              _setState(HyperControlState.pressed, false);
              widget.onLongPressEnd?.call(details);
            }
          : null,
      onLongPressCancel: widget.enabled && _hasLongPressGesture
          ? () {
              _setState(HyperControlState.longPressed, false);
              _setState(HyperControlState.pressed, false);
              widget.onLongPressCancel?.call();
            }
          : null,
      onSecondaryTap: widget.enabled ? widget.onSecondaryTap : null,
      onSecondaryTapDown: widget.enabled && _hasSecondaryGesture
          ? (details) {
              _setState(HyperControlState.secondaryPressed, true);
              widget.onSecondaryTapDown?.call(details);
            }
          : null,
      onSecondaryTapUp: widget.enabled && _hasSecondaryGesture
          ? (details) {
              _setState(HyperControlState.secondaryPressed, false);
              widget.onSecondaryTapUp?.call(details);
            }
          : null,
      onSecondaryTapCancel: widget.enabled && _hasSecondaryGesture
          ? () {
              _setState(HyperControlState.secondaryPressed, false);
              widget.onSecondaryTapCancel?.call();
            }
          : null,
      onTertiaryTapDown: widget.enabled && _hasTertiaryGesture
          ? (details) {
              _setState(HyperControlState.tertiaryPressed, true);
              widget.onTertiaryTapDown?.call(details);
            }
          : null,
      onTertiaryTapUp: widget.enabled && _hasTertiaryGesture
          ? (details) {
              _setState(HyperControlState.tertiaryPressed, false);
              widget.onTertiaryTapUp?.call(details);
            }
          : null,
      onTertiaryTapCancel: widget.enabled && _hasTertiaryGesture
          ? () {
              _setState(HyperControlState.tertiaryPressed, false);
              widget.onTertiaryTapCancel?.call();
            }
          : null,
      onPanDown: widget.enabled && _hasPanGesture ? widget.onPanDown : null,
      onPanStart: widget.enabled && _hasPanGesture
          ? (details) {
              _setState(HyperControlState.dragged, true);
              widget.onPanStart?.call(details);
            }
          : null,
      onPanUpdate: widget.enabled && _hasPanGesture ? widget.onPanUpdate : null,
      onPanEnd: widget.enabled && _hasPanGesture
          ? (details) {
              _setState(HyperControlState.dragged, false);
              widget.onPanEnd?.call(details);
            }
          : null,
      onPanCancel: widget.enabled && _hasPanGesture
          ? () {
              _setState(HyperControlState.dragged, false);
              widget.onPanCancel?.call();
            }
          : null,
      child: result,
    );

    result = FocusableActionDetector(
      enabled: widget.enabled,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus,
      mouseCursor: widget.enabled
          ? widget.mouseCursor
          : SystemMouseCursors.basic,
      onShowHoverHighlight: (value) {
        _setState(HyperControlState.hovered, value);
      },
      onShowFocusHighlight: (value) {
        _setState(HyperControlState.focused, value);
        widget.onFocusChange?.call(value);
      },
      actions: widget.onTap == null
          ? const {}
          : <Type, Action<Intent>>{
              ActivateIntent: CallbackAction<ActivateIntent>(
                onInvoke: (_) {
                  _activate();
                  return null;
                },
              ),
            },
      child: MouseRegion(
        onHover: widget.onHover,
        onEnter: (event) {
          if (widget.enabled) _setState(HyperControlState.hovered, true);
          widget.onEnter?.call(event);
        },
        onExit: (event) {
          _setState(HyperControlState.hovered, false);
          widget.onExit?.call(event);
        },
        child: result,
      ),
    );

    return Semantics(
      enabled: widget.enabled,
      button: widget.semanticButton,
      label: widget.semanticLabel,
      child: result,
    );
  }
}
