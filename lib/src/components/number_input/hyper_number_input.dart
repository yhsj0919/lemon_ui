import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/core/hyper_theme.dart';
import '../icon_button/hyper_icon_button.dart';
import '../icon_button/hyper_icon_button_style.dart';
import '../text_field/hyper_text_field.dart';
import '../text_field/hyper_text_field_style.dart';
import '../text_field/hyper_text_field_theme.dart';

/// Controlled numeric editor. Incomplete input is kept until blur or submit.
/// Empty text reports null; invalid text restores the controlled value on blur.
class HyperNumberInput extends StatefulWidget {
  HyperNumberInput({
    super.key,
    required this.value,
    required this.onChanged,
    this.minimum,
    this.maximum,
    this.step = 1,
    this.precision,
    this.minimumIntegerDigits = 1,
    this.enabled = true,
    this.readOnly = false,
    this.showClearButton = false,
    this.focusNode,
    this.hintText,
    this.semanticLabel,
    this.errorText,
    this.style,
    this.stepperStyle,
  }) {
    if (!step.isFinite ||
        step <= 0 ||
        (minimum != null && !minimum!.isFinite) ||
        (maximum != null && !maximum!.isFinite) ||
        (minimum != null && maximum != null && minimum! > maximum!) ||
        (precision != null && (precision! < 0 || precision! > 15)) ||
        minimumIntegerDigits < 1 ||
        (value != null &&
            (!value!.isFinite ||
                (minimum != null && value! < minimum!) ||
                (maximum != null && value! > maximum!)))) {
      throw ArgumentError('数字范围、值、精度或步长无效');
    }
  }
  final double? value, minimum, maximum;
  final double step;
  final int? precision;
  final int minimumIntegerDigits;
  final ValueChanged<double?>? onChanged;
  final bool enabled, readOnly, showClearButton;
  final FocusNode? focusNode;
  final String? hintText, semanticLabel, errorText;
  final HyperTextFieldStyle? style;
  final HyperIconButtonStyle? stepperStyle;
  @override
  State<HyperNumberInput> createState() => _HyperNumberInputState();
}

class _HyperNumberInputState extends State<HyperNumberInput> {
  late final text = TextEditingController(text: format(widget.value));
  final ownedFocus = FocusNode();
  FocusNode get focus => widget.focusNode ?? ownedFocus;
  bool get editable =>
      widget.enabled && !widget.readOnly && widget.onChanged != null;
  String format(double? value) {
    if (value == null) return '';
    final raw = widget.precision != null
        ? value.toStringAsFixed(widget.precision!)
        : value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
    final sign = raw.startsWith('-') ? '-' : '';
    final parts = (sign.isEmpty ? raw : raw.substring(1)).split('.');
    parts[0] = parts[0].padLeft(widget.minimumIntegerDigits, '0');
    return '$sign${parts.join('.')}';
  }

  double normalize(double value) {
    final rounded = widget.precision == null
        ? double.parse(value.toStringAsPrecision(15))
        : double.parse(value.toStringAsFixed(widget.precision!));
    return rounded.clamp(
      widget.minimum ?? double.negativeInfinity,
      widget.maximum ?? double.infinity,
    );
  }

  @override
  void initState() {
    super.initState();
    focus.addListener(blur);
  }

  void blur() {
    if (!focus.hasFocus) commit();
  }

  void commit() {
    final parsed = double.tryParse(text.text);
    if (editable && parsed != null && parsed.isFinite) {
      final next = normalize(parsed);
      if (next != widget.value) widget.onChanged!(next);
      text.text = format(next);
    } else {
      text.text = format(widget.value);
    }
  }

  @override
  void didUpdateWidget(HyperNumberInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? ownedFocus).removeListener(blur);
      focus.addListener(blur);
    }
    if (oldWidget.value != widget.value ||
        oldWidget.precision != widget.precision) {
      final parsed = double.tryParse(text.text);
      if (!focus.hasFocus ||
          parsed != widget.value ||
          oldWidget.precision != widget.precision) {
        text.text = format(widget.value);
      }
    }
  }

  void change(int direction) {
    if (!editable) return;
    final current = double.tryParse(text.text) ?? widget.value ?? 0;
    final raw = current + direction * widget.step;
    if (!raw.isFinite) return;
    final next = normalize(raw);
    text.text = format(next);
    if (next != widget.value) widget.onChanged!(next);
  }

  @override
  void dispose() {
    focus.removeListener(blur);
    ownedFocus.dispose();
    text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context).textField;
    final inheritedPadding =
        (HyperTextFieldTheme.of(context).style.padding ??
                EdgeInsets.symmetric(
                  horizontal: sizes.horizontalPadding,
                  vertical: sizes.verticalPadding,
                ))
            .resolve(Directionality.of(context));
    final inputStyle = HyperTextFieldStyle(
      padding: EdgeInsetsDirectional.only(
        start: Directionality.of(context) == TextDirection.ltr
            ? inheritedPadding.left
            : inheritedPadding.right,
        end: 0,
        top: inheritedPadding.top,
        bottom: inheritedPadding.bottom,
      ),
    ).merge(widget.style);
    final extent = sizes.minimumHeight / 2;
    final buttons = HyperIconButtonStyle(
      size: extent,
      minimumTapTargetSize: extent,
      iconSize: extent,
      borderRadius: BorderRadius.zero,
    ).merge(widget.stepperStyle);
    return Focus(
      onKeyEvent: (_, event) {
        if (!editable || event is KeyUpEvent) return KeyEventResult.ignored;
        if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
          change(1);
          return KeyEventResult.handled;
        }
        if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
          change(-1);
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: HyperTextField(
        controller: text,
        focusNode: focus,
        enabled: widget.enabled && widget.onChanged != null,
        readOnly: widget.readOnly || widget.onChanged == null,
        hintText: widget.hintText,
        semanticLabel: widget.semanticLabel,
        errorText: widget.errorText,
        style: inputStyle,
        showClearButton: editable && widget.showClearButton,
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: true,
        ),
        inputFormatters: [
          TextInputFormatter.withFunction(
            (oldValue, newValue) =>
                RegExp(r'^-?\d*\.?\d*$').hasMatch(newValue.text)
                ? newValue
                : oldValue,
          ),
        ],
        onChanged: (value) {
          if (!editable) return;
          if (value.isEmpty) {
            widget.onChanged!(null);
            return;
          }
          final parsed = double.tryParse(value);
          if (parsed != null && parsed.isFinite) {
            widget.onChanged!(normalize(parsed));
          }
        },
        onSubmitted: (_) => commit(),
        trailingAtEnd: true,
        trailing: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HyperIconButton.ghost(
              icon: const Icon(Icons.keyboard_arrow_up),
              tooltip: '增加',
              style: buttons,
              onPressed:
                  editable &&
                      (widget.maximum == null ||
                          widget.value == null ||
                          widget.value! < widget.maximum!)
                  ? () => change(1)
                  : null,
            ),
            HyperIconButton.ghost(
              icon: const Icon(Icons.keyboard_arrow_down),
              tooltip: '减少',
              style: buttons,
              onPressed:
                  editable &&
                      (widget.minimum == null ||
                          widget.value == null ||
                          widget.value! > widget.minimum!)
                  ? () => change(-1)
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
