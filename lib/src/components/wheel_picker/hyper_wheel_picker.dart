import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_wheel_picker_style.dart';
import 'hyper_wheel_picker_theme.dart';

/// 单列、受控的滚轮选择器；多列联动和确认提交由父组件管理。
///
/// [value] 不在 [items] 中或为空时展示第一项，但不自动提交。
/// 滚动经过一项时触发 [onChanged]，吸附停止后触发 [onChangeEnd]。
/// 空列表展示空滚轮，无回调；重复值无法唯一定位，应由调用方避免。
class HyperWheelPicker<T> extends StatefulWidget {
  const HyperWheelPicker({
    super.key,
    required this.items,
    required this.value,
    required this.labelBuilder,
    required this.onChanged,
    this.onChangeEnd,
    this.enabled = true,
    this.looping = false,
    this.visibleItemCount = 5,
    this.style,
    this.selectionOverlayBuilder,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
  }) : assert(visibleItemCount > 0 && visibleItemCount % 2 == 1);

  final List<T> items;
  final T? value;
  final String Function(T) labelBuilder;
  final ValueChanged<T>? onChanged, onChangeEnd;
  final bool enabled, looping;
  final int visibleItemCount;
  final HyperWheelPickerStyle? style;
  final Widget Function(BuildContext context, double itemExtent)?
  selectionOverlayBuilder;
  final FocusNode? focusNode;
  final bool autofocus;
  final String? semanticLabel;

  @override
  State<HyperWheelPicker<T>> createState() => _HyperWheelPickerState<T>();
}

class _HyperWheelPickerState<T> extends State<HyperWheelPicker<T>> {
  late final FixedExtentScrollController _controller;
  final FocusNode _focusNode = FocusNode();
  late int _selected;
  bool _synchronizing = false;
  bool _changed = false;
  bool _focused = false;
  bool _pointerInteraction = false;
  double? _lastExtent;
  double? _wheelTarget;
  int _generation = 0;
  bool get _enabled =>
      widget.enabled && widget.onChanged != null && widget.items.isNotEmpty;
  int get _valueIndex =>
      math.max(0, widget.items.indexWhere((v) => v == widget.value));
  HyperWheelPickerStyle get _style =>
      HyperWheelPickerTheme.of(context).style.merge(widget.style);

  @override
  void initState() {
    super.initState();
    _selected = _valueIndex;
    _controller = FixedExtentScrollController(initialItem: _selected);
  }

