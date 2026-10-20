import 'dart:async';

import 'package:flutter/material.dart';

import '../text/hyper_scrolling_text.dart';

import '../../theme/core/hyper_theme.dart';
import '../button/hyper_button.dart';
import '../card/hyper_card.dart';
import '../card/hyper_card_style.dart';
import '../icon_button/hyper_icon_button.dart';
import '../progress/hyper_linear_progress.dart';

/// File metadata; source retains the third-party file handle without loading bytes.
@immutable
class HyperFileSelection {
  const HyperFileSelection({required this.name, this.size, this.source});
  final String name;
  final int? size;
  final Object? source;
}

enum HyperFilePickerVariant { dropzone, simple }

enum HyperFileUploadStatus { waiting, uploading, success, failed, canceled }

@immutable
class HyperFileUploadState {
  const HyperFileUploadState(this.status, {this.progress, this.errorText})
    : assert(progress == null || (progress >= 0 && progress <= 1));
  final HyperFileUploadStatus status;
  final double? progress;
  final String? errorText;
}

typedef HyperFilePickCallback = FutureOr<List<HyperFileSelection>> Function();
typedef HyperFileDropBuilder = Widget Function(
  BuildContext context,
  Widget child,
  ValueChanged<List<HyperFileSelection>> accept,
  ValueChanged<bool> hovering,
  ValueChanged<String> reject,
);

/// Presentation wrapper. Native picking and dropping are supplied by adapters.
/// No upload requests are made here; trailingBuilder can show business progress/retry.
class HyperFilePicker extends StatefulWidget {
  const HyperFilePicker({
    super.key,
    required this.files,
    required this.onChanged,
    required this.pick,
    this.dropBuilder,
    this.multiple = true,
    this.enabled = true,
    this.variant = HyperFilePickerVariant.dropzone,
    this.allowedExtensions,
    this.maxFileSize,
    this.maxFiles,
    this.onRejected,
    this.trailingBuilder,
    this.uploadState,
    this.onRetry,
    this.onCancel,
    this.thumbnailBuilder,
    this.style,
    this.pickLabel = '选择文件',
  }) : assert(maxFiles == null || maxFiles > 0),
       assert(maxFileSize == null || maxFileSize >= 0);
  final List<HyperFileSelection> files;
  final ValueChanged<List<HyperFileSelection>>? onChanged;
  final HyperFilePickCallback pick;
  final HyperFileDropBuilder? dropBuilder;
  final bool multiple, enabled;
  final HyperFilePickerVariant variant;
  final List<String>? allowedExtensions;
  final int? maxFileSize, maxFiles;
  final ValueChanged<String>? onRejected;
  final Widget? Function(BuildContext, HyperFileSelection, int)?
  trailingBuilder;
  final HyperCardStyle? style;
  final String pickLabel;
  final HyperFileUploadState? Function(HyperFileSelection)? uploadState;
  final ValueChanged<HyperFileSelection>? onRetry, onCancel;
  final Widget? Function(BuildContext, HyperFileSelection)? thumbnailBuilder;
  @override
  State<HyperFilePicker> createState() => _HyperFilePickerState();
}

