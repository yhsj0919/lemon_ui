import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test(
    'theme typography balances leading without rewriting supplied line heights',
    () {
      for (final theme in [
        HyperThemeData.light(),
        HyperThemeData.dark(),
        HyperThemeData.fromMaterial(ThemeData()),
      ]) {
        for (final style in [
          theme.textTheme.bodyMedium,
          theme.textTheme.titleSmall,
          theme.textTheme.labelLarge,
          theme.textTheme.labelMedium,
          theme.textTheme.labelSmall,
        ]) {
          expect(style!.leadingDistribution, TextLeadingDistribution.even);
        }
      }
      final material = ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            height: 1.7,
            leadingDistribution: TextLeadingDistribution.proportional,
          ),
          labelLarge: TextStyle(
            height: 1.4,
            leadingDistribution: TextLeadingDistribution.proportional,
          ),
        ),
      );
      final custom = HyperThemeData.fromMaterial(material);
      expect(custom.textTheme.bodyMedium!.height, 1.7);
      expect(
        custom.textTheme.bodyMedium!.leadingDistribution,
        TextLeadingDistribution.proportional,
      );
      expect(custom.textTheme.labelLarge!.height, 1.4);
      expect(
        custom.textTheme.labelLarge!.leadingDistribution,
        TextLeadingDistribution.proportional,
      );
    },
  );
  const fontPath = String.fromEnvironment('CJK_REVIEW_FONT');
  testWidgets('real CJK font has matching measured and editable line heights', (
    tester,
  ) async {
    await tester.runAsync(() async {
      await (FontLoader('CjkReview')..addFont(
            File(fontPath)
                .readAsBytes()
                .then((bytes) => ByteData.sublistView(bytes)),
          ))
          .load();
    });
    for (final scale in [.875, 1.0, 1.3, 2.0]) {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperDeviceDetector(
            deviceType: HyperDeviceType.desktop,
            builder: (_, device, child) => HyperTheme(
              data: HyperThemeData.light(fontFamily: 'CjkReview'),
              child: child!,
            ),
            child: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: Scaffold(
                body: Center(
                  child: SizedBox(
                    width: 180,
                    child: HyperNumberInput(value: 123, onChanged: (_) {}),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      final state = tester.state<EditableTextState>(find.byType(EditableText));
      final widget = tester.widget<EditableText>(find.byType(EditableText));
      final painter = TextPainter(
        text: TextSpan(text: ' ', style: widget.style),
        textDirection: TextDirection.ltr,
        textScaler: TextScaler.linear(scale),
      )..layout();
      expect(
        state.renderEditable.size.height,
        closeTo(painter.preferredLineHeight, 1),
      );
      painter.dispose();
      final field = tester.getRect(find.byType(HyperTextField));
      final render = state.renderEditable;
      final center = render.localToGlobal(Offset(0, render.size.height / 2));
      expect(center.dy, closeTo(field.center.dy, .1));
      expect(tester.takeException(), isNull);
    }
  }, skip: fontPath.isEmpty);
  for (final scale in [.875, 1.0, 1.3, 2.0]) {
    testWidgets(
      'input and number input inherit balanced line metrics at $scale',
      (tester) async {
        final base = HyperThemeData.light();
        await tester.pumpWidget(
          MaterialApp(
            home: HyperDeviceDetector(
              deviceType: HyperDeviceType.desktop,
              builder: (_, device, child) =>
                  HyperTheme(data: base, child: child!),
              child: MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                child: Scaffold(
                  body: Center(
                    child: SizedBox(
                      width: 240,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const HyperTextField(
                            initialValue: '123中文',
                            hintText: '提示文字',
                          ),
                          HyperNumberInput(value: 123, onChanged: (_) {}),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        for (final editable in tester.widgetList<EditableText>(
          find.byType(EditableText),
        )) {
          final resolvedTheme = HyperTheme.of(
            tester.element(find.byType(HyperTextField).first),
          );
          expect(
            editable.style.leadingDistribution,
            TextLeadingDistribution.even,
          );
          expect(
            editable.strutStyle.leadingDistribution,
            TextLeadingDistribution.even,
          );
          expect(
            editable.style.fontSize,
            resolvedTheme.textTheme.labelLarge!.fontSize,
          );
          expect(
            editable.style.height,
            resolvedTheme.textTheme.labelLarge!.height ?? 1,
          );
        }
        final native = tester.widgetList<TextField>(find.byType(TextField));
        expect(
          native.first.decoration!.hintStyle!.leadingDistribution,
          TextLeadingDistribution.even,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets('explicit leading and line height remain overridable', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light().copyWith(
            textFieldTheme: const HyperTextFieldThemeData(
              style: HyperTextFieldStyle(
                textStyle: TextStyle(
                  height: 1.6,
                  leadingDistribution: TextLeadingDistribution.proportional,
                ),
              ),
            ),
          ),
          child: const Scaffold(body: HyperTextField(initialValue: '123中文')),
        ),
      ),
    );
    final editable = tester.widget<EditableText>(find.byType(EditableText));
    expect(editable.style.height, 1.6);
    expect(
      editable.style.leadingDistribution,
      TextLeadingDistribution.proportional,
    );
  });
}
