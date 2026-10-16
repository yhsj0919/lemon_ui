import 'package:flutter/painting.dart';

/// Border-only decoration. Flutter's directional single-side borders reject
/// even a zero radius; non-uniform borders are clipped to the surface instead.
Decoration? hyperSurfaceBorderDecoration(
  BoxBorder? border,
  BorderRadiusGeometry? radius,
) {
  if (border == null) return null;
  if (radius == null || radius == BorderRadius.zero) {
    return BoxDecoration(border: border);
  }
  if ((border is Border || border is BorderDirectional) && !border.isUniform) {
    return _ClippedBorderDecoration(border, radius);
  }
  return BoxDecoration(border: border, borderRadius: radius);
}

class _ClippedBorderDecoration extends Decoration {
  const _ClippedBorderDecoration(this.border, this.radius);
  final BoxBorder border;
  final BorderRadiusGeometry radius;
  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      _BorderPainter(border, radius, onChanged);
  @override
  Decoration? lerpFrom(Decoration? a, double t) => a is _ClippedBorderDecoration
      ? _ClippedBorderDecoration(
          BoxBorder.lerp(a.border, border, t)!,
          BorderRadiusGeometry.lerp(a.radius, radius, t)!,
        )
      : super.lerpFrom(a, t);
  @override
  Decoration? lerpTo(Decoration? b, double t) => b is _ClippedBorderDecoration
      ? _ClippedBorderDecoration(
          BoxBorder.lerp(border, b.border, t)!,
          BorderRadiusGeometry.lerp(radius, b.radius, t)!,
        )
      : super.lerpTo(b, t);
  @override
  bool operator ==(Object other) =>
      other is _ClippedBorderDecoration &&
      other.border == border &&
      other.radius == radius;
  @override
  int get hashCode => Object.hash(border, radius);
}

class _BorderPainter extends BoxPainter {
  _BorderPainter(BoxBorder border, this.radius, VoidCallback? onChanged)
    : delegate = BoxDecoration(border: border).createBoxPainter(onChanged),
      super(onChanged);
  final BoxPainter delegate;
  final BorderRadiusGeometry radius;
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    canvas.save();
    canvas.clipRRect(
      radius
          .resolve(configuration.textDirection ?? TextDirection.ltr)
          .toRRect(offset & configuration.size!),
    );
    delegate.paint(canvas, offset, configuration);
    canvas.restore();
  }

  @override
  void dispose() {
    delegate.dispose();
    super.dispose();
  }
}
