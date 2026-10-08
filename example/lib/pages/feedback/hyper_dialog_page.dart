import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperDialogPage extends StatefulWidget {
  const HyperDialogPage({super.key});
  @override
  State<HyperDialogPage> createState() => _HyperDialogPageState();
}

class _HyperDialogPageState extends State<HyperDialogPage> {
  String _result = '尚未操作';
  bool _reduced = false;

  Future<void> _open(
    BuildContext context, {
    HyperDialogStyle? style,
    bool longContent = false,
    bool dismissible = true,
  }) async {
    final result = await showHyperDialog<String>(
      context: context,
      style: style,
      barrierDismissible: dismissible,
      builder: (dialogContext) => HyperDialog(
        title: const Text('确认操作'),
        content: Text(
          longContent
              ? List.generate(
                  24,
                  (i) => '第 ${i + 1} 段：正文过长时可以滚动，标题和按钮保持可见。',
                ).join('\n\n')
              : 'Dialog 承载任意内容，按钮的点击与业务状态由调用方管理。',
        ),
        actions: [
          HyperButton.tonal(
            label: const Text('取消'),
            onPressed: () => Navigator.of(dialogContext).pop('取消'),
          ),
          HyperButton.filled(
            label: const Text('确认'),
            onPressed: () => Navigator.of(dialogContext).pop('确认'),
          ),
        ],
      ),
    );
    if (mounted) setState(() => _result = result ?? '已关闭');
  }

  Future<void> _asyncDemo(BuildContext context) async {
    var attempt = 0;
    String? error;
    await showHyperDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, update) => HyperDialog(
          showCloseButton: false,
          title: const Text('异步操作'),
          content: Text(error ?? '首次操作模拟失败，再次操作成功。按钮执行期间自动锁定重复点击。'),
          actions: [
            HyperButton.tonal(
              label: const Text('取消'),
              onPressed: () => Navigator.of(dialogContext).pop(),
            ),
            HyperButton.filled(
              label: Text(error == null ? '开始' : '重试'),
              onPressed: () async {
                await Future<void>.delayed(const Duration(seconds: 1));
                if (!dialogContext.mounted) return;
                if (attempt++ == 0) {
                  update(() => error = '模拟失败，请重试。');
                } else {
                  Navigator.of(dialogContext).pop();
                  if (mounted) setState(() => _result = '异步操作成功');
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    final theme = HyperTheme.of(context);
    Widget section(String title, Widget child) =>
        DemoSection(title: title, child: child);
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: _reduced),
      child: Builder(
        builder: (context) => ListView(
          padding: EdgeInsets.all(sizes.pageHorizontalPadding),
          children: [
            const HyperText('Dialog', variant: HyperTextVariant.pageTitle),
            SizedBox(height: sizes.sectionSpacing),
            section(
              '默认与关闭规则',
              Wrap(
                spacing: sizes.dialog.actionSpacing,
                runSpacing: sizes.dialog.actionRunSpacing,
                children: [
                  HyperButton.filled(
                    label: const Text('默认对话框'),
                    onPressed: () => _open(context),
                  ),
                  HyperButton.tonal(
                    label: const Text('禁用遮罩关闭'),
                    onPressed: () => _open(context, dismissible: false),
                  ),
                  HyperButton.tonal(
                    label: const Text('长正文'),
                    onPressed: () => _open(context, longContent: true),
                  ),
                ],
              ),
            ),
            Text('结果：$_result'),
            SizedBox(height: sizes.sectionSpacing),
            section(
              '九宫格弹出位置',
              Wrap(
                spacing: sizes.dialog.actionSpacing,
                runSpacing: sizes.dialog.actionRunSpacing,
                children: [
                  for (final (label, alignment) in const [
                    ('左上', AlignmentDirectional.topStart),
                    ('上中', Alignment.topCenter),
                    ('右上', AlignmentDirectional.topEnd),
                    ('左中', AlignmentDirectional.centerStart),
                    ('居中', Alignment.center),
                    ('右中', AlignmentDirectional.centerEnd),
                    ('左下', AlignmentDirectional.bottomStart),
                    ('下中', Alignment.bottomCenter),
                    ('右下', AlignmentDirectional.bottomEnd),
                  ])
                    HyperButton.outlined(
                      label: Text(label),
                      onPressed: () => _open(
                        context,
                        style: HyperDialogStyle(alignment: alignment),
                      ),
                    ),
                ],
              ),
            ),
            section(
              '边框、圆角与纵向按钮',
              HyperButton.tonal(
                label: const Text('打开自定义样式'),
                onPressed: () => _open(
                  context,
                  style: HyperDialogStyle(
                    border: Border.all(color: theme.colors.primary, width: 2),
                    borderRadius: BorderRadius.circular(8),
                    actionsDirection: Axis.vertical,
                    buttonTheme: HyperButtonThemeData(
                      style: HyperButtonStyle(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            section(
              '局部主题跨路由保留',
              HyperDialogTheme(
                data: HyperDialogThemeData(
                  style: HyperDialogStyle(
                    background: HyperFill.color(theme.colors.surfaceMuted),
                    border: Border.all(color: Colors.teal),
                    borderRadius: BorderRadius.circular(12),
                    titleStyle: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.teal,
                    ),
                  ),
                ),
                child: Builder(
                  builder: (localContext) => HyperButton.tonal(
                    label: const Text('打开局部主题对话框'),
                    onPressed: () => _open(localContext),
                  ),
                ),
              ),
            ),
            section(
              '可替换进出场动画',
              HyperButton.tonal(
                label: const Text('只淡入淡出'),
                onPressed: () => _open(
                  context,
                  style: HyperDialogStyle(
                    transitionBuilder: (
                      context,
                      animation,
                      secondaryAnimation,
                      child,
                    ) => FadeTransition(opacity: animation, child: child),
                  ),
                ),
              ),
            ),
            section(
              '自由内容与操作区',
              HyperButton.tonal(
                label: const Text('打开自定义内容'),
                onPressed: () => showHyperDialog<void>(
                  context: context,
                  builder: (dialogContext) => HyperDialog(
                    title: const Text('自由组合'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const HyperAvatar(icon: Icon(Icons.groups_outlined)),
                        SizedBox(height: sizes.dialog.titleSpacing),
                        const Text('图片、列表和组合控件都可作为正文。'),
                      ],
                    ),
                    actions: [
                      const HyperTag(label: '预览'),
                      HyperButton.filled(
                        label: const Text('完成'),
                        onPressed: () => Navigator.of(dialogContext).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            section(
              '异步操作与重试',
              HyperButton.tonal(
                label: const Text('打开异步示例'),
                onPressed: () => _asyncDemo(context),
              ),
            ),
            HyperSwitchListTile(
              title: const Text('减少动画'),
              value: _reduced,
              onChanged: (value) => setState(() => _reduced = value),
            ),
          ],
        ),
      ),
    );
  }
}
