import 'package:flutter/material.dart';

import '../bottom_sheet/hyper_bottom_sheet.dart';
import '../bottom_sheet/hyper_bottom_sheet_style.dart';
import '../button/hyper_button.dart';
import '../dialog/hyper_dialog.dart';
import '../dialog/hyper_dialog_style.dart';
import 'hyper_form.dart';

/// Opens a form dialog. Confirm validates and submits before returning values.
/// Cancellation returns null; a failed submission keeps the editor open.
Future<Map<String, Object?>?> showHyperFormDialog({
  required BuildContext context,
  required WidgetBuilder builder,
  Widget? title,
  HyperFormController? controller,
  HyperFormSubmitHandler? onSubmit,
  HyperFieldLayout layout = HyperFieldLayout.vertical,
  HyperFieldErrorDisplay errorDisplay = HyperFieldErrorDisplay.auto,
  HyperFieldStyle? formStyle,
  HyperDialogStyle? style,
  Widget confirmLabel = const Text('确定'),
  Widget cancelLabel = const Text('取消'),
  bool barrierDismissible = true,
  bool? useRootNavigator,
}) => showHyperDialog<Map<String, Object?>>(
  context: context,
  style: style,
  barrierDismissible: barrierDismissible,
  useRootNavigator: useRootNavigator,
  builder: (_) => _FormModal(
    builder: builder,
    title: title,
    controller: controller,
    onSubmit: onSubmit,
    layout: layout,
    errorDisplay: errorDisplay,
    formStyle: formStyle,
    confirmLabel: confirmLabel,
    cancelLabel: cancelLabel,
  ),
);

/// Opens a bottom sheet with the same validation contract as the form dialog.
Future<Map<String, Object?>?> showHyperFormBottomSheet({
  required BuildContext context,
  required WidgetBuilder builder,
  Widget? title,
  HyperFormController? controller,
  HyperFormSubmitHandler? onSubmit,
  HyperFieldLayout layout = HyperFieldLayout.vertical,
  HyperFieldErrorDisplay errorDisplay = HyperFieldErrorDisplay.auto,
  HyperFieldStyle? formStyle,
  HyperBottomSheetStyle? style,
  Widget confirmLabel = const Text('确定'),
  Widget cancelLabel = const Text('取消'),
  bool barrierDismissible = true,
  bool enableDrag = true,
  bool? useRootNavigator,
}) => showHyperBottomSheet<Map<String, Object?>>(
  context: context,
  style: style,
  barrierDismissible: barrierDismissible,
  enableDrag: enableDrag,
  useRootNavigator: useRootNavigator,
  builder: (_) => _FormModal(
    bottomSheet: true,
    builder: builder,
    title: title,
    controller: controller,
    onSubmit: onSubmit,
    layout: layout,
    errorDisplay: errorDisplay,
    formStyle: formStyle,
    confirmLabel: confirmLabel,
    cancelLabel: cancelLabel,
  ),
);

class _FormModal extends StatefulWidget {
  const _FormModal({
    required this.builder,
    required this.title,
    required this.controller,
    required this.onSubmit,
    required this.layout,
    required this.errorDisplay,
    required this.formStyle,
    required this.confirmLabel,
    required this.cancelLabel,
    this.bottomSheet = false,
  });
  final WidgetBuilder builder;
  final Widget? title;
  final HyperFormController? controller;
  final HyperFormSubmitHandler? onSubmit;
  final HyperFieldLayout layout;
  final HyperFieldErrorDisplay errorDisplay;
  final HyperFieldStyle? formStyle;
  final Widget confirmLabel, cancelLabel;
  final bool bottomSheet;
  @override
  State<_FormModal> createState() => _FormModalState();
}

class _FormModalState extends State<_FormModal> {
  late final controller = widget.controller ?? HyperFormController();
  bool busy = false;
  @override
  void dispose() {
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  Future<void> confirm() async {
    if (busy) return;
    setState(() => busy = true);
    Map<String, Object?>? submitted;
    try {
      final valid = await controller.submit((values) async {
        submitted = values;
        await widget.onSubmit?.call(values);
      });
      if (valid && mounted && ModalRoute.of(context)?.isCurrent == true) {
        Navigator.of(context).pop(submitted);
      }
    } catch (_) {
      // Controller retains the error for the live summary; preserve input.
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = HyperForm(
      controller: controller,
      layout: widget.layout,
      errorDisplay: widget.errorDisplay,
      style: widget.formStyle,
      child: HyperFormSection(
        children: [
          Builder(builder: widget.builder),
          HyperFormErrorSummary(controller: controller),
        ],
      ),
    );
    final actions = <Widget>[
      HyperButton.outlined(
        onPressed: busy ? null : () => Navigator.of(context).pop(),
        child: widget.cancelLabel,
      ),
      HyperButton.filled(
        loading: busy,
        onPressed: busy ? null : confirm,
        child: widget.confirmLabel,
      ),
    ];
    return PopScope(
      canPop: !busy,
      child: widget.bottomSheet
          ? HyperBottomSheet(
              title: widget.title,
              content: content,
              actions: actions,
            )
          : HyperDialog(
              title: widget.title,
              content: content,
              actions: actions,
              showCloseButton: !busy,
            ),
    );
  }
}
