import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_text_style.dart';

/// HyperText 的全局或局部主题。
///
/// [style] 先作用于全部文字，再叠加对应语义层级样式。实例传入的
/// `TextStyle` 始终最后合并。
@immutable
final class HyperTextThemeData {
  const HyperTextThemeData({
    this.style,
    this.displayLarge,
    this.displayMedium,
    this.displaySmall,
    this.pageTitle,
    this.sectionTitle,
    this.subsectionTitle,
    this.bodyLarge,
    this.body,
    this.bodySmall,
    this.control,
    this.label,
    this.caption,
  });

  /// 所有 HyperText 共用的样式覆盖。
  final TextStyle? style;

  /// 超大展示文字样式。
  final TextStyle? displayLarge;

  /// 大展示文字样式。
  final TextStyle? displayMedium;

  /// 小展示文字样式。
  final TextStyle? displaySmall;

  /// 页面主标题样式。
  final TextStyle? pageTitle;

  /// 页面分区标题样式。
  final TextStyle? sectionTitle;

  /// 次级分区标题样式。
  final TextStyle? subsectionTitle;

  /// 强调正文样式。
  final TextStyle? bodyLarge;

  /// 默认正文样式。
  final TextStyle? body;

  /// 辅助正文样式。
  final TextStyle? bodySmall;

  /// 按钮和输入控件文字样式。
  final TextStyle? control;

  /// 标签文字样式。
  final TextStyle? label;

  /// 说明和注释文字样式。
  final TextStyle? caption;

  /// 合并公共样式和指定语义层级样式。
  TextStyle? resolve(HyperTextVariant variant) {
    final variantStyle = switch (variant) {
      HyperTextVariant.displayLarge => displayLarge,
      HyperTextVariant.displayMedium => displayMedium,
      HyperTextVariant.displaySmall => displaySmall,
      HyperTextVariant.pageTitle => pageTitle,
      HyperTextVariant.sectionTitle => sectionTitle,
      HyperTextVariant.subsectionTitle => subsectionTitle,
      HyperTextVariant.bodyLarge => bodyLarge,
      HyperTextVariant.body => body,
      HyperTextVariant.bodySmall => bodySmall,
      HyperTextVariant.control => control,
      HyperTextVariant.label => label,
      HyperTextVariant.caption => caption,
    };
    return style?.merge(variantStyle) ?? variantStyle;
  }

  static HyperTextThemeData lerp(
    HyperTextThemeData a,
    HyperTextThemeData b,
    double t,
  ) => HyperTextThemeData(
    style: TextStyle.lerp(a.style, b.style, t),
    displayLarge: TextStyle.lerp(a.displayLarge, b.displayLarge, t),
    displayMedium: TextStyle.lerp(a.displayMedium, b.displayMedium, t),
    displaySmall: TextStyle.lerp(a.displaySmall, b.displaySmall, t),
    pageTitle: TextStyle.lerp(a.pageTitle, b.pageTitle, t),
    sectionTitle: TextStyle.lerp(a.sectionTitle, b.sectionTitle, t),
    subsectionTitle: TextStyle.lerp(a.subsectionTitle, b.subsectionTitle, t),
    bodyLarge: TextStyle.lerp(a.bodyLarge, b.bodyLarge, t),
    body: TextStyle.lerp(a.body, b.body, t),
    bodySmall: TextStyle.lerp(a.bodySmall, b.bodySmall, t),
    control: TextStyle.lerp(a.control, b.control, t),
    label: TextStyle.lerp(a.label, b.label, t),
    caption: TextStyle.lerp(a.caption, b.caption, t),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperTextThemeData &&
          other.style == style &&
          other.displayLarge == displayLarge &&
          other.displayMedium == displayMedium &&
          other.displaySmall == displaySmall &&
          other.pageTitle == pageTitle &&
          other.sectionTitle == sectionTitle &&
          other.subsectionTitle == subsectionTitle &&
          other.bodyLarge == bodyLarge &&
          other.body == body &&
          other.bodySmall == bodySmall &&
          other.control == control &&
          other.label == label &&
          other.caption == caption;

  @override
  int get hashCode => Object.hashAll([
    style,
    displayLarge,
    displayMedium,
    displaySmall,
    pageTitle,
    sectionTitle,
    subsectionTitle,
    bodyLarge,
    body,
    bodySmall,
    control,
    label,
    caption,
  ]);
}

/// 为子树单独覆盖 HyperText 主题。
class HyperTextTheme extends InheritedTheme {
  const HyperTextTheme({super.key, required this.data, required super.child});

  /// 当前子树的文字主题。
  final HyperTextThemeData data;

  static HyperTextThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<HyperTextTheme>()?.data ??
      HyperTheme.of(context).textComponentTheme;

  @override
  bool updateShouldNotify(HyperTextTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      HyperTextTheme(data: data, child: child);
}
