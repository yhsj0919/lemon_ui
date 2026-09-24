import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_card.dart';
import 'hyper_card_style.dart';
import 'hyper_titled_card_style.dart';
import 'hyper_titled_card_theme.dart';

/// 标题行位于卡片内部或外部。
enum HyperCardTitlePosition { inside, outside }

/// 带标题的卡片组合；主体和标题右侧均接受任意 Widget。
class HyperTitledCard extends StatelessWidget {
  const HyperTitledCard({
    super.key,
    required this.title,
    required this.child,
    this.action,
    this.titlePosition = HyperCardTitlePosition.outside,
    this.cardStyle,
    this.style,
  });

  final Widget title;
  final Widget child;
  final Widget? action;
  final HyperCardTitlePosition titlePosition;
  final HyperCardStyle? cardStyle;
  final HyperTitledCardStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).card;
    final themedStyle = HyperTitledCardTheme.of(context).style;
    final outside = titlePosition == HyperCardTitlePosition.outside;
    final resolved = HyperTitledCardStyle(
      titlePadding: outside
          ? metrics.outsideTitlePadding
          : metrics.titlePadding,
      titleSpacing: outside
          ? metrics.outsideTitleSpacing
          : metrics.titleSpacing,
      actionSpacing: metrics.actionSpacing,
      // 卡片外的分组标签沿用较小的弱强调文字；卡片内仍是内容标题。
      titleTextStyle: outside
          ? theme.textTheme.titleSmall?.copyWith(
              color: theme.colors.textTertiary,
            )
          : theme.textTheme.titleMedium?.copyWith(
              fontSize: theme.typography.cardTitle,
              color: theme.colors.textPrimary,
            ),
      actionTextStyle: theme.textTheme.titleSmall?.copyWith(
        color: theme.colors.primary,
      ),
    ).merge(themedStyle).merge(style);
    final insets = resolved.titlePadding!.resolve(Directionality.of(context));
    final header = Row(
      children: [
        Expanded(
          child: DefaultTextStyle.merge(
            style: resolved.titleTextStyle,
            child: title,
          ),
        ),
        if (action != null) ...[
          SizedBox(width: resolved.actionSpacing),
          DefaultTextStyle.merge(
            style: resolved.actionTextStyle,
            child: IconTheme.merge(
              data: IconThemeData(color: resolved.actionTextStyle?.color),
              child: action!,
            ),
          ),
        ],
      ],
    );
    if (titlePosition == HyperCardTitlePosition.inside) {
      return HyperCard(
        style: cardStyle,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 标题留在表面内；主体的内边距和排列由调用方决定。
            Padding(
              padding: EdgeInsets.fromLTRB(
                insets.left,
                insets.top,
                insets.right,
                0,
              ),
              child: header,
            ),
            SizedBox(height: resolved.titleSpacing),
            child,
          ],
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(padding: resolved.titlePadding!, child: header),
        SizedBox(height: resolved.titleSpacing),
        HyperCard(style: cardStyle, child: child),
      ],
    );
  }
}
