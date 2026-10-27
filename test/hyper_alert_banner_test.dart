import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget app(Widget child, {HyperThemeData? theme, double scale = 1}) =>
    MaterialApp(
      home: HyperTheme(
        duration: Duration.zero,
        data: theme ?? HyperThemeData.light(),
        child: MediaQuery(
          data: MediaQueryData(textScaler: TextScaler.linear(scale)),
          child: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(width: 240, child: child),
            ),
          ),
        ),
      ),
    );

void main() {
  test('横幅变体状态覆盖参与复制、合并、插值和全局主题值相等', () {
    const a = HyperAlertThemeData(
      style: HyperNoticeStyle(iconSize: 20),
      warning: HyperNoticeStyle(iconColor: Colors.orange),
      bannerWarning: HyperNoticeStyle(iconSize: 30),
    );
    final b = a.copyWith(bannerWarning: HyperNoticeStyle(iconSize: 50));
    expect(a.styleFor(HyperNoticeSeverity.warning, banner: true).iconSize, 30);
    expect(a.styleFor(HyperNoticeSeverity.warning).iconSize, 20);
    expect(
      a.styleFor(HyperNoticeSeverity.warning, banner: true).iconColor,
      Colors.orange,
    );
    expect(HyperAlertThemeData.lerp(a, b, .5).bannerWarning!.iconSize, 40);
    expect(a.copyWith(), a);
    expect(a.copyWith().hashCode, a.hashCode);
    final theme = HyperThemeData.light().copyWith(alertTheme: a);
    expect(
      theme
          .lerp(theme.copyWith(alertTheme: b), .5)
          .alertTheme
          .bannerWarning!
          .iconSize,
      40,
    );
  });

  testWidgets('横幅主题与实例依次覆盖', (tester) async {
    final theme = HyperThemeData.light().copyWith(
      alertTheme: const HyperAlertThemeData(
        style: HyperNoticeStyle(iconColor: Colors.blue),
        bannerStyle: HyperNoticeStyle(iconSize: 31),
      ),
    );
    await tester.pumpWidget(
      app(const HyperAlert.banner(content: Text('内容')), theme: theme),
    );
    await tester.pumpAndSettle();
    expect(tester.widget<HyperAlert>(find.byType(HyperAlert)).isBanner, isTrue);
    final icon = IconTheme.of(tester.element(find.byIcon(HyperIcons.info)));
    expect(icon.size, 31);
    expect(icon.color, Colors.blue);
    await tester.pumpWidget(
      app(
        const HyperAlertTheme(
          data: HyperAlertThemeData(
            bannerStyle: HyperNoticeStyle(iconColor: Colors.green),
          ),
          child: HyperAlert.banner(
            content: Text('内容'),
            style: HyperNoticeStyle(iconColor: Colors.black),
          ),
        ),
        theme: theme,
      ),
    );
    await tester.pumpAndSettle();
    expect(
      IconTheme.of(tester.element(find.byIcon(HyperIcons.info))).color,
      Colors.black,
    );
    expect(tester.takeException(), isNull);
  });

  for (final scale in [1.0, 1.3, 2.0]) {
    testWidgets('横幅窄宽、文字缩放 $scale 与关闭回调', (tester) async {
      var closed = false;
      await tester.pumpWidget(
        app(
          HyperAlert.banner(
            title: const Text('需要注意的提示标题'),
            content: const Text('这是较长的正文，应随系统文字缩放自然换行增高。'),
            onClose: () => closed = true,
          ),
          scale: scale,
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byType(HyperIconButton));
      expect(closed, isTrue);
      expect(tester.takeException(), isNull);
    });
  }
}
