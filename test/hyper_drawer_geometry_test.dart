import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  const margin = EdgeInsets.fromLTRB(12, 20, 30, 40);
  const corners = BorderRadius.only(
    topLeft: Radius.circular(5),
    topRight: Radius.circular(15),
    bottomRight: Radius.circular(25),
    bottomLeft: Radius.circular(35),
  );
  test('尺寸与样式的边距、四角按值继承和插值', () {
    const base = HyperDrawerSize(width: 200, radius: 16);
    final changed = base.copyWith(margin: margin, borderRadius: corners);
    expect(changed.copyWith(), changed);
    expect(changed.copyWith(borderRadius: null).borderRadius, isNull);
    expect(HyperDrawerSize.lerp(base, changed, 1), changed);
    expect(
      HyperDrawerSize.lerp(base, changed, .5).margin,
      const EdgeInsets.fromLTRB(6, 10, 15, 20),
    );
    final style = HyperDrawerStyle(
      margin: margin,
      surfaceStyle: HyperCardStyle(borderRadius: corners),
    );
    expect(const HyperDrawerStyle().merge(style), style);
    expect(style.copyWith().hashCode, style.hashCode);
    expect(style.copyWith(margin: null).margin, isNull);
    expect(
      style,
      isNot(
        HyperDrawerStyle(
          margin: margin,
          surfaceStyle: HyperCardStyle(borderRadius: BorderRadius.zero),
        ),
      ),
    );
    expect(HyperDrawerStyle.lerp(style, style, .5), style);
  });

  for (final direction in TextDirection.values) {
    for (final end in [false, true]) {
      testWidgets('四边留白、四角及遮罩关闭：$direction end=$end', (tester) async {
        await tester.binding.setSurfaceSize(const Size(400, 700));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final drawer = HyperDrawer(
          style: HyperDrawerStyle(
            width: 200,
            margin: margin,
            surfaceStyle: HyperCardStyle(borderRadius: corners),
          ),
          child: const SizedBox.expand(),
        );
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData(platform: TargetPlatform.windows),
            home: HyperTheme(
              data: HyperThemeData.light(),
              duration: Duration.zero,
              child: Directionality(
                textDirection: direction,
                child: HyperScaffold(
                  drawer: end ? null : drawer,
                  endDrawer: end ? drawer : null,
                  body: Builder(
                    builder: (context) => TextButton(
                      onPressed: () => end
                          ? HyperScaffold.openEndDrawer(context)
                          : HyperScaffold.openDrawer(context),
                      child: const Text('打开'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.tap(find.text('打开'));
        await tester.pumpAndSettle();
        final rect = tester.getRect(find.byType(Drawer));
        final left =
            (!end && direction == TextDirection.ltr) ||
            (end && direction == TextDirection.rtl);
        expect(rect.left, closeTo(left ? 12 : 170, .01));
        expect(rect.top, 20);
        expect(rect.width, 200);
        expect(rect.height, 640);
        expect(
          (tester.widget<Drawer>(find.byType(Drawer)).shape!
                  as RoundedRectangleBorder)
              .borderRadius,
          corners,
        );
        await tester.tapAt(const Offset(5, 10));
        await tester.pumpAndSettle();
        final scaffold = tester.state<ScaffoldState>(find.byType(Scaffold));
        expect(end ? scaffold.isEndDrawerOpen : scaffold.isDrawerOpen, isFalse);
      });
    }
  }

  testWidgets('四端规格、局部和实例覆盖在普通及高级材质中保留四角', (tester) async {
    for (final quality in HyperMaterialQuality.values) {
      final base = HyperThemeData.light();
      final theme = base.copyWith(
        sizes: base.sizes.copyWith(
          desktop: base.sizes.desktop.copyWith(
            drawer: base.sizes.desktop.drawer.copyWith(
              margin: const EdgeInsets.all(4),
              borderRadius: BorderRadius.circular(7),
            ),
          ),
        ),
        materialTheme: base.materialTheme.copyWith(
          quality: quality,
          material: const HyperSurfaceMaterial.frostedGlass(),
        ),
      );
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: theme,
            duration: Duration.zero,
            child: HyperDeviceDetector(
              deviceType: HyperDeviceType.desktop,
              builder: (context, device, _) => HyperDrawerTheme(
                data: const HyperDrawerThemeData(
                  style: HyperDrawerStyle(margin: EdgeInsets.all(8)),
                ),
                child: SizedBox(
                  width: 300,
                  height: 500,
                  child: HyperDrawer(
                    style: HyperDrawerStyle(
                      margin: margin,
                      surfaceStyle: HyperCardStyle(
                        borderRadius: corners,
                        boxShadow: const [],
                      ),
                    ),
                    child: const Text('内容'),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        (tester.widget<Drawer>(find.byType(Drawer)).shape!
                as RoundedRectangleBorder)
            .borderRadius,
        corners,
      );
      expect(tester.getTopLeft(find.byType(Drawer)), const Offset(12, 20));
      expect(tester.takeException(), isNull);
    }
  });
}
