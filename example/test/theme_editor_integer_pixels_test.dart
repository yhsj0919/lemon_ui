import 'package:lemon_ui_example/pages/content/hyper_divider_page.dart';
import 'package:lemon_ui_example/pages/selection/hyper_switch_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/main.dart';
import 'package:lemon_ui_example/editor/editor_component_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('未确认控件像素设置写入整数，动态约束合法，缩放保留小数', (tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.binding.setSurfaceSize(const Size(1440, 5000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiExampleApp());
    await tester.pumpAndSettle();
    Future<void> page(String id) async {
      tester
          .widget<EditorComponentNavigation>(
            find.byType(EditorComponentNavigation),
          )
          .onSelected(id);
      if (id == 'hyper-progress-indicator') {
        await tester.pump(const Duration(milliseconds: 300));
      } else {
        await tester.pumpAndSettle();
      }
    }

    HyperSlider slider(String label) => tester.widget<HyperSlider>(
      find.descendant(
        of: find.byKey(ValueKey('editor-number-$label')),
        matching: find.byType(HyperSlider),
      ),
    );
    await page('hyper-badge');
    final height = slider('内容最小高度');
    height.onChanged!(20);
    await tester.pumpAndSettle();
    expect(slider('内容圆角').max, 10);
    slider('内容圆角').onChanged!(1000);
    await tester.pumpAndSettle();
    expect(slider('内容圆角').value, 10);
    slider('内容最小高度').onChanged!(12);
    await tester.pumpAndSettle();
    expect(slider('内容圆角').max, 6);
    expect(slider('内容圆角').value, 6);
    await page('hyper-divider');
    expect(slider('虚线长度').max, 30);
    expect(slider('线段间隔').max, 30);
    expect(slider('线条粗细').max, 20);
    expect(slider('内容与线条间距').max, 64);
    expect(slider('内容图标尺寸').max, 64);
    slider('虚线长度').onChanged!(1000);
    await tester.pumpAndSettle();
    expect(slider('虚线长度').value, 30);
    slider('线条粗细').onChanged!(3.6);
    await tester.pumpAndSettle();
    final divider = find.byType(HyperDividerPage);
    expect(HyperTheme.sizesOf(tester.element(divider)).divider.thickness, 4);
    expect(slider('线条粗细').divisions, isNotNull);
    await page('hyper-progress-indicator');
    expect(slider('细轨道高度').max, 20);
    expect(slider('宽轨道高度').max, 64);
    expect(slider('圆形直径').max, 200);
    expect(slider('无限进度直径').max, 200);
    slider('圆形直径').onChanged!(20);
    await tester.pump(const Duration(milliseconds: 300));
    expect(slider('圆形线宽').max, 10);
    slider('无限进度直径').onChanged!(20);
    await tester.pump(const Duration(milliseconds: 300));
    expect(slider('轨道圆点半径').max, 4);
    await page('hyper-radio');
    expect(slider('标记尺寸').max, 64);
    expect(slider('最小命中尺寸').max, 96);
    slider('标记尺寸').onChanged!(16);
    await tester.pumpAndSettle();
    expect(slider('内部圆点尺寸').max, 16);
    expect(slider('对勾尺寸').max, 16);
    slider('对勾尺寸').onChanged!(10);
    await tester.pumpAndSettle();
    expect(slider('对勾线宽').max, 5);
    await page('hyper-checkbox');
    expect(slider('标记尺寸').max, 64);
    slider('标记尺寸').onChanged!(16);
    await tester.pumpAndSettle();
    expect(slider('标记线宽').max, 7);
    await page('hyper-switch');
    expect(slider('轨道宽度').max, 128);
    expect(slider('轨道高度').max, 64);
    expect(slider('最小命中尺寸').max, 96);
    slider('滑块尺寸').onChanged!(15.3);
    await tester.pumpAndSettle();
    final switchWidget = find.byType(HyperSwitchPage);
    expect(
      HyperTheme.sizesOf(tester.element(switchWidget)).switchSize.thumbSize,
      15,
    );
    final inset = slider('滑块边缘距离');
    expect(inset.min, inset.min.roundToDouble());
    expect(inset.max, inset.max.roundToDouble());
    inset.onChanged!(inset.max + .9);
    await tester.pumpAndSettle();
    expect(
      HyperTheme.sizesOf(tester.element(switchWidget)).switchSize.thumbInset,
      inset.max,
    );
    tester
        .widget<HyperSelect<String>>(
          find.descendant(
            of: find.byKey(const ValueKey('editor-select-状态覆盖')),
            matching: find.byType(HyperSelect<String>),
          ),
        )
        .onChanged!('pressed');
    await tester.pumpAndSettle();
    final scale = slider('交互滑块缩放');
    expect(scale.divisions, isNull);
    scale.onChanged!(1.23);
    await tester.pumpAndSettle();
    expect(slider('交互滑块缩放').value, 1.23);
    expect(tester.takeException(), isNull);
  });
}
