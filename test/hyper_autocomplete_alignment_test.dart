import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

const _fontPath = String.fromEnvironment('CJK_REVIEW_FONT');

void main() {
  setUpAll(() async {
    if (_fontPath.isNotEmpty) {
      await (FontLoader('CjkReview')
            ..addFont(File(_fontPath).readAsBytes().then(ByteData.sublistView)))
          .load();
    }
  });

  for (final scale in [1.0, 1.3, 2.0]) {
    for (final value in [null, 'a']) {
      testWidgets(
        'autocomplete line is centered at scale $scale, value $value',
        (tester) async {
          await tester.pumpWidget(
            MaterialApp(
              home: HyperDeviceDetector(
                deviceType: HyperDeviceType.desktop,
                builder: (_, _, child) => HyperTheme(
                  data: HyperThemeData.light(
                    fontFamily: _fontPath.isEmpty ? null : 'CjkReview',
                  ),
                  child: child!,
                ),
                child: MediaQuery(
                  data: MediaQueryData(textScaler: TextScaler.linear(scale)),
                  child: Scaffold(
                    body: Center(
                      child: HyperAutocomplete<String>(
                        options: const [
                          HyperSelectOption(value: 'a', label: '创建订单'),
                        ],
                        value: value,
                        onChanged: (_) {},
                        placeholder: '选择素材',
                        style: const HyperSelectStyle(width: 160),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final editable = tester
              .state<EditableTextState>(find.byType(EditableText))
              .renderEditable;
          final surface = find
              .descendant(
                of: find.byType(HyperTextField),
                matching: find.byType(AnimatedContainer),
              )
              .first;
          final bounds = tester.getRect(surface);
          final native = tester.widget<TextField>(find.byType(TextField));
          expect(native.strutStyle!.forceStrutHeight, isFalse);
          expect(native.textAlignVertical, TextAlignVertical.center);
          if (value != null) {
            final box = editable
                .getBoxesForSelection(
                  const TextSelection(baseOffset: 0, extentOffset: 4),
                )
                .first;
            final line = box.toRect().shift(
              editable.localToGlobal(Offset.zero),
            );
            expect(line.center.dy, closeTo(bounds.center.dy, .5 * scale));
          }
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
