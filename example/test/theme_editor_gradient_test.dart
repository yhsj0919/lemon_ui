import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('渐变类型切换显示对应参数并保留节点', (tester) async {
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
    tester
        .widget<HyperSegmentedButton<String>>(
          find.byType(HyperSegmentedButton<String>),
        )
        .onSelectionChanged!({'gradient'});
    await tester.pumpAndSettle();
    final scroll = find
        .descendant(
          of: find.byKey(const ValueKey('editor-panel-组件工作区')),
          matching: find.byType(Scrollable),
        )
        .first;
    Future<void> reveal(Key key) async {
      tester.state<ScrollableState>(scroll).position.jumpTo(0);
      await tester.pump();
      await tester.scrollUntilVisible(find.byKey(key), 250, scrollable: scroll);
    }

    for (final entry in {
      'radial': '渐变半径',
      'sweep': '扫描终止角（度）',
      'linear': '渐变方向（度）',
    }.entries) {
      const selectorKey = ValueKey('editor-select-渐变类型');
      await reveal(selectorKey);
      tester
          .widget<HyperSelect<String>>(
            find.descendant(
              of: find.byKey(selectorKey),
              matching: find.byType(HyperSelect<String>),
            ),
          )
          .onChanged!(entry.key);
      await tester.pumpAndSettle();
      final parameter = ValueKey('editor-number-${entry.value}');
      await reveal(parameter);
      expect(find.byKey(parameter), findsOneWidget);
      await reveal(const ValueKey('editor-color-渐变节点 2'));
      expect(find.byKey(const ValueKey('editor-color-渐变节点 2')), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
