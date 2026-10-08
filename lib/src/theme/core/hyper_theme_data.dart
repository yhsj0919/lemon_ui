import '../../components/timeline/hyper_timeline_theme.dart';
import '../../components/steps/hyper_stepper_navigation_theme.dart';
import '../../components/steps/hyper_step_indicator_theme.dart';
import '../../components/pagination/hyper_pagination_theme.dart';
import '../../components/collapsible/hyper_accordion_theme.dart';
import '../../components/collapsible/hyper_collapsible_theme.dart';
import '../../components/notification/hyper_notification_center_theme.dart';
import '../../components/notification/hyper_notification_theme.dart';
import '../../components/loading_overlay/hyper_loading_overlay_theme.dart';
import '../../components/notice/hyper_alert_theme.dart';
import '../../components/notice/hyper_banner_theme.dart';
import '../../components/message/hyper_toast_theme.dart';
import '../../components/message/hyper_snackbar_theme.dart';
import '../../components/text_field/hyper_text_field_theme.dart';
import '../../components/dialog/hyper_dialog_theme.dart';
import '../../components/bottom_sheet/hyper_bottom_sheet_theme.dart';
import '../../components/segmented_button/hyper_segmented_button_theme.dart';
import '../../components/chip/hyper_chip_theme.dart';
import '../../components/empty_state/hyper_empty_state_theme.dart';
import '../../components/skeleton/hyper_skeleton_theme.dart';
import '../../components/avatar/hyper_avatar_theme.dart';

import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';

import '../../foundation/hyper_surface_material.dart';
import '../../components/button/hyper_button_theme.dart';
import '../../components/badge/hyper_badge_theme.dart';
import '../../components/tag/hyper_tag_theme.dart';
import '../../components/widget_group/hyper_widget_group_theme.dart';
import '../../components/breadcrumb/hyper_breadcrumb_theme.dart';
import '../../components/app_bar/hyper_app_bar_theme.dart';
import '../../components/card/hyper_card_theme.dart';
import '../../components/card/hyper_titled_card_theme.dart';
import '../../components/checkbox/hyper_checkbox_theme.dart';
import '../../components/container/hyper_container_theme.dart';
import '../../components/divider/hyper_divider_theme.dart';
import '../../components/drawer/hyper_drawer_theme.dart';
import '../../components/sidebar/hyper_sidebar_theme.dart';
import '../../components/icon/hyper_icon_theme.dart';
import '../../components/icon_button/hyper_icon_button_theme.dart';
import '../../components/list_tile/hyper_list_tile_theme.dart';
import '../../components/menu/hyper_menu_theme.dart';
import '../../components/menu/hyper_dropdown_menu_theme.dart';
import '../../components/progress/hyper_progress_theme.dart';
import '../../components/radio/hyper_radio_theme.dart';
import '../../components/scaffold/hyper_scaffold_theme.dart';
import '../../components/switch/hyper_switch_theme.dart';
import '../../components/slider/hyper_slider_theme.dart';
import '../../components/text/hyper_text_theme.dart';
import '../color/hyper_color_scheme.dart';
import '../color/hyper_contrast_theme.dart';
import '../material/hyper_material_theme.dart';
import '../motion/hyper_motion_theme.dart';
import '../size/hyper_size_theme_data.dart';
import '../typography/hyper_typography_scheme.dart';
import '../typography/hyper_typography_theme_data.dart';

/// 返回当前平台原生 UI 字体，不依赖随 Flutter 或应用打包的字体文件。
String _systemFontFamily() => switch (defaultTargetPlatform) {
  TargetPlatform.windows => 'Microsoft YaHei UI',
  TargetPlatform.macOS => '.AppleSystemUIFont',
  TargetPlatform.iOS => '.SF UI Text',
  TargetPlatform.android => 'sans-serif',
  TargetPlatform.linux => 'sans-serif',
  TargetPlatform.fuchsia => 'sans-serif',
};

/// 中文字体放在前面，桌面端缺少某个字体时仍能回退到系统字库。
List<String> _systemFontFallback() => switch (defaultTargetPlatform) {
  TargetPlatform.windows => const ['Microsoft YaHei', 'Segoe UI'],
  TargetPlatform.macOS ||
  TargetPlatform.iOS => const ['PingFang SC', 'Helvetica Neue'],
  TargetPlatform.android => const ['Noto Sans CJK SC', 'Noto Sans SC'],
  TargetPlatform.linux => const ['Noto Sans CJK SC', 'Noto Sans'],
  TargetPlatform.fuchsia => const ['Noto Sans'],
};

