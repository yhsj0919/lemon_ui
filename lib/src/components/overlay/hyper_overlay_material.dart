import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';

/// 浮层消费者共用的默认材质；显式配方由原消费者保持完整优先级。
abstract final class HyperOverlayMaterial {
  static HyperSurfaceMaterial? fallback(
    BuildContext context, {
    HyperSurfaceMaterial? componentMaterial,
    HyperSurfaceMaterial? instanceMaterial,
    bool hasExplicitBackground = false,
  }) {
    if (hasExplicitBackground ||
        instanceMaterial != null ||
        componentMaterial != null ||
        HyperMaterialTheme.of(context).material != null) {
      return null;
    }
    final colors = HyperTheme.of(context).colors;
    return HyperSurfaceMaterial.softLightGlass(
      background: HyperFill.color(
        colors.surfaceElevated.withValues(alpha: .72),
      ),
      blurSigmaX: 20,
      blurSigmaY: 20,
      tint: colors.surfaceElevated.withValues(alpha: .06),
      border: BorderSide(color: colors.outline.withValues(alpha: .65)),
      boxShadow: [
        BoxShadow(
          color: colors.scrim.withValues(alpha: .12),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
      fallback: HyperSurfaceMaterial.solid(
        background: HyperFill.color(colors.surfaceElevated),
        border: BorderSide(color: colors.outline.withValues(alpha: .65)),
        boxShadow: [
          BoxShadow(
            color: colors.scrim.withValues(alpha: .12),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
    );
  }
}
