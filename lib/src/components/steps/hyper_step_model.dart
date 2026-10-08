import 'package:flutter/widgets.dart';

import 'hyper_step_style.dart';

enum HyperStepStatus { pending, current, completed, error, disabled }

@immutable
final class HyperStepItem {
  const HyperStepItem({
    required this.id,
    required this.title,
    this.description,
    this.icon,
    this.status,
    this.enabled = true,
    this.semanticLabel,
    this.style,
  });
  final Object id;
  final Widget title;
  final Widget? description, icon;
  final HyperStepStatus? status;
  final bool enabled;
  final String? semanticLabel;
  final HyperStepStyle? style;
}

/// currentStep 从 0 开始；等于 items.length 表示全部完成。
final class HyperStepModel {
  HyperStepModel({
    required Iterable<HyperStepItem> items,
    required this.currentStep,
  }) : items = List.unmodifiable(items) {
    if (currentStep < 0 || currentStep > this.items.length) {
      throw RangeError.range(currentStep, 0, this.items.length, 'currentStep');
    }
    final ids = <Object>{};
    for (final item in this.items) {
      if (!ids.add(item.id)) {
        throw ArgumentError.value(item.id, 'id', '步骤 id 必须唯一');
      }
    }
  }
  final List<HyperStepItem> items;
  final int currentStep;
  HyperStepStatus statusAt(int index) {
    final item = items[index];
    if (!item.enabled) {
      return HyperStepStatus.disabled;
    }
    return item.status ??
        (index < currentStep
            ? HyperStepStatus.completed
            : index == currentStep
            ? HyperStepStatus.current
            : HyperStepStatus.pending);
  }

  bool canSelect(int index) =>
      index >= 0 &&
      index < items.length &&
      index != currentStep &&
      statusAt(index) != HyperStepStatus.disabled;
}
