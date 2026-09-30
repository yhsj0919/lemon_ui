import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_badge_style.dart';
import 'hyper_badge_theme.dart';

/// 点、数量或短文本徽标。未提供内容时绘制一个点。
class HyperBadge extends StatelessWidget {
  const HyperBadge({
    super.key,
    this.count,
    this.label,
    this.content,
    this.maxCount = 99,
    this.showZero = false,
    this.visible = true,
    this.semanticsLabel,
    this.style,
  }) : assert(maxCount > 0),
       assert(count == null || count >= 0),
       assert(
         (count == null || label == null) &&
             (count == null || content == null) &&
             (label == null || content == null),
       );

  /// 数字徽标。最多显示两位数字，超过 99 时显示 99+。
  const HyperBadge.number({
    super.key,
    required int count,
    this.showZero = false,
    this.visible = true,
    this.semanticsLabel,
    this.style,
  }) : assert(count >= 0),
       count = count,
       label = null,
       content = null,
       maxCount = 99;

  final int? count;
  final String? label;
  final Widget? content;
  final int maxCount;
  final bool showZero;
  final bool visible;
  final String? semanticsLabel;
  final HyperBadgeStyle? style;

  static Widget _defaultTransition(Widget child, Animation<double> animation) =>
      FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: .85, end: 1).animate(animation),
          child: child,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).badge;
    final badgeTheme = HyperBadgeTheme.of(context);
    final resolved = badgeTheme.style.merge(style);
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = reduceMotion
        ? Duration.zero
        : (resolved.duration ?? theme.motion.fastDuration);
    final curve = resolved.curve ?? theme.motion.fastCurve;
    final text = count == null
        ? label
        : count! > maxCount
        ? '$maxCount+'
        : '$count';
    final show = visible && (count == null || count! != 0 || showZero);
    final dot = text == null && content == null;
    final dotSize = resolved.dotSize ?? metrics.dotSize;
    final height = resolved.contentHeight ?? metrics.contentHeight;
    final badgeBackground =
        resolved.backgroundColor ??
        badgeTheme.backgroundColorFor(theme.brightness);
    final foreground =
        resolved.foregroundColor ??
        badgeTheme.defaultForegroundColor ??
        Colors.white;
    final textStyle = (theme.textTheme.labelSmall ?? const TextStyle())
        .copyWith(
          fontSize: metrics.textSize,
          height: 1,
          leadingDistribution: TextLeadingDistribution.even,
        )
        .merge(resolved.textStyle)
        .copyWith(color: foreground);
    final badgeContent =
        content ??
        Text(
          text ?? '',
          style: textStyle,
          textAlign: TextAlign.center,
          maxLines: 1,
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        );
    final badge = AnimatedContainer(
      key: ValueKey(
        dot
            ? 'dot'
            : content == null
            ? 'text:$text'
            : 'content',
      ),
      duration: duration,
      curve: curve,
      width: dot ? dotSize : null,
      height: dot ? dotSize : height,
      constraints: dot ? null : BoxConstraints(minWidth: height),
      padding: dot
          ? EdgeInsets.zero
          : EdgeInsets.symmetric(
              horizontal:
                  resolved.horizontalPadding ?? metrics.horizontalPadding,
            ),
      decoration: BoxDecoration(
        color: badgeBackground,
        borderRadius: BorderRadius.circular(
          dot
              ? (resolved.dotRadius ?? metrics.dotRadius)
              : (resolved.contentRadius ?? metrics.contentRadius),
        ),
        border: (resolved.borderWidth ?? 0) > 0
            ? Border.all(
                color: resolved.borderColor ?? theme.colors.outline,
                width: resolved.borderWidth!,
              )
            : null,
        boxShadow: resolved.boxShadow,
      ),
      child: dot
          ? null
          : Center(
              widthFactor: 1,
              child: DefaultTextStyle.merge(
                style: textStyle,
                child: IconTheme.merge(
                  data: IconThemeData(color: foreground),
                  child: badgeContent,
                ),
              ),
            ),
    );
    final animated = AnimatedSize(
      duration: duration,
      curve: curve,
      alignment: Alignment.center,
      child: AnimatedSwitcher(
        duration: duration,
        switchInCurve: curve,
        switchOutCurve: curve,
        transitionBuilder: resolved.transitionBuilder ?? _defaultTransition,
        child: show ? badge : const SizedBox.shrink(key: ValueKey('hidden')),
      ),
    );
    final semanticText = show ? (semanticsLabel ?? text) : null;
    return semanticText == null
        ? animated
        : Semantics(
            label: semanticText,
            child: ExcludeSemantics(child: animated),
          );
  }
}
