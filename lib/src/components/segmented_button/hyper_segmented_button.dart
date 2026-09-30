import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../theme/core/hyper_theme.dart';
import '../button/hyper_button.dart';
import '../button/hyper_button_style.dart';
import '../widget_group/hyper_widget_group.dart';
import 'hyper_segmented_button_style.dart';
import 'hyper_segmented_button_theme.dart';

@immutable
class HyperSegment<T> {
  const HyperSegment({
    required this.value,
    required this.label,
    this.icon,
    this.enabled = true,
    this.width,
    this.flex,
  }) : assert(width == null || width > 0),
       assert(flex == null || flex > 0),
       assert(width == null || flex == null);
  final T value;
  final String label;
  final Widget? icon;
  final bool enabled;
  final double? width;
  final int? flex;
}

/// 受控分段选择；默认单选且不允许清空。回调不会修改传入集合。
class HyperSegmentedButton<T> extends StatelessWidget {
  HyperSegmentedButton({
    super.key,
    required List<HyperSegment<T>> segments,
    required Set<T> selected,
    this.onSelectionChanged,
    this.multiSelectionEnabled = false,
    this.emptySelectionAllowed = false,
    this.enabled = true,
    this.expanded = false,
    this.direction = Axis.horizontal,
    this.showSeparators = true,
    this.style,
  }) : segments = List.unmodifiable(segments),
       selected = Set.unmodifiable(selected) {
    assert(segments.isNotEmpty);
    assert(segments.map((e) => e.value).toSet().length == segments.length);
    assert(selected.every((value) => segments.any((e) => e.value == value)));
    assert(multiSelectionEnabled || selected.length <= 1);
    assert(emptySelectionAllowed || selected.isNotEmpty);
    assert(direction == Axis.horizontal || !expanded);
  }
  final List<HyperSegment<T>> segments;
  final Set<T> selected;
  final ValueChanged<Set<T>>? onSelectionChanged;
  final bool multiSelectionEnabled, emptySelectionAllowed, enabled, expanded;
  final Axis direction;
  final bool showSeparators;
  final HyperSegmentedButtonStyle? style;

  /// 返回合法的新集合；无变化或禁用时不发出回调。
  void select(T value) {
    if (!enabled || onSelectionChanged == null) return;
    final item = segments.where((e) => e.value == value).firstOrNull;
    if (item == null || !item.enabled) return;
    final next = Set<T>.of(selected);
    if (next.contains(value)) {
      if (!multiSelectionEnabled && !emptySelectionAllowed) return;
      next.remove(value);
      if (next.isEmpty && !emptySelectionAllowed) return;
    } else {
      if (!multiSelectionEnabled) next.clear();
      next.add(value);
    }
    onSelectionChanged!(Set.unmodifiable(next));
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final resolved = HyperSegmentedButtonTheme.of(context).style.merge(style);
    final normal = HyperButtonStyle(
      background: const HyperFill.none(),
      foregroundColor: theme.colors.textPrimary,
      alignment: Alignment.center,
    ).merge(resolved.button);
    final active = normal
        .merge(
          HyperButtonStyle(
            background: HyperFill.color(theme.colors.surfaceMuted),
            foregroundColor: theme.colors.textPrimary,
          ),
        )
        .merge(resolved.selectedButton);
    Widget group = HyperWidgetGroup(
      connected: true,
      direction: direction,
      showSeparators: showSeparators,
      style: resolved.group,
      children: [
        for (final item in segments)
          HyperWidgetGroupItem(
            width: item.width,
            flex: direction == Axis.horizontal
                ? item.flex ?? (expanded ? 1 : null)
                : null,
            child: Semantics(
              selected: selected.contains(item.value),
              inMutuallyExclusiveGroup: !multiSelectionEnabled,
              child: HyperButton.ghost(
                label: Text(item.label),
                icon: item.icon,
                style: selected.contains(item.value) ? active : normal,
                onPressed: enabled && item.enabled && onSelectionChanged != null
                    ? () => select(item.value)
                    : null,
              ),
            ),
          ),
      ],
    );
    if (direction == Axis.vertical) {
      group = IntrinsicWidth(child: group);
    }
    return group;
  }
}
