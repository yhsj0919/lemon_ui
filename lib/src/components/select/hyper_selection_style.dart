import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

import '../menu/hyper_menu_style.dart';
import '../card/hyper_card_style.dart';
import '../chip/hyper_chip_style.dart';
import '../text_field/hyper_text_field_style.dart';
import '../overlay/hyper_anchored_overlay.dart';
import 'hyper_select_model.dart';

@immutable
final class HyperSelectionStyle {
  const HyperSelectionStyle({
    this.menuStyle,
    this.surfaceStyle,
    this.chipStyle,
    this.searchStyle,
    this.inputStyle,
    this.width,
    this.maxPanelHeight,
    this.chipSpacing,
    this.minimumInputWidth,
    this.searchDebounce,
    this.duration,
    this.curve,
    this.checkIcon,
    this.clearIcon,
    this.searchHint,
    this.loadingText,
    this.emptyText,
    this.errorText,
    this.retryText,
    this.loadMoreText,
    this.doneText,
    this.clearText,
    this.presentation,
    this.transitionBuilder,
    this.feedbackTransitionBuilder,
  });
  final HyperMenuStyle? menuStyle;
  final HyperCardStyle? surfaceStyle;
  final HyperChipStyle? chipStyle;
  final HyperTextFieldStyle? searchStyle;
  final HyperTextFieldStyle? inputStyle;
  final double? width;
  final double? maxPanelHeight;
  final double? chipSpacing;
  final double? minimumInputWidth;
  final Duration? searchDebounce;
  final Duration? duration;
  final Curve? curve;
  final IconData? checkIcon;
  final IconData? clearIcon;
  final String? searchHint;
  final String? loadingText;
  final String? emptyText;
  final String? errorText;
  final String? retryText;
  final String? loadMoreText;
  final String? doneText;
  final String? clearText;
  final HyperSelectPresentation? presentation;
  final HyperOverlayTransitionBuilder? transitionBuilder;
  final AnimatedSwitcherTransitionBuilder? feedbackTransitionBuilder;
  HyperSelectionStyle copyWith({
    HyperMenuStyle? menuStyle,
    HyperCardStyle? surfaceStyle,
    HyperChipStyle? chipStyle,
    HyperTextFieldStyle? searchStyle,
    HyperTextFieldStyle? inputStyle,
    double? width,
    double? maxPanelHeight,
    double? chipSpacing,
    double? minimumInputWidth,
    Duration? searchDebounce,
    Duration? duration,
    Curve? curve,
    IconData? checkIcon,
    IconData? clearIcon,
    String? searchHint,
    String? loadingText,
    String? emptyText,
    String? errorText,
    String? retryText,
    String? loadMoreText,
    String? doneText,
    String? clearText,
    HyperSelectPresentation? presentation,
    HyperOverlayTransitionBuilder? transitionBuilder,
    AnimatedSwitcherTransitionBuilder? feedbackTransitionBuilder,
  }) => HyperSelectionStyle(
    menuStyle: menuStyle ?? this.menuStyle,
    surfaceStyle: surfaceStyle ?? this.surfaceStyle,
    chipStyle: chipStyle ?? this.chipStyle,
    searchStyle: searchStyle ?? this.searchStyle,
    inputStyle: inputStyle ?? this.inputStyle,
    width: width ?? this.width,
    maxPanelHeight: maxPanelHeight ?? this.maxPanelHeight,
    chipSpacing: chipSpacing ?? this.chipSpacing,
    minimumInputWidth: minimumInputWidth ?? this.minimumInputWidth,
    searchDebounce: searchDebounce ?? this.searchDebounce,
    duration: duration ?? this.duration,
    curve: curve ?? this.curve,
    checkIcon: checkIcon ?? this.checkIcon,
    clearIcon: clearIcon ?? this.clearIcon,
    searchHint: searchHint ?? this.searchHint,
    loadingText: loadingText ?? this.loadingText,
    emptyText: emptyText ?? this.emptyText,
    errorText: errorText ?? this.errorText,
    retryText: retryText ?? this.retryText,
    loadMoreText: loadMoreText ?? this.loadMoreText,
    doneText: doneText ?? this.doneText,
    clearText: clearText ?? this.clearText,
    presentation: presentation ?? this.presentation,
    transitionBuilder: transitionBuilder ?? this.transitionBuilder,
    feedbackTransitionBuilder:
        feedbackTransitionBuilder ?? this.feedbackTransitionBuilder,
  );
  HyperSelectionStyle merge(HyperSelectionStyle? other) => other == null
      ? this
      : HyperSelectionStyle(
          menuStyle: menuStyle?.merge(other.menuStyle) ?? other.menuStyle,
          surfaceStyle:
              surfaceStyle?.merge(other.surfaceStyle) ?? other.surfaceStyle,
          chipStyle: chipStyle?.merge(other.chipStyle) ?? other.chipStyle,
          searchStyle:
              searchStyle?.merge(other.searchStyle) ?? other.searchStyle,
          inputStyle: inputStyle?.merge(other.inputStyle) ?? other.inputStyle,
          width: other.width ?? width,
          maxPanelHeight: other.maxPanelHeight ?? maxPanelHeight,
          chipSpacing: other.chipSpacing ?? chipSpacing,
          minimumInputWidth: other.minimumInputWidth ?? minimumInputWidth,
          searchDebounce: other.searchDebounce ?? searchDebounce,
          duration: other.duration ?? duration,
          curve: other.curve ?? curve,
          checkIcon: other.checkIcon ?? checkIcon,
          clearIcon: other.clearIcon ?? clearIcon,
          searchHint: other.searchHint ?? searchHint,
          loadingText: other.loadingText ?? loadingText,
          emptyText: other.emptyText ?? emptyText,
          errorText: other.errorText ?? errorText,
          retryText: other.retryText ?? retryText,
          loadMoreText: other.loadMoreText ?? loadMoreText,
          doneText: other.doneText ?? doneText,
          clearText: other.clearText ?? clearText,
          presentation: other.presentation ?? presentation,
          transitionBuilder: other.transitionBuilder ?? transitionBuilder,
          feedbackTransitionBuilder:
              other.feedbackTransitionBuilder ?? feedbackTransitionBuilder,
        );
  static HyperSelectionStyle lerp(
    HyperSelectionStyle a,
    HyperSelectionStyle b,
    double t,
  ) => t == 0
      ? a
      : t == 1
      ? b
      : HyperSelectionStyle(
          menuStyle: a.menuStyle == null || b.menuStyle == null
              ? (t < .5 ? a.menuStyle : b.menuStyle)
              : HyperMenuStyle.lerp(a.menuStyle!, b.menuStyle!, t),
          surfaceStyle: a.surfaceStyle == null || b.surfaceStyle == null
              ? (t < .5 ? a.surfaceStyle : b.surfaceStyle)
              : HyperCardStyle.lerp(a.surfaceStyle!, b.surfaceStyle!, t),
          chipStyle: a.chipStyle == null || b.chipStyle == null
              ? (t < .5 ? a.chipStyle : b.chipStyle)
              : HyperChipStyle.lerp(a.chipStyle!, b.chipStyle!, t),
          searchStyle: a.searchStyle == null || b.searchStyle == null
              ? (t < .5 ? a.searchStyle : b.searchStyle)
              : HyperTextFieldStyle.lerp(a.searchStyle!, b.searchStyle!, t),
          inputStyle: a.inputStyle == null || b.inputStyle == null
              ? (t < .5 ? a.inputStyle : b.inputStyle)
              : HyperTextFieldStyle.lerp(a.inputStyle!, b.inputStyle!, t),
          width: lerpDouble(a.width, b.width, t),
          maxPanelHeight: lerpDouble(a.maxPanelHeight, b.maxPanelHeight, t),
          chipSpacing: lerpDouble(a.chipSpacing, b.chipSpacing, t),
          minimumInputWidth: lerpDouble(
            a.minimumInputWidth,
            b.minimumInputWidth,
            t,
          ),
          searchDebounce: a.searchDebounce == null || b.searchDebounce == null
              ? (t < .5 ? a.searchDebounce : b.searchDebounce)
              : Duration(
                  microseconds:
                      (a.searchDebounce!.inMicroseconds +
                              (b.searchDebounce!.inMicroseconds -
                                      a.searchDebounce!.inMicroseconds) *
                                  t)
                          .round(),
                ),
          duration: a.duration == null || b.duration == null
              ? (t < .5 ? a.duration : b.duration)
              : Duration(
                  microseconds:
                      (a.duration!.inMicroseconds +
                              (b.duration!.inMicroseconds -
                                      a.duration!.inMicroseconds) *
                                  t)
                          .round(),
                ),
          curve: t < .5 ? a.curve : b.curve,
          checkIcon: t < .5 ? a.checkIcon : b.checkIcon,
          clearIcon: t < .5 ? a.clearIcon : b.clearIcon,
          searchHint: t < .5 ? a.searchHint : b.searchHint,
          loadingText: t < .5 ? a.loadingText : b.loadingText,
          emptyText: t < .5 ? a.emptyText : b.emptyText,
          errorText: t < .5 ? a.errorText : b.errorText,
          retryText: t < .5 ? a.retryText : b.retryText,
          loadMoreText: t < .5 ? a.loadMoreText : b.loadMoreText,
          doneText: t < .5 ? a.doneText : b.doneText,
          clearText: t < .5 ? a.clearText : b.clearText,
          presentation: t < .5 ? a.presentation : b.presentation,
          transitionBuilder: t < .5 ? a.transitionBuilder : b.transitionBuilder,
          feedbackTransitionBuilder: t < .5
              ? a.feedbackTransitionBuilder
              : b.feedbackTransitionBuilder,
        );
  @override
  bool operator ==(Object other) =>
      other is HyperSelectionStyle &&
      menuStyle == other.menuStyle &&
      surfaceStyle == other.surfaceStyle &&
      chipStyle == other.chipStyle &&
      searchStyle == other.searchStyle &&
      inputStyle == other.inputStyle &&
      width == other.width &&
      maxPanelHeight == other.maxPanelHeight &&
      chipSpacing == other.chipSpacing &&
      minimumInputWidth == other.minimumInputWidth &&
      searchDebounce == other.searchDebounce &&
      duration == other.duration &&
      curve == other.curve &&
      checkIcon == other.checkIcon &&
      clearIcon == other.clearIcon &&
      searchHint == other.searchHint &&
      loadingText == other.loadingText &&
      emptyText == other.emptyText &&
      errorText == other.errorText &&
      retryText == other.retryText &&
      loadMoreText == other.loadMoreText &&
      doneText == other.doneText &&
      clearText == other.clearText &&
      presentation == other.presentation &&
      transitionBuilder == other.transitionBuilder &&
      feedbackTransitionBuilder == other.feedbackTransitionBuilder;
  @override
  int get hashCode => Object.hashAll([
    menuStyle,
    surfaceStyle,
    chipStyle,
    searchStyle,
    inputStyle,
    width,
    maxPanelHeight,
    chipSpacing,
    minimumInputWidth,
    searchDebounce,
    duration,
    curve,
    checkIcon,
    clearIcon,
    searchHint,
    loadingText,
    emptyText,
    errorText,
    retryText,
    loadMoreText,
    doneText,
    clearText,
    presentation,
    transitionBuilder,
    feedbackTransitionBuilder,
  ]);
}
