import 'package:flutter/foundation.dart';

import '../../foundation/hyper_device_type.dart';
import 'hyper_typography_scheme.dart';

/// 四端语义字阶。设备解析只在主题层进行，组件读取已解析的字阶。
@immutable
final class HyperTypographyThemeData {
  const HyperTypographyThemeData({
    this.phone = const HyperTypographyScheme(),
    this.tablet = const HyperTypographyScheme(),
    this.desktop = const HyperTypographyScheme.desktop(),
    this.watch = const HyperTypographyScheme.watch(),
  });

  const HyperTypographyThemeData.uniform(HyperTypographyScheme scheme)
    : phone = scheme,
      tablet = scheme,
      desktop = scheme,
      watch = scheme;

  final HyperTypographyScheme phone;
  final HyperTypographyScheme tablet;
  final HyperTypographyScheme desktop;
  final HyperTypographyScheme watch;

  HyperTypographyScheme resolve(HyperDeviceType deviceType) =>
      switch (deviceType) {
        HyperDeviceType.phone => phone,
        HyperDeviceType.tablet => tablet,
        HyperDeviceType.desktop => desktop,
        HyperDeviceType.watch => watch,
      };

  HyperTypographyThemeData copyWith({
    HyperTypographyScheme? phone,
    HyperTypographyScheme? tablet,
    HyperTypographyScheme? desktop,
    HyperTypographyScheme? watch,
  }) => HyperTypographyThemeData(
    phone: phone ?? this.phone,
    tablet: tablet ?? this.tablet,
    desktop: desktop ?? this.desktop,
    watch: watch ?? this.watch,
  );

  static HyperTypographyThemeData lerp(
    HyperTypographyThemeData a,
    HyperTypographyThemeData b,
    double t,
  ) => HyperTypographyThemeData(
    phone: HyperTypographyScheme.lerp(a.phone, b.phone, t),
    tablet: HyperTypographyScheme.lerp(a.tablet, b.tablet, t),
    desktop: HyperTypographyScheme.lerp(a.desktop, b.desktop, t),
    watch: HyperTypographyScheme.lerp(a.watch, b.watch, t),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperTypographyThemeData &&
          other.phone == phone &&
          other.tablet == tablet &&
          other.desktop == desktop &&
          other.watch == watch;

  @override
  int get hashCode => Object.hash(phone, tablet, desktop, watch);
}
