import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperFormActionsPage extends StatefulWidget {
  const HyperFormActionsPage({super.key});

  @override
  State<HyperFormActionsPage> createState() => _HyperFormActionsPageState();
}

class _HyperFormActionsPageState extends State<HyperFormActionsPage> {
  final controller = HyperFormController();
  String result = '尚未提交';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    children: [
      const HyperText('提交会先执行表单校验；重置恢复初始值；取消行为由调用方处理。'),
      DemoSection(
        title: '提交、重置与取消',
        child: HyperForm(
          controller: controller,
          child: HyperFormSection(
            children: [
              HyperTextFormField(
                name: 'name',
                label: '名称',
                hintText: '请输入名称',
                initialValue: 'Lemon',
                validator: (value) =>
                    value == null || value.trim().isEmpty ? '名称不能为空' : null,
              ),
              HyperTextFormField(
                name: 'description',
                label: '说明',
                hintText: '可选',
              ),
              HyperFormErrorSummary(controller: controller),
              HyperFormActions(
                controller: controller,
                onSubmit: (values) async {
                  await Future<void>.delayed(const Duration(milliseconds: 300));
                  if (!mounted) return;
                  setState(() => result = '已提交：$values');
                },
                onReset: () => setState(() => result = '已重置'),
                onCancel: () => setState(() => result = '已取消'),
              ),
              HyperText(result),
            ],
          ),
        ),
      ),
    ],
  );
}
