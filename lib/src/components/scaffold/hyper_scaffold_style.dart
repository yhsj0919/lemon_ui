import 'package:flutter/material.dart';

/// 页面框架的实例或主题覆盖；null 表示继承。
@immutable
final class HyperScaffoldStyle {
  const HyperScaffoldStyle({this.backgroundColor});

  final Color? backgroundColor;

  HyperScaffoldStyle copyWith({Color? backgroundColor}) => HyperScaffoldStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
  );

  HyperScaffoldStyle merge(HyperScaffoldStyle? other) =>
      other == null ? this : copyWith(backgroundColor: other.backgroundColor);

  static HyperScaffoldStyle lerp(
    HyperScaffoldStyle a,
    HyperScaffoldStyle b,
    double t,
  ) => HyperScaffoldStyle(
    backgroundColor: Color.lerp(a.backgroundColor, b.backgroundColor, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperScaffoldStyle && other.backgroundColor == backgroundColor;

  @override
  int get hashCode => backgroundColor.hashCode;
}
