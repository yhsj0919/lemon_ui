import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperTextAreaPage extends StatelessWidget {
  const HyperTextAreaPage({super.key});

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    children: [
      const HyperText('多行文本输入 · 未确认：内容可随输入增长；需要限制长度或占用空间时可显式配置。'),
      DemoSection(
        title: '默认 HyperTextArea',
        child: const HyperTextArea(
          label: '备注',
          hintText: '输入补充说明',
          showClearButton: true,
        ),
      ),
      DemoSection(
        title: '长度限制与计数',
        child: const HyperTextArea(
          label: '项目描述',
          hintText: '描述项目目标与背景',
          maxLength: 240,
          showCounter: true,
        ),
      ),
      DemoSection(title: 'Form 校验', child: const _TextAreaFormDemo()),
    ],
  );
}

class _TextAreaFormDemo extends StatefulWidget {
  const _TextAreaFormDemo();

  @override
  State<_TextAreaFormDemo> createState() => _TextAreaFormDemoState();
}

class _TextAreaFormDemoState extends State<_TextAreaFormDemo> {
  final controller = HyperFormController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HyperForm(
    controller: controller,
    child: HyperFormSection(
      children: [
        HyperTextAreaFormField(
          name: 'description',
          label: '申请说明',
          hintText: '请填写申请原因',
          requiredIndicator: true,
          validator: (value) =>
              value == null || value.trim().isEmpty ? '请填写申请原因' : null,
        ),
      ],
    ),
  );
}
