import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  final theme = HyperThemeData.light();
  for (final type in HyperDeviceType.values) {
    test('${type.name} 新几何字段支持 copyWith、插值与值相等', () {
      final sizes = theme.sizes.resolve(type);
      final radio = sizes.radio.copyWith(
        minimumTapTargetSize: 44,
        indicatorSize: 10,
        markSize: 18,
        strokeWidth: 2,
        radius: 4,
      );
      final radioEnd = radio.copyWith(
        minimumTapTargetSize: 48,
        indicatorSize: 14,
        markSize: 22,
        strokeWidth: 4,
        radius: 8,
      );
      final radioMid = HyperRadioSize.lerp(radio, radioEnd, .5);
      expect(
        radioMid,
        radio.copyWith(
          minimumTapTargetSize: 46,
          indicatorSize: 12,
          markSize: 20,
          strokeWidth: 3,
          radius: 6,
        ),
      );
      expect(radio.copyWith(), radio);
      expect(radio.copyWith().hashCode, radio.hashCode);
      final checkbox = sizes.checkbox.copyWith(
        minimumTapTargetSize: 44,
        circleRadius: 4,
      );
      expect(
        HyperCheckboxSize.lerp(
          checkbox,
          checkbox.copyWith(minimumTapTargetSize: 48, circleRadius: 8),
          .5,
        ),
        checkbox.copyWith(minimumTapTargetSize: 46, circleRadius: 6),
      );
      final toggle = sizes.switchSize.copyWith(
        minimumTapTargetSize: 44,
        radius: 4,
        thumbRadius: 4,
        uncheckedThumbOffset: 4,
        checkedThumbOffset: 20,
      );
      expect(
        HyperSwitchSize.lerp(
          toggle,
          toggle.copyWith(
            minimumTapTargetSize: 48,
            radius: 8,
            thumbRadius: 8,
            uncheckedThumbOffset: 8,
            checkedThumbOffset: 24,
          ),
          .5,
        ),
        toggle.copyWith(
          minimumTapTargetSize: 46,
          radius: 6,
          thumbRadius: 6,
          uncheckedThumbOffset: 6,
          checkedThumbOffset: 22,
        ),
      );
      final progress = sizes.progress.copyWith(
        linearSize: 100,
        radius: 4,
        fillRadius: 4,
        infiniteThickness: 2,
      );
      expect(
        HyperProgressSize.lerp(
          progress,
          progress.copyWith(
            linearSize: 200,
            radius: 8,
            fillRadius: 8,
            infiniteThickness: 4,
          ),
          .5,
        ),
        progress.copyWith(
          linearSize: 150,
          radius: 6,
          fillRadius: 6,
          infiniteThickness: 3,
        ),
      );
      final divider = sizes.divider.copyWith(
        length: 100,
        indent: 4,
        endIndent: 4,
        radius: 2,
      );
      expect(
        HyperDividerSize.lerp(
          divider,
          divider.copyWith(length: 200, indent: 8, endIndent: 8, radius: 4),
          .5,
        ),
        divider.copyWith(length: 150, indent: 6, endIndent: 6, radius: 3),
      );
      expect(sizes.radio.indicatorSize, isNull);
      expect(sizes.checkbox.circleRadius, isNull);
      expect(sizes.switchSize.checkedThumbOffset, isNull);
      expect(sizes.progress.radius, isNull);
      expect(sizes.divider.length, isNull);
    });
  }
  test('局部尺寸覆盖不修改其他设备，空字段保留原几何推导', () {
    final updated = theme.sizes.copyWith(
      desktop: theme.sizes.desktop.copyWith(
        radio: theme.sizes.desktop.radio.copyWith(radius: 3),
      ),
    );
    expect(updated.desktop.radio.radius, 3);
    expect(updated.phone, theme.sizes.phone);
    expect(updated.tablet, theme.sizes.tablet);
    expect(updated.watch, theme.sizes.watch);
    expect(
      HyperRadioSize.lerp(
        theme.sizes.desktop.radio,
        updated.desktop.radio,
        .25,
      ).radius,
      isNull,
    );
    expect(
      HyperRadioSize.lerp(
        theme.sizes.desktop.radio,
        updated.desktop.radio,
        .75,
      ).radius,
      3,
    );
  });
}
