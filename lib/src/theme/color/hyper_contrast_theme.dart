import 'package:flutter/widgets.dart';

import '../../foundation/hyper_fill.dart';
import '../core/hyper_theme.dart';

/// 前景颜色与背景之间的反色策略。
enum HyperContrastMode { standard, adaptive, inverted }

/// 全局前景反色与对比度配置。
@immutable
final class HyperContrastThemeData {
  const HyperContrastThemeData({
    this.mode = HyperContrastMode.standard,
    this.lightForeground = const Color(0xFFFFFFFF),
    this.darkForeground = const Color(0xFF202124),
  });

  /// 默认反色模式。
  final HyperContrastMode mode;

  /// 深色背景上使用的浅色前景。
  final Color lightForeground;

  /// 浅色背景上使用的深色前景。
  final Color darkForeground;

  HyperContrastThemeData copyWith({
    HyperContrastMode? mode,
    Color? lightForeground,
    Color? darkForeground,
  }) => HyperContrastThemeData(
    mode: mode ?? this.mode,
    lightForeground: lightForeground ?? this.lightForeground,
    darkForeground: darkForeground ?? this.darkForeground,
  );

  /// 根据最终背景选择前景。半透明背景先与 [canvasColor] 合成。
  Color resolve({
    required Color foreground,
    required HyperFill? background,
    required Color canvasColor,
    HyperContrastMode? mode,
    double? backgroundLuminance,
  }) {
    final effectiveMode = mode ?? this.mode;
    if (effectiveMode == HyperContrastMode.standard) return foreground;
    if (effectiveMode == HyperContrastMode.inverted) {
      return foreground.computeLuminance() > .5
          ? darkForeground
          : lightForeground;
    }
    final luminance =
        backgroundLuminance ??
        _backgroundColor(background, canvasColor).computeLuminance();
    final lightRatio = _contrastRatio(
      lightForeground.computeLuminance(),
      luminance,
    );
    final darkRatio = _contrastRatio(
      darkForeground.computeLuminance(),
      luminance,
    );
    return lightRatio >= darkRatio ? lightForeground : darkForeground;
  }

  static Color _backgroundColor(HyperFill? fill, Color canvasColor) {
    final sampled = switch (fill) {
      HyperColorFill(:final value) => value,
      HyperGradientFill(:final value) => _average(value.colors),
      _ => canvasColor,
    };
    return Color.alphaBlend(sampled, canvasColor);
  }

  static Color _average(List<Color> colors) {
    if (colors.isEmpty) return const Color(0x00000000);
    var a = 0.0;
    var r = 0.0;
    var g = 0.0;
    var b = 0.0;
    for (final color in colors) {
      a += color.a;
      r += color.r;
      g += color.g;
      b += color.b;
    }
    final count = colors.length;
    return Color.from(
      alpha: a / count,
      red: r / count,
      green: g / count,
      blue: b / count,
    );
  }

  static double _contrastRatio(double a, double b) {
    final lighter = a > b ? a : b;
    final darker = a > b ? b : a;
    return (lighter + .05) / (darker + .05);
  }

  static HyperContrastThemeData lerp(
    HyperContrastThemeData a,
    HyperContrastThemeData b,
    double t,
  ) => HyperContrastThemeData(
    mode: t < .5 ? a.mode : b.mode,
    lightForeground: Color.lerp(a.lightForeground, b.lightForeground, t)!,
    darkForeground: Color.lerp(a.darkForeground, b.darkForeground, t)!,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperContrastThemeData &&
          other.mode == mode &&
          other.lightForeground == lightForeground &&
          other.darkForeground == darkForeground;

  @override
  int get hashCode => Object.hash(mode, lightForeground, darkForeground);
}

/// 为子树替换全局反色策略。
class HyperContrastTheme extends InheritedTheme {
  const HyperContrastTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// 当前子树覆盖的反色主题。
  final HyperContrastThemeData data;

  static HyperContrastThemeData of(BuildContext context) =>
      maybeOf(context) ?? HyperTheme.of(context).contrastTheme;

  static HyperContrastThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HyperContrastTheme>()?.data;

  @override
  bool updateShouldNotify(HyperContrastTheme oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      HyperContrastTheme(data: data, child: child);
}
