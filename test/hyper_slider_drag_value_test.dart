import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/src/components/slider/hyper_slider_drag_value.dart';

void main() {
  test('播放器持续上报不抢占拖动位置，松手提交最后的用户值', () {
    final drag = HyperSliderDragValue<double>();
    double playback = 24;
    expect(drag.resolve(playback), 24);
    drag.begin(playback);
    drag.update(90);
    for (final tick in [24.5, 25.0, 25.5, 26.0]) {
      playback = tick;
      expect(drag.resolve(playback), 90);
    }
    drag.update(120);
    playback = 26.5;
    final seek = drag.end(playback);
    expect(seek, 120);
    expect(drag.active, isFalse);
    playback = seek;
    expect(drag.resolve(playback), 120);
    playback = 120.5;
    expect(drag.resolve(playback), 120.5);
  });

  test('结束不会回放拖动中缓存的外部值，新手势从当前受控值开始', () {
    final drag = HyperSliderDragValue<double>();
    drag.begin(10);
    drag.update(50);
    expect(drag.resolve(11), 50);
    expect(drag.end(12), 50);
    expect(drag.resolve(51), 51);
    drag.begin(51);
    expect(drag.resolve(13), 51);
    drag.update(80);
    expect(drag.end(14), 80);
  });

  test('禁用、范围改变或取消后，临时值立即失效', () {
    final drag = HyperSliderDragValue<double>();
    drag.begin(20);
    drag.update(100);
    drag.cancel();
    expect(drag.active, isFalse);
    expect(drag.resolve(2), 2);
    drag.update(90);
    expect(drag.resolve(3), 3);
    drag.begin(3);
    expect(drag.end(4), 3);
  });

  test('零值同样能保持手势，未开始手势时严格受控', () {
    final drag = HyperSliderDragValue<double>();
    expect(drag.resolve(20), 20);
    expect(drag.resolve(21), 21);
    drag.update(70);
    expect(drag.resolve(22), 22);
    drag.begin(22);
    drag.update(0);
    expect(drag.active, isTrue);
    expect(drag.resolve(23), 0);
    expect(drag.end(24), 0);
  });
}
