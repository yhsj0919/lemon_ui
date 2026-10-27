import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

/// 文件元数据与原始句柄，创建时不会读取整份文件内容。
@immutable
class HyperFileSelection {
  const HyperFileSelection({required this.name, this.size, this.source});

  /// 包含扩展名的文件名称。
  final String name;

  /// 文件字节数；平台无法确定时为 `null`。
  final int? size;

  /// 原始平台句柄，保留给需要自定义处理的调用方。
  final Object? source;

  /// 按需读取系统选择或拖入文件的内容。
  ///
  /// 自定义 [source] 不是支持的文件句柄时抛出 [StateError]。
  /// 自定义选择适配也可通过组件的缩略图回调自行处理句柄。
  Future<Uint8List> readAsBytes() {
    final handle = source;
    if (handle is PlatformFile) return handle.readAsBytes();
    if (handle is XFile) return handle.readAsBytes();
    throw StateError('文件没有可读取的系统句柄：$name');
  }
}
