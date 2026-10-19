import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../button/hyper_button.dart';

/// Shared inset: compact option lists; editing panels retain vertical breathing room.
EdgeInsets hyperSelectionPadding(BuildContext context, {bool editing = false}) {
  final sizes = HyperTheme.sizesOf(context);
  return editing
      ? sizes.dialog.padding
            .resolve(Directionality.of(context))
            .copyWith(left: sizes.menu.padding, right: sizes.menu.padding)
      : EdgeInsets.all(sizes.menu.padding);
}

/// Selection panels share button hierarchy and use the global button geometry.
class HyperSelectionActions extends StatelessWidget {
  const HyperSelectionActions({
    super.key,
    required this.onClear,
    required this.onConfirm,
    this.onCancel,
    this.clearText = '清空',
    this.confirmText = '确定',
  });
  final VoidCallback? onClear, onConfirm, onCancel;
  final String clearText, confirmText;
  @override
  Widget build(BuildContext context) {
    final gap = HyperTheme.sizesOf(context).menu.padding;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HyperButton.text(onPressed: onClear, label: Text(clearText)),
        SizedBox(width: gap),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: gap,
            runSpacing: gap,
            children: [
              if (onCancel != null)
                HyperButton.outlined(
                  onPressed: onCancel,
                  label: const Text('取消'),
                ),
              HyperButton.filled(
                onPressed: onConfirm,
                label: Text(confirmText),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
