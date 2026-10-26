import 'package:flutter/material.dart';

import '../card/hyper_card_style.dart';
import '../overlay/hyper_anchored_overlay.dart';
import 'hyper_sidebar_model.dart';

/// 侧栏当前作用域的视觉和尺寸覆盖；空字段继续继承主题。
@immutable
final class HyperSidebarStyle {
  const HyperSidebarStyle({
    this.width,
    this.collapsedWidth,
    this.itemHeight,
    this.iconSize,
    this.expandIconSize,
    this.collapsedIconSize,
    this.collapsedRowGap,
    this.iconColor,
    this.selectedIconColor,
    this.ancestorSelectedIconColor,
    this.disabledIconColor,
    this.expandIconColor,
    this.selectedExpandIconColor,
    this.ancestorSelectedExpandIconColor,
    this.disabledExpandIconColor,
    this.itemSpacing,
    this.rowGap,
    this.indent,
    this.sectionSpacing,
    this.horizontalPadding,
    this.verticalPadding,
    this.popupWidth,
    this.itemRadius,
    this.backgroundColor,
    this.borderColor,
    this.foregroundColor,
    this.selectedForegroundColor,
    this.selectedBackgroundColor,
    this.ancestorSelectedForegroundColor,
    this.ancestorSelectedBackgroundColor,
    this.disabledColor,
    this.groupTitleStyle,
    this.itemTextStyle,
    this.descriptionTextStyle,
    this.selectionStyle,
    this.popupCardStyle,
    this.disabledItemSurfaceStyle,
    this.ancestorItemSurfaceStyle,
    this.selectedItemSurfaceStyle,
    this.itemSurfaceStyle,
    this.surfaceStyle,
    this.widthTransitionBuilder,
    this.contentTransitionBuilder,
    this.childrenTransitionBuilder,
    this.popupTransitionBuilder,
  });

  final double? width;
  final double? collapsedWidth;
  final double? itemHeight;
  final double? iconSize;
  final double? expandIconSize;
  final double? collapsedIconSize;
  final double? collapsedRowGap;
  final Color? iconColor;
  final Color? selectedIconColor;
  final Color? ancestorSelectedIconColor;
  final Color? disabledIconColor;
  final Color? expandIconColor;
  final Color? selectedExpandIconColor;
  final Color? ancestorSelectedExpandIconColor;
  final Color? disabledExpandIconColor;
  final double? itemSpacing;
  final double? rowGap;
  final double? indent;
  final double? sectionSpacing;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? popupWidth;
  final double? itemRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final Color? foregroundColor;
  final Color? selectedForegroundColor;
  final Color? selectedBackgroundColor;
  final Color? ancestorSelectedForegroundColor;
  final Color? ancestorSelectedBackgroundColor;
  final Color? disabledColor;
  final TextStyle? groupTitleStyle;
  final TextStyle? itemTextStyle;
  final TextStyle? descriptionTextStyle;
  final HyperSidebarSelectionStyle? selectionStyle;

  /// 折叠子菜单的卡片样式；阴影等视觉配置由侧栏消费者决定。
  final HyperCardStyle? popupCardStyle;
  final HyperCardStyle? disabledItemSurfaceStyle;
  final HyperCardStyle? ancestorItemSurfaceStyle;
  final HyperCardStyle? selectedItemSurfaceStyle;
  final HyperCardStyle? itemSurfaceStyle;
  final HyperCardStyle? surfaceStyle;

  /// 自定义宽度过渡的布局；需根据传入宽度约束侧栏内容。
  final HyperSidebarWidthTransitionBuilder? widthTransitionBuilder;

  /// 自定义展开态与折叠态内容切换的视觉效果。
  final HyperSidebarContentTransitionBuilder? contentTransitionBuilder;

  /// 自定义树形子项的展开收起效果，并负责过渡期间的布局尺寸。
  final HyperSidebarChildrenTransitionBuilder? childrenTransitionBuilder;

