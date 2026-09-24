import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 三种标签变体分别演示，选择状态互不干扰。
class HyperTabBarPage extends StatelessWidget {
  const HyperTabBarPage({super.key});

  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    return ListView(
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      children: [
        const _TabExample(
          title: '底槽标签（默认）',
          variant: HyperTabBarVariant.segmented,
          labels: ['隐私', '安全'],
        ),
        SizedBox(height: sizes.sectionSpacing),
        const _TabExample(
          title: '独立圆角标签',
          variant: HyperTabBarVariant.separated,
          labels: ['声音', '触感'],
        ),
        SizedBox(height: sizes.sectionSpacing),
        const _TabExample(
          title: '下划线标签',
          variant: HyperTabBarVariant.underline,
          labels: ['概览', '详情'],
        ),
      ],
    );
  }
}

class _TabExample extends StatelessWidget {
  const _TabExample({
    required this.title,
    required this.variant,
    required this.labels,
  });

  final String title;
  final HyperTabBarVariant variant;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    return DefaultTabController(
      length: labels.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HyperText(title, variant: HyperTextVariant.sectionTitle),
          SizedBox(height: sizes.compactSectionSpacing),
          HyperTabBar(
            variant: variant,
            tabs: [for (final label in labels) HyperTab(text: label)],
          ),
          SizedBox(
            height: sizes.controlHeightMd * 2,
            child: HyperTabBarView(
              children: [
                for (final label in labels)
                  Center(child: HyperText('$label内容')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
