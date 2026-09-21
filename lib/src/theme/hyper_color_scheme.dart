import 'package:flutter/material.dart';

/// Hyper 控件使用的语义颜色集合。
///
/// 颜色名称优先与 Flutter [ColorScheme] 保持一致，并补充 success、warning
/// 和 disabled。控件只消费语义颜色，不直接依赖种子色或固定色板。
@immutable
final class HyperColorScheme {
  const HyperColorScheme({
    required this.brightness,
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceElevated,
    required this.onSurfaceElevated,
    required this.surfaceMuted,
    required this.onSurfaceMuted,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.outline,
    required this.disabled,
    required this.stateLayer,
    required this.scrim,
    required this.error,
    required this.onError,
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
  });

  /// 使用 HyperOS 风格操作蓝或指定种子色创建亮色方案。
  factory HyperColorScheme.light({Color seedColor = const Color(0xFF3482FF)}) {
    return HyperColorScheme.fromSeed(seedColor: seedColor);
  }

  /// 使用 HyperOS 风格操作蓝或指定种子色创建暗色方案。
  factory HyperColorScheme.dark({Color seedColor = const Color(0xFF3482FF)}) {
    return HyperColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: Brightness.dark,
    );
  }

  /// 从种子色生成完整语义颜色。
  ///
  /// 基础颜色由 Flutter [ColorScheme.fromSeed] 生成。success 和 warning
  /// 保持稳定的状态语义，不跟随主色替换为含义不清的颜色。
  factory HyperColorScheme.fromSeed({
    required Color seedColor,
    Brightness brightness = Brightness.light,
  }) {
    final material = ColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    final isDark = brightness == Brightness.dark;
    final textPrimary = isDark
        ? const Color(0xFFF5F5F7)
        : const Color(0xFF19191B);

    return HyperColorScheme(
      brightness: brightness,
      // 显式种子色就是主要操作色，不再经过色调映射后悄悄改变色值。
      primary: seedColor,
      onPrimary:
          ThemeData.estimateBrightnessForColor(seedColor) == Brightness.dark
          ? Colors.white
          : Colors.black,
      primaryContainer: material.primaryContainer,
      onPrimaryContainer: material.onPrimaryContainer,
      background: isDark ? const Color(0xFF0F0F10) : const Color(0xFFF7F7F8),
      onBackground: textPrimary,
      surface: isDark ? const Color(0xFF1A1A1C) : const Color(0xFFFFFFFF),
      onSurface: textPrimary,
      surfaceElevated: isDark
          ? const Color(0xFF242426)
          : const Color(0xFFFFFFFF),
      onSurfaceElevated: textPrimary,
      surfaceMuted: isDark ? const Color(0xFF2C2C2F) : const Color(0xFFF1F1F3),
      onSurfaceMuted: isDark
          ? const Color(0xFFE7E7EA)
          : const Color(0xFF2B2B2F),
      textPrimary: textPrimary,
      textSecondary: isDark ? const Color(0xFFB8B8BD) : const Color(0xFF55555A),
      textTertiary: isDark ? const Color(0xFF85858B) : const Color(0xFF89898F),
      outline: isDark ? const Color(0xFF3A3A3E) : const Color(0xFFE2E2E5),
      disabled: isDark ? const Color(0xFF707075) : const Color(0xFFB8B8BD),
      stateLayer: isDark ? Colors.white : Colors.black,
      scrim: isDark ? const Color(0xA6000000) : const Color(0x52000000),
      error: material.error,
      onError: material.onError,
      success: isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32),
      onSuccess: isDark ? const Color(0xFF102114) : Colors.white,
      warning: isDark ? const Color(0xFFFFB74D) : const Color(0xFFF57C00),
      onWarning: isDark ? const Color(0xFF2D1600) : Colors.white,
    );
  }

  final Brightness brightness;
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceElevated;
  final Color onSurfaceElevated;
  final Color surfaceMuted;
  final Color onSurfaceMuted;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color outline;
  final Color disabled;

  /// 悬停、按压和聚焦的统一中性交互遮罩基色。
  final Color stateLayer;
  final Color scrim;
  final Color error;
  final Color onError;
  final Color success;
  final Color onSuccess;
  final Color warning;
  final Color onWarning;

  /// 创建仅替换指定字段的新颜色方案。
  HyperColorScheme copyWith({
    Brightness? brightness,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
    Color? surfaceElevated,
    Color? onSurfaceElevated,
    Color? surfaceMuted,
    Color? onSurfaceMuted,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? outline,
    Color? disabled,
    Color? stateLayer,
    Color? scrim,
    Color? error,
    Color? onError,
    Color? success,
    Color? onSuccess,
    Color? warning,
    Color? onWarning,
  }) {
    return HyperColorScheme(
      brightness: brightness ?? this.brightness,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      surfaceElevated: surfaceElevated ?? this.surfaceElevated,
      onSurfaceElevated: onSurfaceElevated ?? this.onSurfaceElevated,
      surfaceMuted: surfaceMuted ?? this.surfaceMuted,
      onSurfaceMuted: onSurfaceMuted ?? this.onSurfaceMuted,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      outline: outline ?? this.outline,
      disabled: disabled ?? this.disabled,
      stateLayer: stateLayer ?? this.stateLayer,
      scrim: scrim ?? this.scrim,
      error: error ?? this.error,
      onError: onError ?? this.onError,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
    );
  }

  /// 在两个颜色方案之间插值。
  static HyperColorScheme lerp(
    HyperColorScheme a,
    HyperColorScheme b,
    double t,
  ) {
    return HyperColorScheme(
      brightness: t < 0.5 ? a.brightness : b.brightness,
      primary: Color.lerp(a.primary, b.primary, t)!,
      onPrimary: Color.lerp(a.onPrimary, b.onPrimary, t)!,
      primaryContainer: Color.lerp(a.primaryContainer, b.primaryContainer, t)!,
      onPrimaryContainer: Color.lerp(
        a.onPrimaryContainer,
        b.onPrimaryContainer,
        t,
      )!,
      background: Color.lerp(a.background, b.background, t)!,
      onBackground: Color.lerp(a.onBackground, b.onBackground, t)!,
      surface: Color.lerp(a.surface, b.surface, t)!,
      onSurface: Color.lerp(a.onSurface, b.onSurface, t)!,
      surfaceElevated: Color.lerp(a.surfaceElevated, b.surfaceElevated, t)!,
      onSurfaceElevated: Color.lerp(
        a.onSurfaceElevated,
        b.onSurfaceElevated,
        t,
      )!,
      surfaceMuted: Color.lerp(a.surfaceMuted, b.surfaceMuted, t)!,
      onSurfaceMuted: Color.lerp(a.onSurfaceMuted, b.onSurfaceMuted, t)!,
      textPrimary: Color.lerp(a.textPrimary, b.textPrimary, t)!,
      textSecondary: Color.lerp(a.textSecondary, b.textSecondary, t)!,
      textTertiary: Color.lerp(a.textTertiary, b.textTertiary, t)!,
      outline: Color.lerp(a.outline, b.outline, t)!,
      disabled: Color.lerp(a.disabled, b.disabled, t)!,
      stateLayer: Color.lerp(a.stateLayer, b.stateLayer, t)!,
      scrim: Color.lerp(a.scrim, b.scrim, t)!,
      error: Color.lerp(a.error, b.error, t)!,
      onError: Color.lerp(a.onError, b.onError, t)!,
      success: Color.lerp(a.success, b.success, t)!,
      onSuccess: Color.lerp(a.onSuccess, b.onSuccess, t)!,
      warning: Color.lerp(a.warning, b.warning, t)!,
      onWarning: Color.lerp(a.onWarning, b.onWarning, t)!,
    );
  }

  /// 生成与 Hyper 语义颜色协调的 Flutter Material 颜色方案。
  ColorScheme toMaterialColorScheme() {
    return ColorScheme.fromSeed(
      seedColor: primary,
      brightness: brightness,
    ).copyWith(
      primary: primary,
      onPrimary: onPrimary,
      primaryContainer: primaryContainer,
      onPrimaryContainer: onPrimaryContainer,
      surface: background,
      onSurface: onBackground,
      surfaceContainer: surface,
      surfaceContainerHigh: surfaceElevated,
      surfaceContainerHighest: surfaceMuted,
      outline: outline,
      scrim: scrim,
      error: error,
      onError: onError,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is HyperColorScheme &&
            other.brightness == brightness &&
            other.primary == primary &&
            other.onPrimary == onPrimary &&
            other.primaryContainer == primaryContainer &&
            other.onPrimaryContainer == onPrimaryContainer &&
            other.background == background &&
            other.onBackground == onBackground &&
            other.surface == surface &&
            other.onSurface == onSurface &&
            other.surfaceElevated == surfaceElevated &&
            other.onSurfaceElevated == onSurfaceElevated &&
            other.surfaceMuted == surfaceMuted &&
            other.onSurfaceMuted == onSurfaceMuted &&
            other.textPrimary == textPrimary &&
            other.textSecondary == textSecondary &&
            other.textTertiary == textTertiary &&
            other.outline == outline &&
            other.disabled == disabled &&
            other.stateLayer == stateLayer &&
            other.scrim == scrim &&
            other.error == error &&
            other.onError == onError &&
            other.success == success &&
            other.onSuccess == onSuccess &&
            other.warning == warning &&
            other.onWarning == onWarning;
  }

  @override
  int get hashCode => Object.hashAll([
    brightness,
    primary,
    onPrimary,
    primaryContainer,
    onPrimaryContainer,
    background,
    onBackground,
    surface,
    onSurface,
    surfaceElevated,
    onSurfaceElevated,
    surfaceMuted,
    onSurfaceMuted,
    textPrimary,
    textSecondary,
    textTertiary,
    outline,
    disabled,
    stateLayer,
    scrim,
    error,
    onError,
    success,
    onSuccess,
    warning,
    onWarning,
  ]);
}
