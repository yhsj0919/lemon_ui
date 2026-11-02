import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/pages/framework/hyper_tab_bar_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets(
    'tab content inset writes integers, supports zero and restores inheritance',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      await tester.binding.setSurfaceSize(const Size(1600, 1100));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const LemonUiExampleApp());
      await tester.pumpAndSettle();
      tester
          .widget<EditorComponentNavigation>(
            find.byType(EditorComponentNavigation),
          )
          .onSelected('hyper-tab-bar');
      await tester.pumpAndSettle();
      final panel = find.byKey(const ValueKey('editor-panel-标签导航'));
      final scroll = find
          .descendant(of: panel, matching: find.byType(Scrollable))
          .first;
      Future<Finder> field(String key) async {
        tester.state<ScrollableState>(scroll).position.jumpTo(0);
        await tester.pump();
        final finder = find.byKey(ValueKey(key));
        await tester.scrollUntilVisible(finder, 200, scrollable: scroll);
        return finder;
      }

      Future<void> select(String label, String value) async {
        final target = await field('editor-select-$label');
        tester
            .widget<HyperSelect<String>>(
              find.descendant(
                of: target,
                matching: find.byType(HyperSelect<String>),
              ),
            )
            .onChanged!(value);
        await tester.pumpAndSettle();
      }

      Future<void> setInset(double value) async {
        final target = await field('editor-number-标签水平内边距');
        tester
            .widget<HyperSlider>(
              find.descendant(of: target, matching: find.byType(HyperSlider)),
            )
            .onChanged!(value);
        await tester.pumpAndSettle();
      }

      double? inset() => HyperTheme.sizesOf(
        tester.element(
          find
              .descendant(
                of: find.byType(HyperTabBarPage),
                matching: find.byType(HyperTabBar),
              )
              .first,
        ),
      ).tabBar.itemHorizontalPadding;
      await select('外观变体', 'common');
      await select('编辑范围', 'group');
      await setInset(8.6);
      expect(inset(), 9);
      await setInset(0);
      expect(inset(), 0);
      tester.state<ScrollableState>(scroll).position.jumpTo(0);
      await tester.pump();
      await tester.tap(find.text('恢复当前对象 / 状态继承'));
      await tester.pumpAndSettle();
      expect(inset(), 16);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
    },
  );
}
