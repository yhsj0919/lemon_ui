import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_control_state.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../../theme/size/components/hyper_step_size.dart';
import '../surface/hyper_material_surface.dart';
import 'hyper_step_model.dart';
import 'hyper_step_style.dart';

class HyperStepsBody extends StatelessWidget {
  const HyperStepsBody({
    super.key,
    required this.model,
    required this.direction,
    required this.metrics,
    required this.resolveTheme,
    this.style,
    this.onStepChanged,
    this.enabled = true,
  });
  final HyperStepModel model;
  final Axis direction;
  final HyperStepSize metrics;
  final HyperStepStyle Function(HyperStepStatus) resolveTheme;
  final HyperStepStyle? style;
  final ValueChanged<int>? onStepChanged;
  final bool enabled;
  @override
  Widget build(BuildContext context) {
    if (model.items.isEmpty) {
      return const SizedBox.shrink();
    }
    final theme = HyperTheme.of(context);
    final material = HyperMaterialTheme.of(context);
    final reduce = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    HyperStepStyle resolve(int index) {
      final status = model.statusAt(index);
      final accent = status == HyperStepStatus.error
          ? theme.colors.error
          : theme.colors.primary;
      final emphasized =
          status == HyperStepStatus.current || status == HyperStepStatus.error;
      final muted =
          status == HyperStepStatus.pending ||
          status == HyperStepStatus.disabled;
      final fill = emphasized ? accent : theme.colors.surfaceMuted;
      final foreground = emphasized
          ? (status == HyperStepStatus.error
                ? theme.colors.onError
                : theme.colors.onPrimary)
          : muted
          ? theme.colors.textTertiary
          : theme.colors.primary;
      return HyperStepStyle(
            nodeFill: HyperFill.color(fill),
            foregroundColor: foreground,
            material: material.material,
            materialQuality: material.quality,
            reduceTransparency: material.reduceTransparency,
            nodeBorder: BorderSide.none,
            nodeBorderRadius: BorderRadius.circular(metrics.nodeSize),
            nodeSize: metrics.nodeSize,
            iconSize: metrics.iconSize,
            spacing: metrics.spacing,
            titleSpacing: metrics.titleSpacing,
            itemSpacing: metrics.itemSpacing,
            connectorThickness: metrics.connectorThickness,
            connectorColor: status == HyperStepStatus.completed
                ? theme.colors.primary
                : theme.colors.outline,
            titleStyle: theme.textTheme.bodyMedium?.copyWith(
              color: muted
                  ? theme.colors.textSecondary
                  : theme.colors.textPrimary,
            ),
            descriptionStyle: theme.textTheme.bodySmall?.copyWith(
              color: theme.colors.textSecondary,
            ),
            indexStyle: theme.textTheme.bodyMedium,
            statusLabel: switch (status) {
              HyperStepStatus.pending => '待开始',
              HyperStepStatus.current => '当前步骤',
              HyperStepStatus.completed => '已完成',
              HyperStepStatus.error => '错误',
              HyperStepStatus.disabled => '禁用',
            },
            completedIcon: Icons.check,
            errorIcon: Icons.close,
            interactionRadius: BorderRadius.circular(metrics.interactionRadius),
            overlayColor: theme.colors.stateLayer,
            hoverOpacity: .06,
            focusOpacity: .06,
            pressedOpacity: .10,
            duration: theme.motion.fastDuration,
            curve: theme.motion.fastCurve,
          )
          .merge(resolveTheme(status))
          .merge(style)
          .merge(model.items[index].style);
    }

    final resolved = [for (var i = 0; i < model.items.length; i++) resolve(i)];
    Widget line(int owner, {bool visible = true, bool vertical = false}) {
      final s = resolved[owner];
      return AnimatedContainer(
        duration: reduce ? Duration.zero : s.duration!,
        curve: s.curve!,
        width: vertical ? s.connectorThickness : null,
        height: vertical ? null : s.connectorThickness,
        color: visible ? s.connectorColor : Colors.transparent,
      );
    }

    Widget tile(int index) {
      final item = model.items[index], s = resolved[index];
      final status = model.statusAt(index);
      final duration = reduce ? Duration.zero : s.duration!;
      Widget symbol =
          item.icon ??
          (status == HyperStepStatus.completed
              ? Icon(s.completedIcon)
              : status == HyperStepStatus.error
              ? Icon(s.errorIcon)
              : Text('${index + 1}'));
      symbol = KeyedSubtree(key: ValueKey(item.icon ?? status), child: symbol);
      Widget marker = AnimatedContainer(
        duration: duration,
        curve: s.curve!,
        width: s.nodeSize,
        height: s.nodeSize,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: s.material == null ? s.nodeFill?.color : null,
          gradient: s.material == null ? s.nodeFill?.gradient : null,
          borderRadius: s.nodeBorderRadius,
        ),
        foregroundDecoration: BoxDecoration(
          border: Border.fromBorderSide(s.nodeBorder!),
          borderRadius: s.nodeBorderRadius,
        ),
        child: Center(
          child: IconTheme(
            data: IconThemeData(size: s.iconSize, color: s.foregroundColor),
            child: AnimatedDefaultTextStyle(
              duration: duration,
              curve: s.curve!,
              style: s.indexStyle!.copyWith(color: s.foregroundColor),
              child: AnimatedSwitcher(
                duration: duration,
                switchInCurve: s.curve!,
                switchOutCurve: s.curve!,
                transitionBuilder:
                    s.transitionBuilder ??
                    AnimatedSwitcher.defaultTransitionBuilder,
                child: symbol,
              ),
            ),
          ),
        ),
      );
      if (s.material != null) {
        marker = HyperMaterialSurface(
          material: s.material,
          quality: s.materialQuality,
          reduceTransparency: s.reduceTransparency,
          borderRadius: s.nodeBorderRadius,
          width: s.nodeSize,
          height: s.nodeSize,
          clipBehavior: Clip.antiAlias,
          child: marker,
        );
      }
      marker = ExcludeSemantics(child: marker);
      final text = Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: direction == Axis.horizontal
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: [
          AnimatedDefaultTextStyle(
            duration: duration,
            curve: s.curve!,
            style: s.titleStyle!,
            textAlign: direction == Axis.horizontal
                ? TextAlign.center
                : TextAlign.start,
            child: item.title,
          ),
          if (item.description != null) ...[
            SizedBox(height: s.titleSpacing),
            AnimatedDefaultTextStyle(
              duration: duration,
              curve: s.curve!,
              style: s.descriptionStyle!,
              textAlign: direction == Axis.horizontal
                  ? TextAlign.center
                  : TextAlign.start,
              child: item.description!,
            ),
          ],
        ],
      );
      Widget content;
      if (direction == Axis.horizontal) {
        content = Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(end: s.spacing!),
                    child: line(index == 0 ? 0 : index - 1, visible: index > 0),
                  ),
                ),
                marker,
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(start: s.spacing!),
                    child: line(index, visible: index < model.items.length - 1),
                  ),
                ),
              ],
            ),
            SizedBox(height: s.spacing),
            text,
          ],
        );
      } else {
        content = IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: s.nodeSize,
                child: Column(
                  children: [
                    marker,
                    SizedBox(
                      height: index < model.items.length - 1 ? s.spacing : 0,
                    ),
                    Expanded(
                      child: Center(
                        child: line(
                          index,
                          vertical: true,
                          visible: index < model.items.length - 1,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: s.spacing),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: index == model.items.length - 1
                        ? 0
                        : s.itemSpacing!,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: s.nodeSize!),
                    child: Align(
                      alignment: AlignmentDirectional.topStart,
                      child: text,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
      final interactive =
          enabled && onStepChanged != null && model.canSelect(index);
      if (onStepChanged != null) {
        content = HyperPressable(
          enabled: interactive,
          onTap: () => onStepChanged!(index),
          builder: (context, states, child) {
            final alpha = states.contains(HyperControlState.pressed)
                ? s.pressedOpacity!
                : states.contains(HyperControlState.focused)
                ? s.focusOpacity!
                : states.contains(HyperControlState.hovered)
                ? s.hoverOpacity!
                : 0.0;
            return AnimatedContainer(
              duration: duration,
              curve: s.curve!,
              constraints: BoxConstraints(
                minHeight: HyperTheme.sizesOf(context)
                    .minimumInteractiveDimension,
              ),
              decoration: BoxDecoration(
                color: s.overlayColor!.withValues(alpha: alpha.clamp(0, 1)),
                borderRadius: s.interactionRadius,
              ),
              child: child,
            );
          },
          child: content,
        );
      }
      return Semantics(
        key: ValueKey(item.id),
        container: true,
        selected: index == model.currentStep,
        label: item.semanticLabel,
        value: s.statusLabel,
        enabled: onStepChanged == null ? null : interactive,
        child: content,
      );
    }

    return direction == Axis.horizontal
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < model.items.length; i++)
                Expanded(key: ValueKey(model.items[i].id), child: tile(i)),
            ],
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [for (var i = 0; i < model.items.length; i++) tile(i)],
          );
  }
}
