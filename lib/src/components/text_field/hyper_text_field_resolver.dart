import '../../foundation/hyper_icons.dart';

import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../../foundation/hyper_control_state.dart';
import '../../foundation/hyper_fill.dart';
import '../card/hyper_card_style.dart';
import 'hyper_text_field_style.dart';
import 'hyper_text_field_theme.dart';

// Shared input and composite-input resolution; keep state and instance
// precedence identical when a containing control owns the outer surface.
HyperTextFieldStyle resolveHyperTextFieldStyle(
  BuildContext context, {
  required Set<HyperControlState> states,
  HyperTextFieldStyle? style,
}) {
  final theme = HyperTheme.of(context);
  final metrics = HyperTheme.sizesOf(context).textField;
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
        height: theme.textTheme.labelLarge?.height ?? 1,
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
      errorIcon: HyperIcons.circleAlert,
      clearIcon: HyperIcons.x,
      showPasswordIcon: HyperIcons.eye,
      hidePasswordIcon: HyperIcons.eyeOff,
      errorIconColor: theme.colors.error,
      errorMaxWidth: metrics.errorMaxWidth,
      errorTextStyle: theme.textTheme.bodySmall?.copyWith(
        color: theme.colors.textPrimary,
      ),
      errorPopupStyle: HyperCardStyle(
        padding: EdgeInsets.all(metrics.horizontalPadding),
      ),
    ),
    hovered: HyperTextFieldStyle(
      background: HyperFill.color(
        Color.alphaBlend(
          theme.colors.stateLayer.withValues(
            alpha: HyperTheme.sizesOf(context).button.hoverOverlayOpacity,
          ),
          theme.colors.surfaceMuted,
        ),
      ),
    ),
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
  return defaults
      .merge(HyperTextFieldTheme.of(context))
      .resolve(states)
      .merge(style);
}
