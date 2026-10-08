import '../pages/content/hyper_timeline_page.dart';
import '../pages/framework/hyper_steps_page.dart';
import '../pages/framework/hyper_pagination_page.dart';
import '../pages/container/hyper_collapsible_page.dart';
import '../pages/feedback/hyper_notification_center_page.dart';
import '../pages/feedback/hyper_notification_page.dart';
import '../pages/selection/hyper_text_field_page.dart';
import '../pages/feedback/hyper_dialog_page.dart';
import '../pages/feedback/hyper_bottom_sheet_page.dart';
import '../pages/feedback/hyper_message_page.dart';
import '../pages/feedback/hyper_notice_page.dart';
import '../pages/feedback/hyper_loading_overlay_page.dart';
import '../pages/selection/hyper_segmented_button_page.dart';
import '../pages/content/hyper_avatar_page.dart';

import 'package:flutter/material.dart';

import '../pages/foundation/hyper_color_scheme_page.dart';
import '../pages/foundation/hyper_container_theme_page.dart';
import '../pages/foundation/hyper_device_detector_page.dart';
import '../pages/foundation/hyper_fill_page.dart';
import '../pages/foundation/hyper_motion_theme_page.dart';
import '../pages/foundation/hyper_size_scheme_page.dart';
import '../pages/foundation/hyper_state_value_page.dart';
import '../pages/foundation/hyper_theme_page.dart';
import '../pages/foundation/hyper_typography_scheme_page.dart';
import '../pages/feedback/hyper_progress_page.dart';
import '../pages/feedback/hyper_skeleton_page.dart';
import '../pages/feedback/hyper_empty_state_page.dart';
import '../pages/framework/hyper_app_bar_page.dart';
import '../pages/framework/hyper_drawer_page.dart';
import '../pages/framework/hyper_sidebar_page.dart';
import '../pages/framework/hyper_tab_bar_page.dart';
import '../pages/framework/hyper_breadcrumb_page.dart';
import '../pages/container/hyper_container_page.dart';
import '../pages/container/hyper_card_page.dart';
import '../pages/container/hyper_widget_group_page.dart';
import '../pages/content/hyper_text_page.dart';
import '../pages/content/hyper_badge_page.dart';
import '../pages/content/hyper_tag_page.dart';
import '../pages/content/hyper_icon_page.dart';
import '../pages/content/hyper_divider_page.dart';
import '../pages/content/hyper_list_tile_page.dart';
import '../pages/button/hyper_button_theme_page.dart';
import '../pages/button/hyper_button_page.dart';
import '../pages/button/hyper_icon_button_page.dart';
import '../pages/interaction/hyper_pressable_page.dart';
import '../pages/interaction/hyper_anchored_overlay_page.dart';
import '../pages/interaction/hyper_menu_page.dart';
import '../pages/interaction/hyper_tooltip_page.dart';
import '../pages/surface/hyper_material_surface_page.dart';
import '../pages/selection/hyper_switch_page.dart';
import '../pages/selection/hyper_slider_page.dart';
import '../pages/selection/hyper_chip_page.dart';
import '../pages/selection/hyper_checkbox_page.dart';
import '../pages/selection/hyper_radio_page.dart';
import '../pages/selection/hyper_dropdown_menu_page.dart';
import 'gallery_item.dart';

