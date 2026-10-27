import 'hyper_scrolling_text.dart';

import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_text_style.dart';
import 'hyper_text_theme.dart';

/// 配色语义，与文字字阶分开配置。
enum HyperTextTone { normal, muted }

/// 使用 Hyper 语义字号和系统字体的基础文字控件。
///
/// 普通构造直接返回 Flutter [Text]；[HyperText.scrolling] 提供单行溢出滚动。最终样式优先级为：
/// 实例 [style]、语义层级主题、文字公共主题、全局 [TextTheme]。
class HyperText extends StatelessWidget {
  const HyperText(
    this.data, {
    super.key,
    this.variant = HyperTextVariant.body,
    this.tone = HyperTextTone.normal,
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
  }) : _scrollTrigger = null,
       _scrollMode = HyperTextScrollMode.pingPong,
       _scrollDuration = null,
       _scrollSpeed = 40,
       _pauseDuration = null,
       _loopGap = null,
       _scrollCurve = Curves.linear;

  /// 使用 displayLarge 字阶的简写。
  const HyperText.displayLarge(
    String data, {
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) : this(
         data,
         variant: HyperTextVariant.displayLarge,
         key: key,
         style: style,
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

  /// 使用 displayMedium 字阶的简写。
  const HyperText.displayMedium(
    String data, {
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) : this(
         data,
         variant: HyperTextVariant.displayMedium,
         key: key,
         style: style,
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

  /// 使用 displaySmall 字阶的简写。
  const HyperText.displaySmall(
    String data, {
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) : this(
         data,
         variant: HyperTextVariant.displaySmall,
         key: key,
         style: style,
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

  /// 使用 pageTitle 字阶的简写。
  const HyperText.pageTitle(
    String data, {
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) : this(
         data,
         variant: HyperTextVariant.pageTitle,
         key: key,
         style: style,
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

  /// 使用 sectionTitle 字阶的简写。
  const HyperText.sectionTitle(
    String data, {
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) : this(
         data,
         variant: HyperTextVariant.sectionTitle,
         key: key,
         style: style,
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

  /// 使用 subsectionTitle 字阶的简写。
  const HyperText.subsectionTitle(
    String data, {
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) : this(
         data,
         variant: HyperTextVariant.subsectionTitle,
         key: key,
         style: style,
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

  /// 使用 bodyLarge 字阶的简写。
  const HyperText.bodyLarge(
    String data, {
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) : this(
         data,
         variant: HyperTextVariant.bodyLarge,
         key: key,
         style: style,
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

  /// 使用 bodySmall 字阶的简写。
  const HyperText.bodySmall(
    String data, {
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) : this(
         data,
         variant: HyperTextVariant.bodySmall,
         key: key,
         style: style,
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

  /// 使用 control 字阶的简写。
  const HyperText.control(
    String data, {
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) : this(
         data,
         variant: HyperTextVariant.control,
         key: key,
         style: style,
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

  /// 使用 label 字阶的简写。
  const HyperText.label(
    String data, {
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) : this(
         data,
         variant: HyperTextVariant.label,
         key: key,
         style: style,
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

  /// 使用 body 字阶的简写。
  const HyperText.body(
    String data, {
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) : this(
         data,
         variant: HyperTextVariant.body,
         tone: HyperTextTone.normal,
         key: key,
         style: style,
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

  /// 使用 caption 字阶的简写。
  const HyperText.caption(
    String data, {
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) : this(
         data,
         variant: HyperTextVariant.caption,
         tone: HyperTextTone.normal,
         key: key,
         style: style,
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

  /// 分区标题，等价于 sectionTitle 字阶。
  const HyperText.title(
    String data, {
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) : this(
         data,
         variant: HyperTextVariant.sectionTitle,
         tone: HyperTextTone.normal,
         key: key,
         style: style,
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

  /// 正文的次要配色；局部主题和实例 style 仍优先。
  const HyperText.muted(
    String data, {
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) : this(
         data,
         variant: HyperTextVariant.body,
         tone: HyperTextTone.muted,
         key: key,
         style: style,
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

  /// 单行溢出滚动；支持往返、跑马灯以及自动或悬停触发。
  const HyperText.scrolling(
    this.data, {
    super.key,
    this.variant = HyperTextVariant.body,
    this.tone = HyperTextTone.normal,
    this.style,
    this.semanticsLabel,
    HyperTextScrollTrigger trigger = HyperTextScrollTrigger.automatic,
    HyperTextScrollMode mode = HyperTextScrollMode.pingPong,
    Duration? duration,
    double speed = 40,
    Duration? pauseDuration,
    double? loopGap,
    Curve curve = Curves.linear,
  }) : assert(loopGap == null || loopGap >= 0),
       assert(speed > 0 && speed < double.infinity),
       _scrollTrigger = trigger,
       _scrollMode = mode,
       _scrollDuration = duration,
       _scrollSpeed = speed,
       // Public constructor name is kept independent of private storage.
       // ignore: prefer_initializing_formals
       _pauseDuration = pauseDuration,
       _loopGap = loopGap,
       _scrollCurve = curve,
       strutStyle = null,
       textAlign = null,
       textDirection = null,
       locale = null,
       softWrap = false,
       overflow = TextOverflow.clip,
       textScaler = null,
       maxLines = 1,
       textWidthBasis = null,
       textHeightBehavior = null,
       selectionColor = null;

  final HyperTextScrollTrigger? _scrollTrigger;
  final HyperTextScrollMode _scrollMode;
  final Duration? _scrollDuration, _pauseDuration;
  final double? _loopGap;
  final double _scrollSpeed;
  final Curve _scrollCurve;

  /// 显示的纯文本内容。
  final String data;

  /// 当前文字使用的语义层级，默认是正文。
  final HyperTextVariant variant;

  /// muted 默认使用主题 textSecondary，显式主题或实例颜色可覆盖。
  final HyperTextTone tone;

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
    final componentStyle = HyperTextTheme.of(context).resolve(variant);
    final toneStyle = tone == HyperTextTone.muted
        ? TextStyle(color: theme.colors.textSecondary)
        : null;
    if (_scrollTrigger != null) {
      return HyperScrollingText(
        data,
        variant: variant,
        style: toneStyle == null
            ? style
            : toneStyle.merge(componentStyle).merge(style),
        semanticsLabel: semanticsLabel,
        trigger: _scrollTrigger,
        mode: _scrollMode,
        duration: _scrollDuration,
        speed: _scrollSpeed,
        pauseDuration: _pauseDuration,
        loopGap: _loopGap,
        curve: _scrollCurve,
      );
    }
    // 默认正文服从父级文字环境，使按钮、列表项等容器能够统一控制排版。
    // 显式语义层级仍从 Hyper 主题读取完整样式，不受普通正文环境覆盖。
    final baseStyle = variant == HyperTextVariant.body
        ? DefaultTextStyle.of(context).style
        : variant.resolve(theme.textTheme) ?? const TextStyle();
    final resolvedStyle = baseStyle
        .merge(toneStyle)
        .merge(componentStyle)
        .merge(style);

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
