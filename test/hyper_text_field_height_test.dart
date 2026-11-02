import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

const fontPath = String.fromEnvironment('CJK_REVIEW_FONT');

Widget host(Widget child, {double scale = 1}) => MaterialApp(
  home: HyperDeviceDetector(
    deviceType: HyperDeviceType.desktop,
    builder: (_, _, child) => HyperTheme(
      data: HyperThemeData.light(
        fontFamily: fontPath.isEmpty ? null : 'CjkReview',
      ),
      child: child!,
    ),
    child: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: Scaffold(body: Center(child: child)),
    ),
  ),
);

void main() {
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets(
      'intrinsic rows can measure a constrained field at scale $scale',
      (tester) async {
        await tester.pumpWidget(
          host(
            const SizedBox(
              width: 160,
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    Expanded(
                      child: HyperTextField(
                        initialValue: '输入内容',
                        style: HyperTextFieldStyle(height: 48),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            scale: scale,
          ),
        );
        expect(tester.takeException(), isNull);
        expect(tester.getSize(find.byType(HyperTextField)).height, 48);
      },
    );
  }
  setUpAll(() async {
    if (fontPath.isNotEmpty) {
      await (FontLoader('CjkReview')
            ..addFont(File(fontPath).readAsBytes().then(ByteData.sublistView)))
          .load();
    }
  });
  for (final mode in ['padding', 'parentCap', 'label', 'material']) {
    testWidgets('explicit surface height handles $mode', (tester) async {
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 180,
            height: mode == 'parentCap' ? 48 : null,
            child: HyperTextField(
              label: mode == 'label' ? '名称' : null,
              style: HyperTextFieldStyle(
                height: mode == 'parentCap' ? 64 : 48,
                textStyle: const TextStyle(fontSize: 30, height: 1),
                padding: const EdgeInsets.all(20),
                material: mode == 'material'
                    ? const HyperSurfaceMaterial.frostedGlass()
                    : null,
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      final native = tester.widget<TextField>(find.byType(TextField));
      expect(
        native.decoration!.contentPadding!.resolve(TextDirection.ltr).vertical,
        lessThan(40),
      );
      final surface = find
          .descendant(
            of: find.byType(HyperTextField),
            matching: find.byWidgetPredicate(
              (w) => w is AnimatedContainer && w.decoration is BoxDecoration,
            ),
          )
          .first;
      expect(tester.getSize(surface).height, 48);
      final total = tester.getSize(find.byType(HyperTextField)).height;
      expect(total, mode == 'label' ? greaterThan(48) : equals(48));
    });
  }
  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('desktop group uses default field metrics at scale $scale', (
      tester,
    ) async {
      double? height;
      await tester.pumpWidget(
        host(
          SizedBox(
            width: 280,
            child: Builder(
              builder: (context) {
                height = HyperTheme.sizesOf(context).textField.minimumHeight;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    HyperWidgetGroup(
                      style: HyperWidgetGroupStyle(itemHeight: height),
                      children: [
                        const HyperWidgetGroupItem(
                          flex: 1,
                          child: HyperTextField(hintText: '验证码'),
                        ),
                        HyperButton.text(
                          onPressed: () {},
                          label: const Text('发送'),
                        ),
                      ],
                    ),
                    HyperWidgetGroup(
                      style: HyperWidgetGroupStyle(itemHeight: height),
                      children: [
                        HyperWidgetGroupItem(
                          flex: 1,
                          child: HyperNumberInput(
                            value: 123,
                            onChanged: (_) {},
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          scale: scale,
        ),
      );
      expect(tester.takeException(), isNull);
      for (final field in find.byType(HyperTextField).evaluate()) {
        expect(tester.getSize(find.byWidget(field.widget)).height, height);
      }
    });
  }
  for (final source in ['style', 'parent', 'group', 'looseParent']) {
    for (final scale in [1.0, 1.3, 2.0]) {
      testWidgets('$source height remains bounded at text scale $scale', (
        tester,
      ) async {
        Widget field = HyperTextField(
          initialValue: '验证码',
          style: HyperTextFieldStyle(
            height: source == 'style' ? 48 : null,
            // Reproduce a line box one pixel taller than the content budget.
            textStyle: const TextStyle(fontSize: 47, height: 1),
            padding: const EdgeInsets.all(12),
            borderWidth: 1,
          ),
        );
        if (source == 'parent') field = SizedBox(height: 48, child: field);
        if (source == 'looseParent') {
          field = ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 48),
            child: field,
          );
        }
        if (source == 'group') {
          field = HyperWidgetGroup(
            style: const HyperWidgetGroupStyle(itemHeight: 48),
            children: [HyperWidgetGroupItem(width: 120, child: field)],
          );
        }
        await tester.pumpWidget(
          host(SizedBox(width: 180, child: field), scale: scale),
        );
        expect(tester.takeException(), isNull);
        expect(tester.getSize(find.byType(HyperTextField)).height, 48);
        final native = tester.widget<TextField>(find.byType(TextField));
        expect(
          native.decoration!.contentPadding!
              .resolve(TextDirection.ltr)
              .vertical,
          0,
        );
        expect(
          tester
              .state<EditableTextState>(find.byType(EditableText))
              .renderEditable
              .textScaler
              .scale(47),
          closeTo(47 * scale, .001),
        );
      });
    }
  }
  testWidgets('unbounded height grows with accessible text', (tester) async {
    await tester.pumpWidget(
      host(
        const SizedBox(
          width: 120,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [HyperTextField(initialValue: '输入内容')],
          ),
        ),
      ),
    );
    final before = tester.getSize(find.byType(HyperTextField)).height;
    await tester.pumpWidget(
      host(
        const SizedBox(
          width: 120,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [HyperTextField(initialValue: '输入内容')],
          ),
        ),
        scale: 2,
      ),
    );
    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byType(HyperTextField)).height,
      greaterThan(before),
    );
  });
}
