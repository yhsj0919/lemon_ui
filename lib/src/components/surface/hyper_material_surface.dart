import 'dart:ui';

import 'package:flutter/widgets.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';
import '../../theme/hyper_material_theme.dart';
import '../../theme/hyper_theme.dart';

/// 使用统一材质配方绘制的轻量表面。
class HyperMaterialSurface extends StatelessWidget {
  const HyperMaterialSurface({
    super.key,
    this.material,
    this.quality,
    this.reduceTransparency,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.alignment,
    this.borderRadius,
    this.clipBehavior = Clip.none,
    this.child,
  });

  /// 表面材质配方；null 时使用材质主题或普通表面色。
  final HyperSurfaceMaterial? material;

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
    final materialTheme = HyperMaterialTheme.of(context);
    final source =
        material ??
        materialTheme.material ??
        HyperSurfaceMaterial.solid(
          background: HyperFill.color(hyperTheme.colors.surface),
        );
    final resolved = source.resolve(
      quality:
          quality ?? materialTheme.quality ?? HyperMaterialQuality.standard,
      reduceTransparency:
          reduceTransparency ?? materialTheme.reduceTransparency ?? false,
    );
    final radius = (borderRadius ?? hyperTheme.borderRadius).resolve(
      Directionality.of(context),
    );
    final fill = resolved.background;
    final decoration = BoxDecoration(
      color: fill?.color,
      gradient: fill?.gradient,
      borderRadius: radius,
      boxShadow: resolved.boxShadow,
    );
    Widget? surfaceChild = child;
    if (resolved.tint != null) {
      surfaceChild = Stack(
        fit: StackFit.passthrough,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: resolved.tint,
                  borderRadius: radius,
                ),
              ),
            ),
          ),
          ?child,
        ],
      );
    }
    Widget surface = Container(
      width: width,
      height: height,
      padding: padding,
      alignment: alignment,
      decoration: decoration,
      foregroundDecoration:
          resolved.border == null || resolved.border == BorderSide.none
          ? null
          : BoxDecoration(
              border: Border.fromBorderSide(resolved.border!),
              borderRadius: radius,
            ),
      clipBehavior: Clip.none,
      child: surfaceChild,
    );
    Widget content = surface;
    if (resolved.usesBackdrop) {
      content = ClipRRect(
        borderRadius: radius,
        clipBehavior: clipBehavior == Clip.none ? Clip.antiAlias : clipBehavior,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: resolved.blurSigmaX,
            sigmaY: resolved.blurSigmaY,
          ),
          child: surface,
        ),
      );
    }
    if (margin != null) content = Padding(padding: margin!, child: content);
    return content;
  }
}
