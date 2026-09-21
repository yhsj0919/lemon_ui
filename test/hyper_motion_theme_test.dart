import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('默认提供快速、标准、强调和即时四档动画', () {
    const motion = HyperMotionThemeData();
    expect(motion.durationFor(HyperMotionSpeed.instant), Duration.zero);
    expect(
      motion.durationFor(HyperMotionSpeed.fast),
      const Duration(milliseconds: 120),
    );
    expect(
      motion.durationFor(HyperMotionSpeed.standard),
      const Duration(milliseconds: 240),
    );
    expect(
      motion.durationFor(HyperMotionSpeed.emphasized),
      const Duration(milliseconds: 360),
    );
  });

  test('减少动画会显式返回零时长', () {
    const motion = HyperMotionThemeData();
    expect(
      motion.durationFor(HyperMotionSpeed.emphasized, disableAnimations: true),
      Duration.zero,
    );
    expect(motion.curveFor(HyperMotionSpeed.standard), Curves.easeOutCubic);
  });

  test('copyWith 只替换显式动画参数', () {
    const motion = HyperMotionThemeData();
    final changed = motion.copyWith(
      standardDuration: const Duration(milliseconds: 300),
      spring: const SpringDescription(mass: 1, stiffness: 500, damping: 38),
    );
    expect(changed.standardDuration, const Duration(milliseconds: 300));
    expect(changed.fastDuration, motion.fastDuration);
    expect(changed.spring.stiffness, 500);
  });

  test('lerp 插值时长和弹簧数值并保持端点', () {
    const start = HyperMotionThemeData();
    final end = start.copyWith(
      standardDuration: const Duration(milliseconds: 400),
      spring: const SpringDescription(mass: 2, stiffness: 620, damping: 44),
    );
    expect(HyperMotionThemeData.lerp(start, end, 0), same(start));
    expect(HyperMotionThemeData.lerp(start, end, 1), same(end));
    final middle = HyperMotionThemeData.lerp(start, end, .5);
    expect(middle.standardDuration, const Duration(milliseconds: 320));
    expect(middle.spring.mass, 1.5);
    expect(middle.spring.stiffness, 520);
    expect(middle.spring.damping, 39);
  });
}
