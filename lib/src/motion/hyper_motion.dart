import 'package:flutter/gestures.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../components/menu/hyper_menu_surface.dart';
import '../painting/hyper_box_decoration.dart';
import '../theme/core/hyper_theme.dart';
import 'hyper_lift_style.dart';
import 'hyper_lift_theme.dart';

/// Composable motion effects which leave layout and activation to their child.
///
/// Lift observes pointer/focus events without entering the tap gesture arena.
/// Use a shared [statesController] to drive states from another control. It is
/// owned by the caller; otherwise the wrapper manages its own state controller.
class HyperMotion extends StatefulWidget {
  const HyperMotion.lift({
    super.key,
    required this.child,
    this.enabled = true,
    this.surface,
    this.style,
    this.statesController,
    this.onStateChanged,
  });
  final Widget child;
  final bool enabled;

  /// Whether to paint the wrapper's rectangular shadow surface.
  ///
  /// False retains translation and scale and leaves the child's own shadows
  /// untouched. Null inherits the lift style, whose default is true.
  final bool? surface;
  final HyperLiftStyle? style;
  final WidgetStatesController? statesController;
  final ValueChanged<Set<WidgetState>>? onStateChanged;
  @override
  State<HyperMotion> createState() => _HyperMotionState();
}

/// Resolves offsets from device sizes and timing from the global Motion theme.
HyperLiftStyle resolveHyperLiftStyle(
  BuildContext context, [
  HyperLiftStyle? style,
]) {
  final t = HyperTheme.of(context), m = HyperTheme.sizesOf(context).motionLift;
  return HyperLiftStyle(
    surface: true,
    hoverOffset: m.hoverOffset,
    pressedOffset: m.pressedOffset,
    hoverScale: 1.008,
    pressedScale: .995,
    hoverShadows: resolveHyperMenuSurfaceStyle(
      colors: t.colors,
      radius: m.shadowRadius,
      padding: EdgeInsets.zero,
    ).boxShadow,
    pressedShadows: const [],
    shadowRadius: m.shadowRadius,
    duration: t.motion.standardDuration,
    pressDuration: t.motion.fastDuration,
    curve: t.motion.standardCurve,
    alignment: Alignment.center,
  ).merge(HyperLiftTheme.of(context).style).merge(style);
}

class _HyperMotionState extends State<HyperMotion> {
  late WidgetStatesController _states;
  final _pointers = <int>{};
  bool get _enabled =>
      widget.enabled && !_states.value.contains(WidgetState.disabled);
  void _attach() {
    _states = widget.statesController ?? WidgetStatesController();
    _states.addListener(_changed);
  }

  void _detach() {
    _states.removeListener(_changed);
    if (widget.statesController == null) _states.dispose();
  }

  @override
  void initState() {
    super.initState();
    _attach();
  }

  @override
  void didUpdateWidget(HyperMotion oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.statesController != widget.statesController) {
      _states.removeListener(_changed);
      if (oldWidget.statesController == null) _states.dispose();
      _pointers.clear();
      _attach();
    }
    if (oldWidget.enabled && !widget.enabled) {
      _pointers.clear();
      _states.update(WidgetState.pressed, false);
      _states.update(WidgetState.hovered, false);
    }
  }

  void _changed() {
    if (!mounted) return;
    setState(() {});
    widget.onStateChanged?.call(Set.unmodifiable(_states.value));
  }

  void _update(WidgetState state, bool value) {
    if (_enabled || !value) _states.update(state, value);
  }

  void _release(int pointer) {
    _pointers.remove(pointer);
    _update(WidgetState.pressed, _pointers.isNotEmpty);
  }

  @override
  void dispose() {
    _detach();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = resolveHyperLiftStyle(context, widget.style);
    final surface = widget.surface ?? s.surface!;
    assert(s.hoverScale! > 0 && s.pressedScale! > 0 && s.shadowRadius! >= 0);
    final pressed = _enabled && _states.value.contains(WidgetState.pressed);
    final elevated =
        _enabled &&
        (_states.value.contains(WidgetState.hovered) ||
            _states.value.contains(WidgetState.focused));
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final target = _LiftVisual(
      offset: reduced
          ? Offset.zero
          : pressed
          ? s.pressedOffset!
          : elevated
          ? s.hoverOffset!
          : Offset.zero,
      scale: reduced
          ? 1
          : pressed
          ? s.pressedScale!
          : elevated
          ? s.hoverScale!
          : 1,
      shadows: pressed
          ? s.pressedShadows!
          : elevated
          ? s.hoverShadows!
          : const [],
    );
    return MouseRegion(
      onEnter: (_) => _update(WidgetState.hovered, true),
      onExit: (_) {
        _pointers.clear();
        _update(WidgetState.pressed, false);
        _update(WidgetState.hovered, false);
      },
      child: Listener(
        onPointerDown: (event) {
          if (_enabled && (event.buttons & kPrimaryButton) != 0) {
            _pointers.add(event.pointer);
            _update(WidgetState.pressed, true);
          }
        },
        onPointerUp: (event) => _release(event.pointer),
        onPointerCancel: (event) => _release(event.pointer),
        child: Focus(
          canRequestFocus: false,
          onFocusChange: (focused) => _update(WidgetState.focused, focused),
          child: TweenAnimationBuilder<_LiftVisual>(
            tween: _LiftTween(begin: const _LiftVisual(), end: target),
            duration: reduced
                ? Duration.zero
                : pressed
                ? s.pressDuration!
                : s.duration!,
            curve: s.curve!,
            child: widget.child,
            builder: (context, value, child) => Transform.translate(
              offset: value.offset,
              transformHitTests: false,
              child: Transform.scale(
                scale: value.scale,
                alignment: s.alignment!,
                transformHitTests: false,
                child: DecoratedBox(
                  decoration: HyperBoxDecoration(
                    borderRadius: BorderRadius.circular(s.shadowRadius!),
                    boxShadow: surface ? value.shadows : const [],
                    outerShadowsOnly: true,
                  ),
                  child: child,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LiftVisual {
  const _LiftVisual({
    this.offset = Offset.zero,
    this.scale = 1,
    this.shadows = const [],
  });
  final Offset offset;
  final double scale;
  final List<BoxShadow> shadows;
  @override
  bool operator ==(Object other) =>
      other is _LiftVisual &&
      offset == other.offset &&
      scale == other.scale &&
      listEquals(shadows, other.shadows);
  @override
  int get hashCode => Object.hash(offset, scale, Object.hashAll(shadows));
}

class _LiftTween extends Tween<_LiftVisual> {
  _LiftTween({required super.begin, required super.end});
  @override
  _LiftVisual lerp(double t) => _LiftVisual(
    offset: Offset.lerp(begin!.offset, end!.offset, t)!,
    scale: begin!.scale + (end!.scale - begin!.scale) * t,
    shadows: BoxShadow.lerpList(begin!.shadows, end!.shadows, t)!,
  );
}
