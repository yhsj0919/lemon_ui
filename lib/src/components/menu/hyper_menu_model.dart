import 'package:flutter/widgets.dart';

/// 弹出菜单中的一项操作。
@immutable
final class HyperMenuItem {
  const HyperMenuItem({
    required this.id,
    required this.label,
    this.description,
    this.leading,
    this.trailing,
    this.children = const [],
    this.enabled = true,
    this.onSubmenuOpened,
    this.onPressed,
    this.submenuIcon,
    this.wrapLabel = false,
  });

  final String id;
  final String label;

  /// 标题下方的辅助说明，支持多行；null 不占空间。
  final String? description;
  final Widget? leading;
  final Widget? trailing;

  /// 子菜单项；非空时当前项负责展开子菜单。
  final List<HyperMenuItem> children;
  final bool enabled;

  /// Called when this branch opens, including pointer and keyboard activation.
  final VoidCallback? onSubmenuOpened;

  /// A leaf action handled locally without dismissing ancestor menus.
  ///
  /// Useful for retry actions embedded in asynchronous submenus.
  final VoidCallback? onPressed;

  /// The branch indicator override; otherwise uses the directional chevron.
  final IconData? submenuIcon;

  /// Whether the label wraps instead of using the menu's single-line default.
  final bool wrapLabel;
}

/// 菜单分组；标题可省略，相邻分组仍保持分隔。
@immutable
final class HyperMenuGroup {
  const HyperMenuGroup({this.title, required this.items});

  final String? title;
  final List<HyperMenuItem> items;
}
