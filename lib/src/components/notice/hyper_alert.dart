import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';
import 'hyper_notice_style.dart';
import 'hyper_notice_defaults.dart';
import 'hyper_notice_body.dart';
import 'hyper_alert_theme.dart';

/// 正文内提示，状态和关闭由父级控制。
class HyperAlert extends StatelessWidget {
  const HyperAlert({
    super.key,
    required this.content,
    this.title,
    this.severity = HyperNoticeSeverity.info,
    this.icon,
    this.showIcon = true,
    this.actions = const [],
    this.onClose,
    this.closeButton,
    this.visible = true,
    this.semanticLabel,
    this.liveRegion = true,
    this.style,
  });
  final Widget content;
  final Widget? title, icon, closeButton;
  final HyperNoticeSeverity severity;
  final bool showIcon, visible, liveRegion;
  final List<Widget> actions;
  final VoidCallback? onClose;
  final String? semanticLabel;
  final HyperNoticeStyle? style;
  @override
  Widget build(BuildContext context) {
    final resolved = noticeDefaults(
      theme: HyperTheme.of(context),
      metrics: HyperTheme.sizesOf(context).alert,
      materialTheme: HyperMaterialTheme.of(context),
      severity: severity,
      banner: false,
    ).merge(HyperAlertTheme.of(context).styleFor(severity)).merge(style);
    return HyperNoticeBody(
      content: content,
      title: title,
      icon: icon,
      showIcon: showIcon,
      actions: actions,
      onClose: onClose,
      closeButton: closeButton,
      visible: visible,
      semanticLabel: semanticLabel,
      liveRegion: liveRegion,
      style: resolved,
    );
  }
}
