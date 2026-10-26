import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_resizable_style.dart';
import 'hyper_resizable_theme.dart';

class HyperResizableController extends ChangeNotifier {
  HyperResizableController({List<double>? weights}) {
    if (weights != null) _weights = _validated(weights);
  }
  List<double>? _weights;
  final Set<int> _collapsed = {};
  List<double>? get weights =>
      _weights == null ? null : List.unmodifiable(_weights!);
  Set<int> get collapsed => Set.unmodifiable(_collapsed);
  static List<double> _validated(List<double> values) {
    if (values.isEmpty ||
        values.any((v) => !v.isFinite || v < 0) ||
        values.every((v) => v == 0)) {
      throw ArgumentError('分栏权重须有限、非负且至少一个大于零');
    }
    return List.of(values);
  }

  void setWeights(List<double> values) {
    _weights = _validated(values);
    notifyListeners();
  }

  void setCollapsed(int index, bool value) {
    if (index < 0) throw RangeError.index(index, _weights ?? []);
    if (value ? _collapsed.add(index) : _collapsed.remove(index)) {
      notifyListeners();
    }
  }
}

@immutable
class HyperResizablePane {
  HyperResizablePane({
    required this.child,
    this.initialFlex = 1,
    this.minimumExtent = 0,
    this.maximumExtent = double.infinity,
    this.collapsible = false,
    this.collapsedExtent = 0,
  }) {
    if (!initialFlex.isFinite ||
        initialFlex <= 0 ||
        !minimumExtent.isFinite ||
        minimumExtent < 0 ||
        maximumExtent.isNaN ||
        maximumExtent < minimumExtent ||
        !collapsedExtent.isFinite ||
        collapsedExtent < 0 ||
        collapsedExtent > maximumExtent) {
      throw ArgumentError('分栏尺寸约束无效');
    }
  }
  final Widget child;
  final double initialFlex, minimumExtent, maximumExtent, collapsedExtent;
  final bool collapsible;
}

/// Constrained horizontal/vertical panes. Parent supplies finite width and height.
/// If minima exceed available space, the group scrolls instead of violating them.
class HyperResizable extends StatefulWidget {
  HyperResizable({
    super.key,
    required List<HyperResizablePane> panes,
    this.controller,
    this.direction = Axis.horizontal,
    this.enabled = true,
    this.onResize,
    this.style,
    this.handleBuilder,
    this.semanticLabel = '调整分栏',
  }) : panes = List.unmodifiable(panes) {
    if (panes.length < 2) throw ArgumentError('至少需要两个分栏');
  }
  final List<HyperResizablePane> panes;
  final HyperResizableController? controller;
  final Axis direction;
  final bool enabled;
  final ValueChanged<List<double>>? onResize;
  final HyperResizableStyle? style;
  final Widget Function(BuildContext context, int index, bool active)?
  handleBuilder;
  final String semanticLabel;
  @override
  State<HyperResizable> createState() => _HyperResizableState();
}

class _HyperResizableState extends State<HyperResizable> {
  late final _owned = HyperResizableController();
  HyperResizableController get controller => widget.controller ?? _owned;
  int? _active, _hover, _focused;
  final _handles = <int, FocusNode>{};
  void finishPointerResize(int index) {
    _handles[index]?.unfocus();
    setState(() {
      _active = null;
      _hover = null;
      _focused = null;
    });
  }

  @override
  void initState() {
    super.initState();
    controller.addListener(changed);
  }

