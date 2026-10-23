import 'package:flutter/widgets.dart';

/// Temporary rendering policy used only while capturing an export boundary.
class HyperChartCaptureScope extends InheritedWidget {
  const HyperChartCaptureScope({
    super.key,
    required this.hideTooltip,
    required super.child,
  });
  final bool hideTooltip;

  static bool hidesTooltip(BuildContext context) =>
      context
          .dependOnInheritedWidgetOfExactType<HyperChartCaptureScope>()
          ?.hideTooltip ??
      false;

  @override
  bool updateShouldNotify(HyperChartCaptureScope oldWidget) =>
      hideTooltip != oldWidget.hideTooltip;
}
