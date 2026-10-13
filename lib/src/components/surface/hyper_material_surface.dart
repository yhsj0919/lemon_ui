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
    this.clipBehavior = Clip.none,
    this.child,
  });

  /// 表面材质配方；null 时使用材质主题或普通表面色。
  final HyperSurfaceMaterial? material;

  /// 继承全局高级配方时使用的组件语义底色；显式材质颜色优先。
  final HyperFill? semanticBackground;

  /// 显式轮廓（支持虚线）；空 Border 关闭材质轮廓，null 继承配方。
  final BoxBorder? border;

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
          semanticBackground:
              material == null || material == materialTheme.material
              ? semanticBackground
              : null,
          quality: quality,
          reduceTransparency: reduceTransparency,
        ) ??
        HyperSurfaceMaterial.solid(
          background: semanticBackground?.isNone == true
              ? const HyperFill.none()
              : HyperFill.color(hyperTheme.colors.surface),
        );
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
    final borderDecoration = effectiveBorder == null
        ? null
        : BoxDecoration(border: effectiveBorder, borderRadius: radius);

    if (resolved.usesBackdrop) {
      // 背景滤镜与前景内容必须是兄弟层。若把文字作为 BackdropFilter 的
      // child 一起提交，部分桌面合成器会在文字边缘产生模糊重影。
      Widget filteredBackground = DecoratedBox(
        decoration: backgroundDecoration,
        child: resolved.tint == null ? null : ColoredBox(color: resolved.tint!),
      );
      filteredBackground = BackdropFilter(
        enabled: resolved.blurSigmaX > 0 || resolved.blurSigmaY > 0,
        // Opacity/FadeTransition uses an offscreen layer before reaching
        // 1.0. Replace its filtered backdrop instead of blending it twice.
        blendMode: BlendMode.src,
        filter: ImageFilter.blur(
          sigmaX: resolved.blurSigmaX,
          sigmaY: resolved.blurSigmaY,
        ),
        child: filteredBackground,
      );

      Widget content = ClipRRect(
        borderRadius: radius,
        clipBehavior: clipBehavior == Clip.none ? Clip.antiAlias : clipBehavior,
        child: Stack(
          children: [
            Positioned.fill(child: filteredBackground),
            Container(
              width: width,
              height: height,
              padding: padding,
              alignment: alignment,
              foregroundDecoration: borderDecoration,
              child: child,
            ),
          ],
        ),
      );
      if (resolved.boxShadow.isNotEmpty) {
        content = DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: radius,
            boxShadow: resolved.boxShadow,
          ),
          child: content,
        );
      }
      if (margin != null) content = Padding(padding: margin!, child: content);
      return content;
    }

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
      decoration: backgroundDecoration.copyWith(boxShadow: resolved.boxShadow),
      foregroundDecoration: borderDecoration,
      clipBehavior: Clip.none,
      child: surfaceChild,
    );
    Widget content = surface;
    if (margin != null) content = Padding(padding: margin!, child: content);
    return content;
  }
}
