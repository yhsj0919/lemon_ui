import 'dart:async';

import 'package:flutter/gestures.dart';
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

  testWidgets('同步图标按钮触发操作并提供 Tooltip', (tester) async {
    var count = 0;
    await tester.pumpWidget(
      app(
        HyperIconButton.filled(
          tooltip: '添加',
          icon: const Icon(Icons.add),
          onPressed: () => count++,
        ),
      ),
    );

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(count, 1);
    expect(find.byTooltip('添加'), findsOneWidget);
  });

  testWidgets('异步期间显示进度且外部尺寸稳定', (tester) async {
    final completer = Completer<void>();
    await tester.pumpWidget(
      app(
        HyperIconButton.tonal(
          icon: const Icon(Icons.refresh),
          style: HyperIconButtonStyle(size: 56),
          onPressed: () => completer.future,
        ),
      ),
    );
    final before = tester.getSize(find.byType(HyperIconButton));
    await tester.tap(find.byIcon(Icons.refresh));
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    final progress = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(progress.color, isNot(progress.backgroundColor));
    expect(progress.backgroundColor!.a, lessThan(progress.color!.a));
    expect(tester.getSize(find.byType(HyperIconButton)), before);
    expect(
      tester.getSize(find.byType(CircularProgressIndicator)),
      const Size.square(18),
    );

    completer.complete();
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.refresh), findsOneWidget);
  });

  testWidgets('自定义图标按钮加载内容受进度尺寸约束', (tester) async {
    await tester.pumpWidget(
      app(
        HyperIconButton.filled(
          icon: const Icon(Icons.refresh),
          onPressed: () {},
          loading: true,
          loadingIndicator: const ColoredBox(
            key: Key('custom-icon-loading'),
            color: Colors.white,
          ),
        ),
      ),
    );

    expect(find.byKey(const Key('custom-icon-loading')), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(
      tester.getSize(find.byKey(const Key('custom-icon-loading'))),
      const Size.square(18),
    );
  });

  testWidgets('实例样式覆盖独立的全局图标按钮主题', (tester) async {
    final theme = HyperThemeData.light().copyWith(
      iconButtonTheme: HyperIconButtonThemeData(
        style: HyperIconButtonStyle(size: 52),
        filled: HyperIconButtonStyle(
          background: const HyperFill.color(Colors.red),
        ),
      ),
    );
    await tester.pumpWidget(
      app(
        HyperIconButton.filled(
          icon: const Icon(Icons.check),
          style: HyperIconButtonStyle(
            size: 60,
            background: const HyperFill.color(Colors.green),
          ),
          onPressed: () {},
        ),
        theme: theme,
      ),
    );

    final decorations = tester
        .widgetList<Container>(find.byType(Container))
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>();
    expect(decorations.any((value) => value.color == Colors.green), isTrue);
    expect(tester.getSize(find.byIcon(Icons.check)), const Size(24, 24));
  });

  testWidgets('禁用图标按钮不触发操作', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperIconButton.outlined(
          icon: Icon(Icons.block),
          onPressed: null,
        ),
      ),
    );
    await tester.tap(find.byIcon(Icons.block));
    await tester.pump();
    expect(find.byIcon(Icons.block), findsOneWidget);
  });

  testWidgets('手机与桌面使用独立的图标按钮尺寸', (tester) async {
    Future<void> pump(HyperSizeScheme sizes) => tester.pumpWidget(
      app(
        HyperIconButton.filled(
          icon: const Icon(Icons.settings),
          onPressed: () {},
        ),
        theme: HyperThemeData.light(
          sizes: HyperSizeThemeData(
            phone: sizes,
            tablet: sizes,
            desktop: sizes,
            watch: sizes,
          ),
        ),
      ),
    );

    await pump(const HyperSizeScheme.phone());
    var visual = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.decoration is BoxDecoration &&
          widget.constraints?.maxWidth == 40,
    );
    expect(tester.getSize(visual), const Size.square(40));
    expect(IconTheme.of(tester.element(find.byIcon(Icons.settings))).size, 24);

    await pump(const HyperSizeScheme.desktop());
    visual = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.decoration is BoxDecoration &&
          widget.constraints?.maxWidth == 32,
    );
    expect(tester.getSize(visual), const Size.square(32));
    expect(IconTheme.of(tester.element(find.byIcon(Icons.settings))).size, 16);
  });

  testWidgets('outlined 悬停使用统一中性遮罩而不是主题蓝', (tester) async {
    await tester.pumpWidget(
      app(
        HyperIconButton.outlined(
          icon: const Icon(Icons.share_outlined),
          onPressed: () {},
        ),
      ),
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.byIcon(Icons.share_outlined)));
    await tester.pump();

    final decorated = tester
        .widgetList<Container>(find.byType(Container))
        .firstWhere((widget) => widget.foregroundDecoration != null);
    final overlay = decorated.foregroundDecoration! as BoxDecoration;
    expect(overlay.color?.r, 0);
    expect(overlay.color?.g, 0);
    expect(overlay.color?.b, 0);
    expect(overlay.color?.a, closeTo(.07, .001));

    await mouse.removePointer();
  });

  testWidgets('局部主题逐字段继承全局图标按钮主题', (tester) async {
    final theme = HyperThemeData.light().copyWith(
      iconButtonTheme: HyperIconButtonThemeData(
        style: HyperIconButtonStyle(size: 56),
      ),
    );
    await tester.pumpWidget(
      app(
        HyperIconButtonTheme(
          data: HyperIconButtonThemeData(
            filled: HyperIconButtonStyle(iconSize: 30),
          ),
          child: HyperIconButton.filled(
            icon: const Icon(Icons.star),
            onPressed: () {},
          ),
        ),
        theme: theme,
      ),
    );

    final icon = tester.widget<Icon>(find.byIcon(Icons.star));
    expect(IconTheme.of(tester.element(find.byIcon(Icons.star))).size, 30);
    final visual = find.byWidgetPredicate(
      (widget) =>
          widget is Container &&
          widget.decoration is BoxDecoration &&
          (widget.decoration! as BoxDecoration).color == theme.colors.primary,
    );
    expect(visual, findsOneWidget);
    expect(tester.getSize(visual), const Size(56, 56));
    expect(icon.icon, Icons.star);
  });
}
