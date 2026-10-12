import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../surface/hyper_material_surface.dart';
import 'hyper_description_list_model.dart';
import 'hyper_description_list_style.dart';
import 'hyper_description_list_theme.dart';

/// 标签和值的描述列表。父布局须提供有限宽度，业务内容由调用方管理。
class HyperDescriptionList extends StatelessWidget {
  const HyperDescriptionList({
    super.key,
    required this.items,
    this.columns = 1,
    this.responsive = true,
    this.bordered = false,
    this.labelPlacement = HyperDescriptionLabelPlacement.inline,
    this.title,
    this.extra,
    this.style,
    this.transitionBuilder,
  });
  final List<HyperDescriptionItem> items;
  final int columns;
  final bool responsive, bordered;
  final HyperDescriptionLabelPlacement labelPlacement;
  final Widget? title, extra;
  final HyperDescriptionListStyle? style;

  /// 替换值变化的默认淡入淡出；不参与列宽计算。
  final AnimatedSwitcherTransitionBuilder? transitionBuilder;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final size = HyperTheme.sizesOf(context).descriptionList;
    final material = HyperMaterialTheme.of(context);
    final s = HyperDescriptionListStyle(
      background: bordered
          ? HyperFill.color(theme.colors.surfaceElevated)
          : const HyperFill.none(),
      labelBackground: bordered
          ? HyperFill.color(theme.colors.surfaceMuted)
          : const HyperFill.none(),
      valueBackground: const HyperFill.none(),
      material: material.material,
      materialQuality: material.quality,
      reduceTransparency: material.reduceTransparency,
      borderColor: theme.colors.outline,
      borderThickness: size.borderThickness,
      borderRadius: BorderRadius.circular(size.radius),
      cellPadding: size.cellPadding,
      columnSpacing: size.columnSpacing,
      rowSpacing: size.rowSpacing,
      labelValueSpacing: size.labelValueSpacing,
      headerSpacing: size.headerSpacing,
      minimumColumnWidth: size.minimumColumnWidth,
      labelFlex: 1,
      valueFlex: 2,
      labelStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colors.textSecondary,
      ),
      valueStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colors.textPrimary,
      ),
      titleStyle: theme.textTheme.titleMedium?.copyWith(
        color: theme.colors.textPrimary,
      ),
      placeholder: '—',
      duration: theme.motion.fastDuration,
      curve: theme.motion.fastCurve,
    ).merge(HyperDescriptionListTheme.of(context).style).merge(style);
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    Duration duration(HyperDescriptionListStyle style) =>
        reduced ? Duration.zero : style.duration!;
    final direction = Directionality.of(context);
    final gap = bordered ? 0.0 : s.columnSpacing!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final layout = HyperDescriptionListLayout(
          items,
          columns: columns,
          width: constraints.maxWidth,
          minimumColumnWidth: s.minimumColumnWidth!,
          spacing: gap,
          responsive: responsive,
        );
        Widget cell(HyperDescriptionPlacement placement, bool last) {
          final item = placement.item;
          final cs = s.merge(item.style);
          assert(cs.labelFlex! > 0 && cs.valueFlex! > 0);
          final padding = cs.cellPadding!.resolve(direction);
          Widget part(
            Widget child,
            TextStyle text,
            HyperFill fill, {
            bool value = false,
          }) => AnimatedContainer(
            duration: duration(cs),
            curve: cs.curve!,
            padding: cs.cellPadding,
            decoration: BoxDecoration(
              color: fill.color,
              gradient: fill.gradient,
            ),
            child: AnimatedDefaultTextStyle(
              style: text,
              duration: duration(cs),
              curve: cs.curve!,
              child: value
                  ? AnimatedSwitcher(
                      duration: duration(cs),
                      switchInCurve: cs.curve!,
                      switchOutCurve: cs.curve!,
                      transitionBuilder:
                          transitionBuilder ??
                          cs.transitionBuilder ??
                          AnimatedSwitcher.defaultTransitionBuilder,
                      child: child,
                    )
                  : child,
            ),
          );
          final label = part(item.label, cs.labelStyle!, cs.labelBackground!);
          final value = part(
            item.value ?? Text(cs.placeholder!),
            cs.valueStyle!,
            cs.valueBackground!,
            value: true,
          );
          final separation = bordered
              ? cs.borderThickness!
              : cs.labelValueSpacing!;
          Widget content;
          if (labelPlacement == HyperDescriptionLabelPlacement.above) {
            content = Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                label,
                SizedBox(
                  height: separation,
                  child: bordered ? ColoredBox(color: cs.borderColor!) : null,
                ),
                value,
              ],
            );
          } else {
            content = Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (cs.labelWidth == null)
                  Expanded(flex: cs.labelFlex!, child: label)
                else
                  SizedBox(
                    width: math.min(
                      math.max(0, cs.labelWidth!),
                      math.max(
                        0,
                        placement.width - separation - padding.horizontal,
                      ),
                    ),
                    child: label,
                  ),
                SizedBox(
                  width: separation,
                  child: bordered ? ColoredBox(color: cs.borderColor!) : null,
                ),
                Expanded(flex: cs.valueFlex!, child: value),
              ],
            );
          }
          return SizedBox(
            width: placement.width,
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                border: bordered && !last
                    ? BorderDirectional(
                        end: BorderSide(
                          color: s.borderColor!,
                          width: s.borderThickness!,
                        ),
                      )
                    : null,
              ),
              child: content,
            ),
          );
        }

        Widget body = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var r = 0; r < layout.rows.length; r++) ...[
              if (r > 0)
                SizedBox(
                  height: bordered ? s.borderThickness : s.rowSpacing,
                  child: bordered ? ColoredBox(color: s.borderColor!) : null,
                ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (var c = 0; c < layout.rows[r].length; c++) ...[
                      if (c > 0) SizedBox(width: gap),
                      KeyedSubtree(
                        key: ValueKey(layout.rows[r][c].item.id),
                        child: cell(
                          layout.rows[r][c],
                          c == layout.rows[r].length - 1,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ],
        );
        body = AnimatedContainer(
          duration: duration(s),
          curve: s.curve!,
          decoration: BoxDecoration(
            color: s.material == null ? s.background!.color : null,
            gradient: s.material == null ? s.background!.gradient : null,
            borderRadius: s.borderRadius,
          ),
          child: body,
        );
        if (s.material != null) {
          body = HyperMaterialSurface(
            material: s.material,
            quality: s.materialQuality,
            reduceTransparency: s.reduceTransparency,
            borderRadius: s.borderRadius,
            child: body,
          );
        }
        body = ClipRRect(
          borderRadius: s.borderRadius!.resolve(direction),
          child: body,
        );
        if (bordered) {
          // 前景边框不占布局宽度，跨列与普通列使用同一套宽度。
          body = DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              border: Border.all(
                color: s.borderColor!,
                width: s.borderThickness!,
              ),
              borderRadius: s.borderRadius,
            ),
            child: body,
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null || extra != null) ...[
              AnimatedDefaultTextStyle(
                style: s.titleStyle!,
                duration: duration(s),
                curve: s.curve!,
                child: Wrap(
                  spacing: s.headerSpacing!,
                  runSpacing: s.headerSpacing!,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [?title, ?extra],
                ),
              ),
              SizedBox(height: s.headerSpacing),
            ],
            body,
          ],
        );
      },
    );
  }
}
