import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  Widget app(Widget child) => MaterialApp(
    home: HyperTheme(
      data: HyperThemeData.light(),
      duration: Duration.zero,
      child: Center(child: child),
    ),
  );

  testWidgets('玻璃背景与前景内容使用独立合成层', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperMaterialTheme(
          data: HyperMaterialThemeData(quality: HyperMaterialQuality.advanced),
          child: HyperMaterialSurface(
            width: 180,
            height: 112,
            material: HyperSurfaceMaterial.frostedGlass(
              background: HyperFill.color(Color(0x70FFFFFF)),
              tint: Color(0x12FFFFFF),
            ),
            child: Text('清晰内容'),
          ),
        ),
      ),
    );

    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(
      find.ancestor(
        of: find.text('清晰内容'),
        matching: find.byType(BackdropFilter),
      ),
      findsNothing,
    );
    expect(
      tester.getSize(find.byType(HyperMaterialSurface)),
      const Size(180, 112),
    );
  });

  testWidgets('普通材质不建立背景滤镜', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperMaterialSurface(
          material: HyperSurfaceMaterial.solid(
            background: HyperFill.color(Colors.white),
          ),
          child: Text('普通内容'),
        ),
      ),
    );

    expect(find.byType(BackdropFilter), findsNothing);
    expect(find.text('普通内容'), findsOneWidget);
  });
}
