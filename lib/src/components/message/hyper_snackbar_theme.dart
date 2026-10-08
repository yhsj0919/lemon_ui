import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_message_style.dart';

@immutable
final class HyperSnackbarThemeData {
  const HyperSnackbarThemeData({this.style = const HyperMessageStyle()});
  final HyperMessageStyle style;
  HyperSnackbarThemeData copyWith({HyperMessageStyle? style}) =>
      HyperSnackbarThemeData(style: style ?? this.style);
  HyperSnackbarThemeData merge(HyperSnackbarThemeData? other) => other == null
      ? this
      : HyperSnackbarThemeData(style: style.merge(other.style));
  static HyperSnackbarThemeData lerp(
    HyperSnackbarThemeData a,
    HyperSnackbarThemeData b,
    double t,
  ) => HyperSnackbarThemeData(
    style: HyperMessageStyle.lerp(a.style, b.style, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperSnackbarThemeData && style == other.style;
  @override
  int get hashCode => style.hashCode;
}

class HyperSnackbarTheme extends StatelessWidget {
  const HyperSnackbarTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperSnackbarThemeData data;
  final Widget child;
  static HyperSnackbarThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).snackbarTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperSnackbarThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
