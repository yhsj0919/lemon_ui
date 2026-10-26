import '../pages/pending/hyper_list_group_page.dart';
import '../pages/pending/hyper_pending_controls_pages.dart';
import '../pages/selection/hyper_inline_edit_page.dart';
import '../pages/content/hyper_table_page.dart';
import '../pages/content/hyper_charts_page.dart';
import '../pages/form/hyper_form_page.dart';
import '../pages/form/hyper_form_actions_page.dart';
import '../pages/selection/hyper_cascader_page.dart';
import '../pages/selection/hyper_tree_select_page.dart';
import '../pages/selection/hyper_calendar_page.dart';
import '../pages/selection/hyper_wheel_picker_page.dart';
import '../pages/selection/hyper_date_time_picker_page.dart';
import '../pages/content/hyper_scrolling_text_page.dart';
import '../pages/selection/hyper_dropdown_page.dart';
import '../pages/framework/hyper_top_navigation_page.dart';
import '../pages/selection/hyper_color_picker_page.dart';
import '../pages/content/hyper_description_list_page.dart';
import '../pages/selection/hyper_select_fields_page.dart';
import '../pages/content/hyper_result_page.dart';
import '../pages/content/hyper_tree_view_page.dart';
import '../pages/content/hyper_timeline_page.dart';
import '../pages/framework/hyper_steps_page.dart';
import '../pages/framework/hyper_pagination_page.dart';
import '../pages/framework/hyper_page_indicator_page.dart';
import '../pages/container/hyper_collapsible_page.dart';
import '../pages/feedback/hyper_notification_center_page.dart';
import '../pages/feedback/hyper_notification_page.dart';
import '../pages/selection/hyper_text_field_page.dart';
import '../pages/selection/hyper_text_area_page.dart';
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
import '../pages/foundation/hyper_line_page.dart';
import '../pages/foundation/hyper_motion_theme_page.dart';
import '../pages/foundation/hyper_size_scheme_page.dart';
import '../pages/foundation/hyper_state_value_page.dart';
import '../pages/foundation/hyper_theme_page.dart';
import '../pages/foundation/hyper_typography_scheme_page.dart';
import '../pages/feedback/hyper_progress_page.dart';
import '../pages/feedback/hyper_skeleton_page.dart';
import '../pages/feedback/hyper_result_empty_page.dart';
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
import '../pages/surface/hyper_clear_glass_page.dart';
import '../pages/selection/hyper_switch_page.dart';
import '../pages/selection/hyper_slider_page.dart';
import '../pages/selection/hyper_number_input_page.dart';
import '../pages/selection/hyper_file_picker_page.dart';
import '../pages/selection/hyper_chip_page.dart';
import '../pages/selection/hyper_checkbox_page.dart';
import '../pages/selection/hyper_radio_page.dart';
import 'gallery_item.dart';

