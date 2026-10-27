import 'dart:io';

import 'package:cross_file/cross_file.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/src/components/file_picker/hyper_file_drop_adapter.dart';

class UnreadableFile extends XFile {
  UnreadableFile() : super('unreadable', name: '无法读取.txt');
  @override
  Future<int> length() async => throw const FileSystemException('unsupported');
}

void main() {
  test(
    'folder and unreadable entry do not throw or discard valid file',
    () async {
      final directory = await Directory.systemTemp.createTemp(
        'lemon-file-drop-',
      );
      addTearDown(() => directory.delete(recursive: true));
      final file = await File(
        '${directory.path}${Platform.pathSeparator}ok.txt',
      ).writeAsString('hello');
      final errors = <String>[];
      final accepted = await readHyperDroppedFiles([
        XFile(directory.path),
        UnreadableFile(),
        XFile(file.path, name: 'ok.txt'),
      ], errors.add);
      expect(errors.length, 2);
      expect(errors.first, contains('不支持文件夹'));
      expect(errors.last, contains('无法读取文件'));
      expect(accepted.single.name, 'ok.txt');
      expect(accepted.single.size, 5);
    },
  );
}
