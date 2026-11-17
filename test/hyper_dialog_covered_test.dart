import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('coverage policy merges, copies, interpolates and compares', () {
    const enabled = HyperDialogStyle(reduceTransparencyWhenCovered: true);
    final disabled = enabled.copyWith(reduceTransparencyWhenCovered: false);
    expect(enabled.merge(const HyperDialogStyle()), enabled);
    expect(enabled.merge(disabled), disabled);
    expect(enabled.copyWith(), enabled);
    expect(enabled.copyWith().hashCode, enabled.hashCode);
    expect(enabled, isNot(disabled));
    expect(HyperDialogStyle.lerp(enabled, disabled, .25), enabled);
    expect(HyperDialogStyle.lerp(enabled, disabled, .75), disabled);
  });

  for (final movable in [false, true]) {
    for (final policy in [null, false, true]) {
      for (final reduceTransparency in [false, true]) {
        testWidgets(
          'covered surface: movable=$movable policy=$policy reduced=$reduceTransparency',
          (tester) async {
            final navigator = GlobalKey<NavigatorState>();
            late BuildContext source;
            final focus = FocusNode();
            addTearDown(focus.dispose);
            await tester.pumpWidget(
              HyperTheme(
                data: HyperThemeData.light().copyWith(
                  materialTheme: HyperMaterialThemeData(
                    reduceTransparency: reduceTransparency,
                    quality: HyperMaterialQuality.advanced,
                    material: const HyperSurfaceMaterial.frostedGlass(),
                  ),
                ),
                child: MaterialApp(
                  navigatorKey: navigator,
                  home: Builder(
                    builder: (context) {
                      source = context;
                      return const Scaffold();
                    },
                  ),
                ),
              ),
            );
            final style = HyperDialogStyle(
              reduceTransparencyWhenCovered: policy,
              boxShadow: const [],
            );
            final content = SizedBox(
              key: const ValueKey('lower-content'),
              height: 80,
              child: TextField(focusNode: focus),
            );
            showHyperDialog<void>(
              context: source,
              style: style,
              builder: (_) => movable
                  ? HyperMovableDialog(
                      title: const Text('lower'),
                      content: content,
                    )
                  : HyperDialog(content: content),
            );
            await tester.pumpAndSettle();
            final surface = find
                .descendant(
                  of: find.byType(HyperDialog),
                  matching: find.byType(HyperMaterialSurface),
                )
                .first;
            bool backdropEnabled() => tester
                .widgetList<BackdropFilter>(
                  find.descendant(
                    of: surface,
                    matching: find.byType(BackdropFilter),
                  ),
                )
                .any((filter) => filter.enabled);
            expect(backdropEnabled(), !reduceTransparency);
            focus.requestFocus();
            await tester.pumpAndSettle();
            focus.unfocus();
            await tester.pumpAndSettle();
            expect(backdropEnabled(), !reduceTransparency);
            navigator.currentState!.push<void>(
              RawDialogRoute<void>(
                pageBuilder: (_, _, _) => const Center(child: Text('upper')),
                barrierDismissible: false,
              ),
            );
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 50));
            expect(backdropEnabled(), policy != true && !reduceTransparency);
            await tester.pumpAndSettle();
            expect(backdropEnabled(), policy != true && !reduceTransparency);
            expect(find.byKey(const ValueKey('lower-content')), findsOneWidget);
            navigator.currentState!.pop();
            await tester.pumpAndSettle();
            expect(backdropEnabled(), !reduceTransparency);
            await tester.pumpWidget(const SizedBox());
          },
        );
      }
    }
  }
}
