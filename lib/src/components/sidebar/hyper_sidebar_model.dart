import 'package:flutter/widgets.dart';

/// 选中项使用轻色背景或实色背景。
enum HyperSidebarSelectionStyle { text, fill }

/// 菜单项当前状态，供自定义构建器决定视觉与行为。
@immutable
final class HyperSidebarItemState {
  const HyperSidebarItemState({
    required this.selected,
    required this.ancestorSelected,
    required this.expanded,
    required this.collapsed,
    required this.enabled,
  });

  final bool selected;
  final bool ancestorSelected;
  final bool expanded;
  final bool collapsed;
  final bool enabled;
}

/// 自定义菜单行；defaultItem 提供完整的主题、交互与语义实现。
typedef HyperSidebarItemBuilder = Widget Function(
  BuildContext context,
  HyperSidebarItemState state,
  Widget defaultItem,
);

/// 替换侧栏展开与折叠时菜单内容的过渡；visibility 从 0 到 1。
typedef HyperSidebarContentTransitionBuilder = Widget Function(
  BuildContext context,
  double visibility,
  Widget child,
);

/// 替换侧栏宽度过渡的布局；width 是当前动画宽度。
typedef HyperSidebarWidthTransitionBuilder = Widget Function(
  BuildContext context,
  double width,
  Widget child,
);

/// 替换树形子项的开合过渡；animation 从 0（收起）到 1（展开）。
typedef HyperSidebarChildrenTransitionBuilder = Widget Function(
  BuildContext context,
  Animation<double> animation,
  Widget child,
);

/// 一项导航或可展开的子菜单。
@immutable
final class HyperSidebarItem {
  const HyperSidebarItem({
    required this.id,
    required this.label,
    this.description,
    this.icon,
    this.badge,
    this.children = const [],
    this.enabled = true,
    this.selectableParent = false,
    this.builder,
  });

  /// 同一侧栏内必须唯一。
  final String id;
  final String label;
  final String? description;
  final Widget? icon;
  final Widget? badge;
  final List<HyperSidebarItem> children;
  final bool enabled;
  final bool selectableParent;
  final HyperSidebarItemBuilder? builder;
}

/// 一组菜单项；标题为空时只提供分组间距。
@immutable
final class HyperSidebarGroup {
  const HyperSidebarGroup({this.title, required this.items});

  final String? title;
  final List<HyperSidebarItem> items;
}
