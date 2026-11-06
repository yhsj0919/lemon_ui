import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('field alignment participates in inheritance and value operations', () {
    const base = HyperFieldStyle(
      horizontalAlignment: HyperFieldAlignment.start,
      gap: 8,
    );
    final changed = base.copyWith(horizontalAlignment: HyperFieldAlignment.end);
    expect(base.merge(changed), changed);
    expect(changed.gap, 8);
    expect(HyperFieldStyle.lerp(base, changed, .25), base);
    expect(HyperFieldStyle.lerp(base, changed, .75), changed);
    expect(base, isNot(changed));
    expect(base.hashCode, base.copyWith().hashCode);
  });

  for (final scale in [1.0, 1.3, 2.0]) {
    for (final alignment in [null, ...HyperFieldAlignment.values]) {
      testWidgets('horizontal field alignment $alignment at scale $scale', (
        tester,
      ) async {
        await tester.pumpWidget(
          MaterialApp(
            home: HyperTheme(
              data: HyperThemeData.light().copyWith(
                fieldTheme: const HyperFieldThemeData(
                  style: HyperFieldStyle(
                    horizontalAlignment: HyperFieldAlignment.end,
                  ),
                ),
              ),
              child: MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                child: Scaffold(
                  body: Center(
                    child: SizedBox(
                      width: 500,
                      child: HyperFieldTheme(
                        data: const HyperFieldThemeData(
                          style: HyperFieldStyle(
                            horizontalAlignment: HyperFieldAlignment.start,
                          ),
                        ),
                        child: HyperField(
                          label: '名称',
                          layout: HyperFieldLayout.horizontal,
                          style: HyperFieldStyle(
                            horizontalAlignment:
                                alignment ?? HyperFieldAlignment.center,
                          ),
                          child: const SizedBox(
                            key: ValueKey('control'),
                            width: 200,
                            height: 100,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        final label = tester.getRect(find.text('名称'));
        final control = tester.getRect(find.byKey(const ValueKey('control')));
        switch (alignment ?? HyperFieldAlignment.center) {
          case HyperFieldAlignment.start:
            expect(label.top, control.top);
          case HyperFieldAlignment.center:
            expect(label.center.dy, control.center.dy);
          case HyperFieldAlignment.end:
            expect(label.bottom, control.bottom);
        }
        expect(tester.takeException(), isNull);
      });
    }
  }
  testWidgets('horizontal fields default to center', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: const Scaffold(
            body: SizedBox(
              width: 500,
              child: HyperField(
                label: '名称',
                layout: HyperFieldLayout.horizontal,
                child: SizedBox(
                  key: ValueKey('control'),
                  height: 60,
                  width: 200,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    expect(
      tester.getCenter(find.text('名称')).dy,
      tester.getCenter(find.byKey(const ValueKey('control'))).dy,
    );
  });
}
