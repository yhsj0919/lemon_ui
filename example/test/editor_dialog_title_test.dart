import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/pages/feedback/hyper_dialog_page.dart';
import 'package:lemon_ui_example/pages/feedback/hyper_bottom_sheet_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('对话框与底部弹窗的标题、正文字号入口与实际继承字阶一致', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1600, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    for (final (id, name, pageType) in [
      ('hyper-dialog', '对话框', HyperDialogPage),
      ('hyper-bottom-sheet', '底部弹窗', HyperBottomSheetPage),
    ]) {
      tester
          .widget<EditorComponentNavigation>(
            find.byType(EditorComponentNavigation),
          )
          .onSelected(id);
      await tester.pumpAndSettle();
      final panel = find.byKey(ValueKey('editor-panel-$name'));
      final scroll = find
          .descendant(of: panel, matching: find.byType(Scrollable))
          .first;
      final theme = HyperTheme.of(tester.element(find.byType(pageType)));
      for (final (label, expected) in [
        ('标题字号', theme.textTheme.titleMedium!.fontSize),
        ('正文字号', theme.textTheme.bodyMedium!.fontSize),
      ]) {
        final field = find.byKey(ValueKey('editor-number-$label'));
        await tester.scrollUntilVisible(field, 200, scrollable: scroll);
        final slider = tester.widget<HyperSlider>(
          find.descendant(of: field, matching: find.byType(HyperSlider)),
        );
        expect(slider.value, expected, reason: name + label);
      }
      expect(tester.takeException(), isNull);
    }
    await tester.pumpWidget(const SizedBox());
  });
}
