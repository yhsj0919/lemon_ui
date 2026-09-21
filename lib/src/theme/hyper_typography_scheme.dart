import 'package:flutter/material.dart';

/// Hyper 界面的语义字号规范。
///
/// 所有值均为 Flutter 逻辑像素，是明确字号而不是倍率。修改某一级不会按比例
/// 改动其他级别，控件应按使用场景读取对应语义。
@immutable
final class HyperTypographyScheme {
  const HyperTypographyScheme({
    this.displayLarge = 48,
    this.displayMedium = 40,
    this.displaySmall = 36,
    this.pageTitle = 32,
    this.sectionTitle = 24,
    this.subsectionTitle = 20,
    this.bodyLarge = 18,
    this.body = 16,
    this.bodySmall = 14,
    this.control = 16,
    this.label = 14,
    this.caption = 12,
  });

  /// 最大展示标题字号。
  final double displayLarge;

  /// 中等展示标题字号。
  final double displayMedium;

  /// 最小展示标题字号。
  final double displaySmall;

  /// 页面主标题字号。
  final double pageTitle;

  /// 页面分区标题字号。
  final double sectionTitle;

  /// 次级分区标题字号。
  final double subsectionTitle;

  /// 强调正文或导语字号。
  final double bodyLarge;

  /// 默认正文字号。
  final double body;

  /// 辅助正文字号。
  final double bodySmall;

  /// 按钮和输入控件字号。
  final double control;

  /// 标签字号。
  final double label;

  /// 说明和注释字号。
  final double caption;

  HyperTypographyScheme copyWith({
    double? displayLarge,
    double? displayMedium,
    double? displaySmall,
    double? pageTitle,
    double? sectionTitle,
    double? subsectionTitle,
    double? bodyLarge,
    double? body,
    double? bodySmall,
    double? control,
    double? label,
    double? caption,
  }) => HyperTypographyScheme(
    displayLarge: displayLarge ?? this.displayLarge,
    displayMedium: displayMedium ?? this.displayMedium,
    displaySmall: displaySmall ?? this.displaySmall,
    pageTitle: pageTitle ?? this.pageTitle,
    sectionTitle: sectionTitle ?? this.sectionTitle,
    subsectionTitle: subsectionTitle ?? this.subsectionTitle,
    bodyLarge: bodyLarge ?? this.bodyLarge,
    body: body ?? this.body,
    bodySmall: bodySmall ?? this.bodySmall,
    control: control ?? this.control,
    label: label ?? this.label,
    caption: caption ?? this.caption,
  );

  /// 将语义字号应用到系统字体生成的 [TextTheme]。
  TextTheme applyTo(TextTheme base) => base.copyWith(
    displayLarge: base.displayLarge?.copyWith(fontSize: displayLarge),
    displayMedium: base.displayMedium?.copyWith(fontSize: displayMedium),
    displaySmall: base.displaySmall?.copyWith(fontSize: displaySmall),
    headlineLarge: base.headlineLarge?.copyWith(fontSize: pageTitle),
    headlineMedium: base.headlineMedium?.copyWith(fontSize: sectionTitle),
    headlineSmall: base.headlineSmall?.copyWith(fontSize: subsectionTitle),
    titleLarge: base.titleLarge?.copyWith(fontSize: subsectionTitle),
    titleMedium: base.titleMedium?.copyWith(fontSize: body),
    titleSmall: base.titleSmall?.copyWith(fontSize: bodySmall),
    bodyLarge: base.bodyLarge?.copyWith(fontSize: bodyLarge),
    bodyMedium: base.bodyMedium?.copyWith(fontSize: body),
    bodySmall: base.bodySmall?.copyWith(fontSize: bodySmall),
    labelLarge: base.labelLarge?.copyWith(fontSize: control),
    labelMedium: base.labelMedium?.copyWith(fontSize: label),
    labelSmall: base.labelSmall?.copyWith(fontSize: caption),
  );

  static HyperTypographyScheme lerp(
    HyperTypographyScheme a,
    HyperTypographyScheme b,
    double t,
  ) {
    if (t == 0) return a;
    if (t == 1) return b;
    double value(double x, double y) => x + (y - x) * t;
    return HyperTypographyScheme(
      displayLarge: value(a.displayLarge, b.displayLarge),
      displayMedium: value(a.displayMedium, b.displayMedium),
      displaySmall: value(a.displaySmall, b.displaySmall),
      pageTitle: value(a.pageTitle, b.pageTitle),
      sectionTitle: value(a.sectionTitle, b.sectionTitle),
      subsectionTitle: value(a.subsectionTitle, b.subsectionTitle),
      bodyLarge: value(a.bodyLarge, b.bodyLarge),
      body: value(a.body, b.body),
      bodySmall: value(a.bodySmall, b.bodySmall),
      control: value(a.control, b.control),
      label: value(a.label, b.label),
      caption: value(a.caption, b.caption),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperTypographyScheme &&
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
