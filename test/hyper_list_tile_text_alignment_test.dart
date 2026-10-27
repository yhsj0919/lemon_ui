import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('two-line text group centers with leading icon at $scale', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: const Center(
                child: SizedBox(
                  width: 240,
                  child: HyperListTile(
                    title: Text('填充'),
                    subtitle: Text('纯色、渐变和显式无填充。'),
                    leading: Icon(HyperIcons.paintBucket),
                    style: HyperListTileStyle(
                      minHeight: 64,
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      final textBounds = tester
          .getRect(find.text('填充'))
          .expandToInclude(tester.getRect(find.text('纯色、渐变和显式无填充。')));
      expect(
        textBounds.center.dy,
        closeTo(tester.getCenter(find.byIcon(HyperIcons.paintBucket)).dy, .01),
      );
      expect(tester.takeException(), isNull);
    });
  }
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('list title and chevron share center at text scale $scale', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: const Center(
                child: SizedBox(
                  width: 180,
                  child: HyperListTile(
                    title: Text('输入控件'),
                    trailing: Icon(HyperIcons.chevronRight),
                    style: HyperListTileStyle(
                      minHeight: 48,
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      titleStyle: TextStyle(fontSize: 16, height: 2),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      final text = find.text('输入控件');
      expect(
        tester.getCenter(text).dy,
        closeTo(tester.getCenter(find.byIcon(HyperIcons.chevronRight)).dy, .01),
      );
      final behavior = DefaultTextStyle.of(tester.element(text))
          .textHeightBehavior!;
      expect(behavior.applyHeightToFirstAscent, isFalse);
      expect(behavior.applyHeightToLastDescent, isFalse);
      expect(tester.takeException(), isNull);
    });
  }
}
