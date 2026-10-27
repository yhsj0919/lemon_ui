import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Divider;

// Measure rows with real bounded layout, then stretch every row to the widest.
// No intrinsic queries: user content may contain LayoutBuilder.
class HyperMenuLayout extends MultiChildRenderObjectWidget {
  const HyperMenuLayout({
    super.key,
    required this.naturalWidth,
    required super.children,
  });

  final bool naturalWidth;

  Set<int> get _spacing => {
    for (final (index, child) in children.indexed)
      if (child is Divider || child is SizedBox) index,
  };

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderMenuLayout(naturalWidth, _spacing);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as _RenderMenuLayout).configure(naturalWidth, _spacing);
  }
}

class _RenderMenuLayout extends RenderBox
    with
        ContainerRenderObjectMixin<
          RenderBox,
          ContainerBoxParentData<RenderBox>
        >,
        RenderBoxContainerDefaultsMixin<
          RenderBox,
          ContainerBoxParentData<RenderBox>
        > {
  _RenderMenuLayout(this._naturalWidth, this._spacing);

  bool _naturalWidth;
  Set<int> _spacing;

  void configure(bool naturalWidth, Set<int> spacing) {
    _naturalWidth = naturalWidth;
    _spacing = spacing;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! ContainerBoxParentData<RenderBox>) {
      child.parentData = _MenuParentData();
    }
  }

  @override
  void performLayout() {
    var width = _naturalWidth ? constraints.minWidth : constraints.maxWidth;
    if (_naturalWidth) {
      var index = 0;
      for (var child = firstChild; child != null; child = childAfter(child)) {
        if (!_spacing.contains(index)) {
          child.layout(
            BoxConstraints(maxWidth: constraints.maxWidth),
            parentUsesSize: true,
          );
          if (child.size.width > width) width = child.size.width;
        }
        index++;
      }
    }
    width = constraints.constrainWidth(width);
    var height = 0.0;
    for (var child = firstChild; child != null; child = childAfter(child)) {
      child.layout(BoxConstraints.tightFor(width: width), parentUsesSize: true);
      (child.parentData! as ContainerBoxParentData<RenderBox>).offset = Offset(
        0,
        height,
      );
      height += child.size.height;
    }
    size = constraints.constrain(Size(width, height));
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}

class _MenuParentData extends ContainerBoxParentData<RenderBox> {}
