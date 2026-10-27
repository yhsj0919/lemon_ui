import 'dart:io';

Future<bool> isDropDirectory(String path) async =>
    await FileSystemEntity.type(path) == FileSystemEntityType.directory;
