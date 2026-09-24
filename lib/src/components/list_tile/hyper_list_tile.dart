import 'package:flutter/material.dart';

import '../../foundation/hyper_control_state.dart';
import '../../foundation/hyper_state_value.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/core/hyper_theme.dart';
import '../icon/hyper_icon_style.dart';
import '../icon/hyper_icon_theme.dart';
import 'hyper_list_tile_style.dart';
import 'hyper_list_tile_theme.dart';

/// 列表项的信息密度；具体高度由当前设备尺寸主题决定。
enum HyperListTileDensity { standard, compact }

/// 遵循 MIUIX BasicComponent 结构的基础列表项。
///
/// 组件只负责首部、正文、尾部的排布和整行交互；卡片背景、分组圆角由外层
/// 容器负责，不附加导航、选择或开关语义。进入下一级页面时使用
/// `HyperNavigationListTile`。
class HyperListTile extends StatelessWidget {
  const HyperListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.density = HyperListTileDensity.standard,
    this.onTap,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
    this.style,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;
  final Widget? trailing;

  /// 默认行适合常规设置页，紧凑行适合设备信息等高密度列表。
  final HyperListTileDensity density;
  final VoidCallback? onTap;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? semanticLabel;

  /// 当前实例的覆盖，优先级高于全局和局部主题。
  final HyperListTileStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).listTile;
    final resolved = HyperListTileStyle(
      foregroundColor: theme.colors.textPrimary,
      subtitleColor: theme.colors.textSecondary,
      trailingColor: theme.colors.textTertiary,
      disabledColor: theme.colors.disabled,
      overlayColor: theme.colors.stateLayer,
      titleStyle: theme.textTheme.titleMedium?.copyWith(
        fontSize: theme.typography.listTitle,
        height: theme.typography.listTitleLineHeight,
      ),
      subtitleStyle: theme.textTheme.bodySmall?.copyWith(
        fontSize: theme.typography.listSubtitle,
        height: theme.typography.listSubtitleLineHeight,
      ),
      padding: switch (density) {
        HyperListTileDensity.standard => metrics.padding,
        HyperListTileDensity.compact => metrics.compactPadding,
      },
      minHeight: switch (density) {
        HyperListTileDensity.standard =>
          subtitle == null ? metrics.minHeight : metrics.subtitleMinHeight,
        HyperListTileDensity.compact =>
          subtitle == null
              ? metrics.compactMinHeight
              : metrics.compactSubtitleMinHeight,
      },
      leadingSize: metrics.leadingSize,
      leadingSpacing: metrics.leadingSpacing,
      trailingSpacing: metrics.trailingSpacing,
      trailingIconSize: metrics.trailingIconSize,
      animationDuration: theme.motion.fastDuration,
      animationCurve: theme.motion.standardCurve,
    ).merge(HyperListTileTheme.of(context).style).merge(style);

    return HyperPressable(
      enabled: enabled && onTap != null,
      onTap: onTap,
      autofocus: autofocus,
      focusNode: focusNode,
      semanticLabel: semanticLabel,
      semanticButton: onTap != null,
      mouseCursor: onTap == null
          ? SystemMouseCursors.basic
          : SystemMouseCursors.click,
      builder: (context, states, child) {
        final interactive =
            states.contains(HyperControlState.pressed) ||
            states.contains(HyperControlState.focused) ||
            states.contains(HyperControlState.hovered);
        final foreground = enabled
            ? resolved.foregroundColor!
            : resolved.disabledColor!;
        final subtitleColor = enabled
            ? resolved.subtitleColor!
            : resolved.disabledColor!;
        final contentPadding = resolved.padding!.resolve(
          Directionality.of(context),
        );

        return AnimatedContainer(
          duration: resolved.animationDuration!,
          curve: resolved.animationCurve!,
          constraints: BoxConstraints(minHeight: resolved.minHeight!),
          color: interactive
              ? resolved.overlayColor!.withValues(
                  alpha: states.contains(HyperControlState.pressed) ? .10 : .06,
                )
              : Colors.transparent,
          child: Padding(
            padding: EdgeInsets.only(
              left: contentPadding.left,
              right: contentPadding.right,
            ),
            child: IconTheme(
              data: IconThemeData(color: foreground),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (leading != null) ...[
                    SizedBox.square(
                      dimension: resolved.leadingSize,
                      child: Center(child: leading),
                    ),
                    SizedBox(width: resolved.leadingSpacing),
                  ],
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: contentPadding.top,
                        bottom: contentPadding.bottom,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DefaultTextStyle.merge(
                            style: resolved.titleStyle!.copyWith(
                              color: foreground,
                            ),
                            child: title,
                          ),
                          if (subtitle != null)
                            DefaultTextStyle.merge(
                              style: resolved.subtitleStyle!.copyWith(
                                color: subtitleColor,
                              ),
                              child: subtitle!,
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (trailing != null) ...[
                    SizedBox(width: resolved.trailingSpacing),
                    DefaultTextStyle.merge(
                      style: resolved.subtitleStyle!.copyWith(
                        color: enabled
                            ? resolved.trailingColor
                            : resolved.disabledColor,
                      ),
                      child: HyperIconTheme(
                        data: HyperIconThemeData(
                          style: HyperIconStyle(
                            color: HyperStateValue.all(
                              enabled
                                  ? resolved.trailingColor!
                                  : resolved.disabledColor!,
                            ),
                            size: HyperStateValue.all(
                              resolved.trailingIconSize!,
                            ),
                          ),
                        ),
                        child: IconTheme.merge(
                          data: IconThemeData(
                            color: enabled
                                ? resolved.trailingColor
                                : resolved.disabledColor,
                            size: resolved.trailingIconSize,
                          ),
                          child: trailing!,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
