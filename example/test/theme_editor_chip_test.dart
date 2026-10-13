import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Chip 工作区状态切换与尺寸重置', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1440, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-chip');
    await tester.pumpAndSettle();
    expect(find.text('状态覆盖'), findsOneWidget);
    expect(find.text('编辑状态'), findsNothing);
    expect(find.byType(HyperSegmentedButton<String>), findsNothing);
    final row = find.byKey(const ValueKey('editor-number-标签高度'));
    final slider = tester.widget<HyperSlider>(
      find.descendant(of: row, matching: find.byType(HyperSlider)),
    );
    slider.onChanged!(34);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<HyperSlider>(
            find.descendant(of: row, matching: find.byType(HyperSlider)),
          )
          .value,
      34,
    );
    final selector = tester.widget<HyperSelect<String>>(
      find.descendant(
        of: find.byKey(const ValueKey('editor-chip-state')),
        matching: find.byType(HyperSelect<String>),
      ),
    );
    selector.onChanged!('selected');
    await tester.pumpAndSettle();
    expect(row, findsNothing);
    selector.onChanged!('common');
    await tester.pumpAndSettle();
    expect(row, findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
