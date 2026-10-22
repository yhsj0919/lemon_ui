import 'package:flutter/widgets.dart';

import '../../foundation/hyper_surface_material.dart';

/// Internal shared glass contour. A component's own border always takes priority.
class HyperMaterialEdge extends StatelessWidget {
  const HyperMaterialEdge({
    super.key,
    required this.material,
    required this.radius,
    required this.child,
    this.hasBorderOverride = false,
    this.defaultEnabled = false,
  });

  final HyperSurfaceMaterial? material;
  final BorderRadius radius;
  final bool hasBorderOverride;
  final bool defaultEnabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final gradient = material?.resolveEdgeGradient(
      hasBorderOverride: hasBorderOverride,
      defaultEnabled: defaultEnabled,
    );
    return CustomPaint(
      foregroundPainter: gradient == null
          ? null
          : _MaterialEdgePainter(radius, gradient),
      child: child,
    );
  }
}

class _MaterialEdgePainter extends CustomPainter {
  const _MaterialEdgePainter(this.radius, this.gradient);
  final BorderRadius radius;
  final Gradient gradient;

  @override
  void paint(Canvas canvas, Size size) {
    if (size.shortestSide <= 0) return;
    final rect = Offset.zero & size;
    canvas.drawRRect(
      radius.toRRect(rect).deflate(.5),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1
        ..shader = gradient.createShader(rect),
    );
  }

  @override
  bool shouldRepaint(_MaterialEdgePainter old) =>
      old.radius != radius || old.gradient != gradient;
}
