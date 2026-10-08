import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperBadgePage extends StatefulWidget {
  const HyperBadgePage({super.key});

  @override
  State<HyperBadgePage> createState() => _HyperBadgePageState();
}

class _HyperBadgePageState extends State<HyperBadgePage> {
  int _count = 3;
  HyperBadgePosition _position = HyperBadgePosition.topRight;

  static const _positions = <(HyperBadgePosition, String)>[
    (HyperBadgePosition.topLeft, '左上'),
    (HyperBadgePosition.topCenter, '上中'),
    (HyperBadgePosition.topRight, '右上'),
    (HyperBadgePosition.centerLeft, '左中'),
    (HyperBadgePosition.center, '正中'),
    (HyperBadgePosition.centerRight, '右中'),
    (HyperBadgePosition.bottomLeft, '左下'),
    (HyperBadgePosition.bottomCenter, '下中'),
    (HyperBadgePosition.bottomRight, '右下'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    return Material(
      color: theme.colors.background,
      child: ListView(
        padding: EdgeInsets.all(sizes.pageHorizontalPadding),
        children: [
          const HyperText('HyperBadge', variant: HyperTextVariant.pageTitle),
          SizedBox(height: sizes.compactSectionSpacing),
          const HyperText('点、数字、短文本与自定义内容；角标定位由独立组件负责。'),
          SizedBox(height: sizes.sectionSpacing),
          DemoSection(
            title: '内容形态',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: sizes.compactSectionSpacing,
                  runSpacing: sizes.compactSectionSpacing,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: const [
                    HyperBadge(semanticsLabel: '有新消息'),
                    HyperBadge(label: 'NEW'),
                    HyperBadge(content: Icon(Icons.check, size: 12)),
                  ],
                ),
              ],
            ),
          ),
          DemoSection(
            title: '数字模式（超过 99 显示 99+）',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: sizes.compactSectionSpacing,
                  runSpacing: sizes.compactSectionSpacing,
                  children: const [
                    HyperBadge.number(count: 0),
                    HyperBadge.number(count: 0, showZero: true),
                    HyperBadge.number(count: 8),
                    HyperBadge.number(count: 99),
                    HyperBadge.number(count: 120),
                  ],
                ),
                SizedBox(height: sizes.compactSectionSpacing),
                Row(
                  children: [
                    HyperBadge.number(count: _count),
                    SizedBox(width: sizes.compactSectionSpacing),
                    HyperButton.text(
                      onPressed: () =>
                          setState(() => _count = (_count - 1).clamp(0, 120)),
                      child: const Text('减少'),
                    ),
                    HyperButton.text(
                      onPressed: () =>
                          setState(() => _count = (_count + 1).clamp(0, 120)),
                      child: const Text('增加'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          DemoSection(
            title: '附着在控件上',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: sizes.sectionSpacing,
                  children: [
                    HyperIconButton.ghost(
                      onPressed: () {},
                      tooltip: '通知',
                      icon: const HyperBadgeAnchor(
                        badge: HyperBadge.number(count: 3),
                        child: Icon(Icons.notifications_outlined),
                      ),
                    ),
                    HyperIconButton.ghost(
                      onPressed: () {},
                      tooltip: '用户',
                      icon: const HyperBadgeAnchor(
                        position: HyperBadgePosition.bottomRight,
                        badge: HyperBadge(semanticsLabel: '在线'),
                        child: Icon(Icons.person_outline),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          DemoSection(
            title: '位置、偏移与自定义徽标',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: sizes.controlHeightXl * 4,
                    ),
                    child: Column(
                      children: [
                        for (var row = 0; row < 3; row++)
                          Row(
                            children: [
                              for (var column = 0; column < 3; column++)
                                Expanded(
                                  child: HyperButton.text(
                                    onPressed: () => setState(
                                      () => _position =
                                          _positions[row * 3 + column].$1,
                                    ),
                                    style: HyperButtonStyle(
                                      background:
                                          _position ==
                                              _positions[row * 3 + column].$1
                                          ? HyperFill.color(
                                              theme.colors.surfaceMuted,
                                            )
                                          : null,
                                    ),
                                    child: Text(
                                      _positions[row * 3 + column].$2,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: sizes.compactSectionSpacing),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: HyperBadgeAnchor(
                    position: _position,
                    offset: const Offset(4, -2),
                    badge: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colors.primary,
                        borderRadius: BorderRadius.circular(
                          sizes.badge.contentRadius,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: sizes.badge.horizontalPadding,
                          vertical: 2,
                        ),
                        child: Text(
                          '自绘',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colors.onPrimary,
                          ),
                        ),
                      ),
                    ),
                    child: SizedBox(
                      width: sizes.controlHeightXl,
                      height: sizes.controlHeightXl,
                      child: ColoredBox(
                        color: theme.colors.surfaceMuted,
                        child: const Icon(Icons.widgets_outlined),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          DemoSection(
            title: '局部主题与实例覆盖',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HyperBadgeTheme(
                  data: HyperBadgeThemeData(
                    lightBackgroundColor: theme.colors.warning,
                    darkBackgroundColor: theme.colors.warning,
                    defaultForegroundColor: theme.colors.onWarning,
                  ),
                  child: Wrap(
                    spacing: sizes.compactSectionSpacing,
                    children: [
                      const HyperBadge(count: 4),
                      const HyperBadge(label: '注意'),
                      HyperBadge(
                        label: '完成',
                        style: HyperBadgeStyle(
                          backgroundColor: theme.colors.success,
                          foregroundColor: theme.colors.onSuccess,
                          contentRadius: sizes.badge.dotRadius,
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
