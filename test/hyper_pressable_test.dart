import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  Widget buildPressable({
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onLongPress,
    VoidCallback? onSecondaryTap,
    FocusNode? focusNode,
    ValueChanged<Set<HyperControlState>>? onStatesChanged,
  }) {
    return MaterialApp(
      home: Center(
        child: SizedBox(
          width: 160,
          height: 64,
          child: HyperPressable(
            focusNode: focusNode,
            onTap: onTap,
            onDoubleTap: onDoubleTap,
            onLongPress: onLongPress,
            onSecondaryTap: onSecondaryTap,
            onStatesChanged: onStatesChanged,
            enableFeedback: false,
            builder: (context, states, child) => ColoredBox(
              key: const Key('target'),
              color: states.contains(HyperControlState.pressed)
                  ? Colors.orange
                  : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('单击按下状态和回调使用原生手势生命周期', (tester) async {
    var taps = 0;
    final changes = <Set<HyperControlState>>[];
    await tester.pumpWidget(
      buildPressable(onTap: () => taps++, onStatesChanged: changes.add),
    );
    final gesture = await tester.startGesture(
      tester.getCenter(find.byKey(const Key('target'))),
    );
    await tester.pump();
    expect(changes.last, contains(HyperControlState.pressed));
    await gesture.up();
    await tester.pump();
    expect(taps, 1);
    expect(changes.last, isNot(contains(HyperControlState.pressed)));
  });

  testWidgets('单击和双击同时存在时不会额外触发单击', (tester) async {
    var taps = 0;
    var doubleTaps = 0;
    await tester.pumpWidget(
      buildPressable(onTap: () => taps++, onDoubleTap: () => doubleTaps++),
    );
    await tester.tap(find.byKey(const Key('target')));
    await tester.pump(const Duration(milliseconds: 50));
    await tester.tap(find.byKey(const Key('target')));
    await tester.pumpAndSettle();
    expect(doubleTaps, 1);
    expect(taps, 0);
  });

  testWidgets('长按产生 longPressed 并调用回调', (tester) async {
    var longPresses = 0;
    final changes = <Set<HyperControlState>>[];
    await tester.pumpWidget(
      buildPressable(
        onLongPress: () => longPresses++,
        onStatesChanged: changes.add,
      ),
    );
    await tester.longPress(find.byKey(const Key('target')));
    await tester.pumpAndSettle();
    expect(longPresses, 1);
    expect(
      changes.any((states) => states.contains(HyperControlState.longPressed)),
      isTrue,
    );
    expect(changes.last, isNot(contains(HyperControlState.longPressed)));
  });

  testWidgets('鼠标右键产生辅助按压状态并调用回调', (tester) async {
    var secondaryTaps = 0;
    final changes = <Set<HyperControlState>>[];
    await tester.pumpWidget(
      buildPressable(
        onSecondaryTap: () => secondaryTaps++,
        onStatesChanged: changes.add,
      ),
    );
    final gesture = await tester.createGesture(
      kind: PointerDeviceKind.mouse,
      buttons: kSecondaryMouseButton,
    );
    await gesture.down(tester.getCenter(find.byKey(const Key('target'))));
    await tester.pump();
    expect(changes.last, contains(HyperControlState.secondaryPressed));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(secondaryTaps, 1);
    expect(changes.last, isNot(contains(HyperControlState.secondaryPressed)));
  });

  testWidgets('键盘激活复用主点击回调', (tester) async {
    var taps = 0;
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await tester.pumpWidget(
      buildPressable(onTap: () => taps++, focusNode: focusNode),
    );
    focusNode.requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(taps, 1);
  });
}
