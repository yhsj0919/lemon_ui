import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('按真实设备类型解析对应尺寸方案', () {
    const sizes = HyperSizeThemeData();

    expect(sizes.resolve(HyperDeviceType.phone), sizes.phone);
    expect(sizes.resolve(HyperDeviceType.tablet), sizes.tablet);
    expect(sizes.resolve(HyperDeviceType.desktop), sizes.desktop);
    expect(sizes.resolve(HyperDeviceType.watch), sizes.watch);
  });

  test('copyWith 只替换目标终端尺寸', () {
    const sizes = HyperSizeThemeData();
    final compactDesktop = sizes.desktop.copyWith(controlHeightSm: 32);
    final changed = sizes.copyWith(desktop: compactDesktop);

    expect(changed.desktop.controlHeightSm, 32);
    expect(changed.phone, sizes.phone);
    expect(changed.tablet, sizes.tablet);
    expect(changed.watch, sizes.watch);
  });

  test('组件尺寸可以通过分层 copyWith 只覆盖所需字段', () {
    const sizes = HyperSizeThemeData();
    final changed = sizes.copyWith(
      desktop: sizes.desktop.copyWith(
        button: sizes.desktop.button.copyWith(minimumSize: const Size(72, 42)),
      ),
    );

    expect(changed.desktop.button.minimumSize, const Size(72, 42));
    expect(changed.desktop.button.padding, sizes.desktop.button.padding);
    expect(changed.phone.button, sizes.phone.button);
  });

  test('桌面按钮三档尺寸可通过主题独立覆盖', () {
    const base = HyperSizeScheme.desktop();
    final changed = base.button.copyWith(smallHeight: 26, largeHeight: 42);

    expect(base.button.heightFor(HyperButtonSizeVariant.small), 24);
    expect(base.button.heightFor(HyperButtonSizeVariant.medium), 32);
    expect(base.button.heightFor(HyperButtonSizeVariant.large), 40);
    expect(changed.heightFor(HyperButtonSizeVariant.small), 26);
    expect(changed.heightFor(HyperButtonSizeVariant.medium), 32);
    expect(changed.heightFor(HyperButtonSizeVariant.large), 42);
    expect(changed.padding, base.button.padding);
  });

  test('图标按钮尺寸可独立覆盖', () {
    const sizes = HyperSizeThemeData();
    final changed = sizes.copyWith(
      desktop: sizes.desktop.copyWith(
        iconButton: sizes.desktop.iconButton.copyWith(size: 40),
      ),
    );

    expect(changed.desktop.iconButton.size, 40);
    expect(
      changed.desktop.iconButton.iconSize,
      sizes.desktop.iconButton.iconSize,
    );
  });

  test('其他组件尺寸也可逐项覆盖', () {
    const sizes = HyperSizeThemeData();
    final changed = sizes.copyWith(
      desktop: sizes.desktop.copyWith(
        switchSize: sizes.desktop.switchSize.copyWith(width: 50),
        progressIndicator: sizes.desktop.progressIndicator.copyWith(
          circularSize: 28,
        ),
      ),
    );

    expect(changed.desktop.switchSize.width, 50);
    expect(changed.desktop.switchSize.height, sizes.desktop.switchSize.height);
    expect(changed.desktop.progressIndicator.circularSize, 28);
    expect(changed.phone, sizes.phone);
  });

  test('列表项全部布局尺寸可以按设备独立覆盖', () {
    const sizes = HyperSizeThemeData();
    final changed = sizes.copyWith(
      phone: sizes.phone.copyWith(
        listTile: sizes.phone.listTile.copyWith(
          minHeight: 58,
          compactMinHeight: 50,
          subtitleMinHeight: 70,
          compactSubtitleMinHeight: 62,
          padding: const EdgeInsetsDirectional.fromSTEB(18, 10, 18, 10),
          compactPadding: const EdgeInsetsDirectional.fromSTEB(14, 6, 14, 6),
          leadingSize: 30,
          leadingSpacing: 10,
          trailingSpacing: 6,
          trailingIconSize: 22,
          navigationSpacing: 5,
          navigationIconSize: 26,
        ),
      ),
    );

    final listTile = changed.phone.listTile;
    expect(listTile.minHeight, 58);
    expect(listTile.compactMinHeight, 50);
    expect(listTile.subtitleMinHeight, 70);
    expect(listTile.compactSubtitleMinHeight, 62);
    expect(
      listTile.padding,
      const EdgeInsetsDirectional.fromSTEB(18, 10, 18, 10),
    );
    expect(listTile.leadingSize, 30);
    expect(listTile.leadingSpacing, 10);
    expect(listTile.trailingSpacing, 6);
    expect(listTile.trailingIconSize, 22);
    expect(listTile.navigationSpacing, 5);
    expect(listTile.navigationIconSize, 26);
    expect(changed.tablet, sizes.tablet);
    expect(changed.desktop, sizes.desktop);
    expect(changed.watch, sizes.watch);
  });

  test('列表项默认尺寸按四类设备分别配置', () {
    const sizes = HyperSizeThemeData();

    expect(
      (sizes.phone.listTile.minHeight, sizes.phone.listTile.subtitleMinHeight),
      (56, 68),
    );
    expect(
      (
        sizes.tablet.listTile.minHeight,
        sizes.tablet.listTile.subtitleMinHeight,
      ),
      (56, 68),
    );
    expect(
      (
        sizes.desktop.listTile.minHeight,
        sizes.desktop.listTile.subtitleMinHeight,
      ),
      (48, 60),
    );
    expect(
      (sizes.watch.listTile.minHeight, sizes.watch.listTile.subtitleMinHeight),
      (52, 68),
    );
  });

  test('主题插值分别处理四套设备尺寸', () {
    const start = HyperSizeThemeData();
    final end = start.copyWith(
      desktop: start.desktop.copyWith(controlHeightSm: 44),
    );

    final middle = HyperSizeThemeData.lerp(start, end, .5);
    expect(middle.desktop.controlHeightSm, 40);
    expect(middle.phone, start.phone);
  });
}
