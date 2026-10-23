import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final quality in HyperMaterialQuality.values) {
    for (final card in [true, false]) {
      for (final disableShadow in [false, true]) {
        testWidgets(
          'surface shadow stays outside with $quality / card=$card / disabled=$disableShadow',
          (tester) async {
            final key = GlobalKey();
            const material = HyperSurfaceMaterial.frostedGlass(
              background: HyperFill.color(Color(0x33FFFFFF)),
              blurSigmaX: 8,
              blurSigmaY: 8,
              boxShadow: [
                BoxShadow(
                  color: Color(0xA0FF0000),
                  blurRadius: 12,
                  spreadRadius: 8,
                ),
              ],
            );
            await tester.pumpWidget(
              MaterialApp(
                home: HyperTheme(
                  duration: Duration.zero,
                  data: HyperThemeData.light().copyWith(
                    materialTheme: HyperMaterialThemeData(quality: quality),
                  ),
                  child: Center(
                    child: RepaintBoundary(
                      key: key,
                      child: ColoredBox(
                        color: Colors.white,
                        child: SizedBox(
                          width: 200,
                          height: 160,
                          child: Center(
                            child: card
                                ? HyperCard(
                                    width: 120,
                                    height: 80,
                                    style: HyperCardStyle(
                                      material: material,
                                      boxShadow: disableShadow
                                          ? const []
                                          : null,
                                      padding: EdgeInsets.zero,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                    child: SizedBox(),
                                  )
                                : HyperMaterialSurface(
                                    width: 120,
                                    height: 80,
                                    material: material,
                                    boxShadow: disableShadow ? const [] : null,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(12),
                                    ),
                                    child: SizedBox(),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
            await tester.pumpAndSettle();
            await tester.runAsync(() async {
              final image =
                  await (key.currentContext!.findRenderObject()
                          as RenderRepaintBoundary)
                      .toImage(pixelRatio: 1);
              final data = (await image.toByteData(
                format: ui.ImageByteFormat.rawRgba,
              ))!;
              int green(int x, int y) =>
                  data.getUint8((y * image.width + x) * 4 + 1);
              expect(
                green(44, 80),
                greaterThanOrEqualTo(253),
                reason: '表面内侧不能被自身红色阴影或模糊采样染色',
              );
              expect(green(100, 80), greaterThanOrEqualTo(253));
              expect(
                green(32, 80),
                disableShadow ? greaterThanOrEqualTo(253) : lessThan(250),
                reason: '外侧阴影正常绘制，实例空列表可以关闭',
              );
              image.dispose();
            });
          },
        );
      }
    }
  }
}
