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
  testWidgets(
    'custom controls close and toggle maximize outside the drag handle',
    (tester) async {
      final controller = HyperMovableDialogController();
      var closes = 0;
      await tester.pumpWidget(
        host(
          HyperMovableDialog(
            controller: controller,
            title: const Text('窗口'),
            content: const Text('正文'),
            onClose: () => closes++,
            closeButtonBuilder: (context, close) =>
                HyperButton.text(onPressed: close, label: const Text('自定义关闭')),
            maximizeButtonBuilder: (context, maximized, toggle) =>
                HyperButton.text(
                  onPressed: toggle,
                  label: Text(maximized ? '自定义还原' : '自定义最大化'),
                ),
          ),
        ),
      );
      expect(find.byTooltip('最大化'), findsNothing);
      expect(find.byIcon(HyperIcons.x), findsNothing);
      expect(
        find.ancestor(
          of: find.text('自定义关闭'),
          matching: find.byKey(const ValueKey('hyper-movable-dialog-handle')),
        ),
        findsNothing,
      );
      await tester.tap(find.text('自定义最大化'));
      await tester.pumpAndSettle();
      expect(controller.maximized, isTrue);
      await tester.tap(find.text('自定义还原'));
      await tester.pumpAndSettle();
      expect(controller.maximized, isFalse);
      await tester.tap(find.text('自定义关闭'));
      expect(closes, 1);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );
  for (final showClose in [false, true]) {
    for (final showMaximize in [false, true]) {
      testWidgets(
        'visibility close=$showClose maximize=$showMaximize overrides builders',
        (tester) async {
          await tester.pumpWidget(
            host(
              HyperMovableDialog(
                title: const Text('窗口'),
                content: const Text('正文'),
                showCloseButton: showClose,
                showMaximizeButton: showMaximize,
                closeButtonBuilder: (context, close) =>
                    TextButton(onPressed: close, child: const Text('X')),
                maximizeButtonBuilder: (context, maximized, toggle) =>
                    TextButton(onPressed: toggle, child: const Text('M')),
              ),
            ),
          );
          expect(find.text('X'), showClose ? findsOneWidget : findsNothing);
          expect(find.text('M'), showMaximize ? findsOneWidget : findsNothing);
          expect(find.byIcon(HyperIcons.x), findsNothing);
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
  testWidgets('custom maximize receives disabled callback', (tester) async {
    VoidCallback? action = () {};
    await tester.pumpWidget(
      host(
        HyperMovableDialog(
          title: const Text('窗口'),
          content: const Text('正文'),
          enabled: false,
          maximizeButtonBuilder: (context, maximized, toggle) {
            action = toggle;
            return TextButton(onPressed: toggle, child: const Text('maximize'));
          },
        ),
      ),
    );
    expect(action, isNull);
  });
  testWidgets('custom close defaults to closing the shared dialog route', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showHyperMovableDialog<void>(
              context: context,
              builder: (_) => HyperMovableDialog(
                title: const Text('窗口'),
                content: const Text('正文'),
                closeButtonBuilder: (context, close) =>
                    TextButton(onPressed: close, child: const Text('关闭窗口')),
              ),
            ),
            child: const Text('打开'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('关闭窗口'));
    await tester.pumpAndSettle();
    expect(find.byType(HyperMovableDialog), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
