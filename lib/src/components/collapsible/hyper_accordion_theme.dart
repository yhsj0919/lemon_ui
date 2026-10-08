import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_accordion_style.dart';

@immutable
final class HyperAccordionThemeData {
  const HyperAccordionThemeData({this.style = const HyperAccordionStyle()});
  final HyperAccordionStyle style;

  HyperAccordionThemeData copyWith({HyperAccordionStyle? style}) =>
      HyperAccordionThemeData(style: style ?? this.style);
  HyperAccordionThemeData merge(HyperAccordionThemeData? other) => other == null
      ? this
      : HyperAccordionThemeData(style: style.merge(other.style));
  static HyperAccordionThemeData lerp(
    HyperAccordionThemeData a,
    HyperAccordionThemeData b,
    double t,
  ) => HyperAccordionThemeData(
    style: HyperAccordionStyle.lerp(a.style, b.style, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperAccordionThemeData && style == other.style;
  @override
  int get hashCode => Object.hashAll([style]);
}

class HyperAccordionTheme extends StatelessWidget {
  const HyperAccordionTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperAccordionThemeData data;
  final Widget child;
  static HyperAccordionThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).accordionTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperAccordionThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