/// Example 中所有演示页的唯一注册入口。
///
/// 新控件实现后只需新增页面并登记在对应分类中，菜单壳无需跟随修改。
final List<GallerySection> gallerySections = [
  GallerySection(
    title: '基础能力',
    items: [
      GalleryItem(
        id: 'hyper-fill',
        title: 'HyperFill',
        description: '纯色、渐变和显式无填充。',
        icon: Icons.format_color_fill_outlined,
        builder: (_) => const HyperFillPage(),
      ),
      GalleryItem(
        id: 'hyper-container-theme',
        title: 'HyperContainerThemeData',
        description: '容器主题、单项覆盖与插值。',
        icon: Icons.crop_square,
        builder: (_) => const HyperContainerThemePage(),
      ),
      GalleryItem(
        id: 'hyper-color-scheme',
        title: 'HyperColorScheme',
        description: '语义色、种子色与亮暗方案。',
        icon: Icons.palette_outlined,
        builder: (_) => const HyperColorSchemePage(),
      ),
      GalleryItem(
        id: 'hyper-theme',
        title: 'HyperTheme',
        description: '全局基础主题、局部覆盖和统一动画。',
        icon: Icons.style_outlined,
        builder: (_) => const HyperThemePage(),
      ),
      GalleryItem(
        id: 'hyper-size-scheme',
        title: 'HyperSizeScheme',
        description: '手机、平板、桌面和手表的明确尺寸。',
        icon: Icons.straighten,
        builder: (_) => const HyperSizeSchemePage(),
      ),
      GalleryItem(
        id: 'hyper-typography-scheme',
        title: 'HyperTypographyScheme',
        description: '按场景定义明确字号，并支持全局精确覆盖。',
        icon: Icons.text_fields,
        builder: (_) => const HyperTypographySchemePage(),
      ),
      GalleryItem(
        id: 'hyper-device-detector',
        title: 'HyperDeviceDetector',
        description: '在主题外层自动选择终端尺寸方案。',
        icon: Icons.devices_other,
        builder: (_) => const HyperDeviceDetectorPage(),
      ),
      GalleryItem(
        id: 'hyper-state-value',
        title: 'HyperStateValue',
        description: '组合状态、统一优先级与属性解析。',
        icon: Icons.toggle_on_outlined,
        builder: (_) => const HyperStateValuePage(),
      ),
      GalleryItem(
        id: 'hyper-motion-theme',
        title: 'HyperMotionThemeData',
        description: '统一动画时长、曲线、弹簧和减少动画。',
        icon: Icons.animation,
        builder: (_) => const HyperMotionThemePage(),
      ),
    ],
  ),
  GallerySection(
    title: '页面框架',
    audience: GalleryAudience.mobile,
    items: [
      GalleryItem(
        id: 'hyper-app-bar',
        title: 'HyperAppBar',
        description: '普通与滚动展开顶栏、统一玻璃材质。',
        icon: Icons.web_asset_outlined,
        ownsAppBar: true,
        builder: (_) => const HyperAppBarPage(),
      ),
    ],
  ),
  GallerySection(
    title: '抽屉导航',
    audience: GalleryAudience.mobile,
    items: [
      GalleryItem(
        id: 'hyper-drawer',
        title: 'HyperDrawer',
        description: '可放任意内容的起始侧与结束侧抽屉。',
        icon: Icons.view_sidebar_outlined,
        builder: (_) => const HyperDrawerPage(),
      ),
    ],
  ),
  GallerySection(
    title: '容器与表面',
    items: [
      GalleryItem(
        id: 'hyper-container',
        title: 'HyperContainer',
        description: '轻量容器、主题优先级与精确尺寸。',
        icon: Icons.rounded_corner,
        builder: (_) => const HyperContainerPage(),
      ),
      GalleryItem(
        id: 'hyper-collapsible',
        title: 'HyperCollapsible / Accordion',
        description: '折叠区域、互斥与多项展开。',
        icon: Icons.unfold_more,
        builder: (_) => const HyperCollapsiblePage(),
      ),
      GalleryItem(
        id: 'hyper-card',
        title: 'HyperCard',
        description: '独立主题、设备圆角、自由内容和整卡交互。',
        icon: Icons.view_agenda_outlined,
        builder: (_) => const HyperCardPage(),
      ),
      GalleryItem(
        id: 'hyper-widget-group',
        title: 'HyperWidgetGroup',
        description: '混合控件排列、分隔与可配置的外层视觉。',
        icon: Icons.view_week_outlined,
        builder: (_) => const HyperWidgetGroupPage(),
      ),
      GalleryItem(
        id: 'hyper-material-surface',
        title: 'HyperMaterialSurface',
        description: '普通、半透明、毛玻璃、柔光玻璃及明确降级。',
        icon: Icons.blur_on_outlined,
        builder: (_) => const HyperMaterialSurfacePage(),
      ),
    ],
  ),
  GallerySection(
    title: '文字与内容',
    items: [
      GalleryItem(
        id: 'hyper-timeline',
        title: 'HyperTimeline',
        description: '时间记录、交错布局与自定义节点。',
        icon: Icons.timeline,
        builder: (_) => const HyperTimelinePage(),
      ),
      GalleryItem(
        id: 'hyper-text',
        title: 'HyperText',
        description: '系统字体、语义字号和三层样式覆盖。',
        icon: Icons.title,
        builder: (_) => const HyperTextPage(),
      ),
      GalleryItem(
        id: 'hyper-icon',
        title: 'HyperIcon',
        description: '设备尺寸、状态样式和可变图标轴。',
        icon: Icons.insert_emoticon_outlined,
        builder: (_) => const HyperIconPage(),
      ),
      GalleryItem(
        id: 'hyper-badge',
        title: 'HyperBadge',
        description: '点、数量、短文本徽标和独立锚点定位。',
        icon: Icons.notification_important_outlined,
        builder: (_) => const HyperBadgePage(),
      ),
      GalleryItem(
        id: 'hyper-avatar',
        title: 'HyperAvatar',
        description: '头像、横向堆叠、圆形五角与宫格头像组。',
        icon: Icons.account_circle_outlined,
        builder: (_) => const HyperAvatarPage(),
      ),
      GalleryItem(
        id: 'hyper-tag',
        title: 'HyperTag',
        description: '普通、强调与禁用的静态内容标签。',
        icon: Icons.label_outline,
        builder: (_) => const HyperTagPage(),
      ),
      GalleryItem(
        id: 'hyper-divider',
        title: 'HyperDivider',
        description: '横向、纵向、渐变、虚线和点线。',
        icon: Icons.horizontal_rule,
        builder: (_) => const HyperDividerPage(),
      ),
      GalleryItem(
        id: 'hyper-list-tile',
        title: 'HyperListTile',
        description: 'MIUIX 风格首部、正文、尾部布局与整行交互。',
        icon: Icons.view_agenda_outlined,
        builder: (_) => const HyperListTilePage(),
      ),
    ],
  ),
  GallerySection(
    title: '交互基础',
    items: [
      GalleryItem(
        id: 'hyper-anchored-overlay',
        title: 'HyperAnchoredOverlay',
        description: '点击或悬停打开锚定浮层，自动跟随并避让边缘。',
        icon: Icons.layers_outlined,
        builder: (_) => const HyperAnchoredOverlayPage(),
      ),
      GalleryItem(
        id: 'hyper-pressable',
        title: 'HyperPressable',
        description: '单击、双击、长按、右键、焦点与统一状态。',
        icon: Icons.touch_app_outlined,
        builder: (_) => const HyperPressablePage(),
      ),
    ],
  ),
  GallerySection(
    title: '输入控件',
    items: [
      GalleryItem(
        id: 'hyper-text-field',
        title: 'HyperTextField',
        description: '单行、多行、密码和尾部错误提示。',
        icon: Icons.edit_outlined,
        builder: (_) => const HyperTextFieldPage(),
      ),
    ],
  ),
  GallerySection(
    title: '选择控件',
    items: [
      GalleryItem(
        id: 'hyper-dropdown-menu',
        title: 'HyperDropdownMenu',
        description: '单选、禁用选项、键盘操作与受控值。',
        icon: Icons.arrow_drop_down_circle_outlined,
        builder: (_) => const HyperDropdownMenuPage(),
      ),
      GalleryItem(
        id: 'hyper-checkbox',
        title: 'HyperCheckbox',
        description: '未选中、选中、半选中与独立主题。',
        icon: Icons.check_box_outlined,
        builder: (_) => const HyperCheckboxPage(),
      ),
      GalleryItem(
        id: 'hyper-radio',
        title: 'HyperRadio',
        description: 'MIUIX 勾线单选、分组值和取消选择。',
        icon: Icons.radio_button_checked,
        builder: (_) => const HyperRadioPage(),
      ),
      GalleryItem(
        id: 'hyper-switch',
        title: 'HyperSwitch',
        description: '点击、拖动、设备尺寸与独立主题。',
        icon: Icons.toggle_on_outlined,
        builder: (_) => const HyperSwitchPage(),
      ),
      GalleryItem(
        id: 'hyper-slider',
        title: 'HyperSlider',
        description: '单值、范围和垂直滑块；共享四端尺寸与主题。',
        icon: Icons.tune,
        builder: (_) => const HyperSliderPage(),
      ),
      GalleryItem(
        id: 'hyper-segmented-button',
        title: 'HyperSegmentedButton',
        description: '单选、多选、图标和连接布局。',
        icon: Icons.view_week_outlined,
        builder: (_) => const HyperSegmentedButtonPage(),
      ),
      GalleryItem(
        id: 'hyper-chip',
        title: 'HyperChip',
        description: '操作、单选、多选、头像和独立删除。',
        icon: Icons.label_outline,
        builder: (_) => const HyperChipPage(),
      ),
    ],
  ),
  GallerySection(
    title: '反馈与状态',
    items: [
      GalleryItem(
        id: 'hyper-notification-center',
        title: 'HyperNotificationCenter',
        description: '受控通知列表、分组和批量操作。',
        icon: Icons.notifications_active_outlined,
        builder: (_) => const HyperNotificationCenterPage(),
      ),
      GalleryItem(
        id: 'hyper-notification',
        title: 'HyperNotification',
        description: '通知卡片、已读状态与独立操作。',
        icon: Icons.notifications_outlined,
        builder: (_) => const HyperNotificationPage(),
      ),
      GalleryItem(
        id: 'hyper-loading-overlay',
        title: 'HyperLoadingOverlay',
        description: '区域和整页加载、延迟显示、点击拦截与取消。',
        icon: Icons.hourglass_empty,
        builder: (_) => const HyperLoadingOverlayPage(),
      ),
      GalleryItem(
        id: 'hyper-notice',
        title: 'HyperAlert / HyperBanner',
        description: '四种状态、内联提示、页面横幅、操作与关闭。',
        icon: Icons.info_outline,
        builder: (_) => const HyperNoticePage(),
      ),
      GalleryItem(
        id: 'hyper-bottom-sheet',
        title: 'HyperBottomSheet',
        description: '高度、拖动关闭、边框圆角、正文滚动与固定操作区。',
        icon: Icons.vertical_align_bottom,
        builder: (_) => const HyperBottomSheetPage(),
      ),
      GalleryItem(
        id: 'hyper-message',
        title: 'HyperToast / HyperSnackbar',
        description: '轻提示、操作提示、队列、位置和主题覆盖。',
        icon: Icons.notifications_none,
        builder: (_) => const HyperMessagePage(),
      ),
      GalleryItem(
        id: 'hyper-dialog',
        title: 'HyperDialog',
        description: '位置、边框、圆角、按钮排列和自由内容。',
        icon: Icons.web_asset_outlined,
        builder: (_) => const HyperDialogPage(),
      ),
      GalleryItem(
        id: 'hyper-empty-state',
        title: 'HyperEmptyState',
        description: '暂无数据、搜索无结果、加载失败及自定义内容。',
        icon: Icons.inbox_outlined,
        builder: (_) => const HyperEmptyStatePage(),
      ),
      GalleryItem(
        id: 'hyper-skeleton',
        title: 'HyperSkeleton',
        description: '基础形状、微光、呼吸及加载内容过渡。',
        icon: Icons.view_agenda_outlined,
        builder: (_) => const HyperSkeletonPage(),
      ),
      GalleryItem(
        id: 'hyper-progress-indicator',
        title: 'HyperProgress',
        description: '线性、圆形、确定进度与不确定进度。',
        icon: Icons.data_usage,
        builder: (_) => const HyperProgressPage(),
      ),
    ],
  ),
  GallerySection(
    title: '按钮与操作',
    items: [
      GalleryItem(
        id: 'hyper-button',
        title: 'HyperButton',
        description: '六种变体、图标文字与自动异步进度。',
        icon: Icons.ads_click_outlined,
        builder: (_) => const HyperButtonPage(),
      ),
      GalleryItem(
        id: 'hyper-button-theme',
        title: 'HyperButtonThemeData',
        description: '公共样式、六种变体与局部主题覆盖。',
        icon: Icons.smart_button_outlined,
        builder: (_) => const HyperButtonThemePage(),
      ),
      GalleryItem(
        id: 'hyper-icon-button',
        title: 'HyperIconButton',
        description: '四种变体、异步进度、Tooltip 与材质。',
        icon: Icons.radio_button_checked,
        builder: (_) => const HyperIconButtonPage(),
      ),
    ],
  ),
  GallerySection(
    title: '侧边导航',
    audience: GalleryAudience.desktop,
    items: [
      GalleryItem(
        id: 'hyper-sidebar',
        title: 'HyperSidebar',
        description: '分组、树形、折叠与悬停子菜单。',
        icon: Icons.view_sidebar_outlined,
        builder: (_) => const HyperSidebarPage(),
      ),
    ],
  ),
  GallerySection(
    title: '标签导航',
    items: [
      GalleryItem(
        id: 'hyper-tab-bar',
        title: 'HyperTabBar',
        description: '底槽、独立圆角与下划线标签。',
        icon: Icons.tab_outlined,
        builder: (_) => const HyperTabBarPage(),
      ),
      GalleryItem(
        id: 'hyper-steps',
        title: 'HyperStepIndicator / StepperNavigation',
        description: '步骤状态、横纵布局和受控导航。',
        icon: Icons.format_list_numbered,
        builder: (_) => const HyperStepsPage(),
      ),
      GalleryItem(
        id: 'hyper-pagination',
        title: 'HyperPagination',
        description: '受控页码、省略号与首尾导航。',
        icon: Icons.more_horiz,
        builder: (_) => const HyperPaginationPage(),
      ),
      GalleryItem(
        id: 'hyper-breadcrumb',
        title: 'HyperBreadcrumb',
        description: '胶囊路径、节点点击和长路径滚动。',
        icon: Icons.chevron_right,
        builder: (_) => const HyperBreadcrumbPage(),
      ),
    ],
  ),
  GallerySection(
    title: '操作与提示',
    audience: GalleryAudience.desktop,
    items: [
      GalleryItem(
        id: 'hyper-menu',
        title: 'HyperMenu',
        description: '分组操作、选择状态与键盘导航。',
        icon: Icons.menu_open_outlined,
        builder: (_) => const HyperMenuPage(),
      ),
      GalleryItem(
        id: 'hyper-tooltip',
        title: 'HyperTooltip',
        description: '悬停与焦点提示，支持延迟、避让和替换动画。',
        icon: Icons.info_outline,
        builder: (_) => const HyperTooltipPage(),
      ),
    ],
  ),
];

/// 按注册顺序展开全部演示页。
List<GalleryItem> get galleryItems => [
  for (final section in gallerySections) ...section.items,
];
