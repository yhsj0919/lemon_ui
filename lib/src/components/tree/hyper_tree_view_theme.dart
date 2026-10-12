import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_tree_view_style.dart';

@immutable
final class HyperTreeViewThemeData {
  const HyperTreeViewThemeData({this.style = const HyperTreeViewStyle()});
  final HyperTreeViewStyle style;

  HyperTreeViewThemeData copyWith({HyperTreeViewStyle? style}) =>
      HyperTreeViewThemeData(style: style ?? this.style);
  HyperTreeViewThemeData merge(HyperTreeViewThemeData? other) => other == null
      ? this
      : HyperTreeViewThemeData(style: style.merge(other.style));
  static HyperTreeViewThemeData lerp(
    HyperTreeViewThemeData a,
    HyperTreeViewThemeData b,
    double t,
  ) => HyperTreeViewThemeData(
    style: HyperTreeViewStyle.lerp(a.style, b.style, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperTreeViewThemeData && style == other.style;
  @override
  int get hashCode => Object.hashAll([style]);
}

class HyperTreeViewTheme extends StatelessWidget {
  const HyperTreeViewTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperTreeViewThemeData data;
  final Widget child;
  static HyperTreeViewThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).treeViewTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperTreeViewThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
