import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'package:lemon_ui_example/gallery/gallery_device_preview.dart';

void main() {
  test('预览覆盖画布、缩放和安全区，不继承宿主窗口几何', () {
    const configuration = GalleryDevicePreviewConfiguration(
      HyperDeviceType.phone,
      Size(390, 844),
      true,
      false,
      1.3,
    );
    final media = configuration.media(
      const MediaQueryData(
        size: Size(1920, 1080),
        devicePixelRatio: 2,
        viewInsets: EdgeInsets.only(bottom: 300),
      ),
    );
    expect(media.size, const Size(390, 844));
    expect(media.devicePixelRatio, 1);
    expect(media.padding, const EdgeInsets.only(top: 24, bottom: 24));
    expect(media.viewPadding, media.padding);
    expect(media.viewInsets, EdgeInsets.zero);
    expect(media.textScaler.scale(10), 13);
    expect(
      hyperResolveSelectPresentation(
        HyperSelectPresentation.adaptive,
        configuration.device,
      ),
      HyperSelectPresentation.bottomSheet,
    );
  });
  test('键盘占位保留系统安全区并独立于设备主题类别', () {
    const configuration = GalleryDevicePreviewConfiguration(
      HyperDeviceType.tablet,
      Size(1194, 834),
      true,
      true,
      1,
    );
    final media = configuration.media(const MediaQueryData());
    expect(media.padding.bottom, 0);
    expect(media.viewPadding.bottom, 24);
    expect(media.viewInsets.bottom, closeTo(834 * .35, .001));
    expect(configuration.device, HyperDeviceType.tablet);
    const desktop = GalleryDevicePreviewConfiguration(
      HyperDeviceType.desktop,
      Size(1280, 800),
      true,
      false,
      1,
    );
    expect(desktop.media(const MediaQueryData()).padding, EdgeInsets.zero);
  });
}
