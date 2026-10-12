import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final device in [
    HyperDeviceType.phone,
    HyperDeviceType.tablet,
    HyperDeviceType.watch,
  ]) {
    testWidgets('$device 默认模态选色，取消不提交，确认提交', (tester) async {
      var changes = 0;
      await tester.pumpWidget(
        MaterialApp(
          home: HyperDeviceDetector(
            deviceType: device,
            builder: (context, _, _) => HyperTheme(
              data: HyperThemeData.light(),
              duration: Duration.zero,
              child: Scaffold(
                body: HyperColorPickerField(
                  value: Colors.blue,
                  onChanged: (_) => changes++,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.byType(HyperButton).first);
      await tester.pumpAndSettle();
      expect(find.byType(HyperColorPicker), findsOneWidget);
      expect(
        find.byType(HyperBottomSheet),
        device == HyperDeviceType.watch ? findsNothing : findsOneWidget,
      );
      expect(changes, 0);
      await tester.ensureVisible(find.text('取消'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('取消'));
      await tester.pumpAndSettle();
      expect(changes, 0);
      await tester.tap(find.byType(HyperButton).first);
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('确定'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('确定'));
      await tester.pumpAndSettle();
      expect(changes, 1);
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets('选色浮层继承 Menu 材质与阴影，实例覆盖优先', (tester) async {
    const shadows = [BoxShadow(color: Color(0xFFFF0000), blurRadius: 16)];
    final material = HyperSurfaceMaterial.solid(
      background: HyperFill.color(const Color(0xFFCCFFCC)),
    );
    final theme = HyperThemeData.light().copyWith(
      menuTheme: HyperMenuThemeData(
        style: HyperMenuStyle(
          surfaceStyle: HyperCardStyle(material: material, boxShadow: shadows),
        ),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: theme,
          child: Scaffold(
            body: HyperColorPickerField(
              presentation: HyperSelectPresentation.anchored,
              value: const Color(0xFF3482FF),
              onChanged: (_) {},
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(HyperButton));
    await tester.pumpAndSettle();
    final surface = tester.widget<HyperCard>(find.byType(HyperCard));
    expect(surface.style!.material, material);
    expect(surface.style!.boxShadow, shadows);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: theme,
          child: Scaffold(
            body: HyperColorPickerField(
              presentation: HyperSelectPresentation.anchored,
              value: const Color(0xFF3482FF),
              onChanged: (_) {},
              panelStyle: HyperCardStyle(boxShadow: const []),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester.widget<HyperCard>(find.byType(HyperCard)).style!.boxShadow,
      isEmpty,
    );
  });
  testWidgets('跟随浮层实时选色、跟随字段移动并在外部点击关闭', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var color = const Color(0xFFFF0000);
    var top = 20.0;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return Padding(
                  padding: EdgeInsets.only(top: top, left: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: HyperColorPickerField(
                      presentation: HyperSelectPresentation.anchored,
                      value: color,
                      onChanged: (value) => setState(() => color = value),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(HyperButton));
    await tester.pumpAndSettle();
    expect(find.byType(HyperColorPicker), findsOneWidget);
    final defaultSurface = tester.widget<HyperCard>(find.byType(HyperCard));
    expect(defaultSurface.style!.material, isNotNull);
    expect(defaultSurface.style!.material!.boxShadow, isNotEmpty);
    final before = tester.getRect(find.byType(HyperColorPicker));
    await tester.tap(find.byTooltip('纯白'));
    await tester.pumpAndSettle();
    expect(color, const Color(0xFFFFFFFF));
    expect(
      find.byWidgetPredicate(
        (widget) => widget is Text && widget.data == '#FFFFFFFF',
      ),
      findsOneWidget,
    );
    update(() => top += 40);
    await tester.pumpAndSettle();
    final after = tester.getRect(find.byType(HyperColorPicker));
    expect(after.top - before.top, closeTo(40, .01));
    await tester.tapAt(const Offset(790, 10));
    await tester.pumpAndSettle();
    expect(find.byType(HyperColorPicker), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('禁用字段不会展开取色器', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: const Scaffold(
            body: HyperColorPickerField(
              presentation: HyperSelectPresentation.anchored,
              value: Color(0xFF3482FF),
              onChanged: null,
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(HyperButton));
    await tester.pumpAndSettle();
    expect(find.byType(HyperColorPicker), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
