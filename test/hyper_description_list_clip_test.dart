import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('transparent description layout does not clip input corners', (
    t,
  ) async {
    for (final surface in [false, true]) {
      await t.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: SizedBox(
                width: 300,
                child: HyperDescriptionList(
                  bordered: surface,
                  style: const HyperDescriptionListStyle(
                    cellPadding: EdgeInsets.zero,
                    rowSpacing: 0,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  items: const [
                    HyperDescriptionItem(
                      id: 'edit',
                      label: Text('名称'),
                      value: HyperTextField(
                        initialValue: '示例项目',
                        style: HyperTextFieldStyle(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      final outerClips = find.ancestor(
        of: find.byType(HyperTextField),
        matching: find.byType(ClipRRect),
      );
      expect(outerClips, surface ? findsOneWidget : findsNothing);
      expect(t.takeException(), isNull);
    }
  });
}
