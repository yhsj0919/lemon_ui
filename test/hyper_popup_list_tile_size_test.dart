import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('选项浮窗的四端宽度边界可独立覆盖并插值', () {
    const sizes = HyperSizeThemeData();
    expect(sizes.phone.popupListTile.minWidth, 200);
    expect(sizes.tablet.popupListTile.maxWidth, 320);
    expect(sizes.desktop.popupListTile.minWidth, 160);
    expect(sizes.watch.popupListTile.maxWidth, 200);
    for (final device in [
      sizes.phone,
      sizes.tablet,
      sizes.desktop,
      sizes.watch,
    ]) {
      expect(device.popupListTile.itemHorizontalPadding, 16);
    }

    final changed = sizes.copyWith(
      desktop: sizes.desktop.copyWith(
        popupListTile: sizes.desktop.popupListTile.copyWith(
          maxWidth: 360,
          itemHorizontalPadding: 20,
        ),
      ),
    );
    expect(changed.desktop.popupListTile.maxWidth, 360);
    expect(changed.desktop.popupListTile.itemHorizontalPadding, 20);
    expect(changed.phone, sizes.phone);
    expect(changed.tablet, sizes.tablet);
    expect(changed.watch, sizes.watch);
    expect(
      HyperPopupListTileSize.lerp(
        sizes.desktop.popupListTile,
        changed.desktop.popupListTile,
        .5,
      ).maxWidth,
      340,
    );
    expect(
      HyperPopupListTileSize.lerp(
        sizes.desktop.popupListTile,
        changed.desktop.popupListTile,
        .5,
      ).itemHorizontalPadding,
      18,
    );
  });

  test('菜单表面内边距独立于菜单项文字内边距', () {
    const style = HyperMenuStyle(padding: 12, surfacePadding: 0);
    final changed = style.copyWith(surfacePadding: 8);
    expect(changed.padding, 12);
    expect(changed.surfacePadding, 8);
    expect(style.merge(const HyperMenuStyle(padding: 16)).surfacePadding, 0);
  });
}
