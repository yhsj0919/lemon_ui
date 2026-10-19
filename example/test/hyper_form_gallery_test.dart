import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/form/hyper_form_page.dart';

void main() {
  testWidgets(
    'form gallery mounts all layouts and async errors remain scoped',
    (tester) async {
      tester.view.physicalSize = const Size(1000, 9000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: const Scaffold(body: HyperFormPage()),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HyperForm), findsNWidgets(3));
      final forms = tester
          .widgetList<HyperForm>(find.byType(HyperForm))
          .toList();
      await tester.enterText(find.byType(TextField).first, 'admin');
      await tester.pumpAndSettle();
      final result = forms.first.controller.validate();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 350));
      expect(await result, false);
      await tester.pumpAndSettle();
      expect(find.text('该用户名已被使用'), findsOneWidget);
      forms.first.controller.reset();
      await tester.pumpAndSettle();
      expect(
        tester.widget<TextField>(find.byType(TextField).first).controller!.text,
        '',
      );
      expect(forms[1].controller.isDirty, false);
      expect(tester.takeException(), isNull);
      await tester.pumpWidget(const SizedBox());
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    },
  );
}
