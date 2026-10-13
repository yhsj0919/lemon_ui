import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final width in [0.0, 2.0]) {
    testWidgets('输入框与骨架屏边框宽度 $width', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: Column(
                children: [
                  HyperTextField(
                    style: HyperTextFieldStyle(
                      borderWidth: width,
                      borderColor: Colors.red,
                    ),
                  ),
                  HyperSkeleton(
                    width: 100,
                    height: 30,
                    style: HyperSkeletonStyle(
                      borderWidth: width,
                      borderColor: Colors.red,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      for (final type in [HyperTextField, HyperSkeleton]) {
        final decorations = tester.widgetList<DecoratedBox>(
          find.descendant(
            of: find.byType(type),
            matching: find.byType(DecoratedBox),
          ),
        );
        final redBorders = decorations
            .map((w) => w.decoration)
            .whereType<BoxDecoration>()
            .map((d) => d.border)
            .whereType<Border>()
            .where((b) => b.top.color == Colors.red);
        expect(redBorders, width == 0 ? isEmpty : isNotEmpty);
        if (width > 0) expect(redBorders.first.top.width, width);
      }
      expect(tester.takeException(), isNull);
    });
  }
}
