import 'package:flutter/widgets.dart';

import '../../foundation/hyper_surface_material.dart';
import '../core/hyper_theme.dart';

const _unchanged = Object();

/// 全局材质质量、默认材质和透明度降级策略。
@immutable
final class HyperMaterialThemeData {
  const HyperMaterialThemeData({
    this.quality,
    this.reduceTransparency,
    this.material,
  });

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
  }) => (material ?? this.material)?.resolve(
    quality: quality ?? this.quality ?? HyperMaterialQuality.standard,
    reduceTransparency: reduceTransparency ?? this.reduceTransparency ?? false,
  );

  HyperMaterialThemeData copyWith({
    Object? quality = _unchanged,
    Object? reduceTransparency = _unchanged,
    Object? material = _unchanged,
  }) => HyperMaterialThemeData(
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
      quality: t < .5 ? a.quality : b.quality,
      reduceTransparency: t < .5 ? a.reduceTransparency : b.reduceTransparency,
      material: material,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperMaterialThemeData &&
          other.quality == quality &&
          other.reduceTransparency == reduceTransparency &&
          other.material == material;

  @override
  int get hashCode => Object.hash(quality, reduceTransparency, material);
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
