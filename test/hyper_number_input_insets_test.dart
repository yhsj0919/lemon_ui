import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final device in [HyperDeviceType.desktop, HyperDeviceType.phone]) {
    for (final scale in [1.0, 1.3, 2.0]) {
      testWidgets(
        'vertical stepper keeps balanced vertical insets and trailing clearance on $device scale $scale',
        (t) async {
          await t.pumpWidget(
            MaterialApp(
              home: HyperDeviceDetector(
                deviceType: device,
                builder: (context, _, child) => HyperTheme(
                  data: HyperThemeData.light(),
                  child: MediaQuery(
                    data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                    child: Scaffold(
                      body: Center(
                        child: SizedBox(
                          width: 280,
                          child: HyperNumberInput(value: 1, onChanged: (_) {}),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          await t.pumpAndSettle();
          final field = t.getRect(find.byType(HyperTextField));
          final up = t.getRect(find.byIcon(Icons.keyboard_arrow_up));
          final down = t.getRect(find.byIcon(Icons.keyboard_arrow_down));
          // Bundled MaterialIcons ink bounds in a 512-unit em.
          final top = up.top + up.height * 171 / 512 - field.top;
          final bottom = field.bottom - (down.top + down.height * 341 / 512);
          final end = field.right - (up.left + up.width * 384 / 512);
          expect(top, closeTo(bottom, .5));
          expect(end, closeTo(top, 1.1));
          if (device == HyperDeviceType.desktop && scale == 1) {
            final middle =
                (down.top + down.height * 183 / 512) -
                (up.top + up.height * 329 / 512);
            expect(middle, closeTo(top, 1.1));
          }
          expect(t.takeException(), isNull);
        },
      );
    }
  }
}
