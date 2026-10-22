import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_chart_style.dart';
import 'hyper_chart_theme.dart';
import 'hyper_chart_legend.dart';
export '../../theme/core/hyper_theme.dart';
export '../../theme/core/hyper_theme_data.dart';
export '../../theme/color/hyper_color_scheme.dart';
export 'hyper_chart_style.dart';
export 'hyper_chart_theme.dart';
export 'hyper_chart_legend.dart';

/// 已解析的当前端规格；组件中不保存设备常量。
class HyperChartTokens {
  HyperChartTokens(BuildContext context, [HyperChartStyle? instance]) {
    final s = HyperTheme.sizesOf(context).chart;
    final v = HyperChartTheme.of(context).style.merge(instance);
    height = v.height ?? s.height;
    barWidth = v.barWidth ?? s.barWidth;
    groupSpacing = v.groupSpacing ?? s.groupSpacing;
    axisMinReservedSize = v.axisMinReservedSize ?? s.axisMinReservedSize;
    axisMaxReservedSize = v.axisMaxReservedSize ?? s.axisMaxReservedSize;
    labelFontSize = v.labelFontSize ?? s.labelFontSize;
    radius = v.radius ?? s.radius;
    lineWidth = v.lineWidth ?? s.lineWidth;
    pieRadius = v.pieRadius ?? s.pieRadius;
    donutHoleRadius = v.donutHoleRadius ?? s.donutHoleRadius;
    pointRadius = v.pointRadius ?? s.pointRadius;
    pieSectionSpacing = v.pieSectionSpacing ?? s.pieSectionSpacing;
    legendSpacing = v.legendSpacing ?? s.legendSpacing;
    dataLabelMinSpacing = v.dataLabelMinSpacing ?? s.dataLabelMinSpacing;
    keyboardFocusWidth = v.keyboardFocusWidth ?? s.keyboardFocusWidth;
    gridOpacity = v.gridOpacity ?? HyperChartThemeData.defaults.gridOpacity!;
    inactiveOpacity =
        v.inactiveOpacity ?? HyperChartThemeData.defaults.inactiveOpacity!;
    hoverScale = v.hoverScale ?? HyperChartThemeData.defaults.hoverScale!;
    pieLabelMinPercent =
        v.pieLabelMinPercent ??
        HyperChartThemeData.defaults.pieLabelMinPercent!;
    palette = v.palette ?? const [];
    legend = v.legend ?? const HyperChartLegendOptions();
    animationDuration = HyperTheme.of(context).motion.standardDuration;
    pieAnimationDuration = animationDuration;
  }
  late final double height;
  late final double barWidth;
  late final double groupSpacing;
  late final double axisMinReservedSize;
  late final double axisMaxReservedSize;
  late final double labelFontSize;
  late final double radius;
  late final double lineWidth;
  late final double pieRadius;
  late final double donutHoleRadius;
  late final double pointRadius;
  late final double pieSectionSpacing;
  late final double legendSpacing;
  late final double dataLabelMinSpacing;
  late final double keyboardFocusWidth;
  late final double gridOpacity;
  late final double inactiveOpacity;
  late final double hoverScale;
  late final double pieLabelMinPercent;
  late final List<Color> palette;
  late final HyperChartLegendOptions legend;
  late final Duration animationDuration, pieAnimationDuration;
}
