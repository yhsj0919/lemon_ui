import '../../foundation/hyper_surface_material.dart';
import '../surface/hyper_material_surface.dart';

import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../theme/core/hyper_theme.dart';
import '../../foundation/hyper_image_colors.dart';

part 'hyper_container_image_gradient.dart';

/// 轻量的主题化容器。
///
/// 视觉属性按“实例 → 容器主题 → 中性默认值”解析。
/// 所有尺寸均直接使用 Flutter 逻辑尺寸，不执行倍率换算。
class HyperContainer extends StatelessWidget {
  /// Creates a gradient from [startColor] to a native Material color of [image].
  ///
  /// Accepts NetworkImage, AssetImage, MemoryImage and platform file providers.
  /// Loading and failures use [fallbackColor], or [startColor].
  /// The endpoint defaults to primary; [colorRole] can select primaryContainer.
  /// [colorStrength] blends the image color toward [startColor], defaulting to
  /// the container theme's imageColorStrength or 0.2. A value of one uses raw color.
  /// The default direction is top to bottom; container theme overrides still apply.
  factory HyperContainer.imageGradient({
    Key? key,
    required ImageProvider image,
    required Color startColor,
    HyperImageColorRole colorRole = HyperImageColorRole.primary,
    double? colorStrength,
    Color? fallbackColor,
    AlignmentGeometry begin = Alignment.topCenter,
    AlignmentGeometry end = Alignment.bottomCenter,
    List<double>? stops,
    ValueChanged<Color>? onColorExtracted,
    ValueChanged<Object>? onImageError,
    Widget? child,
    HyperSurfaceMaterial? material,
    BoxBorder? border,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
    double? width,
    double? height,
    BoxConstraints? constraints,
    Duration? animationDuration,
    Curve? animationCurve,
    Clip? clipBehavior,
  }) {
    if (colorStrength != null &&
        (!colorStrength.isFinite || colorStrength < 0 || colorStrength > 1)) {
      throw ArgumentError.value(colorStrength, 'colorStrength');
    }
    if (stops != null &&
        (stops.length != 2 ||
            stops.any((stop) => !stop.isFinite || stop < 0 || stop > 1) ||
            stops[0] > stops[1])) {
      throw ArgumentError.value(stops, 'stops', '需要两个按顺序排列的 0 到 1 之间的位置');
    }
    return _HyperImageGradientContainer(
      key: key,
      image: image,
      startColor: startColor,
      colorRole: colorRole,
      colorStrength: colorStrength,
      fallbackColor: fallbackColor,
      begin: begin,
      end: end,
      onColorExtracted: onColorExtracted,
      onImageError: onImageError,
      stops: stops == null ? null : List<double>.unmodifiable(stops),
      material: material,
      border: border,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
      padding: padding,
      margin: margin,
      alignment: alignment,
      width: width,
      height: height,
      constraints: constraints,
      animationDuration: animationDuration,
      animationCurve: animationCurve,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  const HyperContainer({
    super.key,
    this.child,
    this.background,
    this.material,
    this.border,
    this.borderRadius,
    this.boxShadow,
    this.padding,
    this.margin,
    this.alignment,
    this.width,
    this.height,
    this.constraints,
    this.animationDuration,
    this.animationCurve,
    this.clipBehavior,
  });

  /// 容器内部内容。
  final Widget? child;

  /// 容器背景，支持纯色、渐变和显式无背景。
  final HyperFill? background;

  /// 实例表面配方，未指定时使用容器主题。
  final HyperSurfaceMaterial? material;

  /// 容器边框。
  final BoxBorder? border;

  /// 容器圆角。
  final BorderRadiusGeometry? borderRadius;

  /// 空列表表示显式关闭主题阴影。
  final List<BoxShadow>? boxShadow;

  /// 内容与容器边界之间的内边距。
  final EdgeInsetsGeometry? padding;

  /// 容器外部边距。
  final EdgeInsetsGeometry? margin;

  /// 内容在容器内部的对齐方式。
  final AlignmentGeometry? alignment;

  /// 明确容器宽度。
  final double? width;

  /// 明确容器高度。
  final double? height;

  /// 额外尺寸约束。
  final BoxConstraints? constraints;

  /// 样式变化动画时长；[Duration.zero] 表示不创建动画。
  final Duration? animationDuration;

  /// 样式变化动画曲线。
  final Curve? animationCurve;

  /// 内容裁切方式；默认不裁切。
  ///
  /// 容器阴影属于装饰层，不受子内容裁切影响。需要允许子内容越界时可明确
  /// 传入 [Clip.none]。
  final Clip? clipBehavior;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final componentTheme = theme.containerTheme;
    final resolvedBackground =
        background ?? componentTheme.background ?? const HyperFill.none();
    final resolvedBorderRadius =
        borderRadius ?? componentTheme.borderRadius ?? BorderRadius.zero;
    final resolvedPadding =
        padding ?? componentTheme.padding ?? EdgeInsets.zero;
    final resolvedDuration =
        animationDuration ??
        componentTheme.animationDuration ??
        theme.motion.standardDuration;
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final effectiveDuration = reduceMotion ? Duration.zero : resolvedDuration;
    final resolvedMargin = margin ?? componentTheme.margin;
    final resolvedAlignment = alignment ?? componentTheme.alignment;
    final resolvedConstraints = constraints ?? componentTheme.constraints;
    final resolvedCurve =
        animationCurve ??
        componentTheme.animationCurve ??
        theme.motion.standardCurve;
    final resolvedClip =
        clipBehavior ?? componentTheme.clipBehavior ?? Clip.none;

    return AnimatedContainer(
      width: width,
      height: height,
      constraints: resolvedConstraints,
      margin: resolvedMargin,
      duration: effectiveDuration,
      curve: resolvedCurve,
      child: HyperMaterialSurface(
        material:
            material ??
            componentTheme.material ??
            HyperSurfaceMaterial.solid(background: resolvedBackground),
        semanticBackground: resolvedBackground.isNone
            ? null
            : resolvedBackground,
        borderRadius: resolvedBorderRadius,
        border: border ?? componentTheme.border,
        boxShadow: boxShadow ?? componentTheme.boxShadow,
        padding: resolvedPadding.add(
          (border ?? componentTheme.border)?.dimensions ?? EdgeInsets.zero,
        ),
        alignment: resolvedAlignment,
        clipBehavior: resolvedClip,
        child: child,
      ),
    );
  }
}
