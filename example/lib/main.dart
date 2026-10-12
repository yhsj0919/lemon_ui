import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'gallery/gallery_shell.dart';
import 'gallery/gallery_device_preview.dart';

void main() {
  runApp(const LemonUiExampleApp());
}

/// Lemon UI 的组件演示应用。
class LemonUiExampleApp extends StatelessWidget {
  const LemonUiExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: (context, child) => HyperTheme(
        data: HyperThemeData.light(),
        duration: Duration.zero,
        child: child!,
      ),
      home: GalleryDevicePreview(builder: _buildGallery),
    );
  }

  Widget _buildGallery(GalleryDevicePreviewConfiguration? preview) {
    final fallbackTheme = HyperThemeData.light();
    return MaterialApp(
      title: 'Lemon UI',
      debugShowCheckedModeBanner: false,
      // Material 只承担原生控件绘制，所有颜色均由 Hyper 语义主题映射。
      theme: fallbackTheme.toMaterialThemeData(
        ThemeData(useMaterial3: true, brightness: fallbackTheme.brightness),
      ),
      // HyperTheme 在作用域建立时解析一次设备类型。
      builder: (context, child) {
        final themed = HyperDeviceDetector(
          deviceType: preview?.device,
          builder: (context, device, _) => HyperTheme(
            data: HyperThemeData.light(),
            duration: Duration.zero,
            child: child!,
          ),
        );
        return preview == null
            ? themed
            : MediaQuery(
                data: preview.media(MediaQuery.of(context)),
                child: themed,
              );
      },
      home: const GalleryShell(),
    );
  }
}
