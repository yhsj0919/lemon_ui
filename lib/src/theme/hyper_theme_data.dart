import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/material.dart';

import '../components/container/hyper_container_theme.dart';
import '../components/checkbox/hyper_checkbox_theme.dart';
import '../components/button/hyper_button_theme.dart';
import '../components/icon_button/hyper_icon_button_theme.dart';
import '../components/radio/hyper_radio_theme.dart';
import '../components/switch/hyper_switch_theme.dart';
import 'hyper_color_scheme.dart';
import 'hyper_contrast_theme.dart';
import 'hyper_motion_theme.dart';
import 'hyper_material_theme.dart';
import 'hyper_size_scheme.dart';
import 'hyper_typography_scheme.dart';

/// 返回当前平台原生 UI 字体，不依赖随 Flutter 或应用打包的字体文件。
String _systemFontFamily() => switch (defaultTargetPlatform) {
  TargetPlatform.windows => 'Microsoft YaHei UI',
  TargetPlatform.macOS => '.AppleSystemUIFont',
  TargetPlatform.iOS => '.SF UI Text',
  TargetPlatform.android => 'sans-serif',
  TargetPlatform.linux => 'sans-serif',
  TargetPlatform.fuchsia => 'sans-serif',
};

/// 中文字体放在前面，桌面端缺少某个字体时仍能回退到系统字库。
List<String> _systemFontFallback() => switch (defaultTargetPlatform) {
  TargetPlatform.windows => const ['Microsoft YaHei', 'Segoe UI'],
  TargetPlatform.macOS ||
  TargetPlatform.iOS => const ['PingFang SC', 'Helvetica Neue'],
  TargetPlatform.android => const ['Noto Sans CJK SC', 'Noto Sans SC'],
  TargetPlatform.linux => const ['Noto Sans CJK SC', 'Noto Sans'],
  TargetPlatform.fuchsia => const ['Noto Sans'],
};

/// Lemon UI 的完整主题数据。
///
/// 所有数值都是 Flutter 逻辑尺寸。主题只负责选择离散默认值，不对实例
/// 显式值进行倍率缩放。
@immutable
final class HyperThemeData extends ThemeExtension<HyperThemeData> {
  const HyperThemeData({
    required this.colors,
    required this.textTheme,
    required this.sizes,
    this.typography = const HyperTypographyScheme(),
    required this.motion,
    required this.containerTheme,
    this.buttonTheme = const HyperButtonThemeData(),
    this.iconButtonTheme = const HyperIconButtonThemeData(),
    this.switchTheme = const HyperSwitchThemeData(),
    this.checkboxTheme = const HyperCheckboxThemeData(),
    this.radioTheme = const HyperRadioThemeData(),
    this.materialTheme = const HyperMaterialThemeData(),
    this.contrastTheme = const HyperContrastThemeData(),
  });

  factory HyperThemeData.light({
    Color seedColor = const Color(0xFF3482FF),
    HyperSizeScheme sizes = const HyperSizeScheme.phone(),
    HyperTypographyScheme typography = const HyperTypographyScheme(),
  }) => HyperThemeData.fromSeed(
    seedColor: seedColor,
    sizes: sizes,
    typography: typography,
  );

  factory HyperThemeData.dark({
    Color seedColor = const Color(0xFF3482FF),
    HyperSizeScheme sizes = const HyperSizeScheme.phone(),
    HyperTypographyScheme typography = const HyperTypographyScheme(),
  }) => HyperThemeData.fromSeed(
    seedColor: seedColor,
    brightness: Brightness.dark,
    sizes: sizes,
    typography: typography,
  );

  /// 从种子色和一套明确尺寸创建开箱即用的完整主题。
  factory HyperThemeData.fromSeed({
    required Color seedColor,
    Brightness brightness = Brightness.light,
    HyperSizeScheme sizes = const HyperSizeScheme.phone(),
    HyperTypographyScheme typography = const HyperTypographyScheme(),
  }) {
    final colors = HyperColorScheme.fromSeed(
      seedColor: seedColor,
      brightness: brightness,
    );
    final material = ThemeData(
      colorScheme: colors.toMaterialColorScheme(),
      useMaterial3: true,
      fontFamily: _systemFontFamily(),
      fontFamilyFallback: _systemFontFallback(),
    );
    return HyperThemeData(
      colors: colors,
      textTheme: typography.applyTo(material.textTheme),
      sizes: sizes,
      typography: typography,
      motion: const HyperMotionThemeData(),
      containerTheme: HyperContainerThemeData(),
      buttonTheme: const HyperButtonThemeData(),
      iconButtonTheme: const HyperIconButtonThemeData(),
      switchTheme: const HyperSwitchThemeData(),
      checkboxTheme: const HyperCheckboxThemeData(),
      radioTheme: const HyperRadioThemeData(),
      materialTheme: const HyperMaterialThemeData(),
      contrastTheme: const HyperContrastThemeData(),
    );
  }

