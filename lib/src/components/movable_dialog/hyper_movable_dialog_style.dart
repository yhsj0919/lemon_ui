import 'package:flutter/material.dart';

import '../dialog/hyper_dialog_style.dart';

/// Explicit visual overrides. Unspecified geometry inherits current semantic sizes.
@immutable
final class HyperMovableDialogStyle {
  const HyperMovableDialogStyle({this.dialogStyle, this.mouseCursor});
  final HyperDialogStyle? dialogStyle;
  final MouseCursor? mouseCursor;
  HyperMovableDialogStyle copyWith({
    HyperDialogStyle? dialogStyle,
    MouseCursor? mouseCursor,
  }) => merge(
    HyperMovableDialogStyle(dialogStyle: dialogStyle, mouseCursor: mouseCursor),
  );
  HyperMovableDialogStyle merge(HyperMovableDialogStyle? other) => other == null
      ? this
      : HyperMovableDialogStyle(
          dialogStyle:
              dialogStyle?.merge(other.dialogStyle) ?? other.dialogStyle,
          mouseCursor: other.mouseCursor ?? mouseCursor,
        );
  static HyperMovableDialogStyle lerp(
    HyperMovableDialogStyle a,
    HyperMovableDialogStyle b,
    double t,
  ) => HyperMovableDialogStyle(
    dialogStyle: a.dialogStyle == null || b.dialogStyle == null
        ? (t < .5 ? a.dialogStyle : b.dialogStyle)
        : HyperDialogStyle.lerp(a.dialogStyle!, b.dialogStyle!, t),
    mouseCursor: t < .5 ? a.mouseCursor : b.mouseCursor,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperMovableDialogStyle &&
      other.dialogStyle == dialogStyle &&
      other.mouseCursor == mouseCursor;
  @override
  int get hashCode => Object.hashAll([dialogStyle, mouseCursor]);
}
