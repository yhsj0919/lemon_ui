import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final sheet in [true, false]) {
    testWidgets('打开期间更新调用处主题：bottomSheet=$sheet', (tester) async {
      late BuildContext source;
      Color? observed;
      Widget app(HyperThemeData data) => MaterialApp(
        home: HyperTheme(
          data: data,
          duration: Duration.zero,
          child: Builder(
            builder: (context) {
              source = context;
              return const Scaffold();
            },
          ),
        ),
      );
      Widget content(BuildContext context) {
        observed = HyperTheme.of(context).colors.textPrimary;
        return const Text('主题内容');
      }

      await tester.pumpWidget(app(HyperThemeData.light()));
      if (sheet) {
        showHyperBottomSheet<void>(
          context: source,
          builder: (context) =>
              HyperBottomSheet(content: Builder(builder: content)),
        );
      } else {
        showHyperDialog<void>(
          context: source,
          builder: (context) => HyperDialog(content: Builder(builder: content)),
        );
      }
      await tester.pumpAndSettle();
      expect(observed, HyperThemeData.light().colors.textPrimary);
      await tester.pumpWidget(app(HyperThemeData.dark()));
      await tester.pumpAndSettle();
      expect(observed, HyperThemeData.dark().colors.textPrimary);
      Navigator.of(source).pop();
      await tester.pumpAndSettle();
    });
  }
}
