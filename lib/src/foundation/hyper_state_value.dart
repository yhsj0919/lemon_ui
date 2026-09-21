import 'dart:collection';

import 'package:flutter/foundation.dart';

import 'hyper_control_state.dart';

/// 根据控件状态集合解析属性值。
///
/// 简单状态映射遵循 [HyperControlState.priority]；需要组合判断时使用
/// [HyperStateValue.resolveWith]。
@immutable
abstract class HyperStateValue<T> {
  const HyperStateValue();

  /// 所有状态始终返回同一个值。
  const factory HyperStateValue.all(T value) = _HyperStateAll<T>;

  /// 使用回调处理复杂状态组合。
  const factory HyperStateValue.resolveWith(
    T Function(Set<HyperControlState> states) resolver,
  ) = _HyperStateResolver<T>;

  /// 创建按统一状态优先级解析的映射。
  factory HyperStateValue.fromMap({
    required T fallback,
    required Map<HyperControlState, T> values,
  }) = _HyperStateMap<T>;

  T resolve(Set<HyperControlState> states);

  /// 转换解析后的值，同时保留原状态规则。
  HyperStateValue<R> map<R>(R Function(T value) transform) {
    return HyperStateValue<R>.resolveWith(
      (states) => transform(resolve(states)),
    );
  }

  /// 对两套状态值逐状态插值。
  static HyperStateValue<T> lerp<T>(
    HyperStateValue<T> a,
    HyperStateValue<T> b,
    double t,
    T Function(T a, T b, double t) interpolate,
  ) {
    if (t == 0) return a;
    if (t == 1) return b;
    return HyperStateValue<T>.resolveWith(
      (states) => interpolate(a.resolve(states), b.resolve(states), t),
    );
  }
}

final class _HyperStateAll<T> extends HyperStateValue<T> {
  const _HyperStateAll(this.value);

  final T value;

  @override
  T resolve(Set<HyperControlState> states) => value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _HyperStateAll<T> && other.value == value;

  @override
  int get hashCode => Object.hash(_HyperStateAll<T>, value);
}

final class _HyperStateResolver<T> extends HyperStateValue<T> {
  const _HyperStateResolver(this.resolver);

  final T Function(Set<HyperControlState> states) resolver;

  @override
  T resolve(Set<HyperControlState> states) {
    return resolver(UnmodifiableSetView(states));
  }
}

final class _HyperStateMap<T> extends HyperStateValue<T> {
  _HyperStateMap({
    required this.fallback,
    required Map<HyperControlState, T> values,
  }) : values = Map.unmodifiable(values);

  final T fallback;
  final Map<HyperControlState, T> values;

  @override
  T resolve(Set<HyperControlState> states) {
    for (final state in HyperControlState.priority.reversed) {
      if (states.contains(state) && values.containsKey(state)) {
        return values[state] as T;
      }
    }
    return fallback;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _HyperStateMap<T> &&
          other.fallback == fallback &&
          mapEquals(other.values, values);

  @override
  int get hashCode => Object.hash(
    fallback,
    Object.hashAll([
      for (final state in HyperControlState.priority)
        if (values.containsKey(state)) Object.hash(state, values[state]),
    ]),
  );
}
