import 'package:lemon_ui_example/pages/selection/hyper_slider_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/editor/editor_theme_document.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('胶囊尺寸关联约束与状态重置保留其他范围', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1600, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-slider');
    await tester.pumpAndSettle();
    Finder getPanel() => find.byKey(const ValueKey('editor-panel-滑块'));
    Finder getScroll() => find
        .descendant(of: getPanel(), matching: find.byType(Scrollable))
        .first;
    Future<void> choose(String label, String value) async {
      tester.state<ScrollableState>(getScroll()).position.jumpTo(0);
      await tester.pump();
      final f = find.byKey(ValueKey('editor-select-$label'));
      final select = tester.widget<HyperSelect<String>>(
        find.descendant(of: f, matching: find.byType(HyperSelect<String>)),
      );
      select.onChanged!(value);
      await tester.pumpAndSettle();
    }

    Future<void> number(String label, double value) async {
      tester.state<ScrollableState>(getScroll()).position.jumpTo(0);
      await tester.pump();
      final f = find.byKey(ValueKey('editor-number-$label'));
      await tester.scrollUntilVisible(f, 100, scrollable: getScroll());
      tester
          .widget<HyperSlider>(
            find.descendant(of: f, matching: find.byType(HyperSlider)),
          )
          .onChanged!(value);
      await tester.pumpAndSettle();
    }

    await choose('编辑对象', 'capsule');
    await number('胶囊宽度', 64);
    await number('胶囊图标尺寸', 30);
    await number('胶囊宽度', 24);
    final preview = tester.element(find.byType(HyperSliderPage));
    final metrics = HyperTheme.sizesOf(preview).slider;
    expect(
      metrics.capsuleIconSize,
      lessThanOrEqualTo(metrics.capsuleWidth - 2 * metrics.capsuleIconInset),
    );
    expect(metrics.capsuleIconSize, metrics.capsuleIconSize.roundToDouble());
    await choose('编辑对象', 'standard');
    await choose('状态覆盖', 'pressed');
    await number('按下滑块缩放', 1.5);
    await choose('状态覆盖', 'default');
    await number('轨道粗细', 20);
    await choose('状态覆盖', 'pressed');
    final reset = find.text('重置当前编辑范围');
    await tester.ensureVisible(reset);
    await tester.tap(reset);
    await tester.pumpAndSettle();
    expect(HyperTheme.sizesOf(preview).slider.trackHeight, 20);
    expect(HyperTheme.of(preview).sliderTheme.style.pressedThumbScale, isNull);
    expect(tester.takeException(), isNull);
  });
  test('四类输入设置保存导入、设备尺寸与亮暗隔离', () {
    final d = EditorThemeDocument();
    d.light.sliderInput.input.bufferColor = const EditorColor(argb: 0xFF123456);
    d.desktop.sliderInput
      ..trackHeight = 10
      ..thinTrackHeight = 3
      ..thumbRadius = 8
      ..capsuleWidth = 56;
    d.light.sliderInput.input
      ..activeTrackColor = const EditorColor(argb: 0xFFFF0000)
      ..capsuleOverscrollScale = 1.1
      ..pressedThumbScale = 1.2;
    d.desktop.segmentedInput
      ..height = 42
      ..fontSize = 18
      ..padding = 4;
    d.light.segmentedGroupInput.input.backgroundColor = const EditorColor(
      argb: 0xFF00FF00,
    );
    d.light.segmentedSelectedInput.foreground = const EditorColor(
      argb: 0xFF0000FF,
    );
    d.desktop.colorPickerInput
      ..width = 300
      ..paletteHeight = 180
      ..markerRadius = 7;
    d.light.colorPickerInput.input
      ..hueSnapDegrees = 5
      ..centerRadiusFraction = .2;
    d.desktop.iconButtonInput
      ..width = 44
      ..iconSize = 20
      ..progressSize = 16;
    d.light.iconButtonFilledInput.foreground = const EditorColor(
      argb: 0xFFFFFF00,
    );
    final r = EditorThemeDocument.decode(d.encode());
    expect(r.encode(), d.encode());
    final t = r.resolve(false);
    final sizes = t.sizes.resolve(HyperDeviceType.desktop);
    expect(sizes.slider.trackHeight, 10);
    expect(t.sliderTheme.style.bufferColor, const Color(0xFF123456));
    expect(sizes.slider.thinTrackHeight, 3);
    expect(sizes.slider.capsuleWidth, 56);
    expect(t.sliderTheme.style.activeTrackColor, const Color(0xFFFF0000));
    expect(t.segmentedButtonTheme.style.group.itemHeight, 42);
    expect(
      t.segmentedButtonTheme.style.group.backgroundColor,
      const Color(0xFF00FF00),
    );
    expect(
      t.segmentedButtonTheme.style.selectedButton!.foregroundColor,
      const Color(0xFF0000FF),
    );
    expect(t.colorPickerTheme.style!.width, 300);
    expect(t.colorPickerTheme.style!.hueSnapDegrees, 5);
    expect(
      t.iconButtonTheme.resolve(HyperIconButtonVariant.filled).foregroundColor,
      const Color(0xFFFFFF00),
    );
    expect(
      t.iconButtonTheme.resolve(HyperIconButtonVariant.ghost).foregroundColor,
      isNull,
    );
    expect(
      r
          .resolve(false, deviceType: HyperDeviceType.phone)
          .colorPickerTheme
          .style!
          .width,
      isNull,
    );
    expect(r.resolve(true).sliderTheme.style.activeTrackColor, isNull);
  });
  testWidgets('三个输入工作区提供设置，颜色选择器仅预览', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1600, 1100));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    for (final entry in const {
      'hyper-slider': '轨道粗细',
      'hyper-segmented-button': '子项高度',
      'hyper-icon-button': '按钮边长',
    }.entries) {
      tester
          .widget<EditorComponentNavigation>(
            find.byType(EditorComponentNavigation),
          )
          .onSelected(entry.key);
      await tester.pumpAndSettle();
      expect(find.text('重置当前编辑范围'), findsOneWidget);
      final property = find.byKey(ValueKey('editor-number-${entry.value}'));
      final panel = find
          .ancestor(of: find.text('重置当前编辑范围'), matching: find.byType(ListView))
          .first;
      final scrollable = find
          .descendant(of: panel, matching: find.byType(Scrollable))
          .first;
      await tester.scrollUntilVisible(property, 100, scrollable: scrollable);
      final slider = tester.widget<HyperSlider>(
        find.descendant(of: property, matching: find.byType(HyperSlider)),
      );
      slider.onChanged!(30.7);
      await tester.pumpAndSettle();
      final updated = tester.widget<HyperSlider>(
        find.descendant(of: property, matching: find.byType(HyperSlider)),
      );
      expect(updated.value, updated.value.roundToDouble());
      expect(tester.takeException(), isNull);
    }
    tester
        .widget<EditorComponentNavigation>(
          find.byType(EditorComponentNavigation),
        )
        .onSelected('hyper-color-picker');
    await tester.pumpAndSettle();
    expect(find.text('本页仅提供 Demo 预览，外观跟随主题。'), findsOneWidget);
    expect(find.text('重置当前编辑范围'), findsNothing);
  });
}