/// Example 中所有演示页的唯一注册入口。
///
/// 新控件先登记“未确认”，用户明确确认后再移入对应分类，保持 id 稳定。
final List<GallerySection> gallerySections = [
  GallerySection(
    title: '未确认',
    items: [
      GalleryItem(
        id: 'hyper-list-group',
        title: '列表组',
        description: '带标题和独立操作区，内容无额外内边距。',
        icon: Icons.view_list_outlined,
        builder: (_) => const HyperListGroupPage(),
      ),
      GalleryItem(
        id: 'hyper-rating',
        title: '评分',
        description: '半星、只读、键盘与 Form。',
        icon: Icons.star_outline,
        builder: (_) => const HyperRatingPage(),
      ),
      GalleryItem(
        id: 'hyper-transfer',
        title: '穿梭框',
        description: '搜索、全选和双向移动。',
        icon: Icons.swap_horiz,
        builder: (_) => const HyperTransferPage(),
      ),
      GalleryItem(
        id: 'hyper-resizable',
        title: '可调整分栏',
        description: '拖动、键盘、约束与折叠。',
        icon: Icons.vertical_split_outlined,
        builder: (_) => const HyperResizablePage(),
      ),
      GalleryItem(
        id: 'hyper-movable-dialog',
        title: '可移动对话框',
        description: '公共对话框表面、标题拖动与边界。',
        icon: Icons.open_with,
        builder: (_) => const HyperMovableDialogPage(),
      ),
      GalleryItem(
        id: 'hyper-navigation-bar',
        title: '底部／侧向导航栏',
        description: '受控选择、标签与键盘导航。',
        icon: Icons.space_dashboard_outlined,
        builder: (_) => const HyperNavigationBarPage(),
      ),
    ],
  ),
  GallerySection(
    title: '基础能力',
    items: [
      GalleryItem(
        id: 'hyper-line',
        title: '线条样式',
        description: '分割线与边框共用的实线、虚线、点线样式。',
        icon: Icons.line_style,
        hasStyleOverrides: true,
        builder: (_) => const HyperLinePage(),
      ),
      GalleryItem(
        id: 'hyper-fill',
        title: '填充',
        description: '纯色、渐变和显式无填充。',
        icon: Icons.format_color_fill_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperFillPage(),
      ),
      GalleryItem(
        id: 'hyper-container-theme',
        title: '容器主题',
        description: '容器主题、单项覆盖与插值。',
        icon: Icons.crop_square,
        hasStyleOverrides: true,
        builder: (_) => const HyperContainerThemePage(),
      ),
      GalleryItem(
        id: 'hyper-color-scheme',
        title: '语义颜色',
        description: '语义色、种子色与亮暗方案。',
        icon: Icons.palette_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperColorSchemePage(),
      ),
      GalleryItem(
        id: 'hyper-theme',
        title: '基础主题',
        description: '全局基础主题、局部覆盖和统一动画。',
        icon: Icons.style_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperThemePage(),
      ),
      GalleryItem(
        id: 'hyper-size-scheme',
        title: '尺寸规格',
        description: '手机、平板、桌面和手表的明确尺寸。',
        icon: Icons.straighten,
        hasStyleOverrides: true,
        builder: (_) => const HyperSizeSchemePage(),
      ),
      GalleryItem(
        id: 'hyper-typography-scheme',
        title: '字体规格',
        description: '按场景定义明确字号，并支持全局精确覆盖。',
        icon: Icons.text_fields,
        builder: (_) => const HyperTypographySchemePage(),
      ),
      GalleryItem(
        id: 'hyper-device-detector',
        title: '设备识别',
        description: '在主题外层自动选择终端尺寸方案。',
        icon: Icons.devices_other,
        hasStyleOverrides: true,
        builder: (_) => const HyperDeviceDetectorPage(),
      ),
      GalleryItem(
        id: 'hyper-state-value',
        title: '状态属性',
        description: '组合状态、统一优先级与属性解析。',
        icon: Icons.toggle_on_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperStateValuePage(),
      ),
      GalleryItem(
        id: 'hyper-motion-theme',
        title: '动画主题',
        description: '统一动画时长、曲线、弹簧和减少动画。',
        icon: Icons.animation,
        hasStyleOverrides: true,
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
        title: '应用顶栏',
        description: '普通与滚动展开顶栏、统一玻璃材质。',
        icon: Icons.web_asset_outlined,

        hasStyleOverrides: true,
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
        title: '抽屉',
        description: '可放任意内容的起始侧与结束侧抽屉。',
        icon: Icons.view_sidebar_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperDrawerPage(),
      ),
    ],
  ),
  GallerySection(
    title: '容器与表面',
    items: [
      GalleryItem(
        id: 'hyper-container',
        title: '容器',
        description: '轻量容器、主题优先级与精确尺寸。',
        icon: Icons.rounded_corner,
        hasStyleOverrides: true,
        builder: (_) => const HyperContainerPage(),
      ),
      GalleryItem(
        id: 'hyper-collapsible',
        title: '折叠面板',
        description: '折叠区域、互斥与多项展开。',
        icon: Icons.unfold_more,
        hasStyleOverrides: true,
        builder: (_) => const HyperCollapsiblePage(),
      ),
      GalleryItem(
        id: 'hyper-card',
        title: '卡片',
        description: '独立主题、设备圆角、自由内容和整卡交互。',
        icon: Icons.view_agenda_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperCardPage(),
      ),
      GalleryItem(
        id: 'hyper-widget-group',
        title: '控件组',
        description: '混合控件排列、分隔与可配置的外层视觉。',
        icon: Icons.view_week_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperWidgetGroupPage(),
      ),
      GalleryItem(
        id: 'hyper-clear-glass',
        title: '高透毛玻璃',
        description: '彩色与纯白背景上的高透毛玻璃内置配方。',
        icon: Icons.blur_on,
        hasStyleOverrides: true,
        builder: (_) => const HyperClearGlassPage(),
      ),
      GalleryItem(
        id: 'hyper-material-surface',
        title: '材质表面',
        description: '普通、半透明、毛玻璃、柔光玻璃及明确降级。',
        icon: Icons.blur_on_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperMaterialSurfacePage(),
      ),
    ],
  ),
  GallerySection(
    title: '文字与内容',
    items: [
      GalleryItem(
        id: 'hyper-charts',
        title: '图表',
        description: '折线、柱状、饼图、散点、雷达、排名与 K 线；跟随提示与图例布局。',
        icon: Icons.bar_chart,
        hasStyleOverrides: true,
        builder: (_) => const HyperChartsPage(),
      ),

      GalleryItem(
        id: 'hyper-table',
        title: '数据表格',
        description: '固定列、拖动、多选、排序、列显隐、分页、无限加载与就地编辑。',
        icon: Icons.table_chart_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperTableDemoPage(),
      ),
      GalleryItem(
        id: 'hyper-divider',
        title: '分隔线',
        description: '横向、纵向、渐变、虚线和点线。',
        icon: Icons.horizontal_rule,
        hasStyleOverrides: true,
        builder: (_) => const HyperDividerPage(),
      ),
      GalleryItem(
        id: 'hyper-badge',
        title: '徽标',
        description: '点、数量、短文本徽标和独立锚点定位。',
        icon: Icons.notification_important_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperBadgePage(),
      ),
      GalleryItem(
        id: 'hyper-tree-view',
        title: '树形列表',
        description: '静态树、动态子节点、加载重试与缓存。',
        icon: Icons.account_tree_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperTreeViewPage(),
      ),
      GalleryItem(
        id: 'hyper-result',
        title: '结果页',
        description: '操作结果、状态、自定义插图和操作区。',
        icon: Icons.task_alt,
        hasStyleOverrides: true,
        builder: (_) => const HyperResultPage(),
      ),
      GalleryItem(
        id: 'hyper-description-list',
        title: '描述列表',
        description: '键值、多列与跨列、表格边框和自定义内容。',
        icon: Icons.list_alt,
        hasStyleOverrides: true,
        builder: (_) => const HyperDescriptionListPage(),
      ),
      GalleryItem(
        id: 'hyper-timeline',
        title: '时间线',
        description: '时间记录、交错布局与自定义节点。',
        icon: Icons.timeline,
        hasStyleOverrides: true,
        builder: (_) => const HyperTimelinePage(),
      ),
      GalleryItem(
        id: 'hyper-scrolling-text',
        title: '滚动文字',
        description: '单行溢出滚动，支持自动和悬停触发。',
        icon: Icons.text_fields,
        hasStyleOverrides: true,
        builder: (_) => const HyperScrollingTextPage(),
      ),
      GalleryItem(
        id: 'hyper-text',
        title: '文字',
        description: '系统字体、语义字号和三层样式覆盖。',
        icon: Icons.title,
        hasStyleOverrides: true,
        builder: (_) => const HyperTextPage(),
      ),
      GalleryItem(
        id: 'hyper-icon',
        title: '图标',
        description: '设备尺寸、状态样式和可变图标轴。',
        icon: Icons.insert_emoticon_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperIconPage(),
      ),
      GalleryItem(
        id: 'hyper-avatar',
        title: '头像',
        description: '头像、横向堆叠、圆形五角与宫格头像组。',
        icon: Icons.account_circle_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperAvatarPage(),
      ),
      GalleryItem(
        id: 'hyper-tag',
        title: '标签',
        description: '普通、强调与禁用的静态内容标签。',
        icon: Icons.label_outline,
        hasStyleOverrides: true,
        builder: (_) => const HyperTagPage(),
      ),
      GalleryItem(
        id: 'hyper-list-tile',
        title: '列表项',
        description: 'MIUIX 风格首部、正文、尾部布局与整行交互。',
        icon: Icons.view_agenda_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperListTilePage(),
      ),
    ],
  ),
  GallerySection(
    title: '交互基础',
    items: [
      GalleryItem(
        id: 'hyper-anchored-overlay',
        title: '锚定浮层',
        description: '点击或悬停打开锚定浮层，自动跟随并避让边缘。',
        icon: Icons.layers_outlined,
        builder: (_) => const HyperAnchoredOverlayPage(),
      ),
      GalleryItem(
        id: 'hyper-pressable',
        title: '按压交互',
        description: '单击、双击、长按、右键、焦点与统一状态。',
        icon: Icons.touch_app_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperPressablePage(),
      ),
    ],
  ),
  GallerySection(
    title: '输入控件',
    items: [
      GalleryItem(
        id: 'hyper-inline-edit',
        title: '行内编辑',
        description: '草稿、校验、异步保存和取消。',
        icon: Icons.edit_note,
        builder: (_) => const HyperInlineEditPage(),
      ),
      GalleryItem(
        id: 'hyper-number-input',
        title: '数字输入',
        description: '范围、步长、精度及 Form 校验。',
        icon: Icons.pin_outlined,
        builder: (_) => const HyperNumberInputPage(),
      ),
      GalleryItem(
        id: 'hyper-text-field',
        title: '文本输入',
        description: '单行、多行、密码和尾部错误提示。',
        icon: Icons.edit_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperTextFieldPage(),
      ),
    ],
  ),
  GallerySection(
    title: '选择控件',
    items: [
      GalleryItem(
        id: 'hyper-tree-select',
        title: '树形选择',
        description: '树形单选、仅叶节点、异步分支与 Form 校验。',
        icon: Icons.account_tree_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperTreeSelectPage(),
      ),
      GalleryItem(
        id: 'hyper-cascader',
        title: '级联选择',
        description: '完整路径单选、异步分支、失败重试及 Form 校验与提交。',
        icon: Icons.account_tree_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperCascaderPage(),
      ),
      GalleryItem(
        id: 'hyper-file-picker',
        title: '文件选择',
        description: '第三方系统选择与拖放适配，简洁界面和 Form。',
        icon: Icons.attach_file,
        builder: (_) => const HyperFilePickerPage(),
      ),
      GalleryItem(
        id: 'hyper-calendar',
        title: '日历',
        description: '普通日历和日期区间。',
        icon: Icons.calendar_month,
        builder: (_) => const HyperCalendarPage(),
      ),
      GalleryItem(
        id: 'hyper-wheel-picker',
        title: '滚轮选择器',
        description: '单列吸附、循环与受控更新。',
        icon: Icons.swap_vert,
        builder: (_) => const HyperWheelPickerPage(),
      ),
      GalleryItem(
        id: 'hyper-date-time-picker',
        title: '日期与时间选择器',
        description: '日期、时间与日期时间；确认提交与四端呈现。',
        icon: Icons.date_range_outlined,
        builder: (_) => const HyperDateTimePickerPage(),
      ),
      GalleryItem(
        id: 'hyper-switch',
        title: '开关',
        description: '点击、拖动、设备尺寸与独立主题。',
        icon: Icons.toggle_on_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperSwitchPage(),
      ),
      GalleryItem(
        id: 'hyper-checkbox',
        title: '复选框',
        description: '未选中、选中、半选中与独立主题。',
        icon: Icons.check_box_outlined,
        builder: (_) => const HyperCheckboxPage(),
      ),
      GalleryItem(
        id: 'hyper-radio',
        title: '单选框',
        description: 'MIUIX 勾线单选、分组值和取消选择。',
        icon: Icons.radio_button_checked,
        hasStyleOverrides: true,
        builder: (_) => const HyperRadioPage(),
      ),
      GalleryItem(
        id: 'hyper-dropdown',
        title: '下拉面板',
        description: '自定义内容下拉面板，支持分组与多级筛选。',
        icon: Icons.arrow_drop_down_circle_outlined,
        builder: (_) => const HyperDropdownPage(),
      ),
      GalleryItem(
        id: 'hyper-color-picker',
        title: '颜色选择器',
        description: '色轮、明度、透明度与 HEX 输入，支持自适应选色面板。',
        icon: Icons.colorize,
        hasStyleOverrides: true,
        builder: (_) => const HyperColorPickerPage(),
      ),
      GalleryItem(
        id: 'hyper-select-fields',
        title: '选择与自动补全',
        description: '搜索、多选、异步分页与多种弹出方式。',
        icon: Icons.manage_search,
        hasStyleOverrides: true,
        builder: (_) => const HyperSelectFieldsPage(),
      ),
      GalleryItem(
        id: 'hyper-slider',
        title: '滑块',
        description: '单值、范围和垂直滑块；共享四端尺寸与主题。',
        icon: Icons.tune,
        hasStyleOverrides: true,
        builder: (_) => const HyperSliderPage(),
      ),
      GalleryItem(
        id: 'hyper-segmented-button',
        title: '分段按钮',
        description: '单选、多选、图标和连接布局。',
        icon: Icons.view_week_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperSegmentedButtonPage(),
      ),
      GalleryItem(
        id: 'hyper-chip',
        title: '选择标签',
        description: '操作、单选、多选、头像和独立删除。',
        icon: Icons.label_outline,
        hasStyleOverrides: true,
        builder: (_) => const HyperChipPage(),
      ),
    ],
  ),
  GallerySection(
    title: '反馈与状态',
    items: [
      GalleryItem(
        id: 'hyper-progress-indicator',
        title: '进度',
        description: '线性、圆形、确定进度与不确定进度。',
        icon: Icons.data_usage,
        hasStyleOverrides: true,
        builder: (_) => const HyperProgressPage(),
      ),
      GalleryItem(
        id: 'hyper-notification',
        title: '通知卡片',
        description: '通知卡片、已读状态与独立操作。',
        icon: Icons.notifications_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperNotificationPage(),
      ),
      GalleryItem(
        id: 'hyper-loading-overlay',
        title: '加载遮罩',
        description: '区域和整页加载、延迟显示、点击拦截与取消。',
        icon: Icons.hourglass_empty,
        hasStyleOverrides: true,
        builder: (_) => const HyperLoadingOverlayPage(),
      ),
      GalleryItem(
        id: 'hyper-notice',
        title: '警告与横幅提示',
        description: '四种状态、内联提示、页面横幅、操作与关闭。',
        icon: Icons.info_outline,
        hasStyleOverrides: true,
        builder: (_) => const HyperNoticePage(),
      ),
      GalleryItem(
        id: 'hyper-bottom-sheet',
        title: '底部面板',
        description: '高度、拖动关闭、边框圆角、正文滚动与固定操作区。',
        icon: Icons.vertical_align_bottom,
        hasStyleOverrides: true,
        builder: (_) => const HyperBottomSheetPage(),
      ),
      GalleryItem(
        id: 'hyper-message',
        title: '轻提示与消息条',
        description: '轻提示、操作提示、队列、位置和主题覆盖。',
        icon: Icons.notifications_none,
        hasStyleOverrides: true,
        builder: (_) => const HyperMessagePage(),
      ),
      GalleryItem(
        id: 'hyper-dialog',
        title: '对话框',
        description: '位置、边框、圆角、按钮排列和自由内容。',
        icon: Icons.web_asset_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperDialogPage(),
      ),
      GalleryItem(
        id: 'hyper-empty-state',
        title: '空状态',
        description: '暂无数据、搜索无结果、加载失败及自定义内容。',
        icon: Icons.inbox_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperResultEmptyPage(),
      ),
      GalleryItem(
        id: 'hyper-skeleton',
        title: '骨架屏',
        description: '基础形状、微光、呼吸及加载内容过渡。',
        icon: Icons.view_agenda_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperSkeletonPage(),
      ),
    ],
  ),
  GallerySection(
    title: '按钮与操作',
    items: [
      GalleryItem(
        id: 'hyper-button',
        title: '按钮',
        description: '六种变体、图标文字与自动异步进度。',
        icon: Icons.ads_click_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperButtonPage(),
      ),
      GalleryItem(
        id: 'hyper-button-theme',
        title: '按钮主题',
        description: '公共样式、六种变体与局部主题覆盖。',
        icon: Icons.smart_button_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperButtonThemePage(),
      ),
      GalleryItem(
        id: 'hyper-icon-button',
        title: '图标按钮',
        description: '四种变体、异步进度、Tooltip 与材质。',
        icon: Icons.radio_button_checked,
        hasStyleOverrides: true,
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
        title: '侧边栏',
        description: '分组、树形、折叠与悬停子菜单。',
        icon: Icons.view_sidebar_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperSidebarPage(),
      ),
    ],
  ),
  GallerySection(
    title: '标签导航',
    items: [
      GalleryItem(
        id: 'hyper-tab-bar',
        title: '标签栏',
        description: '底槽、独立圆角与下划线标签。',
        icon: Icons.tab_outlined,
        builder: (_) => const HyperTabBarPage(),
      ),
      GalleryItem(
        id: 'hyper-steps',
        title: '步骤导航',
        description: '步骤状态、横纵布局和受控导航。',
        icon: Icons.format_list_numbered,
        hasStyleOverrides: true,
        builder: (_) => const HyperStepsPage(),
      ),
      GalleryItem(
        id: 'hyper-pagination',
        title: '分页',
        description: '受控页码、省略号与首尾导航。',
        icon: Icons.more_horiz,
        hasStyleOverrides: true,
        builder: (_) => const HyperPaginationPage(),
      ),
      GalleryItem(
        id: 'hyper-page-indicator',
        title: '页面指示器',
        description: '圆点、数字与 PageView 受控联动。',
        icon: Icons.more_horiz,
        hasStyleOverrides: true,
        builder: (_) => const HyperPageIndicatorPage(),
      ),
      GalleryItem(
        id: 'hyper-breadcrumb',
        title: '面包屑',
        description: '胶囊路径、节点点击和长路径滚动。',
        icon: Icons.chevron_right,
        hasStyleOverrides: true,
        builder: (_) => const HyperBreadcrumbPage(),
      ),
    ],
  ),
  GallerySection(
    title: '顶部导航与菜单',
    audience: GalleryAudience.desktop,
    items: [
      GalleryItem(
        id: 'hyper-top-navigation',
        title: '顶部导航',
        description: '横向顶部导航、多级菜单与描述文字。',
        icon: Icons.navigation_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperTopNavigationPage(),
      ),
      GalleryItem(
        id: 'hyper-menu',
        title: '菜单',
        description: '分组操作、选择状态与键盘导航。',
        icon: Icons.menu_open_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperMenuPage(),
      ),
    ],
  ),
  GallerySection(
    title: '操作与提示',
    audience: GalleryAudience.desktop,
    items: [
      GalleryItem(
        id: 'hyper-tooltip',
        title: '悬停提示',
        description: '悬停与焦点提示，支持延迟、避让和替换动画。',
        icon: Icons.info_outline,
        hasStyleOverrides: true,
        builder: (_) => const HyperTooltipPage(),
      ),
    ],
  ),
  GallerySection(
    title: '业务组合示例',
    items: [
      GalleryItem(
        id: 'hyper-notification-center',
        title: '通知中心组合示例',
        description: '业务示例：组合单条通知，实现分组和批量操作。',
        icon: Icons.notifications_active_outlined,
        hasStyleOverrides: true,
        builder: (_) => const HyperNotificationCenterPage(),
      ),
    ],
  ),
  GallerySection(
    title: '表单',
    items: [
      GalleryItem(
        id: 'hyper-form',
        title: '表单',
        description: '横排、竖排与无标题布局，字段校验与提交。',
        icon: Icons.assignment_outlined,
        builder: (_) => const HyperFormPage(),
      ),
      GalleryItem(
        id: 'hyper-form-actions',
        title: '表单操作',
        description: '统一提交、重置、取消与加载状态。',
        icon: Icons.rule_folder_outlined,
        builder: (_) => const HyperFormActionsPage(),
      ),
      GalleryItem(
        id: 'hyper-text-area',
        title: '多行文本',
        description: '内容增长、字数限制与 Form 校验。',
        icon: Icons.notes_outlined,
        builder: (_) => const HyperTextAreaPage(),
      ),
    ],
  ),
];

/// 按注册顺序展开全部演示页。
List<GalleryItem> get galleryItems => [
  for (final section in gallerySections) ...section.items,
];