  /// 自定义折叠态子菜单浮窗的进出场效果。
  final HyperOverlayTransitionBuilder? popupTransitionBuilder;

  HyperSidebarStyle copyWith({
    double? width,
    double? collapsedWidth,
    double? itemHeight,
    double? iconSize,
    double? expandIconSize,
    double? collapsedIconSize,
    double? collapsedRowGap,
    Color? iconColor,
    Color? selectedIconColor,
    Color? ancestorSelectedIconColor,
    Color? disabledIconColor,
    Color? expandIconColor,
    Color? selectedExpandIconColor,
    Color? ancestorSelectedExpandIconColor,
    Color? disabledExpandIconColor,
    double? itemSpacing,
    double? rowGap,
    double? indent,
    double? sectionSpacing,
    double? horizontalPadding,
    double? verticalPadding,
    double? popupWidth,
    double? itemRadius,
    Color? backgroundColor,
    Color? borderColor,
    Color? foregroundColor,
    Color? selectedForegroundColor,
    Color? selectedBackgroundColor,
    Color? ancestorSelectedForegroundColor,
    Color? ancestorSelectedBackgroundColor,
    Color? disabledColor,
    TextStyle? groupTitleStyle,
    TextStyle? itemTextStyle,
    TextStyle? descriptionTextStyle,
    HyperSidebarSelectionStyle? selectionStyle,
    HyperCardStyle? popupCardStyle,
    HyperCardStyle? disabledItemSurfaceStyle,
    HyperCardStyle? ancestorItemSurfaceStyle,
    HyperCardStyle? selectedItemSurfaceStyle,
    HyperCardStyle? itemSurfaceStyle,
    HyperCardStyle? surfaceStyle,
    HyperSidebarWidthTransitionBuilder? widthTransitionBuilder,
    HyperSidebarContentTransitionBuilder? contentTransitionBuilder,
    HyperSidebarChildrenTransitionBuilder? childrenTransitionBuilder,
    HyperOverlayTransitionBuilder? popupTransitionBuilder,
  }) => HyperSidebarStyle(
    width: width ?? this.width,
    collapsedWidth: collapsedWidth ?? this.collapsedWidth,
    itemHeight: itemHeight ?? this.itemHeight,
    iconSize: iconSize ?? this.iconSize,
    expandIconSize: expandIconSize ?? this.expandIconSize,
    collapsedIconSize: collapsedIconSize ?? this.collapsedIconSize,
    collapsedRowGap: collapsedRowGap ?? this.collapsedRowGap,
    iconColor: iconColor ?? this.iconColor,
    selectedIconColor: selectedIconColor ?? this.selectedIconColor,
    ancestorSelectedIconColor:
        ancestorSelectedIconColor ?? this.ancestorSelectedIconColor,
    disabledIconColor: disabledIconColor ?? this.disabledIconColor,
    expandIconColor: expandIconColor ?? this.expandIconColor,
    selectedExpandIconColor:
        selectedExpandIconColor ?? this.selectedExpandIconColor,
    ancestorSelectedExpandIconColor:
        ancestorSelectedExpandIconColor ?? this.ancestorSelectedExpandIconColor,
    disabledExpandIconColor:
        disabledExpandIconColor ?? this.disabledExpandIconColor,
    itemSpacing: itemSpacing ?? this.itemSpacing,
    rowGap: rowGap ?? this.rowGap,
    indent: indent ?? this.indent,
    sectionSpacing: sectionSpacing ?? this.sectionSpacing,
    horizontalPadding: horizontalPadding ?? this.horizontalPadding,
    verticalPadding: verticalPadding ?? this.verticalPadding,
    popupWidth: popupWidth ?? this.popupWidth,
    itemRadius: itemRadius ?? this.itemRadius,
    backgroundColor: backgroundColor ?? this.backgroundColor,
    borderColor: borderColor ?? this.borderColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    selectedForegroundColor:
        selectedForegroundColor ?? this.selectedForegroundColor,
    selectedBackgroundColor:
        selectedBackgroundColor ?? this.selectedBackgroundColor,
    ancestorSelectedForegroundColor:
        ancestorSelectedForegroundColor ?? this.ancestorSelectedForegroundColor,
    ancestorSelectedBackgroundColor:
        ancestorSelectedBackgroundColor ?? this.ancestorSelectedBackgroundColor,
    disabledColor: disabledColor ?? this.disabledColor,
    groupTitleStyle: groupTitleStyle ?? this.groupTitleStyle,
    itemTextStyle: itemTextStyle ?? this.itemTextStyle,
    descriptionTextStyle: descriptionTextStyle ?? this.descriptionTextStyle,
    selectionStyle: selectionStyle ?? this.selectionStyle,
    popupCardStyle: popupCardStyle ?? this.popupCardStyle,
    disabledItemSurfaceStyle:
        disabledItemSurfaceStyle ?? this.disabledItemSurfaceStyle,
    ancestorItemSurfaceStyle:
        ancestorItemSurfaceStyle ?? this.ancestorItemSurfaceStyle,
    selectedItemSurfaceStyle:
        selectedItemSurfaceStyle ?? this.selectedItemSurfaceStyle,
    itemSurfaceStyle: itemSurfaceStyle ?? this.itemSurfaceStyle,
    surfaceStyle: surfaceStyle ?? this.surfaceStyle,
    widthTransitionBuilder:
        widthTransitionBuilder ?? this.widthTransitionBuilder,
    contentTransitionBuilder:
        contentTransitionBuilder ?? this.contentTransitionBuilder,
    childrenTransitionBuilder:
        childrenTransitionBuilder ?? this.childrenTransitionBuilder,
    popupTransitionBuilder:
        popupTransitionBuilder ?? this.popupTransitionBuilder,
  );

