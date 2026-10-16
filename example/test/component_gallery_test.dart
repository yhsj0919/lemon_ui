import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui_example/gallery/gallery_app.dart';

void main() {
  testWidgets('完整 Demo 保留 Hyper 主题及折叠菜单导航', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1440, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiGalleryApp());
    await tester.pumpAndSettle();
    final context = tester.element(find.byType(HyperScaffold));
    final theme = HyperTheme.of(context);
    expect(Theme.of(context).colorScheme.primary, theme.colors.primary);
    expect(find.byType(HyperSidebar), findsOneWidget);
    expect(find.text('Lemon UI 组件演示'), findsOneWidget);
    await tester.tap(find.text('基础能力'));
    await tester.pumpAndSettle();
    expect(find.text('HyperFill'), findsWidgets);
    await tester.ensureVisible(find.text('HyperContainerThemeData'));
    await tester.tap(find.text('HyperContainerThemeData'));
    await tester.pumpAndSettle();
    expect(find.text('容器主题：逐项覆盖与清除'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('窄屏 Demo 的抽屉能选择页面并关闭', (tester) async {
    await tester.binding.setSurfaceSize(const Size(480, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const LemonUiGalleryApp());
    await tester.pumpAndSettle();
    await tester.tap(
      find.byWidgetPredicate(
        (widget) => widget is HyperIconButton && widget.tooltip == '打开组件菜单',
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('基础能力'));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('HyperContainerThemeData'));
    await tester.tap(find.text('HyperContainerThemeData'));
    await tester.pumpAndSettle();
    expect(find.text('容器主题：逐项覆盖与清除'), findsOneWidget);
    expect(
      tester.state<ScaffoldState>(find.byType(Scaffold).first).isDrawerOpen,
      isFalse,
    );
    expect(tester.takeException(), isNull);
  });
}
