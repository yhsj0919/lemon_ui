import 'package:flutter/widgets.dart';

/// A node used by [HyperTreeSelect]. Values must be unique across the tree.
@immutable
class HyperTreeSelectNode<T extends Object> {
  const HyperTreeSelectNode({
    required this.value,
    required this.label,
    this.children = const [],
    this.hasChildren = false,
    this.enabled = true,
    this.selectable = true,
    this.leading,
    this.trailing,
  });

  final T value;
  final String label;
  final List<HyperTreeSelectNode<T>> children;
  final bool hasChildren;
  final bool enabled;
  final bool selectable;
  final Widget? leading;
  final Widget? trailing;
}

typedef HyperTreeSelectChildrenLoader<T extends Object> =
    Future<List<HyperTreeSelectNode<T>>> Function(HyperTreeSelectNode<T> node);
