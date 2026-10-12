import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../foundation/hyper_device_type.dart';

@immutable
final class HyperSelectOption<T> {
  const HyperSelectOption({
    required this.value,
    required this.label,
    this.leading,
    this.trailing,
    this.enabled = true,
  });
  final T value;
  final String label;
  final Widget? leading, trailing;
  final bool enabled;
}

enum HyperSelectPagination { none, page, cursor }

enum HyperSelectCachePolicy { none, query }

enum HyperSelectPresentation {
  adaptive,
  anchored,
  trailing,
  bottomSheet,
  fullScreen,
}

/// 中文等输入法提交组合文本后才发起查询。
bool hyperSelectCanQuery(TextEditingValue value) =>
    !value.composing.isValid || value.composing.isCollapsed;

/// 默认呈现按真实设备类别解析，显式选择不受设备或窗口宽度限制。
HyperSelectPresentation hyperResolveSelectPresentation(
  HyperSelectPresentation presentation,
  HyperDeviceType device,
) => presentation != HyperSelectPresentation.adaptive
    ? presentation
    : device == HyperDeviceType.desktop
    ? HyperSelectPresentation.anchored
    : HyperSelectPresentation.bottomSheet;

@immutable
class HyperSelectQuery {
  const HyperSelectQuery({
    required this.text,
    this.page = 1,
    this.cursor,
    this.pageSize = 20,
  });
  final String text;
  final int page, pageSize;
  final Object? cursor;
}

@immutable
class HyperSelectPage<T> {
  const HyperSelectPage({
    required this.options,
    this.hasMore = false,
    this.nextCursor,
  });
  final List<HyperSelectOption<T>> options;
  final bool hasMore;
  final Object? nextCursor;
}

typedef HyperSelectLoader<T> = Future<HyperSelectPage<T>> Function(
  HyperSelectQuery query,
);

@immutable
class HyperSelectSource<T> {
  const HyperSelectSource.static(this.options)
    : loader = null,
      pagination = HyperSelectPagination.none,
      cachePolicy = HyperSelectCachePolicy.none,
      pageSize = 20,
      cacheCapacity = 20;
  const HyperSelectSource.async({
    required this.loader,
    this.pagination = HyperSelectPagination.none,
    this.cachePolicy = HyperSelectCachePolicy.query,
    this.pageSize = 20,
    this.cacheCapacity = 20,
  }) : options = const [],
       assert(pageSize > 0),
       assert(cacheCapacity > 0);
  final List<HyperSelectOption<T>> options;
  final HyperSelectLoader<T>? loader;
  final HyperSelectPagination pagination;
  final HyperSelectCachePolicy cachePolicy;
  final int pageSize, cacheCapacity;
}

class _Snapshot<T> {
  const _Snapshot(
    this.options,
    this.hasMore,
    this.nextPage,
    this.cursor,
    this.cursors,
  );
  final List<HyperSelectOption<T>> options;
  final bool hasMore;
  final int nextPage;
  final Object? cursor;
  final Set<Object> cursors;
}

/// 选项查询与分页；不管理选择、焦点、输入框或弹出路由。
class HyperSelectOptionsController<T> extends ChangeNotifier {
  HyperSelectOptionsController(this.source) {
    _staticOptions = List.unmodifiable(source.options);
    if (source.pageSize < 1 || source.cacheCapacity < 1) {
      throw ArgumentError('pageSize 与 cacheCapacity 必须为正。');
    }
    _validate(_staticOptions);
  }
  final HyperSelectSource<T> source;
  late final List<HyperSelectOption<T>> _staticOptions;
  final _cache = <String, _Snapshot<T>>{};
  final _cursors = <Object>{};
  List<HyperSelectOption<T>> _options = const [];
  String _query = '';
  bool _loading = false,
      _loadingMore = false,
      _hasMore = false,
      _disposed = false;
  bool _loaded = false;
  Object? _error, _moreError, _cursor;
  int _generation = 0, _nextPage = 1;
  Future<void>? _pending;
  List<HyperSelectOption<T>> get options => _options;
  String get query => _query;
  bool get loading => _loading;
  bool get loadingMore => _loadingMore;
  bool get hasMore => _hasMore;
  bool get loaded => _loaded;
  Object? get error => _error;
  Object? get moreError => _moreError;
  void _alive() {
    if (_disposed) {
      throw StateError('选项控制器已销毁。');
    }
  }

  void _validate(List<HyperSelectOption<T>> options) {
    final ids = <T>{};
    for (final option in options) {
      if (option.value == null || !ids.add(option.value)) {
        throw ArgumentError('选项 value 必须非空且唯一，文字可以重复。');
      }
    }
  }

