import 'package:flutter/widgets.dart';

import '../../foundation/hyper_surface_material.dart';
import '../../foundation/hyper_fill.dart';
import '../core/hyper_theme.dart';

const _unchanged = Object();

/// 全局材质质量、默认材质和透明度降级策略。
@immutable
final class HyperMaterialThemeData {
  const HyperMaterialThemeData({
    this.transitionFadeFraction,
    this.transitionProgress,
    this.quality,
    this.reduceTransparency,
    this.material,
  });

  /// 开合动画中普通表面淡入段所占比例；默认 .6。
  final double? transitionFadeFraction;

  /// 动画层提供的高级材质恢复进度，null 表示稳定状态。
  final double? transitionProgress;

  /// 材质渲染质量；null 表示继承。
  final HyperMaterialQuality? quality;

  /// 是否关闭透明和模糊效果；null 表示继承。
  final bool? reduceTransparency;

  /// 子树默认使用的表面材质；null 表示继承。
  final HyperSurfaceMaterial? material;

  /// 统一选择实例或主题材质，并应用质量与减少透明度策略。
  HyperSurfaceMaterial? resolveMaterial({
    HyperSurfaceMaterial? material,
    HyperMaterialQuality? quality,
    bool? reduceTransparency,
    // 继承配方时由消费者传入；显式组件配方不传，保留完整覆盖。
    HyperFill? semanticBackground,
  }) {
    var recipe = material ?? this.material;
    // An unspecified recipe background inherits the component semantic fill.
    // HyperFill.none remains an explicit transparent override.
    if (recipe != null &&
        recipe.background == null && !recipe.usesBackdrop &&
        semanticBackground != null) {
      recipe = recipe.copyWith(background: semanticBackground);
    }
    if (recipe?.usesBackdrop == true && semanticBackground != null) {
      if (semanticBackground.isNone) return null;
      final opacity =
          recipe!.background?.color?.a ??
          recipe.background?.gradient?.colors.first.a ??
          1;
      HyperFill tinted(double alpha) => semanticBackground.color != null
          ? HyperFill.color(
              semanticBackground.color!.withValues(
                alpha: semanticBackground.color!.a * alpha,
              ),
            )
          : HyperFill.gradient(semanticBackground.gradient!.scale(alpha));
      final hue =
          semanticBackground.color ?? semanticBackground.gradient!.colors.first;
      final fallback =
          recipe.fallback ??
          recipe.resolve(quality: HyperMaterialQuality.standard);
      recipe = recipe.copyWith(
        background: tinted(opacity),
        tint: recipe.tint == null
            ? null
            : hue.withValues(alpha: recipe.tint!.a * hue.a),
        fallback: fallback.copyWith(background: tinted(1), tint: null),
      );
    }
    final resolved = recipe?.resolve(
      quality: quality ?? this.quality ?? HyperMaterialQuality.standard,
      reduceTransparency:
          reduceTransparency ?? this.reduceTransparency ?? false,
    );
    if (resolved == null ||
        !resolved.usesBackdrop ||
        transitionProgress == null) {
      return resolved;
    }
    final progress = transitionProgress!.clamp(0.0, 1.0);
    if (progress == 1) return resolved;
    final ordinary = resolved.resolve(quality: HyperMaterialQuality.standard);
    // Keep the same painting structure; a zero-radius filter is disabled by
    // consumers during the opacity stage. Only recipe parameters interpolate.
    final source = ordinary.copyWith(
      kind: resolved.kind,
      blurSigmaX: 0,
      blurSigmaY: 0,
    );
    return HyperSurfaceMaterial.lerp(source, resolved, progress);
  }

