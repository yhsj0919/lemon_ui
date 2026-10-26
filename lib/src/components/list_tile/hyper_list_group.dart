import 'package:flutter/widgets.dart';

import '../card/hyper_card_style.dart';
import '../card/hyper_card.dart';
import '../card/hyper_titled_card.dart';
import '../card/hyper_titled_card_style.dart';
import '../card/hyper_titled_card_theme.dart';
import '../../theme/core/hyper_theme.dart';

/// 带标题和操作区的列表分组，继承卡片与带标题卡片主题。
///
/// 内容默认不添加内边距，由各列表项管理自己的留白。
class HyperListGroup extends StatelessWidget {
  const HyperListGroup({
    super.key,
    this.title,
    required this.children,
    this.action,
    this.titlePosition = HyperCardTitlePosition.outside,
    this.cardStyle,
    this.style,
  });

  final Widget? title;
  final List<Widget> children;
  final Widget? action;
  final HyperCardTitlePosition titlePosition;
  final HyperCardStyle? cardStyle;
  final HyperTitledCardStyle? style;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
    final surfaceStyle = HyperCardStyle(padding: EdgeInsets.zero)
        .merge(cardStyle);
    if (title == null && action == null) {
      return HyperCard(style: surfaceStyle, child: content);
    }
    return HyperTitledCard(
      title: title ?? const SizedBox.shrink(),
      action: action,
      titlePosition: titlePosition,
      style: titlePosition == HyperCardTitlePosition.inside
          ? HyperTitledCardStyle(
                  titlePadding: HyperTheme.sizesOf(context)
                      .card
                      .listGroupTitlePadding,
                  actionPadding: EdgeInsetsDirectional.only(
                    end: HyperTheme.sizesOf(context).card.listGroupTitlePadding
                        .resolve(Directionality.of(context))
                        .right,
                  ),
                )
                .merge(HyperTitledCardTheme.of(context).style)
                .merge(HyperTitledCardTheme.of(context).inside)
                .merge(style)
          : style,
      cardStyle: surfaceStyle,
      child: content,
    );
  }
}
