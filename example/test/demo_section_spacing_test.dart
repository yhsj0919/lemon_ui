import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/gallery/demo_section.dart';

void main() {
  testWidgets('示例标题到内容只保留标题底部间距，文字缩放不叠加内容顶部内边距', (tester) async {
    for (final scale in [1.0, 1.3, 2.0]) {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperDeviceDetector(
            deviceType: HyperDeviceType.desktop,
            builder: (context, device, child) => HyperTheme(
              data: HyperThemeData.light(),
              child: MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                child: const Center(
                  child: SizedBox(
                    width: 320,
                    child: DemoSection(
                      title: '进入下一级',
                      child: SizedBox(
                        key: ValueKey('content'),
                        width: double.infinity,
                        height: 48,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final title = tester.getRect(find.text('进入下一级'));
      final content = tester.getRect(find.byKey(const ValueKey('content')));
      expect(content.top - title.bottom, 20);
      expect(content.left, title.left);
      expect(tester.takeException(), isNull);
    }
  });
}
