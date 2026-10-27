import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import 'hyper_file_selection.dart';
import 'hyper_file_extensions.dart';

/// 系统文件对话框，由平台插件提供原生或浏览器实现。
abstract final class HyperFileDialog {
  /// 选择文件并返回元数据，取消时返回空列表。
  ///
  /// [multiple] 为 `false` 时打开单选窗口。[allowedExtensions] 支持带点或
  /// 不带点的扩展名；文件大小读取不预加载文件字节。
  static Future<List<HyperFileSelection>> pickFiles({
    bool multiple = true,
    List<String>? allowedExtensions,
    String? dialogTitle,
    String? initialDirectory,
  }) async {
    final extensions = normalizeHyperFileExtensions(allowedExtensions);
    final filter = extensions.isEmpty ? null : extensions.toList();
    final type = filter == null ? FileType.any : FileType.custom;
    final List<PlatformFile> files;
    if (multiple) {
      files = await FilePicker.pickFiles(
        type: type,
        allowedExtensions: filter,
        dialogTitle: dialogTitle,
        initialDirectory: initialDirectory,
      );
    } else {
      final file = await FilePicker.pickFile(
        type: type,
        allowedExtensions: filter,
        dialogTitle: dialogTitle,
        initialDirectory: initialDirectory,
      );
      files = file == null ? [] : [file];
    }
    return List.unmodifiable([
      for (final file in files)
        HyperFileSelection(
          name: file.name,
          size: await file.length(),
          source: file,
        ),
    ]);
  }

  /// 将 [bytes] 保存到用户选择的位置，Web 上由浏览器下载文件。
  ///
  /// 保存位置与取消行为由平台决定，取消时可返回 `null`。
  static Future<Uri?> saveFile({
    required String fileName,
    required Uint8List bytes,
    String mimeType = 'application/octet-stream',
    String? dialogTitle,
    String? initialDirectory,
  }) => FilePicker.saveFile(
    fileName: fileName,
    bytes: bytes,
    mimeType: mimeType,
    dialogTitle: dialogTitle,
    initialDirectory: initialDirectory,
  );
}
