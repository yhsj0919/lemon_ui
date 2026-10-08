import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_pagination_style.dart';

@immutable
final class HyperPaginationThemeData {
  const HyperPaginationThemeData({this.style = const HyperPaginationStyle()});
  final HyperPaginationStyle style;

  HyperPaginationThemeData copyWith({HyperPaginationStyle? style}) =>
      HyperPaginationThemeData(style: style ?? this.style);
  HyperPaginationThemeData merge(HyperPaginationThemeData? other) =>
      other == null
      ? this
      : HyperPaginationThemeData(style: style.merge(other.style));
  static HyperPaginationThemeData lerp(
    HyperPaginationThemeData a,
    HyperPaginationThemeData b,
    double t,
  ) => HyperPaginationThemeData(
    style: HyperPaginationStyle.lerp(a.style, b.style, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperPaginationThemeData && style == other.style;
  @override
  int get hashCode => Object.hashAll([style]);
}

class HyperPaginationTheme extends StatelessWidget {
  const HyperPaginationTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperPaginationThemeData data;
  final Widget child;
  static HyperPaginationThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).paginationTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperPaginationThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
