import 'package:flutter/widgets.dart';

import 'hyper_message_style.dart';
import 'hyper_message_surface.dart';
import 'hyper_snackbar_controller.dart';
import 'hyper_snackbar_host.dart';

/// 无交互的短暂轻提示。独立使用时不负责自动关闭。
class HyperToast extends StatelessWidget {
  const HyperToast({
    super.key,
    required this.content,
    this.icon,
    this.semanticLabel,
    this.style,
  });
  final Widget content;
  final Widget? icon;
  final String? semanticLabel;
  final HyperMessageStyle? style;
  @override
  Widget build(BuildContext context) => IgnorePointer(
    child: HyperMessageSurface(
      content: content,
      icon: icon,
      semanticLabel: semanticLabel,
      style: resolveMessageStyle(context, true, style),
    ),
  );
}

HyperMessageHandle showHyperToast(
  BuildContext context, {
  required Widget content,
  Widget? icon,
  Duration duration = const Duration(seconds: 3),
  String? semanticLabel,
  HyperMessageStyle? style,
  HyperMessageMode? mode,
}) => HyperSnackbarHost.of(context).show(
  content: content,
  icon: icon,
  duration: duration,
  toast: true,
  mode: mode,
  semanticLabel: semanticLabel,
  style: resolveMessageStyle(context, true, style),
);
