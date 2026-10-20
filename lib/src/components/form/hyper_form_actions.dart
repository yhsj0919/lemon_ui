import 'dart:async';

import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../../theme/size/components/hyper_button_size.dart';
import '../button/hyper_button.dart';
import '../button/hyper_button_style.dart';
import 'hyper_form.dart';

/// Form submit, reset and optional cancel actions using the shared form state.
class HyperFormActions extends StatelessWidget {
  const HyperFormActions({
    super.key,
    required this.controller,
    required this.onSubmit,
    this.onCancel,
    this.onReset,
    this.submitLabel = const Text('提交'),
    this.resetLabel = const Text('重置'),
    this.cancelLabel = const Text('取消'),
    this.showReset = true,
    this.enabled = true,
    this.size = HyperButtonSizeVariant.medium,
    this.submitStyle,
    this.resetStyle,
    this.cancelStyle,
    this.onError,
  });

  final HyperFormController controller;
  final HyperFormSubmitHandler onSubmit;
  final FutureOr<void> Function()? onCancel;
  final VoidCallback? onReset;
  final Widget submitLabel, resetLabel, cancelLabel;
  final bool showReset, enabled;
  final HyperButtonSizeVariant size;
  final HyperButtonStyle? submitStyle, resetStyle, cancelStyle;
  final void Function(Object error, StackTrace stackTrace)? onError;

  Future<void> _submit() async {
    try {
      await controller.submit(onSubmit);
    } catch (error, stackTrace) {
      // HyperFormController retains submission errors for HyperFormErrorSummary.
      onError?.call(error, stackTrace);
    }
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final busy = controller.isSubmitting || controller.isValidating;
      final canAct = enabled && !busy;
      final gap = HyperTheme.sizesOf(context).form.gap;
      return Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Wrap(
          alignment: WrapAlignment.end,
          spacing: gap,
          runSpacing: gap,
          children: [
            if (onCancel != null)
              HyperButton.ghost(
                onPressed: canAct ? onCancel : null,
                size: size,
                style: cancelStyle,
                onError: onError,
                child: cancelLabel,
              ),
            if (showReset)
              HyperButton.outlined(
                onPressed: canAct
                    ? () {
                        controller.reset();
                        onReset?.call();
                      }
                    : null,
                size: size,
                style: resetStyle,
                child: resetLabel,
              ),
            HyperButton.filled(
              onPressed: canAct ? _submit : null,
              loading: controller.isSubmitting,
              size: size,
              style: submitStyle,
              onError: onError,
              child: submitLabel,
            ),
          ],
        ),
      );
    },
  );
}
