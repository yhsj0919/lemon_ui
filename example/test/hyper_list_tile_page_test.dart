import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/content/hyper_list_tile_page.dart';

void main() {
  testWidgets('列表项 Demo 使用默认组件组合展示主要状态', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperListTilePage(),
        ),
      ),
    );

    expect(find.text('默认高度'), findsOneWidget);
    expect(find.text('紧凑高度'), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('WLAN'),
      300,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('WLAN'), findsOneWidget);
    expect(find.text('Xiaomi_5G'), findsOneWidget);
    expect(find.byType(HyperNavigationListTile), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('保持亮屏'),
      400,
      scrollable: find.byType(Scrollable),
    );
    expect(find.byType(HyperSwitch), findsOneWidget);
    expect(find.byType(HyperSwitchListTile), findsOneWidget);
    expect(find.byType(HyperCheckbox), findsOneWidget);

    await tester.scrollUntilVisible(
      find.text('紧凑布局'),
      300,
      scrollable: find.byType(Scrollable),
    );
    expect(find.byType(HyperRadio<String>), findsNWidgets(2));
    await tester.tap(find.text('紧凑布局'));
    await tester.pump();
    expect(
      tester
          .widgetList<HyperRadio<String>>(find.byType(HyperRadio<String>))
          .every((radio) => radio.groupValue == 'compact'),
      isTrue,
    );

    await tester.scrollUntilVisible(
      find.text('不可用列表项'),
      300,
      scrollable: find.byType(Scrollable),
    );
    expect(find.text('不可用列表项'), findsOneWidget);
  });
}
