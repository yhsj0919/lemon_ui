import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_description_list_style.dart';

@immutable
final class HyperDescriptionListThemeData {
  const HyperDescriptionListThemeData({
    this.style = const HyperDescriptionListStyle(),
  });
  final HyperDescriptionListStyle style;

  HyperDescriptionListThemeData copyWith({HyperDescriptionListStyle? style}) =>
      HyperDescriptionListThemeData(style: style ?? this.style);
  HyperDescriptionListThemeData merge(HyperDescriptionListThemeData? other) =>
      other == null
      ? this
      : HyperDescriptionListThemeData(style: style.merge(other.style));
  static HyperDescriptionListThemeData lerp(
    HyperDescriptionListThemeData a,
    HyperDescriptionListThemeData b,
    double t,
  ) => HyperDescriptionListThemeData(
    style: HyperDescriptionListStyle.lerp(a.style, b.style, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperDescriptionListThemeData && style == other.style;
  @override
  int get hashCode => Object.hashAll([style]);
}

class HyperDescriptionListTheme extends StatelessWidget {
  const HyperDescriptionListTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperDescriptionListThemeData data;
  final Widget child;
  static HyperDescriptionListThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).descriptionListTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperDescriptionListThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
