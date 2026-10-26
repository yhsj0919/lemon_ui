import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_rating_style.dart';

@immutable
final class HyperRatingThemeData {
  const HyperRatingThemeData({this.style = const HyperRatingStyle()});
  final HyperRatingStyle style;
  HyperRatingThemeData copyWith({HyperRatingStyle? style}) =>
      HyperRatingThemeData(style: this.style.merge(style));
  HyperRatingThemeData merge(HyperRatingThemeData? other) =>
      copyWith(style: other?.style);
  static HyperRatingThemeData lerp(
    HyperRatingThemeData a,
    HyperRatingThemeData b,
    double t,
  ) => HyperRatingThemeData(style: HyperRatingStyle.lerp(a.style, b.style, t));
  @override
  bool operator ==(Object other) =>
      other is HyperRatingThemeData && other.style == style;
  @override
  int get hashCode => style.hashCode;
}

class HyperRatingTheme extends StatelessWidget {
  const HyperRatingTheme({super.key, required this.data, required this.child});
  final HyperRatingThemeData data;
  final Widget child;
  static HyperRatingThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).ratingTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperRatingThemeData data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
}
