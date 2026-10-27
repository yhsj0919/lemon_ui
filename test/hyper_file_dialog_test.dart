import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

final class _MemoryFile extends PlatformFile {
  _MemoryFile(this.name, List<int> bytes) : data = Uint8List.fromList(bytes);
  @override
  final String name;
  final Uint8List data;
  int reads = 0;
  @override
  Uri get uri => Uri.parse('memory:/$name');
  @override
  XFile get xFile => XFile.fromData(data, name: name);
  @override
  int lengthSync() => data.length;
  @override
  Future<int?> length() async => data.length;
  @override
  Future<Uint8List> readAsBytes() async {
    reads++;
    return data;
  }

  @override
  Stream<Uint8List> readAsByteStream() => Stream.value(data);
}

class _Picker extends FilePickerPlatform {
  List<PlatformFile> files = [];
  int singleCalls = 0, multipleCalls = 0;
  FileType? typeSeen;
  List<String>? extensionsSeen;
  Uint8List? savedBytes;
  String? savedName, savedMime;
  @override
  Future<PlatformFile?> pickFile({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    singleCalls++;
    typeSeen = type;
    extensionsSeen = allowedExtensions;
    return files.isEmpty ? null : files.first;
  }

  @override
  Future<List<PlatformFile>> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    multipleCalls++;
    typeSeen = type;
    extensionsSeen = allowedExtensions;
    return files;
  }

  @override
  Future<Uri?> saveFile({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
    String? dialogTitle,
    String? initialDirectory,
    Function(FilePickerStatus)? onFileSaving,
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    savedName = fileName;
    savedBytes = bytes;
    savedMime = mimeType;
    return Uri.parse('memory:/$fileName');
  }
}

void main() {
  late FilePickerPlatform previous;
  late _Picker platform;
  setUp(() {
    previous = FilePickerPlatform.instance;
    platform = _Picker();
    FilePickerPlatform.instance = platform;
  });
  tearDown(() => FilePickerPlatform.instance = previous);
  Widget host(Widget child) => MaterialApp(
    home: HyperTheme(
      data: HyperThemeData.light(),
      child: Scaffold(body: child),
    ),
  );

  test(
    'system single pick normalizes extensions and reads bytes only on demand',
    () async {
      final file = _MemoryFile('a.png', [1, 2, 3]);
      platform.files = [file];
      final files = await HyperFileDialog.pickFiles(
        multiple: false,
        allowedExtensions: ['.PNG', 'jpg', 'PNG', ''],
      );
      expect(platform.singleCalls, 1);
      expect(platform.multipleCalls, 0);
      expect(platform.typeSeen, FileType.custom);
      expect(platform.extensionsSeen, ['png', 'jpg']);
      expect(files.single.name, 'a.png');
      expect(files.single.size, 3);
      expect(files.single.source, same(file));
      expect(file.reads, 0);
      expect(await files.single.readAsBytes(), [1, 2, 3]);
      expect(file.reads, 1);
    },
  );

  test('system multiple pick and save retain native results', () async {
    platform.files = [
      _MemoryFile('a.txt', [1]),
      _MemoryFile('b.txt', [2]),
    ];
    expect((await HyperFileDialog.pickFiles()).length, 2);
    expect(platform.multipleCalls, 1);
    expect(platform.typeSeen, FileType.any);
    expect(platform.extensionsSeen, isNull);
    final bytes = Uint8List.fromList([123, 125]);
    final uri = await HyperFileDialog.saveFile(
      fileName: 'theme.json',
      bytes: bytes,
      mimeType: 'application/json',
    );
    expect(uri, Uri.parse('memory:/theme.json'));
    expect(platform.savedName, 'theme.json');
    expect(platform.savedBytes, same(bytes));
    expect(platform.savedMime, 'application/json');
  });

  testWidgets(
    'picker defaults to native selection and cancellation preserves value',
    (tester) async {
      var changes = 0;
      const original = HyperFileSelection(name: 'existing.txt', size: 1);
      await tester.pumpWidget(
        host(
          HyperFilePicker(
            files: const [original],
            multiple: false,
            onChanged: (_) => changes++,
          ),
        ),
      );
      expect(find.byType(DropTarget), findsOneWidget);
      await tester.tap(find.text('选择文件'));
      await tester.pumpAndSettle();
      expect(platform.singleCalls, 1);
      expect(changes, 0);
      expect(find.text('existing.txt'), findsOneWidget);
    },
  );

  testWidgets('injected picker and drop builder override defaults', (
    tester,
  ) async {
    var customCalls = 0;
    List<HyperFileSelection>? changed;
    await tester.pumpWidget(
      host(
        HyperFilePicker(
          files: const [],
          onChanged: (files) => changed = files,
          pick: () {
            customCalls++;
            return const [HyperFileSelection(name: 'custom.txt')];
          },
          dropBuilder: (context, child, accept, hover, reject) => child,
        ),
      ),
    );
    expect(find.byType(DropTarget), findsNothing);
    await tester.tap(find.text('选择文件'));
    await tester.pumpAndSettle();
    expect(customCalls, 1);
    expect(platform.singleCalls + platform.multipleCalls, 0);
    expect(changed!.single.name, 'custom.txt');
  });

  testWidgets(
    'turning off drop ignores pending adapter results and clears hover',
    (tester) async {
      var drop = true, changed = 0;
      late StateSetter update;
      late ValueChanged<List<HyperFileSelection>> accept;
      late ValueChanged<bool> hover;
      await tester.pumpWidget(
        host(
          StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return HyperFilePicker(
                files: const [],
                enableDrop: drop,
                onChanged: (_) => changed++,
                dropBuilder: (context, child, add, setHover, reject) {
                  accept = add;
                  hover = setHover;
                  return child;
                },
              );
            },
          ),
        ),
      );
      hover(true);
      await tester.pump();
      expect(find.text('松开以添加文件'), findsOneWidget);
      update(() => drop = false);
      await tester.pump();
      accept(const [HyperFileSelection(name: 'late.txt')]);
      hover(true);
      await tester.pump();
      expect(changed, 0);
      expect(find.text('松开以添加文件'), findsNothing);
    },
  );

  testWidgets('default native file form uses the common validation path', (
    tester,
  ) async {
    platform.files = [
      _MemoryFile('a.png', [1, 2, 3]),
    ];
    final form = HyperFormController();
    addTearDown(form.dispose);
    await tester.pumpWidget(
      host(
        HyperForm(
          controller: form,
          child: HyperFileFormField(
            name: 'files',
            multiple: false,
            allowedExtensions: const ['png'],
            maxFileSize: 2,
            enableDrop: false,
          ),
        ),
      ),
    );
    expect(find.byType(DropTarget), findsNothing);
    await tester.tap(find.text('选择文件'));
    await tester.pumpAndSettle();
    expect(platform.singleCalls, 1);
    expect(form.value<List<HyperFileSelection>>('files'), isEmpty);
    expect(find.textContaining('超出大小限制'), findsOneWidget);
  });
}
