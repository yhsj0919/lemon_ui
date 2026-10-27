import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

@Preview(name: '锚定面板', group: '交互基础', size: Size(360, 800))
Widget popoverPreview() => MaterialApp(
  home: HyperTheme(
    data: HyperThemeData.light(),
    child: const Scaffold(body: HyperPopoverPage()),
  ),
);

class HyperPopoverPage extends StatelessWidget {
  const HyperPopoverPage({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HyperText('锚定面板', variant: HyperTextVariant.pageTitle),
        const HyperText('默认继承公共浮层材质、阴影及当前设备的菜单规格。'),
        DemoSection(
          title: '默认主题预览',
          child: Wrap(
            spacing: HyperTheme.sizesOf(context).overlaySpacing,
            runSpacing: HyperTheme.sizesOf(context).overlaySpacing,
            children: [
              HyperPopover.builder(
                anchorBuilder: (context, toggle, open) => HyperButton.tonal(
                  onPressed: toggle,
                  label: Text(open ? '收起' : '点击打开'),
                ),
                contentBuilder: (context, close) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HyperText('可以放置说明、操作或任意内容。'),
                    HyperButton.text(
                      onPressed: close,
                      label: const Text('关闭浮层'),
                    ),
                  ],
                ),
              ),
              HyperPopover(
                trigger: HyperOverlayTrigger.hover,
                placement: HyperOverlayPlacement.sideEnd,
                anchor: const HyperCard(child: HyperText('悬停查看')),
                contentBuilder: (context, close) =>
                    const HyperText('移入面板后保持打开'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: '实例 Style 覆盖 · 关闭阴影',
          child: HyperPopover.builder(
            style: HyperPopoverStyle(
              surfaceStyle: HyperCardStyle(boxShadow: const []),
            ),
            anchorBuilder: (context, toggle, open) => HyperButton.tonal(
              onPressed: toggle,
              label: const Text('无阴影面板'),
            ),
            contentBuilder: (context, close) => const HyperText('仅此实例关闭阴影'),
          ),
        ),
        DemoSection(
          title: '局部主题覆盖 · 表面圆角',
          child: HyperPopoverTheme(
            data: HyperPopoverThemeData(
              style: HyperPopoverStyle(
                surfaceStyle: HyperCardStyle(borderRadius: BorderRadius.zero),
              ),
            ),
            child: HyperPopover.builder(
              anchorBuilder: (context, toggle, open) => HyperButton.tonal(
                onPressed: toggle,
                label: const Text('局部主题面板'),
              ),
              contentBuilder: (context, close) => const HyperText('其余属性继续继承'),
            ),
          ),
        ),
      ],
    ),
  );
}
