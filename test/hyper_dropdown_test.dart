import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('自定义下拉任意内容可交互关闭并复用表面', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: Center(
              child: HyperDropdown(
                presentation: HyperSelectPresentation.anchored,
                surfaceStyle: HyperCardStyle(boxShadow: []),
                panelBuilder: (context, close) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('自由内容'),
                    HyperButton.text(
                      label: const Text('完成筛选'),
                      onPressed: close,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    expect(find.text('自由内容'), findsOneWidget);
    expect(
      tester.widget<HyperCard>(find.byType(HyperCard)).style!.boxShadow,
      isEmpty,
    );
    await tester.tap(find.text('完成筛选'));
    await tester.pumpAndSettle();
    expect(find.text('自由内容'), findsNothing);
    expect(tester.takeException(), isNull);
  });
  testWidgets('禁用下拉不打开，受控开合通知调用者', (tester) async {
    bool? requested;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperDropdown(
              isOpen: false,
              onOpenChanged: (value) => requested = value,
              panelBuilder: (context, close) => const Text('面板'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    expect(requested, isTrue);
    expect(find.text('面板'), findsNothing);
  });
  testWidgets('底部弹窗中的自定义内容可关闭', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperDropdown(
              presentation: HyperSelectPresentation.bottomSheet,
              panelBuilder: (context, close) =>
                  HyperButton.text(label: const Text('关闭面板'), onPressed: close),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('请选择'));
    await tester.pumpAndSettle();
    expect(find.text('关闭面板'), findsOneWidget);
    await tester.tap(find.text('关闭面板'));
    await tester.pumpAndSettle();
    expect(find.text('关闭面板'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
