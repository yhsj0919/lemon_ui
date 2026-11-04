import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

enum HyperFieldLayout { vertical, horizontal, labelHidden }

enum HyperFieldAlignment { start, center, end }

enum HyperFieldErrorDisplay { auto, inline, trailingIcon, below }

@immutable
final class HyperFieldStyle {
  const HyperFieldStyle({
    this.horizontalAlignment,
    this.labelWidth,
    this.gap,
    this.fieldSpacing,
    this.messageSpacing,
    this.minimumControlWidth,
    this.labelStyle,
    this.descriptionStyle,
    this.errorStyle,
    this.requiredColor,
  });
  final double? labelWidth;

  /// 横向布局中标签与内容区的纵向对齐；默认居中。
  final HyperFieldAlignment? horizontalAlignment;
  final double? gap;
  final double? fieldSpacing;
  final double? messageSpacing;
  final double? minimumControlWidth;
  final TextStyle? labelStyle;
  final TextStyle? descriptionStyle;
  final TextStyle? errorStyle;
  final Color? requiredColor;
  HyperFieldStyle copyWith({
    HyperFieldAlignment? horizontalAlignment,
    double? labelWidth,
    double? gap,
    double? fieldSpacing,
    double? messageSpacing,
    double? minimumControlWidth,
    TextStyle? labelStyle,
    TextStyle? descriptionStyle,
    TextStyle? errorStyle,
    Color? requiredColor,
  }) => merge(
    HyperFieldStyle(
      horizontalAlignment: horizontalAlignment,
      labelWidth: labelWidth,
      gap: gap,
      fieldSpacing: fieldSpacing,
      messageSpacing: messageSpacing,
      minimumControlWidth: minimumControlWidth,
      labelStyle: labelStyle,
      descriptionStyle: descriptionStyle,
      errorStyle: errorStyle,
      requiredColor: requiredColor,
    ),
  );
  HyperFieldStyle merge(HyperFieldStyle? other) => other == null
      ? this
      : HyperFieldStyle(
          horizontalAlignment: other.horizontalAlignment ?? horizontalAlignment,
          labelWidth: other.labelWidth ?? labelWidth,
          gap: other.gap ?? gap,
          fieldSpacing: other.fieldSpacing ?? fieldSpacing,
          messageSpacing: other.messageSpacing ?? messageSpacing,
          minimumControlWidth: other.minimumControlWidth ?? minimumControlWidth,
          labelStyle: labelStyle?.merge(other.labelStyle) ?? other.labelStyle,
          descriptionStyle:
              descriptionStyle?.merge(other.descriptionStyle) ??
              other.descriptionStyle,
          errorStyle: errorStyle?.merge(other.errorStyle) ?? other.errorStyle,
          requiredColor: other.requiredColor ?? requiredColor,
        );
  static HyperFieldStyle lerp(
    HyperFieldStyle a,
    HyperFieldStyle b,
    double t,
  ) => HyperFieldStyle(
    horizontalAlignment: t < .5 ? a.horizontalAlignment : b.horizontalAlignment,
    labelWidth: lerpDouble(a.labelWidth, b.labelWidth, t),
    gap: lerpDouble(a.gap, b.gap, t),
    fieldSpacing: lerpDouble(a.fieldSpacing, b.fieldSpacing, t),
    messageSpacing: lerpDouble(a.messageSpacing, b.messageSpacing, t),
    minimumControlWidth: lerpDouble(
      a.minimumControlWidth,
      b.minimumControlWidth,
      t,
    ),
    labelStyle: TextStyle.lerp(a.labelStyle, b.labelStyle, t),
    descriptionStyle: TextStyle.lerp(a.descriptionStyle, b.descriptionStyle, t),
    errorStyle: TextStyle.lerp(a.errorStyle, b.errorStyle, t),
    requiredColor: Color.lerp(a.requiredColor, b.requiredColor, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperFieldStyle &&
      other.horizontalAlignment == horizontalAlignment &&
      other.labelWidth == labelWidth &&
      other.gap == gap &&
      other.fieldSpacing == fieldSpacing &&
      other.messageSpacing == messageSpacing &&
      other.minimumControlWidth == minimumControlWidth &&
      other.labelStyle == labelStyle &&
      other.descriptionStyle == descriptionStyle &&
      other.errorStyle == errorStyle &&
      other.requiredColor == requiredColor;
  @override
  int get hashCode => Object.hashAll([
    horizontalAlignment,
    labelWidth,
    gap,
    fieldSpacing,
    messageSpacing,
    minimumControlWidth,
    labelStyle,
    descriptionStyle,
    errorStyle,
    requiredColor,
  ]);
}