  /// 从当前 Flutter Material 主题建立 Hyper 主题回退值。
  factory HyperThemeData.fromMaterial(
    ThemeData material, {
    HyperSizeScheme sizes = const HyperSizeScheme.phone(),
    HyperTypographyScheme typography = const HyperTypographyScheme(),
  }) {
    final colorScheme = material.colorScheme;
    final colors =
        HyperColorScheme.fromSeed(
          seedColor: colorScheme.primary,
          brightness: colorScheme.brightness,
        ).copyWith(
          primary: colorScheme.primary,
          onPrimary: colorScheme.onPrimary,
          primaryContainer: colorScheme.primaryContainer,
          onPrimaryContainer: colorScheme.onPrimaryContainer,
          background: colorScheme.surface,
          onBackground: colorScheme.onSurface,
          surface: colorScheme.surfaceContainer,
          onSurface: colorScheme.onSurface,
          surfaceElevated: colorScheme.surfaceContainerHigh,
          onSurfaceElevated: colorScheme.onSurface,
          surfaceMuted: colorScheme.surfaceContainerHighest,
          onSurfaceMuted: colorScheme.onSurface,
          textPrimary: colorScheme.onSurface,
          textSecondary: colorScheme.onSurfaceVariant,
          textTertiary: colorScheme.onSurfaceVariant.withValues(alpha: 0.72),
          outline: colorScheme.outline,
          scrim: colorScheme.scrim,
          error: colorScheme.error,
          onError: colorScheme.onError,
        );
    return HyperThemeData(
      colors: colors,
      textTheme: typography.applyTo(material.textTheme),
      sizes: sizes,
      typography: typography,
      motion: const HyperMotionThemeData(),
      containerTheme: HyperContainerThemeData(),
      buttonTheme: const HyperButtonThemeData(),
      iconButtonTheme: const HyperIconButtonThemeData(),
      switchTheme: const HyperSwitchThemeData(),
      checkboxTheme: const HyperCheckboxThemeData(),
      radioTheme: const HyperRadioThemeData(),
      materialTheme: const HyperMaterialThemeData(),
      contrastTheme: const HyperContrastThemeData(),
    );
  }

  /// 全局语义颜色。
  final HyperColorScheme colors;

  /// 已应用系统字体和字号规范的 Flutter 文字主题。
  final TextTheme textTheme;

  /// 当前终端使用的明确尺寸方案。
  final HyperSizeScheme sizes;

  /// 全局语义字号；数值明确且不参与倍率缩放。
  final HyperTypographyScheme typography;

  /// 全局统一动画参数。
  /// 全局动画时长、曲线和弹簧参数。
  final HyperMotionThemeData motion;

  /// 全局容器主题。
  final HyperContainerThemeData containerTheme;

  /// 全局按钮主题。
  final HyperButtonThemeData buttonTheme;

  /// 全局图标按钮主题。
  final HyperIconButtonThemeData iconButtonTheme;

  /// 全局开关主题。
  final HyperSwitchThemeData switchTheme;

  /// 全局复选框主题。
  final HyperCheckboxThemeData checkboxTheme;

  /// 全局单选控件主题。
  final HyperRadioThemeData radioTheme;

  /// 全局材质质量和默认材质。
  final HyperMaterialThemeData materialTheme;

  /// 全局前景反色策略。
  final HyperContrastThemeData contrastTheme;

  Brightness get brightness => colors.brightness;
  BorderRadiusGeometry get borderRadius =>
      BorderRadius.circular(sizes.controlRadius);
  double get controlHeight => sizes.controlHeightMd;
  EdgeInsetsGeometry get controlPadding => sizes.controlPadding;

  /// 兼容读取标准动画时长。
  Duration get animationDuration => motion.standardDuration;

  /// 兼容读取标准动画曲线。
  Curve get animationCurve => motion.standardCurve;

