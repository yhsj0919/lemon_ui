import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final sheet in [false, true]) {
    testWidgets('${sheet ? 'BottomSheet' : 'Dialog'} 留在嵌套画布，显式参数可选择根导航', (
      tester,
    ) async {
      final innerKey = GlobalKey<NavigatorState>();
      final outerKey = GlobalKey<NavigatorState>();
      late BuildContext preview;
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: outerKey,
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Center(
              child: SizedBox(
                width: 300,
                height: 400,
                child: MaterialApp(
                  navigatorKey: innerKey,
                  home: HyperNavigatorScope(
                    useRootNavigator: false,
                    child: Builder(
                      builder: (context) {
                        preview = context;
                        return const Scaffold();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      void open({bool? root}) {
        if (sheet) {
          showHyperBottomSheet<void>(
            context: preview,
            useRootNavigator: root,
            builder: (_) => const HyperBottomSheet(content: Text('测试内容')),
          );
        } else {
          showHyperDialog<void>(
            context: preview,
            useRootNavigator: root,
            builder: (_) => const HyperDialog(content: Text('测试内容')),
          );
        }
      }

      open();
      await tester.pumpAndSettle();
      expect(innerKey.currentState!.canPop(), isTrue);
      expect(outerKey.currentState!.canPop(), isFalse);
      expect(
        tester.getSize(find.byType(ModalBarrier).last),
        const Size(300, 400),
      );
      innerKey.currentState!.pop();
      await tester.pumpAndSettle();
      open(root: true);
      await tester.pumpAndSettle();
      expect(outerKey.currentState!.canPop(), isTrue);
      outerKey.currentState!.pop();
      await tester.pumpAndSettle();
    });
  }
}
