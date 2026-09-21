import 'package:flutter/widgets.dart';

import '../foundation/hyper_device_type.dart';

/// 一套明确、无倍率换算的终端尺寸配置。
@immutable
final class HyperSizeScheme {
  static const double spaceNone = 0;
  static const double spaceXxs = 2;
  static const double spaceXs = 4;
  static const double spaceSm = 6;
  static const double spaceMd = 8;
  static const double spaceLg = 12;
  static const double spaceXl = 16;
  static const double space2xl = 20;
  static const double space3xl = 24;
  static const double space4xl = 32;
  static const double space5xl = 40;
  static const double space6xl = 48;
  static const double space7xl = 64;

  static const double radiusNone = 0;
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radius2xl = 24;
  static const double radius3xl = 32;
  static const double radius4xl = 48;

  const HyperSizeScheme({
    required this.deviceType,
    required this.controlHeightXs,
    required this.controlHeightSm,
    required this.controlHeightMd,
    required this.controlHeightLg,
    required this.controlHeightXl,
    required this.minimumInteractiveDimension,
    required this.controlRadius,
    required this.surfaceRadius,
    required this.overlayRadius,
    required this.controlPadding,
    required this.pageHorizontalPadding,
    required this.compactSectionSpacing,
    required this.sectionSpacing,
    required this.listTileHeight,
    required this.listTileTwoLineHeight,
    required this.listTileThreeLineHeight,
    required this.toolbarCompactHeight,
    required this.toolbarHeight,
    required this.toolbarEmphasizedHeight,
    required this.iconSize,
  });

  /// 手机尺寸方案。
  const HyperSizeScheme.phone()
    : this(
        deviceType: HyperDeviceType.phone,
        controlHeightXs: 32,
        controlHeightSm: 40,
        controlHeightMd: 48,
        controlHeightLg: 56,
        controlHeightXl: 64,
        minimumInteractiveDimension: 48,
        controlRadius: 16,
        surfaceRadius: 20,
        overlayRadius: 28,
        controlPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        pageHorizontalPadding: 16,
        compactSectionSpacing: 16,
        sectionSpacing: 24,
        listTileHeight: 52,
        listTileTwoLineHeight: 64,
        listTileThreeLineHeight: 76,
        toolbarCompactHeight: 48,
        toolbarHeight: 56,
        toolbarEmphasizedHeight: 64,
        iconSize: 24,
      );

