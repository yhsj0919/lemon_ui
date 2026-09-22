import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_checkbox_style.dart';

/// HyperCheckbox 的全局或局部主题。
@immutable
final class HyperCheckboxThemeData {
  const HyperCheckboxThemeData({this.style, this.circle, this.rounded});

  /// 所有复选框共用的样式覆盖。
  final HyperCheckboxStyle? style;

  /// 圆形变体样式。
  final HyperCheckboxStyle? circle;

  /// 圆角矩形变体样式。
  final HyperCheckboxStyle? rounded;

  /// 按变体合并公共样式和变体样式。
  HyperCheckboxStyle resolve(HyperCheckboxVariant variant) =>
      (style ?? HyperCheckboxStyle()).merge(
        variant == HyperCheckboxVariant.circle ? circle : rounded,
      );

  static HyperCheckboxThemeData lerp(
    HyperCheckboxThemeData a,
    HyperCheckboxThemeData b,
    double t,
  ) {
    return t < .5 ? a : b;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperCheckboxThemeData &&
          other.style == style &&
          other.circle == circle &&
          other.rounded == rounded;

  @override
  int get hashCode => Object.hash(style, circle, rounded);
}

/// 为子树单独覆盖复选框主题。
class HyperCheckboxTheme extends InheritedTheme {
  const HyperCheckboxTheme({
    super.key,
    required this.data,
    required super.child,
  });

  /// 当前子树的复选框主题。
  final HyperCheckboxThemeData data;

  static HyperCheckboxThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HyperCheckboxTheme>()?.data ??
      HyperTheme.of(context).checkboxTheme;

  @override
  bool updateShouldNotify(HyperCheckboxTheme oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      HyperCheckboxTheme(data: data, child: child);
}
