import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('统一状态优先级稳定且禁用最高', () {
    expect(
      HyperControlState.highestOf({
        HyperControlState.hovered,
        HyperControlState.pressed,
        HyperControlState.disabled,
      }),
      HyperControlState.disabled,
    );
    expect(
      HyperControlState.highestOf({
        HyperControlState.focused,
        HyperControlState.pressed,
      }),
      HyperControlState.pressed,
    );
    expect(
      HyperControlState.highestOf({
        HyperControlState.pressed,
        HyperControlState.secondaryPressed,
      }),
      HyperControlState.secondaryPressed,
    );
    expect(
      HyperControlState.highestOf({
        HyperControlState.pressed,
        HyperControlState.longPressed,
      }),
      HyperControlState.longPressed,
    );
    expect(HyperControlState.highestOf({}), isNull);
  });

  test('状态映射按统一优先级解析并回退默认值', () {
    final value = HyperStateValue<String>.fromMap(
      fallback: '默认',
      values: const {
        HyperControlState.hovered: '悬停',
        HyperControlState.pressed: '按压',
        HyperControlState.disabled: '禁用',
      },
    );

    expect(value.resolve({}), '默认');
    expect(value.resolve({HyperControlState.hovered}), '悬停');
    expect(
      value.resolve({HyperControlState.hovered, HyperControlState.pressed}),
      '按压',
    );
    expect(
      value.resolve({HyperControlState.pressed, HyperControlState.disabled}),
      '禁用',
    );
  });

  test('自定义解析器能够处理状态组合且集合不可修改', () {
    late Set<HyperControlState> received;
    final value = HyperStateValue<String>.resolveWith((states) {
      received = states;
      return states.contains(HyperControlState.selected) &&
              states.contains(HyperControlState.focused)
          ? '选中且聚焦'
          : '其他';
    });
    expect(
      value.resolve({HyperControlState.selected, HyperControlState.focused}),
      '选中且聚焦',
    );
    expect(
      () => received.add(HyperControlState.hovered),
      throwsUnsupportedError,
    );
  });

  test('固定值、转换和插值保持状态语义', () {
    const start = HyperStateValue<Color>.all(Colors.black);
    final end = HyperStateValue<Color>.fromMap(
      fallback: Colors.white,
      values: const {HyperControlState.pressed: Colors.red},
    );
    final middle = HyperStateValue.lerp<Color>(
      start,
      end,
      .5,
      (a, b, t) => Color.lerp(a, b, t)!,
    );

    expect(middle.resolve({}), Color.lerp(Colors.black, Colors.white, .5));
    expect(
      middle.resolve({HyperControlState.pressed}),
      Color.lerp(Colors.black, Colors.red, .5),
    );
    expect(
      end.map((color) => color.toARGB32()).resolve({}),
      Colors.white.toARGB32(),
    );
  });

  test('映射会防御性复制并支持值相等', () {
    final source = <HyperControlState, String>{HyperControlState.hovered: '悬停'};
    final first = HyperStateValue<String>.fromMap(
      fallback: '默认',
      values: source,
    );
    source[HyperControlState.hovered] = '已修改';
    final second = HyperStateValue<String>.fromMap(
      fallback: '默认',
      values: const {HyperControlState.hovered: '悬停'},
    );
    expect(first.resolve({HyperControlState.hovered}), '悬停');
    expect(first, second);
    expect(first.hashCode, second.hashCode);
  });
}
