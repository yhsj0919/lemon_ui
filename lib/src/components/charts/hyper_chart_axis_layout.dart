import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/widgets.dart';

// Shared separation between an axis boundary and its tick-label box.
const double hyperChartAxisLabelGap = 6;

double hyperChartAxisLabelHeight(BuildContext context, TextStyle style) {
  final painter = TextPainter(
    text: TextSpan(
      text: '0',
      style: DefaultTextStyle.of(context).style.merge(style),
    ),
    textScaler: MediaQuery.textScalerOf(context),
    textDirection: Directionality.of(context),
  )..layout();
  final height = painter.height;
  painter.dispose();
  return height;
}

/// Constrains horizontal label boxes to the plot span without moving ticks.
/// Uses measured text geometry directly, including rotated and scaled labels.
Widget hyperChartCornerLabel(TitleMeta meta, double width, Widget child) {
  final logicalHorizontal =
      meta.axisSide == AxisSide.top || meta.axisSide == AxisSide.bottom;
  if (logicalHorizontal == meta.rotationQuarterTurns.isOdd) return child;
  final extent = meta.parentAxisSize;
  final position = meta.rotationQuarterTurns.isOdd
      ? extent - meta.axisPosition
      : meta.axisPosition;
  final half = math.min(width / 2, extent / 2);
  final center = position.clamp(half, math.max(half, extent - half));
  return Transform.translate(
    offset: Offset(center - position, 0),
    child: child,
  );
}

double hyperChartAxisLabelWidth(
  BuildContext context,
  String label,
  TextStyle style,
) {
  final painter = TextPainter(
    text: TextSpan(
      text: label,
      style: DefaultTextStyle.of(context).style.merge(style),
    ),
    textScaler: MediaQuery.textScalerOf(context),
    textDirection: Directionality.of(context),
  )..layout();
  final width = painter.width;
  painter.dispose();
  return width;
}

/// fl_chart omits grid endpoints. Draw them at the plot boundary using the
/// same visibility predicates and line style as the interior grid.
FlBorderData hyperChartGridBoundary(
  FlGridData grid, {
  required double minY,
  required double maxY,
  double? minX,
  double? maxX,
}) {
  BorderSide horizontal(double value) {
    if (!grid.show ||
        !grid.drawHorizontalLine ||
        !grid.checkToShowHorizontalLine(value)) {
      return BorderSide.none;
    }
    final line = grid.getDrawingHorizontalLine(value);
    return BorderSide(
      color: line.color ?? const Color(0x00000000),
      width: line.strokeWidth,
    );
  }

  BorderSide vertical(double? value) {
    if (value == null ||
        !grid.show ||
        !grid.drawVerticalLine ||
        !grid.checkToShowVerticalLine(value)) {
      return BorderSide.none;
    }
    final line = grid.getDrawingVerticalLine(value);
    return BorderSide(
      color: line.color ?? const Color(0x00000000),
      width: line.strokeWidth,
    );
  }

  return FlBorderData(
    show: grid.show,
    border: Border(
      top: horizontal(maxY),
      bottom: horizontal(minY),
      left: vertical(minX),
      right: vertical(maxX),
    ),
  );
}

double hyperChartAxisExtent(AxisTitles axis) =>
    (axis.axisNameWidget == null ? 0 : axis.axisNameSize) +
    (axis.sideTitles.showTitles ? axis.sideTitles.reservedSize : 0);

/// Balances the physical left/right gutters, including labels and axis names.
/// Horizontal bars rotate their logical top/bottom sides onto these edges.
FlTitlesData hyperChartBalancedTitles(
  FlTitlesData titles, {
  bool quarterTurn = false,
  double verticalLabelHeight = 0,
}) {
  final first = quarterTurn ? titles.bottomTitles : titles.leftTitles;
  final second = quarterTurn ? titles.topTitles : titles.rightTitles;
  final extent = math.max(
    hyperChartAxisExtent(first),
    hyperChartAxisExtent(second),
  );
  AxisTitles reserve(AxisTitles axis) {
    final name = axis.axisNameWidget == null ? 0.0 : axis.axisNameSize;
    final side = axis.sideTitles;
    return axis.copyWith(
      axisNameSize: name,
      sideTitles: side.copyWith(
        showTitles: extent > name,
        reservedSize: extent - name,
        getTitlesWidget: side.showTitles
            ? side.getTitlesWidget
            : (_, _) => const SizedBox.shrink(),
      ),
    );
  }

  final balanced = quarterTurn
      ? titles.copyWith(
          bottomTitles: reserve(first),
          topTitles: reserve(second),
        )
      : titles.copyWith(
          leftTitles: reserve(first),
          rightTitles: reserve(second),
        );
  AxisTitles endpointSpace(AxisTitles axis) {
    final current = hyperChartAxisExtent(axis);
    final extra = math.max(0.0, verticalLabelHeight / 2 - current);
    if (extra == 0) return axis;
    final side = axis.sideTitles;
    return axis.copyWith(
      sideTitles: side.copyWith(
        showTitles: true,
        reservedSize: (side.showTitles ? side.reservedSize : 0) + extra,
        getTitlesWidget: side.showTitles
            ? side.getTitlesWidget
            : (_, _) => const SizedBox.shrink(),
      ),
    );
  }

  return quarterTurn
      ? balanced.copyWith(
          leftTitles: endpointSpace(balanced.leftTitles),
          rightTitles: endpointSpace(balanced.rightTitles),
        )
      : balanced.copyWith(
          topTitles: endpointSpace(balanced.topTitles),
          bottomTitles: endpointSpace(balanced.bottomTitles),
        );
}
