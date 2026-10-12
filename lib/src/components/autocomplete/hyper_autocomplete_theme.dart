import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import '../select/hyper_selection_style.dart';

@immutable
final class HyperAutocompleteThemeData {
  const HyperAutocompleteThemeData({this.style = const HyperSelectionStyle()});
  final HyperSelectionStyle style;

  HyperAutocompleteThemeData copyWith({HyperSelectionStyle? style}) =>
      HyperAutocompleteThemeData(style: style ?? this.style);
  HyperAutocompleteThemeData merge(HyperAutocompleteThemeData? other) =>
      other == null
      ? this
      : HyperAutocompleteThemeData(style: style.merge(other.style));
  static HyperAutocompleteThemeData lerp(
    HyperAutocompleteThemeData a,
    HyperAutocompleteThemeData b,
    double t,
  ) => HyperAutocompleteThemeData(
    style: HyperSelectionStyle.lerp(a.style, b.style, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperAutocompleteThemeData && style == other.style;
  @override
  int get hashCode => Object.hashAll([style]);
}

class HyperAutocompleteTheme extends StatelessWidget {
  const HyperAutocompleteTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperAutocompleteThemeData data;
  final Widget child;
  static HyperAutocompleteThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).autocompleteTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperAutocompleteThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