/// Lemon UI 的完整主题数据。
///
/// 所有数值都是 Flutter 逻辑尺寸。主题只负责选择离散默认值，不对实例
/// 显式值进行倍率缩放。
@immutable
final class HyperThemeData extends ThemeExtension<HyperThemeData> {
  const HyperThemeData({
    required this.colors,
    required this.textTheme,
    required this.sizes,
    this.typography = const HyperTypographyScheme(),
    this.typographyTheme = const HyperTypographyThemeData(),
    required this.motion,
    required this.containerTheme,
    this.scaffoldTheme = const HyperScaffoldThemeData(),
    this.appBarTheme = const HyperAppBarThemeData(),
    this.drawerTheme = const HyperDrawerThemeData(),
    this.sidebarTheme = const HyperSidebarThemeData(),
    this.menuTheme = const HyperMenuThemeData(),
    this.dropdownMenuTheme = const HyperDropdownMenuThemeData(),
    this.breadcrumbTheme = const HyperBreadcrumbThemeData(),
    this.cardTheme = const HyperCardThemeData(),
    this.titledCardTheme = const HyperTitledCardThemeData(),
    this.buttonTheme = const HyperButtonThemeData(),
    this.badgeTheme = const HyperBadgeThemeData(),
    this.tagTheme = const HyperTagThemeData(),
    this.avatarTheme = const HyperAvatarThemeData(),
    this.skeletonTheme = const HyperSkeletonThemeData(),
    this.emptyStateTheme = const HyperEmptyStateThemeData(),
    this.segmentedButtonTheme = const HyperSegmentedButtonThemeData(),
    this.textFieldTheme = const HyperTextFieldThemeData(),
    this.dialogTheme = const HyperDialogThemeData(),
    this.toastTheme = const HyperToastThemeData(),
    this.snackbarTheme = const HyperSnackbarThemeData(),
    this.loadingOverlayTheme = const HyperLoadingOverlayThemeData(),
    this.notificationCenterTheme = const HyperNotificationCenterThemeData(),
    this.collapsibleTheme = const HyperCollapsibleThemeData(),
    this.accordionTheme = const HyperAccordionThemeData(),
    this.paginationTheme = const HyperPaginationThemeData(),
    this.stepIndicatorTheme = const HyperStepIndicatorThemeData(),
    this.stepperNavigationTheme = const HyperStepperNavigationThemeData(),
    this.timelineTheme = const HyperTimelineThemeData(),
    this.notificationTheme = const HyperNotificationThemeData(),
    this.alertTheme = const HyperAlertThemeData(),
    this.bannerTheme = const HyperBannerThemeData(),
    this.bottomSheetTheme = const HyperBottomSheetThemeData(),
    this.chipTheme = const HyperChipThemeData(),
    this.widgetGroupTheme = const HyperWidgetGroupThemeData(),
    this.iconButtonTheme = const HyperIconButtonThemeData(),
    this.iconTheme = const HyperIconThemeData(),
    this.dividerTheme = const HyperDividerThemeData(),
    this.progressTheme = const HyperProgressThemeData(),
    this.switchTheme = const HyperSwitchThemeData(),
    this.sliderTheme = const HyperSliderThemeData(),
    this.checkboxTheme = const HyperCheckboxThemeData(),
    this.radioTheme = const HyperRadioThemeData(),
    this.listTileTheme = const HyperListTileThemeData(),
    this.textComponentTheme = const HyperTextThemeData(),
    this.materialTheme = const HyperMaterialThemeData(
      quality: HyperMaterialQuality.advanced,
    ),
    this.contrastTheme = const HyperContrastThemeData(),
  });

  factory HyperThemeData.light({
    Color seedColor = const Color(0xFF3482FF),
    HyperSizeThemeData sizes = const HyperSizeThemeData(),
    HyperTypographyScheme? typography,
    HyperTypographyThemeData typographyTheme = const HyperTypographyThemeData(),
  }) => HyperThemeData.fromSeed(
    seedColor: seedColor,
    sizes: sizes,
    typography: typography,
    typographyTheme: typographyTheme,
  );

