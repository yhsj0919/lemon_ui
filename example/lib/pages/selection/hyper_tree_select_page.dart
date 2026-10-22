import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

const _nodes = [
  HyperTreeSelectNode(
    value: 'product',
    label: '产品部',
    children: [
      HyperTreeSelectNode(value: 'design', label: '设计组'),
      HyperTreeSelectNode(value: 'research', label: '用户研究组'),
    ],
  ),
  HyperTreeSelectNode(
    value: 'platform',
    label: '平台部',
    children: [
      HyperTreeSelectNode(value: 'client', label: '客户端组'),
      HyperTreeSelectNode(value: 'service', label: '服务端组'),
    ],
  ),
  HyperTreeSelectNode(value: 'unavailable', label: '已停用团队', enabled: false),
];

class HyperTreeSelectPage extends StatefulWidget {
  const HyperTreeSelectPage({super.key});
  @override
  State<HyperTreeSelectPage> createState() => _HyperTreeSelectPageState();
}

class _HyperTreeSelectPageState extends State<HyperTreeSelectPage> {
  String? _value, _leaf, _remote, _local, _instance;
  bool _failNext = true;
  final _form = HyperFormController();
  String _submitted = '尚未提交';

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<List<HyperTreeSelectNode<String>>> _load(
    HyperTreeSelectNode<String> node,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (_failNext) {
      _failNext = false;
      throw StateError('Demo 模拟首次失败');
    }
    return [
      HyperTreeSelectNode(value: '${node.value}-design', label: '设计组'),
      HyperTreeSelectNode(value: '${node.value}-engineering', label: '研发组'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    return ListView(
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      children: [
        const HyperText('树形选择 · 未确认。桌面使用锚定下拉树，手机使用底部树面板；展开箭头与选择操作分开。'),
        DemoSection(
          title: '默认主题 · 单选与清空',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HyperTreeSelect<String>(
                nodes: _nodes,
                value: _value,
                placeholder: '选择团队或部门',
                onChanged: (value) => setState(() => _value = value),
              ),
              HyperText(_value ?? '尚未选择'),
            ],
          ),
        ),
        DemoSection(
          title: '仅叶节点 · 部门不可选',
          child: HyperTreeSelect<String>(
            nodes: _nodes,
            value: _leaf,
            leafOnly: true,
            placeholder: '选择具体团队',
            onChanged: (value) => setState(() => _leaf = value),
          ),
        ),
        DemoSection(
          title: '异步分支 · 首次失败后重试（本地模拟）',
          child: HyperTreeSelect<String>(
            nodes: const [
              HyperTreeSelectNode(
                value: 'remote',
                label: '远程团队',
                hasChildren: true,
              ),
            ],
            value: _remote,
            placeholder: '选择远程团队',
            loadChildren: _load,
            onChanged: (value) => setState(() => _remote = value),
          ),
        ),
        DemoSection(
          title: '表单 · 必填校验、提交和重置（本地演示）',
          child: HyperForm(
            controller: _form,
            child: HyperFormSection(
              children: [
                HyperTreeSelectFormField<String>(
                  name: 'team',
                  label: '团队',
                  requiredIndicator: true,
                  nodes: _nodes,
                  placeholder: '选择团队',
                  validator: (value) => value == null ? '请选择团队' : null,
                ),
                Wrap(
                  spacing: sizes.menu.padding,
                  runSpacing: sizes.menu.padding,
                  children: [
                    HyperButton.outlined(
                      onPressed: () {
                        _form.reset();
                        setState(() => _submitted = '尚未提交');
                      },
                      label: const Text('重置'),
                    ),
                    HyperButton.filled(
                      onPressed: () => _form.submit((values) {
                        if (mounted) {
                          setState(() => _submitted = '已提交：${values['team']}');
                        }
                      }),
                      label: const Text('提交'),
                    ),
                  ],
                ),
                HyperText(_submitted),
              ],
            ),
          ),
        ),
        const DemoSection(
          title: '禁用 · 保留当前值',
          child: HyperTreeSelect<String>(
            nodes: _nodes,
            value: 'design',
            onChanged: null,
          ),
        ),
        DemoSection(
          title: '局部主题覆盖 · 改变展开图标',
          child: HyperTreeSelectTheme(
            data: const HyperTreeSelectThemeData(
              style: HyperTreeSelectStyle(
                treeStyle: HyperTreeViewStyle(expandIcon: Icons.add),
              ),
            ),
            child: HyperTreeSelect<String>(
              nodes: _nodes,
              value: _local,
              onChanged: (value) => setState(() => _local = value),
            ),
          ),
        ),
        DemoSection(
          title: '实例 Style 覆盖 · 自定义面板表面、显式关闭阴影',
          child: HyperTreeSelect<String>(
            nodes: _nodes,
            value: _instance,
            onChanged: (value) => setState(() => _instance = value),
            surfaceStyle: HyperCardStyle(
              background: HyperFill.color(
                HyperTheme.of(context).colors.surface,
              ),
              boxShadow: const [],
            ),
          ),
        ),
      ],
    );
  }
}