  @override
  void didUpdateWidget(HyperWheelPicker<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!listEquals(oldWidget.items, widget.items) ||
        oldWidget.value != widget.value ||
        oldWidget.looping != widget.looping ||
        (oldWidget.onChanged != null && widget.onChanged == null) ||
        (oldWidget.enabled && !widget.enabled)) {
      final index = _valueIndex;
      if (index != _selected ||
          !listEquals(oldWidget.items, widget.items) ||
          oldWidget.looping != widget.looping ||
          !_enabled) {
        _selected = index;
        _synchronize(index);
      }
    }
  }

  void _synchronize(int index) {
    _wheelTarget = null;
    _changed = false;
    _synchronizing = true;
    final generation = ++_generation;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || generation != _generation) return;
      if (_controller.hasClients) _controller.jumpToItem(index);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && generation == _generation) _synchronizing = false;
      });
      WidgetsBinding.instance.scheduleFrame();
    });
  }

  int _rawTarget(int index) {
    if (!widget.looping || !_controller.hasClients) return index;
    final current = _controller.selectedItem;
    final count = widget.items.length;
    var delta = (index - current) % count;
    if (delta > count / 2) delta -= count;
    return current + delta;
  }

  void _moveTo(int rawIndex) {
    if (!_enabled || !_controller.hasClients) return;
    if (!widget.looping) rawIndex = rawIndex.clamp(0, widget.items.length - 1);
    final theme = HyperTheme.of(context), visual = _style;
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : visual.duration ?? theme.motion.fastDuration;
    if (duration == Duration.zero) {
      _controller.jumpToItem(rawIndex);
    } else {
      _controller.animateToItem(
        rawIndex,
        duration: duration,
        curve: visual.curve ?? theme.motion.fastCurve,
      );
    }
  }

  void _step(int delta) => _moveTo(
    (_controller.hasClients ? _controller.selectedItem : _selected) + delta,
  );

  void _pointerSignal(PointerSignalEvent event) {
    if (event is PointerScrollEvent) _hidePointerFocus();
    if (!_enabled ||
        event is! PointerScrollEvent ||
        event.scrollDelta.dy == 0 ||
        !_controller.hasClients ||
        _lastExtent == null) {
      return;
    }
    // Register below Scrollable in the hit path, so a wheel tick is animated
    // instead of ScrollPosition.pointerScroll's immediate forcePixels + snap.
    GestureBinding.instance.pointerSignalResolver.register(event, (event) {
      final scroll = event as PointerScrollEvent;
      // PointerScrollEvent reports platform-dependent logical pixels, not
      // hardware detents. For a discrete selector use one item per signal;
      // keep an integer destination while consecutive animations retarget.
      var target =
          (_wheelTarget ?? _controller.selectedItem.toDouble()) +
          scroll.scrollDelta.dy.sign;
      if (!widget.looping) {
        target = target.clamp(0.0, widget.items.length - 1.0);
      }
      _wheelTarget = target;
      _moveTo(target.round());
    });
  }

  bool _notification(ScrollNotification notification) {
    if (notification.depth != 0) return false;
    if (notification is ScrollStartNotification &&
        notification.dragDetails != null) {
      _generation++;
      _wheelTarget = null;
      _synchronizing = false;
    }
    if (notification is ScrollEndNotification) _wheelTarget = null;
    if (notification is ScrollEndNotification &&
        _changed &&
        !_synchronizing &&
        _enabled) {
      _changed = false;
      widget.onChangeEnd?.call(widget.items[_selected]);
    }
    return false;
  }

  @override
  void dispose() {
    _generation++;
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context).wheelPicker;
    final visual = _style;
    final base = (theme.textTheme.bodyLarge ?? const TextStyle()).merge(
      visual.textStyle,
    );
    final selected = base.merge(visual.selectedTextStyle);
    final normalColor = !_enabled
        ? visual.disabledColor ?? theme.colors.disabled
        : visual.foregroundColor ??
              visual.textStyle?.color ??
              theme.colors.textSecondary;
    final selectedColor = !_enabled
        ? visual.disabledColor ?? theme.colors.disabled
        : visual.selectedForegroundColor ??
              visual.selectedTextStyle?.color ??
              visual.textStyle?.color ??
              theme.colors.primary;
    final horizontalPadding = math.max(
      0.0,
      visual.horizontalPadding ?? sizes.horizontalPadding,
    );
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : visual.duration ?? theme.motion.fastDuration;
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.constrainWidth(visual.width ?? sizes.width);
        final textWidth = math.max(1.0, width - horizontalPadding * 2);
        var extent = math.max(1.0, visual.itemExtent ?? sizes.itemExtent);
        // Measure both text states with the original (possibly nonlinear) scaler.
        // FixedExtent refers to equal rows, not a fixed text height.
        for (final item in widget.items) {
          for (final textStyle in [base, selected]) {
            final painter = TextPainter(
              text: TextSpan(text: widget.labelBuilder(item), style: textStyle),
              textDirection: Directionality.of(context),
              textScaler: MediaQuery.textScalerOf(context),
              locale: Localizations.maybeLocaleOf(context),
            )..layout(maxWidth: textWidth);
            extent = math.max(extent, painter.height.ceilToDouble());
            painter.dispose();
          }
        }
        if (_lastExtent != null && _lastExtent != extent) {
          _synchronize(_selected);
        }
        _lastExtent = extent;
        final viewportHeight = constraints.constrainHeight(
          extent * widget.visibleItemCount,
        );
        final radius = (visual.selectionRadius ?? sizes.selectionRadius).clamp(
          0.0,
          math.min(width, extent) / 2,
        );
        Widget child = SizedBox(
          width: width,
          height: viewportHeight,
          child: ColoredBox(
            color: visual.backgroundColor ?? Colors.transparent,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned(
                  left: 0,
                  right: 0,
                  height: extent,
                  child: IgnorePointer(
                    child:
                        widget.selectionOverlayBuilder?.call(context, extent) ??
                        AnimatedContainer(
                          duration: duration,
                          curve: visual.curve ?? theme.motion.fastCurve,
                          decoration: BoxDecoration(
                            color:
                                visual.selectionColor ??
                                theme.colors.surfaceMuted,
                            borderRadius: BorderRadius.circular(radius),
                            border:
                                visual.selectionBorder ??
                                (_focused
                                    ? Border.all(color: theme.colors.primary)
                                    : null),
                          ),
                        ),
                  ),
                ),
                IgnorePointer(
                  ignoring: !_enabled,
                  child: NotificationListener<ScrollNotification>(
                    onNotification: _notification,
                    child: ListWheelScrollView.useDelegate(
                      controller: _controller,
                      itemExtent: extent,
                      physics: _enabled
                          ? const FixedExtentScrollPhysics()
                          : const NeverScrollableScrollPhysics(),
                      diameterRatio: visual.diameterRatio ?? 2,
                      perspective: visual.perspective ?? .003,
                      squeeze: visual.squeeze ?? 1,
                      overAndUnderCenterOpacity: visual.unselectedOpacity ?? 1,
                      onSelectedItemChanged: (index) {
                        if (_synchronizing || !_enabled || index == _selected) {
                          return;
                        }
                        setState(() {
                          _selected = index;
                          _changed = true;
                        });
                        widget.onChanged?.call(widget.items[index]);
                      },
                      childDelegate: widget.looping && widget.items.isNotEmpty
                          ? ListWheelChildLoopingListDelegate(
                              children: [
                                for (var i = 0; i < widget.items.length; i++)
                                  _item(
                                    i,
                                    horizontalPadding,
                                    base,
                                    selected,
                                    normalColor,
                                    selectedColor,
                                    duration,
                                  ),
                              ],
                            )
                          : ListWheelChildBuilderDelegate(
                              childCount: widget.items.length,
                              builder: (context, index) => _item(
                                index,
                                horizontalPadding,
                                base,
                                selected,
                                normalColor,
                                selectedColor,
                                duration,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        child = Semantics(
          label: widget.semanticLabel,
          enabled: _enabled,
          value: widget.items.isEmpty ? null : _semanticValue(_selected),
          increasedValue:
              _enabled &&
                  (widget.looping || _selected < widget.items.length - 1)
              ? _semanticValue((_selected + 1) % widget.items.length)
              : null,
          decreasedValue: _enabled && (widget.looping || _selected > 0)
              ? _semanticValue((_selected - 1) % widget.items.length)
              : null,
          onIncrease:
              _enabled &&
                  (widget.looping || _selected < widget.items.length - 1)
              ? () => _step(1)
              : null,
          onDecrease: _enabled && (widget.looping || _selected > 0)
              ? () => _step(-1)
              : null,
          child: ExcludeSemantics(child: child),
        );
        return _WheelPointerRegion(
          onSignal: _pointerSignal,
          child: Listener(
            onPointerDown: (_) => _hidePointerFocus(),
            child: FocusableActionDetector(
              enabled: _enabled,
              onShowFocusHighlight: (value) =>
                  setState(() => _focused = value && !_pointerInteraction),
              child: Focus(
                focusNode: widget.focusNode ?? _focusNode,
                autofocus: widget.autofocus,
                canRequestFocus: _enabled,
                onKeyEvent: (node, event) {
                  if (!_enabled || event is KeyUpEvent) {
                    return KeyEventResult.ignored;
                  }
                  _pointerInteraction = false;
                  if (!_focused) setState(() => _focused = true);
                  if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
                    _step(1);
                  } else if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
                    _step(-1);
                  } else if (event.logicalKey == LogicalKeyboardKey.home) {
                    _moveTo(0);
                  } else if (event.logicalKey == LogicalKeyboardKey.end) {
                    _moveTo(widget.items.length - 1);
                  } else {
                    return KeyEventResult.ignored;
                  }
                  return KeyEventResult.handled;
                },
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }

  void _hidePointerFocus() {
    _pointerInteraction = true;
    if (_focused) setState(() => _focused = false);
  }

  String _semanticValue(int index) {
    final label = widget.labelBuilder(widget.items[index]);
    return label.isEmpty ? '${index + 1}' : label;
  }

  Widget _item(
    int index,
    double padding,
    TextStyle base,
    TextStyle selected,
    Color normalColor,
    Color selectedColor,
    Duration duration,
  ) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: _enabled
        ? () {
            (widget.focusNode ?? _focusNode).requestFocus();
            _moveTo(_rawTarget(index));
          }
        : null,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: duration,
          curve: _style.curve ?? HyperTheme.of(context).motion.fastCurve,
          style: (index == _selected ? selected : base).copyWith(
            color: index == _selected ? selectedColor : normalColor,
          ),
          textAlign: TextAlign.center,
          child: AnimatedScale(
            scale: index == _selected
                ? 1
                : (_style.unselectedScale ?? 1).clamp(0.0, 1.0),
            duration: duration,
            curve: _style.curve ?? HyperTheme.of(context).motion.fastCurve,
            child: Text(widget.labelBuilder(widget.items[index])),
          ),
        ),
      ),
    ),
  );
}

class _WheelPointerRegion extends SingleChildRenderObjectWidget {
  const _WheelPointerRegion({required this.onSignal, required super.child});
  final void Function(PointerSignalEvent) onSignal;
  @override
  RenderObject createRenderObject(BuildContext context) =>
      _WheelPointerRenderBox(onSignal);
  @override
  void updateRenderObject(
    BuildContext context,
    covariant _WheelPointerRenderBox renderObject,
  ) => renderObject.onSignal = onSignal;
}

class _WheelPointerRenderBox extends RenderProxyBox {
  _WheelPointerRenderBox(this.onSignal);
  void Function(PointerSignalEvent) onSignal;
  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (!size.contains(position)) return false;
    // Claim pointer signals before the inner Scrollable while keeping its
    // complete pointer hit path for native drag and tap recognition.
    result.add(BoxHitTestEntry(this, position));
    super.hitTest(result, position: position);
    return true;
  }

  @override
  void handleEvent(PointerEvent event, covariant BoxHitTestEntry entry) {
    if (event is PointerSignalEvent) onSignal(event);
  }
}
