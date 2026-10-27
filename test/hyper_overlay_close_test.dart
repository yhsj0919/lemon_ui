import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('controlled anchor requests close and preserves typed result', (
    tester,
  ) async {
    var open = true;
    final results = <int?>[];
    late StateSetter update;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: StatefulBuilder(
            builder: (context, setState) {
              update = setState;
              return HyperAnchoredOverlay<int>(
                isOpen: open,
                onOpenChanged: (value) => update(() => open = value),
                onResult: results.add,
                anchor: const Text('anchor'),
                overlayBuilder: (context, close) => TextButton(
                  onPressed: () {
                    expect(HyperOverlay.close<int>(context, 7), isTrue);
                    expect(HyperOverlay.close<int>(context, 8), isFalse);
                  },
                  child: const Text('finish'),
                ),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('finish'));
    await tester.pumpAndSettle();
    expect(open, isFalse);
    expect(results, [7]);
    update(() => open = true);
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(700, 500));
    await tester.pumpAndSettle();
    expect(results.last, isNull);
  });
  testWidgets('stale outer context cannot pop a newer dialog', (tester) async {
    late BuildContext outer;
    String? innerResult;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () => showHyperDialog<void>(
                context: context,
                builder: (context) {
                  outer = context;
                  return TextButton(
                    onPressed: () async {
                      innerResult = await showHyperDialog<String>(
                        context: context,
                        builder: (context) => TextButton(
                          onPressed: () =>
                              HyperOverlay.close<String>(context, 'inner'),
                          child: const Text('inner'),
                        ),
                      );
                    },
                    child: const Text('outer'),
                  );
                },
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('outer'));
    await tester.pumpAndSettle();
    expect(HyperOverlay.close(outer), isFalse);
    await tester.tap(find.text('inner'));
    await tester.pumpAndSettle();
    expect(innerResult, 'inner');
    expect(find.text('outer'), findsOneWidget);
    expect(HyperOverlay.close(outer), isTrue);
    await tester.pumpAndSettle();
    expect(find.text('open'), findsOneWidget);
  });
  Widget app(Widget child) => MaterialApp(
    home: HyperTheme(data: HyperThemeData.light(), child: child),
  );

  for (final sheet in [false, true]) {
    testWidgets('modal closes with result, sheet=$sheet', (tester) async {
      String? result;
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async {
                Widget panel(BuildContext context) => TextButton(
                  onPressed: () => HyperOverlay.close<String>(context, 'saved'),
                  child: const Text('finish'),
                );
                result = sheet
                    ? await showHyperBottomSheet<String>(
                        context: context,
                        builder: panel,
                      )
                    : await showHyperDialog<String>(
                        context: context,
                        builder: panel,
                      );
              },
              child: const Text('open'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('finish'));
      await tester.pumpAndSettle();
      expect(result, 'saved');
      expect(find.text('open'), findsOneWidget);
      expect(find.text('finish'), findsNothing);
    });
  }

  testWidgets(
    'anchored result closes only the inner layer; page close is safe',
    (tester) async {
      int? result;
      late BuildContext page;
      await tester.pumpWidget(
        app(
          Builder(
            builder: (context) {
              page = context;
              return HyperPopover<int>(
                anchor: const Text('anchor'),
                onResult: (value) => result = value,
                contentBuilder: (context, close) => TextButton(
                  onPressed: () => HyperOverlay.close<int>(context, 42),
                  child: const Text('finish'),
                ),
              );
            },
          ),
        ),
      );
      expect(HyperOverlay.close(page), isFalse);
      await tester.tap(find.text('anchor'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('finish'));
      await tester.pumpAndSettle();
      expect(result, 42);
      expect(find.text('finish'), findsNothing);
      expect(find.text('anchor'), findsOneWidget);
    },
  );

  testWidgets('nested scopes never fall through to outer close', (
    tester,
  ) async {
    var outerCalls = 0;
    await tester.pumpWidget(
      app(
        HyperOverlayScope<void>(
          onClose: (_) {
            outerCalls++;
            return true;
          },
          child: HyperOverlayScope<int>(
            onClose: (_) => false,
            child: Builder(
              builder: (context) => TextButton(
                onPressed: () => HyperOverlay.close<int>(context, 1),
                child: const Text('close'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('close'));
    expect(outerCalls, 0);
  });
}
