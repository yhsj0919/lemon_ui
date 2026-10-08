import 'package:flutter/material.dart';

import '../../foundation/hyper_control_state.dart';
import '../../foundation/hyper_fill.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../button/hyper_button_theme.dart';
import '../icon_button/hyper_icon_button.dart';
import '../icon_button/hyper_icon_button_style.dart';
import '../surface/hyper_material_surface.dart';
import 'hyper_notification_defaults.dart';
import 'hyper_notification_style.dart';
import 'hyper_notification_theme.dart';

/// 通知卡片，不持有通知数据、日期格式化、已读状态或队列。
class HyperNotification extends StatelessWidget {
  const HyperNotification({
    super.key,
    required this.content,
    this.title,
    this.time,
    this.icon,
    this.showIcon = true,
    this.isRead = false,
    this.showUnreadIndicator = true,
    this.unreadIndicator,
    this.actions = const [],
    this.onTap,
    this.onClose,
    this.closeButton,
    this.enabled = true,
    this.visible = true,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.style,
  });
  final Widget content;
  final Widget? title, time, icon, unreadIndicator, closeButton;
  final bool showIcon, isRead, showUnreadIndicator, enabled, visible, autofocus;
  final List<Widget> actions;
  final VoidCallback? onTap, onClose;
  final FocusNode? focusNode;
  final String? semanticLabel;
  final HyperNotificationStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final componentTheme = HyperNotificationTheme.of(context);
    final defaults = notificationDefaults(
      theme: theme,
      metrics: sizes.notification,
      materialTheme: HyperMaterialTheme.of(context),
      isRead: isRead,
    );
    Widget buildVisual(Set<HyperControlState> states) {
      final resolved = defaults
          .merge(componentTheme.resolve(isRead: isRead, states: states))
          .merge(style);
      final duration = (MediaQuery.maybeOf(context)?.disableAnimations ?? false)
          ? Duration.zero
          : resolved.duration!;
      Widget? close =
          closeButton ??
          (onClose == null
              ? null
              : HyperIconButton.ghost(
                  icon: Icon(resolved.closeIcon),
                  onPressed: enabled ? onClose : null,
                  tooltip:
                      resolved.closeLabel ??
                      Localizations.of<MaterialLocalizations>(
                        context,
                        MaterialLocalizations,
                      )?.closeButtonTooltip ??
                      '关闭',
                  style: HyperIconButtonStyle(
                    background: const HyperFill.none(),
                    foregroundColor: resolved.closeIconColor,
                    iconSize: resolved.closeIconSize,
                    size: resolved.closeButtonSize,
                    minimumTapTargetSize: sizes.minimumInteractiveDimension,
                  ),
                ));
      final unread = ExcludeSemantics(
        excluding: isRead,
        child: AnimatedSize(
          duration: duration,
          curve: resolved.curve!,
          child: AnimatedSwitcher(
            duration: duration,
            switchInCurve: resolved.curve!,
            switchOutCurve: resolved.curve!,
            child: isRead
                ? const SizedBox.shrink(key: ValueKey('read'))
                : Semantics(
                    key: const ValueKey('unread'),
                    label: resolved.unreadLabel,
                    child:
                        unreadIndicator ??
                        Container(
                          width: resolved.unreadSize,
                          height: resolved.unreadSize,
                          decoration: BoxDecoration(
                            color: resolved.unreadColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                  ),
          ),
        ),
      );
      final text = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null || showUnreadIndicator) ...[
            Wrap(
              spacing: resolved.spacing!,
              runSpacing: resolved.titleSpacing!,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (title != null)
                  AnimatedDefaultTextStyle(
                    style: resolved.titleStyle!,
                    duration: duration,
                    curve: resolved.curve!,
                    child: title!,
                  ),
                if (showUnreadIndicator) unread,
              ],
            ),
            if (title != null || !isRead)
              SizedBox(height: resolved.titleSpacing),
          ],
          if (time != null) ...[
            AnimatedDefaultTextStyle(
              style: resolved.timeStyle!,
              duration: duration,
              curve: resolved.curve!,
              child: time!,
            ),
            SizedBox(height: resolved.titleSpacing),
          ],
          AnimatedDefaultTextStyle(
            style: resolved.contentStyle!,
            duration: duration,
            curve: resolved.curve!,
            child: content,
          ),
          if (actions.isNotEmpty) ...[
            SizedBox(height: resolved.actionSpacing),
            Wrap(
              alignment: resolved.actionsAlignment!,
              spacing: resolved.actionSpacing!,
              runSpacing: resolved.actionRunSpacing!,
              children: [
                for (final action in actions)
                  if (resolved.buttonTheme != null)
                    HyperButtonTheme(data: resolved.buttonTheme!, child: action)
                  else
                    action,
              ],
            ),
          ],
        ],
      );
      final body = Padding(
        padding: resolved.padding!,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showIcon) ...[
              IconTheme(
                data: IconThemeData(
                  color: resolved.iconColor,
                  size: resolved.iconSize,
                ),
                child: icon ?? Icon(resolved.icon),
              ),
              SizedBox(width: resolved.spacing),
            ],
            Expanded(child: text),
            if (close != null) ...[SizedBox(width: resolved.spacing), close],
          ],
        ),
      );
      final opacity = !enabled
          ? 0.0
          : states.contains(HyperControlState.pressed)
          ? resolved.pressedOpacity!
          : states.contains(HyperControlState.focused)
          ? resolved.focusOpacity!
          : states.contains(HyperControlState.hovered)
          ? resolved.hoverOpacity!
          : 0.0;
      Widget surface = AnimatedContainer(
        duration: duration,
        curve: resolved.curve!,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: resolved.material == null ? resolved.background?.color : null,
          gradient: resolved.material == null
              ? resolved.background?.gradient
              : null,
          borderRadius: resolved.borderRadius,
          boxShadow: resolved.boxShadow,
        ),
        foregroundDecoration: BoxDecoration(
          color: resolved.overlayColor!.withValues(alpha: opacity.clamp(0, 1)),
          border: resolved.border,
          borderRadius: resolved.borderRadius,
        ),
        child: ClipRRect(
          borderRadius: resolved.borderRadius!,
          child: Material(type: MaterialType.transparency, child: body),
        ),
      );
      if (resolved.material != null) {
        surface = HyperMaterialSurface(
          material: resolved.material,
          quality: resolved.materialQuality,
          reduceTransparency: resolved.reduceTransparency,
          borderRadius: resolved.borderRadius,
          clipBehavior: Clip.antiAlias,
          child: surface,
        );
      }
      surface = AnimatedOpacity(
        opacity: enabled ? 1 : resolved.disabledOpacity!.clamp(0, 1),
        duration: duration,
        curve: resolved.curve!,
        child: AnimatedSize(
          duration: duration,
          curve: resolved.curve!,
          alignment: Alignment.topCenter,
          child: surface,
        ),
      );
      return TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: visible ? 1 : 0),
        duration: duration,
        curve: resolved.curve!,
        child: IgnorePointer(
          ignoring: !visible || !enabled,
          child: ExcludeFocus(
            excluding: !visible || !enabled,
            child: ExcludeSemantics(excluding: !visible, child: surface),
          ),
        ),
        builder: (context, value, child) =>
            resolved.transitionBuilder?.call(context, value, child!) ??
            ClipRect(
              child: Align(
                alignment: Alignment.topCenter,
                heightFactor: value.clamp(0, 1),
                child: Opacity(opacity: value.clamp(0, 1), child: child),
              ),
            ),
      );
    }

    final card = onTap == null
        ? buildVisual({if (!enabled) HyperControlState.disabled})
        : HyperPressable(
            enabled: enabled && visible,
            onTap: onTap,
            focusNode: focusNode,
            autofocus: autofocus,
            builder: (context, states, child) => buildVisual(states),
          );
    return ExcludeSemantics(
      excluding: !visible,
      child: Semantics(
        container: true,
        enabled: enabled,
        label: semanticLabel,
        child: card,
      ),
    );
  }
}
