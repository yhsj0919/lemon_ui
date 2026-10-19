import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../theme/core/hyper_theme.dart';
import '../button/hyper_button.dart';
import '../card/hyper_card.dart';
import '../menu/hyper_menu.dart';
import '../menu/hyper_menu_model.dart';
import '../menu/hyper_menu_style.dart';
import '../menu/hyper_menu_theme.dart';
import '../menu/hyper_menu_surface.dart';
import 'hyper_select_model.dart';
import 'hyper_selection_style.dart';
import 'hyper_selection_layout.dart';

/// 面板只处理选项展示；输入、已选值和呈现方式由上层管理。
class HyperSelectPanel<T> extends StatelessWidget {
  const HyperSelectPanel({
    super.key,
    required this.controller,
    required this.selection,
    required this.onSelected,
    required this.style,
    required this.width,
    this.header,
    this.footer,
    this.maximumSelection,
    this.requestFocusOnOpen = true,
    this.navigationController,
    this.editing = false,
    this.showSurface = true,
  });
  final HyperSelectOptionsController<T> controller;
  final ValueListenable<Set<T>> selection;
  final ValueChanged<HyperSelectOption<T>> onSelected;
  final HyperSelectionStyle style;
  final double width;
  final Widget? header, footer;
  final int? maximumSelection;
  final bool requestFocusOnOpen;
  final bool editing;
  final bool showSurface;
  final HyperMenuNavigationController? navigationController;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: Listenable.merge([controller, selection]),
    builder: (context, _) {
      final sizes = HyperTheme.sizesOf(context);
      final values = selection.value;
      final options = controller.options;
      final menuVisual =
          HyperMenuTheme.of(context).style?.merge(style.menuStyle) ??
          style.menuStyle;
      final menuStyle = HyperMenuStyle(
        width: width,
        maxHeight: double.infinity,
        itemTextStyle: HyperTheme.of(context).textTheme.labelLarge
            ?.merge(menuVisual?.itemTextStyle),
      ).merge(style.menuStyle).copyWith(checkIcon: style.checkIcon);
      Widget body;
      if (controller.loading) {
        body = Text(style.loadingText ?? '正在加载…');
      } else if (controller.error != null) {
        body = Row(
          children: [
            Expanded(child: Text(style.errorText ?? '加载失败')),
            HyperButton.text(
              label: Text(style.retryText ?? '重试'),
              onPressed: controller.retry,
            ),
          ],
        );
      } else if (options.isEmpty) {
        body = Text(style.emptyText ?? '没有匹配的选项');
      } else {
        body = HyperMenu(
          showSurface: false,
          navigationController: navigationController,
          requestFocusOnOpen: requestFocusOnOpen,
          selectedIds: {
            for (final (index, option) in options.indexed)
              if (values.contains(option.value)) '$index',
          },
          style: menuStyle,
          items: [
            for (final (index, option) in options.indexed)
              HyperMenuItem(
                id: '$index',
                label: option.label,
                leading: option.leading,
                trailing: option.trailing,
                enabled:
                    option.enabled &&
                    (maximumSelection == null ||
                        values.contains(option.value) ||
                        values.length < maximumSelection!),
              ),
          ],
          onSelected: (id) => onSelected(options[int.parse(id)]),
        );
      }
      Widget surface(Widget child) => !showSurface
          ? child
          : HyperCard(
              width: width,
              style: resolveHyperMenuSurface(
                context,
                padding: menuVisual?.surfacePadding == null
                    ? hyperSelectionPadding(context, editing: editing)
                    : EdgeInsets.all(
                        menuVisual?.surfacePadding ?? sizes.menu.padding,
                      ),
                radius: menuVisual?.surfaceRadius ?? sizes.menu.surfaceRadius,
                style:
                    menuVisual?.surfaceStyle?.merge(style.surfaceStyle) ??
                    style.surfaceStyle,
              ),
              child: child,
            );
      return surface(
        SizedBox(
          width: width,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  (style.maxPanelHeight ?? sizes.selection.maxPanelHeight)
                      .clamp(
                        0,
                        MediaQuery.sizeOf(context).height -
                            MediaQuery.viewInsetsOf(context).bottom,
                      )
                      .toDouble(),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (header != null) ...[
                          header!,
                          SizedBox(height: sizes.navigationItemSpacing),
                        ],
                        AnimatedSwitcher(
                          transitionBuilder:
                              style.feedbackTransitionBuilder ??
                              AnimatedSwitcher.defaultTransitionBuilder,
                          duration:
                              MediaQuery.maybeOf(context)?.disableAnimations ==
                                  true
                              ? Duration.zero
                              : style.duration ??
                                    HyperTheme.of(context).motion.fastDuration,
                          switchInCurve:
                              style.curve ??
                              HyperTheme.of(context).motion.fastCurve,
                          child: KeyedSubtree(
                            key: ValueKey(
                              controller.loading
                                  ? 'loading'
                                  : controller.error != null
                                  ? 'error'
                                  : options.isEmpty
                                  ? 'empty'
                                  : 'options',
                            ),
                            child: body,
                          ),
                        ),
                        if (controller.hasMore || controller.moreError != null)
                          HyperButton.text(
                            label: Text(
                              controller.loadingMore
                                  ? (style.loadingText ?? '正在加载…')
                                  : controller.moreError != null
                                  ? (style.retryText ?? '重试')
                                  : (style.loadMoreText ?? '加载更多'),
                            ),
                            onPressed: controller.loadingMore
                                ? null
                                : controller.retry,
                          ),
                      ],
                    ),
                  ),
                ),
                if (footer != null) ...[
                  SizedBox(height: sizes.menu.padding),
                  footer!,
                ],
              ],
            ),
          ),
        ),
      );
    },
  );
}
