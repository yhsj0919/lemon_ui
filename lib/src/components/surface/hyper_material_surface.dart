import '../../painting/hyper_box_decoration.dart';
import '../../painting/hyper_surface_shadow.dart';
import 'hyper_material_edge.dart';
import '../../painting/hyper_surface_border.dart';

import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';

/// 使用统一材质配方绘制的轻量表面。
class HyperMaterialSurface extends StatelessWidget {
  const HyperMaterialSurface({
    super.key,
    this.material,
    this.materialEdge = false,
    this.semanticBackground,
    this.quality,
    this.reduceTransparency,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.alignment,
    this.borderRadius,
    this.border,
    this.boxShadow,
    this.clipBehavior = Clip.none,
    this.child,
  });

  /// 表面材质配方；null 时使用材质主题或普通表面色。
  final HyperSurfaceMaterial? material;

  /// 此表面用途的高光默认值；配方显式开关优先。
  final bool materialEdge;

  /// 继承全局高级配方时使用的组件语义底色；显式材质颜色优先。
  final HyperFill? semanticBackground;

  /// 显式轮廓（支持虚线）；空 Border 关闭材质轮廓，null 继承配方。
  final BoxBorder? border;

  /// Explicit component shadows; an empty list disables material shadows.
  final List<BoxShadow>? boxShadow;

  /// 当前表面的材质质量覆盖。
  final HyperMaterialQuality? quality;

  /// 是否为当前表面关闭透明和模糊效果。
  final bool? reduceTransparency;

  /// 明确表面宽度。
  final double? width;

  /// 明确表面高度。
  final double? height;

  /// 内容与表面边界之间的内边距。
  final EdgeInsetsGeometry? padding;

  /// 表面外部边距。
  final EdgeInsetsGeometry? margin;

  /// 内容在表面内部的对齐方式。
  final AlignmentGeometry? alignment;

  /// 表面圆角。
  final BorderRadiusGeometry? borderRadius;

  /// 材质模糊区域的裁切方式；[Clip.none] 时玻璃材质使用抗锯齿裁切。
  final Clip clipBehavior;

  /// 表面内部内容。
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final hyperTheme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final materialTheme = HyperMaterialTheme.of(context);
    final resolved =
        materialTheme.resolveMaterial(
          material: material,
          semanticBackground: semanticBackground,
          quality: quality,
          reduceTransparency: reduceTransparency,
        ) ??
        HyperSurfaceMaterial.solid(
          background:
              semanticBackground ?? HyperFill.color(hyperTheme.colors.surface),
        );
    final effectiveShadows = boxShadow ?? resolved.boxShadow;
    final radius = (borderRadius ?? BorderRadius.circular(sizes.controlRadius))
        .resolve(Directionality.of(context));
    final fill = resolved.background;
    final backgroundDecoration = BoxDecoration(
      color: fill?.color,
      gradient: fill?.gradient,
      borderRadius: radius,
    );
    final effectiveBorder =
        border ??
        (resolved.border == null || resolved.border == BorderSide.none
            ? null
            : Border.fromBorderSide(resolved.border!));
    final borderDecoration = hyperSurfaceBorderDecoration(
      effectiveBorder,
      radius,
    );

    final glass = resolved.usesBackdrop;
    final isolateShadow = hyperSurfaceShadowNeedsIsolation(
      background: fill,
      usesBackdrop: glass,
      outsideShadow: resolved.outsideShadow,
    );
    final content = ClipRRect(
      borderRadius: radius,
      clipBehavior: glass && clipBehavior == Clip.none
          ? Clip.antiAlias
          : clipBehavior,
      child: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              enabled:
                  glass && (resolved.blurSigmaX > 0 || resolved.blurSigmaY > 0),
              blendMode: BlendMode.src,
              filter: ImageFilter.blur(
                sigmaX: glass ? resolved.blurSigmaX : 0,
                sigmaY: glass ? resolved.blurSigmaY : 0,
              ),
              child: DecoratedBox(
                decoration: backgroundDecoration,
                child: ColoredBox(
                  color: resolved.tint ?? const Color(0x00000000),
                ),
              ),
            ),
          ),
          Container(
            width: width,
            height: height,
            padding: padding,
            alignment: alignment,
            // Keep the decoration ancestor present when material transitions
            // add/remove a border, so stateful content is never remounted.
            foregroundDecoration: borderDecoration ?? const BoxDecoration(),
            child: child,
          ),
        ],
      ),
    );
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: DecoratedBox(
        position: isolateShadow
            ? DecorationPosition.foreground
            : DecorationPosition.background,
        decoration: HyperBoxDecoration(
          borderRadius: radius,
          boxShadow: effectiveShadows,
          outerShadowsOnly: isolateShadow,
        ),
        child: HyperMaterialEdge(
          material: resolved,
          defaultEnabled: materialEdge,
          radius: radius,
          hasBorderOverride: border != null,
          child: content,
        ),
      ),
    );
  }
}
