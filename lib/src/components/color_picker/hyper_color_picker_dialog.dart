import 'package:flutter/material.dart';

import '../button/hyper_button.dart';
import '../dialog/hyper_dialog.dart';
import '../dialog/hyper_dialog_style.dart';
import 'hyper_color_picker.dart';
import 'hyper_color_picker_style.dart';

/// 打开选色弹窗；仅确认时返回颜色，取消或关闭返回 null。
Future<Color?> showHyperColorPickerDialog({
  required BuildContext context,
  required Color initialColor,
  Widget? title,
  bool showAlpha = true,
  List<Color> recommendedColors = const [],
  HyperColorPickerStyle? pickerStyle,
  HyperDialogStyle? dialogStyle,
  String confirmLabel = '确定',
  String cancelLabel = '取消',
  bool barrierDismissible = true,
  bool? useRootNavigator,
}) => showHyperDialog<Color>(
  context: context,
  style: dialogStyle,
  barrierDismissible: barrierDismissible,
  useRootNavigator: useRootNavigator,
  builder: (_) => HyperColorPickerDialog(
    initialColor: initialColor,
    title: title,
    showAlpha: showAlpha,
    recommendedColors: recommendedColors,
    pickerStyle: pickerStyle,
    dialogStyle: dialogStyle,
    confirmLabel: confirmLabel,
    cancelLabel: cancelLabel,
  ),
);

/// 在弹窗内保存选色草稿；外部颜色在确认前保持不变。
/// 表面与布局复用 Dialog 主题，选色样式复用 ColorPicker 主题。
class HyperColorPickerDialog extends StatefulWidget {
  const HyperColorPickerDialog({
    super.key,
    required this.initialColor,
    this.title,
    this.showAlpha = true,
    this.recommendedColors = const [],
    this.pickerStyle,
    this.dialogStyle,
    this.confirmLabel = '确定',
    this.cancelLabel = '取消',
  });
  final Color initialColor;
  final Widget? title;
  final bool showAlpha;
  final List<Color> recommendedColors;
  final HyperColorPickerStyle? pickerStyle;
  final HyperDialogStyle? dialogStyle;
  final String confirmLabel, cancelLabel;

  @override
  State<HyperColorPickerDialog> createState() => _HyperColorPickerDialogState();
}

class _HyperColorPickerDialogState extends State<HyperColorPickerDialog> {
  late Color _draft = widget.initialColor;

  @override
  void didUpdateWidget(HyperColorPickerDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialColor != widget.initialColor) {
      _draft = widget.initialColor;
    }
  }

  @override
  Widget build(BuildContext context) => HyperDialog(
    title: widget.title ?? const Text('选择颜色'),
    style: widget.dialogStyle,
    content: HyperColorPicker(
      recommendedColors: widget.recommendedColors,
      value: _draft,
      showAlpha: widget.showAlpha,
      style: widget.pickerStyle,
      onChanged: (color) => setState(() => _draft = color),
    ),
    actions: [
      HyperButton.ghost(
        onPressed: () => Navigator.of(context).pop(),
        child: Text(widget.cancelLabel),
      ),
      HyperButton.filled(
        onPressed: () => Navigator.of(context).pop(_draft),
        child: Text(widget.confirmLabel),
      ),
    ],
  );
}
