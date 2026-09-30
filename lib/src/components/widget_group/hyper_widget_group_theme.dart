import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_widget_group_style.dart';

@immutable
final class HyperWidgetGroupThemeData {
  const HyperWidgetGroupThemeData({this.style = const HyperWidgetGroupStyle()});

  final HyperWidgetGroupStyle style;

  HyperWidgetGroupThemeData copyWith({HyperWidgetGroupStyle? style}) =>
      HyperWidgetGroupThemeData(style: style ?? this.style);

  HyperWidgetGroupThemeData merge(HyperWidgetGroupThemeData? other) =>
      other == null
      ? this
      : HyperWidgetGroupThemeData(style: style.merge(other.style));

  static HyperWidgetGroupThemeData lerp(
    HyperWidgetGroupThemeData a,
    HyperWidgetGroupThemeData b,
    double t,
  ) => a == b
      ? a
      : HyperWidgetGroupThemeData(
          style: HyperWidgetGroupStyle.lerp(a.style, b.style, t),
        );

  @override
  bool operator ==(Object other) =>
      other is HyperWidgetGroupThemeData && other.style == style;

  @override
  int get hashCode => style.hashCode;
}

class HyperWidgetGroupTheme extends StatelessWidget {
  const HyperWidgetGroupTheme({
    super.key,
    required this.data,
    required this.child,
  });

  final HyperWidgetGroupThemeData data;
  final Widget child;

  static HyperWidgetGroupThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_WidgetGroupScope>()?.data ??
      HyperTheme.of(context).widgetGroupTheme;

  @override
  Widget build(BuildContext context) =>
      _WidgetGroupScope(data: of(context).merge(data), child: child);
}

class _WidgetGroupScope extends InheritedTheme {
  const _WidgetGroupScope({required this.data, required super.child});

  final HyperWidgetGroupThemeData data;

  @override
  bool updateShouldNotify(_WidgetGroupScope oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _WidgetGroupScope(data: data, child: child);
}
