import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../theme/core/hyper_theme.dart';
import '../icon_button/hyper_icon_button.dart';
import '../icon_button/hyper_icon_button_style.dart';
import '../overlay/hyper_modal_content.dart';
import '../surface/hyper_material_surface.dart';
import 'hyper_bottom_sheet_style.dart';
import 'hyper_bottom_sheet_theme.dart';

HyperBottomSheetStyle _resolveStyle(
  BuildContext context,
  HyperBottomSheetStyle? style,
) {
  final theme = HyperTheme.of(context);
  final metrics = HyperTheme.sizesOf(context).bottomSheet;
  return HyperBottomSheetStyle(
    background: HyperFill.color(theme.colors.surfaceElevated),
    borderRadius: BorderRadius.vertical(top: Radius.circular(metrics.radius)),
    maxWidth: metrics.maxWidth,
    padding: metrics.padding,
    titleStyle: theme.textTheme.titleMedium ?? const TextStyle(),
    contentStyle: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      color: theme.colors.textSecondary,
    ),
    titleSpacing: metrics.titleSpacing,
    actionSpacing: metrics.actionSpacing,
    actionRunSpacing: metrics.actionRunSpacing,
    actionsAlignment: WrapAlignment.end,
    actionsDirection: Axis.horizontal,
    closeIcon: Icons.close,
    closeIconColor: theme.colors.textSecondary,
    closeIconSize: metrics.closeIconSize,
    dragHandleColor: theme.colors.textTertiary,
    dragHandleSize: metrics.dragHandleSize,
    dragHandleBorderRadius: BorderRadius.circular(metrics.dragHandleRadius),
    dragHandlePadding: metrics.dragHandlePadding,
    barrierColor: Colors.black.withValues(alpha: .4),
    animationStyle: AnimationStyle(
      duration: theme.motion.standardDuration,
      reverseDuration: theme.motion.fastDuration,
      curve: theme.motion.standardCurve,
      reverseCurve: theme.motion.fastCurve,
    ),
    clipBehavior: Clip.antiAlias,
  ).merge(HyperBottomSheetTheme.of(context).style).merge(style);
}

/// 底部面板表面与内容；拖动及模态路由由 [showHyperBottomSheet] 管理。
class HyperBottomSheet extends StatelessWidget {
  const HyperBottomSheet({
    super.key,
    this.title,
    required this.content,
    this.actions = const [],
    this.showDragHandle = true,
    this.dragHandle,
    this.showCloseButton = false,
    this.onClose,
    this.scrollable = true,
    this.useBottomSafeArea = true,
    this.semanticLabel,
    this.style,
  });
  final Widget? title;
  final Widget content;
  final List<Widget> actions;
  final bool showDragHandle, showCloseButton, scrollable, useBottomSafeArea;
  final Widget? dragHandle;
  final VoidCallback? onClose;
  final String? semanticLabel;
  final HyperBottomSheetStyle? style;