  /// 平板尺寸方案。
  const HyperSizeScheme.tablet()
    : this(
        deviceType: HyperDeviceType.tablet,
        controlHeightXs: 36,
        controlHeightSm: 44,
        controlHeightMd: 52,
        controlHeightLg: 60,
        controlHeightXl: 68,
        minimumInteractiveDimension: 48,
        controlRadius: 16,
        surfaceRadius: 24,
        overlayRadius: 28,
        controlPadding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 14,
        ),
        pageHorizontalPadding: 24,
        compactSectionSpacing: 20,
        sectionSpacing: 32,
        listTileHeight: 56,
        listTileTwoLineHeight: 68,
        listTileThreeLineHeight: 80,
        toolbarCompactHeight: 52,
        toolbarHeight: 64,
        toolbarEmphasizedHeight: 72,
        iconSize: 28,
      );

  /// 桌面尺寸方案。
  const HyperSizeScheme.desktop()
    : this(
        deviceType: HyperDeviceType.desktop,
        controlHeightXs: 28,
        controlHeightSm: 36,
        controlHeightMd: 44,
        controlHeightLg: 52,
        controlHeightXl: 60,
        minimumInteractiveDimension: 36,
        controlRadius: 10,
        surfaceRadius: 14,
        overlayRadius: 18,
        controlPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        pageHorizontalPadding: 24,
        compactSectionSpacing: 20,
        sectionSpacing: 32,
        listTileHeight: 40,
        listTileTwoLineHeight: 48,
        listTileThreeLineHeight: 60,
        toolbarCompactHeight: 40,
        toolbarHeight: 48,
        toolbarEmphasizedHeight: 56,
        iconSize: 20,
      );

  /// 手表尺寸方案。
  const HyperSizeScheme.watch()
    : this(
        deviceType: HyperDeviceType.watch,
        controlHeightXs: 32,
        controlHeightSm: 40,
        controlHeightMd: 48,
        controlHeightLg: 56,
        controlHeightXl: 64,
        minimumInteractiveDimension: 48,
        controlRadius: 20,
        surfaceRadius: 28,
        overlayRadius: 32,
        controlPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        pageHorizontalPadding: 12,
        compactSectionSpacing: 8,
        sectionSpacing: 16,
        listTileHeight: 48,
        listTileTwoLineHeight: 56,
        listTileThreeLineHeight: 68,
        toolbarCompactHeight: 40,
        toolbarHeight: 48,
        toolbarEmphasizedHeight: 56,
        iconSize: 24,
      );

  /// 按终端类型取得内置方案。
  factory HyperSizeScheme.forDevice(HyperDeviceType type) => switch (type) {
    HyperDeviceType.phone => const HyperSizeScheme.phone(),
    HyperDeviceType.tablet => const HyperSizeScheme.tablet(),
    HyperDeviceType.desktop => const HyperSizeScheme.desktop(),
    HyperDeviceType.watch => const HyperSizeScheme.watch(),
  };

  final HyperDeviceType deviceType;
  final double controlHeightXs;
  final double controlHeightSm;
  final double controlHeightMd;
  final double controlHeightLg;
  final double controlHeightXl;
  final double minimumInteractiveDimension;
  final double controlRadius;
  final double surfaceRadius;
  final double overlayRadius;
  final EdgeInsetsGeometry controlPadding;
  final double pageHorizontalPadding;
  final double compactSectionSpacing;
  final double sectionSpacing;
  final double listTileHeight;
  final double listTileTwoLineHeight;
  final double listTileThreeLineHeight;
  final double toolbarCompactHeight;
  final double toolbarHeight;
  final double toolbarEmphasizedHeight;
  final double iconSize;

  HyperSizeScheme copyWith({
    HyperDeviceType? deviceType,
    double? controlHeightXs,
    double? controlHeightSm,
    double? controlHeightMd,
    double? controlHeightLg,
    double? controlHeightXl,
    double? minimumInteractiveDimension,
    double? controlRadius,
    double? surfaceRadius,
    double? overlayRadius,
    EdgeInsetsGeometry? controlPadding,
    double? pageHorizontalPadding,
    double? compactSectionSpacing,
    double? sectionSpacing,
    double? listTileHeight,
    double? listTileTwoLineHeight,
    double? listTileThreeLineHeight,
    double? toolbarCompactHeight,
    double? toolbarHeight,
    double? toolbarEmphasizedHeight,
    double? iconSize,
  }) => HyperSizeScheme(
    deviceType: deviceType ?? this.deviceType,
    controlHeightXs: controlHeightXs ?? this.controlHeightXs,
    controlHeightSm: controlHeightSm ?? this.controlHeightSm,
    controlHeightMd: controlHeightMd ?? this.controlHeightMd,
    controlHeightLg: controlHeightLg ?? this.controlHeightLg,
    controlHeightXl: controlHeightXl ?? this.controlHeightXl,
    minimumInteractiveDimension:
        minimumInteractiveDimension ?? this.minimumInteractiveDimension,
    controlRadius: controlRadius ?? this.controlRadius,
    surfaceRadius: surfaceRadius ?? this.surfaceRadius,
    overlayRadius: overlayRadius ?? this.overlayRadius,
    controlPadding: controlPadding ?? this.controlPadding,
    pageHorizontalPadding: pageHorizontalPadding ?? this.pageHorizontalPadding,
    compactSectionSpacing: compactSectionSpacing ?? this.compactSectionSpacing,
    sectionSpacing: sectionSpacing ?? this.sectionSpacing,
    listTileHeight: listTileHeight ?? this.listTileHeight,
    listTileTwoLineHeight: listTileTwoLineHeight ?? this.listTileTwoLineHeight,
    listTileThreeLineHeight:
        listTileThreeLineHeight ?? this.listTileThreeLineHeight,
    toolbarCompactHeight: toolbarCompactHeight ?? this.toolbarCompactHeight,
    toolbarHeight: toolbarHeight ?? this.toolbarHeight,
    toolbarEmphasizedHeight:
        toolbarEmphasizedHeight ?? this.toolbarEmphasizedHeight,
    iconSize: iconSize ?? this.iconSize,
  );

  /// 在两套明确尺寸之间插值，仅用于主题切换动画。
  static HyperSizeScheme lerp(HyperSizeScheme a, HyperSizeScheme b, double t) {
    if (t == 0) return a;
    if (t == 1) return b;
    double value(double x, double y) => x + (y - x) * t;
    return HyperSizeScheme(
      deviceType: t < .5 ? a.deviceType : b.deviceType,
      controlHeightXs: value(a.controlHeightXs, b.controlHeightXs),
      controlHeightSm: value(a.controlHeightSm, b.controlHeightSm),
      controlHeightMd: value(a.controlHeightMd, b.controlHeightMd),
      controlHeightLg: value(a.controlHeightLg, b.controlHeightLg),
      controlHeightXl: value(a.controlHeightXl, b.controlHeightXl),
      minimumInteractiveDimension: value(
        a.minimumInteractiveDimension,
        b.minimumInteractiveDimension,
      ),
      controlRadius: value(a.controlRadius, b.controlRadius),
      surfaceRadius: value(a.surfaceRadius, b.surfaceRadius),
      overlayRadius: value(a.overlayRadius, b.overlayRadius),
      controlPadding: EdgeInsetsGeometry.lerp(
        a.controlPadding,
        b.controlPadding,
        t,
      )!,
      pageHorizontalPadding: value(
        a.pageHorizontalPadding,
        b.pageHorizontalPadding,
      ),
      compactSectionSpacing: value(
        a.compactSectionSpacing,
        b.compactSectionSpacing,
      ),
      sectionSpacing: value(a.sectionSpacing, b.sectionSpacing),
      listTileHeight: value(a.listTileHeight, b.listTileHeight),
      listTileTwoLineHeight: value(
        a.listTileTwoLineHeight,
        b.listTileTwoLineHeight,
      ),
      listTileThreeLineHeight: value(
        a.listTileThreeLineHeight,
        b.listTileThreeLineHeight,
      ),
      toolbarCompactHeight: value(
        a.toolbarCompactHeight,
        b.toolbarCompactHeight,
      ),
      toolbarHeight: value(a.toolbarHeight, b.toolbarHeight),
      toolbarEmphasizedHeight: value(
        a.toolbarEmphasizedHeight,
        b.toolbarEmphasizedHeight,
      ),
      iconSize: value(a.iconSize, b.iconSize),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperSizeScheme &&
          other.deviceType == deviceType &&
          other.controlHeightXs == controlHeightXs &&
          other.controlHeightSm == controlHeightSm &&
          other.controlHeightMd == controlHeightMd &&
          other.controlHeightLg == controlHeightLg &&
          other.controlHeightXl == controlHeightXl &&
          other.minimumInteractiveDimension == minimumInteractiveDimension &&
          other.controlRadius == controlRadius &&
          other.surfaceRadius == surfaceRadius &&
          other.overlayRadius == overlayRadius &&
          other.controlPadding == controlPadding &&
          other.pageHorizontalPadding == pageHorizontalPadding &&
          other.compactSectionSpacing == compactSectionSpacing &&
          other.sectionSpacing == sectionSpacing &&
          other.listTileHeight == listTileHeight &&
          other.listTileTwoLineHeight == listTileTwoLineHeight &&
          other.listTileThreeLineHeight == listTileThreeLineHeight &&
          other.toolbarCompactHeight == toolbarCompactHeight &&
          other.toolbarHeight == toolbarHeight &&
          other.toolbarEmphasizedHeight == toolbarEmphasizedHeight &&
          other.iconSize == iconSize;

  @override
  int get hashCode => Object.hashAll([
    deviceType,
    controlHeightXs,
    controlHeightSm,
    controlHeightMd,
    controlHeightLg,
    controlHeightXl,
    minimumInteractiveDimension,
    controlRadius,
    surfaceRadius,
    overlayRadius,
    controlPadding,
    pageHorizontalPadding,
    compactSectionSpacing,
    sectionSpacing,
    listTileHeight,
    listTileTwoLineHeight,
    listTileThreeLineHeight,
    toolbarCompactHeight,
    toolbarHeight,
    toolbarEmphasizedHeight,
    iconSize,
  ]);
}
