import 'package:flutter/material.dart';

import '../notification/hyper_notification.dart';
import '../notification/hyper_notification_style.dart';
import 'hyper_message_style.dart';
import 'hyper_snackbar_controller.dart';
import 'hyper_snackbar_host.dart';

/// The visual and interaction contract of a globally presented message.
enum HyperMessagePresentation { toast, snackbar, notification }

/// Context-free entry point backed by one mounted [HyperMessageHost].
///
/// Use [global] for a single-window app, or create one instance per window.
/// Changing [presentation] affects subsequent messages only.
class HyperMessages {
  HyperMessages({this.presentation = HyperMessagePresentation.toast});

  static final global = HyperMessages();

  HyperMessagePresentation presentation;
  final _controller = HyperSnackbarController();
  Object? _host;

  bool get isAttached => _host != null;

  /// Shows a message using the default or explicit [presentation].
  ///
  /// Toasts are noninteractive. Titles and [notificationStyle] apply to
  /// notification cards; [style] controls toast/snackbar and host transitions.
  /// Zero duration keeps the message visible until closed. No context is
  /// retained: theme and material are resolved live beneath the host.
  HyperMessageHandle show({
    required Widget content,
    HyperMessagePresentation? presentation,
    Widget? title,
    Widget? icon,
    Widget? action,
    Duration duration = const Duration(seconds: 3),
    HyperMessageMode? mode,
    String? semanticLabel,
    HyperMessageStyle? style,
    HyperNotificationStyle? notificationStyle,
  }) {
    if (!isAttached) {
      throw StateError('请先在 HyperTheme 下挂载 HyperMessageHost。');
    }
    final resolved = presentation ?? this.presentation;
    return _controller.show(
      content: content,
      icon: icon,
      action: action,
      toast: resolved == HyperMessagePresentation.toast,
      duration: duration,
      mode: mode,
      semanticLabel: semanticLabel,
      style: style,
      builder: resolved == HyperMessagePresentation.notification
          ? (context, handle) => HyperNotification(
              content: content,
              title: title,
              icon: icon,
              actions: [?action],
              showUnreadIndicator: false,
              semanticLabel: semanticLabel,
              style: notificationStyle,
              onClose: handle.close,
            )
          : null,
    );
  }

  void clear() => _controller.clear();

  /// Dispose custom instances after removing their host. Do not dispose [global].
  void dispose() {
    if (identical(this, global)) {
      throw StateError('全局消息实例由应用生命周期管理，不能销毁。');
    }
    _controller.dispose();
  }
}

/// App-level message host, including the Overlay needed above a Navigator.
///
/// Place beneath HyperTheme in MaterialApp's builder (including MaterialApp.router).
/// The default [messages] is [HyperMessages.global]. Routes and dialogs remain
/// below messages; existing context-based toast/snackbar APIs also work below it.
class HyperMessageHost extends StatefulWidget {
  const HyperMessageHost({
    super.key,
    required this.child,
    this.messages,
    this.alignment = Alignment.bottomCenter,
    this.padding,
    this.toastMode = HyperMessageMode.stack,
    this.snackbarMode = HyperMessageMode.queue,
    this.maxVisible = 3,
    this.stackSpacing,
    this.transitionBuilder,
  }) : assert(maxVisible > 0),
       assert(stackSpacing == null || stackSpacing >= 0);

  final Widget child;
  final HyperMessages? messages;
  final AlignmentGeometry alignment;
  final EdgeInsetsGeometry? padding;
  final HyperMessageMode toastMode, snackbarMode;
  final int maxVisible;
  final double? stackSpacing;
  final HyperMessageTransitionBuilder? transitionBuilder;

  @override
  State<HyperMessageHost> createState() => _HyperMessageHostState();
}

class _HyperMessageHostState extends State<HyperMessageHost> {
  late HyperMessages _messages;
  late final OverlayEntry _entry = OverlayEntry(builder: _buildEntry);

  void _attach() {
    final messages = widget.messages ?? HyperMessages.global;
    if (messages._host != null) {
      throw StateError('一个 HyperMessages 实例只能连接一个宿主；多窗口请分别创建实例。');
    }
    _messages = messages;
    messages._host = this;
  }

  @override
  void initState() {
    super.initState();
    _attach();
  }

  @override
  void didUpdateWidget(HyperMessageHost oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.messages != widget.messages) {
      _messages._host = null;
      _attach();
    }
    _entry.markNeedsBuild();
  }

  Widget _buildEntry(BuildContext context) => HyperSnackbarHost(
    controller: _messages._controller,
    alignment: widget.alignment,
    padding: widget.padding,
    toastMode: widget.toastMode,
    snackbarMode: widget.snackbarMode,
    maxVisible: widget.maxVisible,
    stackSpacing: widget.stackSpacing,
    transitionBuilder: widget.transitionBuilder,
    child: widget.child,
  );

  @override
  Widget build(BuildContext context) => Overlay(initialEntries: [_entry]);

  @override
  void dispose() {
    _messages._host = null;
    _entry.remove();
    _entry.dispose();
    super.dispose();
  }
}
