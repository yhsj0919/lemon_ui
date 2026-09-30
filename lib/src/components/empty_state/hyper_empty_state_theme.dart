import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_empty_state_style.dart';

@immutable
final class HyperEmptyStateThemeData {
  const HyperEmptyStateThemeData({this.style = const HyperEmptyStateStyle()});

  final HyperEmptyStateStyle style;

  HyperEmptyStateThemeData copyWith({HyperEmptyStateStyle? style}) =>
      HyperEmptyStateThemeData(style: style ?? this.style);

  HyperEmptyStateThemeData merge(HyperEmptyStateThemeData? other) =>
      other == null
      ? this
      : HyperEmptyStateThemeData(style: style.merge(other.style));

  static HyperEmptyStateThemeData lerp(
    HyperEmptyStateThemeData a,
    HyperEmptyStateThemeData b,
    double t,
  ) => HyperEmptyStateThemeData(
    style: HyperEmptyStateStyle.lerp(a.style, b.style, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperEmptyStateThemeData && other.style == style;

  @override
  int get hashCode => style.hashCode;
}

class HyperEmptyStateTheme extends StatelessWidget {
  const HyperEmptyStateTheme({
    super.key,
    required this.data,
    required this.child,
  });

  final HyperEmptyStateThemeData data;
  final Widget child;

  static HyperEmptyStateThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_EmptyStateScope>()?.data ??
      HyperTheme.of(context).emptyStateTheme;

  @override
  Widget build(BuildContext context) =>
      _EmptyStateScope(data: of(context).merge(data), child: child);
}

class _EmptyStateScope extends InheritedTheme {
  const _EmptyStateScope({required this.data, required super.child});

  final HyperEmptyStateThemeData data;

  @override
  bool updateShouldNotify(_EmptyStateScope oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _EmptyStateScope(data: data, child: child);
}
