import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_page_indicator_style.dart';

@immutable
final class HyperPageIndicatorThemeData {
  const HyperPageIndicatorThemeData({
    this.style = const HyperPageIndicatorStyle(),
  });
  final HyperPageIndicatorStyle style;

  HyperPageIndicatorThemeData copyWith({HyperPageIndicatorStyle? style}) =>
      HyperPageIndicatorThemeData(style: style ?? this.style);
  HyperPageIndicatorThemeData merge(HyperPageIndicatorThemeData? other) =>
      other == null
      ? this
      : HyperPageIndicatorThemeData(style: style.merge(other.style));
  static HyperPageIndicatorThemeData lerp(
    HyperPageIndicatorThemeData a,
    HyperPageIndicatorThemeData b,
    double t,
  ) => HyperPageIndicatorThemeData(
    style: HyperPageIndicatorStyle.lerp(a.style, b.style, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperPageIndicatorThemeData && style == other.style;
  @override
  int get hashCode => Object.hashAll([style]);
}

class HyperPageIndicatorTheme extends StatelessWidget {
  const HyperPageIndicatorTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperPageIndicatorThemeData data;
  final Widget child;
  static HyperPageIndicatorThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).pageIndicatorTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperPageIndicatorThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
