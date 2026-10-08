import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_notice_style.dart';

@immutable
final class HyperBannerThemeData {
  const HyperBannerThemeData({
    this.style = const HyperNoticeStyle(),
    this.info,
    this.success,
    this.warning,
    this.error,
  });
  final HyperNoticeStyle style;
  final HyperNoticeStyle? info, success, warning, error;
  HyperNoticeStyle styleFor(HyperNoticeSeverity severity) =>
      style.merge(switch (severity) {
        HyperNoticeSeverity.info => info,
        HyperNoticeSeverity.success => success,
        HyperNoticeSeverity.warning => warning,
        HyperNoticeSeverity.error => error,
      });
  HyperBannerThemeData copyWith({
    HyperNoticeStyle? style,
    HyperNoticeStyle? info,
    HyperNoticeStyle? success,
    HyperNoticeStyle? warning,
    HyperNoticeStyle? error,
  }) => HyperBannerThemeData(
    style: style ?? this.style,
    info: info ?? this.info,
    success: success ?? this.success,
    warning: warning ?? this.warning,
    error: error ?? this.error,
  );
  HyperBannerThemeData merge(HyperBannerThemeData? other) => other == null
      ? this
      : HyperBannerThemeData(
          style: style.merge(other.style),
          info: info?.merge(other.info) ?? other.info,
          success: success?.merge(other.success) ?? other.success,
          warning: warning?.merge(other.warning) ?? other.warning,
          error: error?.merge(other.error) ?? other.error,
        );
  static HyperBannerThemeData lerp(
    HyperBannerThemeData a,
    HyperBannerThemeData b,
    double t,
  ) {
    HyperNoticeStyle? blend(HyperNoticeStyle? x, HyperNoticeStyle? y) =>
        x == null || y == null
        ? (t < .5 ? x : y)
        : HyperNoticeStyle.lerp(x, y, t);
    return HyperBannerThemeData(
      style: HyperNoticeStyle.lerp(a.style, b.style, t),
      info: blend(a.info, b.info),
      success: blend(a.success, b.success),
      warning: blend(a.warning, b.warning),
      error: blend(a.error, b.error),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperBannerThemeData &&
      style == other.style &&
      info == other.info &&
      success == other.success &&
      warning == other.warning &&
      error == other.error;
  @override
  int get hashCode => Object.hash(style, info, success, warning, error);
}

class HyperBannerTheme extends StatelessWidget {
  const HyperBannerTheme({super.key, required this.data, required this.child});
  final HyperBannerThemeData data;
  final Widget child;
  static HyperBannerThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).bannerTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperBannerThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
