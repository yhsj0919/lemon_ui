import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../gallery/gallery_registry.dart';
import '../gallery/gallery_item.dart';

/// 分类只展开列表，点击具体组件后才切换受控页面。
class EditorComponentNavigation extends StatefulWidget {
  const EditorComponentNavigation({
    super.key,
    required this.page,
    required this.onSelected,
  });
  final String page;
  final ValueChanged<String> onSelected;
  @override
  State<EditorComponentNavigation> createState() =>
      _EditorComponentNavigationState();
}

class _EditorComponentNavigationState extends State<EditorComponentNavigation>
    with TickerProviderStateMixin {
  TabController? _categoryController;
  Duration? _duration;
  int? _browsingCategory;
  static final _categoryDefinitions = [
    (
      label: '业务',
      icon: Icons.dashboard_customize_outlined,
      sections: ['业务组合示例'],
    ),
    (label: '未确认', icon: Icons.pending_outlined, sections: ['未确认']),
    (label: '基础', icon: Icons.tune, sections: ['基础能力', '交互基础']),
    (label: '容器', icon: Icons.view_agenda_outlined, sections: ['容器与表面']),
    (label: '内容', icon: Icons.text_fields, sections: ['文字与内容']),
    (label: '表单', icon: Icons.assignment_outlined, sections: ['表单']),
    (
      label: '输入',
      icon: Icons.touch_app_outlined,
      sections: ['输入控件', '选择控件', '按钮与操作'],
    ),
    (
      label: '反馈',
      icon: Icons.notifications_outlined,
      sections: ['反馈与状态', '操作与提示'],
    ),
    (
      label: '导航',
      icon: Icons.explore_outlined,
      sections: ['页面框架', '抽屉导航', '侧边导航', '标签导航', '顶部导航与菜单'],
    ),
  ];
  static final _categories = _categoryDefinitions
      .where(
        (category) => gallerySections.any(
          (section) =>
              category.sections.contains(section.title) &&
              section.items.isNotEmpty,
        ),
      )
      .toList();
  List<GalleryItem> _items(int category) => [
    for (final section in gallerySections)
      if (_categories[category].sections.contains(section.title))
        ...section.items,
  ];
  int get _pageCategory => widget.page == 'all'
      ? -1
      : _categories.indexWhere(
          (category) => gallerySections.any(
            (section) =>
                category.sections.contains(section.title) &&
                section.items.any((item) => item.id == widget.page),
          ),
        );
  int get _category => _browsingCategory ?? _pageCategory;
  @override
  void didUpdateWidget(EditorComponentNavigation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.page != widget.page) _browsingCategory = null;
    _syncControllers();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : HyperTheme.of(context).motion.standardDuration;
    if (_duration != duration) {
      _disposeControllers();
      _duration = duration;
      _categoryController = TabController(
        length: _categories.length + 1,
        vsync: this,
        initialIndex: _category + 1,
        animationDuration: duration,
      );
    }
  }

  void _syncControllers() {
    final curve = HyperTheme.of(context).motion.standardCurve;
    _categoryController?.animateTo(
      _category + 1,
      duration: _duration,
      curve: curve,
    );
  }

  void _disposeControllers() {
    _categoryController?.dispose();
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  Widget _tab(BuildContext context, String label, IconData icon) {
    final sizes = HyperTheme.sizesOf(context);
    return HyperTab(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: sizes.menu.iconSize),
          SizedBox(width: sizes.menu.iconSpacing),
          Text(label),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final category = _category;
    final items = category < 0 ? <GalleryItem>[] : _items(category);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final theme = HyperTheme.of(context);
            final sizes = HyperTheme.sizesOf(context);
            final painter = TextPainter(
              text: TextSpan(
                text: '完整 Demo',
                style: theme.textTheme.labelLarge?.copyWith(
                  fontSize: theme.typography.control,
                  fontWeight: FontWeight.w600,
                ),
              ),
              textDirection: Directionality.of(context),
              textScaler: MediaQuery.textScalerOf(context),
            )..layout();
            final itemWidth =
                painter.width +
                sizes.menu.iconSize +
                sizes.menu.iconSpacing +
                sizes.controlPadding.horizontal +
                sizes.overlaySpacing * 2;
            painter.dispose();
            final minimumWidth = itemWidth * (_categories.length + 1);
            final width = constraints.maxWidth < minimumWidth
                ? minimumWidth
                : constraints.maxWidth;
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: width,
                child: HyperTabBar(
                  controller: _categoryController,
                  isScrollable: false,
                  tabs: [
                    _tab(context, '完整 Demo', Icons.dashboard_outlined),
                    for (final item in _categories)
                      _tab(context, item.label, item.icon),
                  ],
                  onTap: (index) {
                    if (index == 0) {
                      setState(() => _browsingCategory = null);
                      widget.onSelected('all');
                      return;
                    }
                    final target = index - 1;
                    setState(() => _browsingCategory = target);
                  },
                ),
              ),
            );
          },
        ),
        if (items.isNotEmpty) ...[
          SizedBox(height: HyperTheme.sizesOf(context).overlaySpacing),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final item in items)
                  Semantics(
                    selected: widget.page == item.id,
                    child: HyperButton.ghost(
                      onPressed: () => widget.onSelected(item.id),
                      style: HyperButtonStyle(
                        background: widget.page == item.id
                            ? HyperFill.color(
                                HyperTheme.of(context).colors.primaryContainer,
                              )
                            : const HyperFill.none(),
                        foregroundColor: widget.page == item.id
                            ? HyperTheme.of(context).colors.primary
                            : HyperTheme.of(context).colors.textPrimary,
                        contrastMode: HyperContrastMode.standard,
                      ),
                      icon: Icon(item.icon),
                      label: Text(_label(item.id)),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: HyperTheme.sizesOf(context).overlaySpacing),
        ],
        if (items.isEmpty)
          SizedBox(
            height:
                HyperTheme.sizesOf(context).tabBar.height +
                HyperTheme.sizesOf(context).overlaySpacing * 2,
          ),
      ],
    );
  }
}

