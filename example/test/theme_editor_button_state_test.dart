import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('按钮按变体和状态分层，仅显示当前状态并保留覆盖', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1440, 5000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-button');
    await tester.pumpAndSettle();
    HyperSelect<String> selector(String key) =>
        tester.widget<HyperSelect<String>>(
          find.descendant(
            of: find.byKey(ValueKey(key)),
            matching: find.byType(HyperSelect<String>),
          ),
        );
    Finder row(String label) => find.byKey(ValueKey('editor-number-$label'));
    HyperSlider slider(String label) => tester.widget<HyperSlider>(
      find.descendant(of: row(label), matching: find.byType(HyperSlider)),
    );
    expect(row('hoverOverlayOpacity'), findsNothing);
    expect(row('悬停垂直位移'), findsNothing);
    expect(row('progressThickness'), findsOneWidget);
    selector('editor-button-state').onChanged!('hovered');
    await tester.pumpAndSettle();
    expect(row('hoverOverlayOpacity'), findsOneWidget);
    expect(row('focusOverlayOpacity'), findsNothing);
    expect(row('progressThickness'), findsNothing);
    expect(find.byKey(const ValueKey('editor-button-size')), findsNothing);
    expect(find.text('悬停阴影'), findsOneWidget);
    expect(find.text('按下阴影'), findsNothing);
    slider('悬停垂直位移').onChanged!(-3);
    await tester.pumpAndSettle();
    selector('editor-button-state').onChanged!('pressed');
    await tester.pumpAndSettle();
    expect(row('悬停垂直位移'), findsNothing);
    expect(row('按下垂直位移'), findsOneWidget);
    expect(find.text('按下阴影'), findsOneWidget);
    slider('按下垂直位移').onChanged!(2);
    await tester.pumpAndSettle();
    selector('editor-button-state').onChanged!('hovered');
    await tester.pumpAndSettle();
    expect(slider('悬停垂直位移').value, -3);
    selector('editor-button-variant').onChanged!('tonal');
    await tester.pumpAndSettle();
    expect(selector('editor-button-state').value, 'hovered');
    expect(slider('悬停垂直位移').value, 0);
    selector('editor-button-variant').onChanged!('common');
    await tester.pumpAndSettle();
    expect(slider('悬停垂直位移').value, -3);
    tester
        .widget<HyperButton>(
          find.ancestor(
            of: find.text('重置当前状态'),
            matching: find.byType(HyperButton),
          ),
        )
        .onPressed!();
    await tester.pumpAndSettle();
    expect(slider('悬停垂直位移').value, 0);
    selector('editor-button-state').onChanged!('pressed');
    await tester.pumpAndSettle();
    expect(slider('按下垂直位移').value, 2);
    selector('editor-button-state').onChanged!('disabled');
    await tester.pumpAndSettle();
    expect(row('pressOverlayOpacity'), findsNothing);
    expect(find.text('禁用阴影'), findsOneWidget);
    selector('editor-button-state').onChanged!('common');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('editor-button-size')), findsOneWidget);
    expect(row('progressThickness'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
