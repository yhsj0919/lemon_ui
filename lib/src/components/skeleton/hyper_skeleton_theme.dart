import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_skeleton_style.dart';

@immutable
final class HyperSkeletonThemeData {
  const HyperSkeletonThemeData({this.style = const HyperSkeletonStyle()});

  final HyperSkeletonStyle style;

  HyperSkeletonThemeData copyWith({HyperSkeletonStyle? style}) =>
      HyperSkeletonThemeData(style: style ?? this.style);

  HyperSkeletonThemeData merge(HyperSkeletonThemeData? other) => other == null
      ? this
      : HyperSkeletonThemeData(style: style.merge(other.style));

  static HyperSkeletonThemeData lerp(
    HyperSkeletonThemeData a,
    HyperSkeletonThemeData b,
    double t,
  ) => HyperSkeletonThemeData(
    style: HyperSkeletonStyle.lerp(a.style, b.style, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperSkeletonThemeData && other.style == style;

  @override
  int get hashCode => style.hashCode;
}

class HyperSkeletonTheme extends StatelessWidget {
  const HyperSkeletonTheme({
    super.key,
    required this.data,
    required this.child,
  });

  final HyperSkeletonThemeData data;
  final Widget child;

  static HyperSkeletonThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SkeletonScope>()?.data ??
      HyperTheme.of(context).skeletonTheme;

  @override
  Widget build(BuildContext context) =>
      _SkeletonScope(data: of(context).merge(data), child: child);
}

class _SkeletonScope extends InheritedTheme {
  const _SkeletonScope({required this.data, required super.child});

  final HyperSkeletonThemeData data;

  @override
  bool updateShouldNotify(_SkeletonScope oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _SkeletonScope(data: data, child: child);
}
