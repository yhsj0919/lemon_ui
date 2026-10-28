import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_image_preview_style.dart';

@immutable
final class HyperImagePreviewThemeData {
  const HyperImagePreviewThemeData({
    this.style = const HyperImagePreviewStyle(),
  });
  final HyperImagePreviewStyle style;
  HyperImagePreviewThemeData copyWith({HyperImagePreviewStyle? style}) =>
      HyperImagePreviewThemeData(style: this.style.merge(style));
  HyperImagePreviewThemeData merge(HyperImagePreviewThemeData? other) =>
      copyWith(style: other?.style);
  static HyperImagePreviewThemeData lerp(
    HyperImagePreviewThemeData a,
    HyperImagePreviewThemeData b,
    double t,
  ) => HyperImagePreviewThemeData(
    style: HyperImagePreviewStyle.lerp(a.style, b.style, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperImagePreviewThemeData && style == other.style;
  @override
  int get hashCode => style.hashCode;
}

class HyperImagePreviewTheme extends StatelessWidget {
  const HyperImagePreviewTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperImagePreviewThemeData data;
  final Widget child;
  static HyperImagePreviewThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).imagePreviewTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperImagePreviewThemeData data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
}
