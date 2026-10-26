import 'package:flutter/material.dart';

import '../button/hyper_button_style.dart';
import '../text_field/hyper_text_field_style.dart';

/// Explicit overrides; geometry inherits the current TextField/Button/Form sizes.
@immutable
final class HyperInlineEditStyle {
  const HyperInlineEditStyle({
    this.displayStyle,
    this.inputStyle,
    this.actionStyle,
    this.errorStyle,
    this.transitionDuration,
    this.transitionCurve,
    this.mouseCursor,
  });
  final TextStyle? displayStyle, errorStyle;
  final HyperTextFieldStyle? inputStyle;
  final HyperButtonStyle? actionStyle;
  final Duration? transitionDuration;
  final Curve? transitionCurve;
  final MouseCursor? mouseCursor;

  HyperInlineEditStyle copyWith({
    TextStyle? displayStyle,
    HyperTextFieldStyle? inputStyle,
    HyperButtonStyle? actionStyle,
    TextStyle? errorStyle,
    Duration? transitionDuration,
    Curve? transitionCurve,
    MouseCursor? mouseCursor,
  }) => merge(
    HyperInlineEditStyle(
      displayStyle: displayStyle,
      inputStyle: inputStyle,
      actionStyle: actionStyle,
      errorStyle: errorStyle,
      transitionDuration: transitionDuration,
      transitionCurve: transitionCurve,
      mouseCursor: mouseCursor,
    ),
  );

  HyperInlineEditStyle merge(HyperInlineEditStyle? other) => other == null
      ? this
      : HyperInlineEditStyle(
          displayStyle:
              displayStyle?.merge(other.displayStyle) ?? other.displayStyle,
          inputStyle: inputStyle?.merge(other.inputStyle) ?? other.inputStyle,
          actionStyle:
              actionStyle?.merge(other.actionStyle) ?? other.actionStyle,
          errorStyle: errorStyle?.merge(other.errorStyle) ?? other.errorStyle,
          transitionDuration: other.transitionDuration ?? transitionDuration,
          transitionCurve: other.transitionCurve ?? transitionCurve,
          mouseCursor: other.mouseCursor ?? mouseCursor,
        );

  static HyperInlineEditStyle lerp(
    HyperInlineEditStyle a,
    HyperInlineEditStyle b,
    double t,
  ) => HyperInlineEditStyle(
    displayStyle: TextStyle.lerp(a.displayStyle, b.displayStyle, t),
    errorStyle: TextStyle.lerp(a.errorStyle, b.errorStyle, t),
    inputStyle: a.inputStyle == null || b.inputStyle == null
        ? (t < .5 ? a.inputStyle : b.inputStyle)
        : HyperTextFieldStyle.lerp(a.inputStyle!, b.inputStyle!, t),
    actionStyle: a.actionStyle == null || b.actionStyle == null
        ? (t < .5 ? a.actionStyle : b.actionStyle)
        : HyperButtonStyle.lerp(a.actionStyle!, b.actionStyle!, t),
    transitionDuration:
        a.transitionDuration == null || b.transitionDuration == null
        ? (t < .5 ? a.transitionDuration : b.transitionDuration)
        : Duration(
            microseconds:
                (a.transitionDuration!.inMicroseconds +
                        (b.transitionDuration!.inMicroseconds -
                                a.transitionDuration!.inMicroseconds) *
                            t)
                    .round(),
          ),
    transitionCurve: t < .5 ? a.transitionCurve : b.transitionCurve,
    mouseCursor: t < .5 ? a.mouseCursor : b.mouseCursor,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperInlineEditStyle &&
      other.displayStyle == displayStyle &&
      other.inputStyle == inputStyle &&
      other.actionStyle == actionStyle &&
      other.errorStyle == errorStyle &&
      other.transitionDuration == transitionDuration &&
      other.transitionCurve == transitionCurve &&
      other.mouseCursor == mouseCursor;
  @override
  int get hashCode => Object.hash(
    displayStyle,
    inputStyle,
    actionStyle,
    errorStyle,
    transitionDuration,
    transitionCurve,
    mouseCursor,
  );
}
