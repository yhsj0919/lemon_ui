import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';
import '../../theme/hyper_contrast_theme.dart';

const _unchanged = Object();

/// 单个按钮样式的完整值对象。
///
/// 所有空字段都表示继续继承；明确的 none、空列表和零值表示显式覆盖。
@immutable
final class HyperButtonStyle {
  HyperButtonStyle({
    this.background,
    this.disabledBackground,
    this.material,
    this.foregroundColor,
    this.disabledForegroundColor,
    this.contrastMode,
    this.overlayColor,
    this.hoverOverlayOpacity,
    this.focusOverlayOpacity,
    this.pressOverlayOpacity,
    this.border,
    this.borderRadius,
    this.textStyle,
    this.padding,
    this.margin,
    this.alignment,
    this.width,
    this.height,
    this.minimumSize,
    this.maximumSize,
    this.minimumTapTargetSize,
    this.iconSize,
    this.iconSpacing,
    this.animationDuration,
    this.animationCurve,
    this.clipBehavior,
    this.progressColor,
    this.progressTrackColor,
    this.progressSize,
    this.progressThickness,
    List<BoxShadow>? boxShadow,
  }) : boxShadow = boxShadow == null ? null : List.unmodifiable(boxShadow);

  /// 正常状态背景；null 表示继续继承。
  final HyperFill? background;

  /// 禁用状态背景；null 时使用正常背景。
  final HyperFill? disabledBackground;

  /// 表面材质配方；设置后按全局材质质量解析。
  final HyperSurfaceMaterial? material;

  /// 正常状态文字与图标颜色。
  final Color? foregroundColor;

  /// 禁用状态文字与图标颜色。
  final Color? disabledForegroundColor;

  /// 当前按钮的前景反色策略。
  final HyperContrastMode? contrastMode;

  /// 悬停、焦点和按下状态层的基础颜色。
  final Color? overlayColor;

  /// 鼠标悬停状态层透明度。
  final double? hoverOverlayOpacity;

  /// 键盘焦点状态层透明度。
  final double? focusOverlayOpacity;

  /// 按下状态层透明度。
  final double? pressOverlayOpacity;

  /// 按钮边框；[BorderSide.none] 表示显式关闭。
  final BorderSide? border;

  /// 按钮外形圆角。
  final BorderRadiusGeometry? borderRadius;

  /// 按钮阴影；空列表表示显式关闭。
  final List<BoxShadow>? boxShadow;

  /// 按钮文字样式。
  final TextStyle? textStyle;

  /// 内容与按钮边界之间的内边距。
  final EdgeInsetsGeometry? padding;

  /// 按钮外部边距。
  final EdgeInsetsGeometry? margin;

  /// 内容在按钮内部的对齐方式。
  final AlignmentGeometry? alignment;

  /// 明确按钮宽度。
  final double? width;

  /// 明确按钮高度。
  final double? height;

  /// 按钮视觉区域的最小尺寸。
  final Size? minimumSize;

  /// 按钮视觉区域的最大尺寸。
  final Size? maximumSize;

  /// 独立于视觉尺寸的最小命中区域。
  final Size? minimumTapTargetSize;

  /// 图标尺寸。
  final double? iconSize;

  /// 图标与文字之间的间距。
  final double? iconSpacing;

  /// 样式变化的动画时长。
  final Duration? animationDuration;

  /// 样式变化的动画曲线。
  final Curve? animationCurve;

  /// 高级材质的裁切方式。
  final Clip? clipBehavior;

  /// 加载进度前景色。
  final Color? progressColor;

  /// 加载进度轨道颜色。
  final Color? progressTrackColor;

  /// 环形加载指示器尺寸。
  final double? progressSize;

  /// 环形加载指示器线宽。
  final double? progressThickness;

