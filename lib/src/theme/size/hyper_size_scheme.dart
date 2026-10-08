import 'components/hyper_timeline_size.dart';
import 'components/hyper_step_size.dart';
import 'components/hyper_pagination_size.dart';
import 'components/hyper_accordion_size.dart';
import 'components/hyper_collapsible_size.dart';
import 'components/hyper_notification_center_size.dart';
import 'components/hyper_notification_size.dart';
import 'components/hyper_loading_overlay_size.dart';
import 'components/hyper_notice_size.dart';
import 'components/hyper_message_size.dart';
import 'components/hyper_text_field_size.dart';
import 'components/hyper_dialog_size.dart';
import 'components/hyper_bottom_sheet_size.dart';
import 'components/hyper_chip_size.dart';
import 'components/hyper_empty_state_size.dart';
import 'components/hyper_skeleton_size.dart';
import 'components/hyper_avatar_size.dart';

import 'package:flutter/widgets.dart';

import '../../foundation/hyper_device_type.dart';
import 'components/hyper_button_size.dart';
import 'components/hyper_badge_size.dart';
import 'components/hyper_tag_size.dart';
import 'components/hyper_widget_group_size.dart';
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
import 'components/hyper_breadcrumb_size.dart';
import 'components/hyper_progress_size.dart';
import 'components/hyper_radio_size.dart';
import 'components/hyper_switch_size.dart';
import 'components/hyper_slider_size.dart';

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
    required this.breadcrumb,
    required this.listTile,
    required this.toolbarCompactHeight,
    required this.toolbarHeight,
    required this.toolbarEmphasizedHeight,
    required this.iconSize,
    required this.button,
    required this.badge,
    required this.tag,
    required this.avatar,
    required this.skeleton,
    required this.emptyState,
    required this.textField,
    required this.dialog,
    required this.toast,
    required this.snackbar,
    required this.loadingOverlay,
    required this.notificationCenter,
    required this.collapsible,
    required this.accordion,
    required this.pagination,
    required this.stepIndicator,
    required this.stepperNavigation,
    required this.timeline,
    required this.notification,
    required this.alert,
    required this.banner,
    required this.bottomSheet,
    required this.chip,
    required this.widgetGroup,
    required this.iconButton,
    required this.checkbox,
    required this.radio,
    required this.switchSize,
    required this.slider,
    required this.divider,
    required this.icon,
    required this.progress,
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
        toast: const HyperMessageSize(
          maxWidth: 320,
          radius: 28,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          iconSize: 20,
          spacing: 8,
        ),
        snackbar: const HyperMessageSize(
          maxWidth: 320,
          radius: 28,
          padding: EdgeInsets.all(16),
          iconSize: 20,
          spacing: 8,
        ),
        loadingOverlay: const HyperLoadingOverlaySize(
          radius: 16,
          padding: EdgeInsets.all(16),
          maxContentWidth: 320,
          spacing: 8,
        ),
        notificationCenter: const HyperNotificationCenterSize(
          padding: EdgeInsets.all(16),
          spacing: 8,
          groupSpacing: 16,
        ),
        collapsible: const HyperCollapsibleSize(
          radius: 16,
          headerPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          contentPadding: EdgeInsets.fromLTRB(16, 0, 16, 16),
          headerMinHeight: 48,
          iconSize: 20,
          spacing: 8,
        ),
        accordion: const HyperAccordionSize(spacing: 8, dividerThickness: 1),
        pagination: const HyperPaginationSize(
          height: 40,
          minWidth: 40,
          radius: 16,
          padding: EdgeInsets.symmetric(horizontal: 8),
          iconSize: 20,
          spacing: 8,
          runSpacing: 8,
        ),
        stepIndicator: const HyperStepSize(
          nodeSize: 32,
          iconSize: 20,
          connectorThickness: 1,
          spacing: 8,
          titleSpacing: 4,
          itemSpacing: 16,
          interactionRadius: 16,
        ),
        stepperNavigation: const HyperStepSize(
          nodeSize: 32,
          iconSize: 20,
          connectorThickness: 1,
          spacing: 8,
          titleSpacing: 4,
          itemSpacing: 16,
          interactionRadius: 16,
        ),
        timeline: const HyperTimelineSize(
          nodeSize: 12,
          iconSize: 20,
          lineThickness: 1,
          spacing: 8,
          itemSpacing: 16,
          textSpacing: 4,
        ),
        notification: const HyperNotificationSize(
          radius: 16,
          padding: EdgeInsets.all(16),
          iconSize: 20,
          unreadSize: 6,
          closeIconSize: 20,
          closeButtonSize: 40,
          spacing: 8,
          titleSpacing: 4,
          actionSpacing: 8,
          actionRunSpacing: 8,
        ),
        alert: const HyperNoticeSize(
          radius: 16,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          iconSize: 20,
          closeIconSize: 20,
          closeButtonSize: 40,
          spacing: 8,
          titleSpacing: 4,
          actionSpacing: 8,
          actionRunSpacing: 8,
        ),
        banner: const HyperNoticeSize(
          radius: 0,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          iconSize: 20,
          closeIconSize: 20,
          closeButtonSize: 40,
          spacing: 8,
          titleSpacing: 4,
          actionSpacing: 8,
          actionRunSpacing: 8,
        ),
        bottomSheet: const HyperBottomSheetSize(
          maxWidth: 320,
          radius: 28,
          titleSpacing: 16,
          actionSpacing: 12,
          actionRunSpacing: 8,
          closeIconSize: 20,
          dragHandleRadius: 2,
          dragHandleSize: Size(32, 4),
          dragHandlePadding: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(16),
        ),
        dialog: const HyperDialogSize(
          maxWidth: 320,
          radius: 28,
          titleSpacing: 16,
          actionSpacing: 12,
          actionRunSpacing: 8,
          closeIconSize: 20,
          padding: EdgeInsets.all(16),
          insetPadding: EdgeInsets.all(16),
        ),
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
        breadcrumb: const HyperBreadcrumbSize(
          itemHeight: 30,
          itemHorizontalPadding: 10,
          itemMaxWidth: 160,
          separatorSize: 20,
          separatorSpacing: 4,
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
        badge: const HyperBadgeSize(
          dotSize: 6,
          dotRadius: 3,
          contentHeight: 16,
          textSize: 11,
          contentRadius: 8,
          horizontalPadding: 4,
        ),
        textField: const HyperTextFieldSize(
          minimumHeight: 48,
          horizontalPadding: 16,
          verticalPadding: 12,
          radius: 16,
          iconSize: 20,
          actionWidth: 40,
          labelGap: 8,
          errorMaxWidth: 320,
        ),
        chip: const HyperChipSize(
          height: 32,
          horizontalPadding: 12,
          radius: 8,
          iconSize: 18,
          iconSpacing: 6,
          avatarSize: 24,
          deleteIconSize: 16,
          deleteTargetWidth: 32,
        ),
        emptyState: const HyperEmptyStateSize(
          iconSize: 48,
          illustrationSize: 80,
          maxWidth: 320,
          contentSpacing: 16,
          titleSpacing: 8,
          actionSpacing: 12,
          actionRunSpacing: 8,
          padding: EdgeInsets.all(16),
        ),
        skeleton: const HyperSkeletonSize(
          lineHeight: 14,
          lineWidth: 160,
          circleSize: 40,
          blockWidth: 160,
          blockHeight: 96,
          radius: 8,
        ),
        avatar: const HyperAvatarSize(
          small: 32,
          medium: 40,
          large: 56,
          radius: 10,
          iconSize: 20,
          overlap: 10,
          spacing: 6,
          ringWidth: 2,
        ),
        tag: const HyperTagSize(
          height: 24,
          horizontalPadding: 8,
          radius: 6,
          iconSize: 14,
          iconSpacing: 4,
        ),
        widgetGroup: const HyperWidgetGroupSize(
          spacing: 8,
          separatorExtent: 20,
          separatorThickness: 1,
          radius: 8,
          innerRadius: 6,
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
        slider: const HyperSliderSize(
          trackHeight: 28,
          thumbRadius: 14,
          stepPointRadius: 3.855,
          thinTrackHeight: 4,
          thinThumbRadius: 10,
          capsuleWidth: 64,
          capsuleCornerRadius: 26,
          capsuleIconSize: 24,
          capsuleIconInset: 12,
          capsuleOverscrollExtent: 10,
        ),
        divider: const HyperDividerSize(
          thickness: 1,
          dashLength: 6,
          gap: 4,
          contentGap: 8,
          edgeExtent: 16,
          iconSize: 18,
        ),
        icon: const HyperIconSize(size: 24),
        progress: const HyperProgressSize(
          circularSize: 30,
          circularThickness: 4,
          linearThickness: 6,
          wideLinearThickness: 28,
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
        toast: const HyperMessageSize(
          maxWidth: 400,
          radius: 28,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          iconSize: 22,
          spacing: 12,
        ),
        snackbar: const HyperMessageSize(
          maxWidth: 400,
          radius: 28,
          padding: EdgeInsets.all(20),
          iconSize: 22,
          spacing: 12,
        ),
        loadingOverlay: const HyperLoadingOverlaySize(
          radius: 20,
          padding: EdgeInsets.all(20),
          maxContentWidth: 400,
          spacing: 12,
        ),
        notificationCenter: const HyperNotificationCenterSize(
          padding: EdgeInsets.all(20),
          spacing: 12,
          groupSpacing: 20,
        ),
        collapsible: const HyperCollapsibleSize(
          radius: 20,
          headerPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          contentPadding: EdgeInsets.fromLTRB(20, 0, 20, 20),
          headerMinHeight: 52,
          iconSize: 22,
          spacing: 12,
        ),
        accordion: const HyperAccordionSize(spacing: 12, dividerThickness: 1),
        pagination: const HyperPaginationSize(
          height: 44,
          minWidth: 44,
          radius: 16,
          padding: EdgeInsets.symmetric(horizontal: 12),
          iconSize: 22,
          spacing: 12,
          runSpacing: 12,
        ),
        stepIndicator: const HyperStepSize(
          nodeSize: 36,
          iconSize: 22,
          connectorThickness: 1,
          spacing: 12,
          titleSpacing: 4,
          itemSpacing: 20,
          interactionRadius: 16,
        ),
        stepperNavigation: const HyperStepSize(
          nodeSize: 36,
          iconSize: 22,
          connectorThickness: 1,
          spacing: 12,
          titleSpacing: 4,
          itemSpacing: 20,
          interactionRadius: 16,
        ),
        timeline: const HyperTimelineSize(
          nodeSize: 12,
          iconSize: 22,
          lineThickness: 1,
          spacing: 12,
          itemSpacing: 20,
          textSpacing: 4,
        ),
        notification: const HyperNotificationSize(
          radius: 20,
          padding: EdgeInsets.all(20),
          iconSize: 22,
          unreadSize: 6,
          closeIconSize: 22,
          closeButtonSize: 44,
          spacing: 12,
          titleSpacing: 4,
          actionSpacing: 12,
          actionRunSpacing: 12,
        ),
        alert: const HyperNoticeSize(
          radius: 20,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          iconSize: 22,
          closeIconSize: 22,
          closeButtonSize: 44,
          spacing: 12,
          titleSpacing: 4,
          actionSpacing: 12,
          actionRunSpacing: 12,
        ),
        banner: const HyperNoticeSize(
          radius: 0,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          iconSize: 22,
          closeIconSize: 22,
          closeButtonSize: 44,
          spacing: 12,
          titleSpacing: 4,
          actionSpacing: 12,
          actionRunSpacing: 12,
        ),
        bottomSheet: const HyperBottomSheetSize(
          maxWidth: 400,
          radius: 28,
          titleSpacing: 20,
          actionSpacing: 12,
          actionRunSpacing: 8,
          closeIconSize: 22,
          dragHandleRadius: 2,
          dragHandleSize: Size(32, 4),
          dragHandlePadding: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(20),
        ),
        dialog: const HyperDialogSize(
          maxWidth: 400,
          radius: 28,
          titleSpacing: 20,
          actionSpacing: 12,
          actionRunSpacing: 8,
          closeIconSize: 22,
          padding: EdgeInsets.all(20),
          insetPadding: EdgeInsets.all(16),
        ),
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
        breadcrumb: const HyperBreadcrumbSize(
          itemHeight: 34,
          itemHorizontalPadding: 12,
          itemMaxWidth: 200,
          separatorSize: 20,
          separatorSpacing: 6,
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
        badge: const HyperBadgeSize(
          dotSize: 6,
          dotRadius: 3,
          contentHeight: 18,
          textSize: 12,
          contentRadius: 9,
          horizontalPadding: 5,
        ),
        textField: const HyperTextFieldSize(
          minimumHeight: 52,
          horizontalPadding: 16,
          verticalPadding: 14,
          radius: 16,
          iconSize: 22,
          actionWidth: 44,
          labelGap: 8,
          errorMaxWidth: 400,
        ),
        chip: const HyperChipSize(
          height: 36,
          horizontalPadding: 14,
          radius: 10,
          iconSize: 20,
          iconSpacing: 8,
          avatarSize: 28,
          deleteIconSize: 18,
          deleteTargetWidth: 36,
        ),
        emptyState: const HyperEmptyStateSize(
          iconSize: 56,
          illustrationSize: 96,
          maxWidth: 400,
          contentSpacing: 20,
          titleSpacing: 8,
          actionSpacing: 12,
          actionRunSpacing: 8,
          padding: EdgeInsets.all(20),
        ),
        skeleton: const HyperSkeletonSize(
          lineHeight: 16,
          lineWidth: 180,
          circleSize: 44,
          blockWidth: 180,
          blockHeight: 108,
          radius: 8,
        ),
        avatar: const HyperAvatarSize(
          small: 32,
          medium: 44,
          large: 64,
          radius: 12,
          iconSize: 24,
          overlap: 12,
          spacing: 6,
          ringWidth: 2,
        ),
        tag: const HyperTagSize(
          height: 26,
          horizontalPadding: 9,
          radius: 6,
          iconSize: 14,
          iconSpacing: 4,
        ),
        widgetGroup: const HyperWidgetGroupSize(
          spacing: 8,
          separatorExtent: 20,
          separatorThickness: 1,
          radius: 8,
          innerRadius: 6,
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
        slider: const HyperSliderSize(
          trackHeight: 28,
          thumbRadius: 14,
          stepPointRadius: 3.855,
          thinTrackHeight: 4,
          thinThumbRadius: 10,
          capsuleWidth: 68,
          capsuleCornerRadius: 28,
          capsuleIconSize: 26,
          capsuleIconInset: 12,
          capsuleOverscrollExtent: 10,
        ),
        divider: const HyperDividerSize(
          thickness: 1,
          dashLength: 6,
          gap: 4,
          contentGap: 8,
          edgeExtent: 16,
          iconSize: 18,
        ),
        icon: const HyperIconSize(size: 24),
        progress: const HyperProgressSize(
          circularSize: 30,
          circularThickness: 4,
          linearThickness: 6,
          wideLinearThickness: 28,
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
        toast: const HyperMessageSize(
          maxWidth: 360,
          radius: 18,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          iconSize: 16,
          spacing: 8,
        ),
        snackbar: const HyperMessageSize(
          maxWidth: 360,
          radius: 18,
          padding: EdgeInsets.all(16),
          iconSize: 16,
          spacing: 8,
        ),
        loadingOverlay: const HyperLoadingOverlaySize(
          radius: 8,
          padding: EdgeInsets.all(12),
          maxContentWidth: 360,
          spacing: 8,
        ),
        notificationCenter: const HyperNotificationCenterSize(
          padding: EdgeInsets.all(12),
          spacing: 8,
          groupSpacing: 12,
        ),
        collapsible: const HyperCollapsibleSize(
          radius: 8,
          headerPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 12),
          headerMinHeight: 44,
          iconSize: 16,
          spacing: 8,
        ),
        accordion: const HyperAccordionSize(spacing: 8, dividerThickness: 1),
        pagination: const HyperPaginationSize(
          height: 36,
          minWidth: 36,
          radius: 10,
          padding: EdgeInsets.symmetric(horizontal: 8),
          iconSize: 16,
          spacing: 8,
          runSpacing: 8,
        ),
        stepIndicator: const HyperStepSize(
          nodeSize: 28,
          iconSize: 16,
          connectorThickness: 1,
          spacing: 8,
          titleSpacing: 4,
          itemSpacing: 12,
          interactionRadius: 10,
        ),
        stepperNavigation: const HyperStepSize(
          nodeSize: 28,
          iconSize: 16,
          connectorThickness: 1,
          spacing: 8,
          titleSpacing: 4,
          itemSpacing: 12,
          interactionRadius: 10,
        ),
        timeline: const HyperTimelineSize(
          nodeSize: 8,
          iconSize: 16,
          lineThickness: 1,
          spacing: 8,
          itemSpacing: 12,
          textSpacing: 4,
        ),
        notification: const HyperNotificationSize(
          radius: 8,
          padding: EdgeInsets.all(12),
          iconSize: 16,
          unreadSize: 6,
          closeIconSize: 16,
          closeButtonSize: 32,
          spacing: 8,
          titleSpacing: 4,
          actionSpacing: 8,
          actionRunSpacing: 8,
        ),
        alert: const HyperNoticeSize(
          radius: 8,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          iconSize: 16,
          closeIconSize: 16,
          closeButtonSize: 32,
          spacing: 8,
          titleSpacing: 4,
          actionSpacing: 8,
          actionRunSpacing: 8,
        ),
        banner: const HyperNoticeSize(
          radius: 0,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          iconSize: 16,
          closeIconSize: 16,
          closeButtonSize: 32,
          spacing: 8,
          titleSpacing: 4,
          actionSpacing: 8,
          actionRunSpacing: 8,
        ),
        bottomSheet: const HyperBottomSheetSize(
          maxWidth: 640,
          radius: 18,
          titleSpacing: 16,
          actionSpacing: 8,
          actionRunSpacing: 8,
          closeIconSize: 16,
          dragHandleRadius: 2,
          dragHandleSize: Size(32, 4),
          dragHandlePadding: EdgeInsets.symmetric(vertical: 8),
          padding: EdgeInsets.all(16),
        ),
        dialog: const HyperDialogSize(
          maxWidth: 360,
          radius: 18,
          titleSpacing: 16,
          actionSpacing: 8,
          actionRunSpacing: 8,
          closeIconSize: 16,
          padding: EdgeInsets.all(16),
          insetPadding: EdgeInsets.all(16),
        ),
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
        breadcrumb: const HyperBreadcrumbSize(
          itemHeight: 26,
          itemHorizontalPadding: 10,
          itemMaxWidth: 180,
          separatorSize: 16,
          separatorSpacing: 4,
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
        badge: const HyperBadgeSize(
          dotSize: 6,
          dotRadius: 3,
          contentHeight: 16,
          textSize: 11,
          contentRadius: 8,
          horizontalPadding: 4,
        ),
        textField: const HyperTextFieldSize(
          minimumHeight: 32,
          horizontalPadding: 12,
          verticalPadding: 6,
          radius: 6,
          iconSize: 16,
          actionWidth: 28,
          labelGap: 6,
          errorMaxWidth: 360,
        ),
        chip: const HyperChipSize(
          height: 28,
          horizontalPadding: 10,
          radius: 6,
          iconSize: 16,
          iconSpacing: 6,
          avatarSize: 20,
          deleteIconSize: 14,
          deleteTargetWidth: 28,
        ),
        emptyState: const HyperEmptyStateSize(
          iconSize: 40,
          illustrationSize: 72,
          maxWidth: 360,
          contentSpacing: 16,
          titleSpacing: 6,
          actionSpacing: 8,
          actionRunSpacing: 8,
          padding: EdgeInsets.all(16),
        ),
        skeleton: const HyperSkeletonSize(
          lineHeight: 12,
          lineWidth: 160,
          circleSize: 32,
          blockWidth: 160,
          blockHeight: 96,
          radius: 6,
        ),
        avatar: const HyperAvatarSize(
          small: 24,
          medium: 32,
          large: 40,
          radius: 6,
          iconSize: 16,
          overlap: 8,
          spacing: 4,
          ringWidth: 2,
        ),
        tag: const HyperTagSize(
          height: 22,
          horizontalPadding: 8,
          radius: 4,
          iconSize: 12,
          iconSpacing: 4,
        ),
        widgetGroup: const HyperWidgetGroupSize(
          spacing: 6,
          separatorExtent: 16,
          separatorThickness: 1,
          radius: 6,
          innerRadius: 4,
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
        slider: const HyperSliderSize(
          trackHeight: 24,
          thumbRadius: 12,
          stepPointRadius: 3,
          thinTrackHeight: 4,
          thinThumbRadius: 9,
          capsuleWidth: 56,
          capsuleCornerRadius: 22,
          capsuleIconSize: 20,
          capsuleIconInset: 10,
          capsuleOverscrollExtent: 8,
        ),
        divider: const HyperDividerSize(
          thickness: 1,
          dashLength: 4,
          gap: 4,
          contentGap: 8,
          edgeExtent: 16,
          iconSize: 16,
        ),
        icon: const HyperIconSize(size: 18),
        progress: const HyperProgressSize(
          circularSize: 24,
          circularThickness: 3,
          linearThickness: 4,
          wideLinearThickness: 24,
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
        toast: const HyperMessageSize(
          maxWidth: 180,
          radius: 32,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          iconSize: 18,
          spacing: 6,
        ),
        snackbar: const HyperMessageSize(
          maxWidth: 180,
          radius: 32,
          padding: EdgeInsets.all(12),
          iconSize: 18,
          spacing: 6,
        ),
        loadingOverlay: const HyperLoadingOverlaySize(
          radius: 20,
          padding: EdgeInsets.all(12),
          maxContentWidth: 180,
          spacing: 6,
        ),
        notificationCenter: const HyperNotificationCenterSize(
          padding: EdgeInsets.all(12),
          spacing: 6,
          groupSpacing: 12,
        ),
        collapsible: const HyperCollapsibleSize(
          radius: 20,
          headerPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          contentPadding: EdgeInsets.fromLTRB(12, 0, 12, 12),
          headerMinHeight: 48,
          iconSize: 18,
          spacing: 6,
        ),
        accordion: const HyperAccordionSize(spacing: 6, dividerThickness: 1),
        pagination: const HyperPaginationSize(
          height: 40,
          minWidth: 40,
          radius: 20,
          padding: EdgeInsets.symmetric(horizontal: 6),
          iconSize: 18,
          spacing: 6,
          runSpacing: 6,
        ),
        stepIndicator: const HyperStepSize(
          nodeSize: 32,
          iconSize: 18,
          connectorThickness: 1,
          spacing: 6,
          titleSpacing: 4,
          itemSpacing: 12,
          interactionRadius: 20,
        ),
        stepperNavigation: const HyperStepSize(
          nodeSize: 32,
          iconSize: 18,
          connectorThickness: 1,
          spacing: 6,
          titleSpacing: 4,
          itemSpacing: 12,
          interactionRadius: 20,
        ),
        timeline: const HyperTimelineSize(
          nodeSize: 12,
          iconSize: 18,
          lineThickness: 1,
          spacing: 6,
          itemSpacing: 12,
          textSpacing: 4,
        ),
        notification: const HyperNotificationSize(
          radius: 20,
          padding: EdgeInsets.all(12),
          iconSize: 18,
          unreadSize: 6,
          closeIconSize: 18,
          closeButtonSize: 40,
          spacing: 6,
          titleSpacing: 4,
          actionSpacing: 6,
          actionRunSpacing: 6,
        ),
        alert: const HyperNoticeSize(
          radius: 20,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          iconSize: 18,
          closeIconSize: 18,
          closeButtonSize: 36,
          spacing: 6,
          titleSpacing: 4,
          actionSpacing: 6,
          actionRunSpacing: 6,
        ),
        banner: const HyperNoticeSize(
          radius: 0,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          iconSize: 18,
          closeIconSize: 18,
          closeButtonSize: 36,
          spacing: 6,
          titleSpacing: 4,
          actionSpacing: 6,
          actionRunSpacing: 6,
        ),
        bottomSheet: const HyperBottomSheetSize(
          maxWidth: 180,
          radius: 32,
          titleSpacing: 8,
          actionSpacing: 6,
          actionRunSpacing: 6,
          closeIconSize: 18,
          dragHandleRadius: 2,
          dragHandleSize: Size(32, 4),
          dragHandlePadding: EdgeInsets.symmetric(vertical: 6),
          padding: EdgeInsets.all(12),
        ),
        dialog: const HyperDialogSize(
          maxWidth: 180,
          radius: 32,
          titleSpacing: 8,
          actionSpacing: 6,
          actionRunSpacing: 6,
          closeIconSize: 18,
          padding: EdgeInsets.all(12),
          insetPadding: EdgeInsets.all(12),
        ),
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
        breadcrumb: const HyperBreadcrumbSize(
          itemHeight: 30,
          itemHorizontalPadding: 10,
          itemMaxWidth: 100,
          separatorSize: 16,
          separatorSpacing: 4,
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
        badge: const HyperBadgeSize(
          dotSize: 5,
          dotRadius: 2.5,
          contentHeight: 14,
          textSize: 10,
          contentRadius: 7,
          horizontalPadding: 3,
        ),
        textField: const HyperTextFieldSize(
          minimumHeight: 48,
          horizontalPadding: 12,
          verticalPadding: 12,
          radius: 16,
          iconSize: 18,
          actionWidth: 36,
          labelGap: 6,
          errorMaxWidth: 180,
        ),
        chip: const HyperChipSize(
          height: 32,
          horizontalPadding: 10,
          radius: 8,
          iconSize: 18,
          iconSpacing: 6,
          avatarSize: 24,
          deleteIconSize: 16,
          deleteTargetWidth: 32,
        ),
        emptyState: const HyperEmptyStateSize(
          iconSize: 32,
          illustrationSize: 48,
          maxWidth: 180,
          contentSpacing: 12,
          titleSpacing: 4,
          actionSpacing: 6,
          actionRunSpacing: 6,
          padding: EdgeInsets.all(8),
        ),
        skeleton: const HyperSkeletonSize(
          lineHeight: 12,
          lineWidth: 120,
          circleSize: 36,
          blockWidth: 120,
          blockHeight: 72,
          radius: 6,
        ),
        avatar: const HyperAvatarSize(
          small: 28,
          medium: 36,
          large: 44,
          radius: 8,
          iconSize: 18,
          overlap: 8,
          spacing: 4,
          ringWidth: 2,
        ),
        tag: const HyperTagSize(
          height: 20,
          horizontalPadding: 6,
          radius: 4,
          iconSize: 12,
          iconSpacing: 3,
        ),
        widgetGroup: const HyperWidgetGroupSize(
          spacing: 4,
          separatorExtent: 14,
          separatorThickness: 1,
          radius: 6,
          innerRadius: 4,
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
        slider: const HyperSliderSize(
          trackHeight: 26,
          thumbRadius: 13,
          stepPointRadius: 3.5,
          thinTrackHeight: 4,
          thinThumbRadius: 9,
          capsuleWidth: 48,
          capsuleCornerRadius: 20,
          capsuleIconSize: 20,
          capsuleIconInset: 8,
          capsuleOverscrollExtent: 6,
        ),
        divider: const HyperDividerSize(
          thickness: 2,
          dashLength: 6,
          gap: 4,
          contentGap: 6,
          edgeExtent: 12,
          iconSize: 16,
        ),
        icon: const HyperIconSize(size: 20),
        progress: const HyperProgressSize(
          circularSize: 24,
          circularThickness: 3,
          linearThickness: 6,
          wideLinearThickness: 26,
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
  final HyperBreadcrumbSize breadcrumb;
  final HyperListTileSize listTile;
  final double toolbarCompactHeight;
  final double toolbarHeight;
  final double toolbarEmphasizedHeight;
  final double iconSize;
  final HyperButtonSize button;
  final HyperBadgeSize badge;
  final HyperTagSize tag;
  final HyperAvatarSize avatar;
  final HyperSkeletonSize skeleton;
  final HyperEmptyStateSize emptyState;
  final HyperTextFieldSize textField;
  final HyperDialogSize dialog;
  final HyperMessageSize toast;
  final HyperMessageSize snackbar;
  final HyperLoadingOverlaySize loadingOverlay;
  final HyperNotificationCenterSize notificationCenter;
  final HyperCollapsibleSize collapsible;
  final HyperAccordionSize accordion;
  final HyperPaginationSize pagination;
  final HyperStepSize stepIndicator;
  final HyperStepSize stepperNavigation;
  final HyperTimelineSize timeline;
  final HyperNotificationSize notification;
  final HyperNoticeSize alert;
  final HyperNoticeSize banner;
  final HyperBottomSheetSize bottomSheet;
  final HyperChipSize chip;
  final HyperWidgetGroupSize widgetGroup;
  final HyperIconButtonSize iconButton;
  final HyperCheckboxSize checkbox;
  final HyperRadioSize radio;
  final HyperSwitchSize switchSize;
  final HyperSliderSize slider;
  final HyperDividerSize divider;
  final HyperIconSize icon;
  final HyperProgressSize progress;

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
    HyperBreadcrumbSize? breadcrumb,
    HyperListTileSize? listTile,
    double? toolbarCompactHeight,
    double? toolbarHeight,
    double? toolbarEmphasizedHeight,
    double? iconSize,
    HyperButtonSize? button,
    HyperBadgeSize? badge,
    HyperTagSize? tag,
    HyperAvatarSize? avatar,
    HyperSkeletonSize? skeleton,
    HyperEmptyStateSize? emptyState,
    HyperTextFieldSize? textField,
    HyperDialogSize? dialog,
    HyperMessageSize? toast,
    HyperMessageSize? snackbar,
    HyperLoadingOverlaySize? loadingOverlay,
    HyperNotificationCenterSize? notificationCenter,
    HyperCollapsibleSize? collapsible,
    HyperAccordionSize? accordion,
    HyperPaginationSize? pagination,
    HyperStepSize? stepIndicator,
    HyperStepSize? stepperNavigation,
    HyperTimelineSize? timeline,
    HyperNotificationSize? notification,
    HyperNoticeSize? alert,
    HyperNoticeSize? banner,
    HyperBottomSheetSize? bottomSheet,
    HyperChipSize? chip,
    HyperWidgetGroupSize? widgetGroup,
    HyperIconButtonSize? iconButton,
    HyperCheckboxSize? checkbox,
    HyperRadioSize? radio,
    HyperSwitchSize? switchSize,
    HyperSliderSize? slider,
    HyperDividerSize? divider,
    HyperIconSize? icon,
    HyperProgressSize? progress,
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
    breadcrumb: breadcrumb ?? this.breadcrumb,
    listTile: listTile ?? this.listTile,
    toolbarCompactHeight: toolbarCompactHeight ?? this.toolbarCompactHeight,
    toolbarHeight: toolbarHeight ?? this.toolbarHeight,
    toolbarEmphasizedHeight:
        toolbarEmphasizedHeight ?? this.toolbarEmphasizedHeight,
    iconSize: iconSize ?? this.iconSize,
    button: button ?? this.button,
    badge: badge ?? this.badge,
    tag: tag ?? this.tag,
    avatar: avatar ?? this.avatar,
    skeleton: skeleton ?? this.skeleton,
    emptyState: emptyState ?? this.emptyState,
    textField: textField ?? this.textField,
    dialog: dialog ?? this.dialog,
    toast: toast ?? this.toast,
    snackbar: snackbar ?? this.snackbar,
    loadingOverlay: loadingOverlay ?? this.loadingOverlay,
    notificationCenter: notificationCenter ?? this.notificationCenter,
    collapsible: collapsible ?? this.collapsible,
    accordion: accordion ?? this.accordion,
    pagination: pagination ?? this.pagination,
    stepIndicator: stepIndicator ?? this.stepIndicator,
    stepperNavigation: stepperNavigation ?? this.stepperNavigation,
    timeline: timeline ?? this.timeline,
    notification: notification ?? this.notification,
    alert: alert ?? this.alert,
    banner: banner ?? this.banner,
    bottomSheet: bottomSheet ?? this.bottomSheet,
    chip: chip ?? this.chip,
    widgetGroup: widgetGroup ?? this.widgetGroup,
    iconButton: iconButton ?? this.iconButton,
    checkbox: checkbox ?? this.checkbox,
    radio: radio ?? this.radio,
    switchSize: switchSize ?? this.switchSize,
    slider: slider ?? this.slider,
    divider: divider ?? this.divider,
    icon: icon ?? this.icon,
    progress: progress ?? this.progress,
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
      dialog: HyperDialogSize.lerp(a.dialog, b.dialog, t),
      toast: HyperMessageSize.lerp(a.toast, b.toast, t),
      snackbar: HyperMessageSize.lerp(a.snackbar, b.snackbar, t),
      loadingOverlay: HyperLoadingOverlaySize.lerp(
        a.loadingOverlay,
        b.loadingOverlay,
        t,
      ),
      notificationCenter: HyperNotificationCenterSize.lerp(
        a.notificationCenter,
        b.notificationCenter,
        t,
      ),
      collapsible: HyperCollapsibleSize.lerp(a.collapsible, b.collapsible, t),
      accordion: HyperAccordionSize.lerp(a.accordion, b.accordion, t),
      pagination: HyperPaginationSize.lerp(a.pagination, b.pagination, t),
      stepIndicator: HyperStepSize.lerp(a.stepIndicator, b.stepIndicator, t),
      stepperNavigation: HyperStepSize.lerp(
        a.stepperNavigation,
        b.stepperNavigation,
        t,
      ),
      timeline: HyperTimelineSize.lerp(a.timeline, b.timeline, t),
      notification: HyperNotificationSize.lerp(
        a.notification,
        b.notification,
        t,
      ),
      alert: HyperNoticeSize.lerp(a.alert, b.alert, t),
      banner: HyperNoticeSize.lerp(a.banner, b.banner, t),
      bottomSheet: HyperBottomSheetSize.lerp(a.bottomSheet, b.bottomSheet, t),
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
      breadcrumb: HyperBreadcrumbSize.lerp(a.breadcrumb, b.breadcrumb, t),
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
      badge: HyperBadgeSize.lerp(a.badge, b.badge, t),
      tag: HyperTagSize.lerp(a.tag, b.tag, t),
      avatar: HyperAvatarSize.lerp(a.avatar, b.avatar, t),
      skeleton: HyperSkeletonSize.lerp(a.skeleton, b.skeleton, t),
      emptyState: HyperEmptyStateSize.lerp(a.emptyState, b.emptyState, t),
      textField: HyperTextFieldSize.lerp(a.textField, b.textField, t),
      chip: HyperChipSize.lerp(a.chip, b.chip, t),
      widgetGroup: HyperWidgetGroupSize.lerp(a.widgetGroup, b.widgetGroup, t),
      iconButton: HyperIconButtonSize.lerp(a.iconButton, b.iconButton, t),
      checkbox: HyperCheckboxSize.lerp(a.checkbox, b.checkbox, t),
      radio: HyperRadioSize.lerp(a.radio, b.radio, t),
      switchSize: HyperSwitchSize.lerp(a.switchSize, b.switchSize, t),
      slider: HyperSliderSize.lerp(a.slider, b.slider, t),
      divider: HyperDividerSize.lerp(a.divider, b.divider, t),
      icon: HyperIconSize.lerp(a.icon, b.icon, t),
      progress: HyperProgressSize.lerp(a.progress, b.progress, t),
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
          other.breadcrumb == breadcrumb &&
          other.listTile == listTile &&
          other.toolbarCompactHeight == toolbarCompactHeight &&
          other.toolbarHeight == toolbarHeight &&
          other.toolbarEmphasizedHeight == toolbarEmphasizedHeight &&
          other.iconSize == iconSize &&
          other.button == button &&
          other.badge == badge &&
          other.tag == tag &&
          other.avatar == avatar &&
          other.skeleton == skeleton &&
          other.emptyState == emptyState &&
          other.textField == textField &&
          other.dialog == dialog &&
          other.toast == toast &&
          other.snackbar == snackbar &&
          other.loadingOverlay == loadingOverlay &&
          other.notificationCenter == notificationCenter &&
          other.collapsible == collapsible &&
          other.accordion == accordion &&
          other.pagination == pagination &&
          other.stepIndicator == stepIndicator &&
          other.stepperNavigation == stepperNavigation &&
          other.timeline == timeline &&
          other.notification == notification &&
          other.alert == alert &&
          other.banner == banner &&
          other.bottomSheet == bottomSheet &&
          other.chip == chip &&
          other.widgetGroup == widgetGroup &&
          other.iconButton == iconButton &&
          other.checkbox == checkbox &&
          other.radio == radio &&
          other.switchSize == switchSize &&
          other.slider == slider &&
          other.divider == divider &&
          other.icon == icon &&
          other.progress == progress;

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
    breadcrumb,
    listTile,
    toolbarCompactHeight,
    toolbarHeight,
    toolbarEmphasizedHeight,
    iconSize,
    button,
    badge,
    tag,
    avatar,
    skeleton,
    emptyState,
    textField,
    dialog,
    toast,
    snackbar,
    loadingOverlay,
    notificationCenter,
    collapsible,
    accordion,
    pagination,
    stepIndicator,
    stepperNavigation,
    timeline,
    notification,
    alert,
    banner,
    bottomSheet,
    chip,
    widgetGroup,
    iconButton,
    checkbox,
    radio,
    switchSize,
    slider,
    divider,
    icon,
    progress,
  ]);
}
