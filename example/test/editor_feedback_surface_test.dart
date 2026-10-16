import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:lemon_ui_example/editor/editor_dimension_limits.dart';
import 'package:lemon_ui_example/editor/editor_review_fields.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/gallery/gallery_registry.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('字号编辑上限独立于继承值，并保留合法整数边界', () {
    final s = HyperThemeData.light().sizes.desktop;
    final bounds = editorReviewBounds(
      'appBar',
      '展开标题字号',
      s,
      const Size(1280, 800),
      min: 1.1,
      max: 64.9,
      typographyDisplaySize: 32,
    );
    expect(bounds.min, 2);
    expect(bounds.max, 64);
    expect(bounds.max, greaterThan(32));
    expect(editorReviewFontSizeLimit(40), 80);
  });
  test('导航变体、状态、材质、轮廓和空阴影保存导入', () {
    final d = EditorThemeDocument();
    d.light.reviews.tabBarSeparated.backgroundColor = const EditorColor(
      argb: 0xFF112233,
    );
    d.light.reviews.tabBarSeparatedSelected.foregroundColor = const EditorColor(
      argb: 0xFFAA3311,
    );
    d.light.reviews.tabBarSeparated.materialKind = 'frostedGlass';
    d.light.reviews.tabBarSeparated.materialBlurX = 13;
    d.light.reviews.tabBarSeparated.borderWidth = 2;
    d.light.reviews.tabBarSeparated.shadow.shadows = [];
    d.light.reviews.sidebarSelected.backgroundColor = const EditorColor(
      argb: 0xFF445566,
    );
    d.light.reviews.sidebarPopup.shadow.shadows = [];
    d.light.reviews.breadcrumbHighlight.foregroundColor = const EditorColor(
      argb: 0xFF778899,
    );
    final copy = EditorThemeDocument.decode(d.encode());
    final theme = copy.resolve(false);
    final tabs = theme.tabBarTheme.resolve(HyperTabBarVariant.separated);
    expect(tabs.trackStyle!.background!.color, const Color(0xFF112233));
    expect(tabs.trackStyle!.material!.blurSigmaX, 13);
    expect((tabs.trackStyle!.border! as Border).top.width, 2);
    expect(tabs.trackStyle!.boxShadow, isEmpty);
    expect(tabs.selectedForegroundColor, const Color(0xFFAA3311));
    expect(
      theme.sidebarTheme.style!.selectedItemSurfaceStyle!.background!.color,
      const Color(0xFF445566),
    );
    expect(theme.sidebarTheme.style!.popupCardStyle!.boxShadow, isEmpty);
    expect(
      theme.breadcrumbTheme.style.highlightForegroundColor,
      const Color(0xFF778899),
    );
    expect(
      copy.resolve(true).tabBarTheme.separated?.trackStyle?.background,
      isNull,
    );
    expect(copy.encode(), d.encode());
  });

  test('范围按实际关联尺寸收紧，通知中心只保留业务示例', () {
    final s = HyperThemeData.light().sizes.desktop;
    final viewport = editorPreviewSize(
      HyperDeviceType.desktop,
      landscape: true,
    );
    final icon = editorReviewBounds(
      'notification',
      '关闭图标尺寸',
      s,
      viewport,
      min: 0,
      max: 64,
      typographyDisplaySize: 24,
    );
    expect(icon.max, s.notification.closeButtonSize);
    final spacing = editorReviewBounds(
      'notification',
      '图标与内容间距',
      s,
      viewport,
      min: 0,
      max: 64,
      typographyDisplaySize: 24,
    );
    expect(spacing.max, s.minimumInteractiveDimension);
    final m = EditorReviewFields()
      ..closeButtonSize = 7
      ..closeIconSize = 24;
    constrainEditorReviewDimensions('notification', m, s);
    expect(m.closeIconSize, 7);
    expect(
      gallerySections
          .firstWhere((s) => s.title == '业务组合示例')
          .items
          .any((i) => i.id == 'hyper-notification-center'),
      isTrue,
    );
    expect(
      gallerySections
          .firstWhere((s) => s.title == '反馈与状态')
          .items
          .any((i) => i.id == 'hyper-notification-center'),
      isFalse,
    );
    final old = EditorReviewCollection.fromJson({
      'notificationCenter': {'titleStyleSize': 28},
    });
    expect(old.toJson()['notificationCenter'], {'titleStyleSize': 28});
  });

  testWidgets('业务通知页面编辑单条通知表面且尺寸整数写入', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1600, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-notification-center');
    await tester.pumpAndSettle();
    final panel = find.byKey(const ValueKey('editor-panel-通知卡片'));
    final scroll = find
        .descendant(of: panel, matching: find.byType(Scrollable))
        .first;
    Future<Finder> field(String key) async {
      tester.state<ScrollableState>(scroll).position.jumpTo(0);
      await tester.pump();
      final f = find.byKey(ValueKey(key));
      await tester.scrollUntilVisible(f, 200, scrollable: scroll);
      return f;
    }

    final material = await field('editor-select-表面材质');
    tester
        .widget<HyperSelect<String>>(
          find.descendant(
            of: material,
            matching: find.byType(HyperSelect<String>),
          ),
        )
        .onChanged!('frostedGlass');
    await tester.pumpAndSettle();
    final blur = await field('editor-number-材质水平模糊');
    tester
        .widget<HyperSlider>(
          find.descendant(of: blur, matching: find.byType(HyperSlider)),
        )
        .onChanged!(12.8);
    await tester.pumpAndSettle();
    final background = await field('editor-color-背景');
    tester
        .widget<HyperColorPickerField>(
          find.descendant(
            of: background,
            matching: find.byType(HyperColorPickerField),
          ),
        )
        .onChanged!(Colors.purple);
    await tester.pumpAndSettle();
    final closeSize = await field('editor-number-关闭按钮尺寸');
    tester
        .widget<HyperSlider>(
          find.descendant(of: closeSize, matching: find.byType(HyperSlider)),
        )
        .onChanged!(7.4);
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(HyperNotification).first);
    final theme = HyperTheme.of(context);
    expect(
      theme.notificationTheme.style.material!.kind,
      HyperSurfaceMaterialKind.frostedGlass,
    );
    expect(theme.notificationTheme.style.material!.blurSigmaX, 13);
    expect(
      theme.notificationTheme.style.background!.color!.toARGB32(),
      Colors.purple.toARGB32(),
    );
    expect(HyperTheme.sizesOf(context).notification.closeButtonSize, 7);
    expect(
      HyperTheme.sizesOf(context).notification.closeIconSize,
      lessThanOrEqualTo(7),
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}
