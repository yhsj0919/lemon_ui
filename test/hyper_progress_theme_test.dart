import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/slider/hyper_slider_track_shapes.dart';

void main() {
  test('填充端圆角独立覆盖、插值和值相等', () {
    const base = HyperProgressStyle(radius: 12, fillRadius: 0);
    final round = base.copyWith(fillRadius: 8);
    expect(round.radius, 12);
    expect(base.merge(round).fillRadius, 8);
    expect(HyperProgressStyle.lerp(base, round, .5).fillRadius, 4);
    expect(round, const HyperProgressStyle(radius: 12, fillRadius: 8));
    expect(
      round.hashCode,
      const HyperProgressStyle(radius: 12, fillRadius: 8).hashCode,
    );
    expect(const HyperProgress.linear(fillRadius: 8).fillRadius, 8);
  });
  test('四端宽条高度与同端 Slider 一致，尺寸可覆盖和插值', () {
    for (final sizes in [
      const HyperSizeScheme.phone(),
      const HyperSizeScheme.tablet(),
      const HyperSizeScheme.desktop(),
      const HyperSizeScheme.watch(),
    ]) {
      expect(sizes.progress.wideLinearThickness, sizes.slider.trackHeight);
      final changed = sizes.progress.copyWith(wideLinearThickness: 40);
      expect(changed.linearThickness, sizes.progress.linearThickness);
      expect(
        HyperProgressSize.lerp(sizes.progress, changed, .5).wideLinearThickness,
        (sizes.slider.trackHeight + 40) / 2,
      );
    }
  });
  test('宽条主题字段覆盖、copyWith、插值和值相等', () {
    const base = HyperProgressStyle(
      variant: HyperProgressVariant.wide,
      color: Colors.blue,
      radius: 12,
    );
    final theme = HyperProgressThemeData(linearStyle: base);
    final local = theme.merge(
      const HyperProgressThemeData(
        linearStyle: HyperProgressStyle(trackColor: Colors.grey),
      ),
    );
    final instance = local.linearStyle.copyWith(color: Colors.orange);
    expect(instance.variant, HyperProgressVariant.wide);
    expect(instance.trackColor, Colors.grey);
    expect(instance.radius, 12);
    expect(theme.copyWith(linearStyle: instance).linearStyle, instance);
    final changed = base.copyWith(radius: 4);
    expect(HyperProgressStyle.lerp(base, changed, .5).radius, 8);
    const expected = HyperProgressStyle(
      variant: HyperProgressVariant.wide,
      color: Colors.blue,
      radius: 4,
    );
    expect(changed, expected);
    expect(changed.hashCode, expected.hashCode);
  });
  test('Slider 显式零留白让可见轨道铺满宽度', () {
    final box = RenderConstrainedBox(
      additionalConstraints: const BoxConstraints.tightFor(
        width: 200,
        height: 48,
      ),
    );
    box.layout(const BoxConstraints.tightFor(width: 200, height: 48));
    const theme = SliderThemeData(
      trackHeight: 24,
      padding: EdgeInsets.zero,
      activeTrackColor: Colors.blue,
      inactiveTrackColor: Colors.grey,
      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8),
      overlayShape: RoundSliderOverlayShape(overlayRadius: 12),
    );
    final rect = const HyperSliderTrackShape().getPreferredRect(
      parentBox: box,
      sliderTheme: theme,
    );
    expect(rect.left, 0);
    expect(rect.right, 200);
    expect(rect.height, 24);
    box.dispose();
  });
}