  HyperMaterialThemeData copyWith({
    Object? transitionFadeFraction = _unchanged,
    Object? transitionProgress = _unchanged,
    Object? quality = _unchanged,
    Object? reduceTransparency = _unchanged,
    Object? material = _unchanged,
  }) => HyperMaterialThemeData(
    transitionFadeFraction: identical(transitionFadeFraction, _unchanged)
        ? this.transitionFadeFraction
        : transitionFadeFraction as double?,
    transitionProgress: identical(transitionProgress, _unchanged)
        ? this.transitionProgress
        : transitionProgress as double?,
    quality: identical(quality, _unchanged)
        ? this.quality
        : quality as HyperMaterialQuality?,
    reduceTransparency: identical(reduceTransparency, _unchanged)
        ? this.reduceTransparency
        : reduceTransparency as bool?,
    material: identical(material, _unchanged)
        ? this.material
        : material as HyperSurfaceMaterial?,
  );

  HyperMaterialThemeData merge(HyperMaterialThemeData? other) => other == null
      ? this
      : HyperMaterialThemeData(
          transitionFadeFraction:
              other.transitionFadeFraction ?? transitionFadeFraction,
          transitionProgress: other.transitionProgress == null
              ? transitionProgress
              : transitionProgress == null
              ? other.transitionProgress
              : (other.transitionProgress! < transitionProgress!
                    ? other.transitionProgress
                    : transitionProgress),
          quality: other.quality ?? quality,
          reduceTransparency: other.reduceTransparency ?? reduceTransparency,
          material: other.material ?? material,
        );

  static HyperMaterialThemeData lerp(
    HyperMaterialThemeData a,
    HyperMaterialThemeData b,
    double t,
  ) {
    HyperSurfaceMaterial? material;
    if (a.material != null && b.material != null) {
      material = HyperSurfaceMaterial.lerp(a.material!, b.material!, t);
    } else {
      material = t < .5 ? a.material : b.material;
    }
    return HyperMaterialThemeData(
      transitionFadeFraction:
          a.transitionFadeFraction == null || b.transitionFadeFraction == null
          ? (t < .5 ? a.transitionFadeFraction : b.transitionFadeFraction)
          : a.transitionFadeFraction! +
                (b.transitionFadeFraction! - a.transitionFadeFraction!) * t,
      transitionProgress:
          a.transitionProgress == null || b.transitionProgress == null
          ? (t < .5 ? a.transitionProgress : b.transitionProgress)
          : a.transitionProgress! +
                (b.transitionProgress! - a.transitionProgress!) * t,
      quality: t < .5 ? a.quality : b.quality,
      reduceTransparency: t < .5 ? a.reduceTransparency : b.reduceTransparency,
      material: material,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperMaterialThemeData &&
          other.transitionFadeFraction == transitionFadeFraction &&
          other.transitionProgress == transitionProgress &&
          other.quality == quality &&
          other.reduceTransparency == reduceTransparency &&
          other.material == material;

  @override
  int get hashCode => Object.hash(
    quality,
    reduceTransparency,
    material,
    transitionFadeFraction,
    transitionProgress,
  );
}

/// 在子树中显式替换材质策略。
class HyperMaterialTheme extends StatelessWidget {
  const HyperMaterialTheme({
    super.key,
    required this.data,
    required this.child,
  });

  /// 当前子树覆盖的材质主题。
  final HyperMaterialThemeData data;

  /// 应用材质主题的子树。
  final Widget child;

  static HyperMaterialThemeData of(BuildContext context) =>
      maybeOf(context) ?? HyperTheme.of(context).materialTheme;

  static HyperMaterialThemeData? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_HyperMaterialThemeScope>()
      ?.data;

  @override
  Widget build(BuildContext context) =>
      _HyperMaterialThemeScope(data: of(context).merge(data), child: child);
}

class _HyperMaterialThemeScope extends InheritedTheme {
  const _HyperMaterialThemeScope({required this.data, required super.child});

  final HyperMaterialThemeData data;

  @override
  bool updateShouldNotify(_HyperMaterialThemeScope oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _HyperMaterialThemeScope(data: data, child: child);
}
