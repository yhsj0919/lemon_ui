import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('状态使用同一套语义色，图标可单独覆盖', () {
    final colors = HyperThemeData.light().colors;
    expect(HyperResultStatus.success.color(colors), colors.success);
    expect(HyperResultStatus.error.color(colors), colors.error);
    expect(HyperResultStatus.warning.color(colors), colors.warning);
    expect(HyperResultStatus.info.color(colors), colors.primary);
    expect(HyperResultStatus.neutral.color(colors), colors.textSecondary);
    expect(HyperResultStatus.empty.color(colors), colors.textTertiary);
    expect(HyperResultStatus.values.map((s) => s.icon).toSet().length, 6);
  });
  test('通用、状态、局部与实例样式逐字段覆盖', () {
    const global = HyperResultThemeData(
      style: HyperResultStyle(
        titleStyle: TextStyle(fontSize: 20),
        actionSpacing: 8,
      ),
      error: HyperResultStyle(iconColor: Colors.red),
    );
    final local = global.merge(
      const HyperResultThemeData(
        error: HyperResultStyle(
          titleStyle: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
    final resolved = local
        .resolve(HyperResultStatus.error)
        .merge(const HyperResultStyle(actionSpacing: 12));
    expect(resolved.titleStyle!.fontSize, 20);
    expect(resolved.titleStyle!.fontWeight, FontWeight.bold);
    expect(resolved.iconColor, Colors.red);
    expect(resolved.actionSpacing, 12);
    expect(local.resolve(HyperResultStatus.success).iconColor, isNull);
    expect(local.copyWith(), local);
    expect(local.copyWith().hashCode, local.hashCode);
  });
  test('材质、边框、字体和过渡参与复制及插值', () {
    Widget transition(Widget child, Animation<double> animation) =>
        FadeTransition(opacity: animation, child: child);
    final a = HyperResultStyle(
      material: const HyperSurfaceMaterial.solid(),
      materialQuality: HyperMaterialQuality.advanced,
      reduceTransparency: true,
      iconColor: Colors.red,
      maxWidth: 320,
      border: Border.all(),
      titleStyle: const TextStyle(fontSize: 18),
      transitionBuilder: transition,
    );
    final b = a.copyWith(maxWidth: 400, iconColor: Colors.blue);
    expect(a.copyWith(), a);
    expect(HyperResultStyle.lerp(a, b, .5).maxWidth, 360);
    expect(HyperResultStyle.lerp(a, b, 1), b);
    expect(b.transitionBuilder, transition);
    expect(b.material, a.material);
    expect(b.border, a.border);
    final ta = HyperResultThemeData(style: a);
    expect(
      HyperResultThemeData.lerp(ta, ta.copyWith(style: b), .5).style.maxWidth,
      360,
    );
  });
  test('四端尺寸按设备存储，结果状态覆盖互不影响', () {
    const schemes = [
      HyperSizeScheme.phone(),
      HyperSizeScheme.tablet(),
      HyperSizeScheme.desktop(),
      HyperSizeScheme.watch(),
    ];
    expect(schemes.map((s) => s.result.maxWidth), [320, 400, 360, 180]);
    final sizes = schemes[2].copyWith(
      result: schemes[2].result.copyWith(iconSize: 60),
    );
    expect(sizes.result.empty.iconSize, 60);
    expect(sizes.deviceType, HyperDeviceType.desktop);
    expect(HyperSizeScheme.lerp(schemes[2], sizes, .5).result.iconSize, 50);
    final base = HyperThemeData.light();
    final changed = base.copyWith(
      resultTheme: const HyperResultThemeData(
        success: HyperResultStyle(iconColor: Colors.green),
      ),
    );
    expect(changed.resultTheme.empty, base.resultTheme.empty);
    expect(changed.copyWith(), changed);
    expect(changed.copyWith().hashCode, changed.hashCode);
    expect(base.lerp(changed, 1).resultTheme, changed.resultTheme);
  });
}
