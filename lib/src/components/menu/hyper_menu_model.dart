import 'package:flutter/widgets.dart';

/// 弹出菜单中的一项操作。
@immutable
final class HyperMenuItem {
  const HyperMenuItem({
    required this.id,
    required this.label,
    this.leading,
    this.trailing,
    this.children = const [],
    this.enabled = true,
  });

  final String id;
  final String label;
  final Widget? leading;
  final Widget? trailing;

  /// 子菜单项；非空时当前项负责展开子菜单。
  final List<HyperMenuItem> children;
  final bool enabled;
}

/// 菜单分组；标题可省略，相邻分组仍保持分隔。
@immutable
final class HyperMenuGroup {
  const HyperMenuGroup({this.title, required this.items});

  final String? title;
  final List<HyperMenuItem> items;
}
