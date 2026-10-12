import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperPageIndicatorPage extends StatefulWidget {
  const HyperPageIndicatorPage({super.key});
  @override
  State<HyperPageIndicatorPage> createState() => _PageState();
}

class _PageState extends State<HyperPageIndicatorPage> {
  final _controller = PageController();
  int _index = 0, _manyIndex = 10;
  bool _enabled = true, _reduced = false;
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final size = HyperTheme.sizesOf(context);
    final reduced = _reduced || MediaQuery.of(context).disableAnimations;
    void go(int index) {
      if (reduced) {
        _controller.jumpToPage(index);
      } else {
        _controller.animateToPage(
          index,
          duration: theme.motion.standardDuration,
          curve: theme.motion.standardCurve,
        );
      }
    }

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: reduced),
      child: ListView(
        padding: EdgeInsets.all(size.pageHorizontalPadding),
        children: [
          DemoSection(
            title: '连接 PageView：拖动或点击切换',
            child: Column(
              children: [
                SizedBox(
                  height: 180,
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (index) => setState(() => _index = index),
                    children: [
                      for (var i = 0; i < 5; i++)
                        Center(
                          child: Text(
                            '第 ${i + 1} 页',
                            style: theme.textTheme.titleLarge,
                          ),
                        ),
                    ],
                  ),
                ),
                HyperPageIndicator(
                  pageCount: 5,
                  currentIndex: _index,
                  enabled: _enabled,
                  onPageChanged: go,
                ),
                SizedBox(height: size.pageIndicator.spacing),
                HyperPageIndicator(
                  pageCount: 5,
                  currentIndex: _index,
                  variant: HyperPageIndicatorVariant.number,
                ),
                Wrap(
                  spacing: size.pageIndicator.spacing,
                  children: [
                    HyperButton.text(
                      label: const Text('上一页'),
                      onPressed: _index == 0 ? null : () => go(_index - 1),
                    ),
                    HyperButton.text(
                      label: const Text('下一页'),
                      onPressed: _index == 4 ? null : () => go(_index + 1),
                    ),
                    HyperButton.text(
                      label: Text(_enabled ? '禁用指示器' : '启用指示器'),
                      onPressed: () => setState(() => _enabled = !_enabled),
                    ),
                    HyperButton.text(
                      label: Text(_reduced ? '恢复动画' : '减少动画'),
                      onPressed: () => setState(() => _reduced = !_reduced),
                    ),
                  ],
                ),
              ],
            ),
          ),
          DemoSection(
            title: '只读、选中长点与纵向',
            child: Wrap(
              spacing: size.result.contentSpacing,
              runSpacing: size.result.contentSpacing,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                HyperPageIndicator(pageCount: 5, currentIndex: _index),
                HyperPageIndicator(
                  pageCount: 5,
                  currentIndex: _index,
                  style: HyperPageIndicatorStyle(
                    selectedWidth: size.timeline.nodeSize,
                  ),
                ),
                HyperPageIndicator(
                  pageCount: 5,
                  currentIndex: _index,
                  direction: Axis.vertical,
                ),
              ],
            ),
          ),
          DemoSection(
            title: '多页有限窗口：保留真实索引',
            child: Column(
              children: [
                HyperPageIndicator(
                  pageCount: 30,
                  currentIndex: _manyIndex,
                  maxVisibleDots: 7,
                  onPageChanged: (index) => setState(() => _manyIndex = index),
                ),
                HyperPageIndicator(
                  pageCount: 30,
                  currentIndex: _manyIndex,
                  variant: HyperPageIndicatorVariant.number,
                ),
                Wrap(
                  children: [
                    HyperButton.text(
                      label: const Text('开头'),
                      onPressed: () => setState(() => _manyIndex = 0),
                    ),
                    HyperButton.text(
                      label: const Text('中间'),
                      onPressed: () => setState(() => _manyIndex = 15),
                    ),
                    HyperButton.text(
                      label: const Text('末尾'),
                      onPressed: () => setState(() => _manyIndex = 29),
                    ),
                  ],
                ),
              ],
            ),
          ),
          DemoSection(
            title: '局部主题与统一材质',
            child: HyperPageIndicatorTheme(
              data: HyperPageIndicatorThemeData(
                style: HyperPageIndicatorStyle(
                  selectedDotFill: HyperFill.color(theme.colors.success),
                  dotFill: HyperFill.color(theme.colors.textTertiary),
                  selectedWidth: size.timeline.nodeSize,
                ),
              ),
              child: HyperPageIndicator(
                pageCount: 5,
                currentIndex: _index,
                style: HyperPageIndicatorStyle(
                  material: const HyperSurfaceMaterial.frostedGlass(),
                  padding: EdgeInsets.all(size.pageIndicator.spacing),
                  borderRadius: BorderRadius.circular(size.card.radius),
                ),
              ),
            ),
          ),
          DemoSection(
            title: '自定义数字内容',
            child: HyperPageIndicator(
              pageCount: 5,
              currentIndex: _index,
              variant: HyperPageIndicatorVariant.number,
              counterBuilder: (context, index, count) =>
                  Text('${index + 1} of $count'),
            ),
          ),
          const DemoSection(
            title: '空列表不绘制指示器',
            child: HyperPageIndicator(pageCount: 0, currentIndex: 0),
          ),
        ],
      ),
    );
  }
}