  void changed() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(covariant HyperResizable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _owned).removeListener(changed);
      controller.addListener(changed);
    }
    if (oldWidget.panes.length != widget.panes.length &&
        widget.controller == null) {
      _owned._weights = null;
      _owned._collapsed.clear();
    }
  }

  @override
  void dispose() {
    for (final node in _handles.values) {
      node.dispose();
    }
    controller.removeListener(changed);
    _owned.dispose();
    super.dispose();
  }

  bool collapsed(int i) =>
      widget.panes[i].collapsible && controller.collapsed.contains(i);
  List<double> allocate(double available, List<double> weights) {
    final result = List.generate(
      widget.panes.length,
      (i) => collapsed(i)
          ? widget.panes[i].collapsedExtent
          : widget.panes[i].minimumExtent,
    );
    var remaining = available - result.fold(0.0, (a, b) => a + b);
    var open = {
      for (var i = 0; i < result.length; i++)
        if (!collapsed(i) && result[i] < widget.panes[i].maximumExtent) i,
    };
    while (remaining > .0001 && open.isNotEmpty) {
      final total = open.fold(0.0, (v, i) => v + weights[i]);
      final budget = remaining;
      var used = 0.0;
      for (final i in open) {
        final share = total == 0
            ? budget / open.length
            : budget * weights[i] / total;
        final add = math.min(share, widget.panes[i].maximumExtent - result[i]);
        result[i] += add;
        used += add;
      }
      remaining -= used;
      if (used < .0001) break;
      open.removeWhere(
        (i) => result[i] >= widget.panes[i].maximumExtent - .0001,
      );
    }
    return result;
  }

  void resize(int index, double delta, List<double> current) {
    if (!widget.enabled || collapsed(index) || collapsed(index + 1)) return;
    final left = widget.panes[index], right = widget.panes[index + 1];
    final lower = math.max(
      left.minimumExtent - current[index],
      current[index + 1] - right.maximumExtent,
    );
    final upper = math.min(
      left.maximumExtent - current[index],
      current[index + 1] - right.minimumExtent,
    );
    if (lower > upper) return;
    final amount = delta.clamp(lower, upper);
    if (amount == 0) return;
    final next = List<double>.of(current);
    next[index] += amount;
    next[index + 1] -= amount;
    // Allocation distributes surplus above minima, so save surplus weights.
    final weights = List.generate(
      next.length,
      (i) => collapsed(i)
          ? (controller.weights?[i] ?? widget.panes[i].initialFlex)
          : math.max(0.0, next[i] - widget.panes[i].minimumExtent),
    );
    if (weights.every((v) => v == 0)) return;
    controller.setWeights(weights);
    widget.onResize?.call(List.unmodifiable(next));
  }

  void toggle(int index) {
    if (!widget.enabled) return;
    final pane = widget.panes[index].collapsible ? index : index + 1;
    if (widget.panes[pane].collapsible) {
      controller.setCollapsed(pane, !collapsed(pane));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context), sizes = HyperTheme.sizesOf(context);
    final style = HyperResizableTheme.of(context).style.merge(widget.style);
    final handle = math.max(
      style.thickness ?? sizes.divider.thickness,
      style.handleExtent ?? sizes.form.gap,
    );
    final weights =
        controller.weights ?? widget.panes.map((p) => p.initialFlex).toList();
    if (weights.length != widget.panes.length) {
      throw ArgumentError('分栏控制器权重数量必须匹配 panes');
    }
    return LayoutBuilder(
      builder: (_, constraints) {
        if (!constraints.hasBoundedWidth || !constraints.hasBoundedHeight) {
          throw FlutterError('HyperResizable 需要有限宽高');
        }
        final horizontal = widget.direction == Axis.horizontal;
        final rtl =
            horizontal && Directionality.of(context) == TextDirection.rtl;
        final extent = horizontal
            ? constraints.maxWidth
            : constraints.maxHeight;
        final minima = List.generate(
          widget.panes.length,
          (i) => collapsed(i)
              ? widget.panes[i].collapsedExtent
              : widget.panes[i].minimumExtent,
        ).fold(0.0, (a, b) => a + b);
        final total = math.max(
          extent,
          minima + handle * (widget.panes.length - 1),
        );
        final allocated = allocate(
          total - handle * (widget.panes.length - 1),
          weights,
        );

        final children = <Widget>[];
        for (var i = 0; i < widget.panes.length; i++) {
          children.add(
            SizedBox(
              width: horizontal ? allocated[i] : null,
              height: horizontal ? null : allocated[i],
              child: ExcludeFocus(
                excluding: collapsed(i),
                child: ExcludeSemantics(
                  excluding: collapsed(i),
                  child: ClipRect(child: widget.panes[i].child),
                ),
              ),
            ),
          );
          if (i == widget.panes.length - 1) continue;
          final active = _active == i || _hover == i || _focused == i;
          final color = _focused == i
              ? style.focusColor ?? theme.colors.primary
              : active
              ? style.activeColor ?? theme.colors.primary
              : style.handleColor ?? theme.colors.outline;
          children.add(
            Semantics(
              label: '${widget.semanticLabel} ${i + 1}',
              slider: true,
              value: allocated[i].round().toString(),
              increasedValue: (allocated[i] + 1).round().toString(),
              decreasedValue: math.max(0, allocated[i] - 1).round().toString(),
              enabled: widget.enabled,
              onIncrease: widget.enabled ? () => resize(i, 1, allocated) : null,
              onDecrease: widget.enabled
                  ? () => resize(i, -1, allocated)
                  : null,
              child: FocusableActionDetector(
                enabled: widget.enabled,
                onShowFocusHighlight: (v) =>
                    setState(() => _focused = v ? i : null),
                child: Focus(
                  focusNode: _handles.putIfAbsent(i, FocusNode.new),
                  canRequestFocus: widget.enabled,
                  onKeyEvent: (_, event) {
                    if (!widget.enabled ||
                        event is! KeyDownEvent && event is! KeyRepeatEvent) {
                      return KeyEventResult.ignored;
                    }
                    final key = event.logicalKey;
                    if (_focused != i) setState(() => _focused = i);
                    if (key == LogicalKeyboardKey.enter ||
                        key == LogicalKeyboardKey.space) {
                      toggle(i);
                      return KeyEventResult.handled;
                    }
                    final increase = horizontal
                        ? (rtl
                              ? LogicalKeyboardKey.arrowLeft
                              : LogicalKeyboardKey.arrowRight)
                        : LogicalKeyboardKey.arrowDown;
                    final decrease = horizontal
                        ? (rtl
                              ? LogicalKeyboardKey.arrowRight
                              : LogicalKeyboardKey.arrowLeft)
                        : LogicalKeyboardKey.arrowUp;
                    if (key != increase && key != decrease) {
                      return KeyEventResult.ignored;
                    }
                    resize(
                      i,
                      (key == increase ? 1 : -1) *
                          (HardwareKeyboard.instance.isShiftPressed
                              ? sizes.form.gap
                              : 1),
                      allocated,
                    );
                    return KeyEventResult.handled;
                  },
                  child: MouseRegion(
                    cursor: !widget.enabled
                        ? SystemMouseCursors.basic
                        : horizontal
                        ? SystemMouseCursors.resizeColumn
                        : SystemMouseCursors.resizeRow,
                    onEnter: (_) => setState(() => _hover = i),
                    onExit: (_) => setState(() => _hover = null),
                    child: GestureDetector(
                      onTap: widget.enabled
                          ? () => _handles[i]!.requestFocus()
                          : null,
                      behavior: HitTestBehavior.opaque,
                      onDoubleTap: widget.enabled ? () => toggle(i) : null,
                      onPanStart: widget.enabled
                          ? (_) {
                              _handles[i]!.unfocus();
                              setState(() => _active = i);
                            }
                          : null,
                      onPanEnd: (_) => finishPointerResize(i),
                      onPanCancel: () => finishPointerResize(i),
                      onPanUpdate: !widget.enabled
                          ? null
                          : (event) => resize(
                              i,
                              horizontal
                                  ? event.delta.dx * (rtl ? -1 : 1)
                                  : event.delta.dy,
                              allocate(
                                total - handle * (widget.panes.length - 1),
                                controller.weights ?? weights,
                              ),
                            ),
                      child: SizedBox(
                        width: horizontal ? handle : null,
                        height: horizontal ? null : handle,
                        child:
                            widget.handleBuilder?.call(context, i, active) ??
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Center(
                                  child: AnimatedContainer(
                                    duration:
                                        MediaQuery.disableAnimationsOf(context)
                                        ? Duration.zero
                                        : style.duration ??
                                              theme.motion.fastDuration,
                                    curve:
                                        style.curve ?? theme.motion.fastCurve,
                                    width: horizontal
                                        ? style.thickness ??
                                              sizes.divider.thickness
                                        : double.infinity,
                                    height: horizontal
                                        ? double.infinity
                                        : style.thickness ??
                                              sizes.divider.thickness,
                                    color: color,
                                  ),
                                ),
                                IgnorePointer(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color:
                                          style.gripBackground ??
                                          theme.colors.surfaceElevated,
                                      borderRadius: BorderRadius.circular(
                                        handle / 2,
                                      ),
                                    ),
                                    width: horizontal
                                        ? handle
                                        : style.gripSize ?? sizes.icon.size,
                                    height: horizontal
                                        ? style.gripSize ?? sizes.icon.size
                                        : handle,
                                    child: CustomPaint(
                                      painter: _ResizeGripPainter(
                                        color: active
                                            ? color
                                            : theme.colors.textTertiary,
                                        horizontal: horizontal,
                                      ),
                                    ),
                                  ),
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
        return SingleChildScrollView(
          scrollDirection: widget.direction,
          child: SizedBox(
            width: horizontal ? total : constraints.maxWidth,
            height: horizontal ? constraints.maxHeight : total,
            child: Flex(
              direction: widget.direction,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        );
      },
    );
  }
}

class _ResizeGripPainter extends CustomPainter {
  const _ResizeGripPainter({required this.color, required this.horizontal});
  final Color color;
  final bool horizontal;
  @override
  void paint(Canvas canvas, Size size) {
    final cross = horizontal ? size.width : size.height;
    final length = horizontal ? size.height : size.width;
    final radius = math.min(cross / 4, length / 12);
    final paint = Paint()..color = color;
    for (var i = -1; i <= 1; i++) {
      final offset = length / 2 + i * length / 4;
      canvas.drawCircle(
        horizontal ? Offset(cross / 2, offset) : Offset(offset, cross / 2),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ResizeGripPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.horizontal != horizontal;
}
