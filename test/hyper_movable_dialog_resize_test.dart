import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Finder handle(int x, int y) =>
    find.byKey(ValueKey('hyper-movable-dialog-resize-$x-$y'));
Rect surface(WidgetTester tester) => tester.getRect(
  find.ancestor(of: handle(1, 0), matching: find.byType(Stack)).first,
);

Widget host(
  HyperMovableDialogController controller, {
  bool resizable = true,
  bool enabled = true,
  double scale = 1,
  EdgeInsets insets = EdgeInsets.zero,
  BoxConstraints resizeConstraints = const BoxConstraints(),
  HyperDialogStyle dialogStyle = const HyperDialogStyle(
    width: 320,
    maxWidth: 320,
  ),
  List<Widget> actions = const [],
}) => MaterialApp(
  home: HyperTheme(
    data: HyperThemeData.light(),
    child: MediaQuery(
      data: MediaQueryData(
        size: const Size(800, 600),
        textScaler: TextScaler.linear(scale),
        viewInsets: insets,
      ),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: HyperMovableDialog(
          controller: controller,
          resizable: resizable,
          enabled: enabled,
          resizeConstraints: resizeConstraints,
          actions: actions,
          title: const Text('窗口标题'),
          content: const HyperTextField(initialValue: 'draft'),
          style: HyperMovableDialogStyle(dialogStyle: dialogStyle),
        ),
      ),
    ),
  ),
);

