import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperResultPage extends StatefulWidget {
  const HyperResultPage({super.key});
  @override
  State<HyperResultPage> createState() => _PageState();
}

class _PageState extends State<HyperResultPage> {
  HyperResultStatus _status = HyperResultStatus.success;
  bool _reduced = false;
  String get _title => switch (_status) {
    HyperResultStatus.empty => '暂无内容',
    HyperResultStatus.neutral => '处理完成',
    HyperResultStatus.success => '保存成功',
    HyperResultStatus.error => '保存失败',
    HyperResultStatus.warning => '需要确认',
    HyperResultStatus.info => '等待后续处理',
  };
  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    final colors = HyperTheme.of(context).colors;
    return ListView(
      padding: EdgeInsets.all(sizes.pageHorizontalPadding),
      children: [
        const DemoSection(
          title: '空状态（默认主题）',
          child: HyperResult.empty(description: '暂无内容时也使用统一结果组件。'),
        ),
        SizedBox(height: sizes.sectionSpacing),
        DemoSection(
          title: '受控状态与过渡',
          child: Column(
            children: [
              Wrap(
                spacing: sizes.result.actionSpacing,
                runSpacing: sizes.result.actionRunSpacing,
                children: [
                  for (final status in HyperResultStatus.values)
                    HyperButton.text(
                      label: Text(status.name),
                      onPressed: () => setState(() => _status = status),
                    ),
                  HyperButton.text(
                    label: Text(_reduced ? '恢复动画' : '减少动画'),
                    onPressed: () => setState(() => _reduced = !_reduced),
                  ),
                ],
              ),
              MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  disableAnimations:
                      _reduced || MediaQuery.of(context).disableAnimations,
                ),
                child: HyperResult(
                  status: _status,
                  title: _title,
                  description: '结果状态和操作由页面管理，调整窗口宽度时文字与按钮自然换行。',
                  actions: [
                    HyperButton.filled(
                      label: const Text('返回'),
                      onPressed: () =>
                          setState(() => _status = HyperResultStatus.neutral),
                    ),
                    if (_status == HyperResultStatus.error)
                      HyperButton.text(
                        label: const Text('重试'),
                        onPressed: () =>
                            setState(() => _status = HyperResultStatus.success),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
        DemoSection(
          title: '详情区与长文字',
          child: HyperResult(
            status: HyperResultStatus.warning,
            title: '部分内容未保存',
            description: '请核对以下信息。详细内容由调用方提供，结果页负责布局。',
            content: HyperDescriptionList(
              bordered: true,
              items: const [
                HyperDescriptionItem(
                  id: 'name',
                  label: Text('项目'),
                  value: Text('资料上传'),
                ),
                HyperDescriptionItem(
                  id: 'reason',
                  label: Text('原因'),
                  value: Text('当前网络不可用，请检查连接后再试。'),
                ),
              ],
            ),
            actions: [
              HyperButton.text(label: const Text('查看帮助'), onPressed: () {}),
            ],
          ),
        ),
        DemoSection(
          title: '自定义插图与局部主题',
          child: HyperResultTheme(
            data: HyperResultThemeData(
              style: HyperResultStyle(
                titleStyle: TextStyle(color: colors.primary),
              ),
              success: const HyperResultStyle(icon: Icons.verified_outlined),
            ),
            child: HyperResult(
              status: HyperResultStatus.success,
              illustration: const Icon(Icons.cloud_done_outlined),
              titleWidget: const Text('同步完成'),
              description: '自定义内容保留自身样式。',
              style: HyperResultStyle(
                border: Border.all(color: colors.outline),
                borderRadius: BorderRadius.circular(sizes.card.radius),
              ),
            ),
          ),
        ),
        DemoSection(
          title: '统一材质与实例覆盖',
          child: HyperResult(
            status: HyperResultStatus.info,
            title: '信息已提交',
            description: '局部开启材质复用统一渲染与降级策略。',
            style: HyperResultStyle(
              material: const HyperSurfaceMaterial.frostedGlass(),
              borderRadius: BorderRadius.circular(sizes.card.radius),
            ),
          ),
        ),
        const DemoSection(
          title: '无插图的简洁结果',
          child: HyperResult(
            showIllustration: false,
            title: '设置已更新',
            description: '可以独立关闭插图区。',
          ),
        ),
      ],
    );
  }
}
