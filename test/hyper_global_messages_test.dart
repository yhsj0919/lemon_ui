import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

class _Routes extends RouterDelegate<Object>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  @override
  Future<void> setNewRoutePath(Object configuration) async {}
  @override
  Widget build(BuildContext context) => Navigator(
    key: navigatorKey,
    pages: const [MaterialPage(child: Scaffold(body: Text('route')))],
    onDidRemovePage: (_) {},
  );
}

void main() {
  testWidgets(
    'replacing the service retires old requests without sharing state',
    (tester) async {
      final first = HyperMessages();
      final second = HyperMessages(
        presentation: HyperMessagePresentation.notification,
      );
      Widget app(HyperMessages messages) => MaterialApp(
        builder: (_, child) => HyperTheme(
          data: HyperThemeData.light(),
          child: HyperMessageHost(messages: messages, child: child!),
        ),
        home: const Scaffold(),
      );
      await tester.pumpWidget(app(first));
      final old = first.show(
        content: const Text('old'),
        duration: Duration.zero,
      );
      await tester.pumpAndSettle();
      await tester.pumpWidget(app(second));
      await tester.pumpAndSettle();
      expect(await old.closed, HyperMessageCloseReason.hostDisposed);
      expect(first.isAttached, isFalse);
      expect(second.isAttached, isTrue);
      second.show(content: const Text('new'), duration: Duration.zero);
      await tester.pumpAndSettle();
      expect(find.byType(HyperNotification), findsOneWidget);
      expect(find.text('old'), findsNothing);
      await tester.pumpWidget(const SizedBox());
      first.dispose();
      second.dispose();
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets(
    'router builder supports context-free switching and notification close above dialog',
    (tester) async {
      final messages = HyperMessages();
      final routes = _Routes();
      Widget app(HyperThemeData theme) => MaterialApp.router(
        routerDelegate: routes,
        builder: (_, child) => HyperTheme(
          data: theme,
          duration: Duration.zero,
          child: HyperMessageHost(messages: messages, child: child!),
        ),
      );
      await tester.pumpWidget(
        app(
          HyperThemeData.light().copyWith(
            materialTheme: const HyperMaterialThemeData(
              quality: HyperMaterialQuality.advanced,
              material: HyperSurfaceMaterial.frostedGlass(),
            ),
          ),
        ),
      );
      final toast = messages.show(
        content: const Text('global toast'),
        duration: Duration.zero,
      );
      await tester.pumpAndSettle();
      expect(find.text('global toast'), findsOneWidget);
      expect(
        tester
            .widgetList<BackdropFilter>(find.byType(BackdropFilter))
            .any((filter) => filter.enabled),
        isTrue,
      );
      toast.close();
      await tester.pumpAndSettle();
      expect(await toast.closed, HyperMessageCloseReason.dismissed);
      final legacy = showHyperToast(
        routes.navigatorKey.currentContext!,
        content: const Text('context toast'),
        duration: Duration.zero,
      );
      await tester.pumpAndSettle();
      expect(find.text('context toast'), findsOneWidget);
      legacy.close();
      await tester.pumpAndSettle();
      showDialog<void>(
        context: routes.navigatorKey.currentContext!,
        builder: (_) => const AlertDialog(content: Text('dialog')),
      );
      await tester.pumpAndSettle();
      messages.presentation = HyperMessagePresentation.snackbar;
      var clicked = false;
      final snackbar = messages.show(
        content: const Text('global snackbar'),
        action: TextButton(
          onPressed: () => clicked = true,
          child: const Text('action'),
        ),
        duration: Duration.zero,
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('action'));
      expect(clicked, isTrue);
      snackbar.close();
      await tester.pumpAndSettle();
      final notification = messages.show(
        presentation: HyperMessagePresentation.notification,
        title: const Text('title'),
        content: const Text('card'),
        duration: Duration.zero,
      );
      await tester.pumpAndSettle();
      expect(find.byType(HyperNotification), findsOneWidget);
      await tester.pumpWidget(app(HyperThemeData.dark()));
      await tester.pumpAndSettle();
      expect(find.text('card'), findsOneWidget);
      await tester.tap(
        find
            .descendant(
              of: find.byType(HyperNotification),
              matching: find.byType(HyperIconButton),
            )
            .last,
      );
      await tester.pumpAndSettle();
      expect(await notification.closed, HyperMessageCloseReason.dismissed);
      routes.navigatorKey.currentState!.pop();
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox());
      expect(messages.isAttached, isFalse);
      expect(
        () => messages.show(content: const Text('unmounted')),
        throwsStateError,
      );
      messages.dispose();
      routes.dispose();
    },
  );

  testWidgets(
    'unmount completes visible and queued handles; global instance can remount',
    (tester) async {
      Widget app(String label) => MaterialApp(
        builder: (_, child) => HyperTheme(
          data: HyperThemeData.light(),
          child: HyperMessageHost(child: child!),
        ),
        home: Scaffold(body: Text(label)),
      );
      await tester.pumpWidget(app('first'));
      final first = HyperMessages.global.show(
        presentation: HyperMessagePresentation.snackbar,
        content: const Text('one'),
        duration: Duration.zero,
      );
      final queued = HyperMessages.global.show(
        presentation: HyperMessagePresentation.snackbar,
        content: const Text('two'),
        duration: Duration.zero,
      );
      await tester.pumpAndSettle();
      await tester.pumpWidget(app('updated'));
      await tester.pumpAndSettle();
      expect(find.text('updated'), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
      expect(await first.closed, HyperMessageCloseReason.hostDisposed);
      expect(await queued.closed, HyperMessageCloseReason.hostDisposed);
      await tester.pumpWidget(app('remounted'));
      HyperMessages.global.show(
        content: const Text('again'),
        duration: const Duration(milliseconds: 50),
      );
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();
      expect(find.text('again'), findsNothing);
      await tester.pumpWidget(const SizedBox());
      expect(tester.takeException(), isNull);
    },
  );
}
