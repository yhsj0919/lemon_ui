import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lemon_ui/lemon_ui.dart';

class HyperTextFieldPage extends StatefulWidget {
  const HyperTextFieldPage({super.key});
  @override
  State<HyperTextFieldPage> createState() => _PageState();
}

class _PageState extends State<HyperTextFieldPage> {
  final _name = TextEditingController(text: 'Lemon');
  final _password = TextEditingController(text: '123');
  bool _showError = false, _reduced = false;
  String? _nameError, _passwordError;
  @override
  void dispose() {
    _name.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    Widget section(String title, List<Widget> fields) => Padding(
      padding: EdgeInsets.only(bottom: sizes.sectionSpacing),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          HyperText(title, variant: HyperTextVariant.sectionTitle),
          SizedBox(height: sizes.compactSectionSpacing),
          for (final field in fields)
            Padding(
              padding: EdgeInsets.only(bottom: sizes.compactSectionSpacing),
              child: field,
            ),
        ],
      ),
    );
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: _reduced),
      child: ListView(
        padding: EdgeInsets.all(sizes.pageHorizontalPadding),
        children: [
          Align(
            alignment: AlignmentDirectional.topStart,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 640),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  section('基本输入', [
                    const HyperTextField(
                      label: '名称',
                      hintText: '输入名称',
                      showClearButton: true,
                    ),
                    const HyperTextField(
                      hintText: '搜索文件',
                      leading: Icon(Icons.search),
                      showClearButton: true,
                      textInputAction: TextInputAction.search,
                    ),
                  ]),
                  section('错误提示：切换时不增加高度', [
                    HyperTextField(
                      initialValue: 'hello@example',
                      label: '邮箱',
                      leading: const Icon(Icons.mail_outline),
                      hintText: '输入邮箱地址',
                      showClearButton: true,
                      errorText: _showError
                          ? '邮箱地址格式不正确，请输入完整地址，例如 name@example.com。错误详情只在浮层中显示。'
                          : null,
                    ),
                    HyperButton.tonal(
                      label: Text(_showError ? '清除错误' : '显示错误'),
                      onPressed: () => setState(() => _showError = !_showError),
                    ),
                    const HyperText('悬停或点击尾部提示图标查看详情。无错误时不占用图标位置。'),
                    const HyperTextField(
                      hintText: '显式预留错误位置',
                      reserveErrorSpace: true,
                    ),
                  ]),
                  section('表单校验与密码', [
                    HyperTextField(
                      controller: _name,
                      label: '用户名',
                      showClearButton: true,
                      errorText: _nameError,
                      onChanged: (value) => setState(
                        () => _nameError = value.trim().isEmpty
                            ? '用户名不能为空'
                            : null,
                      ),
                    ),
                    HyperTextField(
                      controller: _password,
                      label: '密码',
                      obscureText: true,
                      showClearButton: true,
                      errorText: _passwordError,
                      autofillHints: const [AutofillHints.newPassword],
                    ),
                    HyperButton.filled(
                      label: const Text('校验'),
                      onPressed: () => setState(() {
                        _nameError = _name.text.trim().isEmpty
                            ? '用户名不能为空'
                            : null;
                        _passwordError = _password.text.length < 8
                            ? '密码至少需要 8 个字符'
                            : null;
                      }),
                    ),
                  ]),
                  section('字数与多行', [
                    const HyperTextField(
                      label: '标题',
                      maxLength: 20,
                      showCounter: true,
                      showClearButton: true,
                    ),
                    const HyperTextField(
                      label: '备注',
                      hintText: '输入多行备注',
                      minLines: 3,
                      maxLines: 5,
                      maxLength: 120,
                      showCounter: true,
                    ),
                    HyperTextField(
                      label: '数字',
                      hintText: '仅允许数字',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  ]),
                  section('高度、圆角与边框', [
                    const HyperTextField(
                      initialValue: '高度 28，字号保持不变',
                      style: HyperTextFieldStyle(
                        height: 28,
                        borderRadius: BorderRadius.all(Radius.circular(4)),
                        borderWidth: 1,
                      ),
                    ),
                    const HyperTextField(
                      initialValue: '设置高度 16，文字不足以放下时自然撑高',
                      style: HyperTextFieldStyle(
                        height: 16,
                        borderRadius: BorderRadius.all(Radius.circular(2)),
                        borderColor: Colors.teal,
                      ),
                    ),
                  ]),
                  section('只读和禁用', [
                    const HyperTextField(
                      initialValue: '只读内容，可选择复制',
                      readOnly: true,
                      showClearButton: true,
                    ),
                    const HyperTextField(
                      initialValue: '禁用内容',
                      enabled: false,
                      showClearButton: true,
                    ),
                  ]),
                  section('局部主题与实例覆盖', [
                    HyperTextFieldTheme(
                      data: const HyperTextFieldThemeData(
                        style: HyperTextFieldStyle(
                          background: HyperFill.color(Colors.white),
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        focused: HyperTextFieldStyle(borderColor: Colors.teal),
                        error: HyperTextFieldStyle(
                          borderColor: Colors.deepOrange,
                          errorIconColor: Colors.deepOrange,
                        ),
                      ),
                      child: const HyperTextField(
                        hintText: '自定义主题',
                        errorText: '可配置图标、浮层、字体和动效',
                        style: HyperTextFieldStyle(
                          errorIcon: Icons.info_outline,
                        ),
                      ),
                    ),
                    HyperTextField(
                      hintText: '自定义错误内容',
                      errorText: '无法保存',
                      errorBuilder: (context, error) => HyperCard(
                        child: Padding(
                          padding: EdgeInsets.all(sizes.compactSectionSpacing),
                          child: Text('提示：$error'),
                        ),
                      ),
                    ),
                    HyperSwitchListTile(
                      title: const Text('减少动画'),
                      value: _reduced,
                      onChanged: (value) => setState(() => _reduced = value),
                    ),
                  ]),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
