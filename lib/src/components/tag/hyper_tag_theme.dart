import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_tag_style.dart';

/// 普通、强调与禁用标签的全局或局部视觉配置。
@immutable
final class HyperTagThemeData {
  const HyperTagThemeData({
    this.style = const HyperTagStyle(),
    this.emphasized = const HyperTagStyle(),
    this.disabled = const HyperTagStyle(),
  });

  final HyperTagStyle style;
  final HyperTagStyle emphasized;
  final HyperTagStyle disabled;

  HyperTagThemeData copyWith({
    HyperTagStyle? style,
    HyperTagStyle? emphasized,
    HyperTagStyle? disabled,
  }) => HyperTagThemeData(
    style: style ?? this.style,
    emphasized: emphasized ?? this.emphasized,
    disabled: disabled ?? this.disabled,
  );

  HyperTagThemeData merge(HyperTagThemeData? other) => other == null
      ? this
      : HyperTagThemeData(
          style: style.merge(other.style),
          emphasized: emphasized.merge(other.emphasized),
          disabled: disabled.merge(other.disabled),
        );

  static HyperTagThemeData lerp(
    HyperTagThemeData a,
    HyperTagThemeData b,
    double t,
  ) => t == 0 || a == b
      ? a
      : t == 1
      ? b
      : HyperTagThemeData(
          style: HyperTagStyle.lerp(a.style, b.style, t),
          emphasized: HyperTagStyle.lerp(a.emphasized, b.emphasized, t),
          disabled: HyperTagStyle.lerp(a.disabled, b.disabled, t),
        );

  @override
  bool operator ==(Object other) =>
      other is HyperTagThemeData &&
      other.style == style &&
      other.emphasized == emphasized &&
      other.disabled == disabled;

  @override
  int get hashCode => Object.hash(style, emphasized, disabled);
}

class HyperTagTheme extends StatelessWidget {
  const HyperTagTheme({super.key, required this.data, required this.child});

  final HyperTagThemeData data;
  final Widget child;

  static HyperTagThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_TagScope>()?.data ??
      HyperTheme.of(context).tagTheme;

  @override
  Widget build(BuildContext context) =>
      _TagScope(data: of(context).merge(data), child: child);
}

class _TagScope extends InheritedTheme {
  const _TagScope({required this.data, required super.child});

  final HyperTagThemeData data;

  @override
  bool updateShouldNotify(_TagScope oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _TagScope(data: data, child: child);
}
