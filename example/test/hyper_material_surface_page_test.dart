import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/surface/hyper_material_surface_page.dart';

void main() {
  testWidgets('材质演示可以切换质量和减少透明度', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperMaterialSurfacePage(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(BackdropFilter), findsNWidgets(2));
    expect(find.byKey(const ValueKey('material-柔光玻璃')), findsOneWidget);

    await tester.tap(find.text('普通质量'));
    await tester.pumpAndSettle();
    expect(find.byType(BackdropFilter), findsNothing);
    expect(find.textContaining('普通质量 · 正常透明度'), findsOneWidget);

    await tester.tap(find.byType(HyperSwitch));
    await tester.pumpAndSettle();
    expect(find.textContaining('普通质量 · 已降级'), findsOneWidget);
  });
}
