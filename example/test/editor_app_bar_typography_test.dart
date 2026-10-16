import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/pages/framework/hyper_app_bar_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('顶栏字号显示实际默认值，覆盖和恢复继承保持一致', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1600, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-app-bar');
    await tester.pumpAndSettle();
    final panel = find.byKey(const ValueKey('editor-panel-应用顶栏'));
    final scroll = find
        .descendant(of: panel, matching: find.byType(Scrollable))
        .first;
    Future<Finder> field(String label) async {
      tester.state<ScrollableState>(scroll).position.jumpTo(0);
      await tester.pump();
      final finder = find.byKey(ValueKey('editor-number-$label'));
      await tester.scrollUntilVisible(finder, 200, scrollable: scroll);
      return finder;
    }

    HyperThemeData theme() =>
        HyperTheme.of(tester.element(find.byType(HyperAppBarPage)));
    final title = await field('标题字号');
    expect(
      tester
          .widget<HyperSlider>(
            find.descendant(of: title, matching: find.byType(HyperSlider)),
          )
          .value,
      theme().typography.subsectionTitle,
    );
    final expanded = await field('展开标题字号');
    final slider = tester.widget<HyperSlider>(
      find.descendant(of: expanded, matching: find.byType(HyperSlider)),
    );
    expect(slider.value, theme().textTheme.headlineLarge!.fontSize);
    expect(slider.max, greaterThan(slider.value));
    slider.onChanged!(40.6);
    await tester.pumpAndSettle();
    expect(theme().appBarTheme.style!.expandedTitleTextStyle!.fontSize, 41);
    final edited = await field('展开标题字号');
    final editedSlider = tester.widget<HyperSlider>(
      find.descendant(of: edited, matching: find.byType(HyperSlider)),
    );
    expect(editedSlider.value, 41);
    expect(editedSlider.max, slider.max);
    // Explicit values affect both expanded variants, while inherited values
    // retain their separate titleLarge / headlineLarge semantics.
    final reset = find.text('恢复当前对象 / 状态继承');
    tester.state<ScrollableState>(scroll).position.jumpTo(0);
    await tester.pump();
    await tester.scrollUntilVisible(reset, 200, scrollable: scroll);
    await tester.tap(reset);
    await tester.pumpAndSettle();
    final restored = await field('展开标题字号');
    expect(
      tester
          .widget<HyperSlider>(
            find.descendant(of: restored, matching: find.byType(HyperSlider)),
          )
          .value,
      theme().textTheme.headlineLarge!.fontSize,
    );
    expect(theme().appBarTheme.style?.expandedTitleTextStyle?.fontSize, isNull);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
