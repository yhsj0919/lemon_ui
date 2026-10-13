import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// 用实际 Chip 和 +N 尺寸选择可见前缀，不按字符数猜测。
int hyperVisibleSelectionCount(
  List<double> widths,
  Map<int, double> counterWidths,
  double available,
  double spacing,
) {
  if (!available.isFinite ||
      available < 0 ||
      !spacing.isFinite ||
      spacing < 0 ||
      widths.any((width) => !width.isFinite || width < 0) ||
      counterWidths.values.any((width) => !width.isFinite || width < 0)) {
    throw ArgumentError('可用宽度与间距必须为有限非负值。');
  }
  var used = 0.0, visible = 0;
  for (var i = 0; i < widths.length; i++) {
    used += widths[i] + (i == 0 ? 0 : spacing);
    final hidden = widths.length - i - 1;
    final total =
        used + (hidden > 0 ? spacing + (counterWidths[hidden] ?? 0) : 0);
    if (total <= available) {
      visible = i + 1;
    }
  }
  return visible;
}

class HyperSelectionTags extends MultiChildRenderObjectWidget {
  HyperSelectionTags({
    super.key,
    required List<Widget> tags,
    required Widget Function(int count) overflowBuilder,
    required this.spacing,
    required this.direction,
    this.minimumTagWidth = 0,
  }) : count = tags.length,
       super(
         children: [
           ...tags,
           for (var i = 1; i <= tags.length; i++) overflowBuilder(i),
         ],
       );
  final double minimumTagWidth;
  final int count;
  final double spacing;
  final TextDirection direction;
  @override
  RenderObject createRenderObject(BuildContext context) =>
      _TagsRender(count, spacing, direction, minimumTagWidth);
  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as _TagsRender).update(
      count,
      spacing,
      direction,
      minimumTagWidth,
    );
  }
}

class _TagParentData extends ContainerBoxParentData<RenderBox> {}

class _TagsRender extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _TagParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _TagParentData> {
  _TagsRender(
    this._count,
    this._spacing,
    this._direction,
    this._minimumTagWidth,
  );
  double _minimumTagWidth;
  int _count;
  double _spacing;
  TextDirection _direction;
  final _visible = <RenderBox>[];
  void update(
    int count,
    double spacing,
    TextDirection direction,
    double minimumTagWidth,
  ) {
    if (_minimumTagWidth == minimumTagWidth &&
        _count == count &&
        _spacing == spacing &&
        _direction == direction) {
      return;
    }
    _minimumTagWidth = minimumTagWidth;
    _count = count;
    _spacing = spacing;
    _direction = direction;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _TagParentData) {
      child.parentData = _TagParentData();
    }
  }

  List<RenderBox> get _children {
    final result = <RenderBox>[];
    var child = firstChild;
    while (child != null) {
      result.add(child);
      child = childAfter(child);
    }
    return result;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    if (!constraints.maxWidth.isFinite) return constraints.smallest;
    final dimensions = [
      for (final child in _children)
        child.getDryLayout(BoxConstraints(maxWidth: constraints.maxWidth)),
    ];
    var visible = hyperVisibleSelectionCount(
      [for (var i = 0; i < _count; i++) dimensions[i].width],
      {for (var n = 1; n <= _count; n++) n: dimensions[_count + n - 1].width},
      constraints.maxWidth,
      _spacing,
    );
    if (visible == 0 && _count > 1) {
      final budget =
          constraints.maxWidth -
          dimensions[_count + _count - 2].width -
          _spacing;
      final minimum = _minimumTagWidth > 0
          ? _minimumTagWidth
          : _children.first.getMinIntrinsicWidth(double.infinity);
      if (budget > 0 && budget >= minimum) {
        dimensions[0] = _children.first.getDryLayout(
          BoxConstraints(maxWidth: budget),
        );
        visible = 1;
      }
    }
    final shown = [
      ...dimensions.take(visible),
      if (visible < _count) dimensions[_count + _count - visible - 1],
    ];
    return constraints.constrain(
      Size(
        shown.fold<double>(0, (width, item) => width + item.width) +
            math.max(0, shown.length - 1) * _spacing,
        shown.fold<double>(0, (height, item) => math.max(height, item.height)),
      ),
    );
  }

  @override
  void performLayout() {
    if (!constraints.maxWidth.isFinite) {
      throw FlutterError('多选标签需要有限可用宽度。');
    }
    final children = _children;
    for (final child in children) {
      child.layout(
        BoxConstraints(maxWidth: constraints.maxWidth),
        parentUsesSize: true,
      );
    }
    final widths = [for (var i = 0; i < _count; i++) children[i].size.width];
    final counters = {
      for (var n = 1; n <= _count; n++) n: children[_count + n - 1].size.width,
    };
    var visible = hyperVisibleSelectionCount(
      widths,
      counters,
      constraints.maxWidth,
      _spacing,
    );
    if (visible == 0 && _count > 1) {
      final budget = constraints.maxWidth - counters[_count - 1]! - _spacing;
      final minimum = _minimumTagWidth > 0
          ? _minimumTagWidth
          : children.first.getMinIntrinsicWidth(double.infinity);
      if (budget > 0 && budget >= minimum) {
        children.first.layout(
          BoxConstraints(maxWidth: budget),
          parentUsesSize: true,
        );
        visible = 1;
      }
    }
    _visible.clear();
    _visible.addAll(children.take(visible));
    if (visible < _count) {
      _visible.add(children[_count + (_count - visible) - 1]);
    }
    final width =
        _visible.fold<double>(0, (w, c) => w + c.size.width) +
        math.max(0, _visible.length - 1) * _spacing;
    final height = _visible.fold<double>(
      0,
      (h, c) => math.max(h, c.size.height),
    );
    size = constraints.constrain(Size(width, height));
    var x = _direction == TextDirection.ltr ? 0.0 : size.width;
    for (final child in _visible) {
      if (_direction == TextDirection.rtl) {
        x -= child.size.width;
      }
      (child.parentData! as _TagParentData).offset = Offset(
        x,
        (size.height - child.size.height) / 2,
      );
      x += _direction == TextDirection.ltr
          ? child.size.width + _spacing
          : -_spacing;
    }
  }

  @override
  double computeMinIntrinsicHeight(double width) => _children.fold<double>(
    0,
    (h, c) => math.max(h, c.getMinIntrinsicHeight(width)),
  );
  @override
  double computeMaxIntrinsicHeight(double width) =>
      computeMinIntrinsicHeight(width);
  @override
  double computeMinIntrinsicWidth(double height) => 0;
  @override
  double computeMaxIntrinsicWidth(double height) =>
      _children
          .take(_count)
          .fold<double>(0, (w, c) => w + c.getMaxIntrinsicWidth(height)) +
      math.max(0, _count - 1) * _spacing;
  @override
  void paint(PaintingContext context, Offset offset) {
    for (final child in _visible) {
      context.paintChild(
        child,
        offset + (child.parentData! as _TagParentData).offset,
      );
    }
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    for (final child in _visible.reversed) {
      if (result.addWithPaintOffset(
        offset: (child.parentData! as _TagParentData).offset,
        position: position,
        hitTest: (result, transformed) =>
            child.hitTest(result, position: transformed),
      )) {
        return true;
      }
    }
    return false;
  }

  @override
  void visitChildrenForSemantics(RenderObjectVisitor visitor) {
    for (final child in _visible) {
      visitor(child);
    }
  }
}