  ThemeData toMaterialThemeData([ThemeData? base]) {
    final material = base ?? ThemeData(brightness: brightness);
    return material.copyWith(
      brightness: brightness,
      colorScheme: colors.toMaterialColorScheme(),
      textTheme: textTheme,
      scaffoldBackgroundColor: colors.background,
      canvasColor: colors.surface,
      cardColor: colors.surface,
      dividerColor: colors.outline,
      splashColor: colors.stateLayer.withValues(alpha: 0.12),
      highlightColor: colors.stateLayer.withValues(alpha: 0.08),
      hoverColor: colors.stateLayer.withValues(alpha: 0.06),
      focusColor: colors.stateLayer.withValues(alpha: 0.12),
      appBarTheme: material.appBarTheme.copyWith(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      drawerTheme: material.drawerTheme.copyWith(
        backgroundColor: colors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
      ),
      dialogTheme: material.dialogTheme.copyWith(
        backgroundColor: colors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        barrierColor: colors.scrim,
      ),
      bottomSheetTheme: material.bottomSheetTheme.copyWith(
        backgroundColor: colors.surfaceElevated,
        modalBackgroundColor: colors.surfaceElevated,
        surfaceTintColor: Colors.transparent,
        modalBarrierColor: colors.scrim,
      ),
      cardTheme: material.cardTheme.copyWith(
        color: colors.surface,
        surfaceTintColor: Colors.transparent,
      ),
      dividerTheme: material.dividerTheme.copyWith(color: colors.outline),
      extensions: [
        ...material.extensions.values.where(
          (extension) => extension is! HyperThemeData,
        ),
        this,
      ],
    );
  }

  @override
  HyperThemeData copyWith({
    HyperColorScheme? colors,
    TextTheme? textTheme,
    HyperSizeScheme? sizes,
    HyperTypographyScheme? typography,
    HyperMotionThemeData? motion,
    Duration? animationDuration,
    Curve? animationCurve,
    HyperContainerThemeData? containerTheme,
    HyperButtonThemeData? buttonTheme,
    HyperIconButtonThemeData? iconButtonTheme,
    HyperSwitchThemeData? switchTheme,
    HyperCheckboxThemeData? checkboxTheme,
    HyperRadioThemeData? radioTheme,
    HyperMaterialThemeData? materialTheme,
    HyperContrastThemeData? contrastTheme,
  }) {
    var resolvedMotion = motion ?? this.motion;
    final resolvedTypography = typography ?? this.typography;
    final resolvedTextTheme =
        textTheme ??
        (typography == null
            ? this.textTheme
            : resolvedTypography.applyTo(this.textTheme));
    if (animationDuration != null || animationCurve != null) {
      resolvedMotion = resolvedMotion.copyWith(
        standardDuration: animationDuration,
        standardCurve: animationCurve,
      );
    }
    return HyperThemeData(
      colors: colors ?? this.colors,
      textTheme: resolvedTextTheme,
      sizes: sizes ?? this.sizes,
      typography: resolvedTypography,
      motion: resolvedMotion,
      containerTheme: containerTheme ?? this.containerTheme,
      buttonTheme: buttonTheme ?? this.buttonTheme,
      iconButtonTheme: iconButtonTheme ?? this.iconButtonTheme,
      switchTheme: switchTheme ?? this.switchTheme,
      checkboxTheme: checkboxTheme ?? this.checkboxTheme,
      radioTheme: radioTheme ?? this.radioTheme,
      materialTheme: materialTheme ?? this.materialTheme,
      contrastTheme: contrastTheme ?? this.contrastTheme,
    );
  }

  @override
  HyperThemeData lerp(covariant HyperThemeData? other, double t) {
    if (other == null || t == 0) return this;
    if (t == 1) return other;
    return HyperThemeData(
      colors: HyperColorScheme.lerp(colors, other.colors, t),
      textTheme: TextTheme.lerp(textTheme, other.textTheme, t),
      sizes: HyperSizeScheme.lerp(sizes, other.sizes, t),
      typography: HyperTypographyScheme.lerp(typography, other.typography, t),
      motion: HyperMotionThemeData.lerp(motion, other.motion, t),
      containerTheme: HyperContainerThemeData.lerp(
        containerTheme,
        other.containerTheme,
        t,
      ),
      buttonTheme: HyperButtonThemeData.lerp(buttonTheme, other.buttonTheme, t),
      iconButtonTheme: HyperIconButtonThemeData.lerp(
        iconButtonTheme,
        other.iconButtonTheme,
        t,
      ),
      switchTheme: HyperSwitchThemeData.lerp(switchTheme, other.switchTheme, t),
      checkboxTheme: HyperCheckboxThemeData.lerp(
        checkboxTheme,
        other.checkboxTheme,
        t,
      ),
      radioTheme: HyperRadioThemeData.lerp(radioTheme, other.radioTheme, t),
      materialTheme: HyperMaterialThemeData.lerp(
        materialTheme,
        other.materialTheme,
        t,
      ),
      contrastTheme: HyperContrastThemeData.lerp(
        contrastTheme,
        other.contrastTheme,
        t,
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperThemeData &&
          other.colors == colors &&
          other.textTheme == textTheme &&
          other.sizes == sizes &&
          other.typography == typography &&
          other.motion == motion &&
          other.containerTheme == containerTheme &&
          other.buttonTheme == buttonTheme &&
          other.iconButtonTheme == iconButtonTheme &&
          other.switchTheme == switchTheme &&
          other.checkboxTheme == checkboxTheme &&
          other.radioTheme == radioTheme &&
          other.materialTheme == materialTheme &&
          other.contrastTheme == contrastTheme;

  @override
  int get hashCode => Object.hash(
    colors,
    textTheme,
    sizes,
    typography,
    motion,
    containerTheme,
    buttonTheme,
    iconButtonTheme,
    switchTheme,
    checkboxTheme,
    radioTheme,
    materialTheme,
    contrastTheme,
  );
}

/// 用于显式动画和测试的 Hyper 主题补间。
final class HyperThemeDataTween extends Tween<HyperThemeData> {
  HyperThemeDataTween({super.begin, super.end});

  @override
  HyperThemeData lerp(double t) => begin!.lerp(end, t);
}
