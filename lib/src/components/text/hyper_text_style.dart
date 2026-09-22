import 'package:flutter/material.dart';

/// HyperText 使用的语义文字层级。
enum HyperTextVariant {
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
}

/// 返回语义层级在 Flutter [TextTheme] 中对应的基础样式。
extension HyperTextVariantTextTheme on HyperTextVariant {
  TextStyle? resolve(TextTheme theme) => switch (this) {
    HyperTextVariant.displayLarge => theme.displayLarge,
    HyperTextVariant.displayMedium => theme.displayMedium,
    HyperTextVariant.displaySmall => theme.displaySmall,
    HyperTextVariant.pageTitle => theme.headlineLarge,
    HyperTextVariant.sectionTitle => theme.headlineMedium,
    HyperTextVariant.subsectionTitle => theme.headlineSmall,
    HyperTextVariant.bodyLarge => theme.bodyLarge,
    HyperTextVariant.body => theme.bodyMedium,
    HyperTextVariant.bodySmall => theme.bodySmall,
    HyperTextVariant.control => theme.labelLarge,
    HyperTextVariant.label => theme.labelMedium,
    HyperTextVariant.caption => theme.labelSmall,
  };
}
