import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/slider/hyper_slider_thumb_shapes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/src/components/slider/hyper_slider_track_shapes.dart';

void main() {
  testWidgets('嵌套缩放预览中的提示锚点不重复转换', (tester) async {
    final preview = MaterialApp(
      home: HyperTheme(
        data: HyperThemeData.light(),
        duration: Duration.zero,
        child: Scaffold(
          body: Center(
            child: SizedBox(
              width: 400,
              child: HyperSlider(
                value: .5,
                label: '50%',
                onChanged: (_) {},
                style: const HyperSliderStyle(
                  showValueIndicator: ShowValueIndicator.alwaysVisible,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 100, top: 60),
              child: SizedBox(
                width: 400,
                height: 300,
                child: FittedBox(
                  child: SizedBox(width: 800, height: 600, child: preview),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final slider = tester.getRect(find.byType(Slider));
    final card = tester.getRect(find.byType(HyperCard));
    expect(card.center.dx, closeTo(slider.center.dx, 1));
    expect(card.bottom, lessThan(slider.center.dy));
    expect(slider.center.dy - card.bottom, lessThan(30));
    expect(tester.takeException(), isNull);
  });
  testWidgets('提示锚定偏移容器内的滑块并默认主题色', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.only(left: 140, top: 180),
              child: SizedBox(
                width: 320,
                child: HyperSlider(
                  value: .5,
                  label: '50%',
                  onChanged: (_) {},
                  style: const HyperSliderStyle(
                    showValueIndicator: ShowValueIndicator.alwaysVisible,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final slider = tester.getRect(find.byType(Slider));
    final card = tester.getRect(find.byType(HyperCard));
    expect(card.center.dx, closeTo(slider.center.dx, 1));
    expect(card.bottom, lessThan(slider.center.dy));
    expect(slider.center.dy - card.bottom, lessThan(40));
    expect(
      tester.widget<HyperCard>(find.byType(HyperCard)).style!.background!.color,
      HyperThemeData.light().colors.primary,
    );
  });
  testWidgets('常显提示使用公共材质表面并尊重实例内边距圆角与空阴影', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: Scaffold(
            body: Center(
              child: HyperSlider(
                value: .5,
                label: '50%',
                onChanged: (_) {},
                style: HyperSliderStyle(
                  showValueIndicator: ShowValueIndicator.alwaysVisible,
                  valueIndicatorSurface: HyperCardStyle(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: const [],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final card = tester.widget<HyperCard>(find.byType(HyperCard));
    expect(
      card.style!.padding,
      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    );
    expect(card.style!.borderRadius, BorderRadius.circular(4));
    expect(card.style!.boxShadow, isEmpty);
    expect(
      card.style!.background!.color,
      HyperThemeData.light().colors.primary,
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets('数值提示默认关闭并允许主题覆盖', (tester) async {
    for (final mode in [
      null,
      ShowValueIndicator.alwaysVisible,
      ShowValueIndicator.never,
    ]) {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HyperSlider(
              value: .5,
              label: '50%',
              onChanged: (_) {},
              style: HyperSliderStyle(showValueIndicator: mode),
            ),
          ),
        ),
      );
      expect(
        SliderTheme.of(tester.element(find.byType(Slider))).showValueIndicator,
        mode ?? ShowValueIndicator.never,
      );
    }
  });
  testWidgets('长滑块宽高与多层阴影同步到单值和范围绘制', (tester) async {
    final shadows = [
      const BoxShadow(
        color: Colors.black26,
        blurRadius: 4,
        offset: Offset(0, 2),
      ),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              HyperSlider(
                value: .5,
                onChanged: (_) {},
                style: HyperSliderStyle(
                  thumbWidth: 40,
                  thumbHeight: 16,
                  thumbShadows: shadows,
                ),
              ),
              HyperRangeSlider(
                values: const RangeValues(.2, .8),
                onChanged: (_) {},
                style: HyperSliderStyle(
                  thumbWidth: 40,
                  thumbHeight: 16,
                  thumbShadows: shadows,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    final single =
        SliderTheme.of(tester.element(find.byType(Slider))).thumbShape!
            as HyperSliderThumbShape;
    final range =
        SliderTheme.of(tester.element(find.byType(RangeSlider)))
                .rangeThumbShape!
            as HyperRangeSliderThumbShape;
    expect(single.getPreferredSize(true, false), const Size(40, 16));
    expect(range.getPreferredSize(true, false), const Size(40, 16));
    expect(single.shadows, shadows);
    expect(range.shadows, shadows);
    expect(tester.takeException(), isNull);
  });
  testWidgets('范围轨道与单值轨道边界一致，不随滑块半径缩短', (tester) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: SizedBox(key: Key('box'), width: 300, height: 64)),
      ),
    );
    final box = tester.renderObject<RenderBox>(find.byKey(const Key('box')));
    for (final radius in [0.0, 8.0, 24.0, 32.0]) {
      for (final enabled in [false, true]) {
        final theme = SliderThemeData(
          trackHeight: 4,
          padding: EdgeInsets.zero,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: radius),
          rangeThumbShape: RoundRangeSliderThumbShape(
            enabledThumbRadius: radius,
          ),
          overlayShape: RoundSliderOverlayShape(overlayRadius: radius * 1.5),
        );
        final single = const HyperSliderTrackShape().getPreferredRect(
          parentBox: box,
          sliderTheme: theme,
          isEnabled: enabled,
        );
        final range = const HyperRangeSliderTrackShape().getPreferredRect(
          parentBox: box,
          sliderTheme: theme,
          isEnabled: enabled,
        );
        expect(range, single);
        expect(range.left, 0);
        expect(range.width, 300);
      }
    }
  });
}
