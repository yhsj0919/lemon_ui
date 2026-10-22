import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../surface/hyper_material_surface.dart';
import 'hyper_app_bar_style.dart';
import 'hyper_app_bar_theme.dart';
import 'hyper_app_bar_variant.dart';
import 'hyper_app_bar_system_overlay.dart';

/// 两种顶栏共享同一主题解析结果，避免滚动形态改变材质配方。
final class HyperAppBarResolved {
  HyperAppBarResolved(
    BuildContext context,
    HyperAppBarStyle? instanceStyle,
    HyperAppBarVariant variant,
  ) {
    final theme = HyperTheme.of(context);
    final themedStyle = HyperAppBarTheme.of(context).style;
    final base = HyperAppBarStyle(
      backgroundColor: theme.colors.background,
      foregroundColor: theme.colors.onBackground,
      titleTextStyle: theme.textTheme.titleMedium?.copyWith(
        fontSize: theme.typography.subsectionTitle,
      ),
    );
    style = base.merge(themedStyle).merge(instanceStyle);
    systemOverlayStyle = appBarSystemOverlayStyle(
      foregroundColor: style.foregroundColor!,
      override:
          style.systemOverlayStyle ??
          AppBarTheme.of(context).systemOverlayStyle,
    );
    final titleColor =
        instanceStyle?.titleTextStyle?.color ??
        instanceStyle?.foregroundColor ??
        themedStyle?.titleTextStyle?.color ??
        themedStyle?.foregroundColor ??
        theme.colors.onBackground;
    titleTextStyle = style.titleTextStyle?.copyWith(color: titleColor);

    final expandedTitleColor =
        instanceStyle?.expandedTitleTextStyle?.color ??
        instanceStyle?.foregroundColor ??
        themedStyle?.expandedTitleTextStyle?.color ??
        themedStyle?.foregroundColor ??
        theme.colors.onBackground;
    expandedTitleTextStyle =
        (variant == HyperAppBarVariant.medium
                ? theme.textTheme.titleLarge
                : theme.textTheme.headlineLarge)
            ?.merge(style.expandedTitleTextStyle)
            .copyWith(color: expandedTitleColor);

    // 实例背景可以覆盖主题材质的背景；显式实例材质保持完整配方。
    final explicitBackground = instanceStyle?.material == null
        ? instanceStyle?.backgroundColor ??
              (themedStyle?.material == null
                  ? themedStyle?.backgroundColor
                  : null)
        : null;
    final materialTheme = HyperMaterialTheme.of(context);
    final selectedMaterial =
        instanceStyle?.surfaceStyle?.material ??
        instanceStyle?.material ??
        themedStyle?.surfaceStyle?.material ??
        themedStyle?.material ??
        materialTheme.material ??
        (explicitBackground == null
            ? HyperSurfaceMaterial.softLightGlass(
                background: HyperFill.color(
                  theme.colors.background.withValues(alpha: 0.4),
                ),
                blurSigmaX: 20,
                blurSigmaY: 20,
                tint: theme.colors.background.withValues(alpha: 0.06),
                fallback: HyperSurfaceMaterial.solid(
                  background: HyperFill.color(theme.colors.background),
                ),
              )
            : null);
    var recipe = materialTheme.resolveMaterial(
      material: selectedMaterial,
      semanticBackground: HyperFill.color(
        explicitBackground ?? theme.colors.background,
      ),
    );
    if (recipe != null && explicitBackground != null) {
      recipe = recipe.copyWith(background: HyperFill.color(explicitBackground));
    }
    if (recipe != null && style.surfaceStyle?.background != null) {
      recipe = recipe.copyWith(background: style.surfaceStyle!.background);
    }
    material = recipe;
  }

  late final HyperAppBarStyle style;
  late final TextStyle? titleTextStyle;
  late final TextStyle? expandedTitleTextStyle;
  late final HyperSurfaceMaterial? material;
  late final SystemUiOverlayStyle systemOverlayStyle;

  Color get backgroundColor =>
      material == null ? style.backgroundColor! : Colors.transparent;

  Widget? get materialBackground =>
      material == null && style.surfaceStyle == null
      ? null
      : HyperMaterialSurface(
          material: material,
          semanticBackground:
              style.surfaceStyle?.background ??
              HyperFill.color(style.backgroundColor!),
          border: style.surfaceStyle?.border,
          boxShadow: style.surfaceStyle?.boxShadow,
          borderRadius: style.surfaceStyle?.borderRadius ?? BorderRadius.zero,
        );
}