void main() {
  testWidgets('resize respects explicit constraints', (tester) async {
    final controller = HyperMovableDialogController(
      initialSize: const Size(320, 280),
    );
    await tester.pumpWidget(
      host(
        controller,
        resizeConstraints: const BoxConstraints(
          minWidth: 280,
          maxWidth: 380,
          minHeight: 220,
          maxHeight: 340,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(handle(1, 1), const Offset(1000, 1000));
    await tester.pumpAndSettle();
    expect(surface(tester).size, const Size(380, 340));
    await tester.drag(handle(1, 1), const Offset(-1000, -1000));
    await tester.pumpAndSettle();
    expect(surface(tester).size, const Size(280, 220));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
  });
  testWidgets('first resize retains custom alignment and asymmetric insets', (
    tester,
  ) async {
    final controller = HyperMovableDialogController();
    await tester.pumpWidget(
      host(
        controller,
        dialogStyle: const HyperDialogStyle(
          width: 320,
          maxWidth: 320,
          alignment: Alignment.topLeft,
          insetPadding: EdgeInsets.fromLTRB(30, 40, 10, 20),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final before = surface(tester);
    await tester.drag(handle(1, 1), const Offset(60, 40));
    await tester.pumpAndSettle();
    expect(surface(tester).topLeft, before.topLeft);
    expect(surface(tester).width, closeTo(before.width + 60, .01));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
  });
  test('size controller validates geometry and notifies atomically', () {
    expect(
      () => HyperMovableDialogController(initialSize: const Size(0, 10)),
      throwsArgumentError,
    );
    final controller = HyperMovableDialogController();
    var changes = 0;
    controller.addListener(() => changes++);
    controller.resizeTo(const Size(300, 240), offset: const Offset(20, 30));
    expect(controller.size, const Size(300, 240));
    expect(controller.offset, const Offset(20, 30));
    expect(changes, 1);
    controller.resizeTo(const Size(300, 240));
    expect(changes, 1);
    expect(
      () => controller.resizeTo(const Size(double.infinity, 100)),
      throwsArgumentError,
    );
    controller.dispose();
  });
  testWidgets(
    'resize avoids keyboard and title dragging still works afterwards',
    (tester) async {
      final controller = HyperMovableDialogController(
        initialSize: const Size(320, 220),
      );
      await tester.pumpWidget(
        host(controller, insets: const EdgeInsets.only(bottom: 200)),
      );
      await tester.pumpAndSettle();
      await tester.drag(handle(1, 1), const Offset(1000, 1000));
      await tester.pumpAndSettle();
      expect(surface(tester).bottom, lessThanOrEqualTo(400));
      await tester.drag(handle(1, 1), const Offset(-100, -60));
      await tester.pumpAndSettle();
      final before = surface(tester);
      await tester.drag(
        find.byKey(const ValueKey('hyper-movable-dialog-handle')),
        const Offset(-20, -10),
      );
      await tester.pumpAndSettle();
      expect(surface(tester).topLeft, before.topLeft + const Offset(-20, -10));
      expect(surface(tester).size, before.size);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );
  for (final edge in const [
    Alignment.topLeft,
    Alignment.topCenter,
    Alignment.topRight,
    Alignment.centerLeft,
    Alignment.centerRight,
    Alignment.bottomLeft,
    Alignment.bottomCenter,
    Alignment.bottomRight,
  ]) {
    testWidgets(
      'resize $edge holds opposite edges and preserves editing state',
      (tester) async {
        final controller = HyperMovableDialogController(
          initialSize: const Size(320, 280),
        );
        await tester.pumpWidget(host(controller));
        await tester.pumpAndSettle();
        final before = surface(tester);
        final editing = tester
            .widget<EditableText>(find.byType(EditableText))
            .controller;
        await tester.drag(
          handle(edge.x.toInt(), edge.y.toInt()),
          Offset(edge.x * 40, edge.y * 30),
        );
        await tester.pumpAndSettle();
        final after = surface(tester);
        expect(
          after.width,
          closeTo(before.width + (edge.x == 0 ? 0 : 40), .01),
        );
        expect(
          after.height,
          closeTo(before.height + (edge.y == 0 ? 0 : 30), .01),
        );
        if (edge.x < 0) expect(after.right, closeTo(before.right, .01));
        if (edge.x > 0) expect(after.left, closeTo(before.left, .01));
        if (edge.y < 0) expect(after.bottom, closeTo(before.bottom, .01));
        if (edge.y > 0) expect(after.top, closeTo(before.top, .01));
        expect(
          tester.widget<EditableText>(find.byType(EditableText)).controller,
          same(editing),
        );
        expect(editing.text, 'draft');
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox());
        controller.dispose();
      },
    );
  }
  testWidgets('content-sized dialog can grow beyond its initial themed width', (
    tester,
  ) async {
    final controller = HyperMovableDialogController();
    await tester.pumpWidget(host(controller));
    await tester.pumpAndSettle();
    final before = surface(tester);
    await tester.drag(handle(1, 1), const Offset(80, 60));
    await tester.pumpAndSettle();
    expect(surface(tester).width, closeTo(before.width + 80, .01));
    expect(surface(tester).height, closeTo(before.height + 60, .01));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
    controller.dispose();
  });
  testWidgets(
    'maximize restores user size and edge handles stay disabled while maximized',
    (tester) async {
      final controller = HyperMovableDialogController(
        initialSize: const Size(320, 280),
      );
      await tester.pumpWidget(host(controller));
      await tester.pumpAndSettle();
      await tester.drag(handle(1, 1), const Offset(50, 40));
      await tester.pumpAndSettle();
      final rect = surface(tester);
      controller.setMaximized(true);
      await tester.pumpAndSettle();
      expect(handle(1, 0), findsNothing);
      controller.setMaximized(false);
      await tester.pumpAndSettle();
      expect(surface(tester), rect);
      await tester.pumpWidget(host(controller, resizable: false));
      expect(handle(1, 0), findsNothing);
      await tester.pumpWidget(host(controller, enabled: false));
      expect(handle(1, 0), findsNothing);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    },
  );
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('resize remains bounded at scale $scale', (tester) async {
      final controller = HyperMovableDialogController(
        initialSize: const Size(400, 300),
      );
      await tester.pumpWidget(
        host(
          controller,
          scale: scale,
          actions: [
            HyperButton.text(onPressed: () {}, label: const Text('取消')),
            HyperButton.text(onPressed: () {}, label: const Text('确认')),
          ],
        ),
      );
      await tester.pumpAndSettle();
      await tester.drag(handle(1, 1), const Offset(2000, 2000));
      await tester.pumpAndSettle();
      final rect = surface(tester);
      expect(rect.right, lessThanOrEqualTo(800));
      expect(rect.bottom, lessThanOrEqualTo(600));
      await tester.drag(handle(1, 1), const Offset(-2000, -2000));
      await tester.pumpAndSettle();
      expect(surface(tester).size.isEmpty, isFalse);
      expect(surface(tester).width, lessThan(rect.width));
      expect(surface(tester).height, lessThan(rect.height));
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      controller.dispose();
    });
  }
}
