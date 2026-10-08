import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../theme/core/hyper_theme.dart';
import '../button/hyper_button_theme.dart';
import '../icon_button/hyper_icon_button.dart';
import '../icon_button/hyper_icon_button_style.dart';
import '../surface/hyper_material_surface.dart';
import 'hyper_notice_style.dart';

/// 内部呈现单元，接收已解析样式，不读取 Alert 或 Banner 主题。
class HyperNoticeBody extends StatelessWidget {
  const HyperNoticeBody({
    super.key,
    required this.content,
    required this.style,
    this.title,
    this.icon,
    this.showIcon = true,
    this.actions = const [],
    this.onClose,
    this.closeButton,
    this.visible = true,
    this.semanticLabel,
    this.liveRegion = true,
  });
  final Widget content;
  final Widget? title, icon, closeButton;
  final bool showIcon, visible, liveRegion;
  final List<Widget> actions;
  final VoidCallback? onClose;
  final String? semanticLabel;
  final HyperNoticeStyle style;

  @override
  Widget build(BuildContext context) {
    final duration = (MediaQuery.maybeOf(context)?.disableAnimations ?? false)
        ? Duration.zero
        : style.duration!;
    final close =
        closeButton ??
        (onClose == null
            ? null
            : HyperIconButton.ghost(
                icon: Icon(style.closeIcon),
                onPressed: onClose,
                tooltip:
                    style.closeLabel ??
                    Localizations.of<MaterialLocalizations>(
                      context,
                      MaterialLocalizations,
                    )?.closeButtonTooltip ??
                    '关闭',
                style: HyperIconButtonStyle(
                  background: const HyperFill.none(),
                  foregroundColor: style.closeIconColor,
                  iconSize: style.closeIconSize,
                  size: style.closeButtonSize,
                  minimumTapTargetSize: HyperTheme.sizesOf(context)
                      .minimumInteractiveDimension,
                ),
              ));
    final text = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          AnimatedDefaultTextStyle(
            style: style.titleStyle!,
            duration: duration,
            curve: style.curve!,
            child: title!,
          ),
          SizedBox(height: style.titleSpacing),
        ],
        AnimatedDefaultTextStyle(
          style: style.contentStyle!,
          duration: duration,
          curve: style.curve!,
          child: content,
        ),
        if (actions.isNotEmpty) ...[
          SizedBox(height: style.actionSpacing),
          Wrap(
            alignment: style.actionsAlignment!,
            spacing: style.actionSpacing!,
            runSpacing: style.actionRunSpacing!,
            children: [
              for (final action in actions)
                if (style.buttonTheme != null)
                  HyperButtonTheme(data: style.buttonTheme!, child: action)
                else
                  action,
            ],
          ),
        ],
      ],
    );
    final body = Padding(
      padding: style.padding!,
      child: Row(
        crossAxisAlignment: title == null && actions.isEmpty
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          if (showIcon) ...[
            TweenAnimationBuilder<Color?>(
              tween: ColorTween(end: style.iconColor),
              duration: duration,
              curve: style.curve!,
              builder: (context, color, child) => IconTheme(
                data: IconThemeData(color: color, size: style.iconSize),
                child: AnimatedSwitcher(
                  duration: duration,
                  switchInCurve: style.curve!,
                  switchOutCurve: style.curve!,
                  child: icon ?? Icon(style.icon, key: ValueKey(style.icon)),
                ),
              ),
            ),
            SizedBox(width: style.spacing),
          ],
          Expanded(child: text),
          if (close != null) ...[SizedBox(width: style.spacing), close],
        ],
      ),
    );
    Widget surface = AnimatedContainer(
      duration: duration,
      curve: style.curve!,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: style.material == null ? style.background?.color : null,
        gradient: style.material == null ? style.background?.gradient : null,
        border: style.border,
        borderRadius: style.borderRadius,
        boxShadow: style.boxShadow,
      ),
      child: ClipRRect(
        borderRadius: style.borderRadius!,
        child: Material(type: MaterialType.transparency, child: body),
      ),
    );
    if (style.material != null) {
      surface = HyperMaterialSurface(
        material: style.material,
        quality: style.materialQuality,
        reduceTransparency: style.reduceTransparency,
        borderRadius: style.borderRadius,
        clipBehavior: Clip.antiAlias,
        child: surface,
      );
    }
    surface = AnimatedSize(
      duration: duration,
      curve: style.curve!,
      alignment: Alignment.topCenter,
      child: surface,
    );
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: visible ? 1 : 0),
      duration: duration,
      curve: style.curve!,
      child: IgnorePointer(
        ignoring: !visible,
        child: ExcludeFocus(
          excluding: !visible,
          child: ExcludeSemantics(
            excluding: !visible,
            child: Semantics(
              liveRegion: liveRegion,
              label: semanticLabel,
              child: surface,
            ),
          ),
        ),
      ),
      builder: (context, value, child) =>
          style.transitionBuilder?.call(context, value, child!) ??
          ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: value.clamp(0, 1),
              child: Opacity(opacity: value.clamp(0, 1), child: child),
            ),
          ),
    );
  }
}
