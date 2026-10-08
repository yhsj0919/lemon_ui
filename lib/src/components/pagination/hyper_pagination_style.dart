import 'package:flutter/material.dart';

import '../button/hyper_button_style.dart';

@immutable
final class HyperPaginationStyle {
  const HyperPaginationStyle({
    this.buttonStyle,
    this.selectedStyle,
    this.navigationStyle,
    this.spacing,
    this.runSpacing,
    this.ellipsisStyle,
    this.ellipsis,
    this.previousLabel,
    this.nextLabel,
    this.firstLabel,
    this.lastLabel,
    this.previousIcon,
    this.nextIcon,
    this.firstIcon,
    this.lastIcon,
  });
  final HyperButtonStyle? buttonStyle;
  final HyperButtonStyle? selectedStyle;
  final HyperButtonStyle? navigationStyle;
  final double? spacing;
  final double? runSpacing;
  final TextStyle? ellipsisStyle;
  final String? ellipsis;
  final String? previousLabel;
  final String? nextLabel;
  final String? firstLabel;
  final String? lastLabel;
  final IconData? previousIcon;
  final IconData? nextIcon;
  final IconData? firstIcon;
  final IconData? lastIcon;
  HyperPaginationStyle copyWith({
    HyperButtonStyle? buttonStyle,
    HyperButtonStyle? selectedStyle,
    HyperButtonStyle? navigationStyle,
    double? spacing,
    double? runSpacing,
    TextStyle? ellipsisStyle,
    String? ellipsis,
    String? previousLabel,
    String? nextLabel,
    String? firstLabel,
    String? lastLabel,
    IconData? previousIcon,
    IconData? nextIcon,
    IconData? firstIcon,
    IconData? lastIcon,
  }) => HyperPaginationStyle(
    buttonStyle: buttonStyle ?? this.buttonStyle,
    selectedStyle: selectedStyle ?? this.selectedStyle,
    navigationStyle: navigationStyle ?? this.navigationStyle,
    spacing: spacing ?? this.spacing,
    runSpacing: runSpacing ?? this.runSpacing,
    ellipsisStyle: ellipsisStyle ?? this.ellipsisStyle,
    ellipsis: ellipsis ?? this.ellipsis,
    previousLabel: previousLabel ?? this.previousLabel,
    nextLabel: nextLabel ?? this.nextLabel,
    firstLabel: firstLabel ?? this.firstLabel,
    lastLabel: lastLabel ?? this.lastLabel,
    previousIcon: previousIcon ?? this.previousIcon,
    nextIcon: nextIcon ?? this.nextIcon,
    firstIcon: firstIcon ?? this.firstIcon,
    lastIcon: lastIcon ?? this.lastIcon,
  );
  HyperPaginationStyle merge(HyperPaginationStyle? other) => other == null
      ? this
      : HyperPaginationStyle(
          buttonStyle:
              buttonStyle?.merge(other.buttonStyle) ?? other.buttonStyle,
          selectedStyle:
              selectedStyle?.merge(other.selectedStyle) ?? other.selectedStyle,
          navigationStyle:
              navigationStyle?.merge(other.navigationStyle) ??
              other.navigationStyle,
          spacing: other.spacing ?? spacing,
          runSpacing: other.runSpacing ?? runSpacing,
          ellipsisStyle:
              ellipsisStyle?.merge(other.ellipsisStyle) ?? other.ellipsisStyle,
          ellipsis: other.ellipsis ?? ellipsis,
          previousLabel: other.previousLabel ?? previousLabel,
          nextLabel: other.nextLabel ?? nextLabel,
          firstLabel: other.firstLabel ?? firstLabel,
          lastLabel: other.lastLabel ?? lastLabel,
          previousIcon: other.previousIcon ?? previousIcon,
          nextIcon: other.nextIcon ?? nextIcon,
          firstIcon: other.firstIcon ?? firstIcon,
          lastIcon: other.lastIcon ?? lastIcon,
        );
  static HyperPaginationStyle lerp(
    HyperPaginationStyle a,
    HyperPaginationStyle b,
    double t,
  ) {
    if (t == 0) {
      return a;
    }
    if (t == 1) {
      return b;
    }
    return HyperPaginationStyle(
      buttonStyle: a.buttonStyle == null || b.buttonStyle == null
          ? (t < .5 ? a.buttonStyle : b.buttonStyle)
          : HyperButtonStyle.lerp(a.buttonStyle!, b.buttonStyle!, t),
      selectedStyle: a.selectedStyle == null || b.selectedStyle == null
          ? (t < .5 ? a.selectedStyle : b.selectedStyle)
          : HyperButtonStyle.lerp(a.selectedStyle!, b.selectedStyle!, t),
      navigationStyle: a.navigationStyle == null || b.navigationStyle == null
          ? (t < .5 ? a.navigationStyle : b.navigationStyle)
          : HyperButtonStyle.lerp(a.navigationStyle!, b.navigationStyle!, t),
      spacing: a.spacing == null || b.spacing == null
          ? (t < .5 ? a.spacing : b.spacing)
          : a.spacing! + (b.spacing! - a.spacing!) * t,
      runSpacing: a.runSpacing == null || b.runSpacing == null
          ? (t < .5 ? a.runSpacing : b.runSpacing)
          : a.runSpacing! + (b.runSpacing! - a.runSpacing!) * t,
      ellipsisStyle: TextStyle.lerp(a.ellipsisStyle, b.ellipsisStyle, t),
      ellipsis: t < .5 ? a.ellipsis : b.ellipsis,
      previousLabel: t < .5 ? a.previousLabel : b.previousLabel,
      nextLabel: t < .5 ? a.nextLabel : b.nextLabel,
      firstLabel: t < .5 ? a.firstLabel : b.firstLabel,
      lastLabel: t < .5 ? a.lastLabel : b.lastLabel,
      previousIcon: t < .5 ? a.previousIcon : b.previousIcon,
      nextIcon: t < .5 ? a.nextIcon : b.nextIcon,
      firstIcon: t < .5 ? a.firstIcon : b.firstIcon,
      lastIcon: t < .5 ? a.lastIcon : b.lastIcon,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperPaginationStyle &&
      buttonStyle == other.buttonStyle &&
      selectedStyle == other.selectedStyle &&
      navigationStyle == other.navigationStyle &&
      spacing == other.spacing &&
      runSpacing == other.runSpacing &&
      ellipsisStyle == other.ellipsisStyle &&
      ellipsis == other.ellipsis &&
      previousLabel == other.previousLabel &&
      nextLabel == other.nextLabel &&
      firstLabel == other.firstLabel &&
      lastLabel == other.lastLabel &&
      previousIcon == other.previousIcon &&
      nextIcon == other.nextIcon &&
      firstIcon == other.firstIcon &&
      lastIcon == other.lastIcon;
  @override
  int get hashCode => Object.hashAll([
    buttonStyle,
    selectedStyle,
    navigationStyle,
    spacing,
    runSpacing,
    ellipsisStyle,
    ellipsis,
    previousLabel,
    nextLabel,
    firstLabel,
    lastLabel,
    previousIcon,
    nextIcon,
    firstIcon,
    lastIcon,
  ]);
}
