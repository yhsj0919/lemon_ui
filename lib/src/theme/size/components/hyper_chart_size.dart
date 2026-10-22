import 'dart:ui' show lerpDouble;

import 'package:flutter/foundation.dart';

/// 图表候选几何，沿用本地 lemon_shadcn，D 级参考，尚待视觉确认。
/// 四端独立存储；当前暂沿用相同候选值，不代表官方多端规格。
@immutable
final class HyperChartSize {
  const HyperChartSize({
    this.height = 280,
    this.barWidth = 16,
    this.groupSpacing = 20,
    this.axisMinReservedSize = 32,
    this.axisMaxReservedSize = 80,
    this.labelFontSize = 12,
    this.radius = 5,
    this.lineWidth = 2.5,
    this.pieRadius = 76,
    this.donutHoleRadius = 48,
    this.pointRadius = 3,
    this.pieSectionSpacing = 3,
    this.legendSpacing = 12,
    this.dataLabelMinSpacing = 44,
    this.keyboardFocusWidth = 2,
  });
  final double height;
  final double barWidth;
  final double groupSpacing;
  final double axisMinReservedSize;
  final double axisMaxReservedSize;
  final double labelFontSize;
  final double radius;
  final double lineWidth;
  final double pieRadius;
  final double donutHoleRadius;
  final double pointRadius;
  final double pieSectionSpacing;
  final double legendSpacing;
  final double dataLabelMinSpacing;
  final double keyboardFocusWidth;
  HyperChartSize copyWith({
    double? height,
    double? barWidth,
    double? groupSpacing,
    double? axisMinReservedSize,
    double? axisMaxReservedSize,
    double? labelFontSize,
    double? radius,
    double? lineWidth,
    double? pieRadius,
    double? donutHoleRadius,
    double? pointRadius,
    double? pieSectionSpacing,
    double? legendSpacing,
    double? dataLabelMinSpacing,
    double? keyboardFocusWidth,
  }) => HyperChartSize(
    height: height ?? this.height,
    barWidth: barWidth ?? this.barWidth,
    groupSpacing: groupSpacing ?? this.groupSpacing,
    axisMinReservedSize: axisMinReservedSize ?? this.axisMinReservedSize,
    axisMaxReservedSize: axisMaxReservedSize ?? this.axisMaxReservedSize,
    labelFontSize: labelFontSize ?? this.labelFontSize,
    radius: radius ?? this.radius,
    lineWidth: lineWidth ?? this.lineWidth,
    pieRadius: pieRadius ?? this.pieRadius,
    donutHoleRadius: donutHoleRadius ?? this.donutHoleRadius,
    pointRadius: pointRadius ?? this.pointRadius,
    pieSectionSpacing: pieSectionSpacing ?? this.pieSectionSpacing,
    legendSpacing: legendSpacing ?? this.legendSpacing,
    dataLabelMinSpacing: dataLabelMinSpacing ?? this.dataLabelMinSpacing,
    keyboardFocusWidth: keyboardFocusWidth ?? this.keyboardFocusWidth,
  );
  static HyperChartSize lerp(HyperChartSize a, HyperChartSize b, double t) =>
      HyperChartSize(
        height: lerpDouble(a.height, b.height, t)!,
        barWidth: lerpDouble(a.barWidth, b.barWidth, t)!,
        groupSpacing: lerpDouble(a.groupSpacing, b.groupSpacing, t)!,
        axisMinReservedSize: lerpDouble(
          a.axisMinReservedSize,
          b.axisMinReservedSize,
          t,
        )!,
        axisMaxReservedSize: lerpDouble(
          a.axisMaxReservedSize,
          b.axisMaxReservedSize,
          t,
        )!,
        labelFontSize: lerpDouble(a.labelFontSize, b.labelFontSize, t)!,
        radius: lerpDouble(a.radius, b.radius, t)!,
        lineWidth: lerpDouble(a.lineWidth, b.lineWidth, t)!,
        pieRadius: lerpDouble(a.pieRadius, b.pieRadius, t)!,
        donutHoleRadius: lerpDouble(a.donutHoleRadius, b.donutHoleRadius, t)!,
        pointRadius: lerpDouble(a.pointRadius, b.pointRadius, t)!,
        pieSectionSpacing: lerpDouble(
          a.pieSectionSpacing,
          b.pieSectionSpacing,
          t,
        )!,
        legendSpacing: lerpDouble(a.legendSpacing, b.legendSpacing, t)!,
        dataLabelMinSpacing: lerpDouble(
          a.dataLabelMinSpacing,
          b.dataLabelMinSpacing,
          t,
        )!,
        keyboardFocusWidth: lerpDouble(
          a.keyboardFocusWidth,
          b.keyboardFocusWidth,
          t,
        )!,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperChartSize &&
          other.height == height &&
          other.barWidth == barWidth &&
          other.groupSpacing == groupSpacing &&
          other.axisMinReservedSize == axisMinReservedSize &&
          other.axisMaxReservedSize == axisMaxReservedSize &&
          other.labelFontSize == labelFontSize &&
          other.radius == radius &&
          other.lineWidth == lineWidth &&
          other.pieRadius == pieRadius &&
          other.donutHoleRadius == donutHoleRadius &&
          other.pointRadius == pointRadius &&
          other.pieSectionSpacing == pieSectionSpacing &&
          other.legendSpacing == legendSpacing &&
          other.dataLabelMinSpacing == dataLabelMinSpacing &&
          other.keyboardFocusWidth == keyboardFocusWidth;
  @override
  int get hashCode => Object.hashAll([
    height,
    barWidth,
    groupSpacing,
    axisMinReservedSize,
    axisMaxReservedSize,
    labelFontSize,
    radius,
    lineWidth,
    pieRadius,
    donutHoleRadius,
    pointRadius,
    pieSectionSpacing,
    legendSpacing,
    dataLabelMinSpacing,
    keyboardFocusWidth,
  ]);
}