  /// 输入变化先废弃旧请求，再由视图防抖发起 load。
  void invalidate(String query) {
    _alive();
    _generation++;
    _pending = null;
    _query = query.trim();
    _options = const [];
    _loaded = false;
    _loading = false;
    _loadingMore = false;
    _hasMore = false;
    _error = null;
    _moreError = null;
    _cursor = null;
    _cursors.clear();
    _nextPage = 1;
    notifyListeners();
  }

  Future<void> load(String query, {bool refresh = false}) {
    _alive();
    final text = query.trim();
    if (!refresh && text == _query && _pending != null) {
      return _pending!;
    }
    if (!refresh && text == _query && _loaded) {
      return Future.value();
    }
    invalidate(text);
    if (source.loader == null) {
      final needle = text.toLowerCase();
      _options = List.unmodifiable(
        _staticOptions.where((o) => o.label.toLowerCase().contains(needle)),
      );
      _loaded = true;
      notifyListeners();
      return Future.value();
    }
    if (refresh) {
      _cache.remove(text);
    }
    final cached = _cache[text];
    if (cached != null) {
      _options = cached.options;
      _hasMore = cached.hasMore;
      _nextPage = cached.nextPage;
      _cursor = cached.cursor;
      _cursors.addAll(cached.cursors);
      _loaded = true;
      notifyListeners();
      return Future.value();
    }
    return _request(append: false);
  }

  Future<void> loadMore() {
    _alive();
    if (_pending != null) {
      return _pending!;
    }
    if (!_loaded || !_hasMore) {
      return Future.value();
    }
    return _request(append: true);
  }

  Future<void> retry() =>
      _error != null ? load(_query, refresh: true) : loadMore();
  Future<void> _request({required bool append}) {
    final generation = _generation;
    final request = HyperSelectQuery(
      text: _query,
      page: append ? _nextPage : 1,
      cursor: append ? _cursor : null,
      pageSize: source.pageSize,
    );
    if (append) {
      _loadingMore = true;
      _moreError = null;
    } else {
      _loading = true;
      _error = null;
    }
    final future = Future<void>(() async {
      if (_disposed || generation != _generation) {
        return;
      }
      try {
        final response = await source.loader!(request);
        if (_disposed || generation != _generation) {
          return;
        }
        _validate(response.options);
        final more =
            source.pagination != HyperSelectPagination.none &&
            response.hasMore &&
            response.options.isNotEmpty;
        if (more &&
            source.pagination == HyperSelectPagination.cursor &&
            (response.nextCursor == null ||
                response.nextCursor == request.cursor ||
                _cursors.contains(response.nextCursor))) {
          throw StateError('有后续页时必须返回前进的非空游标。');
        }
        final combined = <T, HyperSelectOption<T>>{
          if (append)
            for (final option in _options) option.value: option,
        };
        for (final option in response.options) {
          combined[option.value] = option;
        }
        // 只有验证成功才提交页面，重复值保留原位置并更新标签。
        _options = List.unmodifiable(combined.values);
        _hasMore = more;
        _nextPage = request.page + 1;
        _cursor = response.nextCursor;
        _loaded = true;
        if (more && source.pagination == HyperSelectPagination.cursor) {
          _cursors.add(response.nextCursor!);
        }
        if (source.cachePolicy == HyperSelectCachePolicy.query) {
          _cache.remove(request.text);
          _cache[request.text] = _Snapshot(
            _options,
            _hasMore,
            _nextPage,
            _cursor,
            Set.unmodifiable(_cursors),
          );
          while (_cache.length > source.cacheCapacity) {
            _cache.remove(_cache.keys.first);
          }
        }
      } catch (error) {
        if (_disposed || generation != _generation) {
          return;
        }
        if (append) {
          _moreError = error;
        } else {
          _error = error;
        }
      } finally {
        if (!_disposed && generation == _generation) {
          _pending = null;
          _loading = false;
          _loadingMore = false;
          notifyListeners();
        }
      }
    });
    _pending = future;
    notifyListeners();
    return future;
  }

  @override
  void dispose() {
    _disposed = true;
    _generation++;
    super.dispose();
  }
}

/// 纯选择规则，返回不可变集合；取消不受选择上限影响。
Set<T> hyperToggleSelect<T>(
  Set<T> selected,
  HyperSelectOption<T> option, {
  int? maximum,
}) {
  if (maximum != null && maximum < 1) {
    throw ArgumentError.value(maximum, 'maximum');
  }
  if (!option.enabled) {
    return Set.unmodifiable(selected);
  }
  final next = Set<T>.of(selected);
  if (!next.remove(option.value)) {
    if (maximum == null || next.length < maximum) {
      next.add(option.value);
    }
  }
  return Set.unmodifiable(next);
}