  @override
  Widget build(BuildContext context) {
    final resolved = _resolveStyle(context, style);
    final reduced = MediaQuery.of(context).disableAnimations;
    final motion = HyperTheme.of(context).motion;
    final duration = reduced
        ? Duration.zero
        : (resolved.animationStyle?.duration ?? motion.fastDuration);
    final curve = resolved.animationStyle?.curve ?? motion.fastCurve;
    Widget layout = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (showDragHandle)
          Padding(
            padding: resolved.dragHandlePadding!,
            child: Center(
              child:
                  dragHandle ??
                  ExcludeSemantics(
                    child: Container(
                      width: resolved.dragHandleSize!.width,
                      height: resolved.dragHandleSize!.height,
                      decoration: BoxDecoration(
                        color: resolved.dragHandleColor,
                        borderRadius: resolved.dragHandleBorderRadius,
                      ),
                    ),
                  ),
            ),
          ),
        Flexible(
          fit: resolved.height != null ? FlexFit.tight : FlexFit.loose,
          child: HyperModalContent(
            title: title,
            closeButton: showCloseButton
                ? HyperIconButton.ghost(
                    icon: Icon(resolved.closeIcon!),
                    tooltip: MaterialLocalizations.of(context)
                        .closeButtonTooltip,
                    style: HyperIconButtonStyle(
                      foregroundColor: resolved.closeIconColor,
                      iconSize: resolved.closeIconSize,
                    ),
                    onPressed: onClose ?? () => Navigator.of(context).pop(),
                  )
                : null,
            content: content,
            actions: actions,
            scrollable: scrollable,
            expandContent: resolved.height != null,
            padding: resolved.padding!,
            titleStyle: resolved.titleStyle!,
            contentStyle: resolved.contentStyle!,
            titleSpacing: resolved.titleSpacing!,
            actionSpacing: resolved.actionSpacing!,
            actionRunSpacing: resolved.actionRunSpacing!,
            actionsAlignment: resolved.actionsAlignment!,
            actionsDirection: resolved.actionsDirection!,
            buttonTheme: resolved.buttonTheme,
          ),
        ),
      ],
    );
    if (useBottomSafeArea) {
      layout = SafeArea(top: false, left: false, right: false, child: layout);
    }
    Widget surface = AnimatedContainer(
      height: resolved.height,
      duration: duration,
      curve: curve,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: resolved.material == null ? resolved.background?.color : null,
        gradient: resolved.material == null
            ? resolved.background?.gradient
            : null,
        border: resolved.border,
        borderRadius: resolved.borderRadius,
        boxShadow: resolved.boxShadow,
      ),
      child: ClipRRect(
        borderRadius: resolved.borderRadius!,
        clipBehavior: resolved.clipBehavior!,
        child: Material(type: MaterialType.transparency, child: layout),
      ),
    );
    if (resolved.material != null) {
      surface = HyperMaterialSurface(
        material: resolved.material,
        borderRadius: resolved.borderRadius,
        clipBehavior: resolved.clipBehavior!,
        child: surface,
      );
    }
    return Semantics(
      label: semanticLabel,
      child: AnimatedPadding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        duration: duration,
        curve: curve,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: resolved.maxWidth!,
            maxHeight: resolved.maxHeight ?? double.infinity,
          ),
          child: SizedBox(
            width: resolved.width ?? resolved.maxWidth,
            child: surface,
          ),
        ),
      ),
    );
  }
}

/// 原生模态底部路由：复用拖动关闭、焦点与返回结果。
Future<T?> showHyperBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  HyperBottomSheetStyle? style,
  bool enableDrag = true,
  bool barrierDismissible = true,
  String? barrierLabel,
  bool useRootNavigator = true,
  bool useSafeArea = true,
  bool? requestFocus,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
}) {
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  final themes = InheritedTheme.capture(from: context, to: navigator.context);
  final resolved = _resolveStyle(context, style);
  final reduced = MediaQuery.of(context).disableAnimations;
  final direction = Directionality.of(context);
  return navigator.push<T>(
    ModalBottomSheetRoute<T>(
      capturedThemes: themes,
      builder: (routeContext) {
        Widget page = HyperBottomSheetTheme(
          data: HyperBottomSheetThemeData(style: resolved),
          child: Directionality(
            textDirection: direction,
            child: Builder(builder: builder),
          ),
        );
        if (reduced) {
          page = MediaQuery(
            data: MediaQuery.of(routeContext).copyWith(disableAnimations: true),
            child: page,
          );
        }
        return page;
      },
      isScrollControlled: true,
      enableDrag: enableDrag,
      isDismissible: barrierDismissible,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: const RoundedRectangleBorder(),
      clipBehavior: Clip.none,
      constraints: BoxConstraints(maxWidth: resolved.maxWidth!),
      modalBarrierColor: resolved.barrierColor,
      barrierLabel:
          barrierLabel ??
          MaterialLocalizations.of(context).modalBarrierDismissLabel,
      sheetAnimationStyle: reduced
          ? AnimationStyle.noAnimation
          : resolved.animationStyle,
      useSafeArea: useSafeArea,
      requestFocus: requestFocus,
      settings: routeSettings,
      anchorPoint: anchorPoint,
    ),
  );
}
