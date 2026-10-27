import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final sheet in [false, true]) {
    testWidgets(
      'modal sheet=$sheet preserves form when header and actions change',
      (tester) async {
        final controller = HyperFormController();
        addTearDown(controller.dispose);
        late StateSetter update;
        var header = true;
        var actions = true;
        await tester.pumpWidget(
          MaterialApp(
            home: HyperTheme(
              data: HyperThemeData.light(),
              child: Scaffold(
                body: Center(
                  child: StatefulBuilder(
                    builder: (context, setState) {
                      update = setState;
                      final content = HyperForm(
                        controller: controller,
                        child: HyperTextFormField(
                          name: 'name',
                          initialValue: '初始值',
                        ),
                      );
                      final buttons = actions
                          ? <Widget>[
                              TextButton(
                                onPressed: () {},
                                child: const Text('操作'),
                              ),
                            ]
                          : <Widget>[];
                      return sheet
                          ? HyperBottomSheet(
                              content: content,
                              showCloseButton: header,
                              actions: buttons,
                            )
                          : HyperDialog(
                              content: content,
                              showCloseButton: header,
                              actions: buttons,
                            );
                    },
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        await tester.enterText(find.byType(EditableText), '保留输入');
        final form = tester.element(find.byType(HyperForm));
        final field = tester.element(find.byType(EditableText));
        for (final visible in [false, true, false, true]) {
          update(() {
            header = visible;
            actions = !actions;
          });
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expect(tester.element(find.byType(HyperForm)), same(form));
          expect(tester.element(find.byType(EditableText)), same(field));
          expect(controller.value<String>('name'), '保留输入');
          expect(
            tester
                .widget<EditableText>(find.byType(EditableText))
                .controller
                .text,
            '保留输入',
          );
        }
        await tester.pumpWidget(const SizedBox.shrink());
      },
    );
  }
}
