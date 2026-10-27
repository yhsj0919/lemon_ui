import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/painting/hyper_box_decoration.dart';

void main() {
  testWidgets('global material is inherited below state material overrides', (
    tester,
  ) async {
    final global = HyperSurfaceMaterial.frostedGlass();
    final disabled = HyperSurfaceMaterial.solid(
      background: const HyperFill.color(Colors.red),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light().copyWith(
            materialTheme: HyperMaterialThemeData(material: global),
            textFieldTheme: HyperTextFieldThemeData(
              disabled: HyperTextFieldStyle(material: disabled),
            ),
          ),
          child: Scaffold(
            body: Column(
              children: [
                HyperNumberInput(value: 1, onChanged: (_) {}),
                HyperNumberInput(value: 1, enabled: false, onChanged: (_) {}),
              ],
            ),
          ),
        ),
      ),
    );
    final fields = find.byType(HyperTextField).evaluate().toList();
    final materials = fields
        .map(
          (field) => tester
              .widget<HyperMaterialSurface>(
                find.descendant(
                  of: find.byWidget(field.widget),
                  matching: find.byType(HyperMaterialSurface),
                ),
              )
              .material,
        )
        .toList();
    expect(materials, [global, disabled]);
  });

  testWidgets('text field retains editing state across material changes', (
    tester,
  ) async {
    var material = false;
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                update = setState;
                return HyperTextField(
                  style: HyperTextFieldStyle(
                    material: material
                        ? const HyperSurfaceMaterial.solid()
                        : null,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
    await tester.enterText(find.byType(EditableText), '123');
    final editable = tester.widget<EditableText>(find.byType(EditableText));
    editable.controller.selection = const TextSelection(
      baseOffset: 1,
      extentOffset: 2,
    );
    final element = tester.element(find.byType(EditableText));
    for (final next in [true, false, true]) {
      update(() => material = next);
      await tester.pumpAndSettle();
      expect(tester.element(find.byType(EditableText)), same(element));
      expect(editable.controller.text, '123');
      expect(
        editable.controller.selection,
        const TextSelection(baseOffset: 1, extentOffset: 2),
      );
      expect(editable.focusNode.hasFocus, isTrue);
    }
  });

  Widget host(Widget child) => MaterialApp(
    home: HyperTheme(
      duration: Duration.zero,
      data: HyperThemeData.light().copyWith(
        textFieldTheme: const HyperTextFieldThemeData(
          style: HyperTextFieldStyle(
            foregroundColor: Colors.blue,
            background: HyperFill.color(Colors.blue),
          ),
          disabled: HyperTextFieldStyle(foregroundColor: Colors.red),
          hovered: HyperTextFieldStyle(background: HyperFill.color(Colors.red)),
          focused: HyperTextFieldStyle(foregroundColor: Colors.green),
        ),
      ),
      child: Scaffold(
        body: Center(child: SizedBox(width: 240, child: child)),
      ),
    ),
  );

  for (final layout in HyperNumberInputLayout.values) {
    for (final explicit in [false, true]) {
      testWidgets(
        '$layout disabled theme and explicit foreground precedence: $explicit',
        (tester) async {
          await tester.pumpWidget(
            host(
              HyperNumberInput(
                layout: layout,
                value: 1,
                enabled: false,
                onChanged: (_) {},
                style: explicit
                    ? const HyperTextFieldStyle(foregroundColor: Colors.purple)
                    : null,
              ),
            ),
          );
          expect(
            tester.widget<EditableText>(find.byType(EditableText)).style.color,
            explicit ? Colors.purple : Colors.red,
          );
        },
      );
    }
    testWidgets('$layout focused theme overrides base foreground', (
      tester,
    ) async {
      await tester.pumpWidget(
        host(HyperNumberInput(layout: layout, value: 1, onChanged: (_) {})),
      );
      await tester.tap(find.byType(EditableText));
      await tester.pumpAndSettle();
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).style.color,
        Colors.green,
      );
    });
  }

  testWidgets('vertical stepper preserves input hover background', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(HyperNumberInput(value: 1, onChanged: (_) {})),
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    addTearDown(mouse.removePointer);
    await mouse.moveTo(tester.getCenter(find.byType(EditableText)));
    await tester.pumpAndSettle();
    final backgrounds = tester
        .widgetList<DecoratedBox>(
          find.descendant(
            of: find.byType(HyperTextField),
            matching: find.byType(DecoratedBox),
          ),
        )
        .map((box) => box.decoration)
        .whereType<HyperBoxDecoration>()
        .map((decoration) => decoration.color);
    expect(backgrounds, contains(Colors.red));
  });
}
