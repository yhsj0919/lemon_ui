import 'package:flutter/widgets.dart';

import '../button/hyper_button_style.dart';
import '../widget_group/hyper_widget_group_style.dart';

/// 复用按钮与分组的强类型视觉词汇，不复制设备尺寸。
@immutable
final class HyperSegmentedButtonStyle {
  const HyperSegmentedButtonStyle({
    this.group = const HyperWidgetGroupStyle(),
    this.button,
    this.selectedButton,
  });
  final HyperWidgetGroupStyle group;
  final HyperButtonStyle? button;
  final HyperButtonStyle? selectedButton;
  HyperSegmentedButtonStyle copyWith({
    HyperWidgetGroupStyle? group,
    HyperButtonStyle? button,
    HyperButtonStyle? selectedButton,
  }) => HyperSegmentedButtonStyle(
    group: group ?? this.group,
    button: button ?? this.button,
    selectedButton: selectedButton ?? this.selectedButton,
  );
  HyperSegmentedButtonStyle merge(HyperSegmentedButtonStyle? other) =>
      other == null
      ? this
      : HyperSegmentedButtonStyle(
          group: group.merge(other.group),
          button: button?.merge(other.button) ?? other.button,
          selectedButton:
              selectedButton?.merge(other.selectedButton) ??
              other.selectedButton,
        );
  static HyperSegmentedButtonStyle lerp(
    HyperSegmentedButtonStyle a,
    HyperSegmentedButtonStyle b,
    double t,
  ) {
    if (t == 0 || a == b) return a;
    if (t == 1) return b;
    HyperButtonStyle? blend(HyperButtonStyle? x, HyperButtonStyle? y) =>
        x == null || y == null
        ? (t < .5 ? x : y)
        : HyperButtonStyle.lerp(x, y, t);
    return HyperSegmentedButtonStyle(
      group: HyperWidgetGroupStyle.lerp(a.group, b.group, t),
      button: blend(a.button, b.button),
      selectedButton: blend(a.selectedButton, b.selectedButton),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperSegmentedButtonStyle &&
      group == other.group &&
      button == other.button &&
      selectedButton == other.selectedButton;
  @override
  int get hashCode => Object.hash(group, button, selectedButton);
}
