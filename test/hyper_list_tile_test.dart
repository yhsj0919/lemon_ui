import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  Widget app(Widget child, {HyperThemeData? theme}) => MaterialApp(
    home: HyperTheme(
      data:
          theme ??
          HyperThemeData.light(
            sizes: const HyperSizeThemeData(tablet: HyperSizeScheme.phone()),
          ),
      duration: Duration.zero,
      child: Center(child: SizedBox(width: 320, child: child)),
    ),
  );

  testWidgets('手机默认列表项遵循 MIUIX 行高和内部间距', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperListTile(
          leading: Icon(Icons.settings, key: Key('leading')),
          title: Text('设置', key: Key('title')),
          trailing: HyperIcon(Icons.chevron_right, key: Key('trailing')),
        ),
      ),
    );

    final tile = find.byType(AnimatedContainer);
    expect(tester.getSize(tile), const Size(320, 56));
    expect(
      DefaultTextStyle.of(tester.element(find.text('设置'))).style.fontSize,
      17,
    );
    expect(
      IconTheme.of(tester.element(find.byKey(const Key('trailing')))).color,
      HyperThemeData.light().colors.textTertiary,
    );
    expect(
      IconTheme.of(tester.element(find.byKey(const Key('trailing')))).size,
      20,
    );
    expect(
      tester
          .widget<Icon>(
            find.descendant(
              of: find.byKey(const Key('trailing')),
              matching: find.byType(Icon),
            ),
          )
          .size,
      20,
    );
    final tileRect = tester.getRect(tile);
    expect(
      tester.getTopLeft(find.byKey(const Key('leading'))).dx - tileRect.left,
      20,
    );
    expect(
      tester.getTopLeft(find.byKey(const Key('title'))).dx -
          tester.getTopRight(find.byKey(const Key('leading'))).dx,
      16,
    );
    expect(
      tester.getTopLeft(find.byKey(const Key('trailing'))).dx -
          tester.getTopRight(find.byKey(const Key('title'))).dx,
      greaterThanOrEqualTo(8),
    );
    expect(
      tileRect.right - tester.getTopRight(find.byKey(const Key('trailing'))).dx,
      16,
    );
  });

  testWidgets('手机紧凑列表项使用独立的 48 高度', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperListTile(
          density: HyperListTileDensity.compact,
          title: Text('紧凑项目'),
        ),
      ),
    );

    expect(tester.getSize(find.byType(AnimatedContainer)).height, 48);
  });

  testWidgets('单行尾部控件不会把标准行高撑过 56', (tester) async {
    await tester.pumpWidget(
      app(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HyperCheckboxListTile(
              value: true,
              onChanged: (_) {},
              title: const Text('Checkbox'),
            ),
            HyperListTile(
              title: const Text('Switch'),
              trailing: HyperSwitch(value: true, onChanged: (_) {}),
            ),
          ],
        ),
      ),
    );

    final tiles = find.byType(HyperListTile);
    expect(tester.getSize(tiles.at(0)).height, 56);
    expect(tester.getSize(tiles.at(1)).height, 56);
  });

  testWidgets('手机双行列表项使用独立的 68 高度', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperListTile(title: Text('用户'), subtitle: Text('目前的登录身份：永恒瞬间')),
      ),
    );

    expect(tester.getSize(find.byType(HyperListTile)).height, 68);
  });

  testWidgets('基础列表项不会隐式添加导航箭头', (tester) async {
    await tester.pumpWidget(app(const HyperListTile(title: Text('基础项目'))));

    expect(find.byIcon(Icons.chevron_right), findsNothing);
  });

  testWidgets('导航列表项统一添加描述、箭头和尾部间距', (tester) async {
    await tester.pumpWidget(
      app(
        HyperNavigationListTile(
          title: const Text('WLAN'),
          description: const Text('Xiaomi_5G', key: Key('description')),
          onTap: () {},
        ),
      ),
    );

    final tileRect = tester.getRect(find.byType(AnimatedContainer));
    final descriptionRect = tester.getRect(
      find.byKey(const Key('description')),
    );
    final chevron = find.byIcon(Icons.chevron_right);
    final chevronRect = tester.getRect(chevron);
    expect(chevron, findsOneWidget);
    expect(tester.widget<Icon>(chevron).size, 24);
    expect(chevronRect.left - descriptionRect.right, 4);
    expect(tileRect.right - chevronRect.right, 16);
    expect(
      DefaultTextStyle.of(tester.element(find.byKey(const Key('description'))))
          .style
          .color,
      HyperThemeData.light().colors.textTertiary,
    );
  });

  testWidgets('导航列表项实例样式同步控制描述与箭头间距', (tester) async {
    await tester.pumpWidget(
      app(
        HyperNavigationListTile(
          title: const Text('蓝牙'),
          description: const Text('已开启', key: Key('description')),
          style: const HyperListTileStyle(trailingSpacing: 14),
          onTap: () {},
        ),
      ),
    );

    expect(
      tester.getRect(find.byIcon(Icons.chevron_right)).left -
          tester.getRect(find.byKey(const Key('description'))).right,
      14,
    );
  });

  testWidgets('单选列表项按圆环可见边界对齐且不改变 Checkbox 位置', (tester) async {
    await tester.pumpWidget(
      app(
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HyperRadioListTile<String>(
              value: 'astral',
              groupValue: 'astral',
              onChanged: (_) {},
              title: const Text('astral'),
            ),
            HyperCheckboxListTile(
              value: true,
              onChanged: (_) {},
              title: const Text('通知'),
            ),
          ],
        ),
      ),
    );

    final tiles = tester.getRect(find.byType(AnimatedContainer).first);
    final radioVisual = tester.getRect(
      find.byKey(const ValueKey('hyper_radio_visual')),
    );
    final checkboxTile = tester.getRect(find.byType(HyperListTile).last);
    final checkboxVisual = tester.getRect(
      find.byKey(const ValueKey('hyper_checkbox_visual')),
    );
    expect(tiles.right - radioVisual.right, 16);
    expect(checkboxTile.right - checkboxVisual.right, 16);
  });

  testWidgets('复选列表项点击整行切换值', (tester) async {
    bool? value = false;
    await tester.pumpWidget(
      app(
        HyperCheckboxListTile(
          value: value,
          onChanged: (next) => value = next,
          title: const Text('允许通知'),
        ),
      ),
    );

    await tester.tap(find.text('允许通知'));
    expect(value, isTrue);
  });

  testWidgets('尾部描述文字和图标使用统一的次要视觉层级', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperListTile(
          title: Text('WLAN'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Xiaomi_5G'),
              SizedBox(width: 8),
              HyperIcon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );

    final trailingContext = tester.element(find.text('Xiaomi_5G'));
    final trailingStyle = DefaultTextStyle.of(trailingContext).style;
    expect(trailingStyle.fontSize, 14);
    expect(trailingStyle.color, HyperThemeData.light().colors.textTertiary);
    expect(tester.widget<Icon>(find.byType(Icon)).size, 20);
  });

  testWidgets('标题摘要和首尾内容分别垂直居中且内容可自然增高', (tester) async {
    await tester.pumpWidget(
      app(
        const HyperListTile(
          leading: SizedBox.square(dimension: 24, key: Key('leading')),
          title: Text('网络与连接'),
          subtitle: Text(
            '这是一段会在窄宽度下自动换行的较长说明文字，不使用固定双行高度。',
            key: Key('subtitle'),
          ),
          trailing: SizedBox.square(dimension: 20, key: Key('trailing')),
        ),
      ),
    );

    final tileRect = tester.getRect(find.byType(AnimatedContainer));
    expect(tileRect.height, greaterThan(56));
    for (final key in const [Key('leading'), Key('trailing')]) {
      expect(
        tester.getRect(find.byKey(key)).center.dy,
        closeTo(tileRect.center.dy, .01),
      );
    }
    expect(
      tester.getRect(find.byKey(const Key('subtitle'))).bottom,
      lessThan(tileRect.bottom),
    );
  });

  testWidgets('整行点击且禁用状态不响应', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      app(HyperListTile(title: const Text('可点击'), onTap: () => taps++)),
    );
    await tester.tapAt(
      tester.getRect(find.byType(HyperListTile)).bottomRight -
          const Offset(2, 2),
    );
    expect(taps, 1);

    await tester.pumpWidget(
      app(
        HyperListTile(
          title: const Text('禁用'),
          enabled: false,
          onTap: () => taps++,
        ),
      ),
    );
    await tester.tap(find.byType(HyperListTile));
    expect(taps, 1);
  });

  testWidgets('设备尺寸主题和实例样式按层覆盖', (tester) async {
    final theme =
        HyperThemeData.light(
          sizes: HyperSizeThemeData(
            tablet: const HyperSizeScheme.phone().copyWith(
              listTile: const HyperListTileSize(
                minHeight: 70,
                compactMinHeight: 60,
                subtitleMinHeight: 86,
                compactSubtitleMinHeight: 76,
                padding: EdgeInsets.all(20),
                compactPadding: EdgeInsets.all(16),
                leadingSize: 36,
                leadingSpacing: 14,
                trailingSpacing: 10,
                trailingIconSize: 22,
                navigationSpacing: 6,
                navigationIconSize: 24,
                titleFontSize: 19,
                subtitleFontSize: 15,
                titleLineHeight: 1.2,
                subtitleLineHeight: 1.3,
              ),
            ),
          ),
        ).copyWith(
          listTileTheme: const HyperListTileThemeData(
            style: HyperListTileStyle(minHeight: 72),
          ),
        );
    await tester.pumpWidget(
      app(
        const HyperListTile(
          title: Text('覆盖'),
          style: HyperListTileStyle(minHeight: 74),
        ),
        theme: theme,
      ),
    );

    expect(tester.getSize(find.byType(AnimatedContainer)).height, 74);
  });
}
