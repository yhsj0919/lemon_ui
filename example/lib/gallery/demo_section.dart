import 'package:flutter/widgets.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// Demo 的标题与展示内容共用一张卡片。
class DemoSection extends StatelessWidget {
  const DemoSection({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    return Padding(
      padding: EdgeInsets.only(bottom: sizes.sectionSpacing),
      child: HyperTitledCard(
        title: Text(title),
        titlePosition: HyperCardTitlePosition.inside,
        cardStyle: HyperCardStyle(padding: EdgeInsets.zero),
        child: Padding(
          padding: sizes.card.titlePadding,
          child: Align(alignment: AlignmentDirectional.topStart, child: child),
        ),
      ),
    );
  }
}
