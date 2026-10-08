import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

class HyperCollapsiblePage extends StatefulWidget {
  const HyperCollapsiblePage({super.key});
  @override
  State<HyperCollapsiblePage> createState() => _PageState();
}

class _PageState extends State<HyperCollapsiblePage> {
  bool _expanded = true, _horizontal = false, _multiple = false, _glass = false;
  Set<Object> _ids = {'general'};
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
            SizedBox(height: sizes.accordion.spacing),
          ],
        ],
      ),
    );
    return ListView(
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      children: [
        const HyperText(
          'Collapsible / Accordion',
          variant: HyperTextVariant.pageTitle,
        ),
        SizedBox(height: sizes.sectionSpacing),
        section('单项展开与状态保留', [
          HyperCollapsible(
            expanded: _expanded,
            onExpandedChanged: (value) => setState(() => _expanded = value),
            header: const Text('高级设置'),
            leading: const Icon(Icons.settings_outlined),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('默认保留内容状态，收起时隐藏内容并停止内部动画。'),
                TextField(
                  decoration: InputDecoration(hintText: '输入后收起再展开，文字仍保留'),
                ),
              ],
            ),
          ),
          const HyperCollapsible(
            expanded: false,
            header: Text('禁用面板'),
            enabled: false,
            child: Text('不能通过标题展开'),
          ),
        ]),
        section('单项互斥 / 多项展开', [
          HyperButton.text(
            label: Text(_multiple ? '切换互斥展开' : '切换多项展开'),
            onPressed: () => setState(() {
              _multiple = !_multiple;
              if (!_multiple && _ids.length > 1) {
                _ids = {_ids.first};
              }
            }),
          ),
          HyperAccordion(
            expandedIds: _ids,
            mode: _multiple
                ? HyperAccordionMode.multiple
                : HyperAccordionMode.single,
            onExpandedChanged: (value) => setState(() => _ids = value),
            items: const [
              HyperAccordionItem(
                id: 'general',
                header: Text('常规'),
                child: Text('常规设置内容'),
              ),
              HyperAccordionItem(
                id: 'privacy',
                header: Text('隐私'),
                child: Text('隐私设置内容'),
              ),
              HyperAccordionItem(
                id: 'archive',
                header: Text('归档'),
                child: Text('归档设置'),
                enabled: false,
              ),
            ],
          ),
        ]),
        section('横向内容区域', [
          HyperButton.text(
            label: Text(_horizontal ? '收起横向区域' : '展开横向区域'),
            onPressed: () => setState(() => _horizontal = !_horizontal),
          ),
          HyperCollapsible(
            expanded: _horizontal,
            axis: Axis.horizontal,
            child: SizedBox(
              width: sizes.loadingOverlay.maxContentWidth,
              child: const Text('横向改变内容裁切宽度；父布局需要允许宽度变化。无标题时，可由外部按钮控制。'),
            ),
          ),
        ]),
        section('局部主题、分隔线与统一材质', [
          HyperButton.text(
            label: Text(_glass ? '关闭磨砂材质' : '使用磨砂材质'),
            onPressed: () => setState(() => _glass = !_glass),
          ),
          HyperMaterialTheme(
            data: HyperMaterialThemeData(
              material: _glass
                  ? const HyperSurfaceMaterial.frostedGlass()
                  : const HyperSurfaceMaterial.solid(),
            ),
            child: HyperAccordionTheme(
              data: const HyperAccordionThemeData(
                style: HyperAccordionStyle(
                  showDividers: true,
                  itemTheme: HyperCollapsibleThemeData(
                    expanded: HyperCollapsibleStyle(
                      headerStyle: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    style: HyperCollapsibleStyle(
                      indicatorIcon: Icons.keyboard_arrow_down,
                    ),
                  ),
                ),
              ),
              child: HyperAccordion(
                mode: HyperAccordionMode.multiple,
                expandedIds: const {'details'},
                items: const [
                  HyperAccordionItem(
                    id: 'details',
                    header: Text('局部外观'),
                    child: Text('主题管理文字、图标、表面、间距和动画。'),
                  ),
                  HyperAccordionItem(
                    id: 'other',
                    header: Text('静态受控项'),
                    child: Text('未传回调时标题不响应切换。'),
                  ),
                ],
              ),
            ),
          ),
        ]),
      ],
    );
  }
}
