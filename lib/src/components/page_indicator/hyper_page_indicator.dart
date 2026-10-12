import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_control_state.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../surface/hyper_material_surface.dart';
import 'hyper_page_indicator_model.dart';
import 'hyper_page_indicator_style.dart';
import 'hyper_page_indicator_theme.dart';

typedef HyperPageIndicatorLabelBuilder = String Function(
  int index,
  int pageCount,
);
typedef HyperPageIndicatorCounterBuilder = Widget Function(
  BuildContext context,
  int currentIndex,
  int pageCount,
);

/// 受控页面位置提示；不持有 PageController，不自动播放或切换页面。
class HyperPageIndicator extends StatelessWidget {
  const HyperPageIndicator({
    super.key,
    required this.pageCount,
    required this.currentIndex,
    this.variant = HyperPageIndicatorVariant.dots,
    this.maxVisibleDots = 7,
    this.direction = Axis.horizontal,
    this.enabled = true,
    this.onPageChanged,
    this.labelBuilder,
    this.counterBuilder,
    this.style,
  });
  final int pageCount, currentIndex, maxVisibleDots;
  final HyperPageIndicatorVariant variant;
  final Axis direction;
  final bool enabled;
  final ValueChanged<int>? onPageChanged;
  final HyperPageIndicatorLabelBuilder? labelBuilder;
  final HyperPageIndicatorCounterBuilder? counterBuilder;
  final HyperPageIndicatorStyle? style;
  @override
  Widget build(BuildContext context) {
    final model = HyperPageIndicatorModel(
      pageCount: pageCount,
      currentIndex: currentIndex,
      maxVisibleDots: maxVisibleDots,
    );
    if (pageCount == 0) {
      return const SizedBox.shrink();
    }
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final size = sizes.pageIndicator;
    final material = HyperMaterialTheme.of(context);
    final s = HyperPageIndicatorStyle(
      background: const HyperFill.none(),
      dotFill: HyperFill.color(theme.colors.outline),
      selectedDotFill: HyperFill.color(theme.colors.primary),
      material: material.material,
      materialQuality: material.quality,
      reduceTransparency: material.reduceTransparency,
      borderRadius: BorderRadius.zero,
      padding: size.padding,
      dotSize: size.dotSize,
      selectedWidth: size.selectedWidth,
      spacing: size.spacing,
      minimumTapTargetSize: Size.square(sizes.minimumInteractiveDimension),
      dotBorder: BorderSide.none,
      dotRadius: BorderRadius.circular(size.dotSize),
      focusColor: theme.colors.primary,
      disabledOpacity: .38,
      counterStyle: theme.textTheme.bodySmall?.copyWith(
        color: theme.colors.textSecondary,
      ),
      duration: theme.motion.fastDuration,
      curve: theme.motion.fastCurve,
    ).merge(HyperPageIndicatorTheme.of(context).style).merge(style);
    final duration = (MediaQuery.maybeOf(context)?.disableAnimations ?? false)
        ? Duration.zero
        : s.duration!;
    final interactive = enabled && onPageChanged != null;
    Widget dot(int index) {
      final selected = index == currentIndex;
      final label =
          labelBuilder?.call(index, pageCount) ??
          '第 ${index + 1} 页，共 $pageCount 页';
      final slotWidth = math.max(s.dotSize!, s.selectedWidth!);
      Widget visual(Set<HyperControlState> states) {
        final fill = selected ? s.selectedDotFill! : s.dotFill!;
        final focused = states.contains(HyperControlState.focused);
        return SizedBox(
          width: math.max(
            slotWidth,
            interactive ? s.minimumTapTargetSize!.width : 0,
          ),
          height: math.max(
            s.dotSize!,
            interactive ? s.minimumTapTargetSize!.height : 0,
          ),
          child: Center(
            child: AnimatedContainer(
              duration: duration,
              curve: s.curve!,
              width: selected ? s.selectedWidth : s.dotSize,
              height: s.dotSize,
              decoration: BoxDecoration(
                color: fill.color,
                gradient: fill.gradient,
                borderRadius: s.dotRadius,
                border: Border.fromBorderSide(
                  focused
                      ? s.dotBorder!.copyWith(
                          color: s.focusColor,
                          style: BorderStyle.solid,
                        )
                      : s.dotBorder!,
                ),
              ),
            ),
          ),
        );
      }

      return Semantics(
        selected: selected,
        label: label,
        child: interactive
            ? HyperPressable(
                onTap: selected ? () {} : () => onPageChanged!(index),
                mouseCursor: SystemMouseCursors.click,
                builder: (context, states, child) => visual(states),
              )
            : visual(const {}),
      );
    }

    Widget content;
    if (variant == HyperPageIndicatorVariant.number) {
      content = AnimatedDefaultTextStyle(
        style: s.counterStyle!,
        duration: duration,
        curve: s.curve!,
        textAlign: TextAlign.center,
        child: AnimatedSwitcher(
          duration: duration,
          switchInCurve: s.curve!,
          switchOutCurve: s.curve!,
          transitionBuilder:
              s.transitionBuilder ?? AnimatedSwitcher.defaultTransitionBuilder,
          child: KeyedSubtree(
            key: ValueKey((currentIndex, pageCount)),
            child:
                counterBuilder?.call(context, currentIndex, pageCount) ??
                Text(model.counter),
          ),
        ),
      );
    } else {
      content = Wrap(
        direction: direction,
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: s.spacing!,
        runSpacing: s.spacing!,
        children: [
          for (final index in model.visibleIndices)
            KeyedSubtree(key: ValueKey(index), child: dot(index)),
        ],
      );
    }
    content = AnimatedContainer(
      duration: duration,
      curve: s.curve!,
      padding: s.padding,
      decoration: BoxDecoration(
        color: s.background?.color,
        gradient: s.background?.gradient,
        borderRadius: s.borderRadius,
      ),
      child: content,
    );
    if (s.material != null) {
      content = HyperMaterialSurface(
        material: s.material,
        quality: s.materialQuality,
        reduceTransparency: s.reduceTransparency,
        borderRadius: s.borderRadius,
        child: content,
      );
    }
    return AnimatedOpacity(
      opacity: enabled ? 1 : s.disabledOpacity!,
      duration: duration,
      curve: s.curve!,
      child: AnimatedContainer(
        duration: duration,
        curve: s.curve!,
        decoration: BoxDecoration(
          borderRadius: s.borderRadius,
          boxShadow: s.boxShadow,
        ),
        foregroundDecoration: BoxDecoration(
          borderRadius: s.borderRadius,
          border: s.border,
        ),
        child: content,
      ),
    );
  }
}
