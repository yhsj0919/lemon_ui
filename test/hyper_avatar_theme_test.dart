import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/avatar/hyper_blended_avatar.dart';

import 'dart:typed_data';
import 'dart:math' as math;
import 'dart:ui' as ui;

void main() {
  test('水滴偏转支持主题覆盖、插值和值相等', () {
    const base = HyperAvatarStyle(blendPetalRotation: -.22);
    final changed = base.copyWith(blendPetalRotation: -.35);
    expect(changed.blendPetalRotation, -.35);
    expect(base.merge(changed), changed);
    expect(
      HyperAvatarStyle.lerp(base, changed, .5).blendPetalRotation,
      closeTo(-.285, .000001),
    );
    expect(changed, const HyperAvatarStyle(blendPetalRotation: -.35));
    expect(
      changed.hashCode,
      const HyperAvatarStyle(blendPetalRotation: -.35).hashCode,
    );
  });
  test('磨砂水滴透光参数支持覆盖和插值', () {
    const base = HyperAvatarStyle(blendPetalOpacity: 1);
    final glass = base.copyWith(blendPetalOpacity: .72);
    expect(base.merge(glass), glass);
    expect(
      HyperAvatarStyle.lerp(base, glass, .5).blendPetalOpacity,
      closeTo(.86, .000001),
    );
    expect(glass, const HyperAvatarStyle(blendPetalOpacity: .72));
    expect(
      glass.hashCode,
      const HyperAvatarStyle(blendPetalOpacity: .72).hashCode,
    );
  });
  test('五瓣和七瓣风车自然留空圆心并保持花瓣可见', () async {
    for (final count in [5, 7]) {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      HyperAvatarWindmillPainter(
        colors: List.generate(count, (i) => Colors.primaries[i]),
        rotation: 0,
        padding: 8,
        border: const BorderSide(color: Colors.white, width: 1),
      ).paint(canvas, const Size.square(128));
      final picture = recorder.endRecording();
      final image = await picture.toImage(128, 128);
      final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      expect(data!.getUint8((64 * 128 + 64) * 4 + 3), 0);
      expect(data.getUint8((24 * 128 + 64) * 4 + 3), greaterThan(0));
      image.dispose();
      picture.dispose();
    }
  });
  test('圆形五角坐标的浮点误差不应被误判为非正方形', () {
    final slots = [
      for (var i = 0; i < 5; i++)
        Rect.fromLTWH(
          16 + math.cos(-math.pi / 2 + i * 2 * math.pi / 5) * 16,
          16 + math.sin(-math.pi / 2 + i * 2 * math.pi / 5) * 16,
          32,
          32,
        ),
    ];
    expect(slots.any((r) => r.width != r.height), isTrue);
    expect(
      HyperAvatarGroupGeometry(
        size: const Size.square(64),
        slots: slots,
      ).slots.length,
      5,
    );
  });
  test('图片主色按频率量化并忽略透明像素', () {
    expect(
      hyperAvatarDominantColor(
        Uint8List.fromList([
          240,
          30,
          10,
          255,
          242,
          31,
          11,
          255,
          10,
          50,
          230,
          255,
          0,
          0,
          0,
          0,
        ]),
      ),
      const Color.fromARGB(255, 241, 31, 11),
    );
    expect(hyperAvatarDominantColor(Uint8List.fromList([0, 0, 0, 0])), isNull);
  });
  test('混色主题方向与渐变可以覆盖', () {
    const a = HyperAvatarStyle(blendRotation: 0);
    final b = a.copyWith(
      blendRotation: 2,
      blendGradient: const LinearGradient(colors: [Colors.red, Colors.blue]),
    );
    expect(HyperAvatarStyle.lerp(a, b, .5).blendRotation, 1);
    expect(a.merge(b).blendGradient, b.blendGradient);
  });
  test('混色柔化可插值，风车轮廓保持在头像范围内', () {
    const a = HyperAvatarStyle(blendSoftness: 0);
    const b = HyperAvatarStyle(
      blendSoftness: .6,
      blendVariant: HyperAvatarBlendVariant.windmill,
    );
    expect(HyperAvatarStyle.lerp(a, b, .5).blendSoftness, .3);
    final path = hyperAvatarWindmillPetal(const Rect.fromLTWH(0, 0, 80, 80));
    final bounds = path.getBounds();
    expect(bounds.left, greaterThanOrEqualTo(0));
    expect(bounds.top, greaterThanOrEqualTo(0));
    expect(bounds.right, lessThanOrEqualTo(80));
    expect(bounds.bottom, lessThanOrEqualTo(80));
  });
  test('整组尺寸与间距可逐字段覆盖和插值', () {
    const a = HyperAvatarStyle(groupSize: Size(80, 40), spacing: 4);
    final b = a.copyWith(groupSize: const Size(160, 80), spacing: 8);
    final middle = HyperAvatarStyle.lerp(a, b, .5);
    expect(middle.groupSize, const Size(120, 60));
    expect(middle.spacing, 6);
    expect(
      a.merge(const HyperAvatarStyle(ringWidth: 1)).groupSize,
      a.groupSize,
    );
  });
  test('自定义布局拒绝越界与非正方形头像位置', () {
    expect(
      () => HyperAvatarGroupGeometry(
        size: const Size(80, 80),
        slots: [const Rect.fromLTWH(60, 0, 32, 32)],
      ),
      throwsArgumentError,
    );
    expect(
      () => HyperAvatarGroupGeometry(
        size: const Size(80, 80),
        slots: [const Rect.fromLTWH(0, 0, 32, 16)],
      ),
      throwsArgumentError,
    );
    final geometry = HyperAvatarGroupGeometry(
      size: const Size(80, 80),
      slots: [const Rect.fromLTWH(0, 0, 32, 32)],
    );
    expect(() => geometry.slots.add(Rect.zero), throwsUnsupportedError);
  });
  test('头像尺寸四端独立覆盖及插值', () {
    const sizes = HyperSizeThemeData();
    final changed = sizes.desktop.avatar.copyWith(medium: 48);
    expect(sizes.desktop.avatar.medium, 32);
    expect(sizes.phone.avatar.medium, 40);
    expect(HyperAvatarSize.lerp(sizes.desktop.avatar, changed, .5).medium, 40);
    expect(sizes.desktop.copyWith(avatar: changed).avatar, changed);
  });
  test('头像全局局部和实例逐字段覆盖', () {
    final global = HyperThemeData.light().copyWith(
      avatarTheme: const HyperAvatarThemeData(
        style: HyperAvatarStyle(backgroundColor: Colors.red, size: 32),
      ),
    );
    final local = global.avatarTheme.merge(
      const HyperAvatarThemeData(
        style: HyperAvatarStyle(foregroundColor: Colors.white),
      ),
    );
    final resolved = local.style.merge(const HyperAvatarStyle(size: 48));
    expect(resolved.backgroundColor, Colors.red);
    expect(resolved.foregroundColor, Colors.white);
    expect(resolved.size, 48);
    expect(HyperAvatarThemeData.lerp(local, local, .5), local);
  });
}
