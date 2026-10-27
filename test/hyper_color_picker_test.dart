import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('选色器明度关闭数值提示，不透明度仅拖动显示，不继承全局常显', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light().copyWith(
            sliderTheme: const HyperSliderThemeData(
              style: HyperSliderStyle(
                showValueIndicator: ShowValueIndicator.alwaysVisible,
              ),
            ),
          ),
          duration: Duration.zero,
          child: Scaffold(
            body: HyperColorPicker(value: Colors.blue, onChanged: (_) {}),
          ),
        ),
      ),
    );
    for (final element in find.byType(Slider).evaluate()) {
      expect(
        SliderTheme.of(element).showValueIndicator,
        (element.widget as Slider).label == '明度'
            ? ShowValueIndicator.never
            : ShowValueIndicator.onDrag,
      );
    }
    expect(find.byType(Slider), findsWidgets);
    expect(tester.takeException(), isNull);
  });
  testWidgets('推荐色默认隐藏，传入后遵守透明度开关', (tester) async {
    Color? selected;
    for (final showAlpha in [true, false]) {
      Widget build(List<Color> colors) => MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: HyperColorPicker(
              value: Colors.blue,
              showAlpha: showAlpha,
              recommendedColors: colors,
              onChanged: (v) => selected = v,
            ),
          ),
        ),
      );
      await tester.pumpWidget(build(const []));
      expect(find.byType(HyperIconButton), findsNothing);
      await tester.pumpWidget(build(const [Color(0x803482FF)]));
      expect(find.byType(HyperIconButton), findsOneWidget);
      await tester.tap(find.byType(HyperIconButton));
      await tester.pump();
      expect(selected!.toARGB32(), showAlpha ? 0x803482FF : 0xFF3482FF);
    }
  });
  testWidgets('满明度色盘中间饱和度不会混入黑色', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: const Scaffold(
            body: HyperColorPicker(value: Color(0xFFFF0000)),
          ),
        ),
      ),
    );
    final paint = tester.widget<CustomPaint>(
      find.byKey(const ValueKey('hyper-color-picker-palette')),
    );
    final recorder = ui.PictureRecorder();
    paint.painter!.paint(Canvas(recorder), const Size(200, 200));
    final picture = recorder.endRecording();
    final bytes = await tester.runAsync(() async {
      final image = await picture.toImage(200, 200);
      final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      image.dispose();
      return data!;
    });
    picture.dispose();
    final index = (50 * 200 + 100) * 4;
    expect(bytes!.getUint8(index), greaterThanOrEqualTo(250));
    expect(bytes.getUint8(index + 1), inInclusiveRange(120, 140));
    expect(bytes.getUint8(index + 2), inInclusiveRange(120, 140));
  });
  test('HEX 严格解析 RGB 与 ARGB', () {
    expect(HyperColorPicker.parseHex('#3482ff'), const Color(0xFF3482FF));
    expect(HyperColorPicker.parseHex('803482ff'), const Color(0x803482FF));
    for (final input in ['#123', 'fffffffff', 'zzzzzz', '0x123456']) {
      expect(HyperColorPicker.parseHex(input), isNull);
    }
  });

  for (final device in HyperDeviceType.values) {
    testWidgets('$device 颜色区域、透明度和 HEX 受控更新', (tester) async {
      await tester.binding.setSurfaceSize(const Size(350, 1000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      var color = const Color(0xFF3482FF);
      await tester.pumpWidget(
        MaterialApp(
          home: HyperDeviceDetector(
            deviceType: device,
            builder: (context, device, child) => HyperTheme(
              data: HyperThemeData.light(),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: StatefulBuilder(
                    builder: (context, update) => HyperColorPicker(
                      value: color,
                      recommendedColors: const [Colors.black, Colors.white],
                      onChanged: (value) => update(() => color = value),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final palette = find.byKey(const ValueKey('hyper-color-picker-palette'));
      final rect = tester.getRect(palette);
      final brightnessRect = tester.getRect(find.byType(HyperVerticalSlider));
      expect(brightnessRect.left, greaterThanOrEqualTo(rect.right));
      expect(brightnessRect.height, closeTo(rect.height, .01));
      final alphaRect = tester.getRect(find.byType(HyperSlider).last);
      expect(alphaRect.top, greaterThanOrEqualTo(rect.bottom));
      await tester.tapAt(
        rect.topLeft + Offset(rect.width * .75, rect.height * .5),
      );
      await tester.pumpAndSettle();
      final hsv = HSVColor.fromColor(color);
      expect(hsv.saturation, closeTo(.5, .02));
      expect(hsv.value, closeTo(1, .02));
      await tester.tapAt(rect.center + Offset(rect.width * .04, 0));
      await tester.pumpAndSettle();
      expect(color, const Color(0xFFFFFFFF));
      // 接近红色色相且落在边缘纯色区时，选到精确红色。
      await tester.tapAt(
        rect.center + Offset(rect.width * .005, -rect.height * .46),
      );
      await tester.pumpAndSettle();
      expect(color, const Color(0xFFFF0000));
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is HyperIconButton && w.tooltip == '#FF000000',
        ),
      );
      await tester.pumpAndSettle();
      expect(color, const Color(0xFF000000));
      await tester.tap(
        find.byWidgetPredicate(
          (w) => w is HyperIconButton && w.tooltip == '#FFFFFFFF',
        ),
      );
      await tester.pumpAndSettle();
      expect(color, const Color(0xFFFFFFFF));
      final brightness = tester
          .widgetList<HyperSlider>(find.byType(HyperSlider))
          .first;
      brightness.onChanged!(0);
      await tester.pumpAndSettle();
      expect(HSVColor.fromColor(color).value, 0);
      tester.widgetList<HyperSlider>(find.byType(HyperSlider)).first.onChanged!(
        1,
      );
      await tester.pumpAndSettle();
      expect(HSVColor.fromColor(color).value, 1);
      expect(
        tester.widgetList<HyperSlider>(find.byType(HyperSlider)).first.value,
        1,
      );
      tester.widgetList<HyperSlider>(find.byType(HyperSlider)).last.onChanged!(
        .3,
      );
      await tester.pumpAndSettle();
      expect(color.a, closeTo(.3, .01));
      await tester.enterText(find.byType(EditableText), '#80FF0000');
      await tester.pumpAndSettle();
      expect(color, const Color(0x80FF0000));
      expect(tester.takeException(), isNull);
    });
  }
  test('颜色选择器主题与四端尺寸支持覆盖、插值和值相等', () {
    final theme = HyperThemeData.light();
    final changed = theme.copyWith(
      colorPickerTheme: HyperColorPickerThemeData(
        style: const HyperColorPickerStyle(
          markerColor: Colors.red,
          spacing: 10,
        ),
      ),
    );
    expect(changed, isNot(theme));
    expect(theme.lerp(changed, 1), changed);
    final size = theme.sizes.desktop.colorPicker;
    expect(
      HyperColorPickerSize.lerp(
        size,
        size.copyWith(width: size.width + 20),
        .5,
      ).width,
      size.width + 10,
    );
    expect(
      const HyperColorPickerStyle(markerColor: Colors.red)
          .merge(const HyperColorPickerStyle(spacing: 10)),
      changed.colorPickerTheme.style,
    );
  });
}
