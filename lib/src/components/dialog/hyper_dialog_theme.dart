import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_dialog_style.dart';

@immutable
final class HyperDialogThemeData {
  const HyperDialogThemeData({this.style = const HyperDialogStyle()});
  final HyperDialogStyle style;
  HyperDialogThemeData copyWith({HyperDialogStyle? style}) =>
      HyperDialogThemeData(style: style ?? this.style);
  HyperDialogThemeData merge(HyperDialogThemeData? other) => other == null
      ? this
      : HyperDialogThemeData(style: style.merge(other.style));
  static HyperDialogThemeData lerp(
    HyperDialogThemeData a,
    HyperDialogThemeData b,
    double t,
  ) => HyperDialogThemeData(style: HyperDialogStyle.lerp(a.style, b.style, t));
  @override
  bool operator ==(Object other) =>
      other is HyperDialogThemeData && style == other.style;
  @override
  int get hashCode => style.hashCode;
}

class HyperDialogTheme extends StatelessWidget {
  const HyperDialogTheme({super.key, required this.data, required this.child});
  final HyperDialogThemeData data;
  final Widget child;
  static HyperDialogThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).dialogTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperDialogThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
