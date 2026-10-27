import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperFilePickerPage extends StatefulWidget {
  const HyperFilePickerPage({super.key});
  @override
  State<HyperFilePickerPage> createState() => _HyperFilePickerPageState();
}

class _HyperFilePickerPageState extends State<HyperFilePickerPage> {
  List<HyperFileSelection> files = [], simple = [];
  final states = <HyperFileSelection, HyperFileUploadState>{};
  final timers = <HyperFileSelection, Timer>{};
  bool simulateFailure = false;
  void upload(HyperFileSelection file, {bool retry = false}) {
    timers.remove(file)?.cancel();
    final fail = simulateFailure && !retry;
    var progress = 0.0;
    setState(
      () => states[file] = const HyperFileUploadState(
        HyperFileUploadStatus.uploading,
        progress: 0,
      ),
    );
    timers[file] = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!mounted || !files.contains(file)) {
        timer.cancel();
        return;
      }
      progress = (progress + .1).clamp(0, 1);
      setState(() {
        if (fail && progress >= .5) {
          timer.cancel();
          timers.remove(file);
          states[file] = const HyperFileUploadState(
            HyperFileUploadStatus.failed,
            errorText: '模拟上传失败，请重试',
          );
        } else if (progress >= 1) {
          timer.cancel();
          timers.remove(file);
          states[file] = const HyperFileUploadState(
            HyperFileUploadStatus.success,
          );
        } else {
          states[file] = HyperFileUploadState(
            HyperFileUploadStatus.uploading,
            progress: progress,
          );
        }
      });
    });
  }

  final form = HyperFormController();
  String result = '尚未提交';
  @override
  void dispose() {
    for (final timer in timers.values) {
      timer.cancel();
    }
    form.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    children: [
      const HyperText('文件选择。系统选择与拖放默认由主包提供，上传由业务处理。'),
      DemoSection(
        title: '拖放区域 · 最多三个文件，每个 10 MB',
        child: HyperFilePicker(
          files: files,
          onChanged: (v) => setState(() {
            for (final old in files.where((f) => !v.contains(f))) {
              timers.remove(old)?.cancel();
              states.remove(old);
            }
            files = v;
          }),
          maxFiles: 3,
          maxFileSize: 10 * 1024 * 1024,
          uploadState: (f) =>
              states[f] ??
              const HyperFileUploadState(HyperFileUploadStatus.waiting),
          onRetry: (f) => upload(f, retry: true),
          onCancel: (f) {
            timers.remove(f)?.cancel();
            setState(
              () => states[f] = const HyperFileUploadState(
                HyperFileUploadStatus.canceled,
              ),
            );
          },
          thumbnailBuilder: (_, f) => _FileThumbnail(file: f),
        ),
      ),
      DemoSection(
        title: '模拟上传 · 不发送文件到服务器',
        child: Column(
          children: [
            Row(
              children: [
                HyperSwitch(
                  value: simulateFailure,
                  onChanged: (v) => setState(() => simulateFailure = v),
                ),
                const Expanded(child: Text('模拟首次失败，重试后成功')),
              ],
            ),
            HyperButton.filled(
              onPressed:
                  files.any(
                    (f) =>
                        (states[f]?.status ?? HyperFileUploadStatus.waiting) ==
                        HyperFileUploadStatus.waiting,
                  )
                  ? () {
                      for (final file in files) {
                        if (!states.containsKey(file)) upload(file);
                      }
                    }
                  : null,
              child: const Text('开始模拟上传'),
            ),
          ],
        ),
      ),
      DemoSection(
        title: '简洁单文件 · PNG / JPG',
        child: HyperFilePicker(
          files: simple,
          onChanged: (v) => setState(() => simple = v),
          variant: HyperFilePickerVariant.simple,
          multiple: false,
          allowedExtensions: const ['png', 'jpg'],
        ),
      ),
      DemoSection(
        title: '表单 · 必填与重置',
        child: HyperForm(
          controller: form,
          child: HyperFormSection(
            children: [
              HyperFileFormField(
                name: 'attachments',
                label: '附件',
                validator: (v) => v == null || v.isEmpty ? '请添加附件' : null,
              ),
              Wrap(
                spacing: HyperTheme.sizesOf(context).form.gap,
                children: [
                  HyperButton.outlined(
                    onPressed: form.reset,
                    child: const Text('重置'),
                  ),
                  HyperButton.filled(
                    onPressed: () async {
                      await form.submit((values) {
                        if (mounted) {
                          setState(
                            () => result =
                                '已提交 ${(values['attachments'] as List).length} 个附件（未发送到服务器）',
                          );
                        }
                      });
                    },
                    child: const Text('提交'),
                  ),
                ],
              ),
              HyperText(result),
            ],
          ),
        ),
      ),
    ],
  );
}

class _FileThumbnail extends StatefulWidget {
  const _FileThumbnail({required this.file});
  final HyperFileSelection file;
  @override
  State<_FileThumbnail> createState() => _FileThumbnailState();
}

class _FileThumbnailState extends State<_FileThumbnail> {
  Future<Uint8List>? bytes;
  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  void didUpdateWidget(_FileThumbnail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.file != widget.file) load();
  }

  void load() {
    final file = widget.file;
    final image = RegExp(
      r'\.(png|jpe?g|gif|webp)$',
      caseSensitive: false,
    ).hasMatch(file.name);
    bytes = image && file.size != null && file.size! <= 10 * 1024 * 1024
        ? file.readAsBytes()
        : null;
  }

  @override
  Widget build(BuildContext context) {
    const fallback = Icon(Icons.insert_drive_file_outlined);
    if (bytes == null) return fallback;
    final size = HyperTheme.sizesOf(context).textField.minimumHeight;
    return FutureBuilder<Uint8List>(
      future: bytes,
      builder: (_, snapshot) => snapshot.hasData
          ? ClipRRect(
              borderRadius: BorderRadius.circular(
                HyperTheme.sizesOf(context).textField.radius,
              ),
              child: Image.memory(
                snapshot.data!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => fallback,
              ),
            )
          : fallback,
    );
  }
}
