import '../../painting/hyper_box_decoration.dart';
import '../../foundation/hyper_fill.dart';

import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_tag_style.dart';
import 'hyper_tag_theme.dart';

enum HyperTagVariant { standard, emphasized }

/// 标签表达的业务语义，与配色外观和交互状态分别管理。
enum HyperTagSeverity { success, warning, error, info, neutral }

/// 只展示状态或分类的轻量标签。可点击、可选择的标签由 Chip 承担。
class HyperTag extends StatelessWidget {
  const HyperTag({
    super.key,
    required this.label,
    this.icon,
    this.variant = HyperTagVariant.standard,
    this.enabled = true,
    this.style,
    this.severity,
  });

  const HyperTag.success({
    Key? key,
    required String label,
    Widget? icon,
    HyperTagVariant variant = HyperTagVariant.standard,
    bool enabled = true,
    HyperTagStyle? style,
  }) : this(
         key: key,
         label: label,
         icon: icon,
         variant: variant,
         enabled: enabled,
         style: style,
         severity: HyperTagSeverity.success,
       );

  const HyperTag.warning({
    Key? key,
    required String label,
    Widget? icon,
    HyperTagVariant variant = HyperTagVariant.standard,
    bool enabled = true,
    HyperTagStyle? style,
  }) : this(
         key: key,
         label: label,
         icon: icon,
         variant: variant,
         enabled: enabled,
         style: style,
         severity: HyperTagSeverity.warning,
       );

  const HyperTag.error({
    Key? key,
    required String label,
    Widget? icon,
    HyperTagVariant variant = HyperTagVariant.standard,
    bool enabled = true,
    HyperTagStyle? style,
  }) : this(
         key: key,
         label: label,
         icon: icon,
         variant: variant,
         enabled: enabled,
         style: style,
         severity: HyperTagSeverity.error,
       );

  /// 破坏性操作语义，使用与 [HyperTag.error] 相同的错误色。
  const HyperTag.destructive({
    Key? key,
    required String label,
    Widget? icon,
    HyperTagVariant variant = HyperTagVariant.standard,
    bool enabled = true,
    HyperTagStyle? style,
  }) : this(
         key: key,
         label: label,
         icon: icon,
         variant: variant,
         enabled: enabled,
         style: style,
         severity: HyperTagSeverity.error,
       );

  const HyperTag.info({
    Key? key,
    required String label,
    Widget? icon,
    HyperTagVariant variant = HyperTagVariant.standard,
    bool enabled = true,
    HyperTagStyle? style,
  }) : this(
         key: key,
         label: label,
         icon: icon,
         variant: variant,
         enabled: enabled,
         style: style,
         severity: HyperTagSeverity.info,
       );

  const HyperTag.neutral({
    Key? key,
    required String label,
    Widget? icon,
    HyperTagVariant variant = HyperTagVariant.standard,
    bool enabled = true,
    HyperTagStyle? style,
  }) : this(
         key: key,
         label: label,
         icon: icon,
         variant: variant,
         enabled: enabled,
         style: style,
         severity: HyperTagSeverity.neutral,
       );

  final String label;
  final Widget? icon;
  final HyperTagVariant variant;
  final bool enabled;
  final HyperTagStyle? style;

  /// null 保留普通标签的默认配色；语义色始终跟随当前主题。
  final HyperTagSeverity? severity;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).tag;
    final tagTheme = HyperTagTheme.of(context);
    final variantStyle = variant == HyperTagVariant.emphasized
        ? tagTheme.emphasized
        : const HyperTagStyle();
    final baseColor = switch (severity) {
      HyperTagSeverity.success => theme.colors.success,
      HyperTagSeverity.warning => theme.colors.warning,
      HyperTagSeverity.error => theme.colors.error,
      HyperTagSeverity.info => theme.colors.primary,
      HyperTagSeverity.neutral => theme.colors.textSecondary,
      null => null,
    };
    final resolved =
        HyperTagStyle(
              colorVariant: enabled && baseColor != null
                  ? HyperTagColorVariant.soft
                  : null,
              baseColor: enabled ? baseColor : null,
            )
            .merge(tagTheme.style)
            .merge(variantStyle)
            .merge(enabled ? null : tagTheme.disabled)
            .merge(style)
            .resolvePalette(theme.colors, theme.contrastTheme);
    final colors = theme.colors;
    final background =
        resolved.backgroundColor ??
        (!enabled
            ? colors.surfaceMuted
            : variant == HyperTagVariant.emphasized
            ? colors.primaryContainer
            : colors.surfaceMuted);
    final fill = resolved.background ?? HyperFill.color(background);
    final foreground =
        resolved.foregroundColor ??
        (!enabled
            ? colors.disabled
            : variant == HyperTagVariant.emphasized
            ? colors.onPrimaryContainer
            : colors.textSecondary);
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = reduceMotion
        ? Duration.zero
        : resolved.duration ?? theme.motion.fastDuration;
    final curve = resolved.curve ?? theme.motion.fastCurve;
    final textStyle = (theme.textTheme.labelMedium ?? const TextStyle())
        .copyWith(height: 1, color: foreground)
        .merge(resolved.textStyle);

    return Semantics(
      label: label,
      enabled: enabled,
      child: ExcludeSemantics(
        child: AnimatedContainer(
          duration: duration,
          curve: curve,
          constraints: BoxConstraints(
            minHeight: resolved.height ?? metrics.height,
          ),
          padding: EdgeInsets.symmetric(
            horizontal: resolved.horizontalPadding ?? metrics.horizontalPadding,
          ),
          decoration: HyperBoxDecoration(
            color: fill.color,
            gradient: fill.gradient,
            borderRadius: BorderRadius.circular(
              resolved.radius ?? metrics.radius,
            ),
            border:
                resolved.boxBorder ??
                ((resolved.borderWidth ?? 0) > 0
                    ? Border.all(
                        color: resolved.borderColor ?? colors.outline,
                        width: resolved.borderWidth!,
                      )
                    : null),
            boxShadow: resolved.boxShadow,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                TweenAnimationBuilder<Color?>(
                  tween: ColorTween(end: foreground),
                  duration: duration,
                  curve: curve,
                  builder: (context, color, child) => IconTheme.merge(
                    data: IconThemeData(
                      size: resolved.iconSize ?? metrics.iconSize,
                      color: color,
                    ),
                    child: child!,
                  ),
                  child: icon,
                ),
                SizedBox(width: resolved.iconSpacing ?? metrics.iconSpacing),
              ],
              Flexible(
                child: AnimatedDefaultTextStyle(
                  duration: duration,
                  curve: curve,
                  style: textStyle,
                  child: Text(
                    label,
                    textHeightBehavior: const TextHeightBehavior(
                      leadingDistribution: TextLeadingDistribution.even,
                      applyHeightToFirstAscent: false,
                      applyHeightToLastDescent: false,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
