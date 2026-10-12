import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_selection_style.dart';

@immutable
final class HyperSelectionThemeData {
  const HyperSelectionThemeData({this.style = const HyperSelectionStyle()});
  final HyperSelectionStyle style;

  HyperSelectionThemeData copyWith({HyperSelectionStyle? style}) =>
      HyperSelectionThemeData(style: style ?? this.style);
  HyperSelectionThemeData merge(HyperSelectionThemeData? other) => other == null
      ? this
      : HyperSelectionThemeData(style: style.merge(other.style));
  static HyperSelectionThemeData lerp(
    HyperSelectionThemeData a,
    HyperSelectionThemeData b,
    double t,
  ) => HyperSelectionThemeData(
    style: HyperSelectionStyle.lerp(a.style, b.style, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperSelectionThemeData && style == other.style;
  @override
  int get hashCode => Object.hashAll([style]);
}

class HyperSelectionTheme extends StatelessWidget {
  const HyperSelectionTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperSelectionThemeData data;
  final Widget child;
  static HyperSelectionThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).selectionTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperSelectionThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
