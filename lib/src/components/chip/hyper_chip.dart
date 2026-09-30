import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../foundation/hyper_control_state.dart';
import '../../foundation/hyper_fill.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/core/hyper_theme.dart';
import '../tooltip/hyper_tooltip.dart';
import 'hyper_chip_style.dart';
import 'hyper_chip_theme.dart';

/// 受控交互标签；选中、删除和列表关系由调用方管理。
class HyperChip extends StatelessWidget {
  const HyperChip({
    super.key,
    required this.label,
    this.selected = false,
    this.onSelected,
    this.onPressed,
    this.onDeleted,
    this.enabled = true,
    this.icon,
    this.avatar,
    this.deleteIcon,
    this.deleteTooltip,
    this.showCheckmark,
    this.style,
    this.focusNode,
    this.deleteFocusNode,
    this.autofocus = false,
  }) : assert(onSelected == null || onPressed == null, '选择与普通点击只能提供一种。'),
       assert(icon == null || avatar == null, '图标与头像只能提供一种。');
  const HyperChip.action({
    Key? key,
    required String label,
    VoidCallback? onPressed,
    bool enabled = true,
    Widget? icon,
    HyperChipStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
  }) : this(
         key: key,
         label: label,
         onPressed: onPressed,
         enabled: enabled,
         icon: icon,
         style: style,
         focusNode: focusNode,
         autofocus: autofocus,
         showCheckmark: false,
       );
  const HyperChip.choice({
    Key? key,
    required String label,
    required bool selected,
    ValueChanged<bool>? onSelected,
    bool enabled = true,
    Widget? icon,
    Widget? avatar,
    bool? showCheckmark,
    HyperChipStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
  }) : this(
         key: key,
         label: label,
         selected: selected,
         onSelected: onSelected,
         enabled: enabled,
         icon: icon,
         avatar: avatar,
         showCheckmark: showCheckmark,
         style: style,
         focusNode: focusNode,
         autofocus: autofocus,
       );
  const HyperChip.filter({
    Key? key,
    required String label,
    required bool selected,
    ValueChanged<bool>? onSelected,
    bool enabled = true,
    Widget? icon,
    Widget? avatar,
    bool? showCheckmark,
    HyperChipStyle? style,
    FocusNode? focusNode,
    bool autofocus = false,
  }) : this(
         key: key,
         label: label,
         selected: selected,
         onSelected: onSelected,
         enabled: enabled,
         icon: icon,
         avatar: avatar,
         showCheckmark: showCheckmark,
         style: style,
         focusNode: focusNode,
         autofocus: autofocus,
       );
  const HyperChip.input({
    Key? key,
    required String label,
    VoidCallback? onDeleted,
    bool selected = false,
    ValueChanged<bool>? onSelected,
    bool enabled = true,
    Widget? icon,
    Widget? avatar,
    Widget? deleteIcon,
    String? deleteTooltip,
    bool? showCheckmark,
    HyperChipStyle? style,
    FocusNode? focusNode,
    FocusNode? deleteFocusNode,
    bool autofocus = false,
  }) : this(
         key: key,
         label: label,
         onDeleted: onDeleted,
         selected: selected,
         onSelected: onSelected,
         enabled: enabled,
         icon: icon,
         avatar: avatar,
         deleteIcon: deleteIcon,
         deleteTooltip: deleteTooltip,
         showCheckmark: showCheckmark,
         style: style,
         focusNode: focusNode,
         deleteFocusNode: deleteFocusNode,
         autofocus: autofocus,
       );
  final String label;
  final bool selected, enabled, autofocus;
  final ValueChanged<bool>? onSelected;
  final VoidCallback? onPressed, onDeleted;
  final Widget? icon, avatar, deleteIcon;
  final String? deleteTooltip;
  final bool? showCheckmark;
  final HyperChipStyle? style;
  final FocusNode? focusNode, deleteFocusNode;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final metrics = sizes.chip;
    final chipTheme = HyperChipTheme.of(context);
    final interactive =
        enabled &&
        (onSelected != null || onPressed != null || onDeleted != null);
    final bodyEnabled = enabled && (onSelected != null || onPressed != null);
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    Widget visualBuilder(
      BuildContext context,
      Set<HyperControlState> states,
      Widget? child,
    ) {
      final visualStates = <HyperControlState>{...states}
        ..remove(HyperControlState.disabled);
      if (selected) visualStates.add(HyperControlState.selected);
      if (!interactive) visualStates.add(HyperControlState.disabled);
      final colors = theme.colors;
      final defaults = HyperChipStyle(
        background: HyperFill.color(
          !interactive
              ? colors.surfaceMuted
              : selected
              ? colors.primaryContainer
              : colors.surfaceMuted,
        ),
        foregroundColor: !interactive
            ? colors.disabled
            : selected
            ? colors.onPrimaryContainer
            : colors.textSecondary,
        borderColor: states.contains(HyperControlState.focused)
            ? colors.primary
            : colors.outline,
        borderWidth: states.contains(HyperControlState.focused) && interactive
            ? 1
            : 0,
        height: metrics.height,
        horizontalPadding: metrics.horizontalPadding,
        radius: metrics.radius,
        iconSize: metrics.iconSize,
        avatarSize: metrics.avatarSize,
        avatarOpacity: interactive ? 1 : .4,
        iconSpacing: metrics.iconSpacing,
        deleteIconSize: metrics.deleteIconSize,
        deleteTargetWidth: metrics.deleteTargetWidth,
        minimumTapTargetSize: sizes.minimumInteractiveDimension,
        showCheckmark: true,
        checkmarkIcon: Icons.check,
        deleteIcon: Icons.close,
        duration: theme.motion.fastDuration,
        curve: theme.motion.fastCurve,
      );
      final resolved = defaults
          .merge(chipTheme.resolve(visualStates))
          .merge(style);
      final duration = reduceMotion ? Duration.zero : resolved.duration!;
      final curve = resolved.curve!;
      final foreground = resolved.foregroundColor!;
      final height = resolved.height!;
      final tapHeight = math.max(height, resolved.minimumTapTargetSize!);
      final verticalSpace = (tapHeight - height) / 2;
      final isPressed = states.contains(HyperControlState.pressed);
      final isHovered = states.contains(HyperControlState.hovered);
      final overlay =
          resolved.overlayColor ??
          colors.stateLayer.withValues(
            alpha: !interactive
                ? 0
                : isPressed
                ? .09
                : isHovered
                ? .05
                : 0,
          );
      final leading = avatar ?? icon;
      final showCheck = (showCheckmark ?? resolved.showCheckmark!) && selected;
      final textStyle = (theme.textTheme.labelMedium ?? const TextStyle())
          .copyWith(color: foreground, height: 1)
          .merge(resolved.textStyle);
      Widget animatedIcon(Widget child, double? size) =>
          TweenAnimationBuilder<Color?>(
            tween: ColorTween(end: foreground),
            duration: duration,
            curve: curve,
            builder: (context, color, child) => IconTheme.merge(
              data: IconThemeData(size: size, color: color),
              child: child!,
            ),
            child: child,
          );
      return ConstrainedBox(
        constraints: BoxConstraints(minHeight: tapHeight, minWidth: tapHeight),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(
              child: AnimatedContainer(
                duration: duration,
                curve: curve,
                margin: EdgeInsets.symmetric(vertical: verticalSpace),
                decoration: BoxDecoration(
                  color: resolved.background?.color,
                  gradient: resolved.background?.gradient,
                  borderRadius: BorderRadius.circular(resolved.radius!),
                  border: resolved.borderWidth! > 0
                      ? Border.all(
                          color: resolved.borderColor!,
                          width: resolved.borderWidth!,
                        )
                      : null,
                  boxShadow: resolved.boxShadow,
                ),
                foregroundDecoration: BoxDecoration(
                  color: overlay,
                  borderRadius: BorderRadius.circular(resolved.radius!),
                ),
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: resolved.horizontalPadding!,
                      vertical: verticalSpace,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (leading != null) ...[
                          ExcludeSemantics(
                            child: avatar != null
                                ? AnimatedOpacity(
                                    duration: duration,
                                    curve: curve,
                                    opacity: resolved.avatarOpacity!.clamp(
                                      0.0,
                                      1.0,
                                    ),
                                    child: SizedBox.square(
                                      dimension: resolved.avatarSize,
                                      child: leading,
                                    ),
                                  )
                                : animatedIcon(leading, resolved.iconSize),
                          ),
                          SizedBox(width: resolved.iconSpacing),
                        ],
                        AnimatedSize(
                          duration: duration,
                          curve: curve,
                          alignment: AlignmentDirectional.centerStart,
                          child: AnimatedSwitcher(
                            duration: duration,
                            transitionBuilder:
                                resolved.transitionBuilder ??
                                AnimatedSwitcher.defaultTransitionBuilder,
                            child: showCheck
                                ? Row(
                                    key: const ValueKey(true),
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ExcludeSemantics(
                                        child: animatedIcon(
                                          Icon(resolved.checkmarkIcon),
                                          resolved.iconSize,
                                        ),
                                      ),
                                      SizedBox(width: resolved.iconSpacing),
                                    ],
                                  )
                                : const SizedBox.shrink(key: ValueKey(false)),
                          ),
                        ),
                        Flexible(
                          child: ExcludeSemantics(
                            child: AnimatedDefaultTextStyle(
                              duration: duration,
                              curve: curve,
                              style: textStyle,
                              child: Text(
                                label,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (onDeleted != null)
                  HyperTooltip(
                    message: deleteTooltip ?? '删除 $label',
                    child: HyperPressable(
                      enabled: enabled,
                      onTap: enabled ? onDeleted : null,
                      focusNode: deleteFocusNode,
                      semanticLabel: deleteTooltip ?? '删除 $label',
                      mouseCursor: enabled
                          ? SystemMouseCursors.click
                          : SystemMouseCursors.basic,
                      builder: (context, deleteStates, child) => SizedBox(
                        width: resolved.deleteTargetWidth,
                        height: tapHeight,
                        child: Center(
                          child: AnimatedContainer(
                            duration: duration,
                            curve: curve,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                resolved.radius!,
                              ),
                              color:
                                  deleteStates.contains(
                                        HyperControlState.focused,
                                      ) ||
                                      deleteStates.contains(
                                        HyperControlState.hovered,
                                      ) ||
                                      deleteStates.contains(
                                        HyperControlState.pressed,
                                      )
                                  ? resolved.overlayColor ??
                                        colors.stateLayer.withValues(
                                          alpha: !enabled
                                              ? 0
                                              : deleteStates.contains(
                                                  HyperControlState.pressed,
                                                )
                                              ? .12
                                              : .08,
                                        )
                                  : Colors.transparent,
                            ),
                            padding: EdgeInsets.all(resolved.iconSpacing! / 2),
                            child: ExcludeSemantics(
                              child: animatedIcon(
                                deleteIcon ?? Icon(resolved.deleteIcon),
                                resolved.deleteIconSize,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      );
    }

    final Widget result;
    if (bodyEnabled) {
      result = HyperPressable(
        enabled: true,
        focusNode: focusNode,
        autofocus: autofocus,
        semanticLabel: label,
        mouseCursor: SystemMouseCursors.click,
        onTap: () {
          if (onSelected != null) {
            onSelected!(!selected);
          } else {
            onPressed?.call();
          }
        },
        builder: visualBuilder,
      );
    } else {
      result = Semantics(
        label: label,
        enabled: interactive,
        child: visualBuilder(context, const {}, null),
      );
    }
    return Semantics(
      container: true,
      selected: onSelected != null || selected ? selected : null,
      child: result,
    );
  }
}
