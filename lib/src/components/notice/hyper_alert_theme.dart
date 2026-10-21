import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_notice_style.dart';

@immutable
final class HyperAlertThemeData {
  const HyperAlertThemeData({
    this.style = const HyperNoticeStyle(),
    this.info,
    this.success,
    this.warning,
    this.error,
    this.bannerStyle = const HyperNoticeStyle(),
    this.bannerInfo,
    this.bannerSuccess,
    this.bannerWarning,
    this.bannerError,
  });
  final HyperNoticeStyle style;
  final HyperNoticeStyle? info;
  final HyperNoticeStyle? success;
  final HyperNoticeStyle? warning;
  final HyperNoticeStyle? error;
  final HyperNoticeStyle bannerStyle;
  final HyperNoticeStyle? bannerInfo;
  final HyperNoticeStyle? bannerSuccess;
  final HyperNoticeStyle? bannerWarning;
  final HyperNoticeStyle? bannerError;
  HyperNoticeStyle styleFor(
    HyperNoticeSeverity status, {
    bool banner = false,
  }) => style
      .merge(switch (status) {
        HyperNoticeSeverity.info => info,
        HyperNoticeSeverity.success => success,
        HyperNoticeSeverity.warning => warning,
        HyperNoticeSeverity.error => error,
      })
      .merge(
        banner
            ? bannerStyle.merge(switch (status) {
                HyperNoticeSeverity.info => bannerInfo,
                HyperNoticeSeverity.success => bannerSuccess,
                HyperNoticeSeverity.warning => bannerWarning,
                HyperNoticeSeverity.error => bannerError,
              })
            : null,
      );
  HyperAlertThemeData copyWith({
    HyperNoticeStyle? style,
    HyperNoticeStyle? info,
    HyperNoticeStyle? success,
    HyperNoticeStyle? warning,
    HyperNoticeStyle? error,
    HyperNoticeStyle? bannerStyle,
    HyperNoticeStyle? bannerInfo,
    HyperNoticeStyle? bannerSuccess,
    HyperNoticeStyle? bannerWarning,
    HyperNoticeStyle? bannerError,
  }) => HyperAlertThemeData(
    style: style ?? this.style,
    info: info ?? this.info,
    success: success ?? this.success,
    warning: warning ?? this.warning,
    error: error ?? this.error,
    bannerStyle: bannerStyle ?? this.bannerStyle,
    bannerInfo: bannerInfo ?? this.bannerInfo,
    bannerSuccess: bannerSuccess ?? this.bannerSuccess,
    bannerWarning: bannerWarning ?? this.bannerWarning,
    bannerError: bannerError ?? this.bannerError,
  );
  HyperAlertThemeData merge(HyperAlertThemeData? other) => other == null
      ? this
      : HyperAlertThemeData(
          style: style.merge(other.style),
          info: info?.merge(other.info) ?? other.info,
          success: success?.merge(other.success) ?? other.success,
          warning: warning?.merge(other.warning) ?? other.warning,
          error: error?.merge(other.error) ?? other.error,
          bannerStyle: bannerStyle.merge(other.bannerStyle),
          bannerInfo: bannerInfo?.merge(other.bannerInfo) ?? other.bannerInfo,
          bannerSuccess:
              bannerSuccess?.merge(other.bannerSuccess) ?? other.bannerSuccess,
          bannerWarning:
              bannerWarning?.merge(other.bannerWarning) ?? other.bannerWarning,
          bannerError:
              bannerError?.merge(other.bannerError) ?? other.bannerError,
        );
  static HyperAlertThemeData lerp(
    HyperAlertThemeData a,
    HyperAlertThemeData b,
    double t,
  ) {
    HyperNoticeStyle? blend(HyperNoticeStyle? x, HyperNoticeStyle? y) =>
        x == null || y == null
        ? (t < .5 ? x : y)
        : HyperNoticeStyle.lerp(x, y, t);
    return HyperAlertThemeData(
      style: HyperNoticeStyle.lerp(a.style, b.style, t),
      info: blend(a.info, b.info),
      success: blend(a.success, b.success),
      warning: blend(a.warning, b.warning),
      error: blend(a.error, b.error),
      bannerStyle: HyperNoticeStyle.lerp(a.bannerStyle, b.bannerStyle, t),
      bannerInfo: blend(a.bannerInfo, b.bannerInfo),
      bannerSuccess: blend(a.bannerSuccess, b.bannerSuccess),
      bannerWarning: blend(a.bannerWarning, b.bannerWarning),
      bannerError: blend(a.bannerError, b.bannerError),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperAlertThemeData &&
      style == other.style &&
      info == other.info &&
      success == other.success &&
      warning == other.warning &&
      error == other.error &&
      bannerStyle == other.bannerStyle &&
      bannerInfo == other.bannerInfo &&
      bannerSuccess == other.bannerSuccess &&
      bannerWarning == other.bannerWarning &&
      bannerError == other.bannerError;
  @override
  int get hashCode => Object.hashAll([
    style,
    info,
    success,
    warning,
    error,
    bannerStyle,
    bannerInfo,
    bannerSuccess,
    bannerWarning,
    bannerError,
  ]);
}

class HyperAlertTheme extends StatelessWidget {
  const HyperAlertTheme({super.key, required this.data, required this.child});
  final HyperAlertThemeData data;
  final Widget child;
  static HyperAlertThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).alertTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperAlertThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
