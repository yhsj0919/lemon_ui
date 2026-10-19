import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:desktop_drop/desktop_drop.dart';

import 'file_drop_adapter.dart';

import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

Future<List<HyperFileSelection>> _pickFiles() async => [
  for (final file in await FilePicker.pickFiles())
    HyperFileSelection(
      name: file.name,
      size: await file.length(),
      source: file,
    ),
];

Widget _drop(
  BuildContext context,
  Widget child,
  ValueChanged<List<HyperFileSelection>> accept,
  ValueChanged<bool> hover,
  ValueChanged<String> reject,
) {
  final previewMedia = MediaQuery.of(context);
  return MediaQuery(
    data: previewMedia.copyWith(
      devicePixelRatio: View.of(context).devicePixelRatio,
    ),
    child: DropTarget(
      onDragEntered: (_) => hover(true),
      onDragExited: (_) => hover(false),
      onDragDone: (details) async {
        hover(false);
        final rejections = <String>[];
        final files = await readDroppedFiles(details.files, rejections.add);
        if (context.mounted) accept(files);
        if (context.mounted && rejections.isNotEmpty) reject(rejections.first);
      },
      child: MediaQuery(data: previewMedia, child: child),
    ),
  );
}

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
      const HyperText('文件选择 · 未确认。参考 lemon_shadcn；系统选择和拖放由第三方库完成，上传由业务处理。'),
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
          pick: _pickFiles,
          dropBuilder: _drop,
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
          pick: _pickFiles,
          variant: HyperFilePickerVariant.simple,
          multiple: false,
          allowedExtensions: const ['png', 'jpg'],
        ),
      ),
      DemoSection(
        title: 'Form · 必填与重置',
        child: HyperForm(
          controller: form,
          child: HyperFormSection(
            children: [
              HyperFileFormField(
                name: 'attachments',
                label: '附件',
                pick: _pickFiles,
                dropBuilder: _drop,
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
    final source = file.source;
    bytes = image && file.size != null && file.size! <= 10 * 1024 * 1024
        ? source is PlatformFile
              ? source.xFile.readAsBytes()
              : source is XFile
              ? source.readAsBytes()
              : null
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
