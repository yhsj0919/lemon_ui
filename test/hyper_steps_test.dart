import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

HyperStepItem step(Object id, {HyperStepStatus? status, bool enabled = true}) =>
    HyperStepItem(
      id: id,
      title: const Text('步骤'),
      status: status,
      enabled: enabled,
    );
void main() {
  test('默认状态随当前索引推导，末尾索引表示全部完成', () {
    final items = [step('a'), step('b'), step('c')];
    final model = HyperStepModel(items: items, currentStep: 1);
    expect(
      [for (var i = 0; i < 3; i++) model.statusAt(i)],
      [
        HyperStepStatus.completed,
        HyperStepStatus.current,
        HyperStepStatus.pending,
      ],
    );
    final done = HyperStepModel(items: items, currentStep: 3);
    expect([
      for (var i = 0; i < 3; i++) done.statusAt(i),
    ], everyElement(HyperStepStatus.completed));
  });
  test('显式状态覆盖推导，禁用优先且不能导航', () {
    final model = HyperStepModel(
      items: [
        step('a', status: HyperStepStatus.error),
        step('b', enabled: false, status: HyperStepStatus.completed),
        step('c'),
      ],
      currentStep: 2,
    );
    expect(model.statusAt(0), HyperStepStatus.error);
    expect(model.statusAt(1), HyperStepStatus.disabled);
    expect(model.canSelect(0), true);
    expect(model.canSelect(1), false);
    expect(model.canSelect(2), false);
    expect(model.canSelect(-1), false);
    expect(model.canSelect(3), false);
  });
  test('空步骤、非法索引与重复 id', () {
    expect(HyperStepModel(items: [], currentStep: 0).items, isEmpty);
    expect(() => HyperStepModel(items: [], currentStep: 1), throwsRangeError);
    expect(
      () => HyperStepModel(items: [step('a')], currentStep: -1),
      throwsRangeError,
    );
    expect(
      () => HyperStepModel(items: [step('a')], currentStep: 2),
      throwsRangeError,
    );
    expect(
      () => HyperStepModel(items: [step('a'), step('a')], currentStep: 0),
      throwsArgumentError,
    );
    final source = [step('a')];
    final model = HyperStepModel(items: source, currentStep: 0);
    source.clear();
    expect(model.items.length, 1);
    expect(() => model.items.clear(), throwsUnsupportedError);
  });
  test('状态主题合并与实例覆盖保留文字规格', () {
    const theme = HyperStepIndicatorThemeData(
      style: HyperStepStyle(titleStyle: TextStyle(fontSize: 18), nodeSize: 32),
      error: HyperStepStyle(
        titleStyle: TextStyle(color: Colors.red),
        iconSize: 20,
      ),
    );
    final error = theme
        .resolve(HyperStepStatus.error)
        .merge(const HyperStepStyle(iconSize: 22));
    expect(error.titleStyle!.fontSize, 18);
    expect(error.titleStyle!.color, Colors.red);
    expect(error.nodeSize, 32);
    expect(error.iconSize, 22);
    expect(theme.resolve(HyperStepStatus.pending).titleStyle!.color, isNull);
    final merged = theme.merge(
      const HyperStepIndicatorThemeData(
        error: HyperStepStyle(statusLabel: '失败'),
      ),
    );
    expect(merged.error!.iconSize, 20);
    expect(merged.error!.statusLabel, '失败');
  });
  test('样式复制插值和值相等包括尺寸状态文案与动画', () {
    const a = HyperStepStyle(
      nodeSize: 28,
      iconSize: 16,
      connectorThickness: 1,
      duration: Duration(milliseconds: 100),
      statusLabel: '当前',
    );
    final b = a.copyWith(
      nodeSize: 36,
      iconSize: 24,
      duration: const Duration(milliseconds: 200),
      statusLabel: '完成',
    );
    final mid = HyperStepStyle.lerp(a, b, .5);
    expect(mid.nodeSize, 32);
    expect(mid.iconSize, 20);
    expect(mid.duration, const Duration(milliseconds: 150));
    expect(mid.statusLabel, '完成');
    expect(a.copyWith(), a);
    expect(a.copyWith().hashCode, a.hashCode);
    expect(
      HyperStepIndicatorThemeData.lerp(
        const HyperStepIndicatorThemeData(style: a),
        HyperStepIndicatorThemeData(style: b),
        .5,
      ).style,
      mid,
    );
    expect(
      HyperStepperNavigationThemeData.lerp(
        const HyperStepperNavigationThemeData(style: a),
        HyperStepperNavigationThemeData(style: b),
        .5,
      ).style,
      mid,
    );
  });
  test('四端尺寸与两种全局主题独立覆盖', () {
    final theme = HyperThemeData.light();
    for (final sizes in [
      theme.sizes.phone,
      theme.sizes.tablet,
      theme.sizes.desktop,
      theme.sizes.watch,
    ]) {
      final base = sizes.stepIndicator;
      expect(base.nodeSize, sizes.controlHeightXs);
      expect(base.copyWith(), base);
      expect(base.copyWith().hashCode, base.hashCode);
      final changed = base.copyWith(nodeSize: base.nodeSize + 4);
      expect(HyperStepSize.lerp(base, changed, .5).nodeSize, base.nodeSize + 2);
      expect(
        sizes.copyWith(stepIndicator: changed).stepperNavigation,
        sizes.stepperNavigation,
      );
    }
    const navigation = HyperStepperNavigationThemeData(
      style: HyperStepStyle(nodeSize: 40),
    );
    final updated = theme.copyWith(stepperNavigationTheme: navigation);
    expect(updated.stepperNavigationTheme, navigation);
    expect(updated.stepIndicatorTheme, theme.stepIndicatorTheme);
    expect(theme.lerp(updated, 1), updated);
  });
}
