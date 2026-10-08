import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_loading_overlay_style.dart';

@immutable
final class HyperLoadingOverlayThemeData {
  const HyperLoadingOverlayThemeData({
    this.style = const HyperLoadingOverlayStyle(),
  });
  final HyperLoadingOverlayStyle style;
  HyperLoadingOverlayThemeData copyWith({HyperLoadingOverlayStyle? style}) =>
      HyperLoadingOverlayThemeData(style: style ?? this.style);
  HyperLoadingOverlayThemeData merge(HyperLoadingOverlayThemeData? other) =>
      other == null
      ? this
      : HyperLoadingOverlayThemeData(style: style.merge(other.style));
  static HyperLoadingOverlayThemeData lerp(
    HyperLoadingOverlayThemeData a,
    HyperLoadingOverlayThemeData b,
    double t,
  ) => HyperLoadingOverlayThemeData(
    style: HyperLoadingOverlayStyle.lerp(a.style, b.style, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperLoadingOverlayThemeData && style == other.style;
  @override
  int get hashCode => style.hashCode;
}

class HyperLoadingOverlayTheme extends StatelessWidget {
  const HyperLoadingOverlayTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperLoadingOverlayThemeData data;
  final Widget child;
  static HyperLoadingOverlayThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).loadingOverlayTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperLoadingOverlayThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
