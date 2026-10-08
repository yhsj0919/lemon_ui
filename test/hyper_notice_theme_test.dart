import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/notice/hyper_notice_defaults.dart';

void main() {
  test('四种状态复用统一语义色和图标，材质策略来自统一主题', () {
    final theme = HyperThemeData.light();
    const material = HyperMaterialThemeData(
      quality: HyperMaterialQuality.advanced,
      reduceTransparency: true,
      material: HyperSurfaceMaterial.frostedGlass(),
    );
    final accents = [
      theme.colors.primary,
      theme.colors.success,
      theme.colors.warning,
      theme.colors.error,
    ];
    for (final severity in HyperNoticeSeverity.values) {
      final resolved = noticeDefaults(
        theme: theme,
        metrics: theme.sizes.desktop.alert,
        materialTheme: material,
        severity: severity,
        banner: false,
      );
      expect(resolved.iconColor, accents[severity.index]);
      expect(resolved.icon, isNotNull);
      expect(resolved.material, material.material);
      expect(resolved.materialQuality, material.quality);
      expect(resolved.reduceTransparency, true);
      expect(resolved.duration, theme.motion.standardDuration);
      expect(resolved.padding, theme.sizes.desktop.alert.padding);
    }
  });
  test('通用、状态和实例字段依次覆盖，文字保留未修改规格', () {
    const theme = HyperAlertThemeData(
      style: HyperNoticeStyle(
        titleStyle: TextStyle(fontSize: 18),
        iconSize: 20,
      ),
      warning: HyperNoticeStyle(
        titleStyle: TextStyle(color: Colors.orange),
        iconSize: 22,
      ),
    );
    final resolved = theme
        .styleFor(HyperNoticeSeverity.warning)
        .merge(const HyperNoticeStyle(iconSize: 24));
    expect(resolved.titleStyle!.fontSize, 18);
    expect(resolved.titleStyle!.color, Colors.orange);
    expect(resolved.iconSize, 24);
    expect(theme.styleFor(HyperNoticeSeverity.info).iconSize, 20);
    final merged = theme.merge(
      const HyperAlertThemeData(warning: HyperNoticeStyle(spacing: 12)),
    );
    expect(merged.warning!.iconSize, 22);
    expect(merged.warning!.spacing, 12);
  });
  test('样式支持复制插值和值相等，动画与关闭图标可替换', () {
    const base = HyperNoticeStyle(
      padding: EdgeInsets.all(8),
      iconSize: 16,
      background: HyperFill.color(Colors.white),
      duration: Duration(milliseconds: 120),
      boxShadow: [BoxShadow(color: Colors.black12)],
      closeIcon: Icons.close,
    );
    final other = base.copyWith(
      iconSize: 24,
      duration: const Duration(milliseconds: 240),
      closeIcon: Icons.cancel,
    );
    final mid = HyperNoticeStyle.lerp(base, other, .5);
    expect(mid.iconSize, 20);
    expect(mid.duration, const Duration(milliseconds: 180));
    expect(mid.closeIcon, Icons.cancel);
    expect(base.copyWith(), base);
    expect(base.copyWith().hashCode, base.hashCode);
    expect(HyperNoticeStyle.lerp(base, other, 0), same(base));
    expect(base.copyWith(boxShadow: []), isNot(base));
    expect(
      HyperAlertThemeData.lerp(
        const HyperAlertThemeData(style: base),
        HyperAlertThemeData(style: other),
        .5,
      ).style,
      mid,
    );
    expect(
      HyperBannerThemeData.lerp(
        const HyperBannerThemeData(style: base),
        HyperBannerThemeData(style: other),
        .5,
      ).style,
      mid,
    );
  });
  test('Alert、Banner 的四端尺寸及全局主题保持独立', () {
    final theme = HyperThemeData.light();
    final sizes = theme.sizes;
    expect(
      [
        sizes.phone.alert.radius,
        sizes.tablet.alert.radius,
        sizes.desktop.alert.radius,
        sizes.watch.alert.radius,
      ],
      [16, 20, 8, 20],
    );
    expect(
      [
        sizes.phone.banner.radius,
        sizes.tablet.banner.radius,
        sizes.desktop.banner.radius,
        sizes.watch.banner.radius,
      ],
      [0, 0, 0, 0],
    );
    final changedSize = sizes.desktop.copyWith(
      alert: sizes.desktop.alert.copyWith(iconSize: 24),
    );
    expect(changedSize.banner, sizes.desktop.banner);
    expect(
      HyperSizeScheme.lerp(sizes.desktop, changedSize, .5).alert.iconSize,
      20,
    );
    expect(changedSize.copyWith(), changedSize);
    expect(changedSize.copyWith().hashCode, changedSize.hashCode);
    final changed = theme.copyWith(
      alertTheme: const HyperAlertThemeData(
        error: HyperNoticeStyle(iconColor: Colors.pink),
      ),
      bannerTheme: const HyperBannerThemeData(
        style: HyperNoticeStyle(spacing: 12),
      ),
    );
    expect(changed, isNot(theme));
    expect(changed.copyWith(), changed);
    expect(changed.copyWith().hashCode, changed.hashCode);
    expect(theme.lerp(changed, 1).alertTheme, changed.alertTheme);
    expect(theme.lerp(changed, 1).bannerTheme, changed.bannerTheme);
    expect(theme.bannerTheme.copyWith().hashCode, theme.bannerTheme.hashCode);
  });
}
