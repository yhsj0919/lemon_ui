import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('标题内外布局共用任意 action 和内容', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const Scaffold(
            body: Column(
              children: [
                HyperTitledCard(
                  title: Text('外部标题'),
                  action: Icon(Icons.refresh, key: Key('outside-action')),
                  child: Text('外部内容'),
                ),
                HyperTitledCard(
                  titlePosition: HyperCardTitlePosition.inside,
                  title: Text('内部标题'),
                  action: CircularProgressIndicator(key: Key('inside-action')),
                  child: Wrap(children: [Text('网格 A'), Text('网格 B')]),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.byType(HyperCard), findsNWidgets(2));
    expect(find.byKey(const Key('outside-action')), findsOneWidget);
    expect(find.byKey(const Key('inside-action')), findsOneWidget);
    expect(find.text('网格 B'), findsOneWidget);

    final colors = HyperThemeData.light().colors;
    final outsideTextStyle = DefaultTextStyle.of(
      tester.element(find.text('外部标题')),
    ).style;
    final insideTextStyle = DefaultTextStyle.of(
      tester.element(find.text('内部标题')),
    ).style;
    expect(outsideTextStyle.fontSize, 14);
    expect(outsideTextStyle.color, colors.textTertiary);
    expect(insideTextStyle.fontSize, 18);
    expect(insideTextStyle.color, colors.textPrimary);
    expect(
      IconTheme.of(tester.element(find.byKey(const Key('outside-action'))))
          .color,
      colors.primary,
    );

    final outsideTitle = tester.getTopLeft(find.text('外部标题'));
    final outsideCard = tester.getTopLeft(find.byType(HyperCard).first);
    expect(outsideTitle.dy, lessThan(outsideCard.dy));

    final insideTitle = tester.getTopLeft(find.text('内部标题'));
    final insideCard = tester.getTopLeft(find.byType(HyperCard).last);
    expect(insideTitle.dy, greaterThan(insideCard.dy));
  });

  testWidgets('卡片外标题使用上下边距，action 默认继承主题且允许显式覆盖', (tester) async {
    final colors = HyperThemeData.light().colors;
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: const Scaffold(
            body: Column(
              children: [
                HyperTitledCard(
                  title: Text('分组标题'),
                  action: Text('刷新'),
                  child: SizedBox(height: 40),
                ),
                HyperTitledCard(
                  title: Text('另一组'),
                  action: Text('显式颜色', style: TextStyle(color: Colors.red)),
                  child: SizedBox(height: 40),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    final card = tester.getTopLeft(find.byType(HyperCard).first);
    final title = tester.getTopLeft(find.text('分组标题'));
    final titleBottom = tester.getBottomLeft(find.text('分组标题'));
    final metrics = HyperTheme.sizesOf(
      tester.element(find.text('分组标题')),
    ).card;
    final padding = metrics.outsideTitlePadding.resolve(TextDirection.ltr);
    expect(title.dx - card.dx, padding.left);
    expect(card.dy - titleBottom.dy, padding.bottom + metrics.outsideTitleSpacing);
    final actionStyle = DefaultTextStyle.of(tester.element(find.text('刷新')))
        .style;
    expect(actionStyle.fontSize, 14);
    expect(actionStyle.color, colors.primary);
    expect(tester.widget<Text>(find.text('显式颜色')).style?.color, Colors.red);
  });

  testWidgets('全局、局部和实例只覆盖明确提供的标题属性', (tester) async {
    final base = HyperThemeData.light();
    final customized = base.copyWith(
      titledCardTheme: const HyperTitledCardThemeData(
        style: HyperTitledCardStyle(
          titleTextStyle: TextStyle(fontSize: 24, color: Colors.green),
          actionTextStyle: TextStyle(fontSize: 18, color: Colors.green),
          titleSpacing: 40,
        ),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: customized,
          duration: Duration.zero,
          child: Scaffold(
            body: HyperTitledCardTheme(
              data: const HyperTitledCardThemeData(
                style: HyperTitledCardStyle(
                  titlePadding: EdgeInsets.fromLTRB(30, 10, 40, 0),
                  titleTextStyle: TextStyle(color: Colors.red),
                  actionTextStyle: TextStyle(color: Colors.red),
                ),
              ),
              child: const HyperTitledCard(
                titlePosition: HyperCardTitlePosition.inside,
                title: Text('自定义标题'),
                action: Text('操作'),
                style: HyperTitledCardStyle(
                  titleSpacing: 6,
                  titleTextStyle: TextStyle(color: Colors.blue),
                  actionTextStyle: TextStyle(color: Colors.blue),
                ),
                child: SizedBox(height: 20, child: Text('自由内容')),
              ),
            ),
          ),
        ),
      ),
    );

    final card = tester.getTopLeft(find.byType(HyperCard));
    final title = tester.getTopLeft(find.text('自定义标题'));
    final content = tester.getTopLeft(find.text('自由内容'));
    expect(title.dx - card.dx, 30);
    expect(title.dy - card.dy, 10);
    expect(content.dy - tester.getBottomLeft(find.text('自定义标题')).dy, 6);
    final textStyle = DefaultTextStyle.of(tester.element(find.text('自定义标题')))
        .style;
    expect(textStyle.fontSize, 24);
    expect(textStyle.color, Colors.blue);
    final actionStyle = DefaultTextStyle.of(tester.element(find.text('操作')))
        .style;
    expect(actionStyle.fontSize, 18);
    expect(actionStyle.color, Colors.blue);
    expect(customized.cardTheme, base.cardTheme);
  });
}
