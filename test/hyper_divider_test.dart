import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  Widget app(Widget child, {HyperThemeData? theme}) => MaterialApp(
    home: HyperTheme(
      data: theme ?? HyperThemeData.light(),
      duration: Duration.zero,
      child: Center(child: child),
    ),
  );

  testWidgets('水平和垂直构造器使用明确方向', (tester) async {
    await tester.pumpWidget(
      app(
        const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HyperDivider(key: Key('horizontal'), length: 80, thickness: 2),
            SizedBox(
              height: 80,
              child: HyperDivider.vertical(key: Key('vertical'), thickness: 2),
            ),
          ],
        ),
      ),
    );

    expect(
      tester.getSize(find.byKey(const Key('horizontal'))),
      const Size(80, 2),
    );
    expect(
      tester.getSize(find.byKey(const Key('vertical'))),
      const Size(2, 80),
    );
  });

  testWidgets('实例尺寸优先于局部和全局主题', (tester) async {
    final theme = HyperThemeData.light().copyWith(
      dividerTheme: const HyperDividerThemeData(
        style: HyperDividerStyle(thickness: 2, length: 100),
      ),
    );
    await tester.pumpWidget(
      app(
        const HyperDividerTheme(
          data: HyperDividerThemeData(
            style: HyperDividerStyle(thickness: 4, length: 120),
          ),
          child: HyperDivider(key: Key('divider'), thickness: 6, length: 140),
        ),
        theme: theme,
      ),
    );

    expect(
      tester.getSize(find.byKey(const Key('divider'))),
      const Size(140, 6),
    );
  });

  testWidgets('缩进计入布局且不改变明确线长', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperDivider(
          key: Key('divider'),
          length: 80,
          thickness: 2,
          indent: 10,
          endIndent: 6,
        ),
      ),
    );

    expect(tester.getSize(find.byKey(const Key('divider'))), const Size(96, 2));
  });

  testWidgets('四种设备采用明确的默认粗细', (tester) async {
    for (final entry in <(HyperSizeScheme, double)>[
      (const HyperSizeScheme.phone(), 1),
      (const HyperSizeScheme.tablet(), 1),
      (const HyperSizeScheme.desktop(), 1),
      (const HyperSizeScheme.watch(), 2),
    ]) {
      await tester.pumpWidget(
        app(
          const HyperDivider(key: Key('divider'), length: 80),
          theme: HyperThemeData.light(
            sizes: HyperSizeThemeData(
              phone: entry.$1,
              tablet: entry.$1,
              desktop: entry.$1,
              watch: entry.$1,
            ),
          ),
        ),
      );
      expect(tester.getSize(find.byKey(const Key('divider'))).height, entry.$2);
    }
  });
}
