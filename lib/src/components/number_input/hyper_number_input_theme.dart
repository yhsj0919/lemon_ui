import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import '../icon_button/hyper_icon_button_style.dart';
import 'hyper_number_input_layout.dart';

@immutable
final class HyperNumberInputThemeData {
  const HyperNumberInputThemeData({this.layout, this.stepperStyle});
  final HyperNumberInputLayout? layout;
  final HyperIconButtonStyle? stepperStyle;

  HyperNumberInputThemeData copyWith({
    HyperNumberInputLayout? layout,
    HyperIconButtonStyle? stepperStyle,
  }) => HyperNumberInputThemeData(
    layout: layout ?? this.layout,
    stepperStyle: stepperStyle ?? this.stepperStyle,
  );
  HyperNumberInputThemeData merge(HyperNumberInputThemeData? other) =>
      other == null
      ? this
      : copyWith(
          layout: other.layout,
          stepperStyle: (stepperStyle ?? HyperIconButtonStyle()).merge(
            other.stepperStyle,
          ),
        );
  static HyperNumberInputThemeData lerp(
    HyperNumberInputThemeData a,
    HyperNumberInputThemeData b,
    double t,
  ) => HyperNumberInputThemeData(
    layout: t < .5 ? a.layout : b.layout,
    stepperStyle: HyperIconButtonStyle.lerp(
      a.stepperStyle ?? HyperIconButtonStyle(),
      b.stepperStyle ?? HyperIconButtonStyle(),
      t,
    ),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperNumberInputThemeData &&
      other.layout == layout &&
      other.stepperStyle == stepperStyle;
  @override
  int get hashCode => Object.hash(layout, stepperStyle);
}

class HyperNumberInputTheme extends StatelessWidget {
  const HyperNumberInputTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperNumberInputThemeData data;
  final Widget child;
  static HyperNumberInputThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).numberInputTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperNumberInputThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
