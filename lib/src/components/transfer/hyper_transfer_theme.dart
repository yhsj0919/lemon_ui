import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_transfer_style.dart';

@immutable
final class HyperTransferThemeData {
  const HyperTransferThemeData({this.style = const HyperTransferStyle()});
  final HyperTransferStyle style;
  HyperTransferThemeData copyWith({HyperTransferStyle? style}) =>
      HyperTransferThemeData(style: this.style.merge(style));
  HyperTransferThemeData merge(HyperTransferThemeData? other) =>
      copyWith(style: other?.style);
  static HyperTransferThemeData lerp(
    HyperTransferThemeData a,
    HyperTransferThemeData b,
    double t,
  ) => HyperTransferThemeData(
    style: HyperTransferStyle.lerp(a.style, b.style, t),
  );
  @override
  bool operator ==(Object other) =>
      other is HyperTransferThemeData && other.style == style;
  @override
  int get hashCode => style.hashCode;
}

class HyperTransferTheme extends StatelessWidget {
  const HyperTransferTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperTransferThemeData data;
  final Widget child;
  static HyperTransferThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).transferTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperTransferThemeData data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
}
