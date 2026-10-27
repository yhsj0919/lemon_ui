import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperTagPage extends StatefulWidget {
  const HyperTagPage({super.key});

  @override
  State<HyperTagPage> createState() => _HyperTagPageState();
}

class _HyperTagPageState extends State<HyperTagPage> {
  bool _emphasized = false;
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    return Material(
      color: theme.colors.background,
      child: ListView(
        padding: EdgeInsets.all(sizes.pageHorizontalPadding),
        children: [
          const HyperText('标签', variant: HyperTextVariant.pageTitle),
          SizedBox(height: sizes.compactSectionSpacing),
          const HyperText('轻量分类与状态展示；点击和选择行为由 Chip 提供。'),
          SizedBox(height: sizes.sectionSpacing),
          DemoSection(
            title: '基础状态',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: HyperSizeScheme.spaceMd,
                  runSpacing: HyperSizeScheme.spaceMd,
                  children: const [
                    HyperTag(label: '普通'),
                    HyperTag(label: '已同步', icon: Icon(Icons.check)),
                    HyperTag(label: '重点', variant: HyperTagVariant.emphasized),
                    HyperTag(label: '不可用', enabled: false),
                  ],
                ),
              ],
            ),
          ),
          DemoSection(
            title: '配色样式（实例 Style 覆盖）',
            child: Wrap(
              spacing: sizes.compactSectionSpacing,
              runSpacing: sizes.compactSectionSpacing,
              children: [
                for (final variant in HyperTagColorVariant.values)
                  HyperTag(
                    label: switch (variant) {
                      HyperTagColorVariant.neutral => '中性',
                      HyperTagColorVariant.soft => '浅色',
                      HyperTagColorVariant.filled => '实色',
                      HyperTagColorVariant.outlined => '描边',
                      HyperTagColorVariant.text => '无底色',
                    },
                    style: HyperTagStyle(colorVariant: variant),
                  ),
              ],
            ),
          ),
          DemoSection(
            title: '业务语义（默认配色）',
            child: Wrap(
              spacing: sizes.compactSectionSpacing,
              runSpacing: sizes.compactSectionSpacing,
              children: const [
                HyperTag.success(label: '已完成'),
                HyperTag.warning(label: '待处理'),
                HyperTag.error(label: '失败'),
                HyperTag.destructive(label: '已删除'),
                HyperTag.info(label: '进行中'),
                HyperTag.neutral(label: '草稿'),
              ],
            ),
          ),
          DemoSection(
            title: '状态过渡',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: HyperSizeScheme.spaceMd,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    HyperTag(
                      label: '动态标签',
                      icon: const Icon(Icons.info_outline),
                      variant: _emphasized
                          ? HyperTagVariant.emphasized
                          : HyperTagVariant.standard,
                      enabled: _enabled,
                    ),
                    HyperButton.text(
                      onPressed: () =>
                          setState(() => _emphasized = !_emphasized),
                      child: const Text('切换强调'),
                    ),
                    HyperButton.text(
                      onPressed: () => setState(() => _enabled = !_enabled),
                      child: const Text('切换禁用'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          DemoSection(
            title: '局部主题与实例覆盖',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HyperTagTheme(
                  data: HyperTagThemeData(
                    style: HyperTagStyle(
                      backgroundColor: theme.colors.surfaceElevated,
                      borderColor: theme.colors.outline,
                      borderWidth: 1,
                    ),
                  ),
                  child: Wrap(
                    spacing: HyperSizeScheme.spaceMd,
                    runSpacing: HyperSizeScheme.spaceMd,
                    children: [
                      const HyperTag(label: '局部主题'),
                      HyperTag(
                        label: '实例覆盖',
                        style: HyperTagStyle(
                          backgroundColor: theme.colors.primaryContainer,
                          foregroundColor: theme.colors.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