  /// 覆盖对象中的非空字段逐项替换当前字段。
  HyperButtonStyle merge(HyperButtonStyle? other) {
    if (other == null) return this;
    return HyperButtonStyle(
      background: other.background ?? background,
      disabledBackground: other.disabledBackground ?? disabledBackground,
      material: other.material ?? material,
      foregroundColor: other.foregroundColor ?? foregroundColor,
      disabledForegroundColor:
          other.disabledForegroundColor ?? disabledForegroundColor,
      contrastMode: other.contrastMode ?? contrastMode,
      overlayColor: other.overlayColor ?? overlayColor,
      hoverOverlayOpacity: other.hoverOverlayOpacity ?? hoverOverlayOpacity,
      focusOverlayOpacity: other.focusOverlayOpacity ?? focusOverlayOpacity,
      pressOverlayOpacity: other.pressOverlayOpacity ?? pressOverlayOpacity,
      border: other.border ?? border,
      borderRadius: other.borderRadius ?? borderRadius,
      boxShadow: other.boxShadow ?? boxShadow,
      textStyle: other.textStyle ?? textStyle,
      padding: other.padding ?? padding,
      margin: other.margin ?? margin,
      alignment: other.alignment ?? alignment,
      width: other.width ?? width,
      height: other.height ?? height,
      minimumSize: other.minimumSize ?? minimumSize,
      maximumSize: other.maximumSize ?? maximumSize,
      minimumTapTargetSize: other.minimumTapTargetSize ?? minimumTapTargetSize,
      iconSize: other.iconSize ?? iconSize,
      iconSpacing: other.iconSpacing ?? iconSpacing,
      animationDuration: other.animationDuration ?? animationDuration,
      animationCurve: other.animationCurve ?? animationCurve,
      clipBehavior: other.clipBehavior ?? clipBehavior,
      progressColor: other.progressColor ?? progressColor,
      progressTrackColor: other.progressTrackColor ?? progressTrackColor,
      progressSize: other.progressSize ?? progressSize,
      progressThickness: other.progressThickness ?? progressThickness,
    );
  }

