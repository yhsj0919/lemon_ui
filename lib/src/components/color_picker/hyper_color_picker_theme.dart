import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_color_picker_style.dart';

/// 全局或局部的颜色选择器外观。
@immutable
final class HyperColorPickerThemeData {
  const HyperColorPickerThemeData({this.style});

  /// 非空字段覆盖上一级；按钮及菜单样式逐字段合并。
  final HyperColorPickerStyle? style;
  HyperColorPickerThemeData copyWith({HyperColorPickerStyle? style}) =>
      HyperColorPickerThemeData(style: style ?? this.style);
  HyperColorPickerThemeData merge(HyperColorPickerThemeData? other) =>
      HyperColorPickerThemeData(
        style: style?.merge(other?.style) ?? other?.style,
      );
  static HyperColorPickerThemeData lerp(
    HyperColorPickerThemeData a,
    HyperColorPickerThemeData b,
    double t,
  ) => HyperColorPickerThemeData(
    style: a.style == null || b.style == null
        ? (t < .5 ? a.style : b.style)
        : HyperColorPickerStyle.lerp(a.style!, b.style!, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperColorPickerThemeData && other.style == style;
  @override
  int get hashCode => style.hashCode;
}

/// 仅覆盖子树内显式提供的颜色选择器配置。
class HyperColorPickerTheme extends StatelessWidget {
  const HyperColorPickerTheme({
    super.key,
    required this.data,
    required this.child,
  });

  /// 当前子树的主题覆盖。
  final HyperColorPickerThemeData data;

  /// 应用主题的子树。
  final Widget child;
  static HyperColorPickerThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).colorPickerTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperColorPickerThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => oldWidget.data != data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
