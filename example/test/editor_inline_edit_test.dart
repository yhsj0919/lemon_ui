import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/gallery/gallery_registry.dart';
import 'package:lemon_ui_example/pages/selection/hyper_inline_edit_page.dart';

void main() {
  testWidgets('dialog demo cancels with Escape and saves confirmed content', (
    t,
  ) async {
    await t.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: const Scaffold(
            body: SizedBox(width: 360, child: HyperInlineEditPage()),
          ),
        ),
      ),
    );
    final preview = find.byKey(
      const ValueKey('inline-edit-preview-自定义弹窗编辑 · 页面只保留摘要'),
    );
    await t.scrollUntilVisible(
      preview,
      250,
      scrollable: find.byType(Scrollable).first,
    );
    await t.ensureVisible(find.text('这段内容需要在弹窗中编辑。'));
    await t.pumpAndSettle();
    final height = t.getSize(preview).height;
    await t.longPress(find.text('这段内容需要在弹窗中编辑。'));
    await t.pumpAndSettle();
    expect(find.byType(HyperDialog), findsOneWidget);
    expect(t.getSize(preview).height, height);
    await t.enterText(find.byType(EditableText), '取消的内容');
    await t.sendKeyEvent(LogicalKeyboardKey.escape);
    await t.pumpAndSettle();
    expect(find.byType(HyperDialog), findsNothing);
    expect(find.text('这段内容需要在弹窗中编辑。'), findsOneWidget);
    await t.longPress(find.text('这段内容需要在弹窗中编辑。'));
    await t.pumpAndSettle();
    await t.enterText(find.byType(EditableText), '新的详细内容');
    await t.tap(find.text('保存'));
    await t.pumpAndSettle();
    expect(find.text('新的详细内容'), findsOneWidget);
    expect(t.getSize(preview).height, height);
    expect(t.takeException(), isNull);
  });
  testWidgets('gallery demo supports narrow width and text scaling', (t) async {
    for (final scale in [1.0, 1.3, 2.0]) {
      await t.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: const Scaffold(
                body: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(width: 240, child: HyperInlineEditPage()),
                ),
              ),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      expect(find.byType(HyperInlineEditPage), findsOneWidget);
      final preview = find.byKey(
        const ValueKey('inline-edit-preview-默认 · 单行与校验'),
      );
      await t.scrollUntilVisible(
        preview,
        100,
        scrollable: find.byType(Scrollable).first,
      );
      final height = t.getSize(preview).height;
      await t.ensureVisible(find.text('双击编辑名称').first);
      await t.pumpAndSettle();
      await t.longPress(find.text('双击编辑名称').first);
      await t.pumpAndSettle();
      expect(t.getSize(preview).height, height);
      await t.enterText(find.byType(EditableText), '');
      await t.testTextInput.receiveAction(TextInputAction.done);
      await t.pumpAndSettle();
      expect(find.text('名称不能为空'), findsOneWidget);
      expect(t.getSize(preview).height, height);
      expect(t.takeException(), isNull);
      await t.pumpWidget(const SizedBox());
    }
  });
  test('inline edit is confirmed in inputs and editor colors round trip per appearance', () {
    expect(
      gallerySections
          .firstWhere((s) => s.title == '输入控件')
          .items
          .any((i) => i.id == 'hyper-inline-edit'),
      isTrue,
    );
    final doc = EditorThemeDocument();
    expect(
      gallerySections
          .expand((s) => s.items)
          .where((i) => i.id == 'hyper-inline-edit'),
      hasLength(1),
    );
    expect(
      gallerySections
          .where((s) => s.title == '未确认')
          .expand((s) => s.items)
          .any((i) => i.id == 'hyper-inline-edit'),
      isFalse,
    );
    doc.light.inlineEdit.displayColor = const EditorColor(argb: 0xffff0000);
    doc.dark.inlineEdit.errorColor = const EditorColor(argb: 0xff0000ff);
    final restored = EditorThemeDocument.decode(doc.encode());
    expect(restored.encode(), doc.encode());
    for (final device in HyperDeviceType.values) {
      final light = restored
          .resolve(false, deviceType: device)
          .inlineEditTheme
          .style;
      final dark = restored
          .resolve(true, deviceType: device)
          .inlineEditTheme
          .style;
      expect(light.displayStyle?.color, const Color(0xffff0000));
      expect(light.errorStyle, isNull);
      expect(dark.displayStyle, isNull);
      expect(dark.errorStyle?.color, const Color(0xff0000ff));
    }
    restored.light.inlineEdit.displayColor = null;
    expect(restored.resolve(false).inlineEditTheme.style.displayStyle, isNull);
  });
}
