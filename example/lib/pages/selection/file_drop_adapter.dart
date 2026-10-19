import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'file_drop_path_stub.dart' if (dart.library.io) 'file_drop_path_io.dart';

/// Read each dropped file independently; one unreadable item cannot discard others.
Future<List<HyperFileSelection>> readDroppedFiles(
  List<XFile> incoming,
  void Function(String) reject,
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
