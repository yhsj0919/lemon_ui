import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';

void main() {
  testWidgets('分类导航切换组件和完整 Demo，外部选择同步分类', (tester) async {
    String page = 'hyper-button';
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return EditorComponentNavigation(
                  page: page,
                  onSelected: (value) => setState(() => page = value),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HyperTabBar), findsNWidgets(2));
    expect(find.byType(HyperTopNavigation), findsNothing);
    await tester.ensureVisible(find.text('容器').first);
    await tester.tap(find.text('容器').first);
    await tester.pumpAndSettle();
    expect(page, 'hyper-container');
    await tester.ensureVisible(find.text('卡片'));
    await tester.tap(find.text('卡片'));
    await tester.pumpAndSettle();
    expect(page, 'hyper-card');
    await tester.tap(find.text('容器').first);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.check), findsNothing);
    expect(find.text('卡片'), findsOneWidget);
    await tester.tap(find.text('卡片'));
    await tester.pumpAndSettle();
    update(() => page = 'hyper-text-field');
    await tester.pumpAndSettle();
    expect(find.text('文本输入'), findsOneWidget);
    expect(find.text('卡片'), findsNothing);
    await tester.ensureVisible(find.text('完整 Demo'));
    await tester.tap(find.text('完整 Demo'));
    await tester.pumpAndSettle();
    expect(page, 'all');
    expect(find.byType(HyperTabBar), findsOneWidget);
    await tester.ensureVisible(find.text('容器').first);
    await tester.tap(find.text('容器').first);
    await tester.pumpAndSettle();
    expect(page, 'hyper-card');
    expect(find.text('HyperTextField'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

