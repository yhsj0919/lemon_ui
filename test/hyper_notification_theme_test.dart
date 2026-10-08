import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/notification/hyper_notification_defaults.dart';

void main() {
  test('已读语义与统一材质继承', () {
    final theme = HyperThemeData.light();
    const material = HyperMaterialThemeData(
      material: HyperSurfaceMaterial.frostedGlass(),
      quality: HyperMaterialQuality.advanced,
      reduceTransparency: true,
    );
    for (final read in [false, true]) {
      final value = notificationDefaults(
        theme: theme,
        metrics: theme.sizes.desktop.notification,
        materialTheme: material,
        isRead: read,
      );
      expect(
        value.titleStyle!.color,
        read ? theme.colors.textSecondary : theme.colors.textPrimary,
      );
      expect(
        value.contentStyle!.fontSize,
        theme.textTheme.bodyMedium!.fontSize,
      );
      expect(value.material, material.material);
      expect(value.materialQuality, material.quality);
      expect(value.reduceTransparency, true);
      expect(value.duration, theme.motion.fastDuration);
      expect(value.boxShadow, isNull);
    }
  });
  test('阅读与交互状态按顺序覆盖，实例保留文字规格', () {
    const theme = HyperNotificationThemeData(
      style: HyperNotificationStyle(
        titleStyle: TextStyle(fontSize: 18),
        iconSize: 16,
      ),
      read: HyperNotificationStyle(iconSize: 18),
      unread: HyperNotificationStyle(titleStyle: TextStyle(color: Colors.blue)),
      hovered: HyperNotificationStyle(iconSize: 20),
      focused: HyperNotificationStyle(iconSize: 22),
      pressed: HyperNotificationStyle(iconSize: 24),
      disabled: HyperNotificationStyle(iconSize: 26),
    );
    expect(theme.resolve(isRead: true).iconSize, 18);
    final unread = theme.resolve(isRead: false);
    expect(unread.titleStyle!.fontSize, 18);
    expect(unread.titleStyle!.color, Colors.blue);
    expect(
      theme
          .resolve(
            isRead: false,
            states: {
              HyperControlState.hovered,
              HyperControlState.focused,
              HyperControlState.pressed,
            },
          )
          .iconSize,
      24,
    );
    final disabled = theme.resolve(
      isRead: false,
      states: HyperControlState.values.toSet(),
    );
    expect(disabled.iconSize, 26);
    expect(
      disabled.merge(const HyperNotificationStyle(iconSize: 28)).iconSize,
      28,
    );
    expect(
      theme
          .merge(
            const HyperNotificationThemeData(
              unread: HyperNotificationStyle(spacing: 12),
            ),
          )
          .unread!
          .titleStyle,
      theme.unread!.titleStyle,
    );
  });
  test('样式复制插值和值相等涵盖视觉和动画', () {
    const start = HyperNotificationStyle(
      iconSize: 16,
      unreadSize: 4,
      closeButtonSize: 32,
      padding: EdgeInsets.all(8),
      duration: Duration(milliseconds: 100),
      hoverOpacity: .04,
      boxShadow: [BoxShadow(color: Colors.black12)],
    );
    final end = start.copyWith(
      iconSize: 24,
      unreadSize: 8,
      closeButtonSize: 40,
      padding: const EdgeInsets.all(16),
      duration: const Duration(milliseconds: 200),
      hoverOpacity: .08,
    );
    final mid = HyperNotificationStyle.lerp(start, end, .5);
    expect(mid.iconSize, 20);
    expect(mid.unreadSize, 6);
    expect(mid.closeButtonSize, 36);
    expect(mid.padding, const EdgeInsets.all(12));
    expect(mid.duration, const Duration(milliseconds: 150));
    expect(mid.hoverOpacity, .06);
    expect(start.copyWith(), start);
    expect(start.copyWith().hashCode, start.hashCode);
    expect(start.copyWith(boxShadow: []), isNot(start));
    expect(
      HyperNotificationThemeData.lerp(
        const HyperNotificationThemeData(style: start),
        HyperNotificationThemeData(style: end),
        .5,
      ).style,
      mid,
    );
  });
  test('四端规格与全局主题独立覆盖', () {
    final theme = HyperThemeData.light();
    for (final device in [
      theme.sizes.phone,
      theme.sizes.tablet,
      theme.sizes.desktop,
      theme.sizes.watch,
    ]) {
      final base = device.notification;
      expect(base.closeButtonSize, greaterThan(0));
      expect(base.copyWith(), base);
      expect(base.copyWith().hashCode, base.hashCode);
      final updated = device.copyWith(notification: base.copyWith(radius: 30));
      expect(updated.card, device.card);
      expect(updated.alert, device.alert);
      expect(updated.notification.radius, 30);
      expect(
        HyperNotificationSize.lerp(
          base,
          base.copyWith(radius: base.radius + 4),
          .5,
        ).radius,
        base.radius + 2,
      );
    }
    const notification = HyperNotificationThemeData(
      style: HyperNotificationStyle(spacing: 19),
    );
    final updated = theme.copyWith(notificationTheme: notification);
    expect(updated.notificationTheme, notification);
    expect(updated.cardTheme, theme.cardTheme);
    expect(theme.lerp(updated, 1), updated);
  });
}
