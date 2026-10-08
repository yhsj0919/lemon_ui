import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/selection/hyper_checkbox_page.dart';

void main() {
  testWidgets('展示并切换三态复选框', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperCheckboxPage(),
        ),
      ),
    );
    expect(find.text('未选中'), findsOneWidget);
    expect(find.text('圆角矩形变体'), findsOneWidget);
    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget is HyperCheckbox && widget.semanticLabel == '三态复选框',
      ),
    );
    await tester.pump();
    expect(find.text('选中'), findsOneWidget);
    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget is HyperCheckbox && widget.semanticLabel == '三态复选框',
      ),
    );
    await tester.pump();
    expect(find.text('半选中'), findsOneWidget);
  });
  testWidgets('原生与 Hyper 对照控件同步切换三态', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: HyperCheckboxPage()));
    final native = find.byKey(const Key('native-checkbox-comparison'));
    final hyper = find.byKey(const Key('hyper-checkbox-comparison'));
    final rounded = find.byKey(const Key('rounded-checkbox-comparison'));
    expect(tester.widget<Checkbox>(native).value, true);
    await tester.tap(native);
    await tester.pumpAndSettle();
    expect(tester.widget<HyperCheckbox>(hyper).value, null);
    expect(tester.widget<HyperCheckbox>(rounded).value, null);
    await tester.tap(hyper);
    await tester.pumpAndSettle();
    expect(tester.widget<Checkbox>(native).value, false);
    expect(tester.widget<HyperCheckbox>(rounded).value, false);
  });
}
