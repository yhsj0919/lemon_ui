import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui_example/pages/foundation/hyper_device_detector_page.dart';

void main() {
  testWidgets('设备探测演示可显式切换主题方案', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HyperDeviceDetectorPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('device-override')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('手表').last);
    await tester.pumpAndSettle();

    expect(find.text('当前：手表'), findsOneWidget);
    expect(find.text('默认高度：48'), findsOneWidget);
    expect(find.text('控件圆角：20'), findsOneWidget);
  });
}
