import 'package:flutter/widgets.dart';

import 'hyper_message_style.dart';
import 'hyper_message_surface.dart';
import 'hyper_snackbar_controller.dart';
import 'hyper_snackbar_host.dart';

/// 支持任意操作控件的提示表面；关闭和计时由宿主管理。
class HyperSnackbar extends StatelessWidget {
  const HyperSnackbar({
    super.key,
    required this.content,
    this.icon,
    this.action,
    this.semanticLabel,
    this.style,
  });
  final Widget content;
  final Widget? icon;
  final Widget? action;
  final String? semanticLabel;
  final HyperMessageStyle? style;
  @override
  Widget build(BuildContext context) => HyperMessageSurface(
    content: content,
    icon: icon,
    action: action,
    semanticLabel: semanticLabel,
    style: resolveMessageStyle(context, false, style),
  );
}

HyperMessageHandle showHyperSnackbar(
  BuildContext context, {
  required Widget content,
  Widget? icon,
  Widget? action,
  Duration duration = const Duration(seconds: 4),
  String? semanticLabel,
  HyperMessageStyle? style,
  HyperMessageMode? mode,
}) => HyperSnackbarHost.of(context).show(
  content: content,
  icon: icon,
  action: action,
  mode: mode,
  duration: duration,
  semanticLabel: semanticLabel,
  style: resolveMessageStyle(context, false, style),
);
