import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/foundation/hyper_color_scheme_page.dart';

void main() {
  testWidgets('颜色方案色卡在 2 倍文字下容纳名称和 HEX', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: HyperTheme(
            data: HyperThemeData.light(),
            duration: Duration.zero,
            child: const Scaffold(body: HyperColorSchemePage()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, -550));
    await tester.pumpAndSettle();
    expect(find.text('primaryContainer'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
