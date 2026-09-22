import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('四类终端使用独立的明确默认尺寸', () {
    const phone = HyperSizeScheme.phone();
    const tablet = HyperSizeScheme.tablet();
    const desktop = HyperSizeScheme.desktop();
    const watch = HyperSizeScheme.watch();

    expect(phone.controlHeightMd, 48);
    expect(tablet.controlHeightMd, 52);
    expect(desktop.controlHeightMd, 44);
    expect(watch.controlHeightMd, 48);
    expect(desktop.minimumInteractiveDimension, 36);
    expect(watch.minimumInteractiveDimension, 48);
    expect(HyperSizeScheme.space3xl, 24);
    expect(HyperSizeScheme.radiusLg, 16);
  });

  test('copyWith 只修改显式字段且不执行关联缩放', () {
    const original = HyperSizeScheme.phone();
    final changed = original.copyWith(controlHeightMd: 58);

    expect(changed.controlHeightMd, 58);
    expect(changed.controlHeightSm, 40);
    expect(changed.controlRadius, 16);
    expect(changed.controlPadding, original.controlPadding);
  });

  test('尺寸方案插值保持精确中间值和端点', () {
    const phone = HyperSizeScheme.phone();
    const desktop = HyperSizeScheme.desktop();
    expect(HyperSizeScheme.lerp(phone, desktop, 0), same(phone));
    expect(HyperSizeScheme.lerp(phone, desktop, 1), same(desktop));

    final middle = HyperSizeScheme.lerp(phone, desktop, .5);
    expect(middle.controlHeightMd, 46);
    expect(middle.controlRadius, 13);
    expect(
      middle.controlPadding,
      const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
    );
    expect(middle.deviceType, HyperDeviceType.desktop);
  });

  test('forDevice 返回对应终端方案', () {
    expect(const HyperSizeScheme.tablet(), const HyperSizeScheme.tablet());
  });
}
