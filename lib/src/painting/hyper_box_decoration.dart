import 'package:flutter/painting.dart';

/// 保留自定义 BoxBorder 的插值，复用 Flutter 的颜色、渐变和阴影插值。
class HyperBoxDecoration extends BoxDecoration {
  const HyperBoxDecoration({
    super.color,
    super.image,
    super.border,
    super.borderRadius,
    super.boxShadow,
    super.gradient,
    super.backgroundBlendMode,
    super.shape,
    this.outerShadowsOnly = false,
  });

  /// 阴影只绘制在轮廓外，避免透明表面被自身阴影染色。
  final bool outerShadowsOnly;

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      outerShadowsOnly && (boxShadow?.isNotEmpty ?? false)
      ? _OuterShadowPainter(this, onChanged)
      : super.createBoxPainter(onChanged);

  static BoxDecoration _withoutBorder(BoxDecoration d) => BoxDecoration(
    color: d.color,
    image: d.image,
    borderRadius: d.borderRadius,
    boxShadow: d.boxShadow,
    gradient: d.gradient,
    backgroundBlendMode: d.backgroundBlendMode,
    shape: d.shape,
  );
  static HyperBoxDecoration _blend(
    BoxDecoration? a,
    BoxDecoration? b,
    double t,
  ) {
    final value = BoxDecoration.lerp(
      a == null ? null : _withoutBorder(a),
      b == null ? null : _withoutBorder(b),
      t,
    )!;
    return HyperBoxDecoration(
      outerShadowsOnly: (t < .5 ? a : b) is HyperBoxDecoration
          ? ((t < .5 ? a : b) as HyperBoxDecoration).outerShadowsOnly
          : false,
      color: value.color,
      image: value.image,
      border: lerpHyperBoxBorder(a?.border, b?.border, t),
      borderRadius: value.borderRadius,
      boxShadow: value.boxShadow,
      gradient: value.gradient,
      backgroundBlendMode: value.backgroundBlendMode,
      shape: value.shape,
    );
  }

  @override
  BoxDecoration? lerpFrom(Decoration? a, double t) =>
      a == null || a is BoxDecoration
      ? _blend(a as BoxDecoration?, this, t)
      : super.lerpFrom(a, t);
  @override
  BoxDecoration? lerpTo(Decoration? b, double t) =>
      b == null || b is BoxDecoration
      ? _blend(this, b as BoxDecoration?, t)
      : super.lerpTo(b, t);
  @override
  HyperBoxDecoration scale(double factor) => _blend(null, this, factor);
}

BoxBorder? lerpHyperBoxBorder(BoxBorder? a, BoxBorder? b, double t) {
  if ((a == null || a is Border || a is BorderDirectional) &&
      (b == null || b is Border || b is BorderDirectional)) {
    return BoxBorder.lerp(a, b, t);
  }
  final value = ShapeBorder.lerp(a, b, t);
  return value is BoxBorder
      ? value
      : t < .5
      ? a
      : b;
}

class _OuterShadowPainter extends BoxPainter {
  _OuterShadowPainter(this.decoration, VoidCallback? onChanged)
    : shadow = BoxDecoration(
        borderRadius: decoration.borderRadius,
        shape: decoration.shape,
        boxShadow: decoration.boxShadow,
      ).createBoxPainter(onChanged),
      surface = BoxDecoration(
        color: decoration.color,
        image: decoration.image,
        border: decoration.border,
        borderRadius: decoration.borderRadius,
        gradient: decoration.gradient,
        backgroundBlendMode: decoration.backgroundBlendMode,
        shape: decoration.shape,
      ).createBoxPainter(onChanged),
      super(onChanged);
  final HyperBoxDecoration decoration;
  final BoxPainter shadow, surface;
  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final rect = offset & configuration.size!;
    canvas.save();
    canvas.clipPath(
      Path.combine(
        PathOperation.difference,
        Path()..addRect(canvas.getLocalClipBounds()),
        decoration.getClipPath(
          rect,
          configuration.textDirection ?? TextDirection.ltr,
        ),
      ),
    );
    shadow.paint(canvas, offset, configuration);
    canvas.restore();
    surface.paint(canvas, offset, configuration);
  }

  @override
  void dispose() {
    shadow.dispose();
    surface.dispose();
    super.dispose();
  }
}
