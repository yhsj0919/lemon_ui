import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

const _regions = [
  HyperCascaderNode(
    value: 'zhejiang',
    label: '浙江省',
    children: [
      HyperCascaderNode(
        value: 'hangzhou',
        label: '杭州市',
        children: [
          HyperCascaderNode(value: 'xihu', label: '西湖区'),
          HyperCascaderNode(value: 'yuhang', label: '余杭区'),
        ],
      ),
      HyperCascaderNode(
        value: 'ningbo',
        label: '宁波市',
        children: [HyperCascaderNode(value: 'haishu', label: '海曙区')],
      ),
    ],
  ),
  HyperCascaderNode(
    value: 'jiangsu',
    label: '江苏省',
    children: [
      HyperCascaderNode(
        value: 'nanjing',
        label: '南京市',
        children: [HyperCascaderNode(value: 'gulou', label: '鼓楼区')],
      ),
    ],
  ),
  HyperCascaderNode(value: 'unavailable', label: '暂不可选', enabled: false),
];

class HyperCascaderPage extends StatefulWidget {
  const HyperCascaderPage({super.key});
  @override
  State<HyperCascaderPage> createState() => _HyperCascaderPageState();
}

class _HyperCascaderPageState extends State<HyperCascaderPage> {
  List<String> _region = [], _remote = [], _local = [], _instance = [];
  bool _failNext = true;
  final _form = HyperFormController();
  String _submitted = '尚未提交';

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<List<HyperCascaderNode<String>>> _load(
    List<HyperCascaderNode<String>> path,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (_failNext) {
      _failNext = false;
      throw StateError('Demo 模拟首次失败');
    }
    return [
      HyperCascaderNode(value: '${path.last.value}-design', label: '设计组'),
      HyperCascaderNode(value: '${path.last.value}-engineering', label: '研发组'),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    return ListView(
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      children: [
        const HyperText('级联选择 · 未确认。桌面按菜单向右展开，手机使用多级联动滚轮；手机滚动后点确定提交，标题旁可清空。'),
        DemoSection(
          title: '默认主题 · 地区单选与清空',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HyperCascader<String>(
                nodes: _regions,
                value: _region,
                placeholder: '选择地区',
                onChanged: (value) => setState(() => _region = value),
              ),
              HyperText(_region.isEmpty ? '尚未选择' : _region.join(' → ')),
            ],
          ),
        ),
        DemoSection(
          title: '异步分支 · 首次失败后重试（本地模拟）',
          child: HyperCascader<String>(
            nodes: const [
              HyperCascaderNode(
                value: 'product',
                label: '产品部',
                hasChildren: true,
              ),
              HyperCascaderNode(
                value: 'platform',
                label: '平台部',
                hasChildren: true,
              ),
            ],
            value: _remote,
            onChanged: (value) => setState(() => _remote = value),
            loadChildren: _load,
            placeholder: '选择团队',
          ),
        ),
        DemoSection(
          title: 'Form · 必填校验、提交和重置（本地演示）',
          child: HyperForm(
            controller: _form,
            child: HyperFormSection(
              children: [
                HyperCascaderFormField<String>(
                  name: 'region',
                  label: '地区',
                  requiredIndicator: true,
                  nodes: _regions,
                  placeholder: '选择地区',
                  validator: (path) =>
                      path == null || path.isEmpty ? '请选择地区' : null,
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
                          setState(
                            () => _submitted =
                                '已提交：${(values['region'] as List<String>).join(' → ')}',
                          );
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
          title: '禁用 · 保留完整路径',
          child: HyperCascader<String>(
            nodes: _regions,
            value: ['zhejiang', 'hangzhou', 'xihu'],
            onChanged: null,
          ),
        ),
        DemoSection(
          title: '局部主题覆盖 · 仅替换分支图标',
          child: HyperCascaderTheme(
            data: const HyperCascaderThemeData(
              style: HyperCascaderStyle(branchIcon: Icons.arrow_forward),
            ),
            child: HyperCascader<String>(
              nodes: _regions,
              value: _local,
              onChanged: (value) => setState(() => _local = value),
            ),
          ),
        ),
        DemoSection(
          title: '实例 Style 覆盖 · 自定义面板表面、显式关闭阴影',
          child: HyperCascader<String>(
            nodes: _regions,
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
