import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_card_style.dart';

@immutable
final class HyperCardThemeData {
  const HyperCardThemeData({this.style});
  final HyperCardStyle? style;

  HyperCardThemeData copyWith({HyperCardStyle? style}) =>
      HyperCardThemeData(style: style ?? this.style);

  static HyperCardThemeData lerp(
    HyperCardThemeData a,
    HyperCardThemeData b,
    double t,
  ) => HyperCardThemeData(
    style: a.style == null || b.style == null
        ? (t < .5 ? a.style : b.style)
        : HyperCardStyle.lerp(a.style!, b.style!, t),
  );

  @override
  bool operator ==(Object other) =>
      other is HyperCardThemeData && other.style == style;
  @override
  int get hashCode => style.hashCode;
}

/// 为子树单独覆盖 Card 主题。
class HyperCardTheme extends InheritedTheme {
  const HyperCardTheme({super.key, required this.data, required super.child});
  final HyperCardThemeData data;

  static HyperCardThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HyperCardTheme>()?.data ??
      HyperTheme.of(context).cardTheme;

  @override
  bool updateShouldNotify(HyperCardTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      HyperCardTheme(data: data, child: child);
}
