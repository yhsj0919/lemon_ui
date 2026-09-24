import 'package:flutter/widgets.dart';

import '../../foundation/hyper_device_type.dart';
import 'components/hyper_button_size.dart';
import 'components/hyper_app_bar_size.dart';
import 'components/hyper_card_size.dart';
import 'components/hyper_checkbox_size.dart';
import 'components/hyper_divider_size.dart';
import 'components/hyper_drawer_size.dart';
import 'components/hyper_sidebar_size.dart';
import 'components/hyper_icon_size.dart';
import 'components/hyper_icon_button_size.dart';
import 'components/hyper_list_tile_size.dart';
import 'components/hyper_menu_size.dart';
import 'components/hyper_dropdown_menu_size.dart';
import 'components/hyper_popup_list_tile_size.dart';
import 'components/hyper_tab_bar_size.dart';
import 'components/hyper_progress_indicator_size.dart';
import 'components/hyper_radio_size.dart';
import 'components/hyper_switch_size.dart';

/// 一套明确、无倍率换算的终端尺寸配置。
@immutable
final class HyperSizeScheme {
  static const double spaceNone = 0;
  static const double spaceXxs = 2;
  static const double spaceXs = 4;
  static const double spaceSm = 6;
  static const double spaceMd = 8;
  static const double spaceLg = 12;
  static const double spaceXl = 16;
  static const double space2xl = 20;
  static const double space3xl = 24;
  static const double space4xl = 32;
  static const double space5xl = 40;
  static const double space6xl = 48;
  static const double space7xl = 64;

  static const double radiusNone = 0;
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radius2xl = 24;
  static const double radius3xl = 32;
  static const double radius4xl = 48;

  const HyperSizeScheme({
    required this.deviceType,
    required this.controlHeightXs,
    required this.controlHeightSm,
    required this.controlHeightMd,
    required this.controlHeightLg,
    required this.controlHeightXl,
    required this.minimumInteractiveDimension,
    required this.controlRadius,
    required this.surfaceRadius,
    required this.overlayRadius,
    required this.overlaySpacing,
    required this.controlPadding,
    required this.pageHorizontalPadding,
    required this.compactSectionSpacing,
    required this.sectionSpacing,
    required this.card,
    required this.appBar,
    required this.drawer,
    required this.sidebar,
    required this.menu,
    required this.dropdownMenu,
    required this.popupListTile,
    required this.tabBar,
    required this.listTile,
    required this.toolbarCompactHeight,
    required this.toolbarHeight,
    required this.toolbarEmphasizedHeight,
    required this.iconSize,
    required this.button,
    required this.iconButton,
    required this.checkbox,
    required this.radio,
    required this.switchSize,
    required this.divider,
    required this.icon,
    required this.progressIndicator,
  });

