import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:lemon_ui_example/gallery/gallery_registry.dart';

void main() {
  testWidgets('树形选择入口归入未确认分类并能从编辑器导航显示', (tester) async {
    final pending = gallerySections.singleWhere((s) => s.title == '未确认');
    expect(
      pending.items.where((i) => i.id == 'hyper-tree-select'),
      hasLength(1),
    );
    expect(
      gallerySections
          .where((s) => s.title != '未确认')
          .expand((s) => s.items)
          .where((i) => i.id == 'hyper-tree-select'),
      isEmpty,
    );
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const Scaffold(
            body: EditorComponentNavigation(
              page: 'hyper-tree-select',
              onSelected: _ignoreSelection,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('树形选择 · 未确认'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('多行文本入口登记在表单分类并显示编辑器入口', (tester) async {
    final pending = gallerySections.singleWhere((s) => s.title == '未确认');
    expect(pending.items.where((i) => i.id == 'hyper-text-area'), isEmpty);
    final forms = gallerySections.singleWhere((s) => s.title == '表单');
    expect(forms.items.where((i) => i.id == 'hyper-text-area'), hasLength(1));
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const Scaffold(
            body: EditorComponentNavigation(
              page: 'hyper-text-area',
              onSelected: _ignoreSelection,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('多行文本'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('表单示例归入表单分类并显示编辑器入口', (tester) async {
    final forms = gallerySections.singleWhere((s) => s.title == '表单');
    expect(forms.items.map((i) => i.id), [
      'hyper-form',
      'hyper-form-actions',
      'hyper-text-area',
    ]);
    final pending = gallerySections.singleWhere((s) => s.title == '未确认');
    expect(pending.items.where((i) => i.id.startsWith('hyper-form')), isEmpty);
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const Scaffold(
            body: EditorComponentNavigation(
              page: 'hyper-form-actions',
              onSelected: _ignoreSelection,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('表单操作'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('顶部导航与菜单统一放入导航分类，提示保留在反馈', (tester) async {
    final section = gallerySections.firstWhere((s) => s.title == '顶部导航与菜单');
    expect(section.items.map((i) => i.id), [
      'hyper-top-navigation',
      'hyper-menu',
    ]);
    for (final page in ['hyper-top-navigation', 'hyper-menu']) {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            duration: Duration.zero,
            child: Scaffold(
              body: EditorComponentNavigation(page: page, onSelected: (_) {}),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('顶部导航'), findsOneWidget);
      expect(find.text('菜单'), findsOneWidget);
      expect(find.text('文字提示'), findsNothing);
      expect(tester.takeException(), isNull);
    }
  });
  testWidgets('分类导航切换组件和完整 Demo，外部选择同步分类', (tester) async {
    String page = 'all';
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
    expect(find.byType(HyperTabBar), findsOneWidget);
    expect(find.byType(HyperTopNavigation), findsNothing);
    await tester.ensureVisible(find.text('容器').first);
    await tester.tap(find.text('容器').first);
    await tester.pumpAndSettle();
    expect(page, 'all');
    await tester.ensureVisible(find.text('卡片'));
    await tester.tap(find.text('卡片'));
    await tester.pumpAndSettle();
    expect(page, 'hyper-card');
    await tester.tap(find.text('容器').first);
    await tester.pumpAndSettle();
    expect(page, 'hyper-card');
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
    expect(page, 'all');
    expect(find.text('HyperTextField'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

void _ignoreSelection(String _) {}
