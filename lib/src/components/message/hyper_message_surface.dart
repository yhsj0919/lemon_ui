import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../button/hyper_button_theme.dart';
import '../surface/hyper_material_surface.dart';
import 'hyper_message_style.dart';
import 'hyper_toast_theme.dart';
import 'hyper_snackbar_theme.dart';

HyperMessageStyle resolveMessageStyle(
  BuildContext context,
  bool toast,
  HyperMessageStyle? style,
) {
  final theme = HyperTheme.of(context);
  final sizes = HyperTheme.sizesOf(context);
  final metrics = toast ? sizes.toast : sizes.snackbar;
  final materialTheme = HyperMaterialTheme.of(context);
  return HyperMessageStyle(
        background: HyperFill.color(theme.colors.surfaceElevated),
        material: materialTheme.material,
        materialQuality: materialTheme.quality,
        reduceTransparency: materialTheme.reduceTransparency,
        borderRadius: BorderRadius.circular(metrics.radius),
        maxWidth: metrics.maxWidth,
        padding: metrics.padding,
        textStyle: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
          color: theme.colors.textPrimary,
        ),
        iconColor: theme.colors.textSecondary,
        iconSize: metrics.iconSize,
        spacing: metrics.spacing,
        entryOffset: const Offset(0, .15),
        animationStyle: AnimationStyle(
          duration: theme.motion.standardDuration,
          reverseDuration: theme.motion.fastDuration,
          curve: theme.motion.standardCurve,
          reverseCurve: theme.motion.fastCurve,
        ),
      )
      .merge(
        toast
            ? HyperToastTheme.of(context).style
            : HyperSnackbarTheme.of(context).style,
      )
      .merge(style);
}

/// 内部表面：主题由调用者解析，Toast 与 Snackbar 只共享绘制布局。
class HyperMessageSurface extends StatelessWidget {
  const HyperMessageSurface({
    super.key,
    required this.content,
    required this.style,
    this.icon,
    this.action,
    this.semanticLabel,
  });
  final Widget content;
  final Widget? icon;
  final Widget? action;
  final String? semanticLabel;
  final HyperMessageStyle style;
  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: style.padding!,
      child: DefaultTextStyle(
        style: style.textStyle!,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              IconTheme(
                data: IconThemeData(
                  color: style.iconColor,
                  size: style.iconSize,
                ),
                child: icon!,
              ),
              SizedBox(width: style.spacing),
            ],
            Flexible(child: content),
            if (action != null) ...[
              SizedBox(width: style.spacing),
              if (style.buttonTheme != null)
                HyperButtonTheme(data: style.buttonTheme!, child: action!)
              else
                action!,
            ],
          ],
        ),
      ),
    );
    Widget result = Container(
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: style.material == null ? style.background?.color : null,
        gradient: style.material == null ? style.background?.gradient : null,
        border: style.border,
        borderRadius: style.borderRadius,
        boxShadow: style.boxShadow,
      ),
      child: ClipRRect(
        borderRadius: style.borderRadius!,
        child: Material(type: MaterialType.transparency, child: body),
      ),
    );
    if (style.material != null) {
      result = HyperMaterialSurface(
        material: style.material,
        quality: style.materialQuality,
        reduceTransparency: style.reduceTransparency,
        borderRadius: style.borderRadius,
        clipBehavior: Clip.antiAlias,
        child: result,
      );
    }
    return Semantics(
      liveRegion: true,
      label: semanticLabel,
      excludeSemantics: semanticLabel != null,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: style.maxWidth!),
        child: result,
      ),
    );
  }
}
