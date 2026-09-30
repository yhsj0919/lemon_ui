import 'package:flutter/widgets.dart';

/// 组内原生控件用来去除重复外框的内部上下文。
class HyperWidgetGroupScope extends InheritedWidget {
  const HyperWidgetGroupScope({
    super.key,
    required this.connected,
    this.itemHeight,
    this.fillWidth = false,
    required super.child,
  });

  final bool connected;
  final double? itemHeight;
  final bool fillWidth;

  static HyperWidgetGroupScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HyperWidgetGroupScope>();

  @override
  bool updateShouldNotify(HyperWidgetGroupScope oldWidget) =>
      connected != oldWidget.connected ||
      itemHeight != oldWidget.itemHeight ||
      fillWidth != oldWidget.fillWidth;
}
