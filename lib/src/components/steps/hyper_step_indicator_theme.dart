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
    this.navigationStyle = const HyperStepStyle(),
    this.navigationPending,
    this.navigationCurrent,
    this.navigationCompleted,
    this.navigationError,
    this.navigationDisabled,
  });
  final HyperStepStyle style;
  final HyperStepStyle? pending;
  final HyperStepStyle? current;
  final HyperStepStyle? completed;
  final HyperStepStyle? error;
  final HyperStepStyle? disabled;
  final HyperStepStyle navigationStyle;
  final HyperStepStyle? navigationPending;
  final HyperStepStyle? navigationCurrent;
  final HyperStepStyle? navigationCompleted;
  final HyperStepStyle? navigationError;
  final HyperStepStyle? navigationDisabled;
  HyperStepStyle resolve(HyperStepStatus status, {bool navigation = false}) =>
      style
          .merge(switch (status) {
            HyperStepStatus.pending => pending,
            HyperStepStatus.current => current,
            HyperStepStatus.completed => completed,
            HyperStepStatus.error => error,
            HyperStepStatus.disabled => disabled,
          })
          .merge(
            navigation
                ? navigationStyle.merge(switch (status) {
                    HyperStepStatus.pending => navigationPending,
                    HyperStepStatus.current => navigationCurrent,
                    HyperStepStatus.completed => navigationCompleted,
                    HyperStepStatus.error => navigationError,
                    HyperStepStatus.disabled => navigationDisabled,
                  })
                : null,
          );
  HyperStepIndicatorThemeData copyWith({
    HyperStepStyle? style,
    HyperStepStyle? pending,
    HyperStepStyle? current,
    HyperStepStyle? completed,
    HyperStepStyle? error,
    HyperStepStyle? disabled,
    HyperStepStyle? navigationStyle,
    HyperStepStyle? navigationPending,
    HyperStepStyle? navigationCurrent,
    HyperStepStyle? navigationCompleted,
    HyperStepStyle? navigationError,
    HyperStepStyle? navigationDisabled,
  }) => HyperStepIndicatorThemeData(
    style: style ?? this.style,
    pending: pending ?? this.pending,
    current: current ?? this.current,
    completed: completed ?? this.completed,
    error: error ?? this.error,
    disabled: disabled ?? this.disabled,
    navigationStyle: navigationStyle ?? this.navigationStyle,
    navigationPending: navigationPending ?? this.navigationPending,
    navigationCurrent: navigationCurrent ?? this.navigationCurrent,
    navigationCompleted: navigationCompleted ?? this.navigationCompleted,
    navigationError: navigationError ?? this.navigationError,
    navigationDisabled: navigationDisabled ?? this.navigationDisabled,
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
          navigationStyle: navigationStyle.merge(other.navigationStyle),
          navigationPending:
              navigationPending?.merge(other.navigationPending) ??
              other.navigationPending,
          navigationCurrent:
              navigationCurrent?.merge(other.navigationCurrent) ??
              other.navigationCurrent,
          navigationCompleted:
              navigationCompleted?.merge(other.navigationCompleted) ??
              other.navigationCompleted,
          navigationError:
              navigationError?.merge(other.navigationError) ??
              other.navigationError,
          navigationDisabled:
              navigationDisabled?.merge(other.navigationDisabled) ??
              other.navigationDisabled,
        );
  static HyperStepIndicatorThemeData lerp(
    HyperStepIndicatorThemeData a,
    HyperStepIndicatorThemeData b,
    double t,
  ) {
    HyperStepStyle? blend(HyperStepStyle? x, HyperStepStyle? y) =>
        x == null || y == null
        ? (t < .5 ? x : y)
        : HyperStepStyle.lerp(x, y, t);
    return HyperStepIndicatorThemeData(
      style: HyperStepStyle.lerp(a.style, b.style, t),
      pending: blend(a.pending, b.pending),
      current: blend(a.current, b.current),
      completed: blend(a.completed, b.completed),
      error: blend(a.error, b.error),
      disabled: blend(a.disabled, b.disabled),
      navigationStyle: HyperStepStyle.lerp(
        a.navigationStyle,
        b.navigationStyle,
        t,
      ),
      navigationPending: blend(a.navigationPending, b.navigationPending),
      navigationCurrent: blend(a.navigationCurrent, b.navigationCurrent),
      navigationCompleted: blend(a.navigationCompleted, b.navigationCompleted),
      navigationError: blend(a.navigationError, b.navigationError),
      navigationDisabled: blend(a.navigationDisabled, b.navigationDisabled),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperStepIndicatorThemeData &&
      style == other.style &&
      pending == other.pending &&
      current == other.current &&
      completed == other.completed &&
      error == other.error &&
      disabled == other.disabled &&
      navigationStyle == other.navigationStyle &&
      navigationPending == other.navigationPending &&
      navigationCurrent == other.navigationCurrent &&
      navigationCompleted == other.navigationCompleted &&
      navigationError == other.navigationError &&
      navigationDisabled == other.navigationDisabled;
  @override
  int get hashCode => Object.hashAll([
    style,
    pending,
    current,
    completed,
    error,
    disabled,
    navigationStyle,
    navigationPending,
    navigationCurrent,
    navigationCompleted,
    navigationError,
    navigationDisabled,
  ]);
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
