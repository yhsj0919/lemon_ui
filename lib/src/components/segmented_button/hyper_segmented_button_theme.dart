import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_segmented_button_style.dart';

@immutable
final class HyperSegmentedButtonThemeData {
  const HyperSegmentedButtonThemeData({
    this.style = const HyperSegmentedButtonStyle(),
  });
  final HyperSegmentedButtonStyle style;
  HyperSegmentedButtonThemeData copyWith({HyperSegmentedButtonStyle? style}) =>
      HyperSegmentedButtonThemeData(style: style ?? this.style);
  HyperSegmentedButtonThemeData merge(HyperSegmentedButtonThemeData? other) =>
      other == null
      ? this
      : HyperSegmentedButtonThemeData(style: style.merge(other.style));
  static HyperSegmentedButtonThemeData lerp(
    HyperSegmentedButtonThemeData a,
    HyperSegmentedButtonThemeData b,
    double t,
  ) => HyperSegmentedButtonThemeData(
    style: HyperSegmentedButtonStyle.lerp(a.style, b.style, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperSegmentedButtonThemeData && style == other.style;
  @override
  int get hashCode => style.hashCode;
}

class HyperSegmentedButtonTheme extends StatelessWidget {
  const HyperSegmentedButtonTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperSegmentedButtonThemeData data;
  final Widget child;
  static HyperSegmentedButtonThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).segmentedButtonTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperSegmentedButtonThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