  /// 手机尺寸方案。
  const HyperSizeScheme.phone()
    : this(
        deviceType: HyperDeviceType.phone,
        controlHeightXs: 32,
        controlHeightSm: 40,
        controlHeightMd: 48,
        controlHeightLg: 56,
        controlHeightXl: 64,
        minimumInteractiveDimension: 48,
        controlRadius: 16,
        surfaceRadius: 20,
        overlayRadius: 28,
        overlaySpacing: 4,
        controlPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        pageHorizontalPadding: 16,
        compactSectionSpacing: 16,
        sectionSpacing: 24,
        card: const HyperCardSize(
          padding: EdgeInsets.zero,
          radius: 16,
          titlePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          titleSpacing: 12,
          outsideTitlePadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          outsideTitleSpacing: 0,
          actionSpacing: 8,
        ),
        appBar: const HyperAppBarSize(
          collapsedHeight: 58,
          mediumExpandedHeight: 80,
          expandedHeight: 96,
          titleHorizontalPadding: 26,
        ),
        drawer: const HyperDrawerSize(width: 304),
        sidebar: const HyperSidebarSize(
          width: 280,
          collapsedWidth: 72,
          itemHeight: 48,
          iconSize: 24,
          itemSpacing: 12,
          rowGap: 4,
          indent: 16,
          sectionSpacing: 16,
          horizontalPadding: 12,
          popupWidth: 280,
          itemRadius: 12,
        ),
        menu: const HyperMenuSize(
          width: 280,
          itemHeight: 48,
          padding: 12,
          groupSpacing: 16,
          iconSize: 24,
          iconSpacing: 12,
          itemRadius: 12,
          surfaceRadius: 16,
        ),
        dropdownMenu: const HyperDropdownMenuSize(
          width: 280,
          arrowSize: 24,
          arrowSpacing: 12,
        ),
        popupListTile: const HyperPopupListTileSize(
          minWidth: 200,
          maxWidth: 288,
          itemHorizontalPadding: 16,
        ),
        tabBar: const HyperTabBarSize(
          height: 42,
          separatedRadius: 12,
          segmentedRadius: 8,
          itemSpacing: 9,
          underlineThickness: 2,
        ),
        listTile: const HyperListTileSize(
          minHeight: 56,
          compactMinHeight: 48,
          subtitleMinHeight: 68,
          compactSubtitleMinHeight: 60,
          padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
          compactPadding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
          leadingSize: 32,
          leadingSpacing: 12,
          trailingSpacing: 8,
          trailingIconSize: 20,
          navigationSpacing: 4,
          navigationIconSize: 24,
        ),
        toolbarCompactHeight: 48,
        toolbarHeight: 56,
        toolbarEmphasizedHeight: 64,
        iconSize: 24,
        button: const HyperButtonSize(
          minimumSize: Size(58, 48),
          smallHeight: 48,
          largeHeight: 48,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          smallPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          largePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          radius: 16,
          iconSize: 24,
          iconSpacing: 8,
          progressSize: 18,
          hoverOverlayOpacity: .06,
          focusOverlayOpacity: .08,
          pressOverlayOpacity: .10,
        ),
        iconButton: const HyperIconButtonSize(
          size: 40,
          iconSize: 24,
          progressSize: 18,
          radius: 20,
        ),
        checkbox: const HyperCheckboxSize(
          size: 26,
          markStrokeWidth: 2.34,
          roundedRadius: 6,
        ),
        radio: const HyperRadioSize(size: 26),
        switchSize: const HyperSwitchSize(
          width: 48,
          height: 28,
          thumbSize: 20,
          thumbInset: 4,
        ),
        divider: const HyperDividerSize(thickness: 1, dashLength: 6, gap: 4),
        icon: const HyperIconSize(size: 24),
        progressIndicator: const HyperProgressIndicatorSize(
          circularSize: 30,
          circularThickness: 4,
          linearThickness: 6,
          infiniteSize: 20,
          infiniteDotRadius: 2,
        ),
      );

