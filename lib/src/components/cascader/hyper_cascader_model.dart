import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' show Widget;

/// A branch loader receives the complete ancestor path, including the parent.
typedef HyperCascaderChildrenLoader<T> =
    Future<List<HyperCascaderNode<T>>> Function(
      List<HyperCascaderNode<T>> path,
    );

/// A labeled leaf or branch of a cascade tree.
///
/// Each value must be unique across the tree and have stable equality.
@immutable
class HyperCascaderNode<T> {
  const HyperCascaderNode({
    required this.value,
    required this.label,
    this.children = const [],
    this.hasChildren = false,
    this.enabled = true,
    this.leading,
  });

  final T value;
  final String label;
  final List<HyperCascaderNode<T>> children;

  /// Whether this node has children that may need asynchronous loading.
  ///
  /// A successful empty result stays an empty branch;
  /// it does not silently become a selectable leaf.
  final bool hasChildren;
  final bool enabled;
  final Widget? leading;
}

/// Owns navigation and per-branch loading, never the caller's selection.
class HyperCascaderController<T> extends ChangeNotifier {
  HyperCascaderController({
    required List<HyperCascaderNode<T>> nodes,
    this.loadChildren,
    this.maxDepth,
  }) {
    if (maxDepth != null && maxDepth! < 1) {
      throw ArgumentError.value(maxDepth, 'maxDepth');
    }
    _roots = _snapshot(nodes, <T>{});
  }

  final HyperCascaderChildrenLoader<T>? loadChildren;

  /// The displayed depth limit; null retains the complete tree.
  final int? maxDepth;
  late final List<HyperCascaderNode<T>> _roots;
  final _index = <T, HyperCascaderNode<T>>{};
  final _children = <T, List<HyperCascaderNode<T>>>{};
  final _requests = <T, Future<void>>{};
  final _errors = <T, Object>{};
  List<HyperCascaderNode<T>> _path = const [];
  int _navigation = 0;
  bool _disposed = false;

  List<HyperCascaderNode<T>> get nodes => _roots;
  List<HyperCascaderNode<T>> get path => _path;
  List<HyperCascaderNode<T>> get options =>
      _path.isEmpty ? _roots : childrenOf(_path.last);
  bool get loading =>
      _path.isNotEmpty && _requests.containsKey(_path.last.value);
  Object? get error => _path.isEmpty ? null : _errors[_path.last.value];

  /// Whether the indicated branch has an in-progress request.
  bool isLoading(T value) => _requests.containsKey(value);

  /// Whether a dynamic branch has a cached successful result, including empty.
  bool hasLoaded(T value) => _children.containsKey(value);

  /// The last error for the indicated branch, if any.
  Object? errorFor(T value) => _errors[value];

  /// Loads a branch without changing the current browsing path.
  Future<void> loadBranch(List<HyperCascaderNode<T>> path) {
    if (_disposed || path.isEmpty) return Future.value();
    return _load(path);
  }

  List<HyperCascaderNode<T>> childrenOf(HyperCascaderNode<T> node) =>
      _children[node.value] ?? node.children;
  bool isBranch(HyperCascaderNode<T> node) =>
      node.hasChildren || node.children.isNotEmpty;

  List<HyperCascaderNode<T>> _snapshot(
    List<HyperCascaderNode<T>> nodes,
    Set<T> seen, [
    int depth = 0,
  ]) {
    // Validate before committing any of an async response to the index.
    void validate(List<HyperCascaderNode<T>> items) {
      for (final node in items) {
        if (_index.containsKey(node.value) || !seen.add(node.value)) {
          throw ArgumentError('级联节点 value 必须全局唯一，不允许循环。');
        }
        validate(node.children);
      }
    }

    validate(nodes);
    List<HyperCascaderNode<T>> copy(
      List<HyperCascaderNode<T>> items,
      int level,
    ) => List.unmodifiable([
      for (final node in items)
        _index[node.value] = HyperCascaderNode<T>(
          value: node.value,
          label: node.label,
          children: maxDepth != null && level + 1 >= maxDepth!
              ? const []
              : copy(node.children, level + 1),
          hasChildren:
              (maxDepth == null || level + 1 < maxDepth!) && node.hasChildren,
          enabled: node.enabled,
          leading: node.leading,
        ),
    ]);
    return copy(nodes, depth);
  }

  /// Resolves only contiguous, known ancestors.
  ///
  /// Unknown imported values remain
  /// owned by the caller and are never rewritten by the controller.
  List<HyperCascaderNode<T>> resolvePath(List<T> values) {
    var options = _roots;
    final result = <HyperCascaderNode<T>>[];
    for (final value in values) {
      final matches = options.where((node) => node.value == value);
      if (matches.isEmpty) break;
      final node = matches.first;
      result.add(node);
      options = childrenOf(node);
    }
    return List.unmodifiable(result);
  }

  /// Restores the selected branch on open, loading missing ancestors as needed.
  ///
  /// A later navigation gesture always wins over this asynchronous restoration.
  Future<void> browse(List<T> values) async {
    if (_disposed) return;
    final navigation = ++_navigation;
    _path = const [];
    notifyListeners();
    var options = _roots;
    for (final value in List<T>.of(values)) {
      if (_disposed || navigation != _navigation) return;
      final matches = options.where((node) => node.value == value);
      if (matches.isEmpty) return;
      final node = matches.first;
      if (!node.enabled || !isBranch(node)) return;
      _path = List.unmodifiable([..._path, node]);
      notifyListeners();
      await _load(_path);
      if (_disposed || navigation != _navigation || error != null) return;
      options = childrenOf(node);
    }
  }

  Future<void> enter(HyperCascaderNode<T> node) async {
    if (_disposed ||
        !node.enabled ||
        !isBranch(node) ||
        !options.contains(node)) {
      return;
    }
    ++_navigation;
    _path = List.unmodifiable([..._path, node]);
    notifyListeners();
    await _load(_path);
  }

  /// Keeps [depth] ancestors; zero returns to the roots.
  void goTo(int depth) {
    if (_disposed) return;
    RangeError.checkValueInInterval(depth, 0, _path.length, 'depth');
    ++_navigation;
    _path = List.unmodifiable(_path.take(depth));
    notifyListeners();
  }

  /// Stops restoration without discarding cached results from pending branches.
  void cancelNavigation() => ++_navigation;

  /// Retries loading the current branch without changing selection or position.
  Future<void> retry() async {
    if (_path.isNotEmpty) await _load(_path);
  }

  Future<void> _load(List<HyperCascaderNode<T>> path) {
    final parent = path.last;
    if (!parent.hasChildren ||
        parent.children.isNotEmpty ||
        _children.containsKey(parent.value)) {
      return Future.value();
    }
    final existing = _requests[parent.value];
    if (existing != null) return existing;
    final completed = Completer<void>();
    _requests[parent.value] = completed.future;
    _errors.remove(parent.value);
    notifyListeners();
    Future<void>(() async {
      try {
        if (loadChildren == null) {
          throw StateError('动态分支需要 loadChildren。');
        }
        final result = await loadChildren!(List.unmodifiable(path));
        if (!_disposed) {
          _children[parent.value] = _snapshot(result, <T>{}, path.length);
        }
      } catch (error) {
        if (!_disposed) _errors[parent.value] = error;
      } finally {
        _requests.remove(parent.value);
        if (!_disposed) notifyListeners();
        completed.complete();
      }
    });
    return completed.future;
  }

  @override
  void dispose() {
    _disposed = true;
    ++_navigation;
    super.dispose();
  }
}
