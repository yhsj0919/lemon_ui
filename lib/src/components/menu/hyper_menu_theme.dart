import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import '../button/hyper_button_style.dart';
import 'hyper_menu_style.dart';

@immutable
final class HyperMenuThemeData {
  const HyperMenuThemeData({this.style, this.buttonStyle});

  final HyperMenuStyle? style;

  /// 菜单触发按钮的样式；实例显式字段优先。
  final HyperButtonStyle? buttonStyle;

  HyperMenuThemeData copyWith({
    HyperMenuStyle? style,
    HyperButtonStyle? buttonStyle,
  }) => HyperMenuThemeData(
    style: this.style?.merge(style) ?? style,
    buttonStyle: this.buttonStyle?.merge(buttonStyle) ?? buttonStyle,
  );

  HyperMenuThemeData merge(HyperMenuThemeData? other) => HyperMenuThemeData(
    style: style?.merge(other?.style) ?? other?.style,
    buttonStyle: buttonStyle?.merge(other?.buttonStyle) ?? other?.buttonStyle,
  );

  static HyperMenuThemeData lerp(
    HyperMenuThemeData a,
    HyperMenuThemeData b,
    double t,
  ) => HyperMenuThemeData(
    style: a.style == null || b.style == null
        ? (t < .5 ? a.style : b.style)
        : HyperMenuStyle.lerp(a.style!, b.style!, t),
    buttonStyle: a.buttonStyle == null || b.buttonStyle == null
        ? (t < .5 ? a.buttonStyle : b.buttonStyle)
        : HyperButtonStyle.lerp(a.buttonStyle!, b.buttonStyle!, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperMenuThemeData &&
      other.style == style &&
      other.buttonStyle == buttonStyle;

  @override
  int get hashCode => Object.hash(style, buttonStyle);
}

/// 为当前子树局部覆盖菜单样式。
class HyperMenuTheme extends StatelessWidget {
  const HyperMenuTheme({super.key, required this.data, required this.child});

  final HyperMenuThemeData data;
  final Widget child;

  static HyperMenuThemeData of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_HyperMenuThemeScope>()
          ?.data ??
      HyperTheme.of(context).menuTheme;

  @override
  Widget build(BuildContext context) =>
      _HyperMenuThemeScope(data: of(context).merge(data), child: child);
}

class _HyperMenuThemeScope extends InheritedTheme {
  const _HyperMenuThemeScope({required this.data, required super.child});

  final HyperMenuThemeData data;

  @override
  bool updateShouldNotify(_HyperMenuThemeScope oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _HyperMenuThemeScope(data: data, child: child);
}
