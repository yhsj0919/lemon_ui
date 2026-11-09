import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Future<void> mount(
  WidgetTester tester,
  Widget content, {
  bool? scrollable,
  double scale = 1,
  Size viewport = const Size(800, 600),
  double keyboard = 0,
}) async {
  tester.view.physicalSize = viewport;
  tester.view.devicePixelRatio = 1;
  final dialog = HyperDialog(
    title: const Text('测试弹窗'),
    content: content,
    actions: [TextButton(onPressed: () {}, child: const Text('确定'))],
  );
  await tester.pumpWidget(
    MaterialApp(
      home: HyperTheme(
        data: HyperThemeData.light(),
        duration: Duration.zero,
        child: MediaQuery(
          data: MediaQueryData(
            size: viewport,
            textScaler: TextScaler.linear(scale),
            viewInsets: EdgeInsets.only(bottom: keyboard),
          ),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: scrollable == null
                ? dialog
                : HyperDialog(
                    title: dialog.title,
                    content: content,
                    actions: dialog.actions,
                    scrollable: scrollable,
                  ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  for (final kind in ['infinite-size', 'list', 'grid']) {
    testWidgets(
      'default dialog bounds standalone $kind without explicit dimensions',
      (tester) async {
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final content = switch (kind) {
          'list' => ListView.builder(
            itemCount: 100,
            itemBuilder: (_, i) => Text('项目 $i'),
          ),
          'grid' => GridView.count(
            crossAxisCount: 2,
            children: [for (var i = 0; i < 20; i++) Text('项目 $i')],
          ),
          _ => const SizedBox.expand(child: Text('占满正文')),
        };
        await mount(
          tester,
          content,
          viewport: const Size(320, 640),
          keyboard: 180,
        );
        final size = tester.getSize(find.byWidget(content));
        expect(size.width.isFinite, isTrue);
        expect(size.height.isFinite, isTrue);
        expect(size.height, lessThan(460));
        expect(find.byType(SingleChildScrollView), findsNothing);
        expect(tester.takeException(), isNull);
      },
    );
  }
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets(
      'default row and column receive bounded width at scale $scale',
      (tester) async {
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        BoxConstraints? measured;
        await mount(
          tester,
          Column(
            children: [
              Row(children: [Expanded(child: Text('正常横排文字 ' * 8))]),
              LayoutBuilder(
                builder: (_, constraints) {
                  measured = constraints;
                  return const SizedBox(width: double.infinity, height: 30);
                },
              ),
            ],
          ),
          scale: scale,
          viewport: const Size(320, 640),
          keyboard: 180,
        );
        expect(measured!.hasBoundedWidth, isTrue);
        expect(measured!.maxWidth, lessThan(320));
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'bounded body handles expanded columns and infinite height at scale $scale',
      (tester) async {
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        BoxConstraints? measured;
        await mount(
          tester,
          Column(
            children: [
              const Text('列表标题'),
              Expanded(
                child: LayoutBuilder(
                  builder: (_, constraints) {
                    measured = constraints;
                    return SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                      child: ListView.builder(
                        itemCount: 100,
                        itemBuilder: (_, index) => Text('项目 $index'),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          scale: scale,
          viewport: const Size(320, 640),
          keyboard: 180,
        );
        expect(measured!.hasBoundedWidth, isTrue);
        expect(measured!.hasBoundedHeight, isTrue);
        expect(measured!.maxHeight, lessThan(640 - 180));
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'explicit long content scrolling keeps header and actions fixed',
    (tester) async {
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await mount(
        tester,
        Column(children: [for (var i = 0; i < 100; i++) Text('长内容 $i')]),
        scrollable: true,
      );
      final title = tester.getTopLeft(find.text('测试弹窗'));
      final action = tester.getTopLeft(find.text('确定'));
      await tester.drag(
        find.byType(SingleChildScrollView),
        const Offset(0, -250),
      );
      await tester.pumpAndSettle();
      expect(tester.getTopLeft(find.text('测试弹窗')), title);
      expect(tester.getTopLeft(find.text('确定')), action);
      expect(tester.takeException(), isNull);
    },
  );

  for (final example in [
    'expanded',
    'infinite-height',
    'list-view',
    'nested-row',
  ]) {
    testWidgets(
      'explicit scrolling retains Flutter constraint rules: $example',
      (tester) async {
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        final errors = <FlutterErrorDetails>[];
        final handler = FlutterError.onError;
        FlutterError.onError = errors.add;
        try {
          final content = switch (example) {
            'expanded' => Column(children: [Expanded(child: Container())]),
            'infinite-height' => const SizedBox(height: double.infinity),
            'list-view' => ListView(children: const [Text('列表内容')]),
            _ => Row(
              children: [
                Column(children: [SizedBox(width: 2000, child: Text('超宽内容'))]),
              ],
            ),
          };
          await mount(tester, content, scrollable: true);
          expect(errors, isNotEmpty);
          final message = errors
              .map((error) => error.exceptionAsString())
              .join('\n');
          expect(
            message,
            contains(switch (example) {
              'expanded' => 'unbounded',
              'infinite-height' => 'infinite size',
              'list-view' => 'unbounded height',
              _ => 'overflowed',
            }),
          );
          await tester.pumpWidget(const SizedBox.shrink());
        } finally {
          FlutterError.onError = handler;
        }
      },
    );
  }
}
