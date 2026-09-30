import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../theme/core/hyper_theme.dart';
import 'hyper_empty_state_style.dart';
import 'hyper_empty_state_theme.dart';

/// 空内容展示；不管理加载、重试和业务状态。
class HyperEmptyState extends StatelessWidget {
  const HyperEmptyState({
    super.key,
    this.title = '暂无内容',
    this.description,
    this.icon,
    this.illustration,
    this.showIllustration = true,
    this.titleWidget,
    this.descriptionWidget,
    this.content,
    this.actions = const [],
    this.style,
  });
  final String? title, description;
  final IconData? icon;

  /// 自定义插图优先于默认图标；按主题尺寸约束并保持内容比例。
  final Widget? illustration;
  final bool showIllustration;
  final Widget? titleWidget, descriptionWidget, content;
  final List<Widget> actions;
  final HyperEmptyStateStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context).emptyState;
    final resolved = HyperEmptyStateStyle(
      icon: Icons.inbox_outlined,
      iconColor: theme.colors.textTertiary,
      iconSize: sizes.iconSize,
      illustrationSize: sizes.illustrationSize,
      maxWidth: sizes.maxWidth,
      contentSpacing: sizes.contentSpacing,
      titleSpacing: sizes.titleSpacing,
      actionSpacing: sizes.actionSpacing,
      actionRunSpacing: sizes.actionRunSpacing,
      padding: sizes.padding,
      background: const HyperFill.none(),
      borderRadius: BorderRadius.zero,
      titleStyle: theme.textTheme.titleMedium?.copyWith(
        color: theme.colors.textPrimary,
      ),
      descriptionStyle: theme.textTheme.bodySmall?.copyWith(
        color: theme.colors.textSecondary,
      ),
      textAlign: TextAlign.center,
      actionAlignment: WrapAlignment.center,
      alignment: Alignment.center,
      duration: theme.motion.standardDuration,
      curve: theme.motion.standardCurve,
    ).merge(HyperEmptyStateTheme.of(context).style).merge(style);
    final duration = (MediaQuery.maybeOf(context)?.disableAnimations ?? false)
        ? Duration.zero
        : resolved.duration!;
    Widget transition(Widget child, Object key) => AnimatedSwitcher(
      duration: duration,
      switchInCurve: resolved.curve!,
      switchOutCurve: resolved.curve!,
      transitionBuilder:
          resolved.transitionBuilder ??
          AnimatedSwitcher.defaultTransitionBuilder,
      child: KeyedSubtree(key: ValueKey(key), child: child),
    );
    Widget textContent(Widget? custom, String? text, TextStyle? textStyle) =>
        DefaultTextStyle(
          style: textStyle ?? const TextStyle(),
          textAlign: resolved.textAlign,
          child: custom ?? Text(text!, textAlign: resolved.textAlign),
        );
    final hasTitle =
        titleWidget != null || (title != null && title!.isNotEmpty);
    final hasDescription =
        descriptionWidget != null ||
        (description != null && description!.isNotEmpty);
    final blocks = <Widget>[];
    if (showIllustration) {
      blocks.add(
        ExcludeSemantics(
          child: transition(
            SizedBox.square(
              dimension: resolved.illustrationSize,
              child: illustration == null
                  ? Center(
                      child: Icon(
                        icon ?? resolved.icon,
                        size: resolved.iconSize,
                        color: resolved.iconColor,
                      ),
                    )
                  : IconTheme.merge(
                      data: IconThemeData(
                        color: resolved.iconColor,
                        size: resolved.iconSize,
                      ),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: illustration,
                      ),
                    ),
            ),
            illustration?.key ??
                illustration?.runtimeType ??
                icon ??
                resolved.icon!,
          ),
        ),
      );
    }
    if (hasTitle || hasDescription) {
      blocks.add(
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasTitle)
              transition(
                textContent(titleWidget, title, resolved.titleStyle),
                titleWidget?.key ?? titleWidget?.runtimeType ?? title!,
              ),
            if (hasTitle && hasDescription)
              SizedBox(height: resolved.titleSpacing),
            if (hasDescription)
              transition(
                textContent(
                  descriptionWidget,
                  description,
                  resolved.descriptionStyle,
                ),
                descriptionWidget?.key ??
                    descriptionWidget?.runtimeType ??
                    description!,
              ),
          ],
        ),
      );
    }
    if (content != null) blocks.add(content!);
    if (actions.isNotEmpty) {
      blocks.add(
        Wrap(
          alignment: resolved.actionAlignment!,
          spacing: resolved.actionSpacing!,
          runSpacing: resolved.actionRunSpacing!,
          children: actions,
        ),
      );
    }
    return Align(
      alignment: resolved.alignment!,
      widthFactor: 1,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: resolved.maxWidth!),
        child: AnimatedContainer(
          duration: duration,
          curve: resolved.curve!,
          padding: resolved.padding,
          decoration: BoxDecoration(
            color: resolved.background?.color,
            gradient: resolved.background?.gradient,
            border: resolved.border,
            borderRadius: resolved.borderRadius,
            boxShadow: resolved.boxShadow,
          ),
          child: AnimatedSize(
            duration: duration,
            curve: resolved.curve!,
            alignment: Alignment.topCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < blocks.length; i++) ...[
                  if (i > 0) SizedBox(height: resolved.contentSpacing),
                  blocks[i],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
