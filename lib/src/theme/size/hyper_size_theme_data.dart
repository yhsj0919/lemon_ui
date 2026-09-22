import 'package:flutter/foundation.dart';

import '../../foundation/hyper_device_type.dart';
import 'hyper_size_scheme.dart';

/// 手机、平板、桌面和手表四套明确尺寸方案的全局集合。
///
/// 应用通过 [copyWith] 覆盖任意终端的差异；组件不得直接持有或选择设备尺寸。
@immutable
final class HyperSizeThemeData {
  const HyperSizeThemeData({
    this.phone = const HyperSizeScheme.phone(),
    this.tablet = const HyperSizeScheme.tablet(),
    this.desktop = const HyperSizeScheme.desktop(),
    this.watch = const HyperSizeScheme.watch(),
  });

  final HyperSizeScheme phone;
  final HyperSizeScheme tablet;
  final HyperSizeScheme desktop;
  final HyperSizeScheme watch;

  /// 返回指定真实设备类型使用的完整尺寸方案。
  HyperSizeScheme resolve(HyperDeviceType deviceType) => switch (deviceType) {
    HyperDeviceType.phone => phone,
    HyperDeviceType.tablet => tablet,
    HyperDeviceType.desktop => desktop,
    HyperDeviceType.watch => watch,
  };

  HyperSizeThemeData copyWith({
    HyperSizeScheme? phone,
    HyperSizeScheme? tablet,
    HyperSizeScheme? desktop,
    HyperSizeScheme? watch,
  }) => HyperSizeThemeData(
    phone: phone ?? this.phone,
    tablet: tablet ?? this.tablet,
    desktop: desktop ?? this.desktop,
    watch: watch ?? this.watch,
  );

  static HyperSizeThemeData lerp(
    HyperSizeThemeData a,
    HyperSizeThemeData b,
    double t,
  ) {
    if (t == 0) return a;
    if (t == 1) return b;
    return HyperSizeThemeData(
      phone: HyperSizeScheme.lerp(a.phone, b.phone, t),
      tablet: HyperSizeScheme.lerp(a.tablet, b.tablet, t),
      desktop: HyperSizeScheme.lerp(a.desktop, b.desktop, t),
      watch: HyperSizeScheme.lerp(a.watch, b.watch, t),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperSizeThemeData &&
          other.phone == phone &&
          other.tablet == tablet &&
          other.desktop == desktop &&
          other.watch == watch;

  @override
  int get hashCode => Object.hash(phone, tablet, desktop, watch);
}
