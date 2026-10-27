import '../../components/number_input/hyper_number_input_theme.dart';
import '../../components/popover/hyper_popover_theme.dart';
import '../../components/rating/hyper_rating_theme.dart';
import '../../components/transfer/hyper_transfer_theme.dart';
import '../../components/resizable/hyper_resizable_theme.dart';
import '../../components/movable_dialog/hyper_movable_dialog_theme.dart';
import '../../components/navigation_bar/hyper_navigation_bar_theme.dart';
import '../../components/inline_edit/hyper_inline_edit_theme.dart';
import '../../components/charts/hyper_chart_theme.dart';
import '../../components/table/hyper_table_theme.dart';
import '../../components/form/hyper_form_theme.dart';
import '../../components/cascader/hyper_cascader_theme.dart';
import '../../components/tree_select/hyper_tree_select_theme.dart';
import '../../components/form/hyper_field_theme.dart';
import '../../components/calendar/hyper_calendar_theme.dart';
import '../../components/wheel_picker/hyper_wheel_picker_theme.dart';
import '../../components/tab/hyper_tab_bar_theme.dart';
import '../../components/tooltip/hyper_tooltip_theme.dart';
import '../../components/top_navigation/hyper_top_navigation_theme.dart';
import '../../components/color_picker/hyper_color_picker_theme.dart';
import '../../components/select/hyper_selection_theme.dart';
import '../../components/autocomplete/hyper_autocomplete_theme.dart';
import '../../components/tree/hyper_tree_view_theme.dart';
import '../../components/page_indicator/hyper_page_indicator_theme.dart';
import '../../components/result/hyper_result_theme.dart';
import '../../components/description_list/hyper_description_list_theme.dart';
import '../../components/timeline/hyper_timeline_theme.dart';
import '../../components/steps/hyper_step_indicator_theme.dart';
import '../../components/pagination/hyper_pagination_theme.dart';
import '../../components/collapsible/hyper_accordion_theme.dart';
import '../../components/collapsible/hyper_collapsible_theme.dart';
import '../../components/notification/hyper_notification_theme.dart';
import '../../components/loading_overlay/hyper_loading_overlay_theme.dart';
import '../../components/notice/hyper_alert_theme.dart';
import '../../components/message/hyper_toast_theme.dart';
import '../../components/message/hyper_snackbar_theme.dart';
import '../../components/text_field/hyper_text_field_theme.dart';
import '../../components/dialog/hyper_dialog_theme.dart';
import '../../components/bottom_sheet/hyper_bottom_sheet_theme.dart';
import '../../components/segmented_button/hyper_segmented_button_theme.dart';
import '../../components/chip/hyper_chip_theme.dart';
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
import '../../components/select/hyper_select_theme.dart';
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
// Theme-root styles have a consistent inheritance contract for interpolation.
// Preserve every supplied metric; adding Material geometry here changes control
// heights when a previously unspecified line height becomes explicit.
TextStyle? _standaloneTextStyle(TextStyle? style) => style?.copyWith(
  inherit: false,
  textBaseline: style.textBaseline ?? TextBaseline.alphabetic,
);

