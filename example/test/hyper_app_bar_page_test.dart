import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/pages/framework/hyper_app_bar_page.dart';

void main() {
  testWidgets('AppBar Demo 展示滚动玻璃、普通和中等展开变体', (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperAppBarPage(),
        ),
      ),
    );

    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.byType(NestedScrollView), findsNothing);
    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(find.text('列表项目 1'), findsOneWidget);

    await tester.tap(find.text('普通'));
    await tester.pumpAndSettle();
    expect(find.byType(CustomScrollView), findsOneWidget);
    expect(find.text('普通顶栏'), findsOneWidget);
    expect(
      tester.widget<SliverAppBar>(find.byType(SliverAppBar)).centerTitle,
      isTrue,
    );

    await tester.tap(find.text('中等展开'));
    await tester.pumpAndSettle();
    expect(find.byType(CustomScrollView), findsOneWidget);

    await tester.tap(find.text('关闭玻璃'));
    await tester.pumpAndSettle();
    expect(find.byType(BackdropFilter), findsNothing);
  });

  testWidgets('AppBar Demo 占用状态栏下的页面顶栏', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 890));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        home: MediaQuery(
          data: const MediaQueryData(
            size: Size(400, 890),
            padding: EdgeInsets.only(top: 48),
          ),
          child: HyperTheme(
            data: HyperThemeData.light(),
            duration: Duration.zero,
            child: const Scaffold(body: HyperAppBarPage()),
          ),
        ),
      ),
    );

    expect(find.byType(HyperAppBar), findsNothing);
    expect(find.byType(HyperSliverAppBar), findsOneWidget);
    final settings = tester.widget<FlexibleSpaceBarSettings>(
      find.byType(FlexibleSpaceBarSettings),
    );
    expect(settings.minExtent, 106);
    expect(settings.maxExtent, 144);
    final title = find.descendant(
      of: find.byType(PositionedDirectional),
      matching: find.text('展开顶栏'),
    );
    expect(tester.getTopLeft(title).dy, 106);
  });

  testWidgets('桌面鼠标拖动列表可收起展开顶栏', (tester) async {
    await tester.binding.setSurfaceSize(const Size(900, 700));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(platform: TargetPlatform.windows),
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const HyperAppBarPage(),
        ),
      ),
    );
    final scroll = tester.state<ScrollableState>(find.byType(Scrollable));
    expect(scroll.position.pixels, 0);
    final scrollbarTop = tester.getTopLeft(find.byType(Scrollbar)).dy;
    final gesture = await tester.startGesture(
      tester.getCenter(find.text('列表项目 1')),
      kind: PointerDeviceKind.mouse,
    );
    await gesture.moveBy(const Offset(0, -180));
    await gesture.up();
    await tester.pumpAndSettle();
    expect(scroll.position.pixels, greaterThan(0));
    expect(tester.getTopLeft(find.byType(Scrollbar)).dy, scrollbarTop);
  });
}