  /// 平板尺寸方案。
  const HyperSizeScheme.tablet()
    : this(
        deviceType: HyperDeviceType.tablet,
        controlHeightXs: 36,
        controlHeightSm: 44,
        controlHeightMd: 52,
        controlHeightLg: 60,
        controlHeightXl: 68,
        minimumInteractiveDimension: 48,
        controlRadius: 16,
        surfaceRadius: 24,
        overlayRadius: 28,
        overlaySpacing: 4,
        controlPadding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 14,
        ),
        pageHorizontalPadding: 16,
        compactSectionSpacing: 20,
        sectionSpacing: 32,
        card: const HyperCardSize(
          padding: EdgeInsets.zero,
          radius: 20,
          titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          titleSpacing: 16,
          outsideTitlePadding: EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          outsideTitleSpacing: 0,
          actionSpacing: 12,
        ),
        appBar: const HyperAppBarSize(
          collapsedHeight: 64,
          mediumExpandedHeight: 128,
          expandedHeight: 160,
          titleHorizontalPadding: 26,
        ),
        drawer: const HyperDrawerSize(width: 304),
        sidebar: const HyperSidebarSize(
          width: 280,
          collapsedWidth: 72,
          itemHeight: 48,
          iconSize: 24,
          itemSpacing: 12,
          rowGap: 4,
          indent: 16,
          sectionSpacing: 16,
          horizontalPadding: 12,
          popupWidth: 280,
          itemRadius: 12,
        ),
        menu: const HyperMenuSize(
          width: 280,
          itemHeight: 48,
          padding: 12,
          groupSpacing: 16,
          iconSize: 24,
          iconSpacing: 12,
          itemRadius: 12,
          surfaceRadius: 20,
        ),
        dropdownMenu: const HyperDropdownMenuSize(
          width: 280,
          arrowSize: 28,
          arrowSpacing: 12,
        ),
        popupListTile: const HyperPopupListTileSize(
          minWidth: 220,
          maxWidth: 320,
          itemHorizontalPadding: 16,
        ),
        tabBar: const HyperTabBarSize(
          height: 44,
          separatedRadius: 16,
          segmentedRadius: 16,
          itemSpacing: 10,
          underlineThickness: 2,
        ),
        listTile: const HyperListTileSize(
          minHeight: 56,
          compactMinHeight: 48,
          subtitleMinHeight: 68,
          compactSubtitleMinHeight: 60,
          padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
          compactPadding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
          leadingSize: 32,
          leadingSpacing: 12,
          trailingSpacing: 8,
          trailingIconSize: 20,
          navigationSpacing: 4,
          navigationIconSize: 24,
        ),
        toolbarCompactHeight: 52,
        toolbarHeight: 64,
        toolbarEmphasizedHeight: 72,
        iconSize: 28,
        button: const HyperButtonSize(
          minimumSize: Size(64, 44),
          smallHeight: 44,
          largeHeight: 44,
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          smallPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          largePadding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          radius: 16,
          iconSize: 24,
          iconSpacing: 8,
          progressSize: 18,
          hoverOverlayOpacity: .06,
          focusOverlayOpacity: .08,
          pressOverlayOpacity: .10,
        ),
        iconButton: const HyperIconButtonSize(
          size: 44,
          iconSize: 24,
          progressSize: 18,
          radius: 22,
        ),
        checkbox: const HyperCheckboxSize(
          size: 26,
          markStrokeWidth: 2.34,
          roundedRadius: 6,
        ),
        radio: const HyperRadioSize(size: 26),
        switchSize: const HyperSwitchSize(
          width: 48,
          height: 28,
          thumbSize: 20,
          thumbInset: 4,
        ),
        divider: const HyperDividerSize(thickness: 1, dashLength: 6, gap: 4),
        icon: const HyperIconSize(size: 24),
        progressIndicator: const HyperProgressIndicatorSize(
          circularSize: 30,
          circularThickness: 4,
          linearThickness: 6,
          infiniteSize: 20,
          infiniteDotRadius: 2,
        ),
      );

  /// 桌面尺寸方案。
  const HyperSizeScheme.desktop()
    : this(
        deviceType: HyperDeviceType.desktop,
        controlHeightXs: 28,
        controlHeightSm: 36,
        controlHeightMd: 44,
        controlHeightLg: 52,
        controlHeightXl: 60,
        minimumInteractiveDimension: 36,
        controlRadius: 10,
        surfaceRadius: 14,
        overlayRadius: 18,
        overlaySpacing: 4,
        controlPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        pageHorizontalPadding: 16,
        compactSectionSpacing: 20,
        sectionSpacing: 32,
        card: const HyperCardSize(
          padding: EdgeInsets.zero,
          radius: 8,
          titlePadding: EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          titleSpacing: 12,
          outsideTitlePadding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          outsideTitleSpacing: 0,
          actionSpacing: 8,
        ),
        appBar: const HyperAppBarSize(
          collapsedHeight: 48,
          mediumExpandedHeight: 88,
          expandedHeight: 120,
          titleHorizontalPadding: 16,
        ),
        drawer: const HyperDrawerSize(width: 304),
        sidebar: const HyperSidebarSize(
          width: 180,
          collapsedWidth: 64,
          itemHeight: 32,
          iconSize: 16,
          itemSpacing: 12,
          rowGap: 4,
          indent: 16,
          sectionSpacing: 12,
          horizontalPadding: 8,
          popupWidth: 256,
          itemRadius: 6,
        ),
        menu: const HyperMenuSize(
          width: 192,
          itemHeight: 32,
          padding: 8,
          groupSpacing: 8,
          iconSize: 16,
          iconSpacing: 12,
          itemRadius: 6,
          surfaceRadius: 8,
        ),
        dropdownMenu: const HyperDropdownMenuSize(
          width: 192,
          arrowSize: 20,
          arrowSpacing: 12,
        ),
        popupListTile: const HyperPopupListTileSize(
          minWidth: 160,
          maxWidth: 320,
          itemHorizontalPadding: 16,
        ),
        tabBar: const HyperTabBarSize(
          height: 36,
          separatedRadius: 10,
          segmentedRadius: 10,
          itemSpacing: 8,
          underlineThickness: 2,
        ),
        listTile: const HyperListTileSize(
          minHeight: 48,
          compactMinHeight: 40,
          subtitleMinHeight: 60,
          compactSubtitleMinHeight: 52,
          padding: EdgeInsetsDirectional.fromSTEB(16, 12, 16, 12),
          compactPadding: EdgeInsetsDirectional.fromSTEB(16, 8, 16, 8),
          leadingSize: 24,
          leadingSpacing: 10,
          trailingSpacing: 8,
          trailingIconSize: 18,
          navigationSpacing: 4,
          navigationIconSize: 20,
        ),
        toolbarCompactHeight: 40,
        toolbarHeight: 48,
        toolbarEmphasizedHeight: 56,
        iconSize: 20,
        button: const HyperButtonSize(
          minimumSize: Size(72, 32),
          smallHeight: 24,
          largeHeight: 40,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          smallPadding: EdgeInsets.symmetric(horizontal: 12),
          largePadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          radius: 6,
          iconSize: 16,
          iconSpacing: 4,
          progressSize: 16,
          hoverOverlayOpacity: .05,
          focusOverlayOpacity: .07,
          pressOverlayOpacity: .08,
        ),
        iconButton: const HyperIconButtonSize(
          size: 32,
          iconSize: 16,
          progressSize: 16,
          radius: 6,
        ),
        checkbox: const HyperCheckboxSize(
          size: 22,
          markStrokeWidth: 2,
          roundedRadius: 4,
        ),
        radio: const HyperRadioSize(size: 22),
        switchSize: const HyperSwitchSize(
          width: 44,
          height: 24,
          thumbSize: 18,
          thumbInset: 4,
        ),
        divider: const HyperDividerSize(thickness: 1, dashLength: 4, gap: 4),
        icon: const HyperIconSize(size: 18),
        progressIndicator: const HyperProgressIndicatorSize(
          circularSize: 24,
          circularThickness: 3,
          linearThickness: 4,
          infiniteSize: 16,
          infiniteDotRadius: 1.5,
        ),
      );

  /// 手表尺寸方案。
  const HyperSizeScheme.watch()
    : this(
        deviceType: HyperDeviceType.watch,
        controlHeightXs: 32,
        controlHeightSm: 40,
        controlHeightMd: 48,
        controlHeightLg: 56,
        controlHeightXl: 64,
        minimumInteractiveDimension: 48,
        controlRadius: 20,
        surfaceRadius: 28,
        overlayRadius: 32,
        overlaySpacing: 4,
        controlPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        pageHorizontalPadding: 12,
        compactSectionSpacing: 8,
        sectionSpacing: 16,
        card: const HyperCardSize(
          padding: EdgeInsets.zero,
          radius: 20,
          titlePadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          titleSpacing: 8,
          outsideTitlePadding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          outsideTitleSpacing: 0,
          actionSpacing: 6,
        ),
        appBar: const HyperAppBarSize(
          collapsedHeight: 48,
          mediumExpandedHeight: 72,
          expandedHeight: 96,
          titleHorizontalPadding: 12,
        ),
        drawer: const HyperDrawerSize(width: 200),
        sidebar: const HyperSidebarSize(
          width: 200,
          collapsedWidth: 56,
          itemHeight: 48,
          iconSize: 20,
          itemSpacing: 8,
          rowGap: 4,
          indent: 12,
          sectionSpacing: 8,
          horizontalPadding: 4,
          popupWidth: 200,
          itemRadius: 10,
        ),
        menu: const HyperMenuSize(
          width: 200,
          itemHeight: 48,
          padding: 4,
          groupSpacing: 8,
          iconSize: 20,
          iconSpacing: 8,
          itemRadius: 10,
          surfaceRadius: 20,
        ),
        dropdownMenu: const HyperDropdownMenuSize(
          width: 200,
          arrowSize: 24,
          arrowSpacing: 8,
        ),
        popupListTile: const HyperPopupListTileSize(
          minWidth: 160,
          maxWidth: 200,
          itemHorizontalPadding: 16,
        ),
        tabBar: const HyperTabBarSize(
          height: 40,
          separatedRadius: 20,
          segmentedRadius: 20,
          itemSpacing: 8,
          underlineThickness: 2,
        ),
        listTile: const HyperListTileSize(
          minHeight: 52,
          compactMinHeight: 48,
          subtitleMinHeight: 68,
          compactSubtitleMinHeight: 60,
          padding: EdgeInsetsDirectional.fromSTEB(12, 12, 8, 12),
          compactPadding: EdgeInsetsDirectional.fromSTEB(12, 10, 8, 10),
          leadingSize: 28,
          leadingSpacing: 8,
          trailingSpacing: 8,
          trailingIconSize: 18,
          navigationSpacing: 4,
          navigationIconSize: 20,
        ),
        toolbarCompactHeight: 40,
        toolbarHeight: 48,
        toolbarEmphasizedHeight: 56,
        iconSize: 24,
        button: const HyperButtonSize(
          minimumSize: Size(52, 40),
          smallHeight: 40,
          largeHeight: 40,
          padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          smallPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          largePadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          radius: 20,
          iconSize: 20,
          iconSpacing: 6,
          progressSize: 18,
          hoverOverlayOpacity: .06,
          focusOverlayOpacity: .08,
          pressOverlayOpacity: .10,
        ),
        iconButton: const HyperIconButtonSize(
          size: 40,
          iconSize: 20,
          progressSize: 18,
          radius: 20,
        ),
        checkbox: const HyperCheckboxSize(
          size: 26,
          markStrokeWidth: 2.34,
          roundedRadius: 6,
        ),
        radio: const HyperRadioSize(size: 26),
        switchSize: const HyperSwitchSize(
          width: 44,
          height: 26,
          thumbSize: 22,
          thumbInset: 2,
        ),
        divider: const HyperDividerSize(thickness: 2, dashLength: 6, gap: 4),
        icon: const HyperIconSize(size: 20),
        progressIndicator: const HyperProgressIndicatorSize(
          circularSize: 24,
          circularThickness: 3,
          linearThickness: 6,
          infiniteSize: 20,
          infiniteDotRadius: 2,
        ),
      );

  final HyperDeviceType deviceType;
  final double controlHeightXs;
  final double controlHeightSm;
  final double controlHeightMd;
  final double controlHeightLg;
  final double controlHeightXl;
  final double minimumInteractiveDimension;
  final double controlRadius;
  final double surfaceRadius;
  final double overlayRadius;
  final double overlaySpacing;
  final EdgeInsetsGeometry controlPadding;
  final double pageHorizontalPadding;
  final double compactSectionSpacing;
  final double sectionSpacing;
  final HyperCardSize card;
  final HyperAppBarSize appBar;
  final HyperDrawerSize drawer;
  final HyperSidebarSize sidebar;
  final HyperMenuSize menu;
  final HyperDropdownMenuSize dropdownMenu;
  final HyperPopupListTileSize popupListTile;
  final HyperTabBarSize tabBar;
  final HyperListTileSize listTile;
  final double toolbarCompactHeight;
  final double toolbarHeight;
  final double toolbarEmphasizedHeight;
  final double iconSize;
  final HyperButtonSize button;
  final HyperIconButtonSize iconButton;
  final HyperCheckboxSize checkbox;
  final HyperRadioSize radio;
  final HyperSwitchSize switchSize;
  final HyperDividerSize divider;
  final HyperIconSize icon;
  final HyperProgressIndicatorSize progressIndicator;

  HyperSizeScheme copyWith({
    HyperDeviceType? deviceType,
    double? controlHeightXs,
    double? controlHeightSm,
    double? controlHeightMd,
    double? controlHeightLg,
    double? controlHeightXl,
    double? minimumInteractiveDimension,
    double? controlRadius,
    double? surfaceRadius,
    double? overlayRadius,
    double? overlaySpacing,
    EdgeInsetsGeometry? controlPadding,
    double? pageHorizontalPadding,
    double? compactSectionSpacing,
    double? sectionSpacing,
    HyperCardSize? card,
    HyperAppBarSize? appBar,
    HyperDrawerSize? drawer,
    HyperSidebarSize? sidebar,
    HyperMenuSize? menu,
    HyperDropdownMenuSize? dropdownMenu,
    HyperPopupListTileSize? popupListTile,
    HyperTabBarSize? tabBar,
    HyperListTileSize? listTile,
    double? toolbarCompactHeight,
    double? toolbarHeight,
    double? toolbarEmphasizedHeight,
    double? iconSize,
    HyperButtonSize? button,
    HyperIconButtonSize? iconButton,
    HyperCheckboxSize? checkbox,
    HyperRadioSize? radio,
    HyperSwitchSize? switchSize,
    HyperDividerSize? divider,
    HyperIconSize? icon,
    HyperProgressIndicatorSize? progressIndicator,
  }) => HyperSizeScheme(
    deviceType: deviceType ?? this.deviceType,
    controlHeightXs: controlHeightXs ?? this.controlHeightXs,
    controlHeightSm: controlHeightSm ?? this.controlHeightSm,
    controlHeightMd: controlHeightMd ?? this.controlHeightMd,
    controlHeightLg: controlHeightLg ?? this.controlHeightLg,
    controlHeightXl: controlHeightXl ?? this.controlHeightXl,
    minimumInteractiveDimension:
        minimumInteractiveDimension ?? this.minimumInteractiveDimension,
    controlRadius: controlRadius ?? this.controlRadius,
    surfaceRadius: surfaceRadius ?? this.surfaceRadius,
    overlayRadius: overlayRadius ?? this.overlayRadius,
    overlaySpacing: overlaySpacing ?? this.overlaySpacing,
    controlPadding: controlPadding ?? this.controlPadding,
    pageHorizontalPadding: pageHorizontalPadding ?? this.pageHorizontalPadding,
    compactSectionSpacing: compactSectionSpacing ?? this.compactSectionSpacing,
    sectionSpacing: sectionSpacing ?? this.sectionSpacing,
    card: card ?? this.card,
    appBar: appBar ?? this.appBar,
    drawer: drawer ?? this.drawer,
    sidebar: sidebar ?? this.sidebar,
    menu: menu ?? this.menu,
    dropdownMenu: dropdownMenu ?? this.dropdownMenu,
    popupListTile: popupListTile ?? this.popupListTile,
    tabBar: tabBar ?? this.tabBar,
    listTile: listTile ?? this.listTile,
    toolbarCompactHeight: toolbarCompactHeight ?? this.toolbarCompactHeight,
    toolbarHeight: toolbarHeight ?? this.toolbarHeight,
    toolbarEmphasizedHeight:
        toolbarEmphasizedHeight ?? this.toolbarEmphasizedHeight,
    iconSize: iconSize ?? this.iconSize,
    button: button ?? this.button,
    iconButton: iconButton ?? this.iconButton,
    checkbox: checkbox ?? this.checkbox,
    radio: radio ?? this.radio,
    switchSize: switchSize ?? this.switchSize,
    divider: divider ?? this.divider,
    icon: icon ?? this.icon,
    progressIndicator: progressIndicator ?? this.progressIndicator,
  );

  /// 在两套明确尺寸之间插值，仅用于主题切换动画。
  static HyperSizeScheme lerp(HyperSizeScheme a, HyperSizeScheme b, double t) {
    if (t == 0) return a;
    if (t == 1) return b;
    double value(double x, double y) => x + (y - x) * t;
    return HyperSizeScheme(
      deviceType: t < .5 ? a.deviceType : b.deviceType,
      controlHeightXs: value(a.controlHeightXs, b.controlHeightXs),
      controlHeightSm: value(a.controlHeightSm, b.controlHeightSm),
      controlHeightMd: value(a.controlHeightMd, b.controlHeightMd),
      controlHeightLg: value(a.controlHeightLg, b.controlHeightLg),
      controlHeightXl: value(a.controlHeightXl, b.controlHeightXl),
      minimumInteractiveDimension: value(
        a.minimumInteractiveDimension,
        b.minimumInteractiveDimension,
      ),
      controlRadius: value(a.controlRadius, b.controlRadius),
      surfaceRadius: value(a.surfaceRadius, b.surfaceRadius),
      overlayRadius: value(a.overlayRadius, b.overlayRadius),
      overlaySpacing: value(a.overlaySpacing, b.overlaySpacing),
      controlPadding: EdgeInsetsGeometry.lerp(
        a.controlPadding,
        b.controlPadding,
        t,
      )!,
      pageHorizontalPadding: value(
        a.pageHorizontalPadding,
        b.pageHorizontalPadding,
      ),
      compactSectionSpacing: value(
        a.compactSectionSpacing,
        b.compactSectionSpacing,
      ),
      sectionSpacing: value(a.sectionSpacing, b.sectionSpacing),
      card: HyperCardSize.lerp(a.card, b.card, t),
      appBar: HyperAppBarSize.lerp(a.appBar, b.appBar, t),
      drawer: HyperDrawerSize.lerp(a.drawer, b.drawer, t),
      sidebar: HyperSidebarSize.lerp(a.sidebar, b.sidebar, t),
      menu: HyperMenuSize.lerp(a.menu, b.menu, t),
      dropdownMenu: HyperDropdownMenuSize.lerp(
        a.dropdownMenu,
        b.dropdownMenu,
        t,
      ),
      popupListTile: HyperPopupListTileSize.lerp(
        a.popupListTile,
        b.popupListTile,
        t,
      ),
      tabBar: HyperTabBarSize.lerp(a.tabBar, b.tabBar, t),
      listTile: HyperListTileSize.lerp(a.listTile, b.listTile, t),
      toolbarCompactHeight: value(
        a.toolbarCompactHeight,
        b.toolbarCompactHeight,
      ),
      toolbarHeight: value(a.toolbarHeight, b.toolbarHeight),
      toolbarEmphasizedHeight: value(
        a.toolbarEmphasizedHeight,
        b.toolbarEmphasizedHeight,
      ),
      iconSize: value(a.iconSize, b.iconSize),
      button: HyperButtonSize.lerp(a.button, b.button, t),
      iconButton: HyperIconButtonSize.lerp(a.iconButton, b.iconButton, t),
      checkbox: HyperCheckboxSize.lerp(a.checkbox, b.checkbox, t),
      radio: HyperRadioSize.lerp(a.radio, b.radio, t),
      switchSize: HyperSwitchSize.lerp(a.switchSize, b.switchSize, t),
      divider: HyperDividerSize.lerp(a.divider, b.divider, t),
      icon: HyperIconSize.lerp(a.icon, b.icon, t),
      progressIndicator: HyperProgressIndicatorSize.lerp(
        a.progressIndicator,
        b.progressIndicator,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperSizeScheme &&
          other.deviceType == deviceType &&
          other.controlHeightXs == controlHeightXs &&
          other.controlHeightSm == controlHeightSm &&
          other.controlHeightMd == controlHeightMd &&
          other.controlHeightLg == controlHeightLg &&
          other.controlHeightXl == controlHeightXl &&
          other.minimumInteractiveDimension == minimumInteractiveDimension &&
          other.controlRadius == controlRadius &&
          other.surfaceRadius == surfaceRadius &&
          other.overlayRadius == overlayRadius &&
          other.overlaySpacing == overlaySpacing &&
          other.controlPadding == controlPadding &&
          other.pageHorizontalPadding == pageHorizontalPadding &&
          other.compactSectionSpacing == compactSectionSpacing &&
          other.sectionSpacing == sectionSpacing &&
          other.card == card &&
          other.appBar == appBar &&
          other.drawer == drawer &&
          other.sidebar == sidebar &&
          other.menu == menu &&
          other.dropdownMenu == dropdownMenu &&
          other.popupListTile == popupListTile &&
          other.tabBar == tabBar &&
          other.listTile == listTile &&
          other.toolbarCompactHeight == toolbarCompactHeight &&
          other.toolbarHeight == toolbarHeight &&
          other.toolbarEmphasizedHeight == toolbarEmphasizedHeight &&
          other.iconSize == iconSize &&
          other.button == button &&
          other.iconButton == iconButton &&
          other.checkbox == checkbox &&
          other.radio == radio &&
          other.switchSize == switchSize &&
          other.divider == divider &&
          other.icon == icon &&
          other.progressIndicator == progressIndicator;

  @override
  int get hashCode => Object.hashAll([
    deviceType,
    controlHeightXs,
    controlHeightSm,
    controlHeightMd,
    controlHeightLg,
    controlHeightXl,
    minimumInteractiveDimension,
    controlRadius,
    surfaceRadius,
    overlayRadius,
    overlaySpacing,
    controlPadding,
    pageHorizontalPadding,
    compactSectionSpacing,
    sectionSpacing,
    card,
    appBar,
    drawer,
    sidebar,
    menu,
    dropdownMenu,
    popupListTile,
    tabBar,
    listTile,
    toolbarCompactHeight,
    toolbarHeight,
    toolbarEmphasizedHeight,
    iconSize,
    button,
    iconButton,
    checkbox,
    radio,
    switchSize,
    divider,
    icon,
    progressIndicator,
  ]);
}
