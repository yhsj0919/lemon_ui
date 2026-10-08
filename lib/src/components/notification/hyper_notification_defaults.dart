import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../theme/core/hyper_theme_data.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../../theme/size/components/hyper_notification_size.dart';
import 'hyper_notification_style.dart';

HyperNotificationStyle notificationDefaults({
  required HyperThemeData theme,
  required HyperNotificationSize metrics,
  required HyperMaterialThemeData materialTheme,
  required bool isRead,
}) => HyperNotificationStyle(
  background: HyperFill.color(theme.colors.surfaceElevated),
  material: materialTheme.material,
  materialQuality: materialTheme.quality,
  reduceTransparency: materialTheme.reduceTransparency,
  borderRadius: BorderRadius.circular(metrics.radius),
  padding: metrics.padding,
  titleStyle: (theme.textTheme.titleSmall ?? const TextStyle()).copyWith(
    color: isRead ? theme.colors.textSecondary : theme.colors.textPrimary,
  ),
  contentStyle: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
    color: theme.colors.textSecondary,
  ),
  timeStyle: (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
    color: theme.colors.textTertiary,
  ),
  icon: Icons.notifications_none,
  iconColor: theme.colors.primary,
  iconSize: metrics.iconSize,
  unreadColor: theme.colors.primary,
  unreadSize: metrics.unreadSize,
  unreadLabel: '未读',
  closeIcon: Icons.close,
  closeIconColor: theme.colors.textSecondary,
  closeIconSize: metrics.closeIconSize,
  closeButtonSize: metrics.closeButtonSize,
  spacing: metrics.spacing,
  titleSpacing: metrics.titleSpacing,
  actionSpacing: metrics.actionSpacing,
  actionRunSpacing: metrics.actionRunSpacing,
  actionsAlignment: WrapAlignment.start,
  overlayColor: theme.colors.stateLayer,
  hoverOpacity: .06,
  focusOpacity: .06,
  pressedOpacity: .10,
  disabledOpacity: .38,
  duration: theme.motion.fastDuration,
  curve: theme.motion.fastCurve,
);
