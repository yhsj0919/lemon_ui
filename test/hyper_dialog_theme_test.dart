import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('全局、局部和实例只覆盖显式字段', () {
    final global = HyperDialogThemeData(
      style: HyperDialogStyle(
        border: Border.all(color: Colors.red),
        maxWidth: 400,
        alignment: AlignmentDirectional.topEnd,
      ),
    );
    final local = HyperDialogThemeData(
      style: HyperDialogStyle(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        buttonTheme: HyperButtonThemeData(style: HyperButtonStyle(height: 32)),
      ),
    );
    final resolved = global
        .merge(local)
        .style
        .merge(const HyperDialogStyle(width: 280));
    expect(resolved.border, global.style.border);
    expect(resolved.maxWidth, 400);
    expect(resolved.width, 280);
    expect(resolved.alignment, AlignmentDirectional.topEnd);
    expect(resolved.borderRadius, local.style.borderRadius);
    expect(resolved.buttonTheme?.style?.height, 32);
  });

  test('位置、边框、按钮与动效的复制和插值', () {
    final start = HyperDialogStyle(
      width: 280,
      maxWidth: 320,
      border: Border.all(color: Colors.red, width: 1),
      borderRadius: BorderRadius.circular(8),
      padding: const EdgeInsets.all(12),
      alignment: Alignment.topLeft,
      duration: const Duration(milliseconds: 120),
      background: const HyperFill.color(Colors.red),
      material: HyperSurfaceMaterial.solid(
        background: const HyperFill.color(Colors.white),
      ),
      boxShadow: const [BoxShadow(blurRadius: 2)],
      buttonTheme: HyperButtonThemeData(style: HyperButtonStyle(height: 32)),
    );
    final end = start.copyWith(
      width: 360,
      maxWidth: 400,
      border: Border.all(color: Colors.blue, width: 3),
      borderRadius: BorderRadius.circular(16),
      padding: const EdgeInsets.all(20),
      alignment: Alignment.bottomRight,
      duration: const Duration(milliseconds: 240),
      buttonTheme: HyperButtonThemeData(style: HyperButtonStyle(height: 48)),
    );
    final middle = HyperDialogStyle.lerp(start, end, .5);
    expect(middle.width, 320);
    expect(middle.maxWidth, 360);
    expect(middle.borderRadius, BorderRadius.circular(12));
    expect(middle.padding, const EdgeInsets.all(16));
    expect(middle.alignment, Alignment.center);
    expect(middle.duration, const Duration(milliseconds: 180));
    expect(middle.buttonTheme?.style?.height, 40);
    expect(HyperDialogStyle.lerp(start, end, 0), same(start));
    expect(HyperDialogStyle.lerp(start, end, 1), same(end));
    expect(start.copyWith(), start);
    expect(start.copyWith().hashCode, start.hashCode);
    expect(
      start.merge(const HyperDialogStyle(boxShadow: [])).boxShadow,
      isEmpty,
    );
  });

  test('四端尺寸集中管理，覆盖不改变其他设备', () {
    const sizes = HyperSizeThemeData();
    final changed = sizes.copyWith(
      desktop: sizes.desktop.copyWith(
        dialog: sizes.desktop.dialog.copyWith(maxWidth: 520, radius: 10),
      ),
    );
    expect(changed.desktop.dialog.maxWidth, 520);
    expect(changed.desktop.dialog.radius, 10);
    expect(changed.phone.dialog, sizes.phone.dialog);
    expect(changed.tablet.dialog, sizes.tablet.dialog);
    expect(changed.watch.dialog, sizes.watch.dialog);
    final half = HyperDialogSize.lerp(
      sizes.desktop.dialog,
      changed.desktop.dialog,
      .5,
    );
    expect(half.maxWidth, (sizes.desktop.dialog.maxWidth + 520) / 2);
    expect(changed.desktop.copyWith(), changed.desktop);
    expect(changed.desktop.copyWith().hashCode, changed.desktop.hashCode);
  });

  test('Dialog 独立主题加入全局相等、复制与插值', () {
    final base = HyperThemeData.light();
    final start = base.copyWith(
      dialogTheme: const HyperDialogThemeData(
        style: HyperDialogStyle(maxWidth: 320, titleSpacing: 12),
      ),
    );
    final end = start.copyWith(
      dialogTheme: start.dialogTheme.copyWith(
        style: start.dialogTheme.style.copyWith(maxWidth: 480),
      ),
    );
    expect(start, isNot(end));
    expect(start.copyWith(), start);
    expect(start.copyWith().hashCode, start.hashCode);
    expect(start.lerp(end, .5).dialogTheme.style.maxWidth, 400);
    expect(end.cardTheme, base.cardTheme);
    expect(end.buttonTheme, base.buttonTheme);
  });

  test('正文、操作区和关闭入口可独立组合', () {
    const dialog = HyperDialog(
      content: Text('正文'),
      showCloseButton: false,
      scrollable: false,
      actions: [Text('任意操作内容')],
    );
    expect(dialog.title, isNull);
    expect(dialog.showCloseButton, isFalse);
    expect(dialog.scrollable, isFalse);
    expect(dialog.actions, hasLength(1));
  });
}
