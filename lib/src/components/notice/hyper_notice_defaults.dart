import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../theme/core/hyper_theme_data.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../../theme/size/components/hyper_notice_size.dart';
import 'hyper_notice_style.dart';

/// 纯主题解析：不读取设备、不持有状态，不耦合 Alert 与 Banner 的主题。
HyperNoticeStyle noticeDefaults({
  required HyperThemeData theme,
  required HyperNoticeSize metrics,
  required HyperMaterialThemeData materialTheme,
  required HyperNoticeSeverity severity,
  required bool banner,
}) {
  final colors = theme.colors;
  final accent = switch (severity) {
    HyperNoticeSeverity.info => colors.primary,
    HyperNoticeSeverity.success => colors.success,
    HyperNoticeSeverity.warning => colors.warning,
    HyperNoticeSeverity.error => colors.error,
  };
  final icon = switch (severity) {
    HyperNoticeSeverity.info => Icons.info_outline,
    HyperNoticeSeverity.success => Icons.check_circle_outline,
    HyperNoticeSeverity.warning => Icons.warning_amber_rounded,
    HyperNoticeSeverity.error => Icons.error_outline,
  };
  return HyperNoticeStyle(
    background: HyperFill.color(
      banner
          ? colors.surfaceMuted
          : Color.alphaBlend(accent.withValues(alpha: .08), colors.surface),
    ),
    material: materialTheme.material,
    materialQuality: materialTheme.quality,
    reduceTransparency: materialTheme.reduceTransparency,
    borderRadius: BorderRadius.circular(metrics.radius),
    padding: metrics.padding,
    titleStyle: (theme.textTheme.titleSmall ?? const TextStyle()).copyWith(
      color: colors.textPrimary,
    ),
    contentStyle: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      color: colors.textSecondary,
    ),
    icon: icon,
    iconColor: accent,
    iconSize: metrics.iconSize,
    closeIcon: Icons.close,
    closeIconColor: colors.textSecondary,
    closeIconSize: metrics.closeIconSize,
    closeButtonSize: metrics.closeButtonSize,
    spacing: metrics.spacing,
    titleSpacing: metrics.titleSpacing,
    actionSpacing: metrics.actionSpacing,
    actionRunSpacing: metrics.actionRunSpacing,
    actionsAlignment: WrapAlignment.start,
    duration: theme.motion.standardDuration,
    curve: theme.motion.standardCurve,
  );
}
