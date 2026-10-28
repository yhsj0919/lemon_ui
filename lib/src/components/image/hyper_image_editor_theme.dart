import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_image_editor_style.dart';

@immutable
final class HyperImageEditorThemeData {
  const HyperImageEditorThemeData({this.style = const HyperImageEditorStyle()});
  final HyperImageEditorStyle style;
  HyperImageEditorThemeData copyWith({HyperImageEditorStyle? style}) =>
      HyperImageEditorThemeData(style: this.style.merge(style));
  HyperImageEditorThemeData merge(HyperImageEditorThemeData? other) =>
      copyWith(style: other?.style);
  static HyperImageEditorThemeData lerp(
    HyperImageEditorThemeData a,
    HyperImageEditorThemeData b,
    double t,
  ) => HyperImageEditorThemeData(
    style: HyperImageEditorStyle.lerp(a.style, b.style, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperImageEditorThemeData && style == other.style;
  @override
  int get hashCode => style.hashCode;
}

class HyperImageEditorTheme extends StatelessWidget {
  const HyperImageEditorTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperImageEditorThemeData data;
  final Widget child;
  static HyperImageEditorThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).imageEditorTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperImageEditorThemeData data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
}
