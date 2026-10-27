import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/widgets.dart';

import 'hyper_file_selection.dart';
import 'hyper_file_drop_path_stub.dart'
    if (dart.library.io) 'hyper_file_drop_path_io.dart';

// Process every entry independently: one unreadable file cannot discard others.
Future<List<HyperFileSelection>> readHyperDroppedFiles(
  List<XFile> incoming,
  ValueChanged<String> reject,
) async {
  final files = <HyperFileSelection>[];
  for (final file in incoming) {
    try {
      if (file is DropItemDirectory || await isDropDirectory(file.path)) {
        reject('暂不支持文件夹：${file.name}，请选择其中的文件');
        continue;
      }
      files.add(
        HyperFileSelection(
          name: file.name,
          size: await file.length(),
          source: file,
        ),
      );
    } catch (_) {
      reject('无法读取文件 ${file.name}，请检查文件是否可访问');
    }
  }
  return files;
}

Widget buildHyperFileDropTarget(
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
        final files = await readHyperDroppedFiles(
          details.files,
          rejections.add,
        );
        if (!context.mounted) return;
        accept(files);
        if (rejections.isNotEmpty) reject(rejections.first);
      },
      child: MediaQuery(data: previewMedia, child: child),
    ),
  );
}
