import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_dropdown_menu_style.dart';

@immutable
final class HyperDropdownMenuThemeData {
  const HyperDropdownMenuThemeData({this.style});

  final HyperDropdownMenuStyle? style;

  HyperDropdownMenuThemeData copyWith({HyperDropdownMenuStyle? style}) =>
      HyperDropdownMenuThemeData(style: this.style?.merge(style) ?? style);

  HyperDropdownMenuThemeData merge(HyperDropdownMenuThemeData? other) =>
      HyperDropdownMenuThemeData(
        style: style?.merge(other?.style) ?? other?.style,
      );

  static HyperDropdownMenuThemeData lerp(
    HyperDropdownMenuThemeData a,
    HyperDropdownMenuThemeData b,
    double t,
  ) => HyperDropdownMenuThemeData(
    style: a.style == null || b.style == null
        ? (t < .5 ? a.style : b.style)
        : HyperDropdownMenuStyle.lerp(a.style!, b.style!, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperDropdownMenuThemeData && other.style == style;

  @override
  int get hashCode => style.hashCode;
}

/// 为当前子树局部覆盖下拉选择器样式。
class HyperDropdownMenuTheme extends StatelessWidget {
  const HyperDropdownMenuTheme({
    super.key,
    required this.data,
    required this.child,
  });

  final HyperDropdownMenuThemeData data;
  final Widget child;

  static HyperDropdownMenuThemeData of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_HyperDropdownMenuThemeScope>()
          ?.data ??
      HyperTheme.of(context).dropdownMenuTheme;

  @override
  Widget build(BuildContext context) =>
      _HyperDropdownMenuThemeScope(data: of(context).merge(data), child: child);
}

class _HyperDropdownMenuThemeScope extends InheritedTheme {
  const _HyperDropdownMenuThemeScope({
    required this.data,
    required super.child,
  });

  final HyperDropdownMenuThemeData data;

  @override
  bool updateShouldNotify(_HyperDropdownMenuThemeScope oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _HyperDropdownMenuThemeScope(data: data, child: child);
}
