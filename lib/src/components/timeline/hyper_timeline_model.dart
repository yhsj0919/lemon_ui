import 'package:flutter/widgets.dart';

import 'hyper_timeline_style.dart';

enum HyperTimelineStatus { normal, active, success, warning, error, disabled }

/// start/end 是逻辑方向，会遵守 Directionality。
enum HyperTimelineAlignment { start, end, alternate }

@immutable
final class HyperTimelineItem {
  const HyperTimelineItem({
    required this.id,
    required this.title,
    this.content,
    this.time,
    this.node,
    this.opposite,
    this.status = HyperTimelineStatus.normal,
    this.semanticLabel,
    this.style,
  });
  final Object id;
  final Widget title;
  final Widget? content, time, node, opposite;
  final HyperTimelineStatus status;
  final String? semanticLabel;
  final HyperTimelineStyle? style;
}

final class HyperTimelineModel {
  HyperTimelineModel(Iterable<HyperTimelineItem> source, {this.reverse = false})
    : items = List.unmodifiable(reverse ? source.toList().reversed : source) {
    final ids = <Object>{};
    for (final item in items) {
      if (!ids.add(item.id)) {
        throw ArgumentError.value(item.id, 'id', '时间线 id 必须唯一');
      }
    }
  }
  final List<HyperTimelineItem> items;
  final bool reverse;
  bool hasOppositeColumn(HyperTimelineAlignment alignment) =>
      alignment == HyperTimelineAlignment.alternate ||
      items.any((item) => item.opposite != null);
  bool contentAtStart(int index, HyperTimelineAlignment alignment) =>
      switch (alignment) {
        HyperTimelineAlignment.start => false,
        HyperTimelineAlignment.end => true,
        HyperTimelineAlignment.alternate => index.isOdd,
      };
}
