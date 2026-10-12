import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('基础配色直接取色并支持撤销', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    expect(find.text('基础配色'), findsOneWidget);
    final primaryRow = find.byKey(const ValueKey('editor-color-primary'));
    expect(tester.getSize(primaryRow).height, lessThanOrEqualTo(48));
    final help = find
        .descendant(of: primaryRow, matching: find.byType(Tooltip))
        .first;
    expect(tester.widget<Tooltip>(help).message, contains('主要操作'));
    final field = find.descendant(
      of: primaryRow,
      matching: find.byType(HyperColorPickerField),
    );
    final label = find.descendant(
      of: primaryRow,
      matching: find.text('primary'),
    );
    expect(tester.getCenter(field).dy, closeTo(tester.getCenter(label).dy, 1));
    tester
        .widget<HyperColorPickerField>(find.byType(HyperColorPickerField).first)
        .onChanged!(const Color(0xFFCC2288));
    await tester.pumpAndSettle();
    expect(find.textContaining('未保存'), findsOneWidget);
    expect(
      tester
          .widget<HyperColorPickerField>(
            find.byType(HyperColorPickerField).first,
          )
          .value,
      const Color(0xFFCC2288),
    );
    await tester.tap(find.byTooltip('撤销'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<HyperColorPickerField>(
            find.byType(HyperColorPickerField).first,
          )
          .value,
      const Color(0xFF3482FF),
    );
    expect(tester.takeException(), isNull);
  });
  testWidgets('选择组件只刷新局部，保留工具栏和分类控制器', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    final toolbar = tester.widget(find.textContaining('主题工作室 ·'));
    final global = tester.widget(find.text('全局工作区'));
    final controller = tester
        .widget<HyperTabBar>(find.byType(HyperTabBar).first)
        .controller;
    await tester.tap(find.text('Card').first);
    await tester.pump();
    expect(tester.widget(find.textContaining('主题工作室 ·')), same(toolbar));
    expect(tester.widget(find.text('全局工作区')), same(global));
    expect(
      tester.widget<HyperTabBar>(find.byType(HyperTabBar).first).controller,
      same(controller),
    );
    expect(controller!.indexIsChanging, isTrue);
    await tester.pumpAndSettle();
    expect(find.text('卡片'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('预览隔离、撤销重做和主题库保存打开', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    expect(find.text('全局工作区'), findsOneWidget);
    expect(find.text('组件工作区'), findsOneWidget);
    final scopes = find.byType(HyperScaffold);
    final outer = tester.element(scopes.first),
        preview = tester.element(scopes.at(1));
    final outerBody = HyperTheme.of(outer).typography.body;
    final previewBody = HyperTheme.of(preview).typography.body;
    final bodyEditor = find.byKey(const ValueKey('editor-number-正文'));
    final globalList = find.ancestor(
      of: find.text('全局工作区'),
      matching: find.byType(ListView),
    );
    final scrollable = find
        .descendant(of: globalList, matching: find.byType(Scrollable))
        .first;
    await tester.scrollUntilVisible(
      bodyEditor,
      500,
      scrollable: find.byWidget(tester.widget(scrollable)),
      maxScrolls: 30,
    );
    final slider = find.descendant(
      of: bodyEditor,
      matching: find.byType(HyperSlider),
    );
    await tester.tapAt(tester.getCenter(slider) + const Offset(30, 0));
    await tester.pumpAndSettle();
    expect(HyperTheme.of(outer).typography.body, outerBody);
    expect(HyperTheme.of(preview).typography.body, isNot(previewBody));
    expect(find.textContaining('未保存'), findsOneWidget);
    await tester.tap(find.byTooltip('撤销'));
    await tester.pumpAndSettle();
    expect(HyperTheme.of(preview).typography.body, previewBody);
    await tester.tap(find.byTooltip('重做'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('保存').first);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.enterText(find.byType(EditableText).last, '测试主题');
    await tester.tap(find.text('确定').last);
    await tester.pumpAndSettle();
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('theme-editor-library'), contains('测试主题'));
    expect(find.textContaining('未保存'), findsNothing);
    await tester.tap(find.text('新建'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('主题库'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('测试主题'));
    await tester.pumpAndSettle();
    expect(find.text('主题工作室 · 测试主题'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  for (final width in [400.0, 1000.0, 1440.0]) {
    testWidgets('编辑器 $width 宽度不溢出', (tester) async {
      await tester.binding.setSurfaceSize(Size(width, 850));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const LemonUiExampleApp());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }
}
