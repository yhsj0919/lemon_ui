import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Internal equal-height row measured through real layout, never intrinsics.
class HyperDescriptionRow extends MultiChildRenderObjectWidget {
  const HyperDescriptionRow({
    super.key,
    required this.widths,
    required this.direction,
    required super.children,
  });

  final List<double> widths;
  final TextDirection direction;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _DescriptionRow(widths, direction);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderBox renderObject,
  ) {
    (renderObject as _DescriptionRow)
      ..widths = widths
      ..direction = direction
      ..markNeedsLayout();
  }
}

class _DescriptionRow extends RenderBox
    with
        ContainerRenderObjectMixin<
          RenderBox,
          ContainerBoxParentData<RenderBox>
        >,
        RenderBoxContainerDefaultsMixin<
          RenderBox,
          ContainerBoxParentData<RenderBox>
        > {
  _DescriptionRow(this.widths, this.direction);

  List<double> widths;
  TextDirection direction;

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! ContainerBoxParentData<RenderBox>) {
      child.parentData = _DescriptionParentData();
    }
  }

  @override
  void performLayout() {
    var height = constraints.minHeight;
    var index = 0;
    RenderBox? child = firstChild;
    while (child != null) {
      child.layout(
        BoxConstraints.tightFor(width: widths[index++])
            .copyWith(maxHeight: constraints.maxHeight),
        parentUsesSize: true,
      );
      height = math.max(height, child.size.height);
      child = childAfter(child);
    }
    final width = widths.fold(0.0, (sum, value) => sum + value);
    size = constraints.constrain(Size(width, height));
    var offset = direction == TextDirection.ltr ? 0.0 : size.width;
    index = 0;
    child = firstChild;
    while (child != null) {
      final childWidth = widths[index++];
      // Leave the tallest child's loose constraints intact. Tightening an
      // AnimatedSize mid-transition would constrain its growing editor too.
      if (child.size.height < size.height) {
        child.layout(BoxConstraints.tight(Size(childWidth, size.height)));
      }
      if (direction == TextDirection.rtl) offset -= childWidth;
      (child.parentData! as ContainerBoxParentData<RenderBox>).offset = Offset(
        offset,
        0,
      );
      if (direction == TextDirection.ltr) offset += childWidth;
      child = childAfter(child);
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}

class _DescriptionParentData extends ContainerBoxParentData<RenderBox> {}
