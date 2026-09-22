import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  Widget app(Widget child, {HyperThemeData? theme}) => MaterialApp(
    home: HyperTheme(
      data:
          theme ??
          HyperThemeData.light(
            sizes: const HyperSizeThemeData(tablet: HyperSizeScheme.desktop()),
          ),
      duration: Duration.zero,
      child: Center(child: child),
    ),
  );

  testWidgets('点击切换值', (tester) async {
    var value = false;
    await tester.pumpWidget(
      app(
        StatefulBuilder(
          builder: (context, setState) {
            return HyperSwitch(
              value: value,
              onChanged: (next) => setState(() => value = next),
            );
          },
        ),
      ),
    );
    await tester.tap(find.byType(HyperSwitch));
    await tester.pumpAndSettle();
    expect(value, isTrue);
  });

  testWidgets('横向拖动切换值', (tester) async {
    var value = false;
    await tester.pumpWidget(
      app(
        StatefulBuilder(
          builder: (context, setState) {
            return HyperSwitch(
              value: value,
              onChanged: (next) => setState(() => value = next),
            );
          },
        ),
      ),
    );
    await tester.drag(find.byType(HyperSwitch), const Offset(60, 0));
    await tester.pumpAndSettle();
    expect(value, isTrue);
  });

  testWidgets('桌面方案使用独立的 44×24 舒适尺寸', (tester) async {
    await tester.pumpWidget(app(HyperSwitch(value: true, onChanged: (_) {})));
    final track = find.byWidgetPredicate(
      (widget) => widget is AnimatedContainer,
    );
    expect(tester.getSize(track), const Size(44, 24));
    final container = tester.widget<AnimatedContainer>(track);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.borderRadius, BorderRadius.circular(12));

    final thumb = tester.widget<Container>(
      find.descendant(
        of: find.byType(AnimatedScale),
        matching: find.byType(Container),
      ),
    );
    expect(thumb.constraints?.maxWidth, 18);
    expect(
      (thumb.decoration! as BoxDecoration).borderRadius,
      BorderRadius.circular(9),
    );
  });

  testWidgets('手机方案使用 HyperOS 胶囊比例且无默认描边', (tester) async {
    await tester.pumpWidget(
      app(
        HyperSwitch(value: true, onChanged: (_) {}),
        theme: HyperThemeData.light(
          sizes: const HyperSizeThemeData(tablet: HyperSizeScheme.phone()),
        ),
      ),
    );
    final track = find.byWidgetPredicate(
      (widget) => widget is AnimatedContainer,
    );
    expect(tester.getSize(track), const Size(48, 28));
    final container = tester.widget<AnimatedContainer>(track);
    final decoration = container.decoration! as BoxDecoration;
    expect(decoration.borderRadius, BorderRadius.circular(14));
    expect(decoration.border, isNull);

    final thumbs = tester
        .widgetList<Container>(find.byType(Container))
        .where((widget) => widget.decoration is BoxDecoration);
    final thumb = thumbs.firstWhere(
      (widget) =>
          (widget.constraints?.maxWidth == 20) &&
          (widget.constraints?.maxHeight == 20),
    );
    final thumbDecoration = thumb.decoration! as BoxDecoration;
    expect(thumbDecoration.borderRadius, BorderRadius.circular(10));
    expect(thumbDecoration.boxShadow, isEmpty);
  });

  testWidgets('悬浮时滑块按 MIUIX 比例放大', (tester) async {
    await tester.pumpWidget(app(HyperSwitch(value: true, onChanged: (_) {})));
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byType(HyperSwitch)));
    await tester.pump();

    expect(
      tester.widget<AnimatedScale>(find.byType(AnimatedScale)).scale,
      1.127,
    );
  });

  testWidgets('实例可以明确覆盖轨道、滑块颜色和圆角', (tester) async {
    const trackColor = Color(0xFF123456);
    const thumbColor = Color(0xFFABCDEF);
    await tester.pumpWidget(
      app(
        HyperSwitch(
          value: true,
          onChanged: (_) {},
          style: HyperSwitchStyle(
            activeTrackColor: trackColor,
            activeThumbColor: thumbColor,
            borderRadius: BorderRadius.all(Radius.circular(8)),
            thumbRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
      ),
    );

    final track = tester.widget<AnimatedContainer>(
      find.byWidgetPredicate((widget) => widget is AnimatedContainer),
    );
    final trackDecoration = track.decoration! as BoxDecoration;
    expect(trackDecoration.color, trackColor);
    expect(trackDecoration.borderRadius, BorderRadius.circular(8));

    final thumb = tester.widget<Container>(
      find.descendant(
        of: find.byType(AnimatedScale),
        matching: find.byType(Container),
      ),
    );
    final thumbDecoration = thumb.decoration! as BoxDecoration;
    expect(thumbDecoration.color, thumbColor);
    expect(thumbDecoration.borderRadius, BorderRadius.circular(6));
  });

  testWidgets('禁用状态不触发回调', (tester) async {
    var called = false;
    await tester.pumpWidget(
      app(const HyperSwitch(value: false, onChanged: null)),
    );
    await tester.tap(find.byType(HyperSwitch));
    expect(called, isFalse);
  });
}
