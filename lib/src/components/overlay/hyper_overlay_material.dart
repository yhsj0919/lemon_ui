import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/color/hyper_color_scheme.dart';
import '../../theme/material/hyper_material_theme.dart';

/// 浮层消费者共用的默认材质；显式配方由原消费者保持完整优先级。
abstract final class HyperOverlayMaterial {
  /// macOS 27 UI Kit 的 Liquid Glass/Light|Dark/Menus 外阴影。
  /// 来源、单位与 Flutter 映射见 docs/macos-menu-shadow.md。
  static List<BoxShadow> defaultShadowsFor(HyperColorScheme colors) => [
    BoxShadow(
      color: Colors.black.withValues(alpha: .30),
      blurRadius: 24,
      offset: const Offset(0, 4),
    ),
    BoxShadow(
      color: Colors.black.withValues(
        alpha: colors.brightness == Brightness.dark ? .80 : .20,
      ),
      spreadRadius: .5,
    ),
  ];

  static HyperSurfaceMaterial? fallback(
    BuildContext context, {
    HyperSurfaceMaterial? componentMaterial,
    HyperSurfaceMaterial? instanceMaterial,
    bool hasExplicitBackground = false,
  }) {
    return fallbackFor(
      colors: HyperTheme.of(context).colors,
      globalMaterial: HyperMaterialTheme.of(context).material,
      componentMaterial: componentMaterial,
      instanceMaterial: instanceMaterial,
      hasExplicitBackground: hasExplicitBackground,
    );
  }

  /// 纯配方解析；不另行决定质量或降级策略。
  static HyperSurfaceMaterial? fallbackFor({
    required HyperColorScheme colors,
    HyperSurfaceMaterial? globalMaterial,
    HyperSurfaceMaterial? componentMaterial,
    HyperSurfaceMaterial? instanceMaterial,
    bool hasExplicitBackground = false,
  }) {
    if (hasExplicitBackground ||
        instanceMaterial != null ||
        componentMaterial != null ||
        globalMaterial != null) {
      return null;
    }
    return HyperSurfaceMaterial.softLightGlass(
      background: HyperFill.color(
        colors.surfaceElevated.withValues(alpha: .72),
      ),
      blurSigmaX: 20,
      blurSigmaY: 20,
      tint: colors.surfaceElevated.withValues(alpha: .06),
      boxShadow: defaultShadowsFor(colors),
      fallback: HyperSurfaceMaterial.solid(
        background: HyperFill.color(colors.surfaceElevated),
        border: BorderSide(color: colors.outline.withValues(alpha: .65)),
        boxShadow: defaultShadowsFor(colors),
      ),
    );
  }
}
