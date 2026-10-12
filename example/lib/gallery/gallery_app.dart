import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'gallery_shell.dart';

/// 可独立运行的完整 Gallery，供组合预览和现有演示测试复用。
class LemonUiGalleryApp extends StatelessWidget {
  const LemonUiGalleryApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    builder: (context, child) => HyperTheme(
      data: HyperThemeData.light(),
      duration: Duration.zero,
      child: child!,
    ),
    home: const GalleryShell(),
  );
}
