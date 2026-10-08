import 'package:flutter/widgets.dart';

import 'hyper_collapsible_style.dart';

enum HyperAccordionMode { single, multiple }

@immutable
final class HyperAccordionItem {
  const HyperAccordionItem({
    required this.id,
    required this.header,
    required this.child,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.style,
  });
  final Object id;
  final Widget header, child;
  final Widget? leading, trailing;
  final bool enabled;
  final HyperCollapsibleStyle? style;
}

/// 纯受控展开规则；不保存状态、不回写调用方集合。
final class HyperAccordionSelection {
  HyperAccordionSelection({
    required Iterable<HyperAccordionItem> items,
    required Set<Object> expandedIds,
    required this.mode,
  }) {
    final known = <Object>{};
    final enabledIds = <Object>{};
    for (final item in items) {
      if (!known.add(item.id)) {
        throw ArgumentError.value(item.id, 'id', '手风琴 id 必须唯一');
      }
      if (item.enabled) {
        enabledIds.add(item.id);
      }
    }
    _enabled = Set.unmodifiable(enabledIds);
    expanded = Set.unmodifiable(expandedIds.where(known.contains));
    if (mode == HyperAccordionMode.single && expanded.length > 1) {
      throw ArgumentError.value(expandedIds, 'expandedIds', '单项模式最多展开一项');
    }
  }
  final HyperAccordionMode mode;
  late final Set<Object> _enabled, expanded;
  Set<Object> toggle(Object id) {
    if (!_enabled.contains(id)) {
      return expanded;
    }
    if (expanded.contains(id)) {
      return Set.unmodifiable({...expanded}..remove(id));
    }
    return Set.unmodifiable(
      mode == HyperAccordionMode.single ? {id} : {...expanded, id},
    );
  }
}
