import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// Business composition shared by the inline editor and description gallery.
class InlineEditDescriptionDemo extends StatefulWidget {
  const InlineEditDescriptionDemo({super.key});
  @override
  State<InlineEditDescriptionDemo> createState() =>
      _InlineEditDescriptionDemoState();
}

class _InlineEditDescriptionDemoState extends State<InlineEditDescriptionDemo> {
  String name = '示例项目', note = '双击修改项目备注。', details = '详细内容在弹窗中编辑。';
  bool enabled = true;
  double requestedRowHeight = 32;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context), sizes = HyperTheme.sizesOf(context);
    final label = TextPainter(
      text: TextSpan(text: '详细内容', style: theme.textTheme.bodyMedium),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final labelWidth = label.width.ceilToDouble();
    final labelHeight = label.height;
    label.dispose();
    final line = TextPainter(
      text: TextSpan(text: '备注', style: theme.textTheme.labelLarge),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final input = HyperTextFieldTheme.of(context)
        .resolve({HyperControlState.focused});
    final borderVertical =
        input.border?.dimensions.resolve(Directionality.of(context)).vertical ??
        (input.borderWidth ?? 1) * 2;
    final inputHeight = line.height + borderVertical;
    final contentHeight =
        (inputHeight > labelHeight ? inputHeight : labelHeight).ceilToDouble();
    line.dispose();
    final uniformRowHeight = contentHeight > requestedRowHeight
        ? contentHeight
        : requestedRowHeight;
    // Row spacing is independent of the compact editor's minimum height.
    final editorHeight = contentHeight > 32 ? contentHeight : 32.0;
    // One shared row height for every value, including switches and text editors.
    Widget cell(String id, Widget child) => SizedBox(
      key: ValueKey(id),
      height: uniformRowHeight,
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: uniformRowHeight),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            heightFactor: 1,
            child: child,
          ),
        ),
      ),
    );
    return HyperInlineEditTheme(
      data: HyperInlineEditThemeData(
        style: HyperInlineEditStyle(
          inputStyle: HyperTextFieldStyle(
            minimumHeight: editorHeight,
            height: editorHeight,
            padding: EdgeInsets.symmetric(
              horizontal: sizes.textField.horizontalPadding,
            ),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: sizes.form.gap,
            runSpacing: sizes.form.gap,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const HyperText('统一行高'),
              SizedBox(
                width: sizes.form.minimumControlWidth,
                child: HyperNumberInput(
                  key: const ValueKey('description-row-height'),
                  value: requestedRowHeight,
                  minimum: 32,
                  precision: 0,
                  step: 1,
                  onChanged: (value) {
                    if (value != null) {
                      setState(
                        () => requestedRowHeight = value.roundToDouble(),
                      );
                    }
                  },
                ),
              ),
              HyperText('逻辑像素 · 最低 32 · 当前 ${uniformRowHeight.toInt()}'),
            ],
          ),
          SizedBox(height: sizes.form.gap),
          HyperDescriptionList(
            style: HyperDescriptionListStyle(
              cellPadding: EdgeInsets.zero,
              rowSpacing: 0,
              labelWidth: labelWidth,
              labelValueSpacing: sizes.form.gap,
            ),
            items: [
              HyperDescriptionItem(
                id: 'editable-name',
                label: const HyperText('项目名称'),
                value: cell(
                  'description-name-row',
                  HyperInlineEdit.text(
                    key: const ValueKey('description-edit-name'),
                    value: name,
                    displayBuilder: (_, value) => HyperText(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    showActions: false,
                    onSaved: (value) => setState(() => name = value),
                  ),
                ),
              ),
              HyperDescriptionItem(
                id: 'editable-note',
                label: const HyperText('项目备注'),
                value: cell(
                  'description-note-viewport',
                  HyperInlineEdit.text(
                    key: const ValueKey('description-edit-note'),
                    value: note,
                    displayBuilder: (_, value) => HyperText(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    multiline: true,
                    showActions: false,
                    onSaved: (value) => setState(() => note = value),
                  ),
                ),
              ),
              HyperDescriptionItem(
                id: 'editable-enabled',
                label: const HyperText('启用状态'),
                value: cell(
                  'description-state-row',
                  HyperInlineEdit<bool>(
                    key: const ValueKey('description-edit-enabled'),
                    value: enabled,
                    commitOnChanged: true,
                    showActions: false,
                    displayBuilder: (_, value) =>
                        HyperText(value ? '已启用' : '已停用'),
                    editorBuilder: (_, edit) => SizedBox(
                      height: uniformRowHeight,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: AlignmentDirectional.centerStart,
                        child: HyperSwitch(
                          value: edit.value,
                          onChanged: edit.onChanged,
                          style: HyperSwitchStyle(
                            minimumTapTargetSize: uniformRowHeight,
                          ),
                        ),
                      ),
                    ),
                    onSaved: (value) => setState(() => enabled = value),
                  ),
                ),
              ),
              HyperDescriptionItem(
                id: 'editable-details',
                label: const HyperText('详细内容'),
                value: cell(
                  'description-details-row',
                  HyperInlineEdit<String>.dialog(
                    key: const ValueKey('description-edit-details'),
                    value: details,
                    displayBuilder: (_, value) =>
                        HyperText(value.split('\n').first),
                    dialogBuilder: (context, value) => showHyperDialog<String>(
                      context: context,
                      builder: (_) => InlineEditDetailsDialog(value: value),
                    ),
                    onSaved: (value) => setState(() => details = value),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InlineEditDetailsDialog extends StatefulWidget {
  const InlineEditDetailsDialog({super.key, required this.value});
  final String value;
  @override
  State<InlineEditDetailsDialog> createState() =>
      _InlineEditDetailsDialogState();
}

class _InlineEditDetailsDialogState extends State<InlineEditDetailsDialog> {
  late final controller = TextEditingController(text: widget.value);
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => CallbackShortcuts(
    bindings: {
      const SingleActivator(LogicalKeyboardKey.escape): () =>
          Navigator.of(context).pop(),
    },
    child: HyperDialog(
      title: const HyperText('编辑项目详细内容'),
      content: HyperTextArea(controller: controller, autofocus: true),
      actions: [
        HyperButton.text(
          onPressed: () => Navigator.of(context).pop(),
          label: const Text('取消'),
        ),
        HyperButton.filled(
          onPressed: () => Navigator.of(context).pop(controller.text),
          label: const Text('保存'),
        ),
      ],
    ),
  );
}
