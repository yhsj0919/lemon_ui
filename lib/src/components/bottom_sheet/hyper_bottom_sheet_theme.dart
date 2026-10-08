import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_bottom_sheet_style.dart';

@immutable
final class HyperBottomSheetThemeData {
  const HyperBottomSheetThemeData({this.style = const HyperBottomSheetStyle()});
  final HyperBottomSheetStyle style;
  HyperBottomSheetThemeData copyWith({HyperBottomSheetStyle? style}) =>
      HyperBottomSheetThemeData(style: style ?? this.style);
  HyperBottomSheetThemeData merge(HyperBottomSheetThemeData? other) =>
      other == null
      ? this
      : HyperBottomSheetThemeData(style: style.merge(other.style));
  static HyperBottomSheetThemeData lerp(
    HyperBottomSheetThemeData a,
    HyperBottomSheetThemeData b,
    double t,
  ) => HyperBottomSheetThemeData(
    style: HyperBottomSheetStyle.lerp(a.style, b.style, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperBottomSheetThemeData && style == other.style;
  @override
  int get hashCode => style.hashCode;
}

class HyperBottomSheetTheme extends StatelessWidget {
  const HyperBottomSheetTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperBottomSheetThemeData data;
  final Widget child;
  static HyperBottomSheetThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).bottomSheetTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperBottomSheetThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
