import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('连续拖动实时更新，整次手势只形成一条撤销记录', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1440, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-button');
    await tester.pumpAndSettle();
    final row = find.byKey(const ValueKey('editor-number-最小高度'));
    HyperSlider slider() => tester.widget<HyperSlider>(
      find.descendant(of: row, matching: find.byType(HyperSlider)),
    );
    final initial = slider().value;
    slider().onChangeStart!(initial);
    for (final value in [42.0, 43.0, 44.0, 45.0]) {
      slider().onChanged!(value);
      await tester.pump();
      expect(slider().value, value);
    }
    slider().onChangeEnd!(45);
    await tester.pumpAndSettle();
    Finder action(String title) =>
        find.byWidgetPredicate((w) => w is HyperTooltip && w.message == title);
    await tester.tap(action('撤销'));
    await tester.pumpAndSettle();
    expect(slider().value, initial);
    final undo = tester.widget<HyperButton>(
      find.descendant(of: action('撤销'), matching: find.byType(HyperButton)),
    );
    expect(undo.onPressed, isNull);
    await tester.tap(action('重做'));
    await tester.pumpAndSettle();
    expect(slider().value, 45);
    expect(tester.takeException(), isNull);
  });
}