TextTheme _standaloneTextTheme(TextTheme text) => TextTheme(
  displayLarge: _standaloneTextStyle(text.displayLarge),
  displayMedium: _standaloneTextStyle(text.displayMedium),
  displaySmall: _standaloneTextStyle(text.displaySmall),
  headlineLarge: _standaloneTextStyle(text.headlineLarge),
  headlineMedium: _standaloneTextStyle(text.headlineMedium),
  headlineSmall: _standaloneTextStyle(text.headlineSmall),
  titleLarge: _standaloneTextStyle(text.titleLarge),
  titleMedium: _standaloneTextStyle(text.titleMedium),
  titleSmall: _standaloneTextStyle(text.titleSmall),
  bodyLarge: _standaloneTextStyle(text.bodyLarge),
  bodyMedium: _standaloneTextStyle(text.bodyMedium),
  bodySmall: _standaloneTextStyle(text.bodySmall),
  labelLarge: _standaloneTextStyle(text.labelLarge),
  labelMedium: _standaloneTextStyle(text.labelMedium),
  labelSmall: _standaloneTextStyle(text.labelSmall),
);

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
    this.chartTheme = const HyperChartThemeData(),
    this.sidebarTheme = const HyperSidebarThemeData(),
    this.menuTheme = const HyperMenuThemeData(),
    this.topNavigationTheme = const HyperTopNavigationThemeData(),
    this.colorPickerTheme = const HyperColorPickerThemeData(),
    this.selectTheme = const HyperSelectThemeData(),
    this.cascaderTheme = const HyperCascaderThemeData(),
    this.ratingTheme = const HyperRatingThemeData(),
    this.transferTheme = const HyperTransferThemeData(),
    this.resizableTheme = const HyperResizableThemeData(),
    this.movableDialogTheme = const HyperMovableDialogThemeData(),
    this.navigationBarTheme = const HyperNavigationBarThemeData(),
    this.inlineEditTheme = const HyperInlineEditThemeData(),
    this.treeSelectTheme = const HyperTreeSelectThemeData(),
    this.tabBarTheme = const HyperTabBarThemeData(),
    this.breadcrumbTheme = const HyperBreadcrumbThemeData(),
    this.cardTheme = const HyperCardThemeData(),
    this.titledCardTheme = const HyperTitledCardThemeData(),
    this.buttonTheme = const HyperButtonThemeData(),
    this.badgeTheme = const HyperBadgeThemeData(),
    this.tagTheme = const HyperTagThemeData(),
    this.avatarTheme = const HyperAvatarThemeData(),
    this.skeletonTheme = const HyperSkeletonThemeData(),
    this.pageIndicatorTheme = const HyperPageIndicatorThemeData(),
    this.tableTheme = const HyperTableThemeData(),
    this.treeViewTheme = const HyperTreeViewThemeData(),
    this.selectionTheme = const HyperSelectionThemeData(),
    this.autocompleteTheme = const HyperAutocompleteThemeData(),
    this.wheelPickerTheme = const HyperWheelPickerThemeData(),
    this.calendarTheme = const HyperCalendarThemeData(),
    this.formTheme = const HyperFormThemeData(),
    this.fieldTheme = const HyperFieldThemeData(),
    this.resultTheme = const HyperResultThemeData(),
    this.segmentedButtonTheme = const HyperSegmentedButtonThemeData(),
    this.textFieldTheme = const HyperTextFieldThemeData(),
    this.dialogTheme = const HyperDialogThemeData(),
    this.toastTheme = const HyperToastThemeData(),
    this.snackbarTheme = const HyperSnackbarThemeData(),
    this.loadingOverlayTheme = const HyperLoadingOverlayThemeData(),
    this.collapsibleTheme = const HyperCollapsibleThemeData(),
    this.accordionTheme = const HyperAccordionThemeData(),
    this.paginationTheme = const HyperPaginationThemeData(),
    this.stepIndicatorTheme = const HyperStepIndicatorThemeData(),
    this.timelineTheme = const HyperTimelineThemeData(),
    this.descriptionListTheme = const HyperDescriptionListThemeData(),
    this.notificationTheme = const HyperNotificationThemeData(),
    this.alertTheme = const HyperAlertThemeData(),
    this.bottomSheetTheme = const HyperBottomSheetThemeData(),
    this.chipTheme = const HyperChipThemeData(),
    this.widgetGroupTheme = const HyperWidgetGroupThemeData(),
    this.iconButtonTheme = const HyperIconButtonThemeData(),
    this.numberInputTheme = const HyperNumberInputThemeData(),
    this.popoverTheme = const HyperPopoverThemeData(),
    this.tooltipTheme = const HyperTooltipThemeData(),
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
      textTheme: resolvedTypography.applyTo(
        _standaloneTextTheme(material.textTheme),
      ),
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
      topNavigationTheme: const HyperTopNavigationThemeData(),
      colorPickerTheme: const HyperColorPickerThemeData(),
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
      textTheme: resolvedTypography.applyTo(
        _standaloneTextTheme(material.textTheme),
      ),
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
      topNavigationTheme: const HyperTopNavigationThemeData(),
      colorPickerTheme: const HyperColorPickerThemeData(),
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
  final HyperChartThemeData chartTheme;

  /// 全局树形侧栏主题。
  final HyperSidebarThemeData sidebarTheme;

  /// 全局弹出菜单主题。
  final HyperMenuThemeData menuTheme;

  /// 顶部导航全局主题。
  final HyperTopNavigationThemeData topNavigationTheme;
  final HyperColorPickerThemeData colorPickerTheme;

  /// 全局下拉选择器主题。
  final HyperSelectThemeData selectTheme;
  final HyperCascaderThemeData cascaderTheme;
  final HyperRatingThemeData ratingTheme;
  final HyperTransferThemeData transferTheme;
  final HyperResizableThemeData resizableTheme;
  final HyperMovableDialogThemeData movableDialogTheme;
  final HyperNavigationBarThemeData navigationBarTheme;
  final HyperInlineEditThemeData inlineEditTheme;
  final HyperTreeSelectThemeData treeSelectTheme;

  /// 全局面包屑视觉主题。
  final HyperTabBarThemeData tabBarTheme;
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
  final HyperPageIndicatorThemeData pageIndicatorTheme;
  final HyperTableThemeData tableTheme;
  final HyperTreeViewThemeData treeViewTheme;
  final HyperSelectionThemeData selectionTheme;
  final HyperAutocompleteThemeData autocompleteTheme;
  final HyperWheelPickerThemeData wheelPickerTheme;
  final HyperCalendarThemeData calendarTheme;
  final HyperFormThemeData formTheme;
  final HyperFieldThemeData fieldTheme;
  final HyperResultThemeData resultTheme;
  final HyperSegmentedButtonThemeData segmentedButtonTheme;
  final HyperTextFieldThemeData textFieldTheme;
  final HyperDialogThemeData dialogTheme;
  final HyperToastThemeData toastTheme;
  final HyperSnackbarThemeData snackbarTheme;
  final HyperLoadingOverlayThemeData loadingOverlayTheme;
  final HyperCollapsibleThemeData collapsibleTheme;
  final HyperAccordionThemeData accordionTheme;
  final HyperPaginationThemeData paginationTheme;
  final HyperStepIndicatorThemeData stepIndicatorTheme;
  final HyperTimelineThemeData timelineTheme;
  final HyperDescriptionListThemeData descriptionListTheme;
  final HyperNotificationThemeData notificationTheme;
  final HyperAlertThemeData alertTheme;
  final HyperBottomSheetThemeData bottomSheetTheme;
  final HyperChipThemeData chipTheme;
  final HyperWidgetGroupThemeData widgetGroupTheme;

  /// 全局图标按钮主题。
  final HyperIconButtonThemeData iconButtonTheme;

  /// 全局数字输入主题。
  final HyperNumberInputThemeData numberInputTheme;

  /// 全局锚定面板主题。
  final HyperPopoverThemeData popoverTheme;
  final HyperTooltipThemeData tooltipTheme;

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
    HyperChartThemeData? chartTheme,
    HyperSidebarThemeData? sidebarTheme,
    HyperMenuThemeData? menuTheme,
    HyperTopNavigationThemeData? topNavigationTheme,
    HyperColorPickerThemeData? colorPickerTheme,
    HyperSelectThemeData? selectTheme,
    HyperCascaderThemeData? cascaderTheme,
    HyperRatingThemeData? ratingTheme,
    HyperTransferThemeData? transferTheme,
    HyperResizableThemeData? resizableTheme,
    HyperMovableDialogThemeData? movableDialogTheme,
    HyperNavigationBarThemeData? navigationBarTheme,
    HyperInlineEditThemeData? inlineEditTheme,
    HyperTreeSelectThemeData? treeSelectTheme,
    HyperTabBarThemeData? tabBarTheme,
    HyperBreadcrumbThemeData? breadcrumbTheme,
    HyperCardThemeData? cardTheme,
    HyperTitledCardThemeData? titledCardTheme,
    HyperButtonThemeData? buttonTheme,
    HyperBadgeThemeData? badgeTheme,
    HyperTagThemeData? tagTheme,
    HyperAvatarThemeData? avatarTheme,
    HyperSkeletonThemeData? skeletonTheme,
    HyperPageIndicatorThemeData? pageIndicatorTheme,
    HyperTableThemeData? tableTheme,
    HyperTreeViewThemeData? treeViewTheme,
    HyperSelectionThemeData? selectionTheme,
    HyperAutocompleteThemeData? autocompleteTheme,
    HyperWheelPickerThemeData? wheelPickerTheme,
    HyperCalendarThemeData? calendarTheme,
    HyperFormThemeData? formTheme,
    HyperFieldThemeData? fieldTheme,
    HyperResultThemeData? resultTheme,
    HyperSegmentedButtonThemeData? segmentedButtonTheme,
    HyperTextFieldThemeData? textFieldTheme,
    HyperDialogThemeData? dialogTheme,
    HyperToastThemeData? toastTheme,
    HyperSnackbarThemeData? snackbarTheme,
    HyperLoadingOverlayThemeData? loadingOverlayTheme,
    HyperCollapsibleThemeData? collapsibleTheme,
    HyperAccordionThemeData? accordionTheme,
    HyperPaginationThemeData? paginationTheme,
    HyperStepIndicatorThemeData? stepIndicatorTheme,
    HyperTimelineThemeData? timelineTheme,
    HyperDescriptionListThemeData? descriptionListTheme,
    HyperNotificationThemeData? notificationTheme,
    HyperAlertThemeData? alertTheme,
    HyperBottomSheetThemeData? bottomSheetTheme,
    HyperChipThemeData? chipTheme,
    HyperWidgetGroupThemeData? widgetGroupTheme,
    HyperIconButtonThemeData? iconButtonTheme,
    HyperNumberInputThemeData? numberInputTheme,
    HyperPopoverThemeData? popoverTheme,
    HyperTooltipThemeData? tooltipTheme,
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
      chartTheme: chartTheme ?? this.chartTheme,
      sidebarTheme: sidebarTheme ?? this.sidebarTheme,
      menuTheme: menuTheme ?? this.menuTheme,
      topNavigationTheme: topNavigationTheme ?? this.topNavigationTheme,
      colorPickerTheme: colorPickerTheme ?? this.colorPickerTheme,
      selectTheme: selectTheme ?? this.selectTheme,
      cascaderTheme: cascaderTheme ?? this.cascaderTheme,
      ratingTheme: ratingTheme ?? this.ratingTheme,
      transferTheme: transferTheme ?? this.transferTheme,
      resizableTheme: resizableTheme ?? this.resizableTheme,
      movableDialogTheme: movableDialogTheme ?? this.movableDialogTheme,
      navigationBarTheme: navigationBarTheme ?? this.navigationBarTheme,
      inlineEditTheme: inlineEditTheme ?? this.inlineEditTheme,
      treeSelectTheme: treeSelectTheme ?? this.treeSelectTheme,
      tabBarTheme: tabBarTheme ?? this.tabBarTheme,
      breadcrumbTheme: breadcrumbTheme ?? this.breadcrumbTheme,
      cardTheme: cardTheme ?? this.cardTheme,
      titledCardTheme: titledCardTheme ?? this.titledCardTheme,
      buttonTheme: buttonTheme ?? this.buttonTheme,
      badgeTheme: badgeTheme ?? this.badgeTheme,
      tagTheme: tagTheme ?? this.tagTheme,
      avatarTheme: avatarTheme ?? this.avatarTheme,
      skeletonTheme: skeletonTheme ?? this.skeletonTheme,
      pageIndicatorTheme: pageIndicatorTheme ?? this.pageIndicatorTheme,
      tableTheme: tableTheme ?? this.tableTheme,
      treeViewTheme: treeViewTheme ?? this.treeViewTheme,
      selectionTheme: selectionTheme ?? this.selectionTheme,
      autocompleteTheme: autocompleteTheme ?? this.autocompleteTheme,
      wheelPickerTheme: wheelPickerTheme ?? this.wheelPickerTheme,
      calendarTheme: calendarTheme ?? this.calendarTheme,
      formTheme: formTheme ?? this.formTheme,
      fieldTheme: fieldTheme ?? this.fieldTheme,
      resultTheme: resultTheme ?? this.resultTheme,
      segmentedButtonTheme: segmentedButtonTheme ?? this.segmentedButtonTheme,
      textFieldTheme: textFieldTheme ?? this.textFieldTheme,
      dialogTheme: dialogTheme ?? this.dialogTheme,
      toastTheme: toastTheme ?? this.toastTheme,
      snackbarTheme: snackbarTheme ?? this.snackbarTheme,
      loadingOverlayTheme: loadingOverlayTheme ?? this.loadingOverlayTheme,
      collapsibleTheme: collapsibleTheme ?? this.collapsibleTheme,
      accordionTheme: accordionTheme ?? this.accordionTheme,
      paginationTheme: paginationTheme ?? this.paginationTheme,
      stepIndicatorTheme: stepIndicatorTheme ?? this.stepIndicatorTheme,
      timelineTheme: timelineTheme ?? this.timelineTheme,
      descriptionListTheme: descriptionListTheme ?? this.descriptionListTheme,
      notificationTheme: notificationTheme ?? this.notificationTheme,
      alertTheme: alertTheme ?? this.alertTheme,
      bottomSheetTheme: bottomSheetTheme ?? this.bottomSheetTheme,
      chipTheme: chipTheme ?? this.chipTheme,
      widgetGroupTheme: widgetGroupTheme ?? this.widgetGroupTheme,
      iconButtonTheme: iconButtonTheme ?? this.iconButtonTheme,
      numberInputTheme: numberInputTheme ?? this.numberInputTheme,
      popoverTheme: popoverTheme ?? this.popoverTheme,
      tooltipTheme: tooltipTheme ?? this.tooltipTheme,
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
      chartTheme: HyperChartThemeData.lerp(chartTheme, other.chartTheme, t),
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
      timelineTheme: HyperTimelineThemeData.lerp(
        timelineTheme,
        other.timelineTheme,
        t,
      ),
      descriptionListTheme: HyperDescriptionListThemeData.lerp(
        descriptionListTheme,
        other.descriptionListTheme,
        t,
      ),
      notificationTheme: HyperNotificationThemeData.lerp(
        notificationTheme,
        other.notificationTheme,
        t,
      ),
      alertTheme: HyperAlertThemeData.lerp(alertTheme, other.alertTheme, t),
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
      topNavigationTheme: HyperTopNavigationThemeData.lerp(
        topNavigationTheme,
        other.topNavigationTheme,
        t,
      ),
      colorPickerTheme: HyperColorPickerThemeData.lerp(
        colorPickerTheme,
        other.colorPickerTheme,
        t,
      ),
      selectTheme: HyperSelectThemeData.lerp(selectTheme, other.selectTheme, t),
      ratingTheme: HyperRatingThemeData.lerp(ratingTheme, other.ratingTheme, t),
      transferTheme: HyperTransferThemeData.lerp(
        transferTheme,
        other.transferTheme,
        t,
      ),
      resizableTheme: HyperResizableThemeData.lerp(
        resizableTheme,
        other.resizableTheme,
        t,
      ),
      movableDialogTheme: HyperMovableDialogThemeData.lerp(
        movableDialogTheme,
        other.movableDialogTheme,
        t,
      ),
      navigationBarTheme: HyperNavigationBarThemeData.lerp(
        navigationBarTheme,
        other.navigationBarTheme,
        t,
      ),
      inlineEditTheme: HyperInlineEditThemeData.lerp(
        inlineEditTheme,
        other.inlineEditTheme,
        t,
      ),
      cascaderTheme: HyperCascaderThemeData.lerp(
        cascaderTheme,
        other.cascaderTheme,
        t,
      ),
      treeSelectTheme: HyperTreeSelectThemeData.lerp(
        treeSelectTheme,
        other.treeSelectTheme,
        t,
      ),
      tabBarTheme: HyperTabBarThemeData.lerp(tabBarTheme, other.tabBarTheme, t),
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
      pageIndicatorTheme: HyperPageIndicatorThemeData.lerp(
        pageIndicatorTheme,
        other.pageIndicatorTheme,
        t,
      ),
      tableTheme: HyperTableThemeData.lerp(tableTheme, other.tableTheme, t),
      treeViewTheme: HyperTreeViewThemeData.lerp(
        treeViewTheme,
        other.treeViewTheme,
        t,
      ),
      selectionTheme: HyperSelectionThemeData.lerp(
        selectionTheme,
        other.selectionTheme,
        t,
      ),
      fieldTheme: HyperFieldThemeData.lerp(fieldTheme, other.fieldTheme, t),
      formTheme: HyperFormThemeData.lerp(formTheme, other.formTheme, t),
      calendarTheme: HyperCalendarThemeData.lerp(
        calendarTheme,
        other.calendarTheme,
        t,
      ),
      wheelPickerTheme: HyperWheelPickerThemeData.lerp(
        wheelPickerTheme,
        other.wheelPickerTheme,
        t,
      ),
      autocompleteTheme: HyperAutocompleteThemeData.lerp(
        autocompleteTheme,
        other.autocompleteTheme,
        t,
      ),
      resultTheme: HyperResultThemeData.lerp(resultTheme, other.resultTheme, t),
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
      numberInputTheme: HyperNumberInputThemeData.lerp(
        numberInputTheme,
        other.numberInputTheme,
        t,
      ),
      popoverTheme: HyperPopoverThemeData.lerp(
        popoverTheme,
        other.popoverTheme,
        t,
      ),
      tooltipTheme: HyperTooltipThemeData.lerp(
        tooltipTheme,
        other.tooltipTheme,
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
          other.chartTheme == chartTheme &&
          other.sidebarTheme == sidebarTheme &&
          other.menuTheme == menuTheme &&
          other.topNavigationTheme == topNavigationTheme &&
          other.colorPickerTheme == colorPickerTheme &&
          other.selectTheme == selectTheme &&
          other.cascaderTheme == cascaderTheme &&
          other.ratingTheme == ratingTheme &&
          other.transferTheme == transferTheme &&
          other.resizableTheme == resizableTheme &&
          other.movableDialogTheme == movableDialogTheme &&
          other.navigationBarTheme == navigationBarTheme &&
          other.inlineEditTheme == inlineEditTheme &&
          other.treeSelectTheme == treeSelectTheme &&
          other.tabBarTheme == tabBarTheme &&
          other.breadcrumbTheme == breadcrumbTheme &&
          other.cardTheme == cardTheme &&
          other.titledCardTheme == titledCardTheme &&
          other.buttonTheme == buttonTheme &&
          other.badgeTheme == badgeTheme &&
          other.skeletonTheme == skeletonTheme &&
          other.pageIndicatorTheme == pageIndicatorTheme &&
          other.tableTheme == tableTheme &&
          other.treeViewTheme == treeViewTheme &&
          other.selectionTheme == selectionTheme &&
          other.autocompleteTheme == autocompleteTheme &&
          other.wheelPickerTheme == wheelPickerTheme &&
          other.calendarTheme == calendarTheme &&
          other.formTheme == formTheme &&
          other.fieldTheme == fieldTheme &&
          other.resultTheme == resultTheme &&
          other.segmentedButtonTheme == segmentedButtonTheme &&
          other.textFieldTheme == textFieldTheme &&
          other.dialogTheme == dialogTheme &&
          other.toastTheme == toastTheme &&
          other.snackbarTheme == snackbarTheme &&
          other.loadingOverlayTheme == loadingOverlayTheme &&
          other.collapsibleTheme == collapsibleTheme &&
          other.accordionTheme == accordionTheme &&
          other.paginationTheme == paginationTheme &&
          other.stepIndicatorTheme == stepIndicatorTheme &&
          other.timelineTheme == timelineTheme &&
          other.descriptionListTheme == descriptionListTheme &&
          other.notificationTheme == notificationTheme &&
          other.alertTheme == alertTheme &&
          other.bottomSheetTheme == bottomSheetTheme &&
          other.chipTheme == chipTheme &&
          other.avatarTheme == avatarTheme &&
          other.tagTheme == tagTheme &&
          other.widgetGroupTheme == widgetGroupTheme &&
          other.iconButtonTheme == iconButtonTheme &&
          other.numberInputTheme == numberInputTheme &&
          other.popoverTheme == popoverTheme &&
          other.tooltipTheme == tooltipTheme &&
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
    chartTheme,
    sidebarTheme,
    menuTheme,
    topNavigationTheme,
    colorPickerTheme,
    selectTheme,
    cascaderTheme,
    ratingTheme,
    transferTheme,
    resizableTheme,
    movableDialogTheme,
    navigationBarTheme,
    inlineEditTheme,
    treeSelectTheme,
    breadcrumbTheme,
    cardTheme,
    titledCardTheme,
    buttonTheme,
    badgeTheme,
    skeletonTheme,
    pageIndicatorTheme,
    tableTheme,
    treeViewTheme,
    selectionTheme,
    autocompleteTheme,
    fieldTheme,
    formTheme,
    calendarTheme,
    wheelPickerTheme,
    resultTheme,
    segmentedButtonTheme,
    textFieldTheme,
    dialogTheme,
    toastTheme,
    snackbarTheme,
    loadingOverlayTheme,
    collapsibleTheme,
    accordionTheme,
    paginationTheme,
    stepIndicatorTheme,
    timelineTheme,
    descriptionListTheme,
    notificationTheme,
    alertTheme,
    bottomSheetTheme,
    chipTheme,
    avatarTheme,
    tagTheme,
    widgetGroupTheme,
    iconButtonTheme,
    numberInputTheme,
    popoverTheme,
    tooltipTheme,
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
