import 'package:lemon_ui_example/pages/content/hyper_avatar_page.dart';
import 'package:lemon_ui_example/pages/content/hyper_icon_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';

void main() {
  testWidgets('实际头像Demo堆叠重叠与排列间距分别响应编辑', (tester) async {
    final d = EditorThemeDocument();
    Future<void> render() async {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: d.resolve(false),
            duration: Duration.zero,
            child: const HyperAvatarPage(),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));
    }

    // 前两个普通组是横向堆叠和无重叠排列。
    await tester.binding.setSurfaceSize(const Size(1400, 4000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await render();
    Finder group(HyperAvatarGroupLayout layout) => find
        .byWidgetPredicate((w) => w is HyperAvatarGroup && w.layout == layout)
        .first;
    final stackBefore = tester
        .getSize(group(HyperAvatarGroupLayout.horizontal))
        .width;
    final rowBefore = tester.getSize(group(HyperAvatarGroupLayout.row)).width;
    d.desktop.avatarContent.overlap = 20;
    d.desktop.avatarContent.spacing = 20;
    await render();
    expect(
      tester.getSize(group(HyperAvatarGroupLayout.horizontal)).width,
      lessThan(stackBefore),
    );
    expect(
      tester.getSize(group(HyperAvatarGroupLayout.row)).width,
      greaterThan(rowBefore),
    );
    expect(tester.takeException(), isNull);
  });
  test('头像组设置写入头像组主题', () {
    final d = EditorThemeDocument();
    d.desktop.avatarContent
      ..overlap = 13
      ..spacing = 9
      ..ringWidth = 3
      ..iconSize = 17
      ..radius = 6;
    d.light.avatarContent.content.ringColor = const EditorColor(
      argb: 0xFFFF0000,
    );
    final theme = EditorThemeDocument.decode(d.encode())
        .resolve(false)
        .avatarTheme;
    expect(theme.groupStyle.overlap, 13);
    expect(theme.groupStyle.spacing, 9);
    expect(theme.groupStyle.ringWidth, 3);
    expect(theme.groupStyle.ringColor, const Color(0xFFFF0000));
    expect(theme.groupStyle.iconSize, 17);
    expect(theme.groupStyle.radius, 6);
    expect(theme.style.iconSize, 17);
  });
  testWidgets('头像尺寸编辑重建不更换图片实例', (tester) async {
    Future<void> renderAvatar(double size) => tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light().copyWith(
            avatarTheme: HyperAvatarThemeData(
              style: HyperAvatarStyle(size: size),
            ),
          ),
          duration: Duration.zero,
          child: const HyperAvatarPage(),
        ),
      ),
    );
    await renderAvatar(32);
    final avatar = find.byWidgetPredicate(
      (w) => w is HyperAvatar && w.semanticsLabel == '本地图片示例',
    );
    final image = tester.widget<HyperAvatar>(avatar).image;
    await renderAvatar(48);
    expect(identical(tester.widget<HyperAvatar>(avatar).image, image), isTrue);
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.getSize(avatar).width, 48);
    expect(tester.takeException(), isNull);
  });
  testWidgets('Icon Demo保留编辑器主题全部属性，显式示例独立覆盖', (tester) async {
    final d = EditorThemeDocument();
    d.desktop.iconContent.iconExtent = 42;
    d.light.iconContent.content
      ..foregroundColor = const EditorColor(argb: 0xFFFF0000)
      ..iconFill = .7
      ..iconWeight = 600
      ..iconGrade = 100
      ..iconOpticalSize = 40;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: d.resolve(false),
          duration: Duration.zero,
          child: const HyperIconPage(),
        ),
      ),
    );
    final icon = tester.widget<Icon>(
      find.descendant(
        of: find.byKey(const Key('icon-theme-preview')),
        matching: find.byType(Icon),
      ),
    );
    expect(icon.size, 42);
    expect(icon.color, const Color(0xFFFF0000));
    expect(icon.fill, .7);
    expect(icon.weight, 600);
    expect(icon.grade, 100);
    expect(icon.opticalSize, 40);
    expect(tester.takeException(), isNull);
  });
  test('内容设置四端与亮暗保存导入', () {
    final d = EditorThemeDocument();
    d.desktop.treeContent.indent = 27;
    d.phone.treeContent.indent = 17;
    d.desktop.resultContent.iconSize = 44;
    d.desktop.descriptionContent.columnSpacing = 19;
    d.desktop.timelineContent.nodeSize = 15;
    d.desktop.timelineContent.iconSize = 21;
    d.desktop.avatarContent.avatarMedium = 40;
    d.desktop.listTileContent.trailingIconSize = 22;
    d.desktop.textContent.textStyleSize = 18;
    d.desktop.iconContent.iconExtent = 25;
    d.light.treeContent.content.foregroundColor = const EditorColor(
      semantic: 'primary',
    );
    final r = EditorThemeDocument.decode(d.encode());
    expect(r.encode(), d.encode());
    final theme = r.resolve(false);
    expect(theme.treeViewTheme.style.indent, 27);
    expect(
      r
          .resolve(false, deviceType: HyperDeviceType.phone)
          .treeViewTheme
          .style
          .indent,
      17,
    );
    expect(theme.treeViewTheme.style.foregroundColor, theme.colors.primary);
    expect(theme.resultTheme.style.iconSize, 44);
    final timeline = theme.sizes.resolve(HyperDeviceType.desktop).timeline;
    expect(timeline.nodeSize, 15);
    expect(timeline.iconSize, 21);
    expect(theme.timelineTheme.style.nodeSize, isNull);
    expect(theme.timelineTheme.style.iconSize, isNull);
    expect(theme.textComponentTheme.style!.fontSize, 18);
  });
  testWidgets('内容工作区入口均可渲染', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1440, 5000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    for (final id in [
      'hyper-tree-view',
      'hyper-result',
      'hyper-description-list',
      'hyper-timeline',
      'hyper-text',
      'hyper-icon',
      'hyper-avatar',
      'hyper-list-tile',
    ]) {
      tester
          .widget<EditorComponentNavigation>(
            find.byType(EditorComponentNavigation),
          )
          .onSelected(id);
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.text('恢复当前组件继承'), findsOneWidget);
      expect(tester.takeException(), isNull);
    }
  });
}
