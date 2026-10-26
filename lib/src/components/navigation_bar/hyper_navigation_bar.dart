import '../sidebar/hyper_sidebar.dart';
import '../sidebar/hyper_sidebar_model.dart';
import '../sidebar/hyper_sidebar_style.dart';
import '../sidebar/hyper_sidebar_theme.dart';
import '../../interaction/hyper_pressable.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/motion/hyper_motion_theme.dart';

import 'package:flutter/material.dart';

import '../card/hyper_card_style.dart';
import '../surface/hyper_navigation_surface.dart';
import '../overlay/hyper_overlay_material.dart';
import 'hyper_navigation_bar_style.dart';
import 'hyper_navigation_bar_theme.dart';

enum HyperNavigationLabelVisibility { all, selected, none }

enum HyperNavigationLabelPlacement { below, beside }

@immutable
class HyperNavigationDestination<T> {
  const HyperNavigationDestination({
    required this.value,
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.enabled = true,
  });
  final T value;
  final String label;
  final Widget icon;
  final Widget? selectedIcon;
  final bool enabled;
}

/// Bottom navigation or a vertical rail. Selection and routing belong to the parent.
class HyperNavigationBar<T> extends StatefulWidget {
  HyperNavigationBar({
    super.key,
    required List<HyperNavigationDestination<T>> destinations,
    this.selectedValue,
    this.onSelected,
    this.direction = Axis.horizontal,
    this.labelVisibility = HyperNavigationLabelVisibility.all,
    this.labelPlacement = HyperNavigationLabelPlacement.below,
    this.enabled = true,
    this.equalExtent = true,
    this.collapsed,
    this.useSafeArea = true,
    this.style,
  }) : destinations = List.unmodifiable(destinations) {
    if (destinations.length < 2 ||
        destinations.map((d) => d.value).toSet().length !=
            destinations.length) {
      throw ArgumentError('Material 导航至少需要两项，且 value 唯一');
    }
  }
  final List<HyperNavigationDestination<T>> destinations;
  final T? selectedValue;
  final ValueChanged<T>? onSelected;
  final Axis direction;
  final HyperNavigationLabelVisibility labelVisibility;
  final HyperNavigationLabelPlacement labelPlacement;
  final bool enabled, equalExtent, useSafeArea;
  final bool? collapsed;
  final HyperNavigationBarStyle? style;
  @override
  State<HyperNavigationBar<T>> createState() => _HyperNavigationBarState<T>();
}

