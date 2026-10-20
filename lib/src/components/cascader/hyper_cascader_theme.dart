import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_cascader_style.dart';

@immutable
final class HyperCascaderThemeData {
  const HyperCascaderThemeData({this.style = const HyperCascaderStyle()});
  final HyperCascaderStyle style;

  HyperCascaderThemeData copyWith({HyperCascaderStyle? style}) =>
      HyperCascaderThemeData(style: this.style.merge(style));
  HyperCascaderThemeData merge(HyperCascaderThemeData? other) =>
      copyWith(style: other?.style);
  static HyperCascaderThemeData lerp(
    HyperCascaderThemeData a,
    HyperCascaderThemeData b,
    double t,
  ) => HyperCascaderThemeData(
    style: HyperCascaderStyle.lerp(a.style, b.style, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperCascaderThemeData && other.style == style;
  @override
  int get hashCode => style.hashCode;
}

class HyperCascaderTheme extends StatelessWidget {
  const HyperCascaderTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperCascaderThemeData data;
  final Widget child;

  static HyperCascaderThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_CascaderThemeScope>()?.data ??
      HyperTheme.of(context).cascaderTheme;

  @override
  Widget build(BuildContext context) =>
      _CascaderThemeScope(data: of(context).merge(data), child: child);
}

class _CascaderThemeScope extends InheritedTheme {
  const _CascaderThemeScope({required this.data, required super.child});
  final HyperCascaderThemeData data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _CascaderThemeScope(data: data, child: child);
  @override
  bool updateShouldNotify(_CascaderThemeScope oldWidget) =>
      data != oldWidget.data;
}
