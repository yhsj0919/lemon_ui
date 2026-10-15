import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final variant in HyperSliderVariant.values) {
    testWidgets('${variant.name} 播放器外部更新不能覆盖拖动值', (tester) async {
      double playback = .2;
      double? submitted;
      late StateSetter refresh;
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            duration: Duration.zero,
            child: Scaffold(
              body: Center(
                child: SizedBox(
                  width: 400,
                  child: StatefulBuilder(
                    builder: (context, update) {
                      refresh = update;
                      return HyperSlider(
                        value: playback,
                        variant: variant,
                        onChanged: (_) {},
                        onChangeEnd: (value) {
                          submitted = value;
                          update(() => playback = value);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      final rect = tester.getRect(find.byType(Slider));
      final gesture = await tester.startGesture(rect.center);
      await gesture.moveBy(const Offset(50, 0));
      await tester.pump();
      final dragged = tester.widget<Slider>(find.byType(Slider)).value;
      expect(dragged, greaterThan(.5));
      for (final tick in [.21, .22, .23]) {
        refresh(() => playback = tick);
        await tester.pump(const Duration(milliseconds: 100));
        expect(tester.widget<Slider>(find.byType(Slider)).value, dragged);
      }
      await gesture.moveBy(const Offset(25, 0));
      await tester.pump();
      final finalValue = tester.widget<Slider>(find.byType(Slider)).value;
      expect(finalValue, greaterThan(dragged));
      await gesture.up();
      await tester.pump();
      expect(submitted, finalValue);
      expect(tester.widget<Slider>(find.byType(Slider)).value, finalValue);
      refresh(() => playback = .9);
      await tester.pump();
      expect(tester.widget<Slider>(find.byType(Slider)).value, .9);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('胶囊滑块拖动预览无需业务即时回写，提交最后拖动位置', (tester) async {
    double playback = .2;
    double? submitted;
    late StateSetter refresh;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: Scaffold(
            body: Center(
              child: StatefulBuilder(
                builder: (context, update) {
                  refresh = update;
                  return HyperCapsuleSlider(
                    height: 200,
                    value: playback,
                    onChanged: (_) {},
                    semanticFormatterCallback: (value) =>
                        value.toStringAsFixed(2),
                    onChangeEnd: (value) {
                      submitted = value;
                      update(() => playback = value);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
    final rect = tester.getRect(find.byType(HyperCapsuleSlider));
    final gesture = await tester.startGesture(rect.center);
    await gesture.moveBy(const Offset(0, -25));
    await tester.pump();
    await gesture.moveBy(const Offset(0, -40));
    await tester.pump();
    String value() => tester
        .widgetList<Semantics>(
          find.descendant(
            of: find.byType(HyperCapsuleSlider),
            matching: find.byType(Semantics),
          ),
        )
        .firstWhere((w) => w.properties.slider == true)
        .properties
        .value!;
    final dragged = value();
    expect(double.parse(dragged), greaterThan(.2));
    refresh(() => playback = .21);
    await tester.pump();
    expect(value(), dragged);
    await gesture.up();
    await tester.pump();
    expect(submitted, closeTo(double.parse(dragged), .01));
    expect(tester.takeException(), isNull);
  });
  testWidgets('范围拖动不被外部回写抢占，并提交本地最终范围', (tester) async {
    var external = const RangeValues(.2, .8);
    RangeValues? submitted;
    late StateSetter refresh;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: Scaffold(
            body: Center(
              child: SizedBox(
                width: 400,
                child: StatefulBuilder(
                  builder: (context, update) {
                    refresh = update;
                    return HyperRangeSlider(
                      values: external,
                      onChanged: (_) {},
                      onChangeEnd: (values) {
                        submitted = values;
                        update(() => external = values);
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final rect = tester.getRect(find.byType(RangeSlider));
    final gesture = await tester.startGesture(
      Offset(rect.left + rect.width * .25, rect.center.dy),
    );
    await gesture.moveBy(const Offset(35, 0));
    await tester.pump();
    final dragged = tester.widget<RangeSlider>(find.byType(RangeSlider)).values;
    expect(dragged.start, greaterThan(.2));
    refresh(() => external = const RangeValues(.21, .81));
    await tester.pump();
    expect(
      tester.widget<RangeSlider>(find.byType(RangeSlider)).values,
      dragged,
    );
    await gesture.moveBy(const Offset(20, 0));
    await tester.pump();
    final finalValues = tester
        .widget<RangeSlider>(find.byType(RangeSlider))
        .values;
    await gesture.up();
    await tester.pump();
    expect(submitted, finalValues);
    expect(
      tester.widget<RangeSlider>(find.byType(RangeSlider)).values,
      finalValues,
    );
    expect(tester.takeException(), isNull);
  });
}
