import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget host(Widget child) => MaterialApp(
  home: HyperTheme(
    data: HyperThemeData.light(),
    child: Scaffold(body: child),
  ),
);
void main() {
  testWidgets('upload status shows progress retry and cancellation callbacks', (
    t,
  ) async {
    const file = HyperFileSelection(name: 'a.png', size: 10);
    var status = const HyperFileUploadState(
      HyperFileUploadStatus.uploading,
      progress: .4,
    );
    var retries = 0, cancels = 0;
    late StateSetter update;
    await t.pumpWidget(
      host(
        StatefulBuilder(
          builder: (_, setState) {
            update = setState;
            return HyperFilePicker(
              files: const [file],
              onChanged: (_) {},
              pick: () => const [],
              uploadState: (_) => status,
              onRetry: (_) => retries++,
              onCancel: (_) => cancels++,
            );
          },
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(find.text('上传中 40%'), findsOneWidget);
    expect(
      t.widget<HyperLinearProgress>(find.byType(HyperLinearProgress)).value,
      .4,
    );
    await t.tap(find.text('取消上传'));
    expect(cancels, 1);
    update(
      () => status = const HyperFileUploadState(
        HyperFileUploadStatus.failed,
        errorText: '上传失败，请重试',
      ),
    );
    await t.pumpAndSettle();
    expect(find.text('上传失败，请重试'), findsOneWidget);
    await t.tap(find.text('重试'));
    expect(retries, 1);
    update(
      () => status = const HyperFileUploadState(HyperFileUploadStatus.success),
    );
    await t.pumpAndSettle();
    expect(find.text('上传成功'), findsOneWidget);
    expect(find.text('重试'), findsNothing);
    expect(find.byType(HyperLinearProgress), findsNothing);
    expect(t.takeException(), isNull);
  });
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('file interface wraps at narrow width scale $scale', (t) async {
      await t.pumpWidget(
        host(
          MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: SizedBox(
              width: 220,
              child: HyperFilePicker(
                files: const [
                  HyperFileSelection(name: '很长的附件名称和说明.pdf', size: 100),
                ],
                onChanged: (_) {},
                pick: () => const [],
              ),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
    });
  }
  testWidgets('file selection validates accepts immutable files and removes', (
    t,
  ) async {
    List<HyperFileSelection> files = [];
    await t.pumpWidget(
      host(
        StatefulBuilder(
          builder: (_, setState) => HyperFilePicker(
            files: files,
            onChanged: (v) => setState(() => files = v),
            allowedExtensions: const ['.png'],
            maxFileSize: 100,
            maxFiles: 2,
            pick: () => const [
              HyperFileSelection(name: 'ok.PNG', size: 10),
              HyperFileSelection(name: 'bad.txt', size: 10),
            ],
          ),
        ),
      ),
    );
    await t.tap(find.text('选择文件'));
    await t.pumpAndSettle();
    expect(files.single.name, 'ok.PNG');
    expect(find.textContaining('不支持文件'), findsOneWidget);
    expect(() => files.clear(), throwsUnsupportedError);
    await t.tap(find.byIcon(HyperIcons.x));
    await t.pumpAndSettle();
    expect(files, isEmpty);
    expect(t.takeException(), isNull);
  });
  testWidgets('form file required validation and reset', (t) async {
    final c = HyperFormController();
    await t.pumpWidget(
      host(
        HyperForm(
          controller: c,
          child: HyperFileFormField(
            name: 'files',
            label: '附件',
            variant: HyperFilePickerVariant.simple,
            pick: () => const [HyperFileSelection(name: 'a.pdf', size: 12)],
            validator: (v) => v == null || v.isEmpty ? '必填' : null,
          ),
        ),
      ),
    );
    await t.pumpAndSettle();
    expect(await c.validate(), false);
    await t.tap(find.text('选择文件'));
    await t.pumpAndSettle();
    expect(await c.validate(), true);
    expect(c.isDirty, true);
    c.reset();
    await t.pumpAndSettle();
    expect(c.value<List<HyperFileSelection>>('files'), isEmpty);
    expect(find.text('a.pdf'), findsNothing);
    expect(c.isDirty, false);
  });
  testWidgets('pending picker cannot update disabled control', (t) async {
    final pending = Completer<List<HyperFileSelection>>();
    var enabled = true, calls = 0;
    late StateSetter update;
    await t.pumpWidget(
      host(
        StatefulBuilder(
          builder: (_, setState) {
            update = setState;
            return HyperFilePicker(
              files: const [],
              enabled: enabled,
              pick: () => pending.future,
              onChanged: (_) => calls++,
            );
          },
        ),
      ),
    );
    await t.tap(find.text('选择文件'));
    await t.pump();
    update(() => enabled = false);
    await t.pump();
    pending.complete(const [HyperFileSelection(name: 'a')]);
    await t.pumpAndSettle();
    expect(calls, 0);
    expect(t.takeException(), isNull);
  });
}
