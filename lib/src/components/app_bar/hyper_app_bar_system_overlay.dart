import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 状态栏露出顶栏表面；图标亮暗跟随顶栏前景，不从透明背景推断。
SystemUiOverlayStyle appBarSystemOverlayStyle({
  required Color foregroundColor,
  SystemUiOverlayStyle? override,
}) {
  final brightness = ThemeData.estimateBrightnessForColor(foregroundColor);
  return SystemUiOverlayStyle(
    statusBarColor: override?.statusBarColor ?? Colors.transparent,
    statusBarIconBrightness: override?.statusBarIconBrightness ?? brightness,
    statusBarBrightness:
        override?.statusBarBrightness ??
        (brightness == Brightness.light ? Brightness.dark : Brightness.light),
    systemStatusBarContrastEnforced:
        override?.systemStatusBarContrastEnforced ?? false,
    systemNavigationBarColor: override?.systemNavigationBarColor,
    systemNavigationBarDividerColor: override?.systemNavigationBarDividerColor,
    systemNavigationBarIconBrightness:
        override?.systemNavigationBarIconBrightness,
    systemNavigationBarContrastEnforced:
        override?.systemNavigationBarContrastEnforced,
  );
}
