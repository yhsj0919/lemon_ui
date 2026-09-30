import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_slider_style.dart';

@immutable
final class HyperSliderThemeData {
  const HyperSliderThemeData({this.style = const HyperSliderStyle()});

  final HyperSliderStyle style;

  HyperSliderThemeData copyWith({HyperSliderStyle? style}) =>
      HyperSliderThemeData(style: style ?? this.style);

  HyperSliderThemeData merge(HyperSliderThemeData? other) => other == null
      ? this
      : HyperSliderThemeData(style: style.merge(other.style));

  static HyperSliderThemeData lerp(
    HyperSliderThemeData a,
    HyperSliderThemeData b,
    double t,
  ) => HyperSliderThemeData(style: HyperSliderStyle.lerp(a.style, b.style, t));

  @override
  bool operator ==(Object other) =>
      other is HyperSliderThemeData && other.style == style;

  @override
  int get hashCode => style.hashCode;
}

class HyperSliderTheme extends StatelessWidget {
  const HyperSliderTheme({super.key, required this.data, required this.child});

  final HyperSliderThemeData data;
  final Widget child;

  static HyperSliderThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_SliderScope>()?.data ??
      HyperTheme.of(context).sliderTheme;

  @override
  Widget build(BuildContext context) =>
      _SliderScope(data: of(context).merge(data), child: child);
}

class _SliderScope extends InheritedTheme {
  const _SliderScope({required this.data, required super.child});

  final HyperSliderThemeData data;

  @override
  bool updateShouldNotify(_SliderScope oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _SliderScope(data: data, child: child);
}
