import 'package:lemon_extended_image/extended_image.dart';
import 'package:flutter/widgets.dart';

// Integration adapter only: image transforms, bounds, inertia and page physics
// remain implemented by extended_image. Its gesture math uses local image
// coordinates, while Flutter recognizers and wheel events supply global focal
// points. Embedded galleries therefore need this coordinate conversion.
class HyperImagePreviewGesture extends ExtendedImageGesture {
  const HyperImagePreviewGesture(super.extendedImageState, {super.key});
  @override
  ExtendedImageGestureState createState() => _PreviewGestureState();
}

class _PreviewGestureState extends ExtendedImageGestureState {
  Offset _local(Offset point) =>
      (context.findRenderObject()! as RenderBox).globalToLocal(point);
  @override
  void handleScaleStart(ScaleStartDetails details) {
    super.handleScaleStart(
      ScaleStartDetails(
        focalPoint: _local(details.focalPoint),
        localFocalPoint: details.localFocalPoint,
        pointerCount: details.pointerCount,
        sourceTimeStamp: details.sourceTimeStamp,
        kind: details.kind,
      ),
    );
  }

  @override
  void handleScaleUpdate(ScaleUpdateDetails details) {
    // The backend's image recognizer can win before the horizontal recognizer
    // (notably a coarse mouse move, or a vertical lead). At base scale there is
    // no image to pan: hand that single-pointer horizontal motion to the SAME
    // native pager. Native handleScaleEnd already completes its drag lifecycle.
    if (details.pointerCount == 1 &&
        details.scale == 1 &&
        (gestureDetails?.totalScale ?? 1) <= 1.001 &&
        details.focalPointDelta.dx.abs() > details.focalPointDelta.dy.abs()) {
      final page = context
          .findAncestorStateOfType<ExtendedImageGesturePageViewState>();
      if (page != null) {
        if (!page.isDraging) {
          page.onDragDown(DragDownDetails(globalPosition: details.focalPoint));
          page.onDragStart(
            DragStartDetails(globalPosition: details.focalPoint),
          );
        }
        page.onDragUpdate(
          DragUpdateDetails(
            globalPosition: details.focalPoint,
            delta: Offset(details.focalPointDelta.dx, 0),
            primaryDelta: details.focalPointDelta.dx,
          ),
        );
        return;
      }
    }
    super.handleScaleUpdate(
      ScaleUpdateDetails(
        focalPoint: _local(details.focalPoint),
        localFocalPoint: details.localFocalPoint,
        focalPointDelta: details.focalPointDelta,
        scale: details.scale,
        horizontalScale: details.horizontalScale,
        verticalScale: details.verticalScale,
        rotation: details.rotation,
        pointerCount: details.pointerCount,
        sourceTimeStamp: details.sourceTimeStamp,
      ),
    );
  }
}
