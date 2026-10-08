import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperEmptyStatePage extends StatefulWidget {
  const HyperEmptyStatePage({super.key});
  @override
  State<HyperEmptyStatePage> createState() => _HyperEmptyStatePageState();
}

class _HyperEmptyStatePageState extends State<HyperEmptyStatePage> {
  int _created = 0;
  int _retries = 0;
  bool _cleared = false;
  bool _loading = true;
  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    Widget section(String title, Widget content) =>
        DemoSection(title: title, child: content);
    return ListView(
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      children: [
        Align(
          alignment: AlignmentDirectional.topStart,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const HyperText(
                  'Empty State',
                  variant: HyperTextVariant.pageTitle,
                ),
                SizedBox(height: sizes.sectionSpacing),
                section(
                  '暂无数据',
                  HyperEmptyState(
                    title: _created == 0 ? '暂无项目' : '已创建 $_created 个项目',
                    description: '创建第一个项目，开始整理你的内容。',
                    actions: [
                      HyperButton.filled(
                        onPressed: () => setState(() => _created++),
                        child: const HyperText('创建项目'),
                      ),
                    ],
                  ),
                ),
                section(
                  '搜索无结果',
                  HyperEmptyState(
                    icon: Icons.search_off_outlined,
                    title: _cleared ? '搜索条件已清除' : '未找到相关内容',
                    description: '试试其他关键词，或清除当前筛选条件。',
                    actions: [
                      HyperButton.tonal(
                        onPressed: () => setState(() => _cleared = !_cleared),
                        child: HyperText(_cleared ? '恢复条件' : '清除条件'),
                      ),
                    ],
                  ),
                ),
                section(
                  '加载失败',
                  HyperEmptyState(
                    icon: Icons.cloud_off_outlined,
                    title: '暂时无法加载',
                    description: _retries == 0
                        ? '请检查网络连接后重试。'
                        : '已触发 $_retries 次重试。',
                    actions: [
                      HyperButton.filled(
                        onPressed: () => setState(() => _retries++),
                        child: const HyperText('重试'),
                      ),
                      HyperButton.tonal(
                        onPressed: () => setState(() => _retries = 0),
                        child: const HyperText('重置'),
                      ),
                    ],
                  ),
                ),
                section(
                  '自定义插图',
                  HyperEmptyState(
                    title: '这里还没有文件',
                    description: '插图可替换成图片、矢量资源或自定义 Widget。',
                    illustration: SizedBox(
                      width: 120,
                      height: 88,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Positioned(
                            bottom: 0,
                            child: Container(
                              width: 112,
                              height: 18,
                              decoration: BoxDecoration(
                                color: theme.colors.primary.withValues(
                                  alpha: .08,
                                ),
                                borderRadius: BorderRadius.circular(9),
                              ),
                            ),
                          ),
                          Transform.rotate(
                            angle: -.12,
                            child: Container(
                              width: 56,
                              height: 68,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    theme.colors.primary.withValues(alpha: .18),
                                    theme.colors.primary.withValues(alpha: .05),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.description_outlined,
                                size: 36,
                                color: theme.colors.primary.withValues(
                                  alpha: .7,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                section(
                  '纯文字与自定义内容',
                  const HyperEmptyState(
                    showIllustration: false,
                    titleWidget: HyperText(
                      '先从一个小目标开始',
                      variant: HyperTextVariant.subsectionTitle,
                    ),
                    description: '也可以完全替换标题、说明和附加内容。',
                    content: Center(child: HyperTag(label: '自定义内容')),
                  ),
                ),
                section(
                  '局部主题与实例覆盖',
                  HyperEmptyStateTheme(
                    data: HyperEmptyStateThemeData(
                      style: HyperEmptyStateStyle(
                        iconColor: theme.colors.primary,
                        background: HyperFill.color(
                          theme.colors.primary.withValues(alpha: .04),
                        ),
                        borderRadius: BorderRadius.circular(
                          sizes.surfaceRadius,
                        ),
                        titleStyle: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colors.primary,
                        ),
                      ),
                    ),
                    child: HyperEmptyState(
                      title: '主题可以替换默认外观',
                      description: '当前实例单独覆盖说明文字的颜色。',
                      style: HyperEmptyStateStyle(
                        descriptionStyle: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colors.textPrimary,
                        ),
                      ),
                    ),
                  ),
                ),
                section(
                  '加载结束后为空',
                  Column(
                    children: [
                      Row(
                        children: [
                          const Expanded(child: HyperText('加载中')),
                          HyperSwitch(
                            value: _loading,
                            onChanged: (value) =>
                                setState(() => _loading = value),
                          ),
                        ],
                      ),
                      SizedBox(height: sizes.sectionSpacing),
                      AnimatedSwitcher(
                        duration: MediaQuery.of(context).disableAnimations
                            ? Duration.zero
                            : theme.motion.standardDuration,
                        child: _loading
                            ? Column(
                                key: const ValueKey('loading'),
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const HyperSkeleton.text(),
                                  SizedBox(height: sizes.compactSectionSpacing),
                                  const HyperSkeleton.text(),
                                ],
                              )
                            : const HyperEmptyState(
                                key: ValueKey('empty'),
                                title: '暂无记录',
                                description: '新的记录会显示在这里。',
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
