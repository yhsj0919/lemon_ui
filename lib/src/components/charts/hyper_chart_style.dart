import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../card/hyper_card_style.dart';
import 'hyper_chart_legend.dart';

@immutable
final class HyperChartStyle {
  const HyperChartStyle({
    this.height,
    this.barWidth,
    this.groupSpacing,
    this.axisMinReservedSize,
    this.axisMaxReservedSize,
    this.labelFontSize,
    this.radius,
    this.lineWidth,
    this.pieRadius,
    this.donutHoleRadius,
    this.pointRadius,
    this.pieSectionSpacing,
    this.legendSpacing,
    this.dataLabelMinSpacing,
    this.keyboardFocusWidth,
    this.gridOpacity,
    this.inactiveOpacity,
    this.hoverScale,
    this.pieLabelMinPercent,
    this.palette,
    this.tooltipStyle,
    this.legend,
  });
  final double? height;
  final double? barWidth;
  final double? groupSpacing;
  final double? axisMinReservedSize;
  final double? axisMaxReservedSize;
  final double? labelFontSize;
  final double? radius;
  final double? lineWidth;
  final double? pieRadius;
  final double? donutHoleRadius;
  final double? pointRadius;
  final double? pieSectionSpacing;
  final double? legendSpacing;
  final double? dataLabelMinSpacing;
  final double? keyboardFocusWidth;
  final double? gridOpacity;
  final double? inactiveOpacity;
  final double? hoverScale;
  final double? pieLabelMinPercent;
  final List<Color>? palette;
  final HyperCardStyle? tooltipStyle;
  final HyperChartLegendOptions? legend;
  HyperChartStyle copyWith({
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
    double? gridOpacity,
    double? inactiveOpacity,
    double? hoverScale,
    double? pieLabelMinPercent,
    List<Color>? palette,
    HyperCardStyle? tooltipStyle,
    HyperChartLegendOptions? legend,
  }) => HyperChartStyle(
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
    gridOpacity: gridOpacity ?? this.gridOpacity,
    inactiveOpacity: inactiveOpacity ?? this.inactiveOpacity,
    hoverScale: hoverScale ?? this.hoverScale,
    pieLabelMinPercent: pieLabelMinPercent ?? this.pieLabelMinPercent,
    palette: palette ?? this.palette,
    tooltipStyle: tooltipStyle ?? this.tooltipStyle,
    legend: legend ?? this.legend,
  );
  HyperChartStyle merge(HyperChartStyle? other) => other == null
      ? this
      : HyperChartStyle(
          height: other.height ?? height,
          barWidth: other.barWidth ?? barWidth,
          groupSpacing: other.groupSpacing ?? groupSpacing,
          axisMinReservedSize: other.axisMinReservedSize ?? axisMinReservedSize,
          axisMaxReservedSize: other.axisMaxReservedSize ?? axisMaxReservedSize,
          labelFontSize: other.labelFontSize ?? labelFontSize,
          radius: other.radius ?? radius,
          lineWidth: other.lineWidth ?? lineWidth,
          pieRadius: other.pieRadius ?? pieRadius,
          donutHoleRadius: other.donutHoleRadius ?? donutHoleRadius,
          pointRadius: other.pointRadius ?? pointRadius,
          pieSectionSpacing: other.pieSectionSpacing ?? pieSectionSpacing,
          legendSpacing: other.legendSpacing ?? legendSpacing,
          dataLabelMinSpacing: other.dataLabelMinSpacing ?? dataLabelMinSpacing,
          keyboardFocusWidth: other.keyboardFocusWidth ?? keyboardFocusWidth,
          gridOpacity: other.gridOpacity ?? gridOpacity,
          inactiveOpacity: other.inactiveOpacity ?? inactiveOpacity,
          hoverScale: other.hoverScale ?? hoverScale,
          pieLabelMinPercent: other.pieLabelMinPercent ?? pieLabelMinPercent,
          palette: other.palette ?? palette,
          tooltipStyle:
              tooltipStyle?.merge(other.tooltipStyle) ?? other.tooltipStyle,
          legend: legend?.merge(other.legend) ?? other.legend,
        );
  static HyperChartStyle lerp(HyperChartStyle a, HyperChartStyle b, double t) =>
      HyperChartStyle(
        height: lerpDouble(a.height, b.height, t),
        barWidth: lerpDouble(a.barWidth, b.barWidth, t),
        groupSpacing: lerpDouble(a.groupSpacing, b.groupSpacing, t),
        axisMinReservedSize: lerpDouble(
          a.axisMinReservedSize,
          b.axisMinReservedSize,
          t,
        ),
        axisMaxReservedSize: lerpDouble(
          a.axisMaxReservedSize,
          b.axisMaxReservedSize,
          t,
        ),
        labelFontSize: lerpDouble(a.labelFontSize, b.labelFontSize, t),
        radius: lerpDouble(a.radius, b.radius, t),
        lineWidth: lerpDouble(a.lineWidth, b.lineWidth, t),
        pieRadius: lerpDouble(a.pieRadius, b.pieRadius, t),
        donutHoleRadius: lerpDouble(a.donutHoleRadius, b.donutHoleRadius, t),
        pointRadius: lerpDouble(a.pointRadius, b.pointRadius, t),
        pieSectionSpacing: lerpDouble(
          a.pieSectionSpacing,
          b.pieSectionSpacing,
          t,
        ),
        legendSpacing: lerpDouble(a.legendSpacing, b.legendSpacing, t),
        dataLabelMinSpacing: lerpDouble(
          a.dataLabelMinSpacing,
          b.dataLabelMinSpacing,
          t,
        ),
        keyboardFocusWidth: lerpDouble(
          a.keyboardFocusWidth,
          b.keyboardFocusWidth,
          t,
        ),
        gridOpacity: lerpDouble(a.gridOpacity, b.gridOpacity, t),
        inactiveOpacity: lerpDouble(a.inactiveOpacity, b.inactiveOpacity, t),
        hoverScale: lerpDouble(a.hoverScale, b.hoverScale, t),
        pieLabelMinPercent: lerpDouble(
          a.pieLabelMinPercent,
          b.pieLabelMinPercent,
          t,
        ),
        palette: t < .5 ? a.palette : b.palette,
        tooltipStyle: a.tooltipStyle == null && b.tooltipStyle == null
            ? null
            : HyperCardStyle.lerp(
                a.tooltipStyle ?? HyperCardStyle(),
                b.tooltipStyle ?? HyperCardStyle(),
                t,
              ),
        legend: t < .5 ? a.legend : b.legend,
      );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperChartStyle &&
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
          other.keyboardFocusWidth == keyboardFocusWidth &&
          other.gridOpacity == gridOpacity &&
          other.inactiveOpacity == inactiveOpacity &&
          other.hoverScale == hoverScale &&
          other.pieLabelMinPercent == pieLabelMinPercent &&
          listEquals(other.palette, palette) &&
          other.tooltipStyle == tooltipStyle &&
          other.legend == legend;
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
    gridOpacity,
    inactiveOpacity,
    hoverScale,
    pieLabelMinPercent,
    palette == null ? null : Object.hashAll(palette!),
    tooltipStyle,
    legend,
  ]);
}
