import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_message_style.dart';

@immutable
final class HyperToastThemeData {
  const HyperToastThemeData({this.style = const HyperMessageStyle()});
  final HyperMessageStyle style;
  HyperToastThemeData copyWith({HyperMessageStyle? style}) =>
      HyperToastThemeData(style: style ?? this.style);
  HyperToastThemeData merge(HyperToastThemeData? other) => other == null
      ? this
      : HyperToastThemeData(style: style.merge(other.style));
  static HyperToastThemeData lerp(
    HyperToastThemeData a,
    HyperToastThemeData b,
    double t,
  ) => HyperToastThemeData(style: HyperMessageStyle.lerp(a.style, b.style, t));
  @override
  bool operator ==(Object other) =>
      other is HyperToastThemeData && style == other.style;
  @override
  int get hashCode => style.hashCode;
}

class HyperToastTheme extends StatelessWidget {
  const HyperToastTheme({super.key, required this.data, required this.child});
  final HyperToastThemeData data;
  final Widget child;
  static HyperToastThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).toastTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperToastThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
