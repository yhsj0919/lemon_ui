import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/loading_overlay/hyper_loading_visibility.dart';

void main() {
  test('短请求在延迟内结束，不显示也不遗留计时器', () {
    fakeAsync((fake) {
      final model = HyperLoadingVisibility(
        now: () => DateTime(2026).add(fake.elapsed),
      );
      void update(bool loading) => model.update(
        loading: loading,
        showDelay: const Duration(milliseconds: 120),
        minimumVisibleDuration: const Duration(milliseconds: 240),
      );
      update(true);
      fake.elapse(const Duration(milliseconds: 60));
      update(false);
      fake.elapse(const Duration(seconds: 1));
      expect(model.visible, false);
      expect(fake.nonPeriodicTimerCount, 0);
      model.dispose();
    });
  });
  test('最短显示时间、重启与重复更新保持连续，不重新等待', () {
    fakeAsync((fake) {
      final model = HyperLoadingVisibility(
        now: () => DateTime(2026).add(fake.elapsed),
      );
      void update(bool loading) => model.update(
        loading: loading,
        showDelay: const Duration(milliseconds: 120),
        minimumVisibleDuration: const Duration(milliseconds: 240),
      );
      update(true);
      fake.elapse(const Duration(milliseconds: 100));
      update(true);
      fake.elapse(const Duration(milliseconds: 20));
      expect(model.visible, true);
      update(false);
      fake.elapse(const Duration(milliseconds: 100));
      update(true);
      expect(model.visible, true);
      fake.elapse(const Duration(milliseconds: 200));
      update(false);
      expect(model.visible, false);
      model.dispose();
    });
  });
  test('修改延迟以原请求开始时间计算，销毁取消未完成计时', () {
    fakeAsync((fake) {
      final model = HyperLoadingVisibility(
        now: () => DateTime(2026).add(fake.elapsed),
      );
      model.update(
        loading: true,
        showDelay: const Duration(seconds: 1),
        minimumVisibleDuration: Duration.zero,
      );
      fake.elapse(const Duration(milliseconds: 100));
      model.update(
        loading: true,
        showDelay: const Duration(milliseconds: 200),
        minimumVisibleDuration: Duration.zero,
      );
      fake.elapse(const Duration(milliseconds: 99));
      expect(model.visible, false);
      fake.elapse(const Duration(milliseconds: 1));
      expect(model.visible, true);
      model.update(
        loading: false,
        showDelay: Duration.zero,
        minimumVisibleDuration: const Duration(seconds: 1),
      );
      model.dispose();
      expect(fake.nonPeriodicTimerCount, 0);
      expect(
        () => HyperLoadingVisibility().update(
          loading: true,
          showDelay: const Duration(seconds: -1),
          minimumVisibleDuration: Duration.zero,
        ),
        throwsArgumentError,
      );
    });
  });
  test('主题字段合并、插值和值相等，嵌套样式保留规格', () {
    const base = HyperLoadingOverlayStyle(
      progressStyle: HyperProgressStyle(size: 24),
      textStyle: TextStyle(fontSize: 16),
      maxContentWidth: 320,
      materialQuality: HyperMaterialQuality.advanced,
      reduceTransparency: false,
      showDelay: Duration(milliseconds: 120),
      boxShadow: [BoxShadow(color: Colors.black12)],
    );
    final changed = base.merge(
      const HyperLoadingOverlayStyle(
        progressStyle: HyperProgressStyle(color: Colors.teal),
        textStyle: TextStyle(color: Colors.teal),
        maxContentWidth: 400,
        showDelay: Duration.zero,
      ),
    );
    expect(changed.progressStyle!.size, 24);
    expect(changed.textStyle!.fontSize, 16);
    expect(changed.materialQuality, HyperMaterialQuality.advanced);
    expect(
      HyperLoadingOverlayStyle.lerp(base, changed, .5).maxContentWidth,
      360,
    );
    expect(
      HyperLoadingOverlayStyle.lerp(base, changed, .5).showDelay,
      const Duration(milliseconds: 60),
    );
    expect(base.copyWith(), base);
    expect(base.copyWith().hashCode, base.hashCode);
    expect(base.copyWith(boxShadow: []), isNot(base));
  });
  test('四端规格与全局、局部主题数据保持完整集成', () {
    final theme = HyperThemeData.light();
    final sizes = theme.sizes;
    expect(
      [
        sizes.phone.loadingOverlay.maxContentWidth,
        sizes.tablet.loadingOverlay.maxContentWidth,
        sizes.desktop.loadingOverlay.maxContentWidth,
        sizes.watch.loadingOverlay.maxContentWidth,
      ],
      [320, 400, 360, 180],
    );
    final changedSize = sizes.desktop.copyWith(
      loadingOverlay: sizes.desktop.loadingOverlay.copyWith(spacing: 12),
    );
    expect(changedSize.alert, sizes.desktop.alert);
    expect(
      HyperSizeScheme.lerp(
        sizes.desktop,
        changedSize,
        .5,
      ).loadingOverlay.spacing,
      10,
    );
    expect(changedSize.copyWith().hashCode, changedSize.hashCode);
    final changed = theme.copyWith(
      loadingOverlayTheme: const HyperLoadingOverlayThemeData(
        style: HyperLoadingOverlayStyle(showDelay: Duration.zero),
      ),
    );
    expect(changed.copyWith(), changed);
    expect(changed.copyWith().hashCode, changed.hashCode);
    expect(
      theme.lerp(changed, 1).loadingOverlayTheme,
      changed.loadingOverlayTheme,
    );
    expect(changed.loadingOverlayTheme.copyWith(), changed.loadingOverlayTheme);
    expect(changed.alertTheme, theme.alertTheme);
  });
}
