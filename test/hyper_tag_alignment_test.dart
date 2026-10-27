import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final scale in [1.0, 1.3, 2.0]) {
    for (final withIcon in [false, true]) {
      testWidgets(
        'phone tag centers natural text metrics at $scale, icon $withIcon',
        (tester) async {
          tester.view.physicalSize = const Size(240, 400);
          tester.view.devicePixelRatio = 1;
          addTearDown(tester.view.resetPhysicalSize);
          addTearDown(tester.view.resetDevicePixelRatio);
          await tester.pumpWidget(
            MaterialApp(
              home: HyperDeviceDetector(
                deviceType: HyperDeviceType.phone,
                builder: (context, device, child) => HyperTheme(
                  data: HyperThemeData.light(),
                  child: MediaQuery(
                    data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                    child: Scaffold(
                      body: Center(
                        child: SizedBox(
                          width: 120,
                          child: Align(
                            child: HyperTag(
                              label: '普通 Tag',
                              icon: withIcon ? const Icon(Icons.check) : null,
                              // A tall inherited line box must not shift the only line's
                              // natural ascent/descent relative to the tag surface.
                              style: const HyperTagStyle(
                                textStyle: TextStyle(
                                  fontFamily: 'Ahem',
                                  fontSize: 14,
                                  height: 2,
                                ),
                              ),
                            ),
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
          final text = find.text('普通 Tag');
          final paragraph = tester.renderObject<RenderParagraph>(text);
          final natural = TextPainter(
            text: const TextSpan(
              text: '普通 Tag',
              style: TextStyle(fontFamily: 'Ahem', fontSize: 14),
            ),
            textDirection: TextDirection.ltr,
            textScaler: TextScaler.linear(scale),
            maxLines: 1,
          )..layout(maxWidth: paragraph.size.width);
          final surface = tester.getRect(
            find.descendant(
              of: find.byType(HyperTag),
              matching: find.byType(AnimatedContainer),
            ),
          );
          expect(paragraph.size.height, closeTo(natural.height, .01));
          expect(tester.getCenter(text).dy, closeTo(surface.center.dy, .01));
          expect(surface.height, greaterThanOrEqualTo(natural.height));
          expect(surface.width, lessThanOrEqualTo(120));
          if (withIcon) {
            expect(
              tester.getCenter(find.byType(Icon)).dy,
              closeTo(surface.center.dy, .01),
            );
            expect(
              tester.getSize(find.byType(Icon)).height,
              HyperThemeData.light().sizes.phone.tag.iconSize,
            );
          }
          expect(tester.takeException(), isNull);
          natural.dispose();
        },
      );
    }
  }
}
