import 'package:flutter/material.dart';

import '../../foundation/hyper_surface_material.dart';
import '../../theme/color/hyper_color_scheme.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../card/hyper_card_style.dart';
import '../card/hyper_card_theme.dart';
import '../overlay/hyper_overlay_material.dart';

/// Menu 与组合选择面板共用同一表面，材质质量及降级交给统一材质主题。
HyperCardStyle resolveHyperMenuSurface(
  BuildContext context, {
  required double radius,
  required EdgeInsetsGeometry padding,
  HyperCardStyle? style,
}) {
  final card = HyperCardTheme.of(context).style;
  final material = HyperMaterialTheme.of(context).material;
  final fallback = HyperOverlayMaterial.fallback(
    context,
    componentMaterial: card?.material,
    instanceMaterial: style?.material,
    hasExplicitBackground:
        card?.background != null || style?.background != null,
  );
  return resolveHyperMenuSurfaceStyle(
    colors: HyperTheme.of(context).colors,
    radius: radius,
    padding: padding,
    cardThemeStyle: card,
    globalMaterial: material,
    fallbackMaterial: fallback,
    style: style,
  );
}

/// 与构建上下文分离，便于验证默认材质和显式覆盖的优先级。
HyperCardStyle resolveHyperMenuSurfaceStyle({
  required HyperColorScheme colors,
  required double radius,
  required EdgeInsetsGeometry padding,
  HyperCardStyle? cardThemeStyle,
  HyperSurfaceMaterial? globalMaterial,
  HyperSurfaceMaterial? fallbackMaterial,
  HyperCardStyle? style,
}) {
  final hasMaterial =
      globalMaterial != null ||
      cardThemeStyle?.material != null ||
      style?.material != null ||
      fallbackMaterial != null;
  final shadow =
      fallbackMaterial != null ||
          cardThemeStyle?.material != null ||
          style?.material != null ||
          (globalMaterial?.boxShadow.isNotEmpty ?? false) ||
          cardThemeStyle?.boxShadow != null ||
          style?.boxShadow != null
      ? null
      : [
          BoxShadow(
            color: colors.scrim.withValues(
              alpha: globalMaterial == null ? .10 : .12,
            ),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ];
  return HyperCardStyle(
    material: fallbackMaterial,
    padding: padding,
    borderRadius: BorderRadius.circular(radius),
    border: hasMaterial
        ? null
        : Border.all(color: colors.outline.withValues(alpha: .65)),
    boxShadow: shadow,
  ).merge(style);
}
