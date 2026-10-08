import 'dart:ui' show SemanticsValidationResult;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../foundation/hyper_control_state.dart';
import '../../foundation/hyper_fill.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/core/hyper_theme.dart';
import '../card/hyper_card.dart';
import '../card/hyper_card_style.dart';
import '../overlay/hyper_anchored_overlay.dart';
import '../surface/hyper_material_surface.dart';
import 'hyper_text_field_style.dart';
import 'hyper_text_field_theme.dart';
import 'hyper_text_field_layout.dart';

/// 原生文本编辑，错误以尾部图标和浮层呈现，不增加辅助文字行。
class HyperTextField extends StatefulWidget {
  const HyperTextField({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.label,
    this.hintText,
    this.errorText,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.readOnly = false,
    this.showClearButton = false,
    this.obscureText = false,
    this.showPasswordToggle = true,
    this.reserveErrorSpace = false,
    this.showCounter = false,
    this.maxLength,
    this.maxLengthEnforcement,
    this.maxLines = 1,
    this.minLines,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.textAlign = TextAlign.start,
    this.textDirection,
    this.autofocus = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.autofillHints,
    this.inputFormatters,
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTap,
    this.semanticLabel,
    this.style,
    this.errorBuilder,
  }) : assert(controller == null || initialValue == null),
       assert(maxLines == null || maxLines > 0),
       assert(minLines == null || minLines > 0),
       assert(maxLines == null || minLines == null || minLines <= maxLines),
       assert(!obscureText || maxLines == 1),
       assert(maxLength == null || maxLength > 0);

  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final String? label, hintText, errorText, semanticLabel;
  final Widget? leading, trailing;
  final bool enabled,
      readOnly,
      showClearButton,
      obscureText,
      showPasswordToggle,
      reserveErrorSpace,
      showCounter,
      autofocus,
      autocorrect,
      enableSuggestions;
  final int? maxLength, maxLines, minLines;
  final MaxLengthEnforcement? maxLengthEnforcement;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final TextAlign textAlign;
  final TextDirection? textDirection;
  final Iterable<String>? autofillHints;
  final List<TextInputFormatter>? inputFormatters;
  final ValueChanged<String>? onChanged, onSubmitted;
  final VoidCallback? onEditingComplete, onTap;
  final HyperTextFieldStyle? style;

  /// 替换错误浮层内容，定位和关闭仍由锚定浮层管理。
  final Widget Function(BuildContext context, String errorText)? errorBuilder;
  @override
  State<HyperTextField> createState() => _HyperTextFieldState();
}

class _HyperTextFieldState extends State<HyperTextField> {
  TextEditingController? _ownedController;
  FocusNode? _ownedFocus;
  bool _hovered = false, _showPassword = false;

