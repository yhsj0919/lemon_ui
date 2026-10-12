import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/app_bar/hyper_app_bar_system_overlay.dart';

void main() {
  test('顶部 SafeArea 会移除顶栏需要的状态栏安全区，保留顶部时不会', () {
    const screen = MediaQueryData(
      padding: EdgeInsets.fromLTRB(0, 28, 0, 20),
      viewPadding: EdgeInsets.fromLTRB(0, 28, 0, 20),
    );
    final old = screen.removePadding(removeTop: true, removeBottom: true);
    final corrected = screen.removePadding(removeBottom: true);
    expect(old.padding.top, 0);
    expect(corrected.padding.top, screen.padding.top);
    expect(corrected.padding.bottom, 0);
    // 同一父级保留的顶部数据，可供侧栏自行避让而不影响内容列。
    expect(corrected.removePadding(removeTop: true).padding.top, 0);
    expect(corrected.padding.top, 28);
  });
  test('透明状态栏不额外叠色，图标亮暗与顶栏前景一致', () {
    final lightPage = appBarSystemOverlayStyle(foregroundColor: Colors.black);
    final darkPage = appBarSystemOverlayStyle(foregroundColor: Colors.white);
    expect(lightPage.statusBarColor, Colors.transparent);
    expect(darkPage.statusBarColor, Colors.transparent);
    expect(lightPage.systemStatusBarContrastEnforced, false);
    expect(lightPage.statusBarIconBrightness, Brightness.dark);
    expect(lightPage.statusBarBrightness, Brightness.light);
    expect(darkPage.statusBarIconBrightness, Brightness.light);
    expect(darkPage.statusBarBrightness, Brightness.dark);
    expect(lightPage.systemNavigationBarColor, isNull);
    expect(lightPage.systemNavigationBarIconBrightness, isNull);
  });
  test('局部系统栏字段覆盖后，未指定状态栏字段仍继承默认', () {
    final style = appBarSystemOverlayStyle(
      foregroundColor: Colors.black,
      override: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.indigo,
      ),
    );
    expect(style.statusBarIconBrightness, Brightness.light);
    expect(style.statusBarColor, Colors.transparent);
    expect(style.systemStatusBarContrastEnforced, false);
    expect(style.systemNavigationBarColor, Colors.indigo);
  });
  test('AppBar 强类型主题复制、合并、插值和值相等包含系统栏字段', () {
    const original = HyperAppBarStyle(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    const overlay = SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    );
    final updated = original.copyWith(systemOverlayStyle: overlay);
    expect(updated.systemOverlayStyle, overlay);
    expect(original.copyWith(), original);
    expect(original.copyWith().hashCode, original.hashCode);
    expect(
      HyperAppBarStyle.lerp(original, updated, 0).systemOverlayStyle,
      original.systemOverlayStyle,
    );
    expect(
      HyperAppBarStyle.lerp(original, updated, 1).systemOverlayStyle,
      overlay,
    );
    expect(
      const HyperAppBarThemeData(style: original)
          .merge(HyperAppBarThemeData(style: updated))
          .style!
          .systemOverlayStyle,
      overlay,
    );
  });
}
