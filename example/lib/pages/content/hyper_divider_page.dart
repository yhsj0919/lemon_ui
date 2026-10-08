import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

/// 展示 HyperDivider 的方向、线型、渐变和三层主题覆盖。
class HyperDividerPage extends StatelessWidget {
  const HyperDividerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final parent = HyperTheme.of(context);
    final globalTheme = HyperDividerThemeData(
      style: HyperDividerStyle(color: parent.colors.outline, gap: 4),
    );

    return HyperTheme(
      data: parent.copyWith(dividerTheme: globalTheme),
      child: Builder(
        builder: (context) => Material(
          color: HyperTheme.of(context).colors.background,
          child: ListView(
            padding: EdgeInsets.symmetric(
              horizontal: HyperTheme.sizesOf(context).pageHorizontalPadding,
              vertical: 24,
            ),
            children: [
              const HyperText(
                'HyperDivider',
                variant: HyperTextVariant.pageTitle,
              ),
              const SizedBox(height: 8),
              const HyperText('轻量分隔线，支持横向、纵向、渐变、虚线和点线。'),
              const SizedBox(height: 28),
              DemoSection(
                title: '文字、图标与内容位置',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HyperDivider(child: Text('居中内容')),
                    const SizedBox(height: 20),
                    const HyperDivider(
                      style: HyperDividerStyle(
                        contentAlignment: HyperDividerContentAlignment.start,
                      ),
                      child: Text('起点内容'),
                    ),
                    const SizedBox(height: 20),
                    const HyperDivider(
                      pattern: HyperDividerPattern.dashed,
                      style: HyperDividerStyle(
                        contentAlignment: HyperDividerContentAlignment.end,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.history),
                          SizedBox(width: 6),
                          Text('历史记录'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              DemoSection(
                title: '基本线型',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HyperDivider(),
                    const SizedBox(height: 20),
                    const HyperDivider(
                      pattern: HyperDividerPattern.dashed,
                      thickness: 2,
                      radius: 1,
                    ),
                    const SizedBox(height: 20),
                    const HyperDivider(
                      pattern: HyperDividerPattern.dotted,
                      thickness: 4,
                      gap: 6,
                    ),
                  ],
                ),
              ),
              DemoSection(
                title: '渐变与明确尺寸',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: HyperDivider(
                        length: 240,
                        thickness: 4,
                        radius: 2,
                        gradient: LinearGradient(
                          colors: [Color(0xFF3482FF), Color(0xFF7A4DFF)],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              DemoSection(
                title: '垂直方向',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 72,
                      child: Row(
                        children: [
                          const HyperText('左侧'),
                          const SizedBox(width: 16),
                          HyperDivider.vertical(color: parent.colors.primary),
                          const SizedBox(width: 16),
                          const HyperDivider.vertical(
                            pattern: HyperDividerPattern.dashed,
                            thickness: 2,
                            radius: 1,
                          ),
                          const SizedBox(width: 16),
                          const HyperText('右侧'),
                        ],
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
                    HyperDividerTheme(
                      data: const HyperDividerThemeData(
                        style: HyperDividerStyle(
                          color: Color(0xFFFF9500),
                          thickness: 2,
                          pattern: HyperDividerPattern.dashed,
                        ),
                      ),
                      child: Column(
                        children: [
                          const HyperDivider(),
                          const SizedBox(height: 20),
                          HyperDivider(
                            color: parent.colors.primary,
                            thickness: 4,
                            radius: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
