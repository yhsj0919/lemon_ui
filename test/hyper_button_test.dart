import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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

  Finder buttonVisual() => find.descendant(
    of: find.byType(HyperButton),
    matching: find.byWidgetPredicate(
      (widget) => widget is AnimatedContainer && widget.decoration != null,
    ),
  );

  Finder buttonPadding(EdgeInsetsGeometry padding) => find.descendant(
    of: buttonVisual(),
    matching: find.byWidgetPredicate(
      (widget) => widget is Padding && widget.padding == padding,
    ),
  );

  testWidgets('同步按钮触发一次操作', (tester) async {
    var count = 0;
    await tester.pumpWidget(
      app(
        HyperButton.filled(onPressed: () => count++, child: const Text('保存')),
      ),
    );
    await tester.tap(find.text('保存'));
    await tester.pump();
    expect(count, 1);
  });

  testWidgets('异步期间自动显示进度并保持外部尺寸稳定', (tester) async {
    final completer = Completer<void>();
    await tester.pumpWidget(
      app(
        HyperButton.gradient(
          onPressed: () => completer.future,
          icon: const Icon(Icons.save),
          label: const Text('异步保存'),
        ),
      ),
    );
    final before = tester.getSize(find.byType(HyperButton));
    await tester.tap(find.text('异步保存'));
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    final progress = tester.widget<CircularProgressIndicator>(
      find.byType(CircularProgressIndicator),
    );
    expect(progress.color, isNot(progress.backgroundColor));
    expect(progress.backgroundColor!.a, lessThan(progress.color!.a));
    expect(tester.getSize(find.byType(HyperButton)), before);

    final loadingVisual = tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .firstWhere((widget) => widget.decoration != null);
    final loadingDecoration = loadingVisual.decoration! as BoxDecoration;
    expect(loadingDecoration.gradient, isNotNull);

    await tester.pump(const Duration(milliseconds: 60));
    final opacityValues = tester
        .widgetList<AnimatedOpacity>(find.byType(AnimatedOpacity))
        .map((widget) => widget.opacity)
        .toList();
    expect(opacityValues, containsAll(<double>[0, 1]));

    completer.complete();
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(
      tester
          .widget<TickerMode>(
            find
                .ancestor(
                  of: find.byType(CircularProgressIndicator),
                  matching: find.byType(TickerMode),
                )
                .first,
          )
          .enabled,
      isFalse,
    );
    expect(find.text('异步保存'), findsOneWidget);
  });

  testWidgets('自定义加载内容替换默认圆环且不改变按钮尺寸', (tester) async {
    final completer = Completer<void>();
    await tester.pumpWidget(
      app(
        HyperButton.filled(
          onPressed: () => completer.future,
          loadingIndicator: const ColoredBox(
            key: Key('custom-loading'),
            color: Colors.white,
          ),
          child: const Text('提交'),
        ),
      ),
    );
    final before = tester.getSize(find.byType(HyperButton));

    await tester.tap(find.text('提交'));
    await tester.pump();

    expect(find.byKey(const Key('custom-loading')), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(
      tester.getSize(find.byKey(const Key('custom-loading'))),
      const Size.square(18),
    );
    expect(tester.getSize(find.byType(HyperButton)), before);

    completer.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('禁用按钮不触发操作', (tester) async {
    await tester.pumpWidget(
      app(const HyperButton.outlined(onPressed: null, child: Text('不可用'))),
    );
    await tester.tap(find.text('不可用'));
    await tester.pump();
    expect(find.text('不可用'), findsOneWidget);
  });

  testWidgets('手机按钮采用 MIUIX 基准样式', (tester) async {
    await tester.pumpWidget(
      app(
        HyperButton.filled(onPressed: () {}, child: const Text('手机')),
        theme: HyperThemeData.light(
          sizes: const HyperSizeThemeData(tablet: HyperSizeScheme.phone()),
        ),
      ),
    );
    final visual = tester.widget<Container>(
      find.byWidgetPredicate(
        (widget) => widget is Container && widget.decoration is BoxDecoration,
      ),
    );
    expect(visual.constraints?.minWidth, 58);
    expect(visual.constraints?.minHeight, 48);
    expect(visual.padding, isNull);
    expect(
      buttonPadding(const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
      findsOneWidget,
    );
    expect(
      (visual.decoration! as BoxDecoration).borderRadius,
      BorderRadius.circular(16),
    );
    final text = tester.widget<DefaultTextStyle>(
      find
          .ancestor(
            of: find.text('手机'),
            matching: find.byType(DefaultTextStyle),
          )
          .first,
    );
    expect(text.style.fontSize, 16);
  });

  testWidgets('40 高度手机按钮的文字完整并垂直居中', (tester) async {
    await tester.pumpWidget(
      app(
        HyperButton.filled(
          onPressed: () {},
          style: HyperButtonStyle(height: 40, minimumSize: const Size(58, 40)),
          child: const HyperText('紧凑按钮'),
        ),
        theme: HyperThemeData.light(
          sizes: const HyperSizeThemeData(tablet: HyperSizeScheme.phone()),
        ),
      ),
    );

    final visual = buttonVisual();
    final visualRect = tester.getRect(visual);
    final textRect = tester.getRect(find.text('紧凑按钮'));
    final text = tester.widget<Text>(find.text('紧凑按钮'));

    expect(visualRect.height, 40);
    expect(text.style?.fontSize, 16);
    expect(text.style?.height, isNull);
    expect(textRect.top, greaterThanOrEqualTo(visualRect.top));
    expect(textRect.bottom, lessThanOrEqualTo(visualRect.bottom));
    expect(textRect.center.dy, closeTo(visualRect.center.dy, .01));
  });

  testWidgets('不对称内边距作为整体相对固定尺寸按钮居中', (tester) async {
    const padding = EdgeInsets.fromLTRB(8, 3, 24, 11);
    await tester.pumpWidget(
      app(
        HyperButton.filled(
          onPressed: () {},
          style: HyperButtonStyle(width: 180, height: 72, padding: padding),
          child: const HyperText('居中内容'),
        ),
      ),
    );

    final visualRect = tester.getRect(buttonVisual());
    final paddedRect = tester.getRect(buttonPadding(padding));
    expect(paddedRect.center, visualRect.center);
  });

  testWidgets('图标和文字作为完整内容组居中', (tester) async {
    await tester.pumpWidget(
      app(
        HyperButton.filled(
          onPressed: () {},
          style: HyperButtonStyle(width: 200, height: 64),
          icon: const Icon(Icons.remove),
          label: const HyperText('减少'),
        ),
      ),
    );

    final row = find.descendant(of: buttonVisual(), matching: find.byType(Row));
    expect(tester.getRect(row).center, tester.getRect(buttonVisual()).center);
    final paragraph = tester.renderObject<RenderParagraph>(find.text('减少'));
    expect(paragraph.size.height, greaterThan(0));
  });

  testWidgets('手机按钮在Wrap中按内容收缩而不占满整行', (tester) async {
    await tester.pumpWidget(
      app(
        SizedBox(
          width: 320,
          child: Wrap(
            children: [
              HyperButton.filled(onPressed: () {}, child: const Text('Filled')),
            ],
          ),
        ),
        theme: HyperThemeData.light(
          sizes: const HyperSizeThemeData(tablet: HyperSizeScheme.phone()),
        ),
      ),
    );

    final visual = buttonVisual();
    expect(tester.getSize(visual).width, lessThan(320));
    expect(tester.getSize(visual).width, greaterThanOrEqualTo(58));
    expect(tester.getSize(visual).height, 48);
  });

  testWidgets('桌面按钮使用独立紧凑尺寸', (tester) async {
    await tester.pumpWidget(
      app(
        HyperButton.filled(onPressed: () {}, child: const Text('桌面')),
        theme: HyperThemeData.light(
          sizes: const HyperSizeThemeData(tablet: HyperSizeScheme.desktop()),
        ),
      ),
    );
    final visual = tester.widget<Container>(
      find.byWidgetPredicate(
        (widget) => widget is Container && widget.decoration is BoxDecoration,
      ),
    );
    expect(visual.constraints?.minWidth, 52);
    expect(visual.constraints?.minHeight, 36);
    expect(visual.padding, isNull);
    expect(
      buttonPadding(const EdgeInsets.symmetric(horizontal: 14, vertical: 8)),
      findsOneWidget,
    );
    expect(
      (visual.decoration! as BoxDecoration).borderRadius,
      BorderRadius.circular(10),
    );
    final text = tester.widget<DefaultTextStyle>(
      find
          .ancestor(
            of: find.text('桌面'),
            matching: find.byType(DefaultTextStyle),
          )
          .first,
    );
    expect(text.style.fontSize, 14);
  });

  testWidgets('按钮消费主题中覆盖的组件尺寸', (tester) async {
    const base = HyperSizeScheme.desktop();
    final sizes = base.copyWith(
      button: base.button.copyWith(
        minimumSize: const Size(88, 42),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      ),
    );

    await tester.pumpWidget(
      app(
        HyperButton.filled(onPressed: () {}, child: const Text('自定义')),
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

    final visual = tester.widget<AnimatedContainer>(buttonVisual());
    expect(visual.constraints?.minWidth, 88);
    expect(visual.constraints?.minHeight, 42);
    expect(
      buttonPadding(const EdgeInsets.symmetric(horizontal: 20, vertical: 9)),
      findsOneWidget,
    );
  });

  testWidgets('禁用按钮同时使用独立背景与前景颜色', (tester) async {
    const disabledBackground = Color(0xFF123456);
    const disabledForeground = Color(0xFFABCDEF);
    await tester.pumpWidget(
      app(
        HyperButton.filled(
          onPressed: null,
          style: HyperButtonStyle(
            disabledBackground: const HyperFill.color(disabledBackground),
            disabledForegroundColor: disabledForeground,
          ),
          child: const Text('禁用配色'),
        ),
      ),
    );
    final visual = tester.widget<Container>(
      find.byWidgetPredicate(
        (widget) => widget is Container && widget.decoration is BoxDecoration,
      ),
    );
    expect((visual.decoration! as BoxDecoration).color, disabledBackground);
    final text = tester.widget<DefaultTextStyle>(
      find
          .ancestor(
            of: find.text('禁用配色'),
            matching: find.byType(DefaultTextStyle),
          )
          .first,
    );
    expect(text.style.color, disabledForeground);
  });

  testWidgets('鼠标悬停状态层覆盖完整按钮而不是内容区域', (tester) async {
    await tester.pumpWidget(
      app(
        HyperButton.filled(
          onPressed: () {},
          style: HyperButtonStyle(
            width: 180,
            height: 56,
            padding: const EdgeInsets.symmetric(horizontal: 32),
          ),
          child: const Text('悬停区域'),
        ),
      ),
    );
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await mouse.addPointer(location: Offset.zero);
    await mouse.moveTo(tester.getCenter(find.text('悬停区域')));
    await tester.pumpAndSettle();

    final decoratedFinder = find.byWidgetPredicate(
      (widget) =>
          widget is AnimatedContainer && widget.foregroundDecoration != null,
    );
    final decorated = tester.widget<AnimatedContainer>(decoratedFinder);
    final foreground = decorated.foregroundDecoration! as BoxDecoration;
    expect(tester.getSize(decoratedFinder), const Size(180, 56));
    expect(foreground.color?.a, greaterThan(0));
    expect(foreground.borderRadius, BorderRadius.circular(16));
    await mouse.removePointer();
  });

  testWidgets('按钮材质可在普通与高级质量间变化且尺寸稳定', (tester) async {
    const glass = HyperSurfaceMaterial.frostedGlass(
      background: HyperFill.color(Color(0x66FFFFFF)),
      border: BorderSide(color: Color(0x99FFFFFF)),
      fallback: HyperSurfaceMaterial.solid(
        background: HyperFill.color(Color(0xFFF2F2F4)),
      ),
    );

    Future<void> pump(HyperMaterialQuality quality) => tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light().copyWith(
            materialTheme: HyperMaterialThemeData(quality: quality),
            buttonTheme: HyperButtonThemeData(
              filled: HyperButtonStyle(material: glass),
            ),
          ),
          duration: Duration.zero,
          child: Center(
            child: HyperButton.filled(
              onPressed: () {},
              style: HyperButtonStyle(width: 180, height: 56),
              child: const Text('材质按钮'),
            ),
          ),
        ),
      ),
    );

    await pump(HyperMaterialQuality.standard);
    expect(find.byType(BackdropFilter), findsNothing);
    final standardSize = tester.getSize(find.byType(HyperButton));
    final standardTextRect = tester.getRect(find.text('材质按钮'));
    final standardDecoration = tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>()
        .firstWhere(
          (decoration) => decoration.color == const Color(0xFFF2F2F4),
        );
    expect(standardDecoration.color, const Color(0xFFF2F2F4));

    await pump(HyperMaterialQuality.advanced);
    await tester.pump();
    expect(find.byType(BackdropFilter), findsOneWidget);
    expect(tester.getSize(find.byType(HyperButton)), standardSize);
    expect(tester.getRect(find.text('材质按钮')), standardTextRect);
    final advancedDecoration = tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .map((widget) => widget.foregroundDecoration)
        .whereType<BoxDecoration>()
        .firstWhere((decoration) => decoration.border != null);
    expect(advancedDecoration.border?.top.color, const Color(0x99FFFFFF));
  });

  testWidgets('按钮实例材质覆盖按钮主题材质', (tester) async {
    const themeGlass = HyperSurfaceMaterial.frostedGlass(
      background: HyperFill.color(Color(0x66FFFFFF)),
    );
    const instanceSolid = HyperSurfaceMaterial.solid(
      background: HyperFill.color(Colors.green),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light().copyWith(
            materialTheme: const HyperMaterialThemeData(
              quality: HyperMaterialQuality.advanced,
            ),
            buttonTheme: HyperButtonThemeData(
              filled: HyperButtonStyle(material: themeGlass),
            ),
          ),
          duration: Duration.zero,
          child: Center(
            child: HyperButton.filled(
              onPressed: () {},
              style: HyperButtonStyle(material: instanceSolid),
              child: const Text('实例材质'),
            ),
          ),
        ),
      ),
    );

    expect(find.byType(BackdropFilter), findsNothing);
    final decorations = tester
        .widgetList<AnimatedContainer>(find.byType(AnimatedContainer))
        .map((widget) => widget.decoration)
        .whereType<BoxDecoration>();
    expect(
      decorations.any((decoration) => decoration.color == Colors.green),
      isTrue,
    );
  });
}
