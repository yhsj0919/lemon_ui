import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_resizable_style.dart';

@immutable
final class HyperResizableThemeData {
  const HyperResizableThemeData({this.style = const HyperResizableStyle()});
  final HyperResizableStyle style;
  HyperResizableThemeData copyWith({HyperResizableStyle? style}) =>
      HyperResizableThemeData(style: this.style.merge(style));
  HyperResizableThemeData merge(HyperResizableThemeData? other) =>
      copyWith(style: other?.style);
  static HyperResizableThemeData lerp(
    HyperResizableThemeData a,
    HyperResizableThemeData b,
    double t,
  ) => HyperResizableThemeData(
    style: HyperResizableStyle.lerp(a.style, b.style, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperResizableThemeData && other.style == style;
  @override
  int get hashCode => style.hashCode;
}

class HyperResizableTheme extends StatelessWidget {
  const HyperResizableTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperResizableThemeData data;
  final Widget child;
  static HyperResizableThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).resizableTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperResizableThemeData data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
}
