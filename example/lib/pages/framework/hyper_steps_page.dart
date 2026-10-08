import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

class HyperStepsPage extends StatefulWidget {
  const HyperStepsPage({super.key});
  @override
  State<HyperStepsPage> createState() => _PageState();
}

class _PageState extends State<HyperStepsPage> {
  int _step = 1;
  bool _error = false, _vertical = false, _enabled = true;
  List<HyperStepItem> get _items => [
    const HyperStepItem(
      id: 'info',
      title: Text('填写信息'),
      description: Text('基本资料'),
    ),
    HyperStepItem(
      id: 'review',
      title: const Text('确认内容'),
      description: const Text('核对提交信息'),
      status: _error ? HyperStepStatus.error : null,
    ),
    const HyperStepItem(
      id: 'finish',
      title: Text('完成'),
      description: Text('保存结果'),
    ),
  ];
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
            SizedBox(height: sizes.stepIndicator.spacing),
          ],
        ],
      ),
    );
    return ListView(
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      children: [
        const HyperText('Steps', variant: HyperTextVariant.pageTitle),
        SizedBox(height: sizes.sectionSpacing),
        section('状态指示 · 横向与纵向', [
          HyperStepIndicator(items: _items, currentStep: _step),
          HyperStepIndicator(
            items: _items,
            currentStep: _step,
            direction: Axis.vertical,
          ),
          Wrap(
            spacing: sizes.stepIndicator.spacing,
            children: [
              HyperButton.text(
                label: const Text('上一步'),
                onPressed: _step > 0 ? () => setState(() => _step--) : null,
              ),
              HyperButton.text(
                label: Text(_step == _items.length ? '已全部完成' : '下一步'),
                onPressed: _step < _items.length
                    ? () => setState(() => _step++)
                    : null,
              ),
              HyperButton.text(
                label: Text(_error ? '清除错误' : '第二步错误'),
                onPressed: () => setState(() => _error = !_error),
              ),
            ],
          ),
        ]),
        section('受控步骤导航', [
          Wrap(
            spacing: sizes.stepperNavigation.spacing,
            children: [
              HyperButton.text(
                label: Text(_vertical ? '横向导航' : '纵向导航'),
                onPressed: () => setState(() => _vertical = !_vertical),
              ),
              HyperButton.text(
                label: Text(_enabled ? '禁用导航' : '启用导航'),
                onPressed: () => setState(() => _enabled = !_enabled),
              ),
            ],
          ),
          HyperStepperNavigation(
            items: _items,
            currentStep: _step,
            enabled: _enabled,
            direction: _vertical ? Axis.vertical : Axis.horizontal,
            onStepChanged: (index) => setState(() => _step = index),
          ),
          Text('当前索引：$_step。点击只更新页面状态，不触发提交或校验。'),
        ]),
        section('自定义图标、禁用与长文字', [
          const HyperStepperNavigation(
            currentStep: 0,
            direction: Axis.vertical,
            items: [
              HyperStepItem(
                id: 'account',
                title: Text('账号'),
                icon: Icon(Icons.person_outline),
              ),
              HyperStepItem(
                id: 'locked',
                title: Text('暂不可访问'),
                description: Text('禁用项由页面控制'),
                enabled: false,
              ),
              HyperStepItem(
                id: 'long',
                title: Text('较长的步骤名称会自然换行'),
                description: Text('描述支持多行，不会根据高度缩小字体。'),
              ),
            ],
          ),
        ]),
        section('局部主题独立覆盖', [
          HyperStepIndicatorTheme(
            data: const HyperStepIndicatorThemeData(
              completed: HyperStepStyle(
                nodeFill: HyperFill.color(Colors.green),
                foregroundColor: Colors.white,
              ),
              current: HyperStepStyle(
                nodeBorderRadius: BorderRadius.all(Radius.circular(8)),
              ),
            ),
            child: HyperStepIndicator(items: _items, currentStep: _step),
          ),
          const HyperStepIndicator(items: [], currentStep: 0),
        ]),
      ],
    );
  }
}