class _HyperFilePickerState extends State<HyperFilePicker> {
  bool busy = false, hovering = false;
  String? error;
  bool get enabled => widget.enabled && widget.onChanged != null;
  Widget fileRow(BuildContext context, HyperFileSelection file, int index) {
    final theme = HyperTheme.of(context);
    final gap = HyperTheme.sizesOf(context).form.gap;
    final state = widget.uploadState?.call(file);
    final status = state?.status;
    final message = switch (status) {
      HyperFileUploadStatus.waiting => '等待上传',
      HyperFileUploadStatus.uploading =>
        state!.progress == null
            ? '上传中'
            : '上传中 ${(state.progress! * 100).round()}%',
      HyperFileUploadStatus.success => '上传成功',
      HyperFileUploadStatus.failed => state!.errorText ?? '上传失败',
      HyperFileUploadStatus.canceled => '已取消',
      null => null,
    };
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            widget.thumbnailBuilder?.call(context, file) ??
                const Icon(Icons.insert_drive_file_outlined),
            SizedBox(width: gap),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  HyperScrollingText(
                    file.name,
                    trigger: HyperTextScrollTrigger.hover,
                  ),
                  if (file.size != null)
                    Text('${file.size} 字节', style: theme.textTheme.bodySmall),
                  if (message != null)
                    Semantics(
                      liveRegion: status != HyperFileUploadStatus.uploading,
                      child: Text(
                        message,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: status == HyperFileUploadStatus.failed
                              ? theme.colors.error
                              : theme.colors.textSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            HyperIconButton.ghost(
              icon: const Icon(Icons.close),
              tooltip: '移除文件',
              onPressed: enabled
                  ? () {
                      setState(() => error = null);
                      widget.onChanged!(
                        List.unmodifiable(
                          List<HyperFileSelection>.of(widget.files)
                            ..removeAt(index),
                        ),
                      );
                    }
                  : null,
            ),
          ],
        ),
        if (status == HyperFileUploadStatus.uploading) ...[
          SizedBox(height: gap),
          HyperLinearProgress(
            value: state!.progress,
            semanticsLabel: '${file.name} 上传进度',
          ),
        ],
        if (widget.trailingBuilder != null ||
            ((status == HyperFileUploadStatus.failed ||
                    status == HyperFileUploadStatus.canceled) &&
                widget.onRetry != null) ||
            (status == HyperFileUploadStatus.uploading &&
                widget.onCancel != null))
          Wrap(
            alignment: WrapAlignment.end,
            spacing: gap,
            runSpacing: gap,
            children: [
              if (widget.trailingBuilder?.call(context, file, index)
                  case final Widget trailing)
                trailing,
              if ((status == HyperFileUploadStatus.failed ||
                      status == HyperFileUploadStatus.canceled) &&
                  widget.onRetry != null)
                HyperButton.outlined(
                  onPressed: enabled ? () => widget.onRetry!(file) : null,
                  child: const Text('重试'),
                ),
              if (status == HyperFileUploadStatus.uploading &&
                  widget.onCancel != null)
                HyperButton.text(
                  onPressed: enabled ? () => widget.onCancel!(file) : null,
                  child: const Text('取消上传'),
                ),
            ],
          ),
      ],
    );
  }

  void reject(String message) {
    setState(() => error = message);
    widget.onRejected?.call(message);
  }

  void accept(List<HyperFileSelection> incoming) {
    if (!mounted || !enabled || incoming.isEmpty) return;
    final extensions = widget.allowedExtensions
        ?.map((v) => v.replaceFirst(RegExp(r'^\.'), '').toLowerCase())
        .toSet();
    final accepted = <HyperFileSelection>[];
    String? rejection;
    for (final file in incoming) {
      final extension = file.name.contains('.')
          ? file.name.split('.').last.toLowerCase()
          : '';
      if (extensions != null &&
          extensions.isNotEmpty &&
          !extensions.contains(extension)) {
        rejection ??= '不支持文件 ${file.name} 的格式';
        continue;
      }
      if (widget.maxFileSize != null &&
          (file.size == null || file.size! > widget.maxFileSize!)) {
        rejection ??= '文件 ${file.name} 超出大小限制或大小未知';
        continue;
      }
      accepted.add(file);
      if (!widget.multiple) break;
    }
    final next = widget.multiple ? [...widget.files, ...accepted] : accepted;
    if (widget.maxFiles != null && next.length > widget.maxFiles!) {
      reject('最多选择 ${widget.maxFiles} 个文件');
      return;
    }
    setState(() => error = rejection);
    if (rejection != null) widget.onRejected?.call(rejection);
    if (accepted.isNotEmpty) widget.onChanged!(List.unmodifiable(next));
  }

  Future<void> choose() async {
    if (!enabled || busy) return;
    setState(() => busy = true);
    try {
      final files = await widget.pick();
      if (mounted) accept(files);
    } catch (_) {
      if (mounted && enabled) reject('无法选择文件，请重试');
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context), sizes = HyperTheme.sizesOf(context);
    final gap = sizes.form.gap;
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (widget.variant == HyperFilePickerVariant.dropzone &&
            widget.files.isEmpty) ...[
          Icon(
            Icons.attach_file,
            color: enabled ? theme.colors.textSecondary : theme.colors.disabled,
          ),
          SizedBox(height: gap),
          Text(
            hovering
                ? '松开以添加文件'
                : widget.dropBuilder == null
                ? '选择要添加的文件'
                : '点击选择或拖放文件到这里',
            textAlign: TextAlign.center,
          ),
          SizedBox(height: gap),
        ],
        for (var i = 0; i < widget.files.length; i++) ...[
          fileRow(context, widget.files[i], i),
          SizedBox(height: gap),
        ],
        if (error != null) ...[
          Semantics(
            liveRegion: true,
            child: Text(
              error!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colors.error,
              ),
            ),
          ),
          SizedBox(height: gap),
        ],
        Align(
          alignment:
              widget.variant == HyperFilePickerVariant.dropzone &&
                  widget.files.isEmpty
              ? Alignment.center
              : AlignmentDirectional.centerStart,
          child: HyperButton.outlined(
            onPressed: enabled && !busy ? choose : null,
            loading: busy,
            child: Text(widget.pickLabel),
          ),
        ),
      ],
    );
    Widget result = widget.variant == HyperFilePickerVariant.simple
        ? content
        : HyperCard(
            style: HyperCardStyle(
              padding: sizes.dialog.padding,
              border: Border.all(
                color: hovering && enabled
                    ? theme.colors.primary
                    : theme.colors.outline,
              ),
            ).merge(widget.style),
            child: content,
          );
    if (enabled && widget.dropBuilder != null) {
      result = widget.dropBuilder!(
        context,
        result,
        accept,
        (value) {
          if (mounted && hovering != value) setState(() => hovering = value);
        },
        (message) {
          if (mounted && enabled) reject(message);
        },
      );
    }
    return result;
  }
}
