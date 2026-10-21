import 'package:flutter/material.dart';

import '../../foundation/hyper_control_state.dart';
import '../../theme/core/hyper_theme.dart';
import '../button/hyper_button_style.dart';
import '../text_field/hyper_text_field_theme.dart';

/// Shares the input focus border across select and custom dropdown triggers.
class HyperSelectFocus extends StatefulWidget {
  const HyperSelectFocus({
    super.key,
    required this.open,
    required this.enabled,
    required this.builder,
  });
  final bool open, enabled;
  final Widget Function(HyperButtonStyle focusStyle) builder;
  @override
  State<HyperSelectFocus> createState() => _HyperSelectFocusState();
}

class _HyperSelectFocusState extends State<HyperSelectFocus> {
  bool _focused = false;
  @override
  Widget build(BuildContext context) {
    final active = widget.enabled && (widget.open || _focused);
    final input = HyperTextFieldTheme.of(context)
        .resolve({HyperControlState.focused});
    final border =
        input.border ??
        Border.fromBorderSide(
          BorderSide(
            color: input.borderColor ?? HyperTheme.of(context).colors.primary,
            width: input.borderWidth ?? 1,
          ),
        );
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onFocusChange: (focused) => setState(() => _focused = focused),
      child: widget.builder(
        active ? HyperButtonStyle(boxBorder: border) : HyperButtonStyle(),
      ),
    );
  }
}
