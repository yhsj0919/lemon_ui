import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

import '../../gallery/demo_section.dart';

class HyperFormPage extends StatelessWidget {
  const HyperFormPage({super.key});
  @override
  Widget build(BuildContext context) => ListView(
    padding: EdgeInsets.all(HyperTheme.sizesOf(context).pageHorizontalPadding),
    children: [
      const HyperText('横排指标签与控件的关系。布局与业务校验独立，日期、选择器等继续使用现有控件。'),
      DemoSection(title: '弹窗表单 · 确定时校验', child: const _ModalExamples()),
      for (final layout in HyperFieldLayout.values)
        DemoSection(
          title: switch (layout) {
            HyperFieldLayout.vertical => '竖排表单',
            HyperFieldLayout.horizontal => '横排表单',
            HyperFieldLayout.labelHidden => '无标题表单',
          },
          child: _FormExample(layout: layout),
        ),
    ],
  );
}

Widget _modalFields(BuildContext context) => HyperFormSection(
  children: [
    _contactsField(),
    HyperTextFormField(
      name: 'name',
      label: '姓名',
      hintText: '请输入姓名',
      requiredIndicator: true,
      validator: (v) => v == null || v.trim().isEmpty ? '请输入姓名' : null,
      description: '输入 admin 可查看异步校验；点击确定执行全部校验。',
      asyncValidator: (v) async {
        await Future<void>.delayed(const Duration(milliseconds: 300));
        return v == 'admin' ? '该姓名已被使用' : null;
      },
    ),
    HyperSelectFormField<String>(
      name: 'role',
      label: '角色',
      initialValue: 'member',
      options: const [
        HyperSelectOption(value: 'member', label: '成员'),
        HyperSelectOption(value: 'owner', label: '管理员'),
      ],
    ),
    HyperRadioFormField<String>(
      name: 'contact',
      label: '联系渠道',
      initialValue: 'message',
      options: const [
        HyperSelectOption(value: 'message', label: '站内消息'),
        HyperSelectOption(value: 'email', label: '邮件'),
      ],
    ),
    HyperCheckboxFormField(
      name: 'agreement',
      label: '接受协议',
      requiredIndicator: true,
      validator: (v) => v == true ? null : '请先接受协议',
    ),
    HyperSwitchFormField(name: 'notification', label: '接收通知'),
  ],
);

class _ModalExamples extends StatefulWidget {
  const _ModalExamples();
  @override
  State<_ModalExamples> createState() => _ModalExamplesState();
}

class _ModalExamplesState extends State<_ModalExamples> {
  HyperFieldLayout layout = HyperFieldLayout.vertical;
  bool fail = false;
  String result = '尚未打开弹窗';

  Future<void> open(bool sheet) async {
    final submitFails = fail;
    final show = sheet ? showHyperFormBottomSheet : showHyperFormDialog;
    final values = await show(
      context: context,
      title: const Text('编辑资料'),
      layout: layout,
      builder: _modalFields,
      onSubmit: (_) async {
        await Future<void>.delayed(const Duration(milliseconds: 600));
        if (submitFails) throw StateError('模拟保存失败，输入内容已保留');
      },
    );
    if (!mounted) return;
    setState(() => result = values == null ? '已取消，未提交' : '提交成功：$values');
  }

  @override
  Widget build(BuildContext context) => HyperFormSection(
    children: [
      HyperSelect<HyperFieldLayout>(
        value: layout,
        options: const [
          HyperSelectOption(value: HyperFieldLayout.vertical, label: '竖排'),
          HyperSelectOption(value: HyperFieldLayout.horizontal, label: '横排'),
          HyperSelectOption(value: HyperFieldLayout.labelHidden, label: '无标题'),
        ],
        onChanged: (v) {
          if (v != null) setState(() => layout = v);
        },
      ),
      Row(
        children: [
          HyperSwitch(value: fail, onChanged: (v) => setState(() => fail = v)),
          const Expanded(child: Text('模拟提交失败（下次打开生效）')),
        ],
      ),
      Wrap(
        spacing: HyperTheme.sizesOf(context).form.gap,
        runSpacing: HyperTheme.sizesOf(context).form.gap,
        children: [
          HyperButton.outlined(
            onPressed: () => open(false),
            child: const Text('打开 Dialog 表单'),
          ),
          HyperButton.outlined(
            onPressed: () => open(true),
            child: const Text('打开底部表单'),
          ),
        ],
      ),
      HyperText(result),
    ],
  );
}

