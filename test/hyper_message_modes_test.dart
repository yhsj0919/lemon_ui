import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('复现串行延迟：第二条和第三条等待第一条完成退出', () async {
    final controller = HyperSnackbarController(
      toastMode: HyperMessageMode.queue,
    );
    final first = controller.show(toast: true, content: const Text('1'));
    final request = controller.current!;
    controller.show(toast: true, content: const Text('2'));
    controller.show(toast: true, content: const Text('3'));
    expect(controller.visible.length, 1);
    expect(controller.waitingCount, 2);
    first.close();
    expect(controller.visible.single, same(request));
    controller.complete(request);
    expect(await first.closed, HyperMessageCloseReason.dismissed);
    expect(
      controller.visible.single.content,
      isA<Text>().having((text) => text.data, 'text', '2'),
    );
    controller.dispose();
  });

  test('默认 Toast 实时堆叠，突发超过上限时保留最新三条', () async {
    final controller = HyperSnackbarController();
    final handles = <HyperMessageHandle>[];
    for (var i = 1; i <= 100; i++) {
      handles.add(controller.show(toast: true, content: Text('$i')));
    }
    expect(controller.visible.map((entry) => (entry.content as Text).data), [
      '98',
      '99',
      '100',
    ]);
    expect(controller.waitingCount, 0);
    expect(controller.pendingCount, 3);
    for (final handle in handles.take(97)) {
      expect(await handle.closed, HyperMessageCloseReason.superseded);
    }
    controller.dispose();
    expect(await handles.last.closed, HyperMessageCloseReason.hostDisposed);
  });

  test('已经显示的最旧提示保留退出，立即腾出实时名额', () async {
    final controller = HyperSnackbarController(maxVisible: 2);
    final first = controller.show(toast: true, content: const Text('1'));
    final request = controller.current!;
    controller.markPresented(request);
    controller.show(toast: true, content: const Text('2'));
    controller.show(toast: true, content: const Text('3'));
    expect(request.closeReason, HyperMessageCloseReason.superseded);
    expect(controller.visible.length, 3); // 一条退出，两条有效。
    expect(
      controller.visible.where((entry) => entry.closeReason == null).length,
      2,
    );
    expect(controller.waitingCount, 0);
    controller.complete(request);
    expect(await first.closed, HyperMessageCloseReason.superseded);
    expect(controller.visible.length, 2);
    controller.dispose();
  });

  test('堆叠队列满额等待，任何一项退出后按 FIFO 补位', () async {
    final controller = HyperSnackbarController(
      toastMode: HyperMessageMode.stackQueue,
      maxVisible: 2,
    );
    final first = controller.show(toast: true, content: const Text('1'));
    final second = controller.show(toast: true, content: const Text('2'));
    final secondRequest = controller.visible.last;
    final third = controller.show(toast: true, content: const Text('3'));
    final fourth = controller.show(toast: true, content: const Text('4'));
    expect(controller.visible.length, 2);
    expect(controller.waitingCount, 2);
    second.close();
    expect(controller.waitingCount, 2);
    controller.complete(secondRequest);
    expect(await second.closed, HyperMessageCloseReason.dismissed);
    expect(controller.visible.map((entry) => entry.handle), [first, third]);
    fourth.close();
    expect(await fourth.closed, HyperMessageCloseReason.dismissed);
    expect(controller.waitingCount, 0);
    controller.dispose();
  });

  test('Toast 和带操作 Snackbar 独立，不会被 Toast 淘汰或阻塞', () async {
    final controller = HyperSnackbarController(maxVisible: 1);
    final snackbar = controller.show(
      content: const Text('action'),
      action: const Text('undo'),
    );
    final snackbarRequest = controller.current!;
    final firstToast = controller.show(toast: true, content: const Text('old'));
    final lastToast = controller.show(toast: true, content: const Text('new'));
    expect(await firstToast.closed, HyperMessageCloseReason.superseded);
    expect(snackbarRequest.closeReason, isNull);
    expect(controller.visible.map((entry) => entry.handle), [
      snackbar,
      lastToast,
    ]);
    final secondSnackbar = controller.show(content: const Text('next action'));
    expect(controller.waitingCount, 1);
    snackbar.close(HyperMessageCloseReason.action);
    controller.complete(snackbarRequest);
    expect(controller.visible.map((entry) => entry.handle), [
      lastToast,
      secondSnackbar,
    ]);
    controller.dispose();
  });

  test('可覆盖单条模式和修改上限；关闭中的请求不重复完成', () async {
    expect(() => HyperSnackbarController(maxVisible: 0), throwsArgumentError);
    final controller = HyperSnackbarController(
      toastMode: HyperMessageMode.queue,
    );
    final first = controller.show(
      toast: true,
      content: const Text('1'),
      mode: HyperMessageMode.stack,
    );
    final firstRequest = controller.current!;
    controller.markPresented(firstRequest);
    controller.show(
      toast: true,
      content: const Text('2'),
      mode: HyperMessageMode.stack,
    );
    controller.show(
      toast: true,
      content: const Text('3'),
      mode: HyperMessageMode.stack,
    );
    controller.configure(
      toastMode: HyperMessageMode.stack,
      snackbarMode: HyperMessageMode.queue,
      maxVisible: 1,
    );
    expect(
      controller.visible.where((entry) => entry.closeReason == null).length,
      1,
    );
    first.close();
    controller.complete(firstRequest);
    controller.complete(firstRequest);
    expect(await first.closed, HyperMessageCloseReason.superseded);
    expect(
      () => controller.configure(
        toastMode: HyperMessageMode.stack,
        snackbarMode: HyperMessageMode.queue,
        maxVisible: 0,
      ),
      throwsArgumentError,
    );
    controller.clear();
    for (final request in controller.visible) {
      controller.complete(request);
    }
    expect(controller.pendingCount, 0);
    controller.dispose();
  });
}
