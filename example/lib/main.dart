import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'gallery/gallery_shell.dart';

void main() {
  runApp(const LemonUiExampleApp());
}

/// Lemon UI 的组件演示应用。
class LemonUiExampleApp extends StatelessWidget {
  const LemonUiExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp 启动阶段使用桌面回退；实际整棵应用子树由设备探测结果驱动。
    final fallbackTheme = HyperThemeData.light(
      sizes: const HyperSizeScheme.desktop(),
    );
    return MaterialApp(
      title: 'Lemon UI',
      debugShowCheckedModeBanner: false,
      // Material 只承担原生控件绘制，所有颜色均由 Hyper 语义主题映射。
      theme: fallbackTheme.toMaterialThemeData(
        ThemeData(useMaterial3: true, brightness: fallbackTheme.brightness),
      ),
      builder: (context, child) => HyperDeviceDetector(
        child: child,
        builder: (context, deviceType, child) => HyperTheme(
          data: HyperThemeData.light(
            sizes: HyperSizeScheme.forDevice(deviceType),
          ),
          duration: Duration.zero,
          child: child!,
        ),
      ),
      home: const GalleryShell(),
    );
  }
}
