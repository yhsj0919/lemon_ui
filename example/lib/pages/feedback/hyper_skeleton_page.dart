import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

class HyperSkeletonPage extends StatefulWidget {
  const HyperSkeletonPage({super.key});
  @override
  State<HyperSkeletonPage> createState() => _HyperSkeletonPageState();
}

class _HyperSkeletonPageState extends State<HyperSkeletonPage> {
  bool _loading = true;
  bool _reduced = false;
  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    final theme = HyperTheme.of(context);
    final gap = sizes.compactSectionSpacing;
    Widget lines() => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const HyperSkeleton.text(),
        SizedBox(height: gap),
        const FractionallySizedBox(
          alignment: AlignmentDirectional.centerStart,
          widthFactor: .75,
          child: HyperSkeleton.text(),
        ),
      ],
    );
    Widget row() => Row(
      children: [
        const HyperSkeleton.circle(),
        SizedBox(width: sizes.sectionSpacing),
        Expanded(child: lines()),
      ],
    );
    Widget section(String label, Widget child) => Padding(
      padding: EdgeInsets.only(bottom: sizes.sectionSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HyperText(label, variant: HyperTextVariant.sectionTitle),
          SizedBox(height: gap),
          HyperCard(child: child),
        ],
      ),
    );
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        disableAnimations: _reduced || MediaQuery.of(context).disableAnimations,
      ),
      child: ListView(
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
                    'Skeleton',
                    variant: HyperTextVariant.pageTitle,
                  ),
                  SizedBox(height: sizes.sectionSpacing),
                  Row(
                    children: [
                      const Expanded(child: HyperText('减少动画')),
                      HyperSwitch(
                        value: _reduced,
                        onChanged: (value) => setState(() => _reduced = value),
                      ),
                    ],
                  ),
                  SizedBox(height: sizes.sectionSpacing),
                  section(
                    '基础形状 · 微光',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const HyperSkeleton.text(),
                        SizedBox(height: sizes.sectionSpacing),
                        Wrap(
                          spacing: sizes.sectionSpacing,
                          runSpacing: sizes.sectionSpacing,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: const [
                            HyperSkeleton.circle(),
                            HyperSkeleton(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  section(
                    '呼吸',
                    const HyperSkeletonTheme(
                      data: HyperSkeletonThemeData(
                        style: HyperSkeletonStyle(
                          effect: HyperSkeletonEffect.pulse,
                        ),
                      ),
                      child: HyperSkeleton.text(),
                    ),
                  ),
                  section(
                    '静态',
                    const HyperSkeletonTheme(
                      data: HyperSkeletonThemeData(
                        style: HyperSkeletonStyle(
                          effect: HyperSkeletonEffect.none,
                        ),
                      ),
                      child: HyperSkeleton.text(),
                    ),
                  ),
                  section(
                    '列表组合',
                    Column(
                      children: [
                        for (var i = 0; i < 3; i++) ...[
                          if (i > 0) SizedBox(height: sizes.sectionSpacing),
                          row(),
                        ],
                      ],
                    ),
                  ),
                  section(
                    '卡片组合',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const AspectRatio(
                          aspectRatio: 16 / 9,
                          child: HyperSkeleton(
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),
                        SizedBox(height: sizes.sectionSpacing),
                        row(),
                      ],
                    ),
                  ),
                  section(
                    '加载内容过渡',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        HyperSkeleton.text(
                          loading: _loading,
                          semanticsLabel: '正在加载内容',
                          child: const HyperText('内容加载完成。'),
                        ),
                      ],
                    ),
                  ),
                  section(
                    '局部主题与实例覆盖',
                    HyperSkeletonTheme(
                      data: HyperSkeletonThemeData(
                        style: HyperSkeletonStyle(
                          backgroundColor: theme.colors.primary.withValues(
                            alpha: .12,
                          ),
                          highlightColor: theme.colors.primary.withValues(
                            alpha: .3,
                          ),
                          radius: sizes.controlRadius,
                          duration: const Duration(milliseconds: 1800),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const HyperSkeleton.text(),
                          SizedBox(height: sizes.sectionSpacing),
                          HyperSkeleton.text(
                            style: HyperSkeletonStyle(
                              radius: 0,
                              borderColor: theme.colors.primary.withValues(
                                alpha: .25,
                              ),
                              borderWidth: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
