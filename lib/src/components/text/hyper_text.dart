import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_text_style.dart';
import 'hyper_text_theme.dart';

/// 使用 Hyper 语义字号和系统字体的基础文字控件。
///
/// 控件直接返回 Flutter [Text]，不会增加布局、缩放或动画包装。最终样式优先级为：
/// 实例 [style]、语义层级主题、文字公共主题、全局 [TextTheme]。
class HyperText extends StatelessWidget {
  const HyperText(
    this.data, {
    super.key,
    this.variant = HyperTextVariant.body,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaler,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
    this.selectionColor,
  });

  /// 显示的纯文本内容。
  final String data;

  /// 当前文字使用的语义层级，默认是正文。
  final HyperTextVariant variant;

  /// 当前实例样式，最后合并并具有最高优先级。
  final TextStyle? style;

  /// 控制多行文字基线和行高的支柱样式。
  final StrutStyle? strutStyle;

  /// 文字水平对齐方式。
  final TextAlign? textAlign;

  /// 明确指定文字方向；null 时继承当前方向环境。
  final TextDirection? textDirection;

  /// 用于字形选择的地区信息。
  final Locale? locale;

  /// 是否允许文字自动换行。
  final bool? softWrap;

  /// 文字超出可用空间时的处理方式。
  final TextOverflow? overflow;

  /// 显式文字缩放策略；null 时使用系统无障碍文字缩放。
  final TextScaler? textScaler;

  /// 最大显示行数；null 表示不主动限制。
  final int? maxLines;

  /// 屏幕阅读器使用的替代文本。
  final String? semanticsLabel;

  /// 测量多行文字宽度时使用的基准。
  final TextWidthBasis? textWidthBasis;

  /// 控制首行和末行高度的行为。
  final TextHeightBehavior? textHeightBehavior;

  /// 文字被选择时使用的背景色。
  final Color? selectionColor;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    // 默认正文服从父级文字环境，使按钮、列表项等容器能够统一控制排版。
    // 显式语义层级仍从 Hyper 主题读取完整样式，不受普通正文环境覆盖。
    final baseStyle = variant == HyperTextVariant.body
        ? DefaultTextStyle.of(context).style
        : variant.resolve(theme.textTheme) ?? const TextStyle();
    final componentStyle = HyperTextTheme.of(context).resolve(variant);
    final resolvedStyle = baseStyle.merge(componentStyle).merge(style);

    return Text(
      data,
      style: resolvedStyle,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}
