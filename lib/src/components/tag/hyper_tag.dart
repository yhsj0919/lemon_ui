import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_tag_style.dart';
import 'hyper_tag_theme.dart';

enum HyperTagVariant { standard, emphasized }

/// 只展示状态或分类的轻量标签。可点击、可选择的标签由 Chip 承担。
class HyperTag extends StatelessWidget {
  const HyperTag({
    super.key,
    required this.label,
    this.icon,
    this.variant = HyperTagVariant.standard,
    this.enabled = true,
    this.style,
  });

  final String label;
  final Widget? icon;
  final HyperTagVariant variant;
  final bool enabled;
  final HyperTagStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).tag;
    final tagTheme = HyperTagTheme.of(context);
    final variantStyle = variant == HyperTagVariant.emphasized
        ? tagTheme.emphasized
        : const HyperTagStyle();
    final resolved = tagTheme.style
        .merge(variantStyle)
        .merge(enabled ? null : tagTheme.disabled)
        .merge(style);
    final colors = theme.colors;
    final background =
        resolved.backgroundColor ??
        (!enabled
            ? colors.surfaceMuted
            : variant == HyperTagVariant.emphasized
            ? colors.primaryContainer
            : colors.surfaceMuted);
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
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(
              resolved.radius ?? metrics.radius,
            ),
            border: (resolved.borderWidth ?? 0) > 0
                ? Border.all(
                    color: resolved.borderColor ?? colors.outline,
                    width: resolved.borderWidth!,
                  )
                : null,
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