HyperFormListField<String> _contactsField() => HyperFormListField<String>(
  name: 'contacts',
  label: '联系人（动态列表）',
  description: '最多三项，每项独立校验；重置恢复初始条目。',
  initialValue: const [''],
  maximumItems: 3,
  createItem: () => '',
  itemValidator: (v, _) => v.trim().isEmpty ? '请输入联系人' : null,
  itemBuilder: (context, item) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: HyperTextField(
          initialValue: item.value,
          hintText: '联系人 ${item.index + 1}',
          enabled: item.enabled,
          errorText: item.errorText,
          onChanged: item.onChanged,
        ),
      ),
      SizedBox(width: HyperTheme.sizesOf(context).form.gap),
      HyperButton.text(onPressed: item.remove, child: const Text('删除')),
    ],
  ),
);

class _FormExample extends StatefulWidget {
  const _FormExample({required this.layout});
  final HyperFieldLayout layout;
  @override
  State<_FormExample> createState() => _FormExampleState();
}

class _FormExampleState extends State<_FormExample> {
  late final controller = HyperFormController(
    crossValidators: [
      (values) => values['password'] == values['confirm']
          ? {}
          : {'confirm': '两次密码输入不一致'},
    ],
  );
  bool fail = false;
  String? result;
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HyperForm(
    controller: controller,
    layout: widget.layout,
    child: HyperFormSection(
      children: [
        HyperTextFormField(
          name: 'username',
          label: '用户名',
          semanticLabel: '用户名',
          hintText: '输入用户名',
          requiredIndicator: true,
          description: '输入 admin 后提交可查看异步校验错误。',
          validator: (v) => v == null || v.trim().isEmpty ? '请输入用户名' : null,
          asyncValidator: (v) async {
            await Future<void>.delayed(const Duration(milliseconds: 300));
            return v == 'admin' ? '该用户名已被使用' : null;
          },
        ),
        HyperTextFormField(
          name: 'password',
          label: '密码',
          hintText: '输入密码',
          obscureText: true,
          validator: (v) => (v?.length ?? 0) < 4 ? '至少输入四个字符' : null,
        ),
        HyperTextFormField(
          name: 'confirm',
          label: '确认密码',
          hintText: '再次输入密码',
          obscureText: true,
        ),
        HyperSelectFormField<String>(
          name: 'role',
          label: '角色',
          initialValue: 'member',
          options: const [
            HyperSelectOption(value: 'member', label: '成员'),
            HyperSelectOption(value: 'owner', label: '管理员'),
          ],
        ),
        HyperMultiSelectFormField<String>(
          name: 'tags',
          label: '关注主题',
          description: '至少选择一项，最多两项；可取消选择。',
          minimumSelection: 1,
          maximumSelection: 2,
          options: const [
            HyperSelectOption(value: 'design', label: '设计'),
            HyperSelectOption(value: 'code', label: '开发'),
            HyperSelectOption(value: 'test', label: '测试'),
          ],
        ),
        HyperCheckboxGroupFormField<String>(
          name: 'channels',
          label: '通知渠道',
          description: '至少选择一项，最多两项。',
          minimumSelection: 1,
          maximumSelection: 2,
          options: const [
            HyperSelectOption(value: 'message', label: '站内信'),
            HyperSelectOption(value: 'email', label: '邮件'),
            HyperSelectOption(value: 'sms', label: '短信'),
          ],
        ),
        HyperAutocompleteFormField<String>(
          name: 'city',
          label: '城市自动完成',
          placeholder: '输入城市搜索',
          options: const [
            HyperSelectOption(value: 'beijing', label: '北京'),
            HyperSelectOption(value: 'shanghai', label: '上海'),
          ],
        ),
        HyperMultiAutocompleteFormField<String>(
          name: 'skills',
          label: '技能自动完成（多选）',
          maximumSelection: 2,
          options: const [
            HyperSelectOption(value: 'dart', label: 'Dart'),
            HyperSelectOption(value: 'flutter', label: 'Flutter'),
          ],
        ),
        _contactsField(),
        HyperNumberFormField(
          name: 'quantity',
          label: '数量',
          minimum: 0,
          maximum: 100,
          precision: 0,
          hintText: '请输入数量',
          validator: (v) => v == null ? '请输入数量' : null,
        ),
        HyperSliderFormField(
          name: 'volume',
          label: '音量',
          min: 0,
          max: 100,
          initialValue: 30,
          divisions: 10,
          labelBuilder: (v) => '${v.round()}',
          validator: (v) => (v ?? 0) < 10 ? '音量至少为 10' : null,
        ),
        HyperRangeSliderFormField(
          name: 'budget',
          label: '预算范围',
          min: 0,
          max: 100,
          initialValue: const RangeValues(20, 80),
          divisions: 10,
          labelsBuilder: (v) =>
              RangeLabels('${v.start.round()}', '${v.end.round()}'),
          validator: (v) =>
              v != null && v.end - v.start < 20 ? '范围至少跨越 20' : null,
        ),
        HyperDateFormField(name: 'date', label: '预约日期'),
        HyperTimeFormField(name: 'time', label: '预约时间', minuteInterval: 15),
        HyperDateTimeFormField(
          name: 'dateTime',
          label: '日期和时间',
          showSeconds: true,
        ),
        HyperDateTimeRangeFormField(
          name: 'dateRange',
          label: '日期范围',
          mode: HyperDateTimePickerMode.date,
        ),
        HyperDateTimeRangeFormField(
          name: 'timeRange',
          label: '时间范围',
          mode: HyperDateTimePickerMode.time,
        ),
        HyperDateTimeRangeFormField(name: 'dateTimeRange', label: '日期时间范围'),
        HyperCheckboxFormField(
          name: 'agreement',
          label: '接受协议',
          initialValue: false,
          requiredIndicator: true,
          validator: (v) => v == true ? null : '请先接受协议',
        ),
        HyperRadioFormField<String>(
          name: 'notification',
          label: '通知方式',
          initialValue: 'message',
          options: const [
            HyperSelectOption(value: 'message', label: '站内消息'),
            HyperSelectOption(value: 'email', label: '邮件'),
          ],
        ),
        HyperSwitchFormField(name: 'subscription', label: '订阅更新'),
        Row(
          children: [
            HyperSwitch(
              value: fail,
              onChanged: (v) => setState(() => fail = v),
            ),
            const Expanded(child: Text('模拟提交失败，保留编辑内容')),
          ],
        ),
        HyperFormErrorSummary(controller: controller),
        ListenableBuilder(
          listenable: controller,
          builder: (context, child) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HyperText(
                '已修改：${controller.isDirty ? '是' : '否'} · 已编辑 ${controller.touchedFields.length} 项',
              ),
              Wrap(
                spacing: HyperTheme.sizesOf(context).form.gap,
                runSpacing: HyperTheme.sizesOf(context).form.gap,
                children: [
                  HyperButton.outlined(
                    onPressed: () {
                      controller.reset();
                      setState(() => result = null);
                    },
                    child: const Text('重置'),
                  ),
                  HyperButton.text(
                    onPressed: controller.markClean,
                    child: const Text('标记为已保存'),
                  ),
                  HyperButton.filled(
                    loading: controller.isSubmitting,
                    onPressed: () async {
                      try {
                        await controller.submit((values) async {
                          await Future<void>.delayed(
                            const Duration(milliseconds: 300),
                          );
                          if (fail) throw StateError('提交失败，请重试');
                          if (mounted) {
                            setState(
                              () => result = '提交成功：${values['username']}',
                            );
                          }
                        });
                      } catch (_) {
                        /* Controller preserves error for the summary. */
                      }
                    },
                    child: const Text('提交'),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (result != null) HyperText(result!),
      ],
    ),
  );
}
