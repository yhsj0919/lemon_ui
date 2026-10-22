import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

class _RouteObserver extends NavigatorObserver {
  Route<dynamic>? last;
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    last = route;
  }
}

void main() {
  testWidgets('抽屉和弹窗默认采用同一浅遮罩并继承自定义遮罩', (tester) async {
    for (final dark in [false, true]) {
      for (final custom in [false, true]) {
        final base = dark ? HyperThemeData.dark() : HyperThemeData.light();
        final theme = custom
            ? base.copyWith(
                colors: base.colors.copyWith(scrim: const Color(0x11000000)),
              )
            : base;
        final observer = _RouteObserver();
        await tester.pumpWidget(
          MaterialApp(
            key: UniqueKey(),
            navigatorObservers: [observer],
            home: HyperTheme(
              data: theme,
              duration: Duration.zero,
              child: HyperScaffold(
                drawer: const HyperDrawer(child: Text('抽屉')),
                body: Builder(
                  builder: (context) => TextButton(
                    onPressed: () => showHyperDialog<void>(
                      context: context,
                      builder: (_) => const HyperDialog(content: Text('弹窗')),
                    ),
                    child: const Text('打开弹窗'),
                  ),
                ),
              ),
            ),
          ),
        );
        expect(
          tester
              .widget<Scaffold>(find.byType(Scaffold))
              .drawerScrimColor!
              .toARGB32(),
          custom ? 0x11000000 : 0x33000000,
        );
        await tester.tap(find.text('打开弹窗'));
        await tester.pumpAndSettle();
        expect(
          (observer.last! as ModalRoute).barrierColor!.toARGB32(),
          theme.colors.scrim.toARGB32(),
        );
      }
    }
  });

  testWidgets('弹窗显式透明遮罩仍优先', (tester) async {
    final observer = _RouteObserver();
    await tester.pumpWidget(
      MaterialApp(
        navigatorObservers: [observer],
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: Builder(
            builder: (context) => TextButton(
              onPressed: () => showHyperDialog<void>(
                context: context,
                style: const HyperDialogStyle(barrierColor: Colors.transparent),
                builder: (_) => const HyperDialog(content: Text('内容')),
              ),
              child: const Text('打开'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('打开'));
    await tester.pumpAndSettle();
    expect((observer.last! as ModalRoute).barrierColor, Colors.transparent);
  });
}
