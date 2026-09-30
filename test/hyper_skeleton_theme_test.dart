import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('四端骨架尺寸集中管理、独立覆盖并参与总主题值相等', () {
    final schemes = [
      const HyperSizeScheme.phone(),
      const HyperSizeScheme.tablet(),
      const HyperSizeScheme.desktop(),
      const HyperSizeScheme.watch(),
    ];
    expect(schemes.map((e) => e.skeleton.circleSize), [40, 44, 32, 36]);
    for (final scheme in schemes) {
      final changed = scheme.copyWith(
        skeleton: scheme.skeleton.copyWith(lineHeight: 20),
      );
      expect(changed, isNot(scheme));
      expect(changed.skeleton.circleSize, scheme.skeleton.circleSize);
      expect(
        HyperSizeScheme.lerp(scheme, changed, .5).skeleton.lineHeight,
        (scheme.skeleton.lineHeight + 20) / 2,
      );
    }
  });
  test('骨架主题全局、局部和实例逐字段覆盖并正确插值', () {
    final base = HyperThemeData.light().copyWith(
      skeletonTheme: const HyperSkeletonThemeData(
        style: HyperSkeletonStyle(
          backgroundColor: Colors.grey,
          radius: 8,
          shimmerWidth: .2,
          duration: Duration(milliseconds: 1200),
        ),
      ),
    );
    final local = base.skeletonTheme.merge(
      const HyperSkeletonThemeData(
        style: HyperSkeletonStyle(effect: HyperSkeletonEffect.pulse),
      ),
    );
    final instance = local.style.copyWith(radius: 4);
    expect(instance.backgroundColor, Colors.grey);
    expect(instance.effect, HyperSkeletonEffect.pulse);
    expect(instance.duration, const Duration(milliseconds: 1200));
    final changed = base.copyWith(
      skeletonTheme: local.copyWith(style: instance),
    );
    expect(changed, isNot(base));
    expect(base.lerp(changed, .5).skeletonTheme.style.radius, 6);
    expect(instance, local.style.copyWith(radius: 4));
    expect(instance.hashCode, local.style.copyWith(radius: 4).hashCode);
  });
  test('已有内容控件主题的变化必须被全局主题识别', () {
    final base = HyperThemeData.light();
    expect(
      base.copyWith(
        avatarTheme: base.avatarTheme.copyWith(
          style: const HyperAvatarStyle(backgroundColor: Colors.red),
        ),
      ),
      isNot(base),
    );
    expect(
      base.copyWith(
        tagTheme: base.tagTheme.copyWith(
          style: const HyperTagStyle(backgroundColor: Colors.red),
        ),
      ),
      isNot(base),
    );
  });
  test('自定义动画与阴影可覆盖，值相等和插值保留强类型配置', () {
    Widget effect(BuildContext context, Widget child, double progress) => child;
    final base = HyperSkeletonStyle(
      effectBuilder: effect,
      boxShadow: const [BoxShadow(color: Colors.black, blurRadius: 2)],
      shimmerAngle: .1,
      pulseMinOpacity: .6,
    );
    final end = base.copyWith(shimmerAngle: .3, pulseMinOpacity: .8);
    final mid = HyperSkeletonStyle.lerp(base, end, .5);
    expect(mid.shimmerAngle, closeTo(.2, .000001));
    expect(mid.pulseMinOpacity, closeTo(.7, .000001));
    expect(mid.effectBuilder, effect);
    expect(base, base.copyWith());
    expect(base.hashCode, base.copyWith().hashCode);
  });
  test('微光只绘制在骨架范围内，周期端点不留下亮块', () async {
    Future<ByteData> render(double phase) async {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder)..translate(10, 10);
      HyperSkeletonShimmerPainter(
        progress: phase,
        color: Colors.white,
        bandWidth: .28,
        angle: .18,
        direction: TextDirection.ltr,
      ).paint(canvas, const Size(40, 12));
      final picture = recorder.endRecording();
      final image = await picture.toImage(60, 32);
      final bytes = (await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      ))!;
      image.dispose();
      picture.dispose();
      return bytes;
    }

    final mid = await render(.5);
    expect(mid.getUint8((16 * 60 + 30) * 4 + 3), greaterThan(0));
    expect(mid.getUint8((5 * 60 + 30) * 4 + 3), 0);
    for (final phase in [0.0, 1.0]) {
      final bytes = await render(phase);
      expect(bytes.buffer.asUint8List().every((e) => e == 0), true);
    }
  });
}
