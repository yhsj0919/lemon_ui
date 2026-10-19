import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget host(Widget child, {double scale = 1, double width = 192}) =>
    MaterialApp(
      home: HyperDeviceDetector(
        deviceType: HyperDeviceType.desktop,
        builder: (context, device, unused) => HyperTheme(
          data: HyperThemeData.light(),
          child: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(scale)),
            child: Scaffold(
              body: SizedBox(width: width, child: child),
            ),
          ),
        ),
      ),
    );
HyperWheelPicker<int> wheel({
  int value = 3,
  ValueChanged<int>? changed,
  ValueChanged<int>? ended,
  bool looping = false,
  bool enabled = true,
  int count = 10,
  bool autofocus = false,
}) => HyperWheelPicker<int>(
  items: List.generate(count, (i) => i),
  value: value,
  labelBuilder: (v) => '$v',
  onChanged: changed,
  onChangeEnd: ended,
  looping: looping,
  enabled: enabled,
  autofocus: autofocus,
);

void main() {
  testWidgets('drag snaps and notifies once at scroll end', (tester) async {
    final values = <int>[], ends = <int>[];
    await tester.pumpWidget(host(wheel(changed: values.add, ended: ends.add)));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListWheelScrollView), const Offset(0, -90));
    await tester.pumpAndSettle();
    expect(values, isNotEmpty);
    expect(values.last, greaterThan(3));
    expect(ends, [values.last]);
    final view = tester.widget<ListWheelScrollView>(
      find.byType(ListWheelScrollView),
    );
    expect(
      (view.controller! as FixedExtentScrollController).offset -
          (view.controller! as FixedExtentScrollController).selectedItem *
              view.itemExtent,
      closeTo(0, 1),
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets('tap a neighbour selects it', (tester) async {
    int? value;
    await tester.pumpWidget(host(wheel(changed: (v) => value = v)));
    await tester.pumpAndSettle();
    await tester.tap(find.text('4'));
    await tester.pumpAndSettle();
    expect(value, 4);
    expect(tester.takeException(), isNull);
  });
  testWidgets('keyboard and looping wrap around boundaries', (tester) async {
    int? value;
    await tester.pumpWidget(
      host(
        wheel(
          value: 0,
          count: 3,
          looping: true,
          autofocus: true,
          changed: (v) => value = v,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pumpAndSettle();
    expect(value, 2);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(value, 0);
  });
  testWidgets('mouse wheel scrolls and snaps', (tester) async {
    int? value;
    await tester.pumpWidget(host(wheel(changed: (v) => value = v)));
    await tester.pumpAndSettle();
    final controller =
        tester
                .widget<ListWheelScrollView>(find.byType(ListWheelScrollView))
                .controller!
            as FixedExtentScrollController;
    final before = controller.offset;
    tester.binding.handlePointerEvent(
      PointerScrollEvent(
        position: tester.getCenter(find.byType(ListWheelScrollView)),
        scrollDelta: const Offset(0, 88),
      ),
    );
    expect(
      controller.offset,
      before,
      reason: 'wheel input must not jump pixels before animation',
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 40));
    expect(controller.offset, greaterThan(before));
    final intermediate = controller.offset;
    tester.binding.handlePointerEvent(
      PointerScrollEvent(
        position: tester.getCenter(find.byType(ListWheelScrollView)),
        scrollDelta: const Offset(0, 32),
      ),
    );
    expect(
      controller.offset,
      intermediate,
      reason: 'consecutive ticks retarget without jumping',
    );
    await tester.pumpAndSettle();
    expect(value, 5);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'mouse signals each move exactly one item regardless of pixel delta',
    (tester) async {
      await tester.pumpWidget(host(wheel(changed: (_) {})));
      await tester.pumpAndSettle();
      final controller =
          tester
                  .widget<ListWheelScrollView>(find.byType(ListWheelScrollView))
                  .controller!
              as FixedExtentScrollController;
      for (final delta in [48.0, 48.0, 120.0, -32.0, -88.0]) {
        final before = controller.selectedItem;
        tester.binding.handlePointerEvent(
          PointerScrollEvent(
            position: tester.getCenter(find.byType(ListWheelScrollView)),
            scrollDelta: Offset(0, delta),
          ),
        );
        await tester.pumpAndSettle();
        expect(controller.selectedItem, before + delta.sign.toInt());
      }
    },
  );
  testWidgets(
    'external value, shrunken list and empty list synchronize without callbacks',
    (tester) async {
      final values = <int>[];
      await tester.pumpWidget(host(wheel(changed: values.add)));
      await tester.pumpAndSettle();
      await tester.pumpWidget(host(wheel(value: 8, changed: values.add)));
      await tester.pumpAndSettle();
      var controller =
          tester
                  .widget<ListWheelScrollView>(find.byType(ListWheelScrollView))
                  .controller!
              as FixedExtentScrollController;
      expect(controller.selectedItem, 8);
      expect(values, isEmpty);
      await tester.pumpWidget(
        host(wheel(value: 1, count: 2, changed: values.add)),
      );
      await tester.pumpAndSettle();
      expect(controller.selectedItem, 1);
      await tester.pumpWidget(host(wheel(count: 0, changed: values.add)));
      await tester.pumpAndSettle();
      expect(values, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('disabled ignores input', (tester) async {
    final values = <int>[];
    await tester.pumpWidget(host(wheel(enabled: false, changed: values.add)));
    await tester.pumpAndSettle();
    await tester.dragFrom(
      tester.getCenter(find.byType(HyperWheelPicker<int>)),
      const Offset(0, -90),
    );
    await tester.pumpAndSettle();
    expect(values, isEmpty);
  });
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('long text grows equal rows at scale $scale', (tester) async {
      await tester.pumpWidget(
        host(
          HyperWheelPicker<String>(
            items: const ['较长的选项文字会换行显示', '短文字'],
            value: '短文字',
            labelBuilder: (v) => v,
            onChanged: (_) {},
          ),
          width: 100,
          scale: scale,
        ),
      );
      await tester.pumpAndSettle();
      final view = tester.widget<ListWheelScrollView>(
        find.byType(ListWheelScrollView),
      );
      final text = tester.getSize(find.text('较长的选项文字会换行显示'));
      expect(view.itemExtent, greaterThanOrEqualTo(text.height));
      expect(tester.takeException(), isNull);
    });
  }
  testWidgets(
    'changing width and scale preserves selection without notification',
    (tester) async {
      final values = <String>[];
      Widget build(double scale, double width) => host(
        HyperWheelPicker<String>(
          items: const ['很长的一个选项', '另一个选项', '第三个选项'],
          value: '第三个选项',
          labelBuilder: (v) => v,
          onChanged: values.add,
        ),
        scale: scale,
        width: width,
      );
      await tester.pumpWidget(build(1, 192));
      await tester.pumpAndSettle();
      await tester.pumpWidget(build(2, 90));
      await tester.pumpAndSettle();
      final view = tester.widget<ListWheelScrollView>(
        find.byType(ListWheelScrollView),
      );
      final controller = view.controller! as FixedExtentScrollController;
      expect(controller.selectedItem, 2);
      expect(controller.offset, 2 * view.itemExtent);
      expect(values, isEmpty);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('local and instance themes merge over global sizes', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        HyperWheelPickerTheme(
          data: const HyperWheelPickerThemeData(
            style: HyperWheelPickerStyle(
              itemExtent: 60,
              foregroundColor: Colors.red,
            ),
          ),
          child: HyperWheelPicker<int>(
            items: const [0, 1, 2],
            value: 1,
            labelBuilder: (v) => '$v',
            onChanged: (_) {},
            style: const HyperWheelPickerStyle(
              itemExtent: 70,
              selectedForegroundColor: Colors.blue,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<ListWheelScrollView>(find.byType(ListWheelScrollView))
          .itemExtent,
      70,
    );
    final textStyle = tester.widget<AnimatedDefaultTextStyle>(
      find
          .ancestor(
            of: find.text('1'),
            matching: find.byType(AnimatedDefaultTextStyle),
          )
          .first,
    );
    expect(textStyle.style.color, Colors.blue);
    expect(tester.takeException(), isNull);
  });

  test('theme size and visual copy merge interpolate and compare', () {
    final theme = HyperThemeData.light();
    const a = HyperWheelPickerStyle(
      selectionColor: Colors.red,
      textStyle: TextStyle(fontSize: 16),
    );
    final b = a.copyWith(selectionColor: Colors.blue, itemExtent: 60);
    final configured = theme.copyWith(
      wheelPickerTheme: HyperWheelPickerThemeData(style: b),
    );
    expect(configured.wheelPickerTheme.style.textStyle!.fontSize, 16);
    expect(
      HyperWheelPickerStyle.lerp(a, b, .5).selectionColor,
      Color.lerp(Colors.red, Colors.blue, .5),
    );
    expect(
      configured,
      theme.copyWith(wheelPickerTheme: HyperWheelPickerThemeData(style: b)),
    );
    expect(
      theme.lerp(configured, 1).wheelPickerTheme,
      configured.wheelPickerTheme,
    );
    final sizes = theme.sizes.desktop;
    final changed = sizes.copyWith(
      wheelPicker: sizes.wheelPicker.copyWith(itemExtent: 70),
    );
    expect(
      HyperSizeScheme.lerp(sizes, changed, .5).wheelPicker.itemExtent,
      (sizes.wheelPicker.itemExtent + 70) / 2,
    );
    expect(
      changed,
      sizes.copyWith(wheelPicker: sizes.wheelPicker.copyWith(itemExtent: 70)),
    );
  });
}
