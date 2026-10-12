import 'package:flutter/widgets.dart';

enum HyperTreeLoadState { idle, loading, loaded, error }

typedef HyperTreeChildrenLoader<T> = Future<List<HyperTreeNode<T>>> Function(
  HyperTreeNode<T> node,
);

@immutable
class HyperTreeNode<T> {
  const HyperTreeNode({
    required this.id,
    required this.label,
    this.data,
    this.children = const [],
    this.hasChildren = false,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.selectable = true,
  });
  final Object id;
  final Widget label;
  final T? data;
  final List<HyperTreeNode<T>> children;

  /// 未提供静态子项时，以此标记可以动态加载的分支。
  final bool hasChildren;
  final Widget? leading, trailing;
  final bool enabled, selectable;
}

@immutable
class HyperTreeEntry<T> {
  const HyperTreeEntry(this.node, this.depth, this.parentId);
  final HyperTreeNode<T> node;
  final int depth;
  final Object? parentId;
}

/// 管理树展开、单选和子节点缓存。请求完成不改变用户之后的收起状态。
class HyperTreeController<T> extends ChangeNotifier {
  HyperTreeController({
    List<HyperTreeNode<T>> nodes = const [],
    this.loadChildren,
    Set<Object> expandedIds = const {},
    Object? selectedId,
  }) {
    _replace(nodes);
    for (final id in expandedIds) {
      if (!_index.containsKey(id)) {
        throw ArgumentError.value(id, 'expandedIds', '节点不存在');
      }
      _expanded.add(id);
    }
    if (selectedId != null && !_index.containsKey(selectedId)) {
      throw ArgumentError.value(selectedId, 'selectedId', '节点不存在');
    }
    _selectedId = selectedId;
  }
  final HyperTreeChildrenLoader<T>? loadChildren;
  List<HyperTreeNode<T>> _roots = const [];
  Map<Object, HyperTreeNode<T>> _index = {};
  final _children = <Object, List<HyperTreeNode<T>>>{};
  final _states = <Object, HyperTreeLoadState>{};
  final _errors = <Object, Object>{};
  final _requests = <Object, Future<void>>{};
  final _expanded = <Object>{};
  Object? _selectedId;
  int _generation = 0;
  bool _disposed = false;
  List<HyperTreeNode<T>> get nodes => _roots;
  Object? get selectedId => _selectedId;
  Set<Object> get expandedIds => Set.unmodifiable(_expanded);
  bool isExpanded(Object id) => _expanded.contains(id);
  HyperTreeNode<T>? nodeFor(Object id) => _index[id];
  HyperTreeLoadState loadState(Object id) =>
      _states[id] ?? HyperTreeLoadState.idle;
  Object? errorFor(Object id) => _errors[id];
  List<HyperTreeNode<T>> childrenOf(Object id) =>
      _children[id] ?? _index[id]?.children ?? const [];
  bool canExpand(Object id) {
    final node = _index[id];
    return node != null &&
        (childrenOf(id).isNotEmpty ||
            (node.hasChildren && loadState(id) != HyperTreeLoadState.loaded));
  }

  void _ensureAlive() {
    if (_disposed) {
      throw StateError('树控制器已经销毁。');
    }
  }

  Map<Object, HyperTreeNode<T>> _collect(List<HyperTreeNode<T>> nodes) {
    final result = <Object, HyperTreeNode<T>>{};
    void visit(HyperTreeNode<T> node) {
      if (result.containsKey(node.id)) {
        throw ArgumentError('树节点 id 必须全局唯一，不允许循环。');
      }
      result[node.id] = node;
      for (final child in node.children) {
        visit(child);
      }
    }

    for (final node in nodes) {
      visit(node);
    }
    return result;
  }

