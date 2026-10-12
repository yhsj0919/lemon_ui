import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('菜单项间距可独立覆盖，参与主题合并和插值', () {
    const schemes = [
      HyperSizeScheme.phone(),
      HyperSizeScheme.tablet(),
      HyperSizeScheme.desktop(),
      HyperSizeScheme.watch(),
    ];
    expect(schemes.map((s) => s.navigationItemSpacing), [4, 4, 4, 4]);
    expect(
      schemes.every(
        (s) => s.menu.itemSpacing == null && s.sidebar.rowGap == null,
      ),
      isTrue,
    );
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
