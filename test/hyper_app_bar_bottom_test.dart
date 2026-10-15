import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  for (final scale in [1.0, 1.3, 2.0]) {
    for (final variant in HyperAppBarVariant.values) {
      testWidgets('bottom reserves space and stays visible: $variant, $scale', (
        tester,
      ) async {
        const bottom = PreferredSize(
          preferredSize: Size.fromHeight(56),
          child: SizedBox(height: 56, child: Center(child: Text('筛选区'))),
        );
        final appBar = switch (variant) {
          HyperAppBarVariant.small => const HyperAppBar(
            title: Text('标题'),
            bottom: bottom,
          ),
          HyperAppBarVariant.medium => const HyperAppBar.medium(
            title: Text('标题'),
            bottom: bottom,
          ),
          HyperAppBarVariant.large => const HyperAppBar.large(
            title: Text('标题'),
            bottom: bottom,
          ),
        };
        await tester.pumpWidget(
          MaterialApp(
            home: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: HyperTheme(
                data: HyperThemeData.light(),
                child: HyperScaffold(
                  appBar: appBar,
                  body: ListView.builder(
                    itemCount: 50,
                    itemBuilder: (_, index) =>
                        SizedBox(height: 60, child: Text('结果 $index')),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final before = tester.getRect(find.byWidget(bottom));
        expect(
          tester.getTopLeft(find.text('结果 0')).dy,
          greaterThanOrEqualTo(before.bottom),
        );
        await tester.drag(find.byType(ListView), const Offset(0, -400));
        await tester.pumpAndSettle();
        final after = tester.getRect(find.byWidget(bottom));
        expect(after.height, 56);
        expect(after.top, greaterThanOrEqualTo(0));
        if (variant == HyperAppBarVariant.small) expect(after, before);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
