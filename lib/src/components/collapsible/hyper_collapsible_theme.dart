import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_collapsible_style.dart';

@immutable
final class HyperCollapsibleThemeData {
  const HyperCollapsibleThemeData({
    this.style = const HyperCollapsibleStyle(),
    this.expanded,
    this.collapsed,
    this.disabled,
  });
  final HyperCollapsibleStyle style;
  final HyperCollapsibleStyle? expanded;
  final HyperCollapsibleStyle? collapsed;
  final HyperCollapsibleStyle? disabled;
  HyperCollapsibleThemeData copyWith({
    HyperCollapsibleStyle? style,
    HyperCollapsibleStyle? expanded,
    HyperCollapsibleStyle? collapsed,
    HyperCollapsibleStyle? disabled,
  }) => HyperCollapsibleThemeData(
    style: style ?? this.style,
    expanded: expanded ?? this.expanded,
    collapsed: collapsed ?? this.collapsed,
    disabled: disabled ?? this.disabled,
  );
  HyperCollapsibleThemeData merge(HyperCollapsibleThemeData? other) =>
      other == null
      ? this
      : HyperCollapsibleThemeData(
          style: style.merge(other.style),
          expanded: expanded?.merge(other.expanded) ?? other.expanded,
          collapsed: collapsed?.merge(other.collapsed) ?? other.collapsed,
          disabled: disabled?.merge(other.disabled) ?? other.disabled,
        );
  static HyperCollapsibleThemeData lerp(
    HyperCollapsibleThemeData a,
    HyperCollapsibleThemeData b,
    double t,
  ) => HyperCollapsibleThemeData(
    style: HyperCollapsibleStyle.lerp(a.style, b.style, t),
    expanded: a.expanded == null || b.expanded == null
        ? (t < .5 ? a.expanded : b.expanded)
        : HyperCollapsibleStyle.lerp(a.expanded!, b.expanded!, t),
    collapsed: a.collapsed == null || b.collapsed == null
        ? (t < .5 ? a.collapsed : b.collapsed)
        : HyperCollapsibleStyle.lerp(a.collapsed!, b.collapsed!, t),
    disabled: a.disabled == null || b.disabled == null
        ? (t < .5 ? a.disabled : b.disabled)
        : HyperCollapsibleStyle.lerp(a.disabled!, b.disabled!, t),
  );
  HyperCollapsibleStyle resolve({
    required bool isExpanded,
    required bool enabled,
  }) => style
      .merge(isExpanded ? expanded : collapsed)
      .merge(enabled ? null : disabled);
  @override
  bool operator ==(Object other) =>
      other is HyperCollapsibleThemeData &&
      style == other.style &&
      expanded == other.expanded &&
      collapsed == other.collapsed &&
      disabled == other.disabled;
  @override
  int get hashCode => Object.hashAll([style, expanded, collapsed, disabled]);
}

class HyperCollapsibleTheme extends StatelessWidget {
  const HyperCollapsibleTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperCollapsibleThemeData data;
  final Widget child;
  static HyperCollapsibleThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).collapsibleTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperCollapsibleThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
