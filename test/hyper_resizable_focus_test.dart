import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets(
    'pointer release clears highlight and focus before pointer exit',
    (t) async {
      bool active = false;
      await t.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: Scaffold(
              body: SizedBox(
                width: 400,
                height: 200,
                child: HyperResizable(
                  panes: [
                    HyperResizablePane(child: const SizedBox()),
                    HyperResizablePane(child: const SizedBox()),
                  ],
                  handleBuilder: (_, i, value) {
                    active = value;
                    return const ColoredBox(
                      key: ValueKey('handle'),
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      );
      final mouse = await t.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: const Offset(500, 300));
      addTearDown(mouse.removePointer);
      await mouse.moveTo(t.getCenter(find.byKey(const ValueKey('handle'))));
      await t.pumpAndSettle();
      expect(active, isTrue);
      await mouse.down(t.getCenter(find.byKey(const ValueKey('handle'))));
      await mouse.moveBy(const Offset(30, 0));
      await mouse.up();
      await t.pumpAndSettle();
      expect(active, isFalse);
      final handleFocus = t
          .widget<Focus>(
            find
                .ancestor(
                  of: find.byKey(const ValueKey('handle')),
                  matching: find.byType(Focus),
                )
                .first,
          )
          .focusNode;
      expect(handleFocus?.hasFocus ?? false, isFalse);
      await mouse.moveTo(const Offset(500, 300));
      await t.pumpAndSettle();
      expect(active, isFalse);
      handleFocus!.requestFocus();
      await t.pump();
      await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
      await t.pumpAndSettle();
      expect(active, isTrue);
      expect(t.takeException(), isNull);
    },
  );
}
