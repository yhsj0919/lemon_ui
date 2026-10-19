import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_wheel_picker_style.dart';

@immutable
final class HyperWheelPickerThemeData {
  const HyperWheelPickerThemeData({this.style = const HyperWheelPickerStyle()});
  final HyperWheelPickerStyle style;

  HyperWheelPickerThemeData copyWith({HyperWheelPickerStyle? style}) =>
      HyperWheelPickerThemeData(style: style ?? this.style);
  HyperWheelPickerThemeData merge(HyperWheelPickerThemeData? other) =>
      other == null
      ? this
      : HyperWheelPickerThemeData(style: style.merge(other.style));
  static HyperWheelPickerThemeData lerp(
    HyperWheelPickerThemeData a,
    HyperWheelPickerThemeData b,
    double t,
  ) => HyperWheelPickerThemeData(
    style: HyperWheelPickerStyle.lerp(a.style, b.style, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperWheelPickerThemeData && style == other.style;
  @override
  int get hashCode => Object.hashAll([style]);
}

class HyperWheelPickerTheme extends StatelessWidget {
  const HyperWheelPickerTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperWheelPickerThemeData data;
  final Widget child;
  static HyperWheelPickerThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).wheelPickerTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperWheelPickerThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
