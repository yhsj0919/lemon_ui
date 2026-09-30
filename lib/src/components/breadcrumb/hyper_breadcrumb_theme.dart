import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_breadcrumb_style.dart';

/// 面包屑的全局与局部视觉主题。
@immutable
final class HyperBreadcrumbThemeData {
  const HyperBreadcrumbThemeData({this.style = const HyperBreadcrumbStyle()});

  final HyperBreadcrumbStyle style;

  HyperBreadcrumbThemeData copyWith({HyperBreadcrumbStyle? style}) =>
      HyperBreadcrumbThemeData(style: style ?? this.style);

  HyperBreadcrumbThemeData merge(HyperBreadcrumbThemeData? other) =>
      other == null
      ? this
      : HyperBreadcrumbThemeData(style: style.merge(other.style));

  static HyperBreadcrumbThemeData lerp(
    HyperBreadcrumbThemeData a,
    HyperBreadcrumbThemeData b,
    double t,
  ) => HyperBreadcrumbThemeData(
    style: HyperBreadcrumbStyle.lerp(a.style, b.style, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperBreadcrumbThemeData && other.style == style;

  @override
  int get hashCode => style.hashCode;
}

class HyperBreadcrumbTheme extends StatelessWidget {
  const HyperBreadcrumbTheme({
    super.key,
    required this.data,
    required this.child,
  });

  final HyperBreadcrumbThemeData data;
  final Widget child;

  static HyperBreadcrumbThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_BreadcrumbScope>()?.data ??
      HyperTheme.of(context).breadcrumbTheme;

  @override
  Widget build(BuildContext context) =>
      _BreadcrumbScope(data: of(context).merge(data), child: child);
}

class _BreadcrumbScope extends InheritedTheme {
  const _BreadcrumbScope({required this.data, required super.child});

  final HyperBreadcrumbThemeData data;

  @override
  bool updateShouldNotify(_BreadcrumbScope oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _BreadcrumbScope(data: data, child: child);
}