  HyperTreeNode<T> _freeze(HyperTreeNode<T> node) => HyperTreeNode<T>(
    id: node.id,
    label: node.label,
    data: node.data,
    children: List.unmodifiable(node.children.map(_freeze)),
    hasChildren: node.hasChildren,
    leading: node.leading,
    trailing: node.trailing,
    enabled: node.enabled,
    selectable: node.selectable,
  );
  void _replace(List<HyperTreeNode<T>> nodes) {
    _collect(nodes);
    final roots = List<HyperTreeNode<T>>.unmodifiable(nodes.map(_freeze));
    _index = _collect(roots);
    _roots = roots;
  }

  /// 替换数据使旧请求失效；无效的新数据不会清空当前数据。
  void replaceNodes(List<HyperTreeNode<T>> nodes) {
    _ensureAlive();
    _replace(nodes);
    _generation++;
    _children.clear();
    _states.clear();
    _errors.clear();
    _requests.clear();
    _expanded.removeWhere((id) => !_index.containsKey(id));
    if (!_index.containsKey(_selectedId)) {
      _selectedId = null;
    }
    notifyListeners();
  }

  void select(Object? id) {
    _ensureAlive();
    if (id != null) {
      final node = _index[id];
      if (node == null) {
        throw ArgumentError.value(id, 'id', '节点不存在');
      }
      if (!node.enabled || !node.selectable) {
        return;
      }
    }
    if (_selectedId == id) {
      return;
    }
    _selectedId = id;
    notifyListeners();
  }

  Future<void> setExpanded(Object id, bool value) {
    _ensureAlive();
    final node = _index[id];
    if (node == null) {
      throw ArgumentError.value(id, 'id', '节点不存在');
    }
    if (!node.enabled || !canExpand(id)) {
      return Future.value();
    }
    if (value) {
      _expanded.add(id);
    } else {
      _expanded.remove(id);
    }
    notifyListeners();
    return value ? ensureLoaded(id) : Future.value();
  }

  Future<void> ensureLoaded(Object id) {
    _ensureAlive();
    final node = _index[id];
    if (node == null) {
      throw ArgumentError.value(id, 'id', '节点不存在');
    }
    if (!node.enabled ||
        !node.hasChildren ||
        node.children.isNotEmpty ||
        loadChildren == null ||
        loadState(id) == HyperTreeLoadState.loaded) {
      return Future.value();
    }
    final pending = _requests[id];
    if (pending != null) {
      return pending;
    }
    final generation = _generation;
    _states[id] = HyperTreeLoadState.loading;
    _errors.remove(id);
    // 在通知前登记请求，避免监听者重入时重复发起请求。
    final request = Future<void>(() async {
      if (_disposed || generation != _generation) {
        return;
      }
      try {
        final response = await loadChildren!(node);
        if (_disposed || generation != _generation) {
          return;
        }
        final additions = _collect(response);
        if (additions.keys.any(_index.containsKey)) {
          throw ArgumentError('动态子节点 id 与已有节点重复。');
        }
        final frozen = List<HyperTreeNode<T>>.unmodifiable(
          response.map(_freeze),
        );
        _index.addAll(_collect(frozen));
        _children[id] = frozen;
        _states[id] = HyperTreeLoadState.loaded;
      } catch (error) {
        if (_disposed || generation != _generation) {
          return;
        }
        _states[id] = HyperTreeLoadState.error;
        _errors[id] = error;
      } finally {
        if (!_disposed && generation == _generation) {
          _requests.remove(id);
          notifyListeners();
        }
      }
    });
    _requests[id] = request;
    notifyListeners();
    return request;
  }

  List<HyperTreeEntry<T>> get visibleEntries {
    final result = <HyperTreeEntry<T>>[];
    void visit(HyperTreeNode<T> node, int depth, Object? parent) {
      result.add(HyperTreeEntry(node, depth, parent));
      if (_expanded.contains(node.id)) {
        for (final child in childrenOf(node.id)) {
          visit(child, depth + 1, node.id);
        }
      }
    }

    for (final node in _roots) {
      visit(node, 0, null);
    }
    return List.unmodifiable(result);
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    super.dispose();
  }
}