  /// 未传参数保留原值；显式传 null 时恢复该字段的继承行为。
  HyperButtonStyle copyWith({
    Object? background = _unchanged,
    Object? disabledBackground = _unchanged,
    Object? material = _unchanged,
    Object? foregroundColor = _unchanged,
    Object? disabledForegroundColor = _unchanged,
    Object? contrastMode = _unchanged,
    Object? overlayColor = _unchanged,
    Object? hoverOverlayOpacity = _unchanged,
    Object? focusOverlayOpacity = _unchanged,
    Object? pressOverlayOpacity = _unchanged,
    Object? border = _unchanged,
    Object? borderRadius = _unchanged,
    Object? boxShadow = _unchanged,
    Object? textStyle = _unchanged,
    Object? padding = _unchanged,
    Object? margin = _unchanged,
    Object? alignment = _unchanged,
    Object? width = _unchanged,
    Object? height = _unchanged,
    Object? minimumSize = _unchanged,
    Object? maximumSize = _unchanged,
    Object? minimumTapTargetSize = _unchanged,
    Object? iconSize = _unchanged,
    Object? iconSpacing = _unchanged,
    Object? animationDuration = _unchanged,
    Object? animationCurve = _unchanged,
    Object? clipBehavior = _unchanged,
    Object? progressColor = _unchanged,
    Object? progressTrackColor = _unchanged,
    Object? progressSize = _unchanged,
    Object? progressThickness = _unchanged,
  }) => HyperButtonStyle(
    background: identical(background, _unchanged)
        ? this.background
        : background as HyperFill?,
    disabledBackground: identical(disabledBackground, _unchanged)
        ? this.disabledBackground
        : disabledBackground as HyperFill?,
    material: identical(material, _unchanged)
        ? this.material
        : material as HyperSurfaceMaterial?,
    foregroundColor: identical(foregroundColor, _unchanged)
        ? this.foregroundColor
        : foregroundColor as Color?,
    disabledForegroundColor: identical(disabledForegroundColor, _unchanged)
        ? this.disabledForegroundColor
        : disabledForegroundColor as Color?,
    contrastMode: identical(contrastMode, _unchanged)
        ? this.contrastMode
        : contrastMode as HyperContrastMode?,
    overlayColor: identical(overlayColor, _unchanged)
        ? this.overlayColor
        : overlayColor as Color?,
    hoverOverlayOpacity: identical(hoverOverlayOpacity, _unchanged)
        ? this.hoverOverlayOpacity
        : hoverOverlayOpacity as double?,
    focusOverlayOpacity: identical(focusOverlayOpacity, _unchanged)
        ? this.focusOverlayOpacity
        : focusOverlayOpacity as double?,
    pressOverlayOpacity: identical(pressOverlayOpacity, _unchanged)
        ? this.pressOverlayOpacity
        : pressOverlayOpacity as double?,
    border: identical(border, _unchanged) ? this.border : border as BorderSide?,
    borderRadius: identical(borderRadius, _unchanged)
        ? this.borderRadius
        : borderRadius as BorderRadiusGeometry?,
    boxShadow: identical(boxShadow, _unchanged)
        ? this.boxShadow
        : boxShadow as List<BoxShadow>?,
    textStyle: identical(textStyle, _unchanged)
        ? this.textStyle
        : textStyle as TextStyle?,
    padding: identical(padding, _unchanged)
        ? this.padding
        : padding as EdgeInsetsGeometry?,
    margin: identical(margin, _unchanged)
        ? this.margin
        : margin as EdgeInsetsGeometry?,
    alignment: identical(alignment, _unchanged)
        ? this.alignment
        : alignment as AlignmentGeometry?,
    width: identical(width, _unchanged) ? this.width : width as double?,
    height: identical(height, _unchanged) ? this.height : height as double?,
    minimumSize: identical(minimumSize, _unchanged)
        ? this.minimumSize
        : minimumSize as Size?,
    maximumSize: identical(maximumSize, _unchanged)
        ? this.maximumSize
        : maximumSize as Size?,
    minimumTapTargetSize: identical(minimumTapTargetSize, _unchanged)
        ? this.minimumTapTargetSize
        : minimumTapTargetSize as Size?,
    iconSize: identical(iconSize, _unchanged)
        ? this.iconSize
        : iconSize as double?,
    iconSpacing: identical(iconSpacing, _unchanged)
        ? this.iconSpacing
        : iconSpacing as double?,
    animationDuration: identical(animationDuration, _unchanged)
        ? this.animationDuration
        : animationDuration as Duration?,
    animationCurve: identical(animationCurve, _unchanged)
        ? this.animationCurve
        : animationCurve as Curve?,
    clipBehavior: identical(clipBehavior, _unchanged)
        ? this.clipBehavior
        : clipBehavior as Clip?,
    progressColor: identical(progressColor, _unchanged)
        ? this.progressColor
        : progressColor as Color?,
    progressTrackColor: identical(progressTrackColor, _unchanged)
        ? this.progressTrackColor
        : progressTrackColor as Color?,
    progressSize: identical(progressSize, _unchanged)
        ? this.progressSize
        : progressSize as double?,
    progressThickness: identical(progressThickness, _unchanged)
        ? this.progressThickness
        : progressThickness as double?,
  );

