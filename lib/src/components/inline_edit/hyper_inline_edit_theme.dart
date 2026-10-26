import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_inline_edit_style.dart';

@immutable
final class HyperInlineEditThemeData {
  const HyperInlineEditThemeData({this.style = const HyperInlineEditStyle()});
  final HyperInlineEditStyle style;

  HyperInlineEditThemeData copyWith({HyperInlineEditStyle? style}) =>
      HyperInlineEditThemeData(style: this.style.merge(style));
  HyperInlineEditThemeData merge(HyperInlineEditThemeData? other) =>
      copyWith(style: other?.style);
  static HyperInlineEditThemeData lerp(
    HyperInlineEditThemeData a,
    HyperInlineEditThemeData b,
    double t,
  ) => HyperInlineEditThemeData(
    style: HyperInlineEditStyle.lerp(a.style, b.style, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperInlineEditThemeData && other.style == style;
  @override
  int get hashCode => style.hashCode;
}

class HyperInlineEditTheme extends StatelessWidget {
  const HyperInlineEditTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperInlineEditThemeData data;
  final Widget child;

  static HyperInlineEditThemeData of(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<_InlineEditThemeScope>()
          ?.data ??
      HyperTheme.of(context).inlineEditTheme;

  @override
  Widget build(BuildContext context) =>
      _InlineEditThemeScope(data: of(context).merge(data), child: child);
}

class _InlineEditThemeScope extends InheritedTheme {
  const _InlineEditThemeScope({required this.data, required super.child});
  final HyperInlineEditThemeData data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      _InlineEditThemeScope(data: data, child: child);
  @override
  bool updateShouldNotify(_InlineEditThemeScope oldWidget) =>
      data != oldWidget.data;
}
