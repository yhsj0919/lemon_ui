import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_control_state.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../surface/hyper_material_surface.dart';
import 'hyper_collapsible_style.dart';
import 'hyper_collapsible_theme.dart';

/// 受控折叠区域；无 header 时仅负责 child 的展开和收起。
class HyperCollapsible extends StatelessWidget {
  const HyperCollapsible({
    super.key,
    required this.expanded,
    required this.child,
    this.header,
    this.onExpandedChanged,
    this.leading,
    this.trailing,
    this.enabled = true,
    this.showIndicator = true,
    this.maintainState = true,
    this.axis = Axis.vertical,
    this.focusNode,
    this.autofocus = false,
    this.semanticLabel,
    this.style,
  });
  final bool expanded, enabled, showIndicator, maintainState, autofocus;
  final Widget child;
  final Widget? header, leading, trailing;
  final ValueChanged<bool>? onExpandedChanged;
  final Axis axis;
  final FocusNode? focusNode;
  final String? semanticLabel;
  final HyperCollapsibleStyle? style;
  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).collapsible;
    final material = HyperMaterialTheme.of(context);
    final resolved =
        HyperCollapsibleStyle(
              background: HyperFill.color(theme.colors.surfaceElevated),
              material: material.material,
              materialQuality: material.quality,
              reduceTransparency: material.reduceTransparency,
              borderRadius: BorderRadius.circular(metrics.radius),
              headerPadding: metrics.headerPadding,
              contentPadding: metrics.contentPadding,
              headerMinHeight: metrics.headerMinHeight,
              iconSize: metrics.iconSize,
              spacing: metrics.spacing,
              headerStyle: theme.textTheme.titleSmall?.copyWith(
                color: theme.colors.textPrimary,
              ),
              iconColor: theme.colors.textSecondary,
              indicatorIcon: Icons.expand_more,
              overlayColor: theme.colors.stateLayer,
              hoverOpacity: .06,
              focusOpacity: .06,
              pressedOpacity: .10,
              disabledOpacity: .38,
              duration: theme.motion.standardDuration,
              curve: theme.motion.standardCurve,
            )
            .merge(
              HyperCollapsibleTheme.of(context)
                  .resolve(isExpanded: expanded, enabled: enabled),
            )
            .merge(style);
    final duration = (MediaQuery.maybeOf(context)?.disableAnimations ?? false)
        ? Duration.zero
        : resolved.duration!;
    final content = _Content(
      expanded: expanded,
      maintainState: maintainState,
      axis: axis,
      duration: duration,
      curve: resolved.curve!,
      transitionBuilder: resolved.transitionBuilder,
      child: Padding(padding: resolved.contentPadding!, child: child),
    );
    Widget buildHeader(Set<HyperControlState> states) {
      final alpha = !enabled
          ? 0.0
          : states.contains(HyperControlState.pressed)
          ? resolved.pressedOpacity!
          : states.contains(HyperControlState.focused)
          ? resolved.focusOpacity!
          : states.contains(HyperControlState.hovered)
          ? resolved.hoverOpacity!
          : 0.0;
      return AnimatedContainer(
        duration: duration,
        curve: resolved.curve!,
        color: resolved.overlayColor!.withValues(alpha: alpha.clamp(0, 1)),
        constraints: BoxConstraints(minHeight: resolved.headerMinHeight!),
        padding: resolved.headerPadding,
        child: AnimatedDefaultTextStyle(
          duration: duration,
          curve: resolved.curve!,
          style: resolved.headerStyle!,
          child: IconTheme(
            data: IconThemeData(
              size: resolved.iconSize,
              color: resolved.iconColor,
            ),
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  SizedBox(width: resolved.spacing),
                ],
                Expanded(child: header!),
                if (trailing != null) ...[
                  SizedBox(width: resolved.spacing),
                  trailing!,
                ],
                if (showIndicator) ...[
                  SizedBox(width: resolved.spacing),
                  AnimatedRotation(
                    turns: expanded ? .5 : 0,
                    duration: duration,
                    curve: resolved.curve!,
                    child: Icon(resolved.indicatorIcon),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    final trigger = header == null
        ? null
        : Semantics(
            expanded: expanded,
            label: semanticLabel,
            child: onExpandedChanged == null
                ? buildHeader({})
                : HyperPressable(
                    enabled: enabled,
                    onTap: () => onExpandedChanged!(!expanded),
                    focusNode: focusNode,
                    autofocus: autofocus,
                    builder: (context, states, child) => buildHeader(states),
                  ),
          );
    final body = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: axis == Axis.vertical
          ? CrossAxisAlignment.stretch
          : CrossAxisAlignment.start,
      children: [?trigger, content],
    );
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
      ),
      foregroundDecoration: BoxDecoration(
        border: resolved.border,
        borderRadius: resolved.borderRadius,
      ),
      child: ClipRRect(borderRadius: resolved.borderRadius!, child: body),
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
    return AnimatedOpacity(
      opacity: enabled ? 1 : resolved.disabledOpacity!.clamp(0, 1),
      duration: duration,
      curve: resolved.curve!,
      child: IgnorePointer(
        ignoring: !enabled,
        child: ExcludeFocus(excluding: !enabled, child: surface),
      ),
    );
  }
}

/// 动画完成后才卸载内容，maintainState 时离屏内容不参与布局与交互。
class _Content extends StatefulWidget {
  const _Content({
    required this.expanded,
    required this.maintainState,
    required this.axis,
    required this.duration,
    required this.curve,
    required this.child,
    this.transitionBuilder,
  });
  final bool expanded, maintainState;
  final Axis axis;
  final Duration duration;
  final Curve curve;
  final Widget child;
  final HyperCollapsibleTransitionBuilder? transitionBuilder;
  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
    value: widget.expanded ? 1 : 0,
  )..addStatusListener(_status);
  void _status(AnimationStatus status) {
    if (status == AnimationStatus.dismissed) {
      setState(() {});
    }
  }

  @override
  void didUpdateWidget(_Content oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.duration = widget.duration;
    if (widget.duration == Duration.zero) {
      _controller.value = widget.expanded ? 1 : 0;
    } else if (oldWidget.expanded != widget.expanded) {
      widget.expanded ? _controller.forward() : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final hidden = !widget.expanded && _controller.isDismissed;
    if (hidden && !widget.maintainState) {
      return const SizedBox.shrink();
    }
    return Offstage(
      offstage: hidden,
      child: TickerMode(
        enabled: !hidden,
        child: IgnorePointer(
          ignoring: !widget.expanded,
          child: ExcludeFocus(
            excluding: !widget.expanded,
            child: ExcludeSemantics(
              excluding: !widget.expanded,
              child: AnimatedBuilder(
                animation: _controller,
                child: widget.child,
                builder: (context, child) {
                  final value = widget.curve
                      .transform(_controller.value)
                      .clamp(0.0, 1.0);
                  return widget.transitionBuilder?.call(
                        context,
                        value,
                        widget.axis,
                        child!,
                      ) ??
                      ClipRect(
                        child: Align(
                          alignment: AlignmentDirectional.topStart,
                          heightFactor: widget.axis == Axis.vertical
                              ? value
                              : 1,
                          widthFactor: widget.axis == Axis.horizontal
                              ? value
                              : 1,
                          child: Opacity(opacity: value, child: child),
                        ),
                      );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
