import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'editor/editor_theme_document.dart';
import 'editor/theme_editor.dart';
import 'gallery/gallery_shell.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HyperThemeData? startupTheme;
  try {
    final prefs = await SharedPreferences.getInstance();
    final source = prefs.getString('theme-editor-startup');
    if (source != null) {
      final json = jsonDecode(source) as Map<String, dynamic>;
      startupTheme = EditorThemeDocument.decode(jsonEncode(json['theme']))
          .resolve(json['dark'] as bool);
    }
  } catch (error) {
    debugPrint('启动主题读取失败，使用默认主题：$error');
  }
  runApp(LemonUiExampleApp(startupTheme: startupTheme));
}

/// 主题编辑器的外壳主题只在启动时确定。
class LemonUiExampleApp extends StatelessWidget {
  const LemonUiExampleApp({super.key, this.startupTheme});
  final HyperThemeData? startupTheme;
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Lemon UI · 主题工作室',
    debugShowCheckedModeBanner: false,
    builder: (context, child) => HyperTheme(
      data: startupTheme ?? HyperThemeData.light(),
      duration: Duration.zero,
      child: child!,
    ),
    home: HyperDeviceDetector(
      builder: (context, device, child) =>
          device == HyperDeviceType.phone || device == HyperDeviceType.watch
          ? const GalleryShell()
          : const ThemeEditor(),
    ),
  );
}