  HyperSidebarStyle merge(HyperSidebarStyle? other) => other == null
      ? this
      : HyperSidebarStyle(
          width: other.width ?? width,
          collapsedWidth: other.collapsedWidth ?? collapsedWidth,
          itemHeight: other.itemHeight ?? itemHeight,
          iconSize: other.iconSize ?? iconSize,
          expandIconSize: other.expandIconSize ?? expandIconSize,
          collapsedIconSize: other.collapsedIconSize ?? collapsedIconSize,
          collapsedRowGap: other.collapsedRowGap ?? collapsedRowGap,
          iconColor: other.iconColor ?? iconColor,
          selectedIconColor: other.selectedIconColor ?? selectedIconColor,
          ancestorSelectedIconColor:
              other.ancestorSelectedIconColor ?? ancestorSelectedIconColor,
          disabledIconColor: other.disabledIconColor ?? disabledIconColor,
          expandIconColor: other.expandIconColor ?? expandIconColor,
          selectedExpandIconColor:
              other.selectedExpandIconColor ?? selectedExpandIconColor,
          ancestorSelectedExpandIconColor:
              other.ancestorSelectedExpandIconColor ??
              ancestorSelectedExpandIconColor,
          disabledExpandIconColor:
              other.disabledExpandIconColor ?? disabledExpandIconColor,
          itemSpacing: other.itemSpacing ?? itemSpacing,
          rowGap: other.rowGap ?? rowGap,
          indent: other.indent ?? indent,
          sectionSpacing: other.sectionSpacing ?? sectionSpacing,
          horizontalPadding: other.horizontalPadding ?? horizontalPadding,
          verticalPadding: other.verticalPadding ?? verticalPadding,
          popupWidth: other.popupWidth ?? popupWidth,
          itemRadius: other.itemRadius ?? itemRadius,
          backgroundColor: other.backgroundColor ?? backgroundColor,
          borderColor: other.borderColor ?? borderColor,
          foregroundColor: other.foregroundColor ?? foregroundColor,
          selectedForegroundColor:
              other.selectedForegroundColor ?? selectedForegroundColor,
          selectedBackgroundColor:
              other.selectedBackgroundColor ?? selectedBackgroundColor,
          ancestorSelectedForegroundColor:
              other.ancestorSelectedForegroundColor ??
              ancestorSelectedForegroundColor,
          ancestorSelectedBackgroundColor:
              other.ancestorSelectedBackgroundColor ??
              ancestorSelectedBackgroundColor,
          disabledColor: other.disabledColor ?? disabledColor,
          groupTitleStyle: other.groupTitleStyle ?? groupTitleStyle,
          itemTextStyle: other.itemTextStyle ?? itemTextStyle,
          descriptionTextStyle:
              other.descriptionTextStyle ?? descriptionTextStyle,
          selectionStyle: other.selectionStyle ?? selectionStyle,
          surfaceStyle:
              surfaceStyle?.merge(other.surfaceStyle) ?? other.surfaceStyle,
          itemSurfaceStyle:
              itemSurfaceStyle?.merge(other.itemSurfaceStyle) ??
              other.itemSurfaceStyle,
          selectedItemSurfaceStyle:
              selectedItemSurfaceStyle?.merge(other.selectedItemSurfaceStyle) ??
              other.selectedItemSurfaceStyle,
          ancestorItemSurfaceStyle:
              ancestorItemSurfaceStyle?.merge(other.ancestorItemSurfaceStyle) ??
              other.ancestorItemSurfaceStyle,
          disabledItemSurfaceStyle:
              disabledItemSurfaceStyle?.merge(other.disabledItemSurfaceStyle) ??
              other.disabledItemSurfaceStyle,
          popupCardStyle:
              popupCardStyle?.merge(other.popupCardStyle) ??
              other.popupCardStyle,
          widthTransitionBuilder:
              other.widthTransitionBuilder ?? widthTransitionBuilder,
          contentTransitionBuilder:
              other.contentTransitionBuilder ?? contentTransitionBuilder,
          childrenTransitionBuilder:
              other.childrenTransitionBuilder ?? childrenTransitionBuilder,
          popupTransitionBuilder:
              other.popupTransitionBuilder ?? popupTransitionBuilder,
        );

