import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_timeline_style.dart';
import 'hyper_timeline_model.dart';

@immutable
final class HyperTimelineThemeData {
  const HyperTimelineThemeData({
    this.style = const HyperTimelineStyle(),
    this.normal,
    this.active,
    this.success,
    this.warning,
    this.error,
    this.disabled,
  });
  final HyperTimelineStyle style;
  final HyperTimelineStyle? normal;
  final HyperTimelineStyle? active;
  final HyperTimelineStyle? success;
  final HyperTimelineStyle? warning;
  final HyperTimelineStyle? error;
  final HyperTimelineStyle? disabled;
  HyperTimelineStyle resolve(HyperTimelineStatus status) =>
      style.merge(switch (status) {
        HyperTimelineStatus.normal => normal,
        HyperTimelineStatus.active => active,
        HyperTimelineStatus.success => success,
        HyperTimelineStatus.warning => warning,
        HyperTimelineStatus.error => error,
        HyperTimelineStatus.disabled => disabled,
      });
  HyperTimelineThemeData copyWith({
    HyperTimelineStyle? style,
    HyperTimelineStyle? normal,
    HyperTimelineStyle? active,
    HyperTimelineStyle? success,
    HyperTimelineStyle? warning,
    HyperTimelineStyle? error,
    HyperTimelineStyle? disabled,
  }) => HyperTimelineThemeData(
    style: style ?? this.style,
    normal: normal ?? this.normal,
    active: active ?? this.active,
    success: success ?? this.success,
    warning: warning ?? this.warning,
    error: error ?? this.error,
    disabled: disabled ?? this.disabled,
  );
  HyperTimelineThemeData merge(HyperTimelineThemeData? other) => other == null
      ? this
      : HyperTimelineThemeData(
          style: style.merge(other.style),
          normal: normal?.merge(other.normal) ?? other.normal,
          active: active?.merge(other.active) ?? other.active,
          success: success?.merge(other.success) ?? other.success,
          warning: warning?.merge(other.warning) ?? other.warning,
          error: error?.merge(other.error) ?? other.error,
          disabled: disabled?.merge(other.disabled) ?? other.disabled,
        );
  static HyperTimelineThemeData lerp(
    HyperTimelineThemeData a,
    HyperTimelineThemeData b,
    double t,
  ) => HyperTimelineThemeData(
    style: HyperTimelineStyle.lerp(a.style, b.style, t),
    normal: a.normal == null || b.normal == null
        ? (t < .5 ? a.normal : b.normal)
        : HyperTimelineStyle.lerp(a.normal!, b.normal!, t),
    active: a.active == null || b.active == null
        ? (t < .5 ? a.active : b.active)
        : HyperTimelineStyle.lerp(a.active!, b.active!, t),
    success: a.success == null || b.success == null
        ? (t < .5 ? a.success : b.success)
        : HyperTimelineStyle.lerp(a.success!, b.success!, t),
    warning: a.warning == null || b.warning == null
        ? (t < .5 ? a.warning : b.warning)
        : HyperTimelineStyle.lerp(a.warning!, b.warning!, t),
    error: a.error == null || b.error == null
        ? (t < .5 ? a.error : b.error)
        : HyperTimelineStyle.lerp(a.error!, b.error!, t),
    disabled: a.disabled == null || b.disabled == null
        ? (t < .5 ? a.disabled : b.disabled)
        : HyperTimelineStyle.lerp(a.disabled!, b.disabled!, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperTimelineThemeData &&
      style == other.style &&
      normal == other.normal &&
      active == other.active &&
      success == other.success &&
      warning == other.warning &&
      error == other.error &&
      disabled == other.disabled;
  @override
  int get hashCode => Object.hashAll([
    style,
    normal,
    active,
    success,
    warning,
    error,
    disabled,
  ]);
}

class HyperTimelineTheme extends StatelessWidget {
  const HyperTimelineTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperTimelineThemeData data;
  final Widget child;
  static HyperTimelineThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).timelineTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperTimelineThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
