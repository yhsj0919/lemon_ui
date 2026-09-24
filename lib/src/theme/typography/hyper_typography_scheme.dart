import 'package:flutter/material.dart';

/// Hyper 界面的集中式语义字号规范。
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
    this.listTitle = 17,
    this.listSubtitle = 14,
    this.listTitleLineHeight = 1.25,
    this.listSubtitleLineHeight = 1.25,
    this.cardTitle = 18,
    this.label = 14,
    this.caption = 12,
  });

  /// HIUI 桌面字阶：32/24/18/16/14/12，按明确语义映射。
  const HyperTypographyScheme.desktop()
    : displayLarge = 32,
      displayMedium = 24,
      displaySmall = 18,
      pageTitle = 32,
      sectionTitle = 24,
      subsectionTitle = 18,
      bodyLarge = 16,
      body = 14,
      bodySmall = 12,
      control = 14,
      listTitle = 14,
      listSubtitle = 12,
      listTitleLineHeight = 22 / 14,
      listSubtitleLineHeight = 20 / 12,
      cardTitle = 14,
      label = 12,
      caption = 12;

  /// 手表列表采用独立字阶，其余角色沿用当前移动端基准。
  const HyperTypographyScheme.watch()
    : displayLarge = 48,
      displayMedium = 40,
      displaySmall = 36,
      pageTitle = 32,
      sectionTitle = 24,
      subsectionTitle = 20,
      bodyLarge = 18,
      body = 16,
      bodySmall = 14,
      control = 16,
      listTitle = 16,
      listSubtitle = 13,
      listTitleLineHeight = 1.25,
      listSubtitleLineHeight = 1.25,
      cardTitle = 18,
      label = 14,
      caption = 12;

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

  /// 列表和侧栏主文案。
  final double listTitle;

  /// 列表和侧栏说明文案。
  final double listSubtitle;

  /// 列表主文案的行高倍率。
  final double listTitleLineHeight;

  /// 列表说明文案的行高倍率。
  final double listSubtitleLineHeight;

  /// 卡片内部标题；与卡片外部分组标签分别解析。
  final double cardTitle;

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
    double? listTitle,
    double? listSubtitle,
    double? listTitleLineHeight,
    double? listSubtitleLineHeight,
    double? cardTitle,
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
    listTitle: listTitle ?? this.listTitle,
    listSubtitle: listSubtitle ?? this.listSubtitle,
    listTitleLineHeight: listTitleLineHeight ?? this.listTitleLineHeight,
    listSubtitleLineHeight:
        listSubtitleLineHeight ?? this.listSubtitleLineHeight,
    cardTitle: cardTitle ?? this.cardTitle,
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
      listTitle: value(a.listTitle, b.listTitle),
      listSubtitle: value(a.listSubtitle, b.listSubtitle),
      listTitleLineHeight: value(a.listTitleLineHeight, b.listTitleLineHeight),
      listSubtitleLineHeight: value(
        a.listSubtitleLineHeight,
        b.listSubtitleLineHeight,
      ),
      cardTitle: value(a.cardTitle, b.cardTitle),
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
          other.listTitle == listTitle &&
          other.listSubtitle == listSubtitle &&
          other.listTitleLineHeight == listTitleLineHeight &&
          other.listSubtitleLineHeight == listSubtitleLineHeight &&
          other.cardTitle == cardTitle &&
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
    listTitle,
    listSubtitle,
    listTitleLineHeight,
    listSubtitleLineHeight,
    cardTitle,
    label,
    caption,
  ]);
}
