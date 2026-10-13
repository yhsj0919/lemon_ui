import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('自动填充跟随设备触发圆角，实例圆角优先', (tester) async {
    final base = HyperThemeData.light();
    await tester.pumpWidget(
      MaterialApp(
        home: HyperDeviceDetector(
          deviceType: HyperDeviceType.desktop,
          builder: (context, device, child) => HyperTheme(
            data: base.copyWith(
              sizes: base.sizes.copyWith(
                desktop: base.sizes.desktop.copyWith(
                  select: base.sizes.desktop.select.copyWith(radius: 24),
                ),
              ),
            ),
            child: child!,
          ),
          child: Scaffold(
            body: Column(
              children: [
                HyperAutocomplete<String>(
                  key: const ValueKey('single'),
                  options: const [],
                  value: null,
                  onChanged: (_) {},
                ),
                HyperAutocomplete<String>.multiple(
                  key: const ValueKey('multi'),
                  options: const [],
                  values: const {},
                  onSelectionChanged: (_) {},
                ),
                HyperAutocomplete<String>(
                  key: const ValueKey('override'),
                  options: const [],
                  value: null,
                  onChanged: (_) {},
                  inputStyle: const HyperTextFieldStyle(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    for (final entry in {
      'single': 24.0,
      'multi': 24.0,
      'override': 7.0,
    }.entries) {
      final field = find.descendant(
        of: find.byKey(ValueKey(entry.key)),
        matching: find.byType(HyperTextField),
      );
      final surface = find
          .descendant(
            of: field,
            matching: find.byWidgetPredicate(
              (w) => w is AnimatedContainer && w.decoration is BoxDecoration,
            ),
          )
          .first;
      expect(
        (tester.widget<AnimatedContainer>(surface).decoration! as BoxDecoration)
            .borderRadius,
        BorderRadius.circular(entry.value),
      );
    }
    expect(base.sizes.phone.select.radius, isNull);
    expect(tester.takeException(), isNull);
  });
}
