import '../content/inline_edit_description_demo.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

@Preview(name: '行内编辑', group: '输入控件', size: Size(360, 640))
Widget inlineEditPreview() => MaterialApp(
  home: HyperTheme(
    data: HyperThemeData.light(),
    child: const Scaffold(body: HyperInlineEditPage()),
  ),
);

class HyperInlineEditPage extends StatefulWidget {
  const HyperInlineEditPage({super.key});
  @override
  State<HyperInlineEditPage> createState() => _HyperInlineEditPageState();
}

class _HyperInlineEditPageState extends State<HyperInlineEditPage> {
  String name = '双击编辑名称', description = '长按或双击编辑描述。', remote = '异步保存内容';
  bool fail = true;
  bool flag = false;
  double? count = 3;
  String details = '这段内容需要在弹窗中编辑。';

  Widget _section({
    required String title,
    required Widget child,
  }) => DemoSection(
    title: title,
    child: SizedBox(
      key: ValueKey('inline-edit-preview-$title'),
      // Demo layout only: reserve three control rows for editor/actions/error.
      // Long drafts and large text scroll inside rather than moving later demos.
      height: HyperTheme.sizesOf(context).textField.minimumHeight * 3,
      width: double.infinity,
      child: SingleChildScrollView(child: child),
    ),
  );
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    children: [
      const HyperText(
        '行内编辑。悬停显示可编辑手形，双击或长按编辑，点击区域外或失焦保存，Esc 取消。多行 Enter 换行。预览区高度固定，长内容内部滚动；复杂内容可直接打开弹窗编辑。',
      ),
      _section(
        title: '默认 · 单行与校验',
        child: HyperInlineEdit.text(
          showActions: false,
          value: name,
          onSaved: (value) => setState(() => name = value),
          validator: (value) => value.trim().isEmpty ? '名称不能为空' : null,
        ),
      ),
      _section(
        title: '默认 · 多行',
        child: HyperInlineEdit.text(
          value: description,
          multiline: true,
          showActions: false,
          onSaved: (value) => setState(() => description = value),
        ),
      ),
      _section(
        title: '默认 · 异步保存与失败重试（首次保存失败）',
        child: HyperInlineEdit.text(
          value: remote,
          showActions: false,
          onSaved: (value) async {
            await Future<void>.delayed(const Duration(milliseconds: 500));
            if (fail) {
              fail = false;
              throw StateError('示例保存失败');
            }
            if (mounted) setState(() => remote = value);
          },
        ),
      ),
      _section(
        title: '默认 · 自定义编辑器（开关）',
        child: HyperInlineEdit<bool>(
          value: flag,
          commitOnChanged: true,
          showActions: false,
          displayBuilder: (_, value) => HyperText(value ? '已开启' : '已关闭'),
          editorBuilder: (_, details) =>
              HyperSwitch(value: details.value, onChanged: details.onChanged),
          onSaved: (value) => setState(() => flag = value),
        ),
      ),
      _section(
        title: '自定义就地编辑 · 数字输入（失焦保存、Esc 取消）',
        child: HyperInlineEdit<double?>(
          value: count,
          showActions: false,
          displayBuilder: (_, value) => HyperText('数量：${value?.toInt() ?? 0}'),
          editorBuilder: (_, edit) => HyperNumberInput(
            value: edit.value,
            focusNode: edit.focusNode,
            onChanged: edit.onChanged,
            enabled: !edit.saving,
            minimum: 0,
            precision: 0,
          ),
          onSaved: (value) => setState(() => count = value),
        ),
      ),
      _section(
        title: '自定义弹窗编辑 · 页面只保留摘要',
        child: HyperInlineEdit<String>.dialog(
          value: details,
          displayBuilder: (_, value) => HyperText(value.split('\n').first),
          dialogBuilder: (context, value) => showHyperDialog<String>(
            context: context,
            builder: (_) => InlineEditDetailsDialog(value: value),
          ),
          onSaved: (value) => setState(() => details = value),
        ),
      ),
      _section(
        title: '禁用',
        child: HyperInlineEdit.text(
          value: '不可编辑',
          enabled: false,
          onSaved: (_) {},
        ),
      ),
      _section(
        title: '局部主题覆盖 · 展示文字颜色（非默认）',
        child: HyperInlineEditTheme(
          data: HyperInlineEditThemeData(
            style: HyperInlineEditStyle(
              displayStyle: TextStyle(
                color: HyperTheme.of(context).colors.primary,
              ),
            ),
          ),
          child: HyperInlineEdit.text(
            showActions: false,
            value: name,
            onSaved: (value) => setState(() => name = value),
          ),
        ),
      ),
      _section(
        title: '实例 Style 覆盖 · 无切换动画（非默认）',
        child: HyperInlineEdit.text(
          value: name,
          showActions: false,
          onSaved: (value) => setState(() => name = value),
          style: const HyperInlineEditStyle(transitionDuration: Duration.zero),
        ),
      ),
      const DemoSection(
        title: '组合示例 · 紧凑描述列表（布局覆盖）',
        child: InlineEditDescriptionDemo(),
      ),
    ],
  );
}