  static HyperSidebarStyle lerp(
    HyperSidebarStyle a,
    HyperSidebarStyle b,
    double t,
  ) {
    if (a == b) {
      return a;
    }
    double? number(double? x, double? y) =>
        x == null || y == null ? (t < .5 ? x : y) : x + (y - x) * t;
    return HyperSidebarStyle(
      width: number(a.width, b.width),
      collapsedWidth: number(a.collapsedWidth, b.collapsedWidth),
      itemHeight: number(a.itemHeight, b.itemHeight),
      iconSize: number(a.iconSize, b.iconSize),
      expandIconSize: number(a.expandIconSize, b.expandIconSize),
      collapsedIconSize: number(a.collapsedIconSize, b.collapsedIconSize),
      collapsedRowGap: number(a.collapsedRowGap, b.collapsedRowGap),
      iconColor: Color.lerp(a.iconColor, b.iconColor, t),
      selectedIconColor: Color.lerp(
        a.selectedIconColor,
        b.selectedIconColor,
        t,
      ),
      ancestorSelectedIconColor: Color.lerp(
        a.ancestorSelectedIconColor,
        b.ancestorSelectedIconColor,
        t,
      ),
      disabledIconColor: Color.lerp(
        a.disabledIconColor,
        b.disabledIconColor,
        t,
      ),
      expandIconColor: Color.lerp(a.expandIconColor, b.expandIconColor, t),
      selectedExpandIconColor: Color.lerp(
        a.selectedExpandIconColor,
        b.selectedExpandIconColor,
        t,
      ),
      ancestorSelectedExpandIconColor: Color.lerp(
        a.ancestorSelectedExpandIconColor,
        b.ancestorSelectedExpandIconColor,
        t,
      ),
      disabledExpandIconColor: Color.lerp(
        a.disabledExpandIconColor,
        b.disabledExpandIconColor,
        t,
      ),
      itemSpacing: number(a.itemSpacing, b.itemSpacing),
      rowGap: number(a.rowGap, b.rowGap),
      indent: number(a.indent, b.indent),
      sectionSpacing: number(a.sectionSpacing, b.sectionSpacing),
      horizontalPadding: number(a.horizontalPadding, b.horizontalPadding),
      verticalPadding: number(a.verticalPadding, b.verticalPadding),
      popupWidth: number(a.popupWidth, b.popupWidth),
      itemRadius: number(a.itemRadius, b.itemRadius),
      backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
      borderColor: Color.lerp(a.borderColor, b.borderColor, t),
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
      selectedForegroundColor: Color.lerp(
        a.selectedForegroundColor,
        b.selectedForegroundColor,
        t,
      ),
      selectedBackgroundColor: Color.lerp(
        a.selectedBackgroundColor,
        b.selectedBackgroundColor,
        t,
      ),
      ancestorSelectedForegroundColor: Color.lerp(
        a.ancestorSelectedForegroundColor,
        b.ancestorSelectedForegroundColor,
        t,
      ),
      ancestorSelectedBackgroundColor: Color.lerp(
        a.ancestorSelectedBackgroundColor,
        b.ancestorSelectedBackgroundColor,
        t,
      ),
      disabledColor: Color.lerp(a.disabledColor, b.disabledColor, t),
      groupTitleStyle: TextStyle.lerp(a.groupTitleStyle, b.groupTitleStyle, t),
      itemTextStyle: TextStyle.lerp(a.itemTextStyle, b.itemTextStyle, t),
      descriptionTextStyle: TextStyle.lerp(
        a.descriptionTextStyle,
        b.descriptionTextStyle,
        t,
      ),
      surfaceStyle: a.surfaceStyle == null || b.surfaceStyle == null
          ? (t < .5 ? a.surfaceStyle : b.surfaceStyle)
          : HyperCardStyle.lerp(a.surfaceStyle!, b.surfaceStyle!, t),
      itemSurfaceStyle: a.itemSurfaceStyle == null || b.itemSurfaceStyle == null
          ? (t < .5 ? a.itemSurfaceStyle : b.itemSurfaceStyle)
          : HyperCardStyle.lerp(a.itemSurfaceStyle!, b.itemSurfaceStyle!, t),
      selectedItemSurfaceStyle:
          a.selectedItemSurfaceStyle == null ||
              b.selectedItemSurfaceStyle == null
          ? (t < .5 ? a.selectedItemSurfaceStyle : b.selectedItemSurfaceStyle)
          : HyperCardStyle.lerp(
              a.selectedItemSurfaceStyle!,
              b.selectedItemSurfaceStyle!,
              t,
            ),
      ancestorItemSurfaceStyle:
          a.ancestorItemSurfaceStyle == null ||
              b.ancestorItemSurfaceStyle == null
          ? (t < .5 ? a.ancestorItemSurfaceStyle : b.ancestorItemSurfaceStyle)
          : HyperCardStyle.lerp(
              a.ancestorItemSurfaceStyle!,
              b.ancestorItemSurfaceStyle!,
              t,
            ),
      disabledItemSurfaceStyle:
          a.disabledItemSurfaceStyle == null ||
              b.disabledItemSurfaceStyle == null
          ? (t < .5 ? a.disabledItemSurfaceStyle : b.disabledItemSurfaceStyle)
          : HyperCardStyle.lerp(
              a.disabledItemSurfaceStyle!,
              b.disabledItemSurfaceStyle!,
              t,
            ),
      selectionStyle: t < .5 ? a.selectionStyle : b.selectionStyle,
      popupCardStyle: a.popupCardStyle == null || b.popupCardStyle == null
          ? (t < .5 ? a.popupCardStyle : b.popupCardStyle)
          : HyperCardStyle.lerp(a.popupCardStyle!, b.popupCardStyle!, t),
      widthTransitionBuilder: t < .5
          ? a.widthTransitionBuilder
          : b.widthTransitionBuilder,
      contentTransitionBuilder: t < .5
          ? a.contentTransitionBuilder
          : b.contentTransitionBuilder,
      childrenTransitionBuilder: t < .5
          ? a.childrenTransitionBuilder
          : b.childrenTransitionBuilder,
      popupTransitionBuilder: t < .5
          ? a.popupTransitionBuilder
          : b.popupTransitionBuilder,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperSidebarStyle &&
          other.width == width &&
          other.collapsedWidth == collapsedWidth &&
          other.itemHeight == itemHeight &&
          other.iconSize == iconSize &&
          other.expandIconSize == expandIconSize &&
          other.collapsedIconSize == collapsedIconSize &&
          other.collapsedRowGap == collapsedRowGap &&
          other.iconColor == iconColor &&
          other.selectedIconColor == selectedIconColor &&
          other.ancestorSelectedIconColor == ancestorSelectedIconColor &&
          other.disabledIconColor == disabledIconColor &&
          other.expandIconColor == expandIconColor &&
          other.selectedExpandIconColor == selectedExpandIconColor &&
          other.ancestorSelectedExpandIconColor ==
              ancestorSelectedExpandIconColor &&
          other.disabledExpandIconColor == disabledExpandIconColor &&
          other.itemSpacing == itemSpacing &&
          other.rowGap == rowGap &&
          other.indent == indent &&
          other.sectionSpacing == sectionSpacing &&
          other.horizontalPadding == horizontalPadding &&
          other.verticalPadding == verticalPadding &&
          other.popupWidth == popupWidth &&
          other.itemRadius == itemRadius &&
          other.backgroundColor == backgroundColor &&
          other.borderColor == borderColor &&
          other.foregroundColor == foregroundColor &&
          other.selectedForegroundColor == selectedForegroundColor &&
          other.selectedBackgroundColor == selectedBackgroundColor &&
          other.ancestorSelectedForegroundColor ==
              ancestorSelectedForegroundColor &&
          other.ancestorSelectedBackgroundColor ==
              ancestorSelectedBackgroundColor &&
          other.disabledColor == disabledColor &&
          other.groupTitleStyle == groupTitleStyle &&
          other.itemTextStyle == itemTextStyle &&
          other.descriptionTextStyle == descriptionTextStyle &&
          other.selectionStyle == selectionStyle &&
          other.popupCardStyle == popupCardStyle &&
          other.widthTransitionBuilder == widthTransitionBuilder &&
          other.contentTransitionBuilder == contentTransitionBuilder &&
          other.childrenTransitionBuilder == childrenTransitionBuilder &&
          other.popupTransitionBuilder == popupTransitionBuilder;

  @override
  int get hashCode => Object.hashAll([
    width,
    collapsedWidth,
    itemHeight,
    iconSize,
    expandIconSize,
    collapsedIconSize,
    collapsedRowGap,
    iconColor,
    selectedIconColor,
    ancestorSelectedIconColor,
    disabledIconColor,
    expandIconColor,
    selectedExpandIconColor,
    ancestorSelectedExpandIconColor,
    disabledExpandIconColor,
    itemSpacing,
    rowGap,
    indent,
    sectionSpacing,
    horizontalPadding,
    verticalPadding,
    popupWidth,
    itemRadius,
    backgroundColor,
    borderColor,
    foregroundColor,
    selectedForegroundColor,
    selectedBackgroundColor,
    ancestorSelectedForegroundColor,
    ancestorSelectedBackgroundColor,
    disabledColor,
    groupTitleStyle,
    itemTextStyle,
    descriptionTextStyle,
    selectionStyle,
    popupCardStyle,
    disabledItemSurfaceStyle,
    ancestorItemSurfaceStyle,
    selectedItemSurfaceStyle,
    itemSurfaceStyle,
    surfaceStyle,
    widthTransitionBuilder,
    contentTransitionBuilder,
    childrenTransitionBuilder,
    popupTransitionBuilder,
  ]);
}
