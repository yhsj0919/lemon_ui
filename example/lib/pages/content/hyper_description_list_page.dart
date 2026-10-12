import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperDescriptionListPage extends StatefulWidget {
  const HyperDescriptionListPage({super.key});
  @override
  State<HyperDescriptionListPage> createState() => _PageState();
}

class _PageState extends State<HyperDescriptionListPage> {
  int _columns = 3;
  bool _above = false;
  bool _enabled = true;
  final _items = const [
    HyperDescriptionItem(
      id: 'name',
      label: Text('名称'),
      value: Text('Lemon UI'),
    ),
    HyperDescriptionItem(id: 'version', label: Text('版本'), value: Text('开发中')),
    HyperDescriptionItem(id: 'status', label: Text('状态'), value: Text('已启用')),
    HyperDescriptionItem(
      id: 'description',
      label: Text('说明'),
      span: 2,
      value: Text('长文字按可用宽度自然换行。调整窗口宽度会减少列数，设备类别与主题尺寸保持不变。'),
    ),
    HyperDescriptionItem(id: 'missing', label: Text('备注')),
  ];
  @override
  Widget build(BuildContext context) {
    final size = HyperTheme.sizesOf(context);
    return ListView(
      padding: EdgeInsets.all(size.pageHorizontalPadding),
      children: [
        DemoSection(
          title: '列数、跨列与自然换行',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: size.descriptionList.columnSpacing,
                children: [
                  for (final columns in [1, 2, 3])
                    HyperButton.text(
                      label: Text('$columns 列'),
                      onPressed: () => setState(() => _columns = columns),
                    ),
                  HyperButton.text(
                    label: Text(_above ? '标签在上' : '标签在侧'),
                    onPressed: () => setState(() => _above = !_above),
                  ),
                  HyperButton.text(
                    label: const Text('切换状态动画'),
                    onPressed: () => setState(() => _enabled = !_enabled),
                  ),
                ],
              ),
              SizedBox(height: size.descriptionList.headerSpacing),
              HyperDescriptionList(
                columns: _columns,
                labelPlacement: _above
                    ? HyperDescriptionLabelPlacement.above
                    : HyperDescriptionLabelPlacement.inline,
                items: [
                  for (final item in _items)
                    if (item.id != 'status')
                      item
                    else
                      HyperDescriptionItem(
                        id: 'status',
                        label: const Text('状态'),
                        value: Text(
                          _enabled ? '已启用' : '已停用',
                          key: ValueKey(_enabled),
                        ),
                      ),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: '表格边框与不满一行',
          child: HyperDescriptionList(
            columns: _columns,
            bordered: true,
            labelPlacement: _above
                ? HyperDescriptionLabelPlacement.above
                : HyperDescriptionLabelPlacement.inline,
            items: [
              ..._items,
              const HyperDescriptionItem(
                id: 'owner',
                label: Text('负责人'),
                value: Text('陈'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: '自定义值与局部主题',
          child: HyperDescriptionListTheme(
            data: HyperDescriptionListThemeData(
              style: HyperDescriptionListStyle(
                labelStyle: TextStyle(
                  color: HyperTheme.of(context).colors.primary,
                ),
                placeholder: '未填写',
              ),
            ),
            child: HyperDescriptionList(
              title: const Text('项目资料'),
              extra: HyperButton.text(
                label: const Text('编辑'),
                onPressed: () {},
              ),
              items: [
                HyperDescriptionItem(
                  id: 'action',
                  label: const Text('操作'),
                  value: Wrap(
                    children: [
                      HyperButton.text(
                        label: const Text('查看详情'),
                        onPressed: () {},
                      ),
                      const Icon(Icons.check_circle_outline),
                    ],
                  ),
                ),
                const HyperDescriptionItem(id: 'empty', label: Text('联系方式')),
              ],
            ),
          ),
        ),
        DemoSection(
          title: '标签在上与显式背景覆盖',
          child: HyperDescriptionList(
            bordered: true,
            columns: 2,
            labelPlacement: HyperDescriptionLabelPlacement.above,
            style: HyperDescriptionListStyle(
              labelBackground: HyperFill.color(
                HyperTheme.of(context).colors.surfaceElevated,
              ),
              valueStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
            items: _items,
          ),
        ),
      ],
    );
  }
}
