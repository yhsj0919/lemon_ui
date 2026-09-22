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

  testWidgets('不同设备使用明确的默认图标尺寸', (tester) async {
    for (final entry in <(HyperSizeScheme, double)>[
      (const HyperSizeScheme.phone(), 24),
      (const HyperSizeScheme.tablet(), 24),
      (const HyperSizeScheme.desktop(), 18),
      (const HyperSizeScheme.watch(), 20),
    ]) {
      await tester.pumpWidget(
        app(
          const HyperIcon(Icons.home),
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
      expect(tester.widget<Icon>(find.byType(Icon)).size, entry.$2);
    }
  });

  testWidgets('实例属性优先于局部和全局主题', (tester) async {
    final theme = HyperThemeData.light().copyWith(
      iconTheme: const HyperIconThemeData(
        style: HyperIconStyle(
          color: HyperStateValue.all(Colors.red),
          size: HyperStateValue.all(20),
        ),
      ),
    );
    await tester.pumpWidget(
      app(
        const HyperIconTheme(
          data: HyperIconThemeData(
            style: HyperIconStyle(
              color: HyperStateValue.all(Colors.green),
              size: HyperStateValue.all(26),
            ),
          ),
          child: HyperIcon(Icons.home, color: Colors.blue, size: 30),
        ),
        theme: theme,
      ),
    );

    final icon = tester.widget<Icon>(find.byType(Icon));
    expect(icon.color, Colors.blue);
    expect(icon.size, 30);
  });

  testWidgets('状态样式遵守统一状态优先级', (tester) async {
    await tester.pumpWidget(
      app(
        HyperIcon(
          Icons.favorite,
          states: const {
            HyperControlState.selected,
            HyperControlState.disabled,
          },
          style: HyperIconStyle(
            color: HyperStateValue.fromMap(
              fallback: Colors.black,
              values: const {
                HyperControlState.selected: Colors.blue,
                HyperControlState.disabled: Colors.grey,
              },
            ),
          ),
        ),
      ),
    );

    expect(tester.widget<Icon>(find.byType(Icon)).color, Colors.grey);
  });

  testWidgets('自定义图标内容接收解析后的 IconTheme', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperIcon.widget(
          Icon(Icons.bolt),
          color: Colors.orange,
          size: 31,
          semanticLabel: '闪电',
        ),
      ),
    );

    final icon = tester.widget<Icon>(find.byType(Icon));
    final iconTheme = IconTheme.of(tester.element(find.byType(Icon)));
    expect(icon.color, isNull);
    expect(iconTheme.color, Colors.orange);
    expect(iconTheme.size, 31);
    expect(find.bySemanticsLabel('闪电'), findsOneWidget);
  });
}
