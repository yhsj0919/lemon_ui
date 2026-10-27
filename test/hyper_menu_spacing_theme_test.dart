import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('菜单面板内边距只应用一次，表面覆盖直接替换默认值', (tester) async {
    for (final explicit in [null, 0.0, 12.0]) {
      await tester.pumpWidget(
        MaterialApp(
          home: HyperTheme(
            data: HyperThemeData.light(),
            child: HyperCardTheme(
              data: HyperCardThemeData(
                style: HyperCardStyle(padding: const EdgeInsets.all(40)),
              ),
              child: Center(
                child: HyperMenu(
                  style: HyperMenuStyle(
                    surfacePadding: 8,
                    surfaceStyle: explicit == null
                        ? null
                        : HyperCardStyle(padding: EdgeInsets.all(explicit)),
                  ),
                  items: const [HyperMenuItem(id: 'one', label: '菜单项')],
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final card = tester.getRect(find.byType(HyperCard));
      final row = tester.getRect(
        find.byKey(const ValueKey('hyper-menu-item-one')),
      );
      expect(row.left - card.left, explicit ?? 8);
      expect(card.right - row.right, explicit ?? 8);
      expect(row.top - card.top, explicit ?? 8);
      expect(card.bottom - row.bottom, explicit ?? 8);
      expect(tester.takeException(), isNull);
    }
  });
  test('菜单项间距可独立覆盖，参与主题合并和插值', () {
    const schemes = [
      HyperSizeScheme.phone(),
      HyperSizeScheme.tablet(),
      HyperSizeScheme.desktop(),
      HyperSizeScheme.watch(),
    ];
    expect(schemes.map((s) => s.navigationItemSpacing), [4, 4, 4, 4]);
    expect(schemes.map((s) => s.menu.itemSpacing), [0, null, null, null]);
    expect(schemes.every((s) => s.sidebar.rowGap == null), isTrue);
    final shared = schemes[2].copyWith(navigationItemSpacing: 6);
    expect(shared.menu.itemSpacing ?? shared.navigationItemSpacing, 6);
    expect(shared.sidebar.rowGap ?? shared.navigationItemSpacing, 6);
    expect(shared.treeView.rowSpacing ?? shared.navigationItemSpacing, 6);
    expect(shared.sidebar.itemSpacing, schemes[2].sidebar.itemSpacing);
    expect(
      HyperSizeScheme.lerp(schemes[2], shared, .5).navigationItemSpacing,
      5,
    );
    final original = schemes[2].menu.copyWith(itemSpacing: 2);
    final changed = original.copyWith(itemSpacing: 6);
    expect(changed.groupSpacing, original.groupSpacing);
    expect(changed.copyWith(), changed);
    expect(changed.copyWith().hashCode, changed.hashCode);
    expect(HyperMenuSize.lerp(original, changed, .5).itemSpacing, 4);
    const style = HyperMenuStyle(itemSpacing: 2, groupSpacing: 8);
    final overridden = style.merge(const HyperMenuStyle(itemSpacing: 0));
    expect(overridden.itemSpacing, 0);
    expect(overridden.groupSpacing, 8);
    expect(style.copyWith(), style);
    expect(style.copyWith().hashCode, style.hashCode);
    expect(
      HyperMenuStyle.lerp(
        style,
        style.copyWith(itemSpacing: 6),
        .5,
      ).itemSpacing,
      4,
    );
  });
}
