import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_list_tile_style.dart';

/// HyperListTile 的全局或局部主题。
@immutable
final class HyperListTileThemeData {
  const HyperListTileThemeData({this.style});

  final HyperListTileStyle? style;

  HyperListTileThemeData copyWith({HyperListTileStyle? style}) =>
      HyperListTileThemeData(style: style ?? this.style);

  static HyperListTileThemeData lerp(
    HyperListTileThemeData a,
    HyperListTileThemeData b,
    double t,
  ) {
    if (a.style == null || b.style == null) return t < .5 ? a : b;
    return HyperListTileThemeData(
      style: HyperListTileStyle.lerp(a.style!, b.style!, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperListTileThemeData && other.style == style;

  @override
  int get hashCode => style.hashCode;
}

/// 为子树单独覆盖列表项主题。
class HyperListTileTheme extends InheritedTheme {
  const HyperListTileTheme({
    super.key,
    required this.data,
    required super.child,
  });

  final HyperListTileThemeData data;

  static HyperListTileThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HyperListTileTheme>()?.data ??
      HyperTheme.of(context).listTileTheme;

  @override
  bool updateShouldNotify(HyperListTileTheme oldWidget) =>
      data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      HyperListTileTheme(data: data, child: child);
}