String _label(String id) => switch (id) {
  'hyper-table' => '数据表格',
  'hyper-scrolling-text' => '滚动文字',
  'hyper-color-picker' => '颜色选择器',
  'hyper-fill' => '填充',
  'hyper-container-theme' => '容器主题',
  'hyper-color-scheme' => '语义颜色',
  'hyper-theme' => '基础主题',
  'hyper-size-scheme' => '尺寸规格',
  'hyper-typography-scheme' => '字体规格',
  'hyper-device-detector' => '设备识别',
  'hyper-state-value' => '状态属性',
  'hyper-motion-theme' => '动画主题',
  'hyper-app-bar' => '顶栏',
  'hyper-drawer' => '抽屉',
  'hyper-container' => '容器',
  'hyper-collapsible' => '折叠面板',
  'hyper-card' => '卡片',
  'hyper-widget-group' => '控件组',
  'hyper-material-surface' => '材质表面',
  'hyper-tree-view' => '树形列表',
  'hyper-tree-select' => '树形选择',
  'hyper-text-area' => '多行文本',
  'hyper-form-actions' => '表单操作',
  'hyper-result' => '结果页',
  'hyper-description-list' => '描述列表',
  'hyper-timeline' => '时间线',
  'hyper-text' => '文字',
  'hyper-icon' => '图标',
  'hyper-badge' => '徽标',
  'hyper-avatar' => '头像',
  'hyper-tag' => '标签',
  'hyper-divider' => '分隔线',
  'hyper-line' => '线条样式',
  'hyper-list-tile' => '列表项',
  'hyper-anchored-overlay' => '锚定浮层基础设施',
  'hyper-image-preview' => '图片预览',
  'hyper-image-editor' => '图片编辑',
  'hyper-image' => '图片',
  'hyper-popover' => '锚定面板',
  'hyper-pressable' => '按压交互',
  'hyper-text-field' => '文本输入',
  'hyper-select-fields' => '选择与自动补全',
  'hyper-checkbox' => '复选框',
  'hyper-radio' => '单选框',
  'hyper-switch' => '开关',
  'hyper-slider' => '滑块',
  'hyper-segmented-button' => '分段按钮',
  'hyper-chip' => '选择标签',
  'hyper-notification-center' => '通知中心',
  'hyper-notification' => '通知卡片',
  'hyper-loading-overlay' => '加载遮罩',
  'hyper-notice' => '提示横幅',
  'hyper-bottom-sheet' => '底部面板',
  'hyper-message' => '轻提示',
  'hyper-dialog' => '对话框',
  'hyper-empty-state' => '空状态',
  'hyper-skeleton' => '骨架屏',
  'hyper-progress-indicator' => '进度',
  'hyper-button' => '按钮',
  'hyper-button-theme' => '按钮主题',
  'hyper-icon-button' => '图标按钮',
  'hyper-sidebar' => '侧栏',
  'hyper-tab-bar' => '标签栏',
  'hyper-steps' => '步骤导航',
  'hyper-pagination' => '分页',
  'hyper-page-indicator' => '页面指示器',
  'hyper-breadcrumb' => '面包屑',
  'hyper-top-navigation' => '顶部导航',
  'hyper-menu' => '菜单',
  'hyper-tooltip' => '悬停提示',
  _ => galleryItems.where((item) => item.id == id).firstOrNull?.title ?? id,
};
