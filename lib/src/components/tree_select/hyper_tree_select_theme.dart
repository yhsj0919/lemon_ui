import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_tree_select_style.dart';

@immutable
final class HyperTreeSelectThemeData {
  const HyperTreeSelectThemeData({this.style = const HyperTreeSelectStyle()});
  final HyperTreeSelectStyle style;

  HyperTreeSelectThemeData copyWith({HyperTreeSelectStyle? style}) =>
      HyperTreeSelectThemeData(style: this.style.merge(style));
  HyperTreeSelectThemeData merge(HyperTreeSelectThemeData? other) =>
      copyWith(style: other?.style);
  static HyperTreeSelectThemeData lerp(
    HyperTreeSelectThemeData a,
    HyperTreeSelectThemeData b,
    double t,
  ) => HyperTreeSelectThemeData(
    style: HyperTreeSelectStyle.lerp(a.style, b.style, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperTreeSelectThemeData && other.style == style;
  @override
  int get hashCode => style.hashCode;
}

class HyperTreeSelectTheme extends StatelessWidget {
  const HyperTreeSelectTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperTreeSelectThemeData data;
  final Widget child;

  static HyperTreeSelectThemeData of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_TreeSelectThemeScope>()
          ?.data ??
      HyperTheme.of(context).treeSelectTheme;

  @override
  Widget build(BuildContext context) =>
      _TreeSelectThemeScope(data: of(context).merge(data), child: child);
}

class _TreeSelectThemeScope extends InheritedTheme {
  const _TreeSelectThemeScope({required this.data, required super.child});
  final HyperTreeSelectThemeData data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _TreeSelectThemeScope(data: data, child: child);
  @override
  bool updateShouldNotify(_TreeSelectThemeScope oldWidget) =>
      data != oldWidget.data;
}
