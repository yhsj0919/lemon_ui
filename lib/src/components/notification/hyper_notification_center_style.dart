import 'package:flutter/material.dart';

import '../button/hyper_button_theme.dart';
import '../empty_state/hyper_empty_state_style.dart';
import 'hyper_notification_theme.dart';

@immutable
final class HyperNotificationCenterStyle {
  const HyperNotificationCenterStyle({
    this.padding,
    this.spacing,
    this.groupSpacing,
    this.titleStyle,
    this.groupStyle,
    this.countStyle,
    this.title,
    this.unreadCountLabel,
    this.markReadLabel,
    this.markAllReadLabel,
    this.clearLabel,
    this.emptyTitle,
    this.emptyDescription,
    this.buttonTheme,
    this.notificationTheme,
    this.emptyStateStyle,
    this.duration,
    this.curve,
    this.transitionBuilder,
  });
  final EdgeInsetsGeometry? padding;
  final double? spacing;
  final double? groupSpacing;
  final TextStyle? titleStyle;
  final TextStyle? groupStyle;
  final TextStyle? countStyle;
  final String? title;
  final String? unreadCountLabel;
  final String? markReadLabel;
  final String? markAllReadLabel;
  final String? clearLabel;
  final String? emptyTitle;
  final String? emptyDescription;
  final HyperButtonThemeData? buttonTheme;
  final HyperNotificationThemeData? notificationTheme;
  final HyperEmptyStateStyle? emptyStateStyle;
  final Duration? duration;
  final Curve? curve;
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;
  HyperNotificationCenterStyle copyWith({
    EdgeInsetsGeometry? padding,
    double? spacing,
    double? groupSpacing,
    TextStyle? titleStyle,
    TextStyle? groupStyle,
    TextStyle? countStyle,
    String? title,
    String? unreadCountLabel,
    String? markReadLabel,
    String? markAllReadLabel,
    String? clearLabel,
    String? emptyTitle,
    String? emptyDescription,
    HyperButtonThemeData? buttonTheme,
    HyperNotificationThemeData? notificationTheme,
    HyperEmptyStateStyle? emptyStateStyle,
    Duration? duration,
    Curve? curve,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
  }) => HyperNotificationCenterStyle(
    padding: padding ?? this.padding,
    spacing: spacing ?? this.spacing,
    groupSpacing: groupSpacing ?? this.groupSpacing,
    titleStyle: titleStyle ?? this.titleStyle,
    groupStyle: groupStyle ?? this.groupStyle,
    countStyle: countStyle ?? this.countStyle,
    title: title ?? this.title,
    unreadCountLabel: unreadCountLabel ?? this.unreadCountLabel,
    markReadLabel: markReadLabel ?? this.markReadLabel,
    markAllReadLabel: markAllReadLabel ?? this.markAllReadLabel,
    clearLabel: clearLabel ?? this.clearLabel,
    emptyTitle: emptyTitle ?? this.emptyTitle,
    emptyDescription: emptyDescription ?? this.emptyDescription,
    buttonTheme: buttonTheme ?? this.buttonTheme,
    notificationTheme: notificationTheme ?? this.notificationTheme,
    emptyStateStyle: emptyStateStyle ?? this.emptyStateStyle,
    duration: duration ?? this.duration,
    curve: curve ?? this.curve,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
  );
  HyperNotificationCenterStyle merge(HyperNotificationCenterStyle? other) =>
      other == null
      ? this
      : HyperNotificationCenterStyle(
          padding: other.padding ?? padding,
          spacing: other.spacing ?? spacing,
          groupSpacing: other.groupSpacing ?? groupSpacing,
          titleStyle: titleStyle?.merge(other.titleStyle) ?? other.titleStyle,
          groupStyle: groupStyle?.merge(other.groupStyle) ?? other.groupStyle,
          countStyle: countStyle?.merge(other.countStyle) ?? other.countStyle,
          title: other.title ?? title,
          unreadCountLabel: other.unreadCountLabel ?? unreadCountLabel,
          markReadLabel: other.markReadLabel ?? markReadLabel,
          markAllReadLabel: other.markAllReadLabel ?? markAllReadLabel,
          clearLabel: other.clearLabel ?? clearLabel,
          emptyTitle: other.emptyTitle ?? emptyTitle,
          emptyDescription: other.emptyDescription ?? emptyDescription,
          buttonTheme:
              buttonTheme?.merge(other.buttonTheme) ?? other.buttonTheme,
          notificationTheme:
              notificationTheme?.merge(other.notificationTheme) ??
              other.notificationTheme,
          emptyStateStyle:
              emptyStateStyle?.merge(other.emptyStateStyle) ??
              other.emptyStateStyle,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
          transitionBuilder: other.transitionBuilder ?? transitionBuilder,
        );
  static HyperNotificationCenterStyle lerp(
    HyperNotificationCenterStyle a,
    HyperNotificationCenterStyle b,
    double t,
  ) {
    if (t == 0) {
      return a;
    }
    if (t == 1) {
      return b;
    }
    return HyperNotificationCenterStyle(
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      spacing: a.spacing == null || b.spacing == null
          ? (t < .5 ? a.spacing : b.spacing)
          : a.spacing! + (b.spacing! - a.spacing!) * t,
      groupSpacing: a.groupSpacing == null || b.groupSpacing == null
          ? (t < .5 ? a.groupSpacing : b.groupSpacing)
          : a.groupSpacing! + (b.groupSpacing! - a.groupSpacing!) * t,
      titleStyle: TextStyle.lerp(a.titleStyle, b.titleStyle, t),
      groupStyle: TextStyle.lerp(a.groupStyle, b.groupStyle, t),
      countStyle: TextStyle.lerp(a.countStyle, b.countStyle, t),
      title: t < .5 ? a.title : b.title,
      unreadCountLabel: t < .5 ? a.unreadCountLabel : b.unreadCountLabel,
      markReadLabel: t < .5 ? a.markReadLabel : b.markReadLabel,
      markAllReadLabel: t < .5 ? a.markAllReadLabel : b.markAllReadLabel,
      clearLabel: t < .5 ? a.clearLabel : b.clearLabel,
      emptyTitle: t < .5 ? a.emptyTitle : b.emptyTitle,
      emptyDescription: t < .5 ? a.emptyDescription : b.emptyDescription,
      buttonTheme: a.buttonTheme == null || b.buttonTheme == null
          ? (t < .5 ? a.buttonTheme : b.buttonTheme)
          : HyperButtonThemeData.lerp(a.buttonTheme!, b.buttonTheme!, t),
      notificationTheme:
          a.notificationTheme == null || b.notificationTheme == null
          ? (t < .5 ? a.notificationTheme : b.notificationTheme)
          : HyperNotificationThemeData.lerp(
              a.notificationTheme!,
              b.notificationTheme!,
              t,
            ),
      emptyStateStyle: a.emptyStateStyle == null || b.emptyStateStyle == null
          ? (t < .5 ? a.emptyStateStyle : b.emptyStateStyle)
          : HyperEmptyStateStyle.lerp(
              a.emptyStateStyle!,
              b.emptyStateStyle!,
              t,
            ),
      duration: a.duration == null || b.duration == null
          ? (t < .5 ? a.duration : b.duration)
          : Duration(
              microseconds:
                  (a.duration!.inMicroseconds +
                          (b.duration!.inMicroseconds -
                                  a.duration!.inMicroseconds) *
                              t)
                      .round(),
            ),
      curve: t < .5 ? a.curve : b.curve,
      transitionBuilder: t < .5 ? a.transitionBuilder : b.transitionBuilder,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperNotificationCenterStyle &&
      padding == other.padding &&
      spacing == other.spacing &&
      groupSpacing == other.groupSpacing &&
      titleStyle == other.titleStyle &&
      groupStyle == other.groupStyle &&
      countStyle == other.countStyle &&
      title == other.title &&
      unreadCountLabel == other.unreadCountLabel &&
      markReadLabel == other.markReadLabel &&
      markAllReadLabel == other.markAllReadLabel &&
      clearLabel == other.clearLabel &&
      emptyTitle == other.emptyTitle &&
      emptyDescription == other.emptyDescription &&
      buttonTheme == other.buttonTheme &&
      notificationTheme == other.notificationTheme &&
      emptyStateStyle == other.emptyStateStyle &&
      duration == other.duration &&
      curve == other.curve &&
      transitionBuilder == other.transitionBuilder;
  @override
  int get hashCode => Object.hashAll([
    padding,
    spacing,
    groupSpacing,
    titleStyle,
    groupStyle,
    countStyle,
    title,
    unreadCountLabel,
    markReadLabel,
    markAllReadLabel,
    clearLabel,
    emptyTitle,
    emptyDescription,
    buttonTheme,
    notificationTheme,
    emptyStateStyle,
    duration,
    curve,
    transitionBuilder,
  ]);
}
