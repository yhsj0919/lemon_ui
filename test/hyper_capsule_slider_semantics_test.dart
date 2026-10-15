import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/src/components/slider/hyper_slider_semantics.dart';

void main() {
  test('最小复现：提供当前值和增大操作却没有增大后的值会触发断言', () {
    final config = SemanticsConfiguration()
      ..value = '50%'
      ..onIncrease = () {};
    expect(
      () => SemanticsNode().updateWith(config: config),
      throwsAssertionError,
    );
  });

  void validate(HyperSliderSemanticsValues values) {
    final config = SemanticsConfiguration()
      ..value = values.label
      ..increasedValue = values.increasedLabel
      ..decreasedValue = values.decreasedLabel
      ..onIncrease = () {}
      ..onDecrease = () {};
    expect(() => SemanticsNode().updateWith(config: config), returnsNormally);
  }

  test('默认格式补齐三项语义，通过真实 SemanticsNode 检查', () {
    final values = HyperSliderSemanticsValues(value: .5, min: 0, max: 1);
    expect(values.label, '50%');
    expect(values.increasedLabel, '55%');
    expect(values.decreasedLabel, '45%');
    expect(values.increased, .55);
    expect(values.decreased, .45);
    validate(values);
  });

  test('非默认范围与自定义单位使用实际数值，步进与键盘保持一致', () {
    final values = HyperSliderSemanticsValues(
      value: 50,
      min: 20,
      max: 120,
      formatter: (v) => '${v.round()} 亮度',
    );
    expect(values.label, '50 亮度');
    expect(values.increasedLabel, '55 亮度');
    expect(values.decreasedLabel, '45 亮度');
    expect(
      HyperSliderSemanticsValues.step(50, 20, 120, true),
      values.increased,
    );
    expect(
      HyperSliderSemanticsValues.step(50, 20, 120, false),
      values.decreased,
    );
    validate(values);
  });

  test('两端、零范围和禁用语义保持有效', () {
    for (final value in [0.0, 1.0]) {
      final values = HyperSliderSemanticsValues(value: value, min: 0, max: 1);
      expect(values.increased, inInclusiveRange(0, 1));
      expect(values.decreased, inInclusiveRange(0, 1));
      validate(values);
    }
    final zero = HyperSliderSemanticsValues(value: 4, min: 4, max: 4);
    expect(zero.label, '0%');
    expect(zero.increased, 4);
    expect(zero.decreased, 4);
    final disabled = SemanticsConfiguration()
      ..value = zero.label
      ..increasedValue = zero.increasedLabel
      ..decreasedValue = zero.decreasedLabel;
    expect(() => SemanticsNode().updateWith(config: disabled), returnsNormally);
  });

  test('自定义回调部分返回空字符串也不会生成不完整语义', () {
    final values = HyperSliderSemanticsValues(
      value: .5,
      min: 0,
      max: 1,
      formatter: (v) => v == .5 ? '中间' : '',
    );
    expect(values.label, '中间');
    expect(values.increasedLabel, '55%');
    expect(values.decreasedLabel, '45%');
    validate(values);
    validate(
      HyperSliderSemanticsValues(
        value: .5,
        min: 0,
        max: 1,
        formatter: (_) => '',
      ),
    );
  });
  test('普通 / 范围滑块保留默认回调空值，不替代 Flutter 原生语义', () {
    expect(hyperSliderSemanticFormatter(null, 0, 1), isNull);
  });

  test('普通 / 范围滑块自定义格式化空值回退，通过真实节点断言', () {
    for (final bounds in [(0.0, 1.0), (20.0, 120.0)]) {
      final (min, max) = bounds;
      final current = min + (max - min) * .5;
      final formatter = hyperSliderSemanticFormatter(
        (value) => value == current ? '当前数值' : '',
        min,
        max,
      )!;
      final config = SemanticsConfiguration()
        ..value = formatter(current)
        ..increasedValue = formatter(min + (max - min) * .6)
        ..decreasedValue = formatter(min + (max - min) * .4)
        ..onIncrease = () {}
        ..onDecrease = () {};
      expect(config.value, '当前数值');
      expect(config.increasedValue, '60%');
      expect(config.decreasedValue, '40%');
      expect(() => SemanticsNode().updateWith(config: config), returnsNormally);
    }
  });

  test('自定义单位内容原样保留，零范围格式化不会产生 NaN', () {
    final formatter = hyperSliderSemanticFormatter(
      (value) => '${value.round()} 度',
      -20,
      80,
    )!;
    expect(formatter(-20), '-20 度');
    expect(formatter(80), '80 度');
    final empty = hyperSliderSemanticFormatter((_) => '', 4, 4)!;
    expect(empty(4), '0%');
  });
}
