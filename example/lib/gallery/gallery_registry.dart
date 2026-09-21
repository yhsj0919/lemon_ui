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
import '../pages/container/hyper_container_page.dart';
import '../pages/button/hyper_button_theme_page.dart';
import '../pages/button/hyper_button_page.dart';
import '../pages/button/hyper_icon_button_page.dart';
import '../pages/interaction/hyper_pressable_page.dart';
import '../pages/surface/hyper_material_surface_page.dart';
import '../pages/selection/hyper_switch_page.dart';
import '../pages/selection/hyper_checkbox_page.dart';
import '../pages/selection/hyper_radio_page.dart';
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
        id: 'hyper-material-surface',
        title: 'HyperMaterialSurface',
        description: '普通、半透明、毛玻璃、柔光玻璃及明确降级。',
        icon: Icons.blur_on_outlined,
        builder: (_) => const HyperMaterialSurfacePage(),
      ),
    ],
  ),
  GallerySection(
    title: '交互基础',
    items: [
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
    title: '选择控件',
    items: [
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
];

/// 按注册顺序展开全部演示页。
List<GalleryItem> get galleryItems => [
  for (final section in gallerySections) ...section.items,
];
