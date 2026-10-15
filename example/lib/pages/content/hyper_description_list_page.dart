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
          title: '分组分割线与任意内容',
          child: HyperDescriptionList(
            columns: 2,
            items: [
              const HyperDescriptionItem(
                id: 'company',
                label: Text('物业公司'),
                value: Text('示例物业'),
              ),
              const HyperDescriptionItem(
                id: 'contact',
                label: Text('联系人'),
                value: Text('安安'),
              ),
              const HyperDescriptionItem.divider(id: 'section-divider'),
              const HyperDescriptionItem(
                id: 'maintenance',
                label: Text('维保公司'),
                value: Text('示例维保'),
              ),
              const HyperDescriptionItem(
                id: 'phone',
                label: Text('联系电话'),
                value: Text('13100000000'),
              ),
              HyperDescriptionItem.custom(
                id: 'custom-content',
                span: 2,
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text('现场照片'),
                    HyperButton.text(
                      onPressed: () {},
                      child: const Text('查看全部（1）'),
                    ),
                    const Icon(Icons.photo_outlined),
                  ],
                ),
              ),
              const HyperDescriptionItem(
                id: 'vertical',
                span: 2,
                labelPlacement: HyperDescriptionLabelPlacement.above,
                label: Text('备注（单项纵向）'),
                value: Text('单项标签布局独立，任意内容可使用 Row、Column、Wrap 等组合。'),
              ),
            ],
          ),
        ),
        SizedBox(height: size.sectionSpacing),
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
              SizedBox(height: size.compactSectionSpacing),
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
            child: HyperTitledCard(
              titlePosition: HyperCardTitlePosition.inside,
              cardStyle: HyperCardStyle(
                background: const HyperFill.none(),
                material: const HyperSurfaceMaterial.solid(),
                border: const Border(),
                boxShadow: const [],
              ),
              title: const Text('项目资料'),
              action: HyperButton.text(
                label: const Text('编辑'),
                onPressed: () {},
              ),
              child: HyperDescriptionList(
                items: [
                  HyperDescriptionItem(
                    id: 'action',
                    label: const Text('操作'),
                    value: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
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
