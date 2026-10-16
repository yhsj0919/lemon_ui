import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_review_fields.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('步骤设置写入整数并联动收紧图标，重置状态保留尺寸', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1600, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-steps');
    await tester.pumpAndSettle();
    final panel = find.byKey(const ValueKey('editor-panel-步骤指示器 / 步骤导航'));
    final scroll = find
        .descendant(of: panel, matching: find.byType(Scrollable))
        .first;
    Future<void> number(String name, double value) async {
      expect(panel, findsOneWidget);
      tester.state<ScrollableState>(scroll).position.jumpTo(0);
      await tester.pump();
      final field = find.byKey(ValueKey('editor-number-$name'));
      await tester.scrollUntilVisible(field, 200, scrollable: scroll);
      tester
          .widget<HyperSlider>(
            find.descendant(of: field, matching: find.byType(HyperSlider)),
          )
          .onChanged!(value);
      await tester.pumpAndSettle();
    }

    Future<void> choose(String label, String value) async {
      tester.state<ScrollableState>(scroll).position.jumpTo(0);
      await tester.pump();
      final field = find.byKey(ValueKey('editor-select-$label'));
      tester
          .widget<HyperSelect<String>>(
            find.descendant(
              of: field,
              matching: find.byType(HyperSelect<String>),
            ),
          )
          .onChanged!(value);
      await tester.pumpAndSettle();
    }

    HyperThemeData preview() =>
        HyperTheme.of(tester.element(find.byType(HyperStepIndicator).first));
    await number('节点尺寸', 20.4);
    await number('图标尺寸', 19.8);
    await number('节点尺寸', 9.2);
    expect(preview().sizes.desktop.stepIndicator.nodeSize, 9);
    expect(preview().sizes.desktop.stepIndicator.iconSize, 9);
    await choose('步骤状态', 'error');
    await choose('标题字重', '700');
    expect(
      preview().stepIndicatorTheme.error!.titleStyle!.fontWeight,
      FontWeight.w700,
    );
    final reset = find.text('恢复当前对象 / 状态继承');
    await tester.ensureVisible(reset);
    await tester.tap(reset);
    await tester.pumpAndSettle();
    expect(preview().stepIndicatorTheme.error?.titleStyle, isNull);
    expect(preview().sizes.desktop.stepIndicator.nodeSize, 9);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  test('反馈与导航保存导入、状态与设备隔离', () {
    final d = EditorThemeDocument();
    d.desktop.reviews.notification.iconSize = 31;
    d.phone.reviews.notification.iconSize = 19;
    d.light.reviews.alertError.iconColor = const EditorColor(argb: 0xFF123456);
    d.light.reviews.notificationUnread.titleStyleColor = const EditorColor(
      argb: 0xFFABCDEF,
    );
    d.light.reviews.paginationSelected.backgroundColor = const EditorColor(
      argb: 0xFF654321,
    );
    d.desktop.reviews.tabBar.height = 43;
    d.light.reviews.tooltip.shadow.shadows = [];
    final copy = EditorThemeDocument.decode(d.encode());
    final desktop = copy.resolve(false, deviceType: HyperDeviceType.desktop);
    expect(desktop.sizes.desktop.notification.iconSize, 31);
    expect(desktop.sizes.phone.notification.iconSize, 19);
    expect(desktop.sizes.desktop.tabBar.height, 43);
    expect(desktop.alertTheme.error!.iconColor, const Color(0xFF123456));
    expect(desktop.alertTheme.success?.iconColor, isNull);
    expect(
      desktop.notificationTheme.unread!.titleStyle!.color,
      const Color(0xFFABCDEF),
    );
    expect(
      desktop.paginationTheme.style.selectedStyle!.background!.color,
      const Color(0xFF654321),
    );
    expect(desktop.tooltipTheme.style!.boxShadow, isEmpty);
    expect(copy.resolve(true).alertTheme.error?.iconColor, isNull);
    expect(copy.encode(), d.encode());
  });
  test('节点与圆角联动约束', () {
    final s = HyperThemeData.light().sizes.desktop;
    final m = EditorReviewFields()
      ..nodeSize = 9
      ..iconSize = 30
      ..connectorThickness = 15
      ..interactionRadius = 20;
    constrainEditorReviewDimensions('stepIndicator', m, s);
    expect(m.iconSize, 9);
    expect(m.connectorThickness, 4);
    expect(m.interactionRadius, 4);
    final tabs = EditorReviewFields()
      ..height = 13
      ..segmentedRadius = 20
      ..separatedRadius = 20
      ..underlineThickness = 20;
    constrainEditorReviewDimensions('tabBar', tabs, s);
    expect(tabs.segmentedRadius, 6);
    expect(tabs.separatedRadius, 6);
    expect(tabs.underlineThickness, 6);
    expect(
      () => EditorReviewFields.fromJson({'unknown': 1}),
      throwsFormatException,
    );
  });
  testWidgets('反馈和导航页面均具有设置入口且可构建', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1600, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    for (final page in const [
      'hyper-app-bar',
      'hyper-drawer',
      'hyper-notification-center',
      'hyper-notification',
      'hyper-loading-overlay',
      'hyper-notice',
      'hyper-bottom-sheet',
      'hyper-message',
      'hyper-dialog',
      'hyper-empty-state',
      'hyper-skeleton',
      'hyper-sidebar',
      'hyper-tab-bar',
      'hyper-steps',
      'hyper-pagination',
      'hyper-page-indicator',
      'hyper-breadcrumb',
      'hyper-top-navigation',
      'hyper-tooltip',
    ]) {
      tester
          .widget<EditorComponentNavigation>(
            find.byType(EditorComponentNavigation),
          )
          .onSelected(page);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump();
      expect(
        find.text('尺寸按设备保存，外观按亮暗保存；局部主题与实例覆盖以 Demo 标记为准。'),
        findsOneWidget,
        reason: page,
      );
      expect(tester.takeException(), isNull, reason: page);
      Future<void> variants(String label) async {
        final panel = find.byWidgetPredicate(
          (widget) =>
              widget is ListView &&
              widget.key is ValueKey<String> &&
              (widget.key! as ValueKey<String>).value.startsWith(
                'editor-panel-',
              ),
        );
        final scroll = find
            .descendant(of: panel, matching: find.byType(Scrollable))
            .first;
        tester.state<ScrollableState>(scroll).position.jumpTo(0);
        await tester.pump();
        final field = find.byKey(ValueKey('editor-select-$label'));
        if (field.evaluate().isEmpty) return;
        final select = find.descendant(
          of: field,
          matching: find.byType(HyperSelect<String>),
        );
        final options = tester
            .widget<HyperSelect<String>>(select)
            .options
            .map((o) => o.value)
            .toList();
        for (final option in options) {
          tester.widget<HyperSelect<String>>(select).onChanged!(option);
          await tester.pump();
          await tester.pump(const Duration(milliseconds: 300));
          await tester.pump();
          expect(
            tester.takeException(),
            isNull,
            reason: '$page $label $option',
          );
        }
      }

      await variants('编辑对象');
      await variants('交互状态');
      await variants('提示状态');
      await variants('步骤状态');
      await variants('编辑范围');
    }
    await tester.pumpWidget(const SizedBox());
  });
}
