import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

Finder tooltipFinder(String message) => find.byWidgetPredicate(
  (widget) =>
      widget is HyperTooltip && widget.message == message ||
      widget is Tooltip && widget.message == message,
);

void main() {
  testWidgets('工作区跟随页面，并支持按钮变体选择', (tester) async {
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
    final variants = find.descendant(
      of: find.byKey(const ValueKey('editor-button-variant')),
      matching: find.byType(HyperSelect<String>),
    );
    expect(variants, findsOneWidget);
    tester.widget<HyperSelect<String>>(variants).onChanged!('tonal');
    await tester.pumpAndSettle();
    expect(tester.widget<HyperSelect<String>>(variants).value, 'tonal');
    tester.widget<HyperSelect<String>>(variants).onChanged!('gradient');
    await tester.pumpAndSettle();
    final thicknessKey = find.byKey(
      const ValueKey('editor-number-progressThickness'),
    );
    await tester.scrollUntilVisible(
      thicknessKey,
      200,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('editor-panel-组件工作区')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    final thicknessSlider = find.descendant(
      of: thicknessKey,
      matching: find.byType(HyperSlider),
    );
    expect(tester.widget<HyperSlider>(thicknessSlider).min, 1);
    expect(tester.widget<HyperSlider>(thicknessSlider).divisions, 9);
    tester.widget<HyperSlider>(thicknessSlider).onChanged!(3.6);
    await tester.pumpAndSettle();
    expect(tester.widget<HyperSlider>(thicknessSlider).value, 4);
    await tester.scrollUntilVisible(
      find.text('渐变背景'),
      300,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('editor-panel-组件工作区')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('渐变背景'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('渐变节点 1'),
      150,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('editor-panel-组件工作区')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('渐变节点 1'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('渐变节点 2'),
      150,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('editor-panel-组件工作区')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.text('渐变节点 2'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('editor-select-背景类型')),
      -250,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('editor-panel-组件工作区')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    final backgroundSelect = find.descendant(
      of: find.byKey(const ValueKey('editor-select-背景类型')),
      matching: find.byType(HyperSelect<String>),
    );
    tester.widget<HyperSelect<String>>(backgroundSelect).onChanged!('none');
    await tester.pumpAndSettle();
    expect(find.text('渐变背景'), findsNothing);
    tester.widget<HyperSelect<String>>(backgroundSelect).onChanged!('solid');
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('editor-color-背景')), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('editor-select-边框类型')),
      200,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('editor-panel-组件工作区')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    final borderSelect = find.descendant(
      of: find.byKey(const ValueKey('editor-select-边框类型')),
      matching: find.byType(HyperSelect<String>),
    );
    tester.widget<HyperSelect<String>>(borderSelect).onChanged!('dashed');
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('editor-number-虚线间隔')),
      150,
      scrollable: find
          .descendant(
            of: find.byKey(const ValueKey('editor-panel-组件工作区')),
            matching: find.byType(Scrollable),
          )
          .first,
    );
    expect(find.byKey(const ValueKey('editor-number-虚线间隔')), findsOneWidget);
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-tooltip');
    await tester.pumpAndSettle();
    expect(find.text('暂不支持编辑'), findsNothing);
    expect(find.byKey(const ValueKey('editor-panel-文字提示')), findsOneWidget);
    expect(variants, findsNothing);
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-button');
    await tester.pumpAndSettle();
    expect(find.text('暂不支持编辑'), findsNothing);
    expect(tester.widget<HyperSelect<String>>(variants).value, 'gradient');
    expect(tester.takeException(), isNull);
  });
  setUp(() => SharedPreferences.setMockInitialValues({}));
  testWidgets('主题库列表支持取消删除和持久化删除', (tester) async {
    final document = EditorThemeDocument(name: '待删除主题');
    final startup = jsonEncode({'dark': false, 'theme': document.toJson()});
    SharedPreferences.setMockInitialValues({
      'theme-editor-library': jsonEncode({'待删除主题': document.encode()}),
      'theme-editor-startup': startup,
    });
    await tester.binding.setSurfaceSize(const Size(1440, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    await tester.tap(tooltipFinder('主题库'));
    await tester.pumpAndSettle();
    expect(
      find.ancestor(
        of: find.text('待删除主题'),
        matching: find.byType(HyperListTile),
      ),
      findsOneWidget,
    );
    await tester.tap(tooltipFinder('删除主题 待删除主题'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('取消').last);
    await tester.pumpAndSettle();
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('theme-editor-library'), contains('待删除主题'));
    await tester.tap(tooltipFinder('删除主题 待删除主题'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('删除').last);
    await tester.pumpAndSettle();
    expect(jsonDecode(prefs.getString('theme-editor-library')!), isEmpty);
    expect(prefs.getString('theme-editor-startup'), startup);
    expect(find.text('还没有保存的主题'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('主题色直接取色并支持撤销', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    expect(find.text('主题与强调色'), findsOneWidget);
    expect(find.text('主题色'), findsOneWidget);
    final primaryRow = find.byKey(const ValueKey('editor-color-primary'));
    expect(tester.getSize(primaryRow).height, lessThanOrEqualTo(48));
    final help = find
        .descendant(of: primaryRow, matching: find.byType(HyperTooltip))
        .first;
    expect(tester.widget<HyperTooltip>(help).message, contains('主要操作'));
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
    await tester.tap(tooltipFinder('撤销'));
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
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-card');
    await tester.pump();
    expect(tester.widget(find.textContaining('主题工作室 ·')), same(toolbar));
    expect(tester.widget(find.text('全局工作区')), same(global));
    expect(
      tester.widget<HyperTabBar>(find.byType(HyperTabBar).first).controller,
      same(controller),
    );
    expect(controller!.indexIsChanging, isTrue);
    await tester.pumpAndSettle();
    expect(
      find.descendant(
        of: find.byType(EditorComponentNavigation),
        matching: find.text('卡片'),
      ),
      findsOneWidget,
    );
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
    await tester.ensureVisible(slider);
    await tester.pumpAndSettle();
    await tester.tapAt(tester.getCenter(slider) + const Offset(30, 0));
    await tester.pumpAndSettle();
    expect(HyperTheme.of(outer).typography.body, outerBody);
    expect(HyperTheme.of(preview).typography.body, isNot(previewBody));
    expect(find.textContaining('未保存'), findsOneWidget);
    await tester.tap(tooltipFinder('撤销'));
    await tester.pumpAndSettle();
    expect(HyperTheme.of(preview).typography.body, previewBody);
    await tester.tap(tooltipFinder('重做'));
    await tester.pumpAndSettle();
    await tester.tap(tooltipFinder('保存').first);
    await tester.pump(const Duration(milliseconds: 400));
    await tester.enterText(find.byType(EditableText).last, '测试主题');
    await tester.tap(find.text('确定').last);
    await tester.pumpAndSettle();
    final prefs = await SharedPreferences.getInstance();
    expect(prefs.getString('theme-editor-library'), contains('测试主题'));
    expect(find.textContaining('未保存'), findsNothing);
    await tester.tap(tooltipFinder('新建'));
    await tester.pumpAndSettle();
    await tester.tap(tooltipFinder('主题库'));
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.text('测试主题'));
    await tester.pumpAndSettle();
    expect(find.text('主题工作室 · 测试主题'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  for (final width in [400.0, 1000.0, 1440.0, 2000.0]) {
    testWidgets('编辑器 $width 宽度不溢出', (tester) async {
      await tester.binding.setSurfaceSize(Size(width, 850));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(const LemonUiExampleApp());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      if (width >= 1000) {
        final saveBounds = tester.getRect(tooltipFinder('保存').first);
        expect(saveBounds.right, lessThanOrEqualTo(width));
      }
    });
  }
}
