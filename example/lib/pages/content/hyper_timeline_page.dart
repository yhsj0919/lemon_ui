import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

class HyperTimelinePage extends StatefulWidget {
  const HyperTimelinePage({super.key});
  @override
  State<HyperTimelinePage> createState() => _PageState();
}

class _PageState extends State<HyperTimelinePage> {
  HyperTimelineAlignment _alignment = HyperTimelineAlignment.start;
  bool _reverse = false;
  HyperTimelineStatus _status = HyperTimelineStatus.active;
  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    Widget section(String title, List<Widget> children) => Padding(
      padding: EdgeInsets.only(bottom: sizes.sectionSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HyperText(title, variant: HyperTextVariant.sectionTitle),
          SizedBox(height: sizes.compactSectionSpacing),
          for (final child in children) ...[
            child,
            SizedBox(height: sizes.timeline.spacing),
          ],
        ],
      ),
    );
    return ListView(
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      children: [
        const HyperText('Timeline', variant: HyperTextVariant.pageTitle),
        SizedBox(height: sizes.sectionSpacing),
        section('记录顺序与展示方向', [
          Wrap(
            spacing: sizes.timeline.spacing,
            runSpacing: sizes.timeline.spacing,
            children: [
              for (final alignment in HyperTimelineAlignment.values)
                HyperButton.text(
                  label: Text(alignment.name),
                  onPressed: () => setState(() => _alignment = alignment),
                ),
              HyperButton.text(
                label: Text(_reverse ? '恢复顺序' : '反转顺序'),
                onPressed: () => setState(() => _reverse = !_reverse),
              ),
              HyperButton.text(
                label: const Text('切换第二项状态'),
                onPressed: () => setState(() {
                  _status =
                      HyperTimelineStatus.values[(_status.index + 1) %
                          HyperTimelineStatus.values.length];
                }),
              ),
            ],
          ),
          HyperTimeline(
            alignment: _alignment,
            reverse: _reverse,
            items: [
              const HyperTimelineItem(
                id: 'created',
                title: Text('订单已创建'),
                time: Text('10:20'),
                content: Text('等待处理。'),
                status: HyperTimelineStatus.success,
              ),
              HyperTimelineItem(
                id: 'shipping',
                title: const Text('正在配送'),
                time: const Text('11:30'),
                content: const Text('配送员正在前往目的地，这段正文可以自然换行。'),
                status: _status,
              ),
              const HyperTimelineItem(
                id: 'delivered',
                title: Text('等待签收'),
                time: Text('预计 12:00'),
                content: Text('时间文字由页面格式化。'),
              ),
            ],
          ),
        ]),
        section('六种状态', [
          HyperTimeline(
            items: [
              for (final status in HyperTimelineStatus.values)
                HyperTimelineItem(
                  id: status,
                  title: Text(status.name),
                  status: status,
                ),
            ],
          ),
        ]),
        section('自定义节点和内容', [
          HyperTimeline(
            items: [
              const HyperTimelineItem(
                id: 'small',
                title: Text('默认圆点'),
                content: Text('与自定义节点保持同一轨道'),
              ),
              HyperTimelineItem(
                id: 'custom',
                title: const Text('自定义图标'),
                node: const Icon(Icons.local_shipping_outlined),
                status: HyperTimelineStatus.active,
                style: HyperTimelineStyle(
                  nodeSize: sizes.stepIndicator.nodeSize,
                ),
                content: HyperButton.text(
                  label: const Text('查看详情'),
                  onPressed: () {},
                ),
              ),
              const HyperTimelineItem(
                id: 'tail',
                title: Text('最后一项'),
                content: Text('末尾不绘制连接线'),
              ),
            ],
          ),
        ]),
        section('独立主题和对侧内容', [
          HyperTimelineTheme(
            data: const HyperTimelineThemeData(
              active: HyperTimelineStyle(
                nodeFill: HyperFill.color(Colors.teal),
                lineColor: Colors.teal,
              ),
              style: HyperTimelineStyle(
                titleStyle: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            child: const HyperTimeline(
              items: [
                HyperTimelineItem(
                  id: 1,
                  title: Text('发布版本'),
                  opposite: Text('2026 / 10 / 06'),
                  status: HyperTimelineStatus.active,
                  content: Text('两侧布局保持统一的中心轨道'),
                ),
                HyperTimelineItem(
                  id: 2,
                  title: Text('准备下一版本'),
                  content: Text('未设置对侧内容时保留该列'),
                ),
              ],
            ),
          ),
          const Directionality(
            textDirection: TextDirection.rtl,
            child: HyperTimeline(
              items: [
                HyperTimelineItem(
                  id: 'rtl',
                  title: Text('RTL 布局'),
                  content: Text('轨道使用逻辑起始方向'),
                ),
              ],
            ),
          ),
          const HyperTimeline(items: []),
        ]),
      ],
    );
  }
}
