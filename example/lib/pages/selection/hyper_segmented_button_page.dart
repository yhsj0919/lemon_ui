import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperSegmentedButtonPage extends StatefulWidget {
  const HyperSegmentedButtonPage({super.key});
  @override
  State<HyperSegmentedButtonPage> createState() => _PageState();
}

class _PageState extends State<HyperSegmentedButtonPage> {
  Set<String> _view = {'列表'}, _formats = {'加粗'}, _sort = {'时间'};
  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    Widget section(String title, Widget child) =>
        DemoSection(title: title, child: child);
    final views = [
      const HyperSegment(
        value: '列表',
        label: '列表',
        icon: Icon(Icons.view_list_outlined),
      ),
      const HyperSegment(value: '网格', label: '网格', icon: Icon(Icons.grid_view)),
      const HyperSegment(value: '详情', label: '详情', enabled: false),
    ];
    return ListView(
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      children: [
        Align(
          alignment: AlignmentDirectional.topStart,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                section(
                  '单选、图标与禁用项',
                  HyperSegmentedButton(
                    segments: views,
                    selected: _view,
                    onSelectionChanged: (v) => setState(() => _view = v),
                  ),
                ),
                section(
                  '多选，可清空',
                  HyperSegmentedButton(
                    segments: const [
                      HyperSegment(value: '加粗', label: '加粗'),
                      HyperSegment(value: '斜体', label: '斜体'),
                      HyperSegment(value: '下划线', label: '下划线'),
                    ],
                    selected: _formats,
                    multiSelectionEnabled: true,
                    emptySelectionAllowed: true,
                    onSelectionChanged: (v) => setState(() => _formats = v),
                  ),
                ),
                section(
                  '等分宽度',
                  SizedBox(
                    width: 480,
                    child: HyperSegmentedButton(
                      segments: views,
                      selected: _view,
                      expanded: true,
                      onSelectionChanged: (v) => setState(() => _view = v),
                    ),
                  ),
                ),
                section(
                  '纵向',
                  HyperSegmentedButton(
                    direction: Axis.vertical,
                    segments: const [
                      HyperSegment(value: '时间', label: '按时间排序'),
                      HyperSegment(value: '名称', label: '按名称排序'),
                      HyperSegment(value: '大小', label: '按大小排序'),
                    ],
                    selected: _sort,
                    onSelectionChanged: (v) => setState(() => _sort = v),
                  ),
                ),
                section(
                  '局部主题与实例覆盖',
                  HyperSegmentedButtonTheme(
                    data: HyperSegmentedButtonThemeData(
                      style: HyperSegmentedButtonStyle(
                        selectedButton: HyperButtonStyle(
                          background: HyperFill.color(
                            HyperTheme.of(context).colors.primary,
                          ),
                          foregroundColor: HyperTheme.of(context)
                              .colors
                              .onPrimary,
                        ),
                      ),
                    ),
                    child: HyperSegmentedButton(
                      segments: views,
                      selected: _view,
                      showSeparators: false,
                      style: const HyperSegmentedButtonStyle(
                        group: HyperWidgetGroupStyle(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      ),
                      onSelectionChanged: (v) => setState(() => _view = v),
                    ),
                  ),
                ),
                section(
                  '整体禁用',
                  HyperSegmentedButton(
                    segments: views,
                    selected: _view,
                    enabled: false,
                    onSelectionChanged: (v) => setState(() => _view = v),
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
