import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  Future<HyperDeviceType> detect(
    WidgetTester tester,
    Size size, {
    HyperDeviceType? override,
  }) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = size;
    late HyperDeviceType result;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperDeviceDetector(
          key: UniqueKey(),
          deviceType: override,
          builder: (context, deviceType, _) {
            result = deviceType;
            expect(HyperDeviceDetector.of(context), deviceType);
            return const SizedBox();
          },
        ),
      ),
    );
    return result;
  }

  tearDown(() {
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('触摸平台按明确断点区分手机和平板', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(await detect(tester, const Size(390, 844)), HyperDeviceType.phone);
    expect(await detect(tester, const Size(800, 1200)), HyperDeviceType.tablet);
    debugDefaultTargetPlatformOverride = null;
    tester.view.reset();
  });

  testWidgets('小型近方形窗口识别为手表', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    expect(await detect(tester, const Size(220, 220)), HyperDeviceType.watch);
    debugDefaultTargetPlatformOverride = null;
    tester.view.reset();
  });

  testWidgets('桌面平台优先使用桌面方案', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    expect(
      await detect(tester, const Size(1280, 800)),
      HyperDeviceType.desktop,
    );
    expect(await detect(tester, const Size(220, 220)), HyperDeviceType.desktop);
    debugDefaultTargetPlatformOverride = null;
    tester.view.reset();
  });

  testWidgets('非手机平台默认使用桌面方案', (tester) async {
    for (final platform in <TargetPlatform>[
      TargetPlatform.windows,
      TargetPlatform.linux,
      TargetPlatform.macOS,
      TargetPlatform.fuchsia,
    ]) {
      debugDefaultTargetPlatformOverride = platform;
      expect(
        await detect(tester, const Size(220, 220)),
        HyperDeviceType.desktop,
      );
    }
    debugDefaultTargetPlatformOverride = null;
    tester.view.reset();
  });

  testWidgets('窗口缩放不改变已经确定的设备类型', (tester) async {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    var resolved = HyperDeviceType.desktop;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperDeviceDetector(
          builder: (context, deviceType, _) {
            resolved = deviceType;
            return const SizedBox();
          },
        ),
      ),
    );
    expect(resolved, HyperDeviceType.phone);

    tester.view.physicalSize = const Size(800, 1200);
    await tester.pump();
    expect(resolved, HyperDeviceType.phone);
    debugDefaultTargetPlatformOverride = null;
    tester.view.reset();
  });

  testWidgets('显式类型覆盖自动探测并可驱动主题', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 800);
    late HyperDeviceType resolvedType;
    late double resolvedHeight;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperDeviceDetector(
          deviceType: HyperDeviceType.watch,
          builder: (context, deviceType, _) {
            return HyperTheme(
              data: HyperThemeData.light(sizes: const HyperSizeThemeData()),
              duration: Duration.zero,
              child: Builder(
                builder: (context) {
                  resolvedType = HyperDeviceDetector.of(context);
                  resolvedHeight = HyperTheme.sizesOf(context).controlHeightMd;
                  return const SizedBox();
                },
              ),
            );
          },
        ),
      ),
    );
    expect(resolvedType, HyperDeviceType.watch);
    expect(resolvedHeight, 48);
    tester.view.reset();
  });
}
