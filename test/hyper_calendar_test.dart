import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget host(Widget child, {double scale = 1, double width = 280}) =>
    MaterialApp(
      home: HyperTheme(
        data: HyperThemeData.light(),
        child: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(width: width, child: child),
            ),
          ),
        ),
      ),
    );
Finder day(int y, int m, int d) => find.byKey(ValueKey('calendar-$y-$m-$d'));
void main() {
  testWidgets('range fill remains stable during second endpoint animation', (
    tester,
  ) async {
    DateTimeRange? value;
    await tester.pumpWidget(
      host(
        StatefulBuilder(
          builder: (context, setState) => HyperCalendar.range(
            value: value,
            initialMonth: DateTime(2026, 10),
            style: const HyperCalendarStyle(rangeColor: Colors.orange),
            onChanged: (v) => setState(() => value = v),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(day(2026, 10, 9));
    await tester.pumpAndSettle();
    await tester.tap(day(2026, 10, 23));
    for (final elapsed in [
      Duration.zero,
      const Duration(milliseconds: 40),
      const Duration(milliseconds: 200),
    ]) {
      await tester.pump(elapsed);
      final fills = tester.widgetList<DecoratedBox>(
        find.descendant(
          of: day(2026, 10, 15),
          matching: find.byType(DecoratedBox),
        ),
      );
      expect(
        fills.any(
          (box) =>
              box.decoration is BoxDecoration &&
              (box.decoration as BoxDecoration).color == Colors.orange,
        ),
        isTrue,
      );
    }
    expect(value!.start, DateTime(2026, 10, 9));
    expect(value!.end, DateTime(2026, 10, 23));
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'dual month range shares endpoints and wraps on narrow constraints',
    (tester) async {
      DateTimeRange? result;
      Widget calendar(double width) => host(
        HyperCalendar.range(
          value: result,
          initialMonth: DateTime(2026, 10),
          panels: HyperCalendarPanels.doubleMonth,
          style: const HyperCalendarStyle(width: 280),
          onChanged: (v) => result = v,
        ),
        width: width,
      );
      await tester.pumpWidget(calendar(700));
      await tester.pumpAndSettle();
      expect(day(2026, 10, 31), findsOneWidget);
      expect(day(2026, 11, 2), findsOneWidget);
      expect(
        tester.getCenter(day(2026, 11, 2)).dx,
        greaterThan(tester.getCenter(day(2026, 10, 2)).dx),
      );
      await tester.tap(day(2026, 10, 31));
      await tester.pumpAndSettle();
      await tester.tap(day(2026, 11, 2));
      await tester.pumpAndSettle();
      expect(
        result,
        DateTimeRange(
          start: DateTime(2026, 10, 31),
          end: DateTime(2026, 11, 2),
        ),
      );
      await tester.pumpWidget(calendar(200));
      await tester.pumpAndSettle();
      expect(
        tester.getCenter(day(2026, 11, 2)).dy,
        greaterThan(tester.getCenter(day(2026, 10, 2)).dy),
      );
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('dual mode does not display a month past lastDate', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        HyperCalendar.range(
          value: null,
          initialMonth: DateTime(2026, 12),
          lastDate: DateTime(2026, 12, 31),
          panels: HyperCalendarPanels.doubleMonth,
          style: const HyperCalendarStyle(width: 280),
          onChanged: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(day(2026, 12, 1), findsOneWidget);
    expect(day(2027, 1, 1), findsNothing);
  });
  testWidgets('hover layer shares selection bounds and radius', (tester) async {
    await tester.pumpWidget(
      host(
        HyperCalendar(
          value: DateTime(2024, 2, 10),
          initialMonth: DateTime(2024, 2),
          onChanged: (_) {},
          style: const HyperCalendarStyle(selectionSize: 28, radius: 4),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(day(2024, 2, 10)));
    await tester.pumpAndSettle();
    final surface = find.descendant(
      of: day(2024, 2, 10),
      matching: find.byType(AnimatedContainer),
    );
    final container = tester.widget<AnimatedContainer>(surface);
    expect(tester.getSize(surface), const Size(28, 28));
    expect(
      (container.decoration as BoxDecoration).borderRadius,
      (container.foregroundDecoration as BoxDecoration).borderRadius,
    );
    expect(
      (container.foregroundDecoration as BoxDecoration).color!.a,
      greaterThan(0),
    );
    await mouse.removePointer();
  });
  testWidgets('year and month navigation returns to days without selecting', (
    tester,
  ) async {
    DateTime? selected;
    await tester.pumpWidget(
      host(
        HyperCalendar(
          value: null,
          initialMonth: DateTime(2026, 10),
          firstDate: DateTime(2024, 2, 10),
          lastDate: DateTime(2028, 11, 20),
          onChanged: (v) => selected = v,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('calendar-year-heading')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('calendar-year-2024')));
    await tester.pumpAndSettle();
    expect(day(2024, 10, 1), findsOneWidget);
    expect(selected, isNull);
    await tester.tap(find.byKey(const ValueKey('calendar-month-heading')));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<HyperButton>(find.byKey(const ValueKey('calendar-month-1')))
          .onPressed,
      isNull,
    );
    await tester.tap(find.byKey(const ValueKey('calendar-month-2')));
    await tester.pumpAndSettle();
    expect(day(2024, 2, 29), findsOneWidget);
    expect(selected, isNull);
    await tester.tap(day(2024, 2, 29));
    await tester.pumpAndSettle();
    expect(selected, DateTime(2024, 2, 29));
  });
  testWidgets('year grid pages and respects bounds at large text', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        HyperCalendar.range(
          value: null,
          initialMonth: DateTime(2026, 10),
          firstDate: DateTime(2020),
          lastDate: DateTime(2050, 12, 31),
          onChanged: (_) {},
        ),
        width: 200,
        scale: 2,
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('calendar-year-heading')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('calendar-next')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('calendar-year-2040')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets(
    'spacing does not enlarge selection and foreground stays explicit',
    (tester) async {
      for (final spacing in [4.0, 0.0]) {
        await tester.pumpWidget(
          host(
            HyperCalendar(
              value: DateTime(2024, 2, 10),
              initialMonth: DateTime(2024, 2),
              onChanged: (_) {},
              style: HyperCalendarStyle(
                selectionSize: 28,
                spacing: spacing,
                selectedColor: Colors.blue,
                selectedForegroundColor: Colors.white,
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final surface = find.byWidgetPredicate(
          (w) =>
              w is DecoratedBox &&
              w.decoration is BoxDecoration &&
              (w.decoration as BoxDecoration).color == Colors.blue,
        );
        expect(tester.getSize(surface), const Size(28, 28));
        final text = find.descendant(
          of: day(2024, 2, 10),
          matching: find.text('10'),
        );
        expect(tester.widget<Text>(text).style!.color, Colors.white);
      }
    },
  );
  testWidgets('selected surface is square and radius is configurable', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        HyperCalendar(
          value: DateTime(2024, 2, 10),
          initialMonth: DateTime(2024, 2),
          onChanged: (_) {},
          style: const HyperCalendarStyle(radius: 3, selectedColor: Colors.red),
        ),
        width: 200,
        scale: 2,
      ),
    );
    await tester.pumpAndSettle();
    final surface = find.byWidgetPredicate(
      (w) =>
          w is DecoratedBox &&
          w.decoration is BoxDecoration &&
          (w.decoration as BoxDecoration).color == Colors.red,
    );
    expect(surface, findsOneWidget);
    final size = tester.getSize(surface);
    expect(size.width, size.height);
    expect(
      (tester.widget<DecoratedBox>(surface).decoration as BoxDecoration)
          .borderRadius,
      BorderRadius.circular(3),
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets('leap month renders and selects normalized day', (tester) async {
    DateTime? value;
    await tester.pumpWidget(
      host(
        HyperCalendar(
          value: null,
          initialMonth: DateTime(2024, 2),
          onChanged: (v) => value = v,
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(day(2024, 2, 29), findsOneWidget);
    expect(find.text('2024年'), findsOneWidget);
    expect(find.text('2月'), findsOneWidget);
    expect(find.byIcon(HyperIcons.chevronLeft), findsOneWidget);
    expect(find.text('一'), findsOneWidget);
    expect(day(2024, 2, 30), findsNothing);
    await tester.tap(day(2024, 2, 29));
    await tester.pumpAndSettle();
    expect(value, DateTime(2024, 2, 29));
    expect(tester.takeException(), isNull);
  });
  testWidgets('range reverse selection and same day', (tester) async {
    DateTimeRange? value;
    await tester.pumpWidget(
      host(
        HyperCalendar.range(
          value: null,
          initialMonth: DateTime(2026, 10),
          onChanged: (v) => value = v,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(day(2026, 10, 20));
    await tester.pumpAndSettle();
    expect(value, isNull);
    await tester.tap(day(2026, 10, 10));
    await tester.pumpAndSettle();
    expect(
      value,
      DateTimeRange(start: DateTime(2026, 10, 10), end: DateTime(2026, 10, 20)),
    );
    await tester.tap(day(2026, 10, 5));
    await tester.pumpAndSettle();
    await tester.tap(day(2026, 10, 5));
    await tester.pumpAndSettle();
    expect(value!.start, value!.end);
  });
  testWidgets('cross month range and bounds', (tester) async {
    DateTimeRange? value;
    await tester.pumpWidget(
      host(
        HyperCalendar.range(
          value: null,
          initialMonth: DateTime(2026, 10),
          firstDate: DateTime(2026, 10, 30),
          lastDate: DateTime(2026, 11, 3),
          onChanged: (v) => value = v,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(day(2026, 10, 31));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('calendar-next')));
    await tester.pumpAndSettle();
    await tester.tap(day(2026, 11, 2));
    await tester.pumpAndSettle();
    expect(
      value,
      DateTimeRange(start: DateTime(2026, 10, 31), end: DateTime(2026, 11, 2)),
    );
  });
  testWidgets('range cannot cross disabled day', (tester) async {
    DateTimeRange? value;
    await tester.pumpWidget(
      host(
        HyperCalendar.range(
          value: null,
          initialMonth: DateTime(2026, 10),
          selectableDayPredicate: (d) => d.day != 15,
          onChanged: (v) => value = v,
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(day(2026, 10, 14));
    await tester.pumpAndSettle();
    await tester.tap(day(2026, 10, 16));
    await tester.pumpAndSettle();
    expect(value, isNull);
  });
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('narrow calendar scale $scale', (tester) async {
      await tester.pumpWidget(
        host(
          HyperCalendar(
            value: null,
            initialMonth: DateTime(2024, 2),
            onChanged: (_) {},
          ),
          scale: scale,
          width: 200,
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
  test('calendar theme copy and lerp', () {
    final a = HyperThemeData.light();
    final b = a.copyWith(
      calendarTheme: const HyperCalendarThemeData(
        style: HyperCalendarStyle(selectedColor: Colors.red),
      ),
    );
    expect(a.lerp(b, 1).calendarTheme, b.calendarTheme);
    final size = a.sizes.desktop;
    expect(
      size
          .copyWith(calendar: size.calendar.copyWith(width: 400))
          .calendar
          .width,
      400,
    );
  });
}
