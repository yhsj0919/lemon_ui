import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('table flags merge, copy, interpolate and compare', () {
    const enabled = HyperTableStyle(
      hoverLift: true,
      striped: true,
      showColumnResizeHandles: true,
    );
    const disabled = HyperTableStyle(
      hoverLift: false,
      striped: false,
      showColumnResizeHandles: false,
    );
    expect(enabled.copyWith(hoverLift: false).hoverLift, isFalse);
    expect(enabled.merge(disabled), disabled);
    final first = HyperTableStyle.lerp(enabled, disabled, .25);
    final second = HyperTableStyle.lerp(enabled, disabled, .75);
    expect(
      [first.hoverLift, first.striped, first.showColumnResizeHandles],
      [true, true, true],
    );
    expect(
      [second.hoverLift, second.striped, second.showColumnResizeHandles],
      [false, false, false],
    );
    expect(enabled.copyWith(), enabled);
    expect(enabled.copyWith().hashCode, enabled.hashCode);
  });
  for (final scenario in ['global', 'local', 'style', 'instance']) {
    testWidgets('table hoverLift precedence: $scenario', (tester) async {
      final base = HyperThemeData.light();
      final table = HyperTable<String>(
        columns: [
          HyperTableColumn(id: 'name', title: '名称', value: (row) => row),
        ],
        rows: const ['row-a', 'row-b'],
        rowKey: (row) => row,
        hoverLift: scenario == 'instance' ? true : null,
        striped: scenario == 'instance' ? true : null,
        showColumnResizeHandles: scenario == 'instance' ? true : null,
        style: scenario == 'style' || scenario == 'instance'
            ? const HyperTableStyle(
                hoverLift: false,
                striped: false,
                showColumnResizeHandles: false,
              )
            : null,
      );
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            duration: Duration.zero,
            data: base.copyWith(
              tableTheme: const HyperTableThemeData(
                style: HyperTableStyle(
                  hoverLift: true,
                  striped: true,
                  showColumnResizeHandles: true,
                  stripeBackground: Colors.purple,
                  hoverBackground: Colors.green,
                  liftBackground: Colors.red,
                ),
              ),
            ),
            child: Scaffold(
              body: SizedBox(
                width: 600,
                height: 400,
                child: scenario == 'local'
                    ? HyperTableTheme(
                        data: const HyperTableThemeData(
                          style: HyperTableStyle(
                            hoverLift: false,
                            striped: false,
                            showColumnResizeHandles: false,
                          ),
                        ),
                        child: table,
                      )
                    : table,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      await mouse.moveTo(tester.getCenter(find.text('row-a')));
      await tester.pumpAndSettle();
      final expected = scenario == 'global' || scenario == 'instance'
          ? Colors.red
          : Colors.green;
      expect(
        tester
            .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
            .any(
              (widget) =>
                  widget.decoration is BoxDecoration &&
                  (widget.decoration! as BoxDecoration).color == expected,
            ),
        isTrue,
      );
      final enabled = scenario == 'global' || scenario == 'instance';
      expect(
        tester
            .widgetList<ColoredBox>(find.byType(ColoredBox))
            .any((widget) => widget.color == Colors.purple),
        enabled,
      );
      final resize = find.byWidgetPredicate(
        (widget) =>
            widget is GestureDetector && widget.onHorizontalDragUpdate != null,
      );
      final opacity = find.descendant(
        of: resize,
        matching: find.byType(AnimatedOpacity),
      );
      expect(opacity, findsOneWidget);
      expect(tester.widget<AnimatedOpacity>(opacity).opacity, enabled ? 1 : 0);
      expect(tester.takeException(), isNull);
      await mouse.removePointer();
    });
  }
}
