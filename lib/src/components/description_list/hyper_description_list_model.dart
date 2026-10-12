import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'hyper_description_list_style.dart';

enum HyperDescriptionLabelPlacement { inline, above }

@immutable
class HyperDescriptionItem {
  const HyperDescriptionItem({
    required this.id,
    required this.label,
    this.value,
    this.span = 1,
    this.style,
  });
  final Object id;
  final Widget label;
  final Widget? value;
  final int span;
  final HyperDescriptionListStyle? style;
}

/// 布局只依据可用宽度，不改变设备分类。每行保留未用的尾部列。
class HyperDescriptionListLayout {
  HyperDescriptionListLayout(
    List<HyperDescriptionItem> items, {
    required int columns,
    required double width,
    required double minimumColumnWidth,
    double spacing = 0,
    bool responsive = true,
  }) {
    if (columns < 1 ||
        !width.isFinite ||
        width < 0 ||
        !minimumColumnWidth.isFinite ||
        minimumColumnWidth <= 0 ||
        !spacing.isFinite ||
        spacing < 0) {
      throw ArgumentError('列数和最小列宽必须为正，可用宽度与间距必须为有限非负值。');
    }
    columnCount = responsive
        ? math.min(
            columns,
            math.max(
              1,
              ((width + spacing) / (minimumColumnWidth + spacing)).floor(),
            ),
          )
        : columns;
    columnWidth = math.max(
      0,
      (width - (columnCount - 1) * spacing) / columnCount,
    );
    final ids = <Object>{};
    final result = <List<HyperDescriptionPlacement>>[];
    var row = <HyperDescriptionPlacement>[];
    var used = 0;
    for (final item in items) {
      if (!ids.add(item.id) || item.span < 1) {
        throw ArgumentError('描述项 id 必须唯一，span 必须为正。');
      }
      final span = math.min(item.span, columnCount);
      if (used + span > columnCount) {
        result.add(List.unmodifiable(row));
        row = [];
        used = 0;
      }
      row.add(
        HyperDescriptionPlacement(
          item,
          span,
          columnWidth * span + spacing * (span - 1),
        ),
      );
      used += span;
    }
    if (row.isNotEmpty) {
      result.add(List.unmodifiable(row));
    }
    rows = List.unmodifiable(result);
  }
  late final int columnCount;
  late final double columnWidth;
  late final List<List<HyperDescriptionPlacement>> rows;
}

@immutable
class HyperDescriptionPlacement {
  const HyperDescriptionPlacement(this.item, this.span, this.width);
  final HyperDescriptionItem item;
  final int span;
  final double width;
}