class _HyperNavigationBarState<T> extends State<HyperNavigationBar<T>> {
  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final sidebar =
        HyperSidebarTheme.of(context).style ?? const HyperSidebarStyle();
    final metrics = sizes.sidebar;
    final duration = theme.motion.durationFor(
      HyperMotionSpeed.standard,
      disableAnimations:
          MediaQuery.maybeOf(context)?.disableAnimations ?? false,
    );
    final style = HyperNavigationBarTheme.of(context).style.merge(widget.style);
    final selectedColor =
        style.selectedItemStyle?.foregroundColor ??
        sidebar.selectedForegroundColor ??
        theme.colors.primary;
    final normalColor =
        style.itemStyle?.foregroundColor ??
        sidebar.foregroundColor ??
        theme.colors.textPrimary;
    final disabledColor = sidebar.disabledColor ?? theme.colors.disabled;
    final interactive = widget.enabled && widget.onSelected != null;
    final surface = HyperCardStyle(
      material: HyperOverlayMaterial.fallback(
        context,
        componentMaterial: style.surfaceStyle?.material,
        hasExplicitBackground: style.surfaceStyle?.background != null,
      ),
      padding: EdgeInsets.zero,
      border: const Border(),
      borderRadius: BorderRadius.zero,
    ).merge(sidebar.surfaceStyle).merge(style.surfaceStyle);
    if (widget.direction == Axis.vertical) {
      final index = widget.destinations.indexWhere(
        (d) => d.value == widget.selectedValue,
      );
      return HyperSidebar(
        collapsed:
            widget.collapsed ??
            widget.labelPlacement != HyperNavigationLabelPlacement.beside,
        selectedId: index < 0 ? null : '$index',
        onSelected: interactive
            ? (id) =>
                  widget.onSelected!(widget.destinations[int.parse(id)].value)
            : null,
        items: [
          for (var i = 0; i < widget.destinations.length; i++)
            HyperSidebarItem(
              id: '$i',
              label: widget.destinations[i].label,
              icon: widget.destinations[i].value == widget.selectedValue
                  ? widget.destinations[i].selectedIcon ??
                        widget.destinations[i].icon
                  : widget.destinations[i].icon,
              enabled: interactive && widget.destinations[i].enabled,
            ),
        ],
        style: HyperSidebarStyle(
          foregroundColor: normalColor,
          selectedForegroundColor: selectedColor,
          iconColor: normalColor,
          selectedIconColor: selectedColor,
          disabledColor: disabledColor,
          disabledIconColor: sidebar.disabledIconColor ?? disabledColor,
          selectedBackgroundColor: Colors.transparent,
          iconSize: style.iconSize,
          collapsedIconSize: style.iconSize,
          itemTextStyle: style.labelStyle,
          surfaceStyle: surface,
        ),
      );
    }
    final barMetrics = sizes.navigationBar;
    final iconSize = style.iconSize ?? barMetrics.iconSize;
    final textStyle =
        (sidebar.itemTextStyle ??
                theme.textTheme.titleMedium ??
                const TextStyle())
            .copyWith(
              fontSize: theme.typography.listTitle,
              height: theme.typography.listTitleLineHeight,
            )
            .merge(style.labelStyle);
    Widget item(HyperNavigationDestination<T> d) {
      final selected = widget.selectedValue == d.value;
      final enabled = interactive && d.enabled;
      final color = !enabled
          ? disabledColor
          : selected
          ? selectedColor
          : normalColor;
      final showLabel =
          widget.labelVisibility == HyperNavigationLabelVisibility.all ||
          widget.labelVisibility == HyperNavigationLabelVisibility.selected &&
              selected;
      return TweenAnimationBuilder<Color?>(
        tween: ColorTween(end: color),
        duration: duration,
        curve: theme.motion.standardCurve,
        builder: (context, animatedColor, _) {
          final icon = IconTheme(
            data: IconThemeData(size: iconSize, color: animatedColor),
            child: AnimatedSwitcher(
              duration: duration,
              switchInCurve: theme.motion.standardCurve,
              switchOutCurve: theme.motion.standardCurve,
              child: KeyedSubtree(
                key: ValueKey(selected),
                child: selected ? d.selectedIcon ?? d.icon : d.icon,
              ),
            ),
          );
          final label = Text(
            d.label,
            textAlign: TextAlign.center,
            style: textStyle.copyWith(color: animatedColor),
          );
          final gap = style.itemSpacing ?? barMetrics.itemSpacing;
          return Semantics(
            selected: selected,
            child: HyperPressable(
              enabled: enabled,
              semanticLabel: d.label,
              mouseCursor: enabled
                  ? SystemMouseCursors.click
                  : SystemMouseCursors.basic,
              onTap: enabled
                  ? () {
                      if (!selected) widget.onSelected!(d.value);
                    }
                  : null,
              builder: (_, states, child) => child!,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: barMetrics.verticalPadding,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        (barMetrics.minHeight - barMetrics.verticalPadding * 2)
                            .clamp(0, double.infinity),
                  ),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(end: showLabel ? 1.0 : 0.0),
                    duration: duration,
                    curve: theme.motion.standardCurve,
                    builder: (context, visibility, _) {
                      final beside =
                          widget.labelPlacement ==
                          HyperNavigationLabelPlacement.beside;
                      return LayoutBuilder(
                        builder: (context, constraints) {
                          final text =
                              TextPainter(
                                text: TextSpan(text: d.label, style: textStyle),
                                textDirection: Directionality.of(context),
                                textScaler: MediaQuery.textScalerOf(context),
                              )..layout(
                                maxWidth: beside
                                    ? (constraints.maxWidth - iconSize - gap)
                                          .clamp(0, double.infinity)
                                    : constraints.maxWidth,
                              );
                          final labelSize = text.size;
                          text.dispose();
                          if (widget.labelVisibility ==
                              HyperNavigationLabelVisibility.none)
                            return Center(child: icon);
                          final width = beside
                              ? iconSize + gap + labelSize.width
                              : (iconSize > labelSize.width
                                    ? iconSize
                                    : labelSize.width);
                          final height = beside
                              ? (iconSize > labelSize.height
                                    ? iconSize
                                    : labelSize.height)
                              : iconSize + gap + labelSize.height;
                          final direction =
                              Directionality.of(context) == TextDirection.rtl
                              ? -1.0
                              : 1.0;
                          return SizedBox(
                            width: width,
                            height: height,
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              children: [
                                Transform.translate(
                                  offset: beside
                                      ? Offset(
                                          -direction *
                                              (gap + labelSize.width) /
                                              2 *
                                              visibility,
                                          0,
                                        )
                                      : Offset(
                                          0,
                                          -(gap + labelSize.height) /
                                              2 *
                                              visibility,
                                        ),
                                  child: icon,
                                ),
                                Align(
                                  alignment: beside
                                      ? AlignmentDirectional.centerEnd
                                      : Alignment.bottomCenter,
                                  child: IgnorePointer(
                                    child: ExcludeSemantics(
                                      excluding: !showLabel,
                                      child: Opacity(
                                        opacity: visibility,
                                        child: Transform.translate(
                                          offset: beside
                                              ? Offset(
                                                  direction *
                                                      gap *
                                                      (1 - visibility),
                                                  0,
                                                )
                                              : Offset(
                                                  0,
                                                  gap * (1 - visibility),
                                                ),
                                          child: label,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
          );
        },
      );
    }

    Widget content = LayoutBuilder(
      builder: (_, constraints) {
        final minWidth = sidebar.collapsedWidth ?? metrics.collapsedWidth;
        if (constraints.hasBoundedWidth &&
            widget.equalExtent &&
            constraints.maxWidth >= minWidth * widget.destinations.length) {
          return Row(
            children: [
              for (final d in widget.destinations) Expanded(child: item(d)),
            ],
          );
        }
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final d in widget.destinations)
                SizedBox(width: minWidth, child: item(d)),
            ],
          ),
        );
      },
    );
    if (widget.useSafeArea) content = SafeArea(top: false, child: content);
    return HyperNavigationSurface(
      inheritMaterial: true,
      style: surface,
      child: content,
    );
  }
}
