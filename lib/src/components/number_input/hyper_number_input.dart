import '../../foundation/hyper_icons.dart';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/core/hyper_theme.dart';
import '../icon_button/hyper_icon_button.dart';
import '../icon_button/hyper_icon_button_style.dart';
import '../text_field/hyper_text_field.dart';
import '../text_field/hyper_text_field_style.dart';
import '../text_field/hyper_text_field_theme.dart';
import '../text_field/hyper_text_field_layout.dart';
import 'hyper_number_input_layout.dart';
import 'hyper_number_input_theme.dart';
import '../../foundation/hyper_control_state.dart';
import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_surface_material.dart';
import '../text_field/hyper_text_field_resolver.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../widget_group/hyper_widget_group.dart';
import '../widget_group/hyper_widget_group_style.dart';

// MaterialIcons keyboard_arrow_up/down, measured in the bundled font's
// 512-unit em: outer vertical ink starts at 171, horizontal ink at 128.
// Align the ink rather than the differently padded icon canvases.
const _stepperGlyphInsetCorrection = (171 - 128) / 512;

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
    this.layout,
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
  final HyperNumberInputLayout? layout;
  @override
  State<HyperNumberInput> createState() => _HyperNumberInputState();
}

class _HyperNumberInputState extends State<HyperNumberInput> {
  late final text = TextEditingController(text: format(widget.value));
  final ownedFocus = FocusNode();
  final _inputKey = GlobalKey();
  bool _hovered = false;
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
    if (mounted) setState(() {});
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
    final numberTheme = HyperNumberInputTheme.of(context);
    final horizontal =
        (widget.layout ??
            numberTheme.layout ??
            HyperNumberInputLayout.trailingVertical) ==
        HyperNumberInputLayout.leadingTrailing;
    final field = HyperTextFieldTheme.of(context).style.merge(widget.style);
    final surface = resolveHyperTextFieldStyle(
      context,
      states: {
        if (_hovered && widget.enabled) HyperControlState.hovered,
        if (focus.hasFocus) HyperControlState.focused,
        if (widget.errorText?.isNotEmpty == true) HyperControlState.error,
        if (!widget.enabled || widget.onChanged == null)
          HyperControlState.disabled,
      },
      style: widget.style,
    );
    final surfaceMaterial =
        surface.material ??
        HyperMaterialTheme.of(context).material ??
        HyperSurfaceMaterial.solid(background: surface.background);
    final inheritedPadding =
        (field.padding ??
                EdgeInsets.symmetric(
                  horizontal: sizes.horizontalPadding,
                  vertical: sizes.verticalPadding,
                ))
            .resolve(Directionality.of(context));
    // Keep the pair compact within the field instead of stretching two buttons
    // across its entire height. The remaining height becomes symmetric insets.
    final buttonWidth = horizontal
        ? surface.height ?? surface.minimumHeight ?? sizes.minimumHeight
        : math.min(
            (field.minimumHeight ?? sizes.minimumHeight) / 2,
            field.iconSize ?? sizes.iconSize,
          );
    final textPainter = TextPainter(
      text: TextSpan(text: ' ', style: surface.textStyle),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final lineHeight = textPainter.preferredLineHeight;
    textPainter.dispose();
    final layout = resolveHyperTextFieldLayout(
      height: surface.height,
      minimumHeight: surface.minimumHeight!,
      padding: inheritedPadding,
      contentHeight: lineHeight,
      borderWidth: 0,
    );
    final controlHeight = math.max(
      layout.minimumHeight,
      lineHeight + layout.padding.vertical,
    );
    final iconExtent = field.iconSize ?? sizes.iconSize;
    // With the measured glyph bounds, solve for a row height whose middle
    // ink gap equals the outer vertical inset. Keep the icon itself unscaled.
    final extent = horizontal
        ? buttonWidth
        : math.min(
            buttonWidth,
            (controlHeight / 3 + iconExtent * 122 / 1536).roundToDouble(),
          );
    final suffixPadding = resolveHyperTextFieldSuffixPadding(
      padding: Directionality.of(context) == TextDirection.ltr
          ? inheritedPadding.right
          : inheritedPadding.left,
      actionWidth: field.actionWidth ?? sizes.actionWidth,
      iconSize: field.iconSize ?? sizes.iconSize,
      endsWithAction: true,
    );
    final inputStyle = HyperTextFieldStyle(
      padding: EdgeInsetsDirectional.only(
        start: resolveHyperTextFieldSuffixPadding(
          padding: Directionality.of(context) == TextDirection.ltr
              ? inheritedPadding.left
              : inheritedPadding.right,
          actionWidth: field.actionWidth ?? sizes.actionWidth,
          iconSize: field.iconSize ?? sizes.iconSize,
          endsWithAction: horizontal,
        ),
        end: horizontal
            ? suffixPadding
            : math.max(
                0,
                (controlHeight - extent - buttonWidth) / 2 +
                    (field.iconSize ?? sizes.iconSize) *
                        _stepperGlyphInsetCorrection,
              ),
        top: inheritedPadding.top,
        bottom: inheritedPadding.bottom,
      ),
    ).merge(widget.style);
    final buttons = HyperIconButtonStyle(
      size: buttonWidth,
      minimumTapTargetSize: extent,
      iconSize: field.iconSize ?? sizes.iconSize,
      foregroundColor:
          field.iconColor ?? HyperTheme.of(context).colors.textSecondary,
      borderRadius: BorderRadius.zero,
    ).merge(numberTheme.stepperStyle).merge(widget.stepperStyle);
    Widget stepButton(int direction, IconData icon) {
      final button = HyperIconButton.ghost(
        icon: horizontal
            ? Icon(icon)
            : OverflowBox(
                minWidth: buttons.iconSize,
                maxWidth: buttons.iconSize,
                minHeight: buttons.iconSize,
                maxHeight: buttons.iconSize,
                child: Icon(icon),
              ),
        tooltip: direction > 0 ? '增加' : '减少',
        style: buttons,
        onPressed:
            editable &&
                (direction > 0
                    ? widget.maximum == null ||
                          widget.value == null ||
                          widget.value! < widget.maximum!
                    : widget.minimum == null ||
                          widget.value == null ||
                          widget.value! > widget.minimum!)
            ? () => change(direction)
            : null,
      );
      return horizontal
          ? button
          : SizedBox(width: buttons.size, height: extent, child: button);
    }

    // A global material is a base default, so state themes can still override it.
    final input = HyperTextFieldTheme(
      data: HyperTextFieldThemeData(
        style: HyperTextFieldStyle(
          material:
              HyperTextFieldTheme.of(context).style.material ??
              HyperMaterialTheme.of(context).material,
        ),
      ),
      child: HyperTextField(
        key: _inputKey,
        controller: text,
        focusNode: focus,
        enabled: widget.enabled && widget.onChanged != null,
        readOnly: widget.readOnly || widget.onChanged == null,
        hintText: widget.hintText,
        semanticLabel: widget.semanticLabel,
        errorText: widget.errorText,
        style: horizontal
            ? (widget.style ?? const HyperTextFieldStyle()).merge(
                const HyperTextFieldStyle(
                  borderRadius: BorderRadius.zero,
                  border: Border(),
                  borderWidth: 0,
                  background: HyperFill.none(),
                  material: HyperSurfaceMaterial.solid(
                    background: HyperFill.none(),
                  ),
                  boxShadow: [],
                ),
              )
            : inputStyle,
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
        trailing: horizontal
            ? null
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  stepButton(1, HyperIcons.chevronUp),
                  stepButton(-1, HyperIcons.chevronDown),
                ],
              ),
      ),
    );
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
      child: horizontal
          ? MouseRegion(
              onEnter: (_) => setState(() => _hovered = true),
              onExit: (_) => setState(() => _hovered = false),
              child: HyperWidgetGroup(
                connected: true,
                showSeparators: true,
                style: HyperWidgetGroupStyle(
                  borderRadius: surface.borderRadius,
                  material: surfaceMaterial,
                  border:
                      surface.border ??
                      Border.all(
                        color: surface.borderColor!,
                        width: surface.borderWidth!,
                      ),
                  boxShadow: surface.boxShadow,
                  spacing: 0,
                  padding: EdgeInsets.zero,
                  itemBorderRadius: BorderRadius.zero,
                ),
                children: [
                  stepButton(-1, HyperIcons.minus),
                  HyperWidgetGroupItem(flex: 1, child: input),
                  stepButton(1, HyperIcons.plus),
                ],
              ),
            )
          : input,
    );
  }
}
