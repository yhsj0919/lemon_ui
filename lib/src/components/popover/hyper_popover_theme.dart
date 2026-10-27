import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_popover_style.dart';

@immutable
final class HyperPopoverThemeData {
  const HyperPopoverThemeData({this.style = const HyperPopoverStyle()});
  final HyperPopoverStyle style;
  HyperPopoverThemeData copyWith({HyperPopoverStyle? style}) =>
      HyperPopoverThemeData(style: this.style.merge(style));
  HyperPopoverThemeData merge(HyperPopoverThemeData? other) =>
      copyWith(style: other?.style);
  static HyperPopoverThemeData lerp(
    HyperPopoverThemeData a,
    HyperPopoverThemeData b,
    double t,
  ) =>
      HyperPopoverThemeData(style: HyperPopoverStyle.lerp(a.style, b.style, t));
  @override
  bool operator ==(Object other) =>
      other is HyperPopoverThemeData && other.style == style;
  @override
  int get hashCode => style.hashCode;
}

class HyperPopoverTheme extends StatelessWidget {
  const HyperPopoverTheme({super.key, required this.data, required this.child});
  final HyperPopoverThemeData data;
  final Widget child;
  static HyperPopoverThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).popoverTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperPopoverThemeData data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
}
