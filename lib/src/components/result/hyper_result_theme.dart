import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_result_model.dart';
import 'hyper_result_style.dart';

@immutable
final class HyperResultThemeData {
  const HyperResultThemeData({
    this.style = const HyperResultStyle(),
    this.neutral = const HyperResultStyle(),
    this.success = const HyperResultStyle(),
    this.error = const HyperResultStyle(),
    this.warning = const HyperResultStyle(),
    this.info = const HyperResultStyle(),
  });
  final HyperResultStyle style, neutral, success, error, warning, info;
  HyperResultStyle resolve(HyperResultStatus status) =>
      style.merge(switch (status) {
        HyperResultStatus.neutral => neutral,
        HyperResultStatus.success => success,
        HyperResultStatus.error => error,
        HyperResultStatus.warning => warning,
        HyperResultStatus.info => info,
      });
  HyperResultThemeData copyWith({
    HyperResultStyle? style,
    HyperResultStyle? neutral,
    HyperResultStyle? success,
    HyperResultStyle? error,
    HyperResultStyle? warning,
    HyperResultStyle? info,
  }) => HyperResultThemeData(
    style: style ?? this.style,
    neutral: neutral ?? this.neutral,
    success: success ?? this.success,
    error: error ?? this.error,
    warning: warning ?? this.warning,
    info: info ?? this.info,
  );
  HyperResultThemeData merge(HyperResultThemeData? other) => other == null
      ? this
      : HyperResultThemeData(
          style: style.merge(other.style),
          neutral: neutral.merge(other.neutral),
          success: success.merge(other.success),
          error: error.merge(other.error),
          warning: warning.merge(other.warning),
          info: info.merge(other.info),
        );
  static HyperResultThemeData lerp(
    HyperResultThemeData a,
    HyperResultThemeData b,
    double t,
  ) => HyperResultThemeData(
    style: HyperResultStyle.lerp(a.style, b.style, t),
    neutral: HyperResultStyle.lerp(a.neutral, b.neutral, t),
    success: HyperResultStyle.lerp(a.success, b.success, t),
    error: HyperResultStyle.lerp(a.error, b.error, t),
    warning: HyperResultStyle.lerp(a.warning, b.warning, t),
    info: HyperResultStyle.lerp(a.info, b.info, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperResultThemeData &&
      style == other.style &&
      neutral == other.neutral &&
      success == other.success &&
      error == other.error &&
      warning == other.warning &&
      info == other.info;
  @override
  int get hashCode =>
      Object.hash(style, neutral, success, error, warning, info);
}

class HyperResultTheme extends StatelessWidget {
  const HyperResultTheme({super.key, required this.data, required this.child});
  final HyperResultThemeData data;
  final Widget child;
  static HyperResultThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).resultTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperResultThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
