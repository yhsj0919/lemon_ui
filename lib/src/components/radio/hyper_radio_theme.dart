import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_radio_style.dart';

/// HyperRadio 的全局或局部主题。
@immutable
final class HyperRadioThemeData {
  const HyperRadioThemeData({
    this.style,
    this.checkmark,
    this.circle,
    this.filled,
  });

  /// 所有单选控件共用的样式覆盖。
  final HyperRadioStyle? style;

  /// MIUIX 勾线变体样式。
  final HyperRadioStyle? checkmark;

  /// 普通外圈圆点变体样式。
  final HyperRadioStyle? circle;

  /// 带弱背景和主题色对勾的变体样式。
  final HyperRadioStyle? filled;

  HyperRadioStyle resolve(HyperRadioVariant variant) =>
      (style ?? const HyperRadioStyle()).merge(switch (variant) {
        HyperRadioVariant.checkmark => checkmark,
        HyperRadioVariant.circle => circle,
        HyperRadioVariant.filled => filled,
      });

  static HyperRadioThemeData lerp(
    HyperRadioThemeData a,
    HyperRadioThemeData b,
    double t,
  ) {
    return t < .5 ? a : b;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperRadioThemeData &&
          other.style == style &&
          other.checkmark == checkmark &&
          other.circle == circle &&
          other.filled == filled;

  @override
  int get hashCode => Object.hash(style, checkmark, circle, filled);
}

/// 为子树单独覆盖单选控件主题。
class HyperRadioTheme extends InheritedTheme {
  const HyperRadioTheme({super.key, required this.data, required super.child});

  /// 当前子树的单选控件主题。
  final HyperRadioThemeData data;

  static HyperRadioThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HyperRadioTheme>()?.data ??
      HyperTheme.of(context).radioTheme;

  @override
  bool updateShouldNotify(HyperRadioTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      HyperRadioTheme(data: data, child: child);
}
