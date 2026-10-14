import '../../painting/hyper_box_decoration.dart';

import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../theme/core/hyper_theme.dart';

/// 轻量的主题化容器。
///
/// 视觉属性按“实例 → 容器主题 → 中性默认值”解析。
/// 所有尺寸均直接使用 Flutter 逻辑尺寸，不执行倍率换算。
class HyperContainer extends StatelessWidget {
  const HyperContainer({
    super.key,
    this.child,
    this.background,
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
    final decoration = HyperBoxDecoration(
      color: resolvedBackground.color,
      gradient: resolvedBackground.gradient,
      border: border ?? componentTheme.border,
      borderRadius: resolvedBorderRadius,
      boxShadow: boxShadow ?? componentTheme.boxShadow,
    );
    final resolvedMargin = margin ?? componentTheme.margin;
    final resolvedAlignment = alignment ?? componentTheme.alignment;
    final resolvedConstraints = constraints ?? componentTheme.constraints;
    final resolvedCurve =
        animationCurve ??
        componentTheme.animationCurve ??
        theme.motion.standardCurve;
    final resolvedClip =
        clipBehavior ?? componentTheme.clipBehavior ?? Clip.none;

    if (effectiveDuration == Duration.zero) {
      return Container(
        width: width,
        height: height,
        constraints: resolvedConstraints,
        margin: resolvedMargin,
        padding: resolvedPadding,
        alignment: resolvedAlignment,
        decoration: decoration,
        clipBehavior: resolvedClip,
        child: child,
      );
    }

    return AnimatedContainer(
      width: width,
      height: height,
      constraints: resolvedConstraints,
      margin: resolvedMargin,
      padding: resolvedPadding,
      alignment: resolvedAlignment,
      decoration: decoration,
      clipBehavior: resolvedClip,
      duration: effectiveDuration,
      curve: resolvedCurve,
      child: child,
    );
  }
}
