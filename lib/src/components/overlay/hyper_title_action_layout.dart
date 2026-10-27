import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// End controls reserve width, while the title alone determines header height.
/// Controls may extend into the surrounding modal padding/title spacing.
class HyperTitleActionLayout extends MultiChildRenderObjectWidget {
  HyperTitleActionLayout({
    super.key,
    required Widget title,
    required Widget controls,
    required this.direction,
  }) : super(children: [title, controls]);
  final TextDirection direction;
  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderTitleActionLayout()..direction = direction;
  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    final layout = renderObject as _RenderTitleActionLayout;
    layout.direction = direction;
    layout.markNeedsLayout();
  }
}

class _TitleParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderTitleActionLayout extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _TitleParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _TitleParentData> {
  TextDirection direction = TextDirection.ltr;
  @override
  double computeMinIntrinsicWidth(double height) =>
      firstChild!.getMinIntrinsicWidth(height) +
      lastChild!.getMinIntrinsicWidth(height);
  @override
  double computeMaxIntrinsicWidth(double height) =>
      firstChild!.getMaxIntrinsicWidth(height) +
      lastChild!.getMaxIntrinsicWidth(height);
  @override
  double computeMinIntrinsicHeight(double width) =>
      firstChild!.getMinIntrinsicHeight(
        (width - lastChild!.getMaxIntrinsicWidth(double.infinity)).clamp(
          0,
          double.infinity,
        ),
      );
  @override
  double computeMaxIntrinsicHeight(double width) =>
      firstChild!.getMaxIntrinsicHeight(
        (width - lastChild!.getMaxIntrinsicWidth(double.infinity)).clamp(
          0,
          double.infinity,
        ),
      );
  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _TitleParentData) {
      child.parentData = _TitleParentData();
    }
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final controls = lastChild!.getDryLayout(constraints.loosen());
    final title = firstChild!.getDryLayout(
      BoxConstraints.tightFor(
        width: (constraints.maxWidth - controls.width).clamp(
          0,
          double.infinity,
        ),
      ),
    );
    return constraints.constrain(Size(constraints.maxWidth, title.height));
  }

  @override
  void performLayout() {
    final title = firstChild!, controls = lastChild!;
    controls.layout(constraints.loosen(), parentUsesSize: true);
    title.layout(
      BoxConstraints.tightFor(
        width: (constraints.maxWidth - controls.size.width).clamp(
          0,
          double.infinity,
        ),
      ),
      parentUsesSize: true,
    );
    size = constraints.constrain(Size(constraints.maxWidth, title.size.height));
    (title.parentData! as _TitleParentData).offset = Offset(
      direction == TextDirection.rtl ? controls.size.width : 0,
      0,
    );
    (controls.parentData! as _TitleParentData).offset = Offset(
      direction == TextDirection.rtl ? 0 : size.width - controls.size.width,
      (size.height - controls.size.height) / 2,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);
  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (defaultHitTestChildren(result, position: position)) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }
    return false;
  }
}

// Header controls can extend into the padding above the column. Keep that
// painted part interactive while the outer modal still bounds hit testing.
class HyperOverflowColumn extends MultiChildRenderObjectWidget {
  const HyperOverflowColumn({super.key, required super.children});

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderOverflowColumn(textDirection: Directionality.of(context));

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderObject renderObject,
  ) {
    (renderObject as _RenderOverflowColumn).textDirection = Directionality.of(
      context,
    );
  }
}

class _RenderOverflowColumn extends RenderFlex {
  _RenderOverflowColumn({required super.textDirection})
    : super(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
      );

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (defaultHitTestChildren(result, position: position)) {
      result.add(BoxHitTestEntry(this, position));
      return true;
    }
    return false;
  }
}