  TextEditingController get _controller =>
      widget.controller ?? _ownedController!;
  FocusNode get _focus => widget.focusNode ?? _ownedFocus!;
  bool get _hasError => widget.errorText?.trim().isNotEmpty ?? false;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _ownedController = TextEditingController(text: widget.initialValue);
    }
    if (widget.focusNode == null) _ownedFocus = FocusNode();
    _focus.addListener(_focusChanged);
  }

  void _focusChanged() {
    if (mounted) setState(() {});
  }

  @override
  void didUpdateWidget(HyperTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      final previous = oldWidget.controller ?? _ownedController!;
      if (widget.controller == null) {
        _ownedController = TextEditingController.fromValue(previous.value);
      } else {
        _ownedController?.dispose();
        _ownedController = null;
      }
    }
    if (oldWidget.focusNode != widget.focusNode) {
      final previous = oldWidget.focusNode ?? _ownedFocus!;
      previous.removeListener(_focusChanged);
      if (widget.focusNode == null) {
        _ownedFocus = FocusNode();
      } else {
        _ownedFocus?.dispose();
        _ownedFocus = null;
      }
      _focus.addListener(_focusChanged);
    }
    if (oldWidget.obscureText != widget.obscureText) _showPassword = false;
  }

  @override
  void dispose() {
    _focus.removeListener(_focusChanged);
    _ownedController?.dispose();
    _ownedFocus?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).textField;
    final states = <HyperControlState>{
      if (_hovered && widget.enabled) HyperControlState.hovered,
      if (_focus.hasFocus) HyperControlState.focused,
      if (_hasError) HyperControlState.error,
      if (!widget.enabled) HyperControlState.disabled,
    };
    final defaults = HyperTextFieldThemeData(
      style: HyperTextFieldStyle(
        background: HyperFill.color(theme.colors.surfaceMuted),
        borderColor: theme.colors.outline,
        borderWidth: 1,
        borderRadius: BorderRadius.circular(metrics.radius),
        minimumHeight: metrics.minimumHeight,
        padding: EdgeInsets.symmetric(
          horizontal: metrics.horizontalPadding,
          vertical: metrics.verticalPadding,
        ),
        iconSize: metrics.iconSize,
        actionWidth: metrics.actionWidth,
        labelGap: metrics.labelGap,
        textStyle: theme.textTheme.labelLarge?.copyWith(
          fontWeight: FontWeight.w400,
        ),
        hintStyle: theme.textTheme.labelLarge?.copyWith(
          color: theme.colors.textTertiary,
          fontWeight: FontWeight.w400,
        ),
        labelStyle: theme.textTheme.labelMedium?.copyWith(
          color: theme.colors.textSecondary,
        ),
        counterStyle: theme.textTheme.labelSmall?.copyWith(
          color: theme.colors.textSecondary,
        ),
        foregroundColor: theme.colors.textPrimary,
        iconColor: theme.colors.textSecondary,
        cursorColor: theme.colors.primary,
        cursorWidth: 2,
        cursorRadius: const Radius.circular(1),
        errorIcon: Icons.error_outline,
        clearIcon: Icons.close,
        showPasswordIcon: Icons.visibility_outlined,
        hidePasswordIcon: Icons.visibility_off_outlined,
        errorIconColor: theme.colors.error,
        errorMaxWidth: metrics.errorMaxWidth,
        errorTextStyle: theme.textTheme.bodySmall?.copyWith(
          color: theme.colors.textPrimary,
        ),
        errorPopupStyle: HyperCardStyle(
          padding: EdgeInsets.all(metrics.horizontalPadding),
        ),
      ),
      hovered: HyperTextFieldStyle(borderColor: theme.colors.textSecondary),
      focused: HyperTextFieldStyle(borderColor: theme.colors.primary),
      error: HyperTextFieldStyle(
        borderColor: theme.colors.error,
        cursorColor: theme.colors.error,
      ),
      disabled: HyperTextFieldStyle(
        foregroundColor: theme.colors.disabled,
        iconColor: theme.colors.disabled,
        borderColor: theme.colors.outline,
      ),
    );
    var resolved = defaults
        .merge(HyperTextFieldTheme.of(context))
        .resolve(states)
        .merge(widget.style);
    if (resolved.height != null) {
      final textPainter = TextPainter(
        text: TextSpan(text: ' ', style: resolved.textStyle),
        textDirection: widget.textDirection ?? Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
      );
      final lineHeight = textPainter.preferredLineHeight;
      textPainter.dispose();
      final contentHeight =
          lineHeight * (widget.minLines ?? widget.maxLines ?? 1);
      final layout = resolveHyperTextFieldLayout(
        height: resolved.height,
        minimumHeight: resolved.minimumHeight!,
        padding: resolved.padding!.resolve(Directionality.of(context)),
        contentHeight: contentHeight > resolved.iconSize!
            ? contentHeight
            : resolved.iconSize!,
        borderWidth: resolved.borderWidth!,
      );
      resolved = resolved.copyWith(
        minimumHeight: layout.minimumHeight,
        padding: layout.padding,
      );
    }
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = reduced
        ? Duration.zero
        : resolved.duration ?? theme.motion.fastDuration;
    final curve = resolved.curve ?? theme.motion.fastCurve;
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: _controller,
      builder: (context, value, _) {
        final editable = widget.enabled && !widget.readOnly;
        final padding = resolved.padding!.resolve(Directionality.of(context));
        final startPadding = Directionality.of(context) == TextDirection.ltr
            ? padding.left
            : padding.right;
        final endPadding = Directionality.of(context) == TextDirection.ltr
            ? padding.right
            : padding.left;
        final hasCounter = widget.showCounter && widget.maxLength != null;
        final endsWithAction =
            !hasCounter &&
            ((widget.obscureText && widget.showPasswordToggle) ||
                widget.showClearButton ||
                _hasError ||
                widget.reserveErrorSpace);
        final suffixPadding = resolveHyperTextFieldSuffixPadding(
          padding: endPadding,
          actionWidth: resolved.actionWidth!,
          iconSize: resolved.iconSize!,
          endsWithAction: endsWithAction,
        );
        final actions = <Widget>[
          if (widget.trailing != null) widget.trailing!,
          if (widget.showClearButton)
            _action(
              resolved,
              duration,
              curve,
              visible: value.text.isNotEmpty && editable,
              icon: resolved.clearIcon!,
              label: '清空输入',
              onTap: () {
                _controller.clear();
                widget.onChanged?.call('');
                _focus.requestFocus();
              },
            ),
          if (widget.obscureText && widget.showPasswordToggle)
            _action(
              resolved,
              duration,
              curve,
              visible: true,
              enabled: widget.enabled,
              icon: _showPassword
                  ? resolved.hidePasswordIcon!
                  : resolved.showPasswordIcon!,
              label: _showPassword ? '隐藏密码' : '显示密码',
              onTap: () => setState(() => _showPassword = !_showPassword),
            ),
          _errorAction(resolved, duration, curve),
          if (widget.showCounter && widget.maxLength != null)
            Padding(
              padding: EdgeInsetsDirectional.only(start: endPadding),
              child: Text(
                '${value.text.characters.length}/${widget.maxLength}',
                style: resolved.counterStyle,
              ),
            ),
        ];
        // 错误提示始终挂载以完成退出动画，无错误时自身宽度为零。
        final suffix = IconTheme(
          data: IconThemeData(
            size: resolved.iconSize,
            color: resolved.iconColor,
          ),
          child: Padding(
            padding: EdgeInsetsDirectional.only(end: suffixPadding),
            child: Row(mainAxisSize: MainAxisSize.min, children: actions),
          ),
        );
        final field = TextField(
          controller: _controller,
          focusNode: _focus,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          obscureText: widget.obscureText && !_showPassword,
          maxLines: widget.maxLines,
          minLines: widget.minLines,
          maxLength: widget.maxLength,
          maxLengthEnforcement: widget.maxLengthEnforcement,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          textAlign: widget.textAlign,
          textDirection: widget.textDirection,
          textAlignVertical:
              resolved.textAlignVertical ??
              (widget.maxLines == 1
                  ? TextAlignVertical.center
                  : TextAlignVertical.top),
          autofocus: widget.autofocus,
          autocorrect: widget.obscureText ? false : widget.autocorrect,
          enableSuggestions: widget.obscureText
              ? false
              : widget.enableSuggestions,
          autofillHints: widget.autofillHints,
          inputFormatters: widget.inputFormatters,
          onChanged: widget.onChanged,
          onSubmitted: widget.onSubmitted,
          onEditingComplete: widget.onEditingComplete,
          onTap: widget.onTap,
          style: resolved.textStyle?.copyWith(color: resolved.foregroundColor),
          cursorColor: resolved.cursorColor,
          cursorWidth: resolved.cursorWidth!,
          cursorRadius: resolved.cursorRadius,
          decoration: InputDecoration(
            isDense: true,
            // 四端留白已由 HyperSizeScheme 解析，避免 Material 密度再次缩减。
            visualDensity: VisualDensity.standard,
            filled: false,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedErrorBorder: InputBorder.none,
            contentPadding: resolved.padding,
            hintText: widget.hintText,
            hintStyle: resolved.hintStyle,
            counterText: '',
            prefixIcon: widget.leading == null
                ? null
                : Padding(
                    padding: EdgeInsetsDirectional.only(start: startPadding),
                    child: IconTheme(
                      data: IconThemeData(
                        size: resolved.iconSize,
                        color: resolved.iconColor,
                      ),
                      child: widget.leading!,
                    ),
                  ),
            prefixIconConstraints: BoxConstraints(
              minWidth: resolved.actionWidth!,
              minHeight: resolved.minimumHeight!,
            ),
            suffixIcon: suffix,
            suffixIconConstraints: const BoxConstraints(),
            constraints: BoxConstraints(minHeight: resolved.minimumHeight!),
          ),
        );
        Widget surface = AnimatedContainer(
          duration: duration,
          curve: curve,
          padding: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: resolved.material == null
                ? resolved.background?.color
                : null,
            gradient: resolved.material == null
                ? resolved.background?.gradient
                : null,
            border: Border.all(
              color: resolved.borderColor!,
              width: resolved.borderWidth!,
            ),
            borderRadius: resolved.borderRadius,
            boxShadow: resolved.boxShadow,
          ),
          child: field,
        );
        if (resolved.material != null) {
          surface = HyperMaterialSurface(
            material: resolved.material,
            borderRadius: resolved.borderRadius,
            clipBehavior: Clip.antiAlias,
            child: surface,
          );
        }
        return MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.label != null) ...[
                Text(widget.label!, style: resolved.labelStyle),
                SizedBox(height: resolved.labelGap),
              ],
              Semantics(
                label: widget.semanticLabel ?? widget.label,
                hint: _hasError ? widget.errorText : null,
                liveRegion: _hasError,
                validationResult: _hasError
                    ? SemanticsValidationResult.invalid
                    : SemanticsValidationResult.none,
                child: surface,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _action(
    HyperTextFieldStyle style,
    Duration duration,
    Curve curve, {
    required bool visible,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool enabled = true,
  }) => SizedBox(
    width: style.actionWidth,
    height: style.minimumHeight,
    child: IgnorePointer(
      ignoring: !visible || !enabled,
      child: ExcludeSemantics(
        excluding: !visible,
        child: AnimatedOpacity(
          opacity: visible ? 1 : 0,
          duration: duration,
          curve: curve,
          child: HyperPressable(
            enabled: enabled && visible,
            semanticLabel: label,
            onTap: onTap,
            mouseCursor: SystemMouseCursors.click,
            builder: (context, states, _) => Center(
              child: AnimatedSwitcher(
                duration: duration,
                switchInCurve: curve,
                switchOutCurve: curve,
                transitionBuilder: style.transitionBuilder ?? _transition,
                child: Icon(
                  icon,
                  key: ValueKey(icon),
                  size: style.iconSize,
                  color: style.iconColor,
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
  Widget _errorAction(
    HyperTextFieldStyle style,
    Duration duration,
    Curve curve,
  ) => _ErrorHint(
    errorText: widget.errorText,
    reserveSpace: widget.reserveErrorSpace,
    enabled: widget.enabled,
    errorBuilder: widget.errorBuilder,
    style: style,
    duration: duration,
    curve: curve,
  );
  static Widget _transition(Widget child, Animation<double> animation) =>
      FadeTransition(opacity: animation, child: child);
}

/// 浮层留在稳定的元素位置；错误图标淡出时不会保留仍打开的旧 Portal。
class _ErrorHint extends StatefulWidget {
  const _ErrorHint({
    required this.errorText,
    required this.reserveSpace,
    required this.enabled,
    required this.errorBuilder,
    required this.style,
    required this.duration,
    required this.curve,
  });
  final String? errorText;
  final bool reserveSpace;
  final bool enabled;
  final Widget Function(BuildContext, String)? errorBuilder;
  final HyperTextFieldStyle style;
  final Duration duration;
  final Curve curve;
  @override
  State<_ErrorHint> createState() => _ErrorHintState();
}

class _ErrorHintState extends State<_ErrorHint> {
  bool _pinned = false, _hovered = false;
  String _lastError = '';
  bool get _hasError => widget.errorText?.trim().isNotEmpty ?? false;
  @override
  void initState() {
    super.initState();
    if (_hasError) _lastError = widget.errorText!;
  }

  @override
  void didUpdateWidget(_ErrorHint oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_hasError) _lastError = widget.errorText!;
    if (oldWidget.errorText != widget.errorText || !widget.enabled) {
      _pinned = _hovered = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    // 保留退出动画期间的详情文本；不会缓存验证结果或业务数据。
    final error = _hasError ? widget.errorText! : _lastError;
    final hint = SizedBox(
      width: style.actionWidth,
      height: style.minimumHeight,
      child: HyperAnchoredOverlay.builder(
        placement: style.errorPlacement ?? HyperOverlayPlacement.bottomEnd,
        transitionBuilder: style.errorTransitionBuilder,
        isOpen: widget.enabled && _hasError && (_pinned || _hovered),
        onOpenChanged: (open) {
          if (!open && mounted) setState(() => _pinned = _hovered = false);
        },
        anchorBuilder: (context, toggle, isOpen) => MouseRegion(
          onEnter: (_) {
            if (widget.enabled && _hasError) setState(() => _hovered = true);
          },
          onExit: (_) => setState(() => _hovered = false),
          child: HyperPressable(
            enabled: widget.enabled && _hasError,
            onTap: () => setState(() => _pinned = !_pinned),
            onFocusChange: (focused) {
              if (!focused && mounted) setState(() => _pinned = false);
            },
            semanticLabel: _hasError ? '错误：$error' : null,
            excludeFromSemantics: !_hasError,
            mouseCursor: _hasError
                ? SystemMouseCursors.click
                : SystemMouseCursors.basic,
            builder: (context, states, _) => Center(
              child: AnimatedSwitcher(
                duration: widget.duration,
                switchInCurve: widget.curve,
                switchOutCurve: widget.curve,
                transitionBuilder: style.transitionBuilder ?? _transition,
                child: _hasError
                    ? Icon(
                        style.errorIcon,
                        key: const ValueKey('error'),
                        size: style.iconSize,
                        color: style.errorIconColor,
                      )
                    : const SizedBox.shrink(key: ValueKey('no-error')),
              ),
            ),
          ),
        ),
        overlayBuilder: (context, close) => ConstrainedBox(
          constraints: BoxConstraints(maxWidth: style.errorMaxWidth!),
          child:
              widget.errorBuilder?.call(context, error) ??
              HyperCard(
                style: style.errorPopupStyle,
                child: Text(error, style: style.errorTextStyle),
              ),
        ),
      ),
    );
    return TweenAnimationBuilder<double>(
      tween: Tween(end: widget.reserveSpace || _hasError ? 1.0 : 0.0),
      duration: widget.duration,
      curve: widget.curve,
      child: hint,
      builder: (context, factor, child) => ClipRect(
        child: Align(
          alignment: AlignmentDirectional.centerEnd,
          widthFactor: factor.clamp(0.0, 1.0).toDouble(),
          heightFactor: 1,
          child: child,
        ),
      ),
    );
  }

  static Widget _transition(Widget child, Animation<double> animation) =>
      FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: Tween<double>(begin: .85, end: 1).animate(animation),
          child: child,
        ),
      );
}
