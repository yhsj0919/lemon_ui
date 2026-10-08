import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperWidgetGroupPage extends StatefulWidget {
  const HyperWidgetGroupPage({super.key});

  @override
  State<HyperWidgetGroupPage> createState() => _HyperWidgetGroupPageState();
}

class _HyperWidgetGroupPageState extends State<HyperWidgetGroupPage> {
  int _clicks = 0;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    // 此示例特意拉开外角与内角的差异，便于辨认逐项圆角覆盖。
    final outerItemRadius = sizes.widgetGroup.radius * 2;
    final innerItemRadius = sizes.widgetGroup.innerRadius / 2;
    const demoWidth = 360.0;
    final verticalWidth =
        sizes.button.minimumSize.width +
        sizes.button.padding.resolve(Directionality.of(context)).horizontal;
    Widget verticalExample(String title, Widget group) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HyperText(title),
        SizedBox(height: sizes.compactSectionSpacing),
        group,
      ],
    );
    List<Widget> verticalButtons() => [
      for (final label in ['复制', '移动', '删除'])
        HyperWidgetGroupItem(
          width: verticalWidth,
          child: HyperButton.ghost(
            label: Text(label),
            onPressed: () => setState(() => _clicks++),
          ),
        ),
    ];
    return Material(
      color: theme.colors.background,
      child: ListView(
        padding: EdgeInsets.all(sizes.pageHorizontalPadding),
        children: [
          const HyperText(
            'HyperWidgetGroup',
            variant: HyperTextVariant.pageTitle,
          ),
          SizedBox(height: sizes.compactSectionSpacing),
          const HyperText('混合任意控件；组只负责排列和外层视觉。'),
          SizedBox(height: sizes.sectionSpacing),
          DemoSection(
            title: '连续按钮组',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: HyperWidgetGroup(
                    connected: true,
                    showSeparators: true,
                    style: const HyperWidgetGroupStyle(width: demoWidth),
                    children: [
                      HyperWidgetGroupItem(
                        flex: 1,
                        child: HyperButton.ghost(
                          label: const Text('上一页'),
                          onPressed: () => setState(() => _clicks++),
                        ),
                      ),
                      HyperWidgetGroupItem(
                        flex: 1,
                        child: HyperButton.ghost(
                          label: const Text('当前页'),
                          onPressed: () => setState(() => _clicks++),
                        ),
                      ),
                      HyperWidgetGroupItem(
                        flex: 1,
                        child: HyperButton.ghost(
                          label: const Text('下一页'),
                          onPressed: () => setState(() => _clicks++),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DemoSection(
            title: '横向混合',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: HyperWidgetGroup(
                    style: const HyperWidgetGroupStyle(width: demoWidth),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      HyperButton.filled(
                        label: const Text('保存'),
                        onPressed: () => setState(() => _clicks++),
                      ),
                      const HyperTag(label: '草稿'),
                      HyperIconButton.ghost(
                        icon: const Icon(Icons.more_horiz),
                        tooltip: '更多',
                        onPressed: () => setState(() => _clicks++),
                      ),
                      Text('点击 $_clicks 次'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DemoSection(
            title: '固定宽度、比例和统一高度',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: HyperWidgetGroup(
                    connected: true,
                    style: const HyperWidgetGroupStyle(width: demoWidth),
                    children: [
                      HyperWidgetGroupItem(
                        flex: 2,
                        child: HyperButton.ghost(
                          label: const Text('主操作'),
                          onPressed: () => setState(() => _clicks++),
                        ),
                      ),
                      HyperWidgetGroupItem(
                        flex: 1,
                        child: HyperButton.ghost(
                          label: const Text('次操作'),
                          onPressed: () => setState(() => _clicks++),
                        ),
                      ),
                      HyperWidgetGroupItem(
                        width: 80,
                        child: HyperButton.ghost(
                          label: const Text('固定'),
                          onPressed: () => setState(() => _clicks++),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DemoSection(
            title: '带分隔与外层表面',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: HyperWidgetGroup(
                    connected: true,
                    showSeparators: true,
                    style: const HyperWidgetGroupStyle(width: demoWidth),
                    children: [
                      HyperWidgetGroupItem(
                        flex: 1,
                        child: HyperButton.ghost(
                          label: const Text('新建'),
                          onPressed: () => setState(() => _clicks++),
                        ),
                      ),
                      HyperWidgetGroupItem(
                        flex: 1,
                        child: HyperButton.ghost(
                          label: const Text('打开'),
                          onPressed: () => setState(() => _clicks++),
                        ),
                      ),
                      const HyperWidgetGroupItem(
                        flex: 1,
                        child: HyperButton.ghost(
                          label: Text('导出'),
                          onPressed: null,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DemoSection(
            title: '空白分隔与独立圆角',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: HyperWidgetGroup(
                    style: HyperWidgetGroupStyle(
                      width: demoWidth,
                      spacing: sizes.widgetGroup.spacing,
                      itemHeight: sizes.button.minimumSize.height,
                      itemBorderRadius: BorderRadius.circular(innerItemRadius),
                    ),
                    children: [
                      HyperWidgetGroupItem(
                        flex: 1,
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(outerItemRadius),
                          bottomStart: Radius.circular(outerItemRadius),
                          topEnd: Radius.circular(innerItemRadius),
                          bottomEnd: Radius.circular(innerItemRadius),
                        ),
                        child: ColoredBox(
                          color: theme.colors.surface,
                          child: const Center(child: Text('第一项')),
                        ),
                      ),
                      HyperWidgetGroupItem(
                        flex: 1,
                        child: ColoredBox(
                          color: theme.colors.surface,
                          child: const Center(child: Text('中间项')),
                        ),
                      ),
                      HyperWidgetGroupItem(
                        flex: 1,
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(innerItemRadius),
                          bottomStart: Radius.circular(innerItemRadius),
                          topEnd: Radius.circular(outerItemRadius),
                          bottomEnd: Radius.circular(outerItemRadius),
                        ),
                        child: ColoredBox(
                          color: theme.colors.surface,
                          child: const Center(child: Text('最后一项')),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          DemoSection(
            title: '纵向组合样式',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: sizes.sectionSpacing,
                  runSpacing: sizes.sectionSpacing,
                  children: [
                    verticalExample(
                      '连续组合',
                      HyperWidgetGroup(
                        direction: Axis.vertical,
                        connected: true,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        style: HyperWidgetGroupStyle(width: verticalWidth),
                        children: verticalButtons(),
                      ),
                    ),
                    verticalExample(
                      '线条分隔',
                      HyperWidgetGroup(
                        direction: Axis.vertical,
                        connected: true,
                        showSeparators: true,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        style: HyperWidgetGroupStyle(width: verticalWidth),
                        children: verticalButtons(),
                      ),
                    ),
                    verticalExample(
                      '空白分隔',
                      HyperWidgetGroup(
                        direction: Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        style: HyperWidgetGroupStyle(
                          width: verticalWidth,
                          itemHeight: sizes.button.minimumSize.height,
                          itemBorderRadius: BorderRadius.circular(
                            innerItemRadius,
                          ),
                        ),
                        children: [
                          for (var index = 0; index < 3; index++)
                            HyperWidgetGroupItem(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(
                                  index == 0
                                      ? outerItemRadius
                                      : innerItemRadius,
                                ),
                                bottom: Radius.circular(
                                  index == 2
                                      ? outerItemRadius
                                      : innerItemRadius,
                                ),
                              ),
                              child: ColoredBox(
                                color: theme.colors.surface,
                                child: Center(
                                  child: Text(['复制', '移动', '删除'][index]),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          DemoSection(
            title: '纵向与局部主题',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HyperWidgetGroupTheme(
                  data: HyperWidgetGroupThemeData(
                    style: HyperWidgetGroupStyle(
                      spacing: sizes.widgetGroup.spacing,
                      separatorColor: theme.colors.primary,
                    ),
                  ),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: IntrinsicWidth(
                      child: HyperWidgetGroup(
                        direction: Axis.vertical,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        showSeparators: true,
                        children: const [
                          HyperTag(label: '普通'),
                          HyperTag(
                            label: '重点',
                            variant: HyperTagVariant.emphasized,
                          ),
                          HyperTag(label: '已归档', enabled: false),
                        ],
                      ),
                    ),
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
