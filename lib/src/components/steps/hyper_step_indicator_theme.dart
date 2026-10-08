import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_step_style.dart';
import 'hyper_step_model.dart';

@immutable
final class HyperStepIndicatorThemeData {
  const HyperStepIndicatorThemeData({
    this.style = const HyperStepStyle(),
    this.pending,
    this.current,
    this.completed,
    this.error,
    this.disabled,
  });
  final HyperStepStyle style;
  final HyperStepStyle? pending;
  final HyperStepStyle? current;
  final HyperStepStyle? completed;
  final HyperStepStyle? error;
  final HyperStepStyle? disabled;
  HyperStepStyle resolve(HyperStepStatus status) =>
      style.merge(switch (status) {
        HyperStepStatus.pending => pending,
        HyperStepStatus.current => current,
        HyperStepStatus.completed => completed,
        HyperStepStatus.error => error,
        HyperStepStatus.disabled => disabled,
      });
  HyperStepIndicatorThemeData copyWith({
    HyperStepStyle? style,
    HyperStepStyle? pending,
    HyperStepStyle? current,
    HyperStepStyle? completed,
    HyperStepStyle? error,
    HyperStepStyle? disabled,
  }) => HyperStepIndicatorThemeData(
    style: style ?? this.style,
    pending: pending ?? this.pending,
    current: current ?? this.current,
    completed: completed ?? this.completed,
    error: error ?? this.error,
    disabled: disabled ?? this.disabled,
  );
  HyperStepIndicatorThemeData merge(HyperStepIndicatorThemeData? other) =>
      other == null
      ? this
      : HyperStepIndicatorThemeData(
          style: style.merge(other.style),
          pending: pending?.merge(other.pending) ?? other.pending,
          current: current?.merge(other.current) ?? other.current,
          completed: completed?.merge(other.completed) ?? other.completed,
          error: error?.merge(other.error) ?? other.error,
          disabled: disabled?.merge(other.disabled) ?? other.disabled,
        );
  static HyperStepIndicatorThemeData lerp(
    HyperStepIndicatorThemeData a,
    HyperStepIndicatorThemeData b,
    double t,
  ) => HyperStepIndicatorThemeData(
    style: HyperStepStyle.lerp(a.style, b.style, t),
    pending: a.pending == null || b.pending == null
        ? (t < .5 ? a.pending : b.pending)
        : HyperStepStyle.lerp(a.pending!, b.pending!, t),
    current: a.current == null || b.current == null
        ? (t < .5 ? a.current : b.current)
        : HyperStepStyle.lerp(a.current!, b.current!, t),
    completed: a.completed == null || b.completed == null
        ? (t < .5 ? a.completed : b.completed)
        : HyperStepStyle.lerp(a.completed!, b.completed!, t),
    error: a.error == null || b.error == null
        ? (t < .5 ? a.error : b.error)
        : HyperStepStyle.lerp(a.error!, b.error!, t),
    disabled: a.disabled == null || b.disabled == null
        ? (t < .5 ? a.disabled : b.disabled)
        : HyperStepStyle.lerp(a.disabled!, b.disabled!, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperStepIndicatorThemeData &&
      style == other.style &&
      pending == other.pending &&
      current == other.current &&
      completed == other.completed &&
      error == other.error &&
      disabled == other.disabled;
  @override
  int get hashCode =>
      Object.hashAll([style, pending, current, completed, error, disabled]);
}

class HyperStepIndicatorTheme extends StatelessWidget {
  const HyperStepIndicatorTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperStepIndicatorThemeData data;
  final Widget child;
  static HyperStepIndicatorThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).stepIndicatorTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperStepIndicatorThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
