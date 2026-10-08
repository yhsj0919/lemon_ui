import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('主题覆盖保留未修改的动画和按钮字段', () {
    final global = HyperBottomSheetThemeData(
      style: HyperBottomSheetStyle(
        maxWidth: 400,
        dragHandleColor: Colors.teal,
        animationStyle: const AnimationStyle(
          duration: Duration(milliseconds: 240),
          reverseDuration: Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        ),
        buttonTheme: HyperButtonThemeData(
          style: HyperButtonStyle(height: 32),
          filled: HyperButtonStyle(foregroundColor: Colors.white),
        ),
      ),
    );
    final local = HyperBottomSheetThemeData(
      style: HyperBottomSheetStyle(
        animationStyle: const AnimationStyle(
          duration: Duration(milliseconds: 400),
        ),
        buttonTheme: HyperButtonThemeData(
          style: HyperButtonStyle(borderRadius: BorderRadius.circular(4)),
        ),
      ),
    );
    final resolved = global
        .merge(local)
        .style
        .merge(const HyperBottomSheetStyle(height: 320));
    expect(resolved.maxWidth, 400);
    expect(resolved.height, 320);
    expect(resolved.dragHandleColor, Colors.teal);
    expect(
      resolved.animationStyle!.duration,
      const Duration(milliseconds: 400),
    );
    expect(
      resolved.animationStyle!.reverseDuration,
      const Duration(milliseconds: 120),
    );
    expect(resolved.animationStyle!.curve, Curves.easeOutCubic);
    expect(resolved.buttonTheme!.style!.height, 32);
    expect(resolved.buttonTheme!.filled!.foregroundColor, Colors.white);
  });

  test('表面、拖动条、尺寸和动画支持复制插值与值相等', () {
    final start = HyperBottomSheetStyle(
      height: 240,
      maxHeight: 400,
      borderRadius: BorderRadius.circular(8),
      padding: const EdgeInsets.all(12),
      dragHandleSize: const Size(32, 4),
      dragHandlePadding: const EdgeInsets.all(4),
      dragHandleBorderRadius: BorderRadius.circular(2),
      boxShadow: const [BoxShadow(blurRadius: 2)],
      animationStyle: const AnimationStyle(
        duration: Duration(milliseconds: 120),
      ),
    );
    final end = start.copyWith(
      height: 360,
      maxHeight: 600,
      dragHandleSize: const Size(40, 8),
      padding: const EdgeInsets.all(20),
      animationStyle: const AnimationStyle(
        duration: Duration(milliseconds: 360),
      ),
    );
    final mid = HyperBottomSheetStyle.lerp(start, end, .5);
    expect(mid.height, 300);
    expect(mid.maxHeight, 500);
    expect(mid.dragHandleSize, const Size(36, 6));
    expect(mid.padding, const EdgeInsets.all(16));
    expect(mid.animationStyle!.duration, const Duration(milliseconds: 240));
    expect(start.copyWith(), start);
    expect(start.copyWith().hashCode, start.hashCode);
    expect(HyperBottomSheetStyle.lerp(start, end, 0), same(start));
    expect(HyperBottomSheetStyle.lerp(start, end, 1), same(end));
    expect(
      start.merge(const HyperBottomSheetStyle(boxShadow: [])).boxShadow,
      isEmpty,
    );
  });

  test('四端规格及全局主题完整集成，Dialog 主题保持独立', () {
    const sizes = HyperSizeThemeData();
    expect(
      [
        sizes.phone.bottomSheet.maxWidth,
        sizes.tablet.bottomSheet.maxWidth,
        sizes.desktop.bottomSheet.maxWidth,
        sizes.watch.bottomSheet.maxWidth,
      ],
      [320, 400, 640, 180],
    );
    final changed = sizes.copyWith(
      desktop: sizes.desktop.copyWith(
        bottomSheet: sizes.desktop.bottomSheet.copyWith(
          maxWidth: 480,
          radius: 10,
        ),
      ),
    );
    expect(changed.phone.bottomSheet, sizes.phone.bottomSheet);
    expect(changed.desktop.dialog, sizes.desktop.dialog);
    final mid = HyperSizeScheme.lerp(sizes.desktop, changed.desktop, .5);
    expect(mid.bottomSheet.maxWidth, 560);
    expect(changed.desktop.copyWith(), changed.desktop);
    expect(changed.desktop.copyWith().hashCode, changed.desktop.hashCode);
    final base = HyperThemeData.light();
    final themed = base.copyWith(
      bottomSheetTheme: const HyperBottomSheetThemeData(
        style: HyperBottomSheetStyle(height: 360),
      ),
    );
    final end = themed.copyWith(
      bottomSheetTheme: themed.bottomSheetTheme.copyWith(
        style: themed.bottomSheetTheme.style.copyWith(height: 480),
      ),
    );
    expect(themed.copyWith(), themed);
    expect(themed.copyWith().hashCode, themed.hashCode);
    expect(themed.lerp(end, .5).bottomSheetTheme.style.height, 420);
    expect(themed.dialogTheme, base.dialogTheme);
    expect(themed.buttonTheme, base.buttonTheme);
  });

  test('零时长覆盖保留其他动画字段', () {
    const style = HyperBottomSheetStyle(
      animationStyle: AnimationStyle(
        duration: Duration(milliseconds: 240),
        curve: Curves.easeOut,
      ),
    );
    final zero = style.merge(
      const HyperBottomSheetStyle(animationStyle: AnimationStyle.noAnimation),
    );
    expect(zero.animationStyle!.duration, Duration.zero);
    expect(zero.animationStyle!.reverseDuration, Duration.zero);
    expect(zero.animationStyle!.curve, Curves.easeOut);
  });
}
