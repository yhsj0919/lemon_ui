import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show defaultTargetPlatform;

import '../../adaptive/hyper_device_detector.dart';
import '../../foundation/hyper_device_type.dart';
import '../size/hyper_size_scheme.dart';
import 'hyper_theme_data.dart';

/// 为子树提供全局或局部 Hyper 主题，并在主题变化时统一执行动画。
class HyperTheme extends StatelessWidget {
  const HyperTheme({
    super.key,
    required this.data,
    required this.child,
    this.duration,
    this.curve,
    this.applyToMaterial = true,
  });

  /// 当前作用域使用的完整主题。
  /// 当前子树使用的完整 Hyper 主题。
  final HyperThemeData data;

  /// 主题作用域中的内容。
  /// 应用主题的子树。
  final Widget child;

  /// 局部动画时长；未指定时使用 [HyperThemeData.animationDuration]。
  final Duration? duration;

  /// 局部动画曲线；未指定时使用 [HyperThemeData.animationCurve]。
  final Curve? curve;

  /// 是否同步更新子树中的 Flutter Material 主题。
  /// 是否同步生成 Flutter [Theme]，供基础 Material 控件使用。
  final bool applyToMaterial;

  /// 获取最近的显式 Hyper 主题；不存在时从 Material 主题安全生成。
  static HyperThemeData of(BuildContext context) {
    return maybeOf(context) ?? HyperThemeData.fromMaterial(Theme.of(context));
  }

  /// 获取最近的显式主题或 Material ThemeExtension。
  static HyperThemeData? maybeOf(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_HyperThemeScope>();
    if (scope != null) {
      return scope.data;
    }
    return Theme.of(context).extension<HyperThemeData>();
  }

  /// 获取当前设备已解析的单套尺寸。
  static HyperSizeScheme sizesOf(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_HyperThemeScope>();
    if (scope != null) return scope.sizes;
    final data = Theme.of(context).extension<HyperThemeData>();
    final deviceType =
        HyperDeviceDetector.maybeOf(context) ??
        _fallbackDeviceType(defaultTargetPlatform);
    return (data ?? HyperThemeData.fromMaterial(Theme.of(context))).sizes
        .resolve(deviceType);
  }

  @override
  Widget build(BuildContext context) {
    final detected = HyperDeviceDetector.maybeOf(context);
    if (detected == null) {
      return HyperDeviceDetector(
        builder: (context, deviceType, _) =>
            _buildResolved(context, deviceType),
      );
    }
    return _buildResolved(context, detected);
  }

  Widget _buildResolved(BuildContext context, HyperDeviceType deviceType) {
    final media = MediaQuery.maybeOf(context);
    final reduceMotion = media?.disableAnimations ?? false;
    final effectiveDuration = reduceMotion
        ? Duration.zero
        : duration ?? data.motion.standardDuration;
    final material = Theme.of(context);

    Widget buildScope(HyperThemeData value) {
      Widget result = _HyperThemeScope(
        data: value,
        sizes: value.sizes.resolve(deviceType),
        child: child,
      );
      if (applyToMaterial) {
        result = Theme(
          data: value.toMaterialThemeData(material),
          child: result,
        );
      }
      return result;
    }

    if (effectiveDuration == Duration.zero) {
      return buildScope(data);
    }

    return TweenAnimationBuilder<HyperThemeData>(
      tween: HyperThemeDataTween(end: data),
      duration: effectiveDuration,
      curve: curve ?? data.motion.standardCurve,
      builder: (context, value, _) => buildScope(value),
    );
  }
}

HyperDeviceType _fallbackDeviceType(TargetPlatform platform) =>
    switch (platform) {
      TargetPlatform.android || TargetPlatform.iOS => HyperDeviceType.phone,
      _ => HyperDeviceType.desktop,
    };

class _HyperThemeScope extends InheritedTheme {
  const _HyperThemeScope({
    required this.data,
    required this.sizes,
    required super.child,
  });

  final HyperThemeData data;
  final HyperSizeScheme sizes;

  @override
  bool updateShouldNotify(_HyperThemeScope oldWidget) =>
      data != oldWidget.data || sizes != oldWidget.sizes;

  @override
  Widget wrap(BuildContext context, Widget child) {
    return _HyperThemeScope(data: data, sizes: sizes, child: child);
  }
}