  static HyperButtonStyle lerp(
    HyperButtonStyle a,
    HyperButtonStyle b,
    double t,
  ) {
    if (t == 0) return a;
    if (t == 1) return b;
    T? blend<T>(T? x, T? y, T Function(T, T, double) lerp) {
      if (x == null || y == null) return t < .5 ? x : y;
      return lerp(x, y, t);
    }

    double? number(double? x, double? y) =>
        blend(x, y, (a, b, t) => a + (b - a) * t);
    return HyperButtonStyle(
      background: blend(a.background, b.background, HyperFill.lerp),
      disabledBackground: blend(
        a.disabledBackground,
        b.disabledBackground,
        HyperFill.lerp,
      ),
      material: blend(a.material, b.material, HyperSurfaceMaterial.lerp),
      foregroundColor: Color.lerp(a.foregroundColor, b.foregroundColor, t),
      disabledForegroundColor: Color.lerp(
        a.disabledForegroundColor,
        b.disabledForegroundColor,
        t,
      ),
      contrastMode: t < .5 ? a.contrastMode : b.contrastMode,
      overlayColor: Color.lerp(a.overlayColor, b.overlayColor, t),
      hoverOverlayOpacity: number(a.hoverOverlayOpacity, b.hoverOverlayOpacity),
      focusOverlayOpacity: number(a.focusOverlayOpacity, b.focusOverlayOpacity),
      pressOverlayOpacity: number(a.pressOverlayOpacity, b.pressOverlayOpacity),
      border: blend(a.border, b.border, BorderSide.lerp),
      borderRadius: BorderRadiusGeometry.lerp(
        a.borderRadius,
        b.borderRadius,
        t,
      ),
      boxShadow: blend(
        a.boxShadow,
        b.boxShadow,
        (a, b, t) => BoxShadow.lerpList(a, b, t)!,
      ),
      textStyle: TextStyle.lerp(a.textStyle, b.textStyle, t),
      padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t),
      margin: EdgeInsetsGeometry.lerp(a.margin, b.margin, t),
      alignment: AlignmentGeometry.lerp(a.alignment, b.alignment, t),
      width: number(a.width, b.width),
      height: number(a.height, b.height),
      minimumSize: Size.lerp(a.minimumSize, b.minimumSize, t),
      maximumSize: Size.lerp(a.maximumSize, b.maximumSize, t),
      minimumTapTargetSize: Size.lerp(
        a.minimumTapTargetSize,
        b.minimumTapTargetSize,
        t,
      ),
      iconSize: number(a.iconSize, b.iconSize),
      iconSpacing: number(a.iconSpacing, b.iconSpacing),
      animationDuration: blend(
        a.animationDuration,
        b.animationDuration,
        (a, b, t) => Duration(
          microseconds:
              (a.inMicroseconds + (b.inMicroseconds - a.inMicroseconds) * t)
                  .round(),
        ),
      ),
      animationCurve: t < .5 ? a.animationCurve : b.animationCurve,
      clipBehavior: t < .5 ? a.clipBehavior : b.clipBehavior,
      progressColor: Color.lerp(a.progressColor, b.progressColor, t),
      progressTrackColor: Color.lerp(
        a.progressTrackColor,
        b.progressTrackColor,
        t,
      ),
      progressSize: number(a.progressSize, b.progressSize),
      progressThickness: number(a.progressThickness, b.progressThickness),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperButtonStyle &&
          other.background == background &&
          other.disabledBackground == disabledBackground &&
          other.material == material &&
          other.foregroundColor == foregroundColor &&
          other.disabledForegroundColor == disabledForegroundColor &&
          other.contrastMode == contrastMode &&
          other.overlayColor == overlayColor &&
          other.hoverOverlayOpacity == hoverOverlayOpacity &&
          other.focusOverlayOpacity == focusOverlayOpacity &&
          other.pressOverlayOpacity == pressOverlayOpacity &&
          other.border == border &&
          other.borderRadius == borderRadius &&
          listEquals(other.boxShadow, boxShadow) &&
          other.textStyle == textStyle &&
          other.padding == padding &&
          other.margin == margin &&
          other.alignment == alignment &&
          other.width == width &&
          other.height == height &&
          other.minimumSize == minimumSize &&
          other.maximumSize == maximumSize &&
          other.minimumTapTargetSize == minimumTapTargetSize &&
          other.iconSize == iconSize &&
          other.iconSpacing == iconSpacing &&
          other.animationDuration == animationDuration &&
          other.animationCurve == animationCurve &&
          other.clipBehavior == clipBehavior &&
          other.progressColor == progressColor &&
          other.progressTrackColor == progressTrackColor &&
          other.progressSize == progressSize &&
          other.progressThickness == progressThickness;

  @override
  int get hashCode => Object.hashAll([
    background,
    disabledBackground,
    material,
    foregroundColor,
    disabledForegroundColor,
    contrastMode,
    overlayColor,
    hoverOverlayOpacity,
    focusOverlayOpacity,
    pressOverlayOpacity,
    border,
    borderRadius,
    Object.hashAll(boxShadow ?? const []),
    textStyle,
    padding,
    margin,
    alignment,
    width,
    height,
    minimumSize,
    maximumSize,
    minimumTapTargetSize,
    iconSize,
    iconSpacing,
    animationDuration,
    animationCurve,
    clipBehavior,
    progressColor,
    progressTrackColor,
    progressSize,
    progressThickness,
  ]);
}