  factory HyperThemeData.dark({
    Color seedColor = const Color(0xFF3482FF),
    HyperSizeThemeData sizes = const HyperSizeThemeData(),
    HyperTypographyScheme? typography,
    HyperTypographyThemeData typographyTheme = const HyperTypographyThemeData(),
  }) => HyperThemeData.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
    sizes: sizes,
    typography: typography,
    typographyTheme: typographyTheme,
  );

  /// 从种子色和一套明确尺寸创建开箱即用的完整主题。
  factory HyperThemeData.fromSeed({
    required Color seedColor,
    Brightness brightness = Brightness.light,
    HyperSizeThemeData sizes = const HyperSizeThemeData(),
    HyperTypographyScheme? typography,
    HyperTypographyThemeData typographyTheme = const HyperTypographyThemeData(),
  }) {
    final resolvedTypography = typography ?? typographyTheme.phone;
    final resolvedTypographyTheme = typography == null
        ? typographyTheme
        : HyperTypographyThemeData.uniform(typography);
    final colors = HyperColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    final material = ThemeData(
      colorScheme: colors.toMaterialColorScheme(),
      useMaterial3: true,
      fontFamily: _systemFontFamily(),
      fontFamilyFallback: _systemFontFallback(),
    );
    return HyperThemeData(
      colors: colors,
      textTheme: resolvedTypography.applyTo(material.textTheme),
      sizes: sizes,
      typography: resolvedTypography,
      typographyTheme: resolvedTypographyTheme,
      motion: const HyperMotionThemeData(),
      containerTheme: HyperContainerThemeData(),
      scaffoldTheme: const HyperScaffoldThemeData(),
      appBarTheme: const HyperAppBarThemeData(),
      drawerTheme: const HyperDrawerThemeData(),
      sidebarTheme: const HyperSidebarThemeData(),
      menuTheme: const HyperMenuThemeData(),
      cardTheme: const HyperCardThemeData(),
      titledCardTheme: const HyperTitledCardThemeData(),
      buttonTheme: const HyperButtonThemeData(),
      badgeTheme: const HyperBadgeThemeData(),
      tagTheme: const HyperTagThemeData(),
      avatarTheme: const HyperAvatarThemeData(),
      widgetGroupTheme: const HyperWidgetGroupThemeData(),
      iconButtonTheme: const HyperIconButtonThemeData(),
      iconTheme: const HyperIconThemeData(),
      dividerTheme: const HyperDividerThemeData(),
      progressTheme: const HyperProgressThemeData(),
      switchTheme: const HyperSwitchThemeData(),
      sliderTheme: const HyperSliderThemeData(),
      checkboxTheme: const HyperCheckboxThemeData(),
      radioTheme: const HyperRadioThemeData(),
      listTileTheme: const HyperListTileThemeData(),
      textComponentTheme: const HyperTextThemeData(),
      materialTheme: const HyperMaterialThemeData(
        quality: HyperMaterialQuality.advanced,
      ),
      contrastTheme: const HyperContrastThemeData(),
    );
  }

  /// 从当前 Flutter Material 主题建立 Hyper 主题回退值。
  factory HyperThemeData.fromMaterial(
    ThemeData material, {
    HyperSizeThemeData sizes = const HyperSizeThemeData(),
    HyperTypographyScheme? typography,
    HyperTypographyThemeData typographyTheme = const HyperTypographyThemeData(),
  }) {
    final resolvedTypography = typography ?? typographyTheme.phone;
    final resolvedTypographyTheme = typography == null
        ? typographyTheme
        : HyperTypographyThemeData.uniform(typography);
    final colorScheme = material.colorScheme;
    final colors =
        HyperColorScheme.fromSeed(
          seedColor: colorScheme.primary,
          brightness: colorScheme.brightness,
        ).copyWith(
          primary: colorScheme.primary,
          onPrimary: colorScheme.onPrimary,
          primaryContainer: colorScheme.primaryContainer,
          onPrimaryContainer: colorScheme.onPrimaryContainer,
          background: colorScheme.surface,
          onBackground: colorScheme.onSurface,
          surface: colorScheme.surfaceContainer,
          onSurface: colorScheme.onSurface,
          surfaceElevated: colorScheme.surfaceContainerHigh,
          onSurfaceElevated: colorScheme.onSurface,
          surfaceMuted: colorScheme.surfaceContainerHighest,
          onSurfaceMuted: colorScheme.onSurface,
          textPrimary: colorScheme.onSurface,
          textSecondary: colorScheme.onSurfaceVariant,
          textTertiary: colorScheme.onSurfaceVariant.withValues(alpha: 0.72),
          outline: colorScheme.outline,
          scrim: colorScheme.scrim,
          error: colorScheme.error,
          onError: colorScheme.onError,
        );
    return HyperThemeData(
      colors: colors,
      textTheme: resolvedTypography.applyTo(material.textTheme),
      sizes: sizes,
      typography: resolvedTypography,
      typographyTheme: resolvedTypographyTheme,
      motion: const HyperMotionThemeData(),
      containerTheme: HyperContainerThemeData(),
      scaffoldTheme: const HyperScaffoldThemeData(),
      appBarTheme: const HyperAppBarThemeData(),
      drawerTheme: const HyperDrawerThemeData(),
      sidebarTheme: const HyperSidebarThemeData(),
      menuTheme: const HyperMenuThemeData(),
      cardTheme: const HyperCardThemeData(),
      titledCardTheme: const HyperTitledCardThemeData(),
      buttonTheme: const HyperButtonThemeData(),
      badgeTheme: const HyperBadgeThemeData(),
      tagTheme: const HyperTagThemeData(),
      avatarTheme: const HyperAvatarThemeData(),
      widgetGroupTheme: const HyperWidgetGroupThemeData(),
      iconButtonTheme: const HyperIconButtonThemeData(),
      iconTheme: const HyperIconThemeData(),
      dividerTheme: const HyperDividerThemeData(),
      progressTheme: const HyperProgressThemeData(),
      switchTheme: const HyperSwitchThemeData(),
      sliderTheme: const HyperSliderThemeData(),
      checkboxTheme: const HyperCheckboxThemeData(),
      radioTheme: const HyperRadioThemeData(),
      listTileTheme: const HyperListTileThemeData(),
      textComponentTheme: const HyperTextThemeData(),
      materialTheme: const HyperMaterialThemeData(
        quality: HyperMaterialQuality.advanced,
      ),
      contrastTheme: const HyperContrastThemeData(),
    );
  }

  /// 全局语义颜色。
  final HyperColorScheme colors;

  /// 已应用系统字体和字号规范的 Flutter 文字主题。
  final TextTheme textTheme;

  /// 四类设备的全局尺寸配置；当前端由 [HyperTheme] 解析。
  final HyperSizeThemeData sizes;

  /// 全局语义字号；数值明确且不参与倍率缩放。
  final HyperTypographyScheme typography;

  /// 四端字阶模板；[HyperTheme] 将当前端解析到 [typography]。
  final HyperTypographyThemeData typographyTheme;

  /// 全局统一动画参数。
  /// 全局动画时长、曲线和弹簧参数。
  final HyperMotionThemeData motion;

  /// 全局容器主题。
  final HyperContainerThemeData containerTheme;

  /// 页面框架的全局视觉主题。
  final HyperScaffoldThemeData scaffoldTheme;

  /// 固定与滚动顶部应用栏的全局主题。
  final HyperAppBarThemeData appBarTheme;

  /// 全局通用抽屉主题。
  final HyperDrawerThemeData drawerTheme;

  /// 全局树形侧栏主题。
  final HyperSidebarThemeData sidebarTheme;

  /// 全局弹出菜单主题。
  final HyperMenuThemeData menuTheme;

  /// 全局下拉选择器主题。
  final HyperDropdownMenuThemeData dropdownMenuTheme;

  /// 全局面包屑视觉主题。
  final HyperBreadcrumbThemeData breadcrumbTheme;

  /// 全局 Card 主题，与 Container 主题相互独立。
  final HyperCardThemeData cardTheme;

  /// 带标题卡片的标题行主题。
  final HyperTitledCardThemeData titledCardTheme;

  /// 全局按钮主题。
  final HyperButtonThemeData buttonTheme;

  /// 全局徽标主题。
  final HyperBadgeThemeData badgeTheme;
  final HyperTagThemeData tagTheme;
  final HyperAvatarThemeData avatarTheme;
  final HyperSkeletonThemeData skeletonTheme;
  final HyperEmptyStateThemeData emptyStateTheme;
  final HyperSegmentedButtonThemeData segmentedButtonTheme;
  final HyperTextFieldThemeData textFieldTheme;
  final HyperDialogThemeData dialogTheme;
  final HyperToastThemeData toastTheme;
  final HyperSnackbarThemeData snackbarTheme;
  final HyperLoadingOverlayThemeData loadingOverlayTheme;
  final HyperNotificationCenterThemeData notificationCenterTheme;
  final HyperCollapsibleThemeData collapsibleTheme;
  final HyperAccordionThemeData accordionTheme;
  final HyperPaginationThemeData paginationTheme;
  final HyperStepIndicatorThemeData stepIndicatorTheme;
  final HyperStepperNavigationThemeData stepperNavigationTheme;
  final HyperTimelineThemeData timelineTheme;
  final HyperNotificationThemeData notificationTheme;
  final HyperAlertThemeData alertTheme;
  final HyperBannerThemeData bannerTheme;
  final HyperBottomSheetThemeData bottomSheetTheme;
  final HyperChipThemeData chipTheme;
  final HyperWidgetGroupThemeData widgetGroupTheme;

  /// 全局图标按钮主题。
  final HyperIconButtonThemeData iconButtonTheme;

  /// 全局基础图标主题，不与图标按钮主题共用。
  final HyperIconThemeData iconTheme;

  /// 全局分隔线主题，不直接复用 Material DividerTheme。
  final HyperDividerThemeData dividerTheme;

  /// 全局基础进度指示器主题。
  final HyperProgressThemeData progressTheme;

  /// 全局开关主题。
  final HyperSwitchThemeData switchTheme;
  final HyperSliderThemeData sliderTheme;

  /// 全局复选框主题。
  final HyperCheckboxThemeData checkboxTheme;

  /// 全局单选控件主题。
  final HyperRadioThemeData radioTheme;

  /// 全局基础列表项主题。
  final HyperListTileThemeData listTileTheme;

  /// 全局 HyperText 控件主题；基础字体和字号仍由 [textTheme] 提供。
  final HyperTextThemeData textComponentTheme;

  /// 全局材质质量和默认材质。
  final HyperMaterialThemeData materialTheme;

  /// 全局前景反色策略。
  final HyperContrastThemeData contrastTheme;

  Brightness get brightness => colors.brightness;

  ThemeData toMaterialThemeData([ThemeData? base]) {
    final material = base ?? ThemeData(brightness: brightness);
    return material.copyWith(
      brightness: brightness,
      colorScheme: colors.toMaterialColorScheme(),
      textTheme: textTheme,
      scaffoldBackgroundColor: colors.background,
      canvasColor: colors.surface,
      cardColor: colors.surface,
      dividerColor: colors.outline,
      splashColor: colors.stateLayer.withValues(alpha: 0.12),
      highlightColor: colors.stateLayer.withValues(alpha: 0.08),
      hoverColor: colors.stateLayer.withValues(alpha: 0.06),
      focusColor: colors.stateLayer.withValues(alpha: 0.12),
      appBarTheme: material.appBarTheme.copyWith(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      drawerTheme: material.drawerTheme.copyWith(
        backgroundColor: colors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: material.dialogTheme.copyWith(
        backgroundColor: colors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        barrierColor: colors.scrim,
      ),
      bottomSheetTheme: material.bottomSheetTheme.copyWith(
        backgroundColor: colors.surfaceElevated,
        modalBackgroundColor: colors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        modalBarrierColor: colors.scrim,
      ),
      cardTheme: material.cardTheme.copyWith(
        color: colors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: material.dividerTheme.copyWith(color: colors.outline),
      extensions: [
        ...material.extensions.values.where(
          (extension) => extension is! HyperThemeData,
        ),
        this,
      ],
    );
  }

  @override
  HyperThemeData copyWith({
    HyperColorScheme? colors,
    TextTheme? textTheme,
    HyperSizeThemeData? sizes,
    HyperTypographyScheme? typography,
    HyperTypographyThemeData? typographyTheme,
    HyperMotionThemeData? motion,
    HyperContainerThemeData? containerTheme,
    HyperScaffoldThemeData? scaffoldTheme,
    HyperAppBarThemeData? appBarTheme,
    HyperDrawerThemeData? drawerTheme,
    HyperSidebarThemeData? sidebarTheme,
    HyperMenuThemeData? menuTheme,
    HyperDropdownMenuThemeData? dropdownMenuTheme,
    HyperBreadcrumbThemeData? breadcrumbTheme,
    HyperCardThemeData? cardTheme,
    HyperTitledCardThemeData? titledCardTheme,
    HyperButtonThemeData? buttonTheme,
    HyperBadgeThemeData? badgeTheme,
    HyperTagThemeData? tagTheme,
    HyperAvatarThemeData? avatarTheme,
    HyperSkeletonThemeData? skeletonTheme,
    HyperEmptyStateThemeData? emptyStateTheme,
    HyperSegmentedButtonThemeData? segmentedButtonTheme,
    HyperTextFieldThemeData? textFieldTheme,
    HyperDialogThemeData? dialogTheme,
    HyperToastThemeData? toastTheme,
    HyperSnackbarThemeData? snackbarTheme,
    HyperLoadingOverlayThemeData? loadingOverlayTheme,
    HyperNotificationCenterThemeData? notificationCenterTheme,
    HyperCollapsibleThemeData? collapsibleTheme,
    HyperAccordionThemeData? accordionTheme,
    HyperPaginationThemeData? paginationTheme,
    HyperStepIndicatorThemeData? stepIndicatorTheme,
    HyperStepperNavigationThemeData? stepperNavigationTheme,
    HyperTimelineThemeData? timelineTheme,
    HyperNotificationThemeData? notificationTheme,
    HyperAlertThemeData? alertTheme,
    HyperBannerThemeData? bannerTheme,
    HyperBottomSheetThemeData? bottomSheetTheme,
    HyperChipThemeData? chipTheme,
    HyperWidgetGroupThemeData? widgetGroupTheme,
    HyperIconButtonThemeData? iconButtonTheme,
    HyperIconThemeData? iconTheme,
    HyperDividerThemeData? dividerTheme,
    HyperProgressThemeData? progressTheme,
    HyperSwitchThemeData? switchTheme,
    HyperSliderThemeData? sliderTheme,
    HyperCheckboxThemeData? checkboxTheme,
    HyperRadioThemeData? radioTheme,
    HyperListTileThemeData? listTileTheme,
    HyperTextThemeData? textComponentTheme,
    HyperMaterialThemeData? materialTheme,
    HyperContrastThemeData? contrastTheme,
  }) {
    final resolvedTypography =
        typography ?? typographyTheme?.phone ?? this.typography;
    final resolvedTypographyTheme =
        typographyTheme ??
        (typography == null
            ? this.typographyTheme
            : HyperTypographyThemeData.uniform(typography));
    final resolvedTextTheme =
        textTheme ??
        (typography == null && typographyTheme == null
            ? this.textTheme
            : resolvedTypography.applyTo(this.textTheme));
    return HyperThemeData(
      colors: colors ?? this.colors,
      textTheme: resolvedTextTheme,
      sizes: sizes ?? this.sizes,
      typography: resolvedTypography,
      typographyTheme: resolvedTypographyTheme,
      motion: motion ?? this.motion,
      containerTheme: containerTheme ?? this.containerTheme,
      scaffoldTheme: scaffoldTheme ?? this.scaffoldTheme,
      appBarTheme: appBarTheme ?? this.appBarTheme,
      drawerTheme: drawerTheme ?? this.drawerTheme,
      sidebarTheme: sidebarTheme ?? this.sidebarTheme,
      menuTheme: menuTheme ?? this.menuTheme,
      dropdownMenuTheme: dropdownMenuTheme ?? this.dropdownMenuTheme,
      breadcrumbTheme: breadcrumbTheme ?? this.breadcrumbTheme,
      cardTheme: cardTheme ?? this.cardTheme,
      titledCardTheme: titledCardTheme ?? this.titledCardTheme,
      buttonTheme: buttonTheme ?? this.buttonTheme,
      badgeTheme: badgeTheme ?? this.badgeTheme,
      tagTheme: tagTheme ?? this.tagTheme,
      avatarTheme: avatarTheme ?? this.avatarTheme,
      skeletonTheme: skeletonTheme ?? this.skeletonTheme,
      emptyStateTheme: emptyStateTheme ?? this.emptyStateTheme,
      segmentedButtonTheme: segmentedButtonTheme ?? this.segmentedButtonTheme,
      textFieldTheme: textFieldTheme ?? this.textFieldTheme,
      dialogTheme: dialogTheme ?? this.dialogTheme,
      toastTheme: toastTheme ?? this.toastTheme,
      snackbarTheme: snackbarTheme ?? this.snackbarTheme,
      loadingOverlayTheme: loadingOverlayTheme ?? this.loadingOverlayTheme,
      notificationCenterTheme:
          notificationCenterTheme ?? this.notificationCenterTheme,
      collapsibleTheme: collapsibleTheme ?? this.collapsibleTheme,
      accordionTheme: accordionTheme ?? this.accordionTheme,
      paginationTheme: paginationTheme ?? this.paginationTheme,
      stepIndicatorTheme: stepIndicatorTheme ?? this.stepIndicatorTheme,
      stepperNavigationTheme:
          stepperNavigationTheme ?? this.stepperNavigationTheme,
      timelineTheme: timelineTheme ?? this.timelineTheme,
      notificationTheme: notificationTheme ?? this.notificationTheme,
      alertTheme: alertTheme ?? this.alertTheme,
      bannerTheme: bannerTheme ?? this.bannerTheme,
      bottomSheetTheme: bottomSheetTheme ?? this.bottomSheetTheme,
      chipTheme: chipTheme ?? this.chipTheme,
      widgetGroupTheme: widgetGroupTheme ?? this.widgetGroupTheme,
      iconButtonTheme: iconButtonTheme ?? this.iconButtonTheme,
      iconTheme: iconTheme ?? this.iconTheme,
      dividerTheme: dividerTheme ?? this.dividerTheme,
      progressTheme: progressTheme ?? this.progressTheme,
      switchTheme: switchTheme ?? this.switchTheme,
      sliderTheme: sliderTheme ?? this.sliderTheme,
      checkboxTheme: checkboxTheme ?? this.checkboxTheme,
      radioTheme: radioTheme ?? this.radioTheme,
      listTileTheme: listTileTheme ?? this.listTileTheme,
      textComponentTheme: textComponentTheme ?? this.textComponentTheme,
      materialTheme: materialTheme ?? this.materialTheme,
      contrastTheme: contrastTheme ?? this.contrastTheme,
    );
  }

  @override
  HyperThemeData lerp(covariant HyperThemeData? other, double t) {
    if (other == null || t == 0) return this;
    if (t == 1) return other;
    return HyperThemeData(
      colors: HyperColorScheme.lerp(colors, other.colors, t),
      textTheme: TextTheme.lerp(textTheme, other.textTheme, t),
      sizes: HyperSizeThemeData.lerp(sizes, other.sizes, t),
      typography: HyperTypographyScheme.lerp(typography, other.typography, t),
      typographyTheme: HyperTypographyThemeData.lerp(
        typographyTheme,
        other.typographyTheme,
        t,
      ),
      motion: HyperMotionThemeData.lerp(motion, other.motion, t),
      containerTheme: HyperContainerThemeData.lerp(
        containerTheme,
        other.containerTheme,
        t,
      ),
      scaffoldTheme: HyperScaffoldThemeData.lerp(
        scaffoldTheme,
        other.scaffoldTheme,
        t,
      ),
      appBarTheme: HyperAppBarThemeData.lerp(appBarTheme, other.appBarTheme, t),
      drawerTheme: HyperDrawerThemeData.lerp(drawerTheme, other.drawerTheme, t),
      dialogTheme: HyperDialogThemeData.lerp(dialogTheme, other.dialogTheme, t),
      toastTheme: HyperToastThemeData.lerp(toastTheme, other.toastTheme, t),
      snackbarTheme: HyperSnackbarThemeData.lerp(
        snackbarTheme,
        other.snackbarTheme,
        t,
      ),
      loadingOverlayTheme: HyperLoadingOverlayThemeData.lerp(
        loadingOverlayTheme,
        other.loadingOverlayTheme,
        t,
      ),
      notificationCenterTheme: HyperNotificationCenterThemeData.lerp(
        notificationCenterTheme,
        other.notificationCenterTheme,
        t,
      ),
      collapsibleTheme: HyperCollapsibleThemeData.lerp(
        collapsibleTheme,
        other.collapsibleTheme,
        t,
      ),
      accordionTheme: HyperAccordionThemeData.lerp(
        accordionTheme,
        other.accordionTheme,
        t,
      ),
      paginationTheme: HyperPaginationThemeData.lerp(
        paginationTheme,
        other.paginationTheme,
        t,
      ),
      stepIndicatorTheme: HyperStepIndicatorThemeData.lerp(
        stepIndicatorTheme,
        other.stepIndicatorTheme,
        t,
      ),
      stepperNavigationTheme: HyperStepperNavigationThemeData.lerp(
        stepperNavigationTheme,
        other.stepperNavigationTheme,
        t,
      ),
      timelineTheme: HyperTimelineThemeData.lerp(
        timelineTheme,
        other.timelineTheme,
        t,
      ),
      notificationTheme: HyperNotificationThemeData.lerp(
        notificationTheme,
        other.notificationTheme,
        t,
      ),
      alertTheme: HyperAlertThemeData.lerp(alertTheme, other.alertTheme, t),
      bannerTheme: HyperBannerThemeData.lerp(bannerTheme, other.bannerTheme, t),
      bottomSheetTheme: HyperBottomSheetThemeData.lerp(
        bottomSheetTheme,
        other.bottomSheetTheme,
        t,
      ),
      sidebarTheme: HyperSidebarThemeData.lerp(
        sidebarTheme,
        other.sidebarTheme,
        t,
      ),
      menuTheme: HyperMenuThemeData.lerp(menuTheme, other.menuTheme, t),
      dropdownMenuTheme: HyperDropdownMenuThemeData.lerp(
        dropdownMenuTheme,
        other.dropdownMenuTheme,
        t,
      ),
      breadcrumbTheme: HyperBreadcrumbThemeData.lerp(
        breadcrumbTheme,
        other.breadcrumbTheme,
        t,
      ),
      cardTheme: HyperCardThemeData.lerp(cardTheme, other.cardTheme, t),
      titledCardTheme: HyperTitledCardThemeData.lerp(
        titledCardTheme,
        other.titledCardTheme,
        t,
      ),
      buttonTheme: HyperButtonThemeData.lerp(buttonTheme, other.buttonTheme, t),
      badgeTheme: HyperBadgeThemeData.lerp(badgeTheme, other.badgeTheme, t),
      tagTheme: HyperTagThemeData.lerp(tagTheme, other.tagTheme, t),
      avatarTheme: HyperAvatarThemeData.lerp(avatarTheme, other.avatarTheme, t),
      segmentedButtonTheme: HyperSegmentedButtonThemeData.lerp(
        segmentedButtonTheme,
        other.segmentedButtonTheme,
        t,
      ),
      textFieldTheme: HyperTextFieldThemeData.lerp(
        textFieldTheme,
        other.textFieldTheme,
        t,
      ),
      chipTheme: HyperChipThemeData.lerp(chipTheme, other.chipTheme, t),
      emptyStateTheme: HyperEmptyStateThemeData.lerp(
        emptyStateTheme,
        other.emptyStateTheme,
        t,
      ),
      skeletonTheme: HyperSkeletonThemeData.lerp(
        skeletonTheme,
        other.skeletonTheme,
        t,
      ),
      widgetGroupTheme: HyperWidgetGroupThemeData.lerp(
        widgetGroupTheme,
        other.widgetGroupTheme,
        t,
      ),
      iconButtonTheme: HyperIconButtonThemeData.lerp(
        iconButtonTheme,
        other.iconButtonTheme,
        t,
      ),
      iconTheme: HyperIconThemeData.lerp(iconTheme, other.iconTheme, t),
      dividerTheme: HyperDividerThemeData.lerp(
        dividerTheme,
        other.dividerTheme,
        t,
      ),
      progressTheme: HyperProgressThemeData.lerp(
        progressTheme,
        other.progressTheme,
        t,
      ),
      switchTheme: HyperSwitchThemeData.lerp(switchTheme, other.switchTheme, t),
      sliderTheme: HyperSliderThemeData.lerp(sliderTheme, other.sliderTheme, t),
      checkboxTheme: HyperCheckboxThemeData.lerp(
        checkboxTheme,
        other.checkboxTheme,
        t,
      ),
      radioTheme: HyperRadioThemeData.lerp(radioTheme, other.radioTheme, t),
      listTileTheme: HyperListTileThemeData.lerp(
        listTileTheme,
        other.listTileTheme,
        t,
      ),
      textComponentTheme: HyperTextThemeData.lerp(
        textComponentTheme,
        other.textComponentTheme,
        t,
      ),
      materialTheme: HyperMaterialThemeData.lerp(
        materialTheme,
        other.materialTheme,
        t,
      ),
      contrastTheme: HyperContrastThemeData.lerp(
        contrastTheme,
        other.contrastTheme,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperThemeData &&
          other.colors == colors &&
          other.textTheme == textTheme &&
          other.sizes == sizes &&
          other.typography == typography &&
          other.typographyTheme == typographyTheme &&
          other.motion == motion &&
          other.containerTheme == containerTheme &&
          other.scaffoldTheme == scaffoldTheme &&
          other.appBarTheme == appBarTheme &&
          other.drawerTheme == drawerTheme &&
          other.sidebarTheme == sidebarTheme &&
          other.menuTheme == menuTheme &&
          other.dropdownMenuTheme == dropdownMenuTheme &&
          other.breadcrumbTheme == breadcrumbTheme &&
          other.cardTheme == cardTheme &&
          other.titledCardTheme == titledCardTheme &&
          other.buttonTheme == buttonTheme &&
          other.badgeTheme == badgeTheme &&
          other.skeletonTheme == skeletonTheme &&
          other.emptyStateTheme == emptyStateTheme &&
          other.segmentedButtonTheme == segmentedButtonTheme &&
          other.textFieldTheme == textFieldTheme &&
          other.dialogTheme == dialogTheme &&
          other.toastTheme == toastTheme &&
          other.snackbarTheme == snackbarTheme &&
          other.loadingOverlayTheme == loadingOverlayTheme &&
          other.notificationCenterTheme == notificationCenterTheme &&
          other.collapsibleTheme == collapsibleTheme &&
          other.accordionTheme == accordionTheme &&
          other.paginationTheme == paginationTheme &&
          other.stepIndicatorTheme == stepIndicatorTheme &&
          other.stepperNavigationTheme == stepperNavigationTheme &&
          other.timelineTheme == timelineTheme &&
          other.notificationTheme == notificationTheme &&
          other.alertTheme == alertTheme &&
          other.bannerTheme == bannerTheme &&
          other.bottomSheetTheme == bottomSheetTheme &&
          other.chipTheme == chipTheme &&
          other.avatarTheme == avatarTheme &&
          other.tagTheme == tagTheme &&
          other.widgetGroupTheme == widgetGroupTheme &&
          other.iconButtonTheme == iconButtonTheme &&
          other.iconTheme == iconTheme &&
          other.dividerTheme == dividerTheme &&
          other.progressTheme == progressTheme &&
          other.switchTheme == switchTheme &&
          other.sliderTheme == sliderTheme &&
          other.checkboxTheme == checkboxTheme &&
          other.radioTheme == radioTheme &&
          other.listTileTheme == listTileTheme &&
          other.textComponentTheme == textComponentTheme &&
          other.materialTheme == materialTheme &&
          other.contrastTheme == contrastTheme;

  @override
  int get hashCode => Object.hashAll([
    colors,
    textTheme,
    sizes,
    typography,
    typographyTheme,
    motion,
    containerTheme,
    scaffoldTheme,
    appBarTheme,
    drawerTheme,
    sidebarTheme,
    menuTheme,
    dropdownMenuTheme,
    breadcrumbTheme,
    cardTheme,
    titledCardTheme,
    buttonTheme,
    badgeTheme,
    skeletonTheme,
    emptyStateTheme,
    segmentedButtonTheme,
    textFieldTheme,
    dialogTheme,
    toastTheme,
    snackbarTheme,
    loadingOverlayTheme,
    notificationCenterTheme,
    collapsibleTheme,
    accordionTheme,
    paginationTheme,
    stepIndicatorTheme,
    stepperNavigationTheme,
    timelineTheme,
    notificationTheme,
    alertTheme,
    bannerTheme,
    bottomSheetTheme,
    chipTheme,
    avatarTheme,
    tagTheme,
    widgetGroupTheme,
    iconButtonTheme,
    iconTheme,
    dividerTheme,
    progressTheme,
    switchTheme,
    sliderTheme,
    checkboxTheme,
    radioTheme,
    listTileTheme,
    textComponentTheme,
    materialTheme,
    contrastTheme,
  ]);
}

/// 用于显式动画和测试的 Hyper 主题补间。
final class HyperThemeDataTween extends Tween<HyperThemeData> {
  HyperThemeDataTween({super.begin, super.end});

  @override
  HyperThemeData lerp(double t) => begin!.lerp(end, t);
}
