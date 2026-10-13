import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:lemon_ui/lemon_ui.dart';

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/src/painting/hyper_box_decoration.dart';

void main() {
  test('外侧阴影不染色透明内部，普通阴影对照可复现染色', () async {
    Future<List<int>> pixel(bool outer, int x, int y) async {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      canvas.drawColor(Colors.white, BlendMode.src);
      final painter = HyperBoxDecoration(
        outerShadowsOnly: outer,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x80ff0000), spreadRadius: 8)],
      ).createBoxPainter();
      painter.paint(
        canvas,
        const Offset(30, 30),
        const ImageConfiguration(
          size: Size(40, 40),
          textDirection: TextDirection.ltr,
        ),
      );
      final picture = recorder.endRecording();
      final image = await picture.toImage(100, 100);
      final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      final i = (y * 100 + x) * 4;
      final value = [
        data!.getUint8(i),
        data.getUint8(i + 1),
        data.getUint8(i + 2),
      ];
      image.dispose();
      picture.dispose();
      painter.dispose();
      return value;
    }

    expect(await pixel(false, 50, 50), [255, 127, 127]);
    expect(await pixel(true, 50, 50), [255, 255, 255]);
    expect(await pixel(true, 25, 50), [255, 127, 127]);
  });
  testWidgets('按钮悬停阴影退出中间帧与结束帧内部颜色保持一致', (tester) async {
    final key = GlobalKey();
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: RepaintBoundary(
            key: key,
            child: const ColoredBox(
              color: Colors.white,
              child: Center(child: _ShadowButton()),
            ),
          ),
        ),
      ),
    );
    final button = find.byType(HyperButton);
    final rect = tester.getRect(button);
    final pointer = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await pointer.addPointer(location: const Offset(0, 0));
    await pointer.moveTo(rect.center);
    await tester.pumpAndSettle();
    Future<int> green() async {
      final boundary =
          key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
      final image = await boundary.toImage();
      final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
      final offset = boundary.globalToLocal(
        Offset(rect.left + 12, rect.center.dy),
      );
      final i = (offset.dy.floor() * image.width + offset.dx.floor()) * 4;
      final value = data!.getUint8(i + 1);
      image.dispose();
      return value;
    }

    expect(await tester.runAsync(green), 255);
    await pointer.moveTo(const Offset(0, 0));
    await tester.pump();
    for (final duration in [
      const Duration(milliseconds: 50),
      const Duration(milliseconds: 49),
      const Duration(milliseconds: 1),
    ]) {
      await tester.pump(duration);
      expect(await tester.runAsync(green), 255);
    }
    await pointer.removePointer();
  });
  test('外侧阴影插值保留绘制策略', () {
    const a = HyperBoxDecoration(outerShadowsOnly: true, boxShadow: []);
    const b = HyperBoxDecoration(
      outerShadowsOnly: true,
      boxShadow: [BoxShadow(blurRadius: 12)],
    );
    expect((a.lerpTo(b, .5)! as HyperBoxDecoration).outerShadowsOnly, isTrue);
  });
}

class _ShadowButton extends StatelessWidget {
  const _ShadowButton();
  @override
  Widget build(BuildContext context) => HyperButton.text(
    label: const Text('Text'),
    onPressed: () {},
    focusHighlight: false,
    style: HyperButtonStyle(
      width: 160,
      height: 60,
      background: const HyperFill.none(),
      boxShadow: const [],
      hoveredBoxShadow: const [
        BoxShadow(color: Color(0x80ff0000), blurRadius: 20, spreadRadius: 8),
      ],
      hoverOverlayOpacity: 0,
      focusOverlayOpacity: 0,
      pressOverlayOpacity: 0,
      animationDuration: const Duration(milliseconds: 100),
      animationCurve: Curves.linear,
    ),
  );
}
