import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('50 wide rail keeps equal button edge insets', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: HyperSidebarTheme(
            data: const HyperSidebarThemeData(
              style: HyperSidebarStyle(
                collapsedWidth: 50,
                itemHeight: 32,
                horizontalPadding: 9,
                verticalPadding: 9,
                collapsedRowGap: 8,
              ),
            ),
            child: Center(
              child: SizedBox(
                width: 50,
                height: 90,
                child: HyperNavigationBar<int>(
                  direction: Axis.vertical,
                  selectedValue: 0,
                  onSelected: (_) {},
                  destinations: const [
                    HyperNavigationDestination(
                      value: 0,
                      label: 'One',
                      icon: Icon(Icons.home),
                    ),
                    HyperNavigationDestination(
                      value: 1,
                      label: 'Two',
                      enabled: false,
                      icon: Icon(Icons.settings),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
    final rail = tester.getRect(find.byType(HyperSidebar));
    final first = tester.getRect(
      find.byKey(const ValueKey('hyper-sidebar-item-0')),
    );
    final last = tester.getRect(
      find.byKey(const ValueKey('hyper-sidebar-item-1')),
    );
    expect(first.left - rail.left, 9);
    expect(rail.right - first.right, 9);
    expect(first.top - rail.top, 9);
    expect(rail.bottom - last.bottom, 9);
    expect(
      IconTheme.of(tester.element(find.byIcon(Icons.settings))).color,
      HyperThemeData.light().colors.disabled,
    );
    expect(tester.takeException(), isNull);
  });
  for (final height in [100.0, 320.0]) {
    for (final placement in HyperNavigationLabelPlacement.values) {
      testWidgets('shared sidebar builds and selects $placement at $height', (
        tester,
      ) async {
        var selected = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: HyperTheme(
              data: HyperThemeData.light(),
              duration: Duration.zero,
              child: Scaffold(
                body: Align(
                  alignment: Alignment.topLeft,
                  child: SizedBox(
                    width: placement == HyperNavigationLabelPlacement.beside
                        ? 300
                        : 80,
                    height: height,
                    child: HyperNavigationBar<int>(
                      direction: Axis.vertical,
                      labelPlacement: placement,
                      selectedValue: selected,
                      onSelected: (value) => selected = value,
                      destinations: const [
                        HyperNavigationDestination(
                          value: 0,
                          label: 'Home',
                          icon: Icon(Icons.home),
                        ),
                        HyperNavigationDestination(
                          value: 1,
                          label: 'Settings',
                          icon: Icon(Icons.settings),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        expect(find.byType(HyperSidebar), findsOneWidget);
        expect(find.byType(HyperMaterialSurface), findsOneWidget);
        expect(tester.takeException(), isNull);
        await tester.ensureVisible(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Icons.settings));
        await tester.pumpAndSettle();
        expect(selected, 1);
        expect(tester.takeException(), isNull);
      });
    }
  }
}
