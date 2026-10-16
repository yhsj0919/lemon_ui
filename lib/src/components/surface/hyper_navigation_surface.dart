import '../../painting/hyper_surface_border.dart';

import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../card/hyper_card_style.dart';
import 'hyper_material_surface.dart';

/// Shared non-overlay navigation surface. Component defaults are supplied by
/// the caller; this never inherits Card's component theme or device sizes.
class HyperNavigationSurface extends StatelessWidget {
  const HyperNavigationSurface({
    super.key,
    required this.style,
    required this.child,
    this.inheritMaterial = false,
    this.stateLayer,
  });
  final HyperCardStyle style;
  final Widget child;
  final bool inheritMaterial;
  final Color? stateLayer;
  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final duration = (MediaQuery.maybeOf(context)?.disableAnimations ?? false)
        ? Duration.zero
        : theme.motion.fastDuration;
    final content = stateLayer == null
        ? child
        : Stack(
            fit: StackFit.passthrough,
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: style.borderRadius ?? BorderRadius.zero,
                  child: AnimatedContainer(
                    duration: duration,
                    curve: theme.motion.fastCurve,
                    color: stateLayer,
                  ),
                ),
              ),
              child,
            ],
          );
    final material =
        style.material ??
        (inheritMaterial ? HyperMaterialTheme.of(context).material : null);
    if (material != null) {
      return HyperMaterialSurface(
        material: material,
        semanticBackground: style.background,
        border: style.border,
        boxShadow: style.boxShadow,
        borderRadius: style.borderRadius,
        padding: style.padding,
        child: content,
      );
    }
    return AnimatedContainer(
      duration: duration,
      curve: theme.motion.fastCurve,
      padding: style.padding,
      foregroundDecoration: hyperSurfaceBorderDecoration(
        style.border,
        style.borderRadius,
      ),
      decoration: BoxDecoration(
        color: style.background?.color,
        gradient: style.background?.gradient,
        borderRadius: style.borderRadius,
        boxShadow: style.boxShadow,
      ),
      child: content,
    );
  }
}
