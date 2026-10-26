import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_movable_dialog_style.dart';

@immutable
final class HyperMovableDialogThemeData {
  const HyperMovableDialogThemeData({
    this.style = const HyperMovableDialogStyle(),
  });
  final HyperMovableDialogStyle style;
  HyperMovableDialogThemeData copyWith({HyperMovableDialogStyle? style}) =>
      HyperMovableDialogThemeData(style: this.style.merge(style));
  HyperMovableDialogThemeData merge(HyperMovableDialogThemeData? other) =>
      copyWith(style: other?.style);
  static HyperMovableDialogThemeData lerp(
    HyperMovableDialogThemeData a,
    HyperMovableDialogThemeData b,
    double t,
  ) => HyperMovableDialogThemeData(
    style: HyperMovableDialogStyle.lerp(a.style, b.style, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperMovableDialogThemeData && other.style == style;
  @override
  int get hashCode => style.hashCode;
}

class HyperMovableDialogTheme extends StatelessWidget {
  const HyperMovableDialogTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperMovableDialogThemeData data;
  final Widget child;
  static HyperMovableDialogThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).movableDialogTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperMovableDialogThemeData data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
}
