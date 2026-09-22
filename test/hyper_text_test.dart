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

  testWidgets('默认正文继承父级文字环境', (tester) async {
    await tester.pumpWidget(
      app(
        const DefaultTextStyle(
          style: TextStyle(
            fontFamily: 'TestFamily',
            fontSize: 19,
            height: 1,
            color: Colors.purple,
          ),
          child: HyperText('正文'),
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('正文'));
    expect(text.style?.fontSize, 19);
    expect(text.style?.fontFamily, 'TestFamily');
    expect(text.style?.height, 1);
    expect(text.style?.color, Colors.purple);
  });

  testWidgets('语义层级读取对应全局字号', (tester) async {
    final theme = HyperThemeData.light(
      typography: const HyperTypographyScheme(pageTitle: 34),
    );
    await tester.pumpWidget(
      app(
        const HyperText('标题', variant: HyperTextVariant.pageTitle),
        theme: theme,
      ),
    );

    expect(tester.widget<Text>(find.text('标题')).style?.fontSize, 34);
  });

  testWidgets('实例样式优先于控件主题和全局文字主题', (tester) async {
    final theme = HyperThemeData.light().copyWith(
      textComponentTheme: const HyperTextThemeData(
        style: TextStyle(color: Colors.red),
        body: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
    );
    await tester.pumpWidget(
      app(
        const HyperText(
          '覆盖',
          style: TextStyle(color: Colors.blue, fontSize: 19),
        ),
        theme: theme,
      ),
    );

    final style = tester.widget<Text>(find.text('覆盖')).style!;
    expect(style.color, Colors.blue);
    expect(style.fontSize, 19);
    expect(style.fontWeight, FontWeight.w500);
  });

  testWidgets('局部主题只覆盖当前子树', (tester) async {
    await tester.pumpWidget(
      app(
        const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HyperTextTheme(
              data: HyperTextThemeData(body: TextStyle(color: Colors.green)),
              child: HyperText('局部'),
            ),
            HyperText('外部'),
          ],
        ),
      ),
    );

    expect(tester.widget<Text>(find.text('局部')).style?.color, Colors.green);
    expect(
      tester.widget<Text>(find.text('外部')).style?.color,
      isNot(Colors.green),
    );
  });

  testWidgets('原生换行和溢出参数保持不变', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperText(
          '很长的文字',
          maxLines: 2,
          softWrap: false,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
      ),
    );

    final text = tester.widget<Text>(find.text('很长的文字'));
    expect(text.maxLines, 2);
    expect(text.softWrap, isFalse);
    expect(text.overflow, TextOverflow.ellipsis);
    expect(text.textAlign, TextAlign.center);
  });
}
