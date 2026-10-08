import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../theme/core/hyper_theme.dart';
import '../overlay/hyper_modal_content.dart';
import '../icon_button/hyper_icon_button.dart';
import '../icon_button/hyper_icon_button_style.dart';
import '../surface/hyper_material_surface.dart';
import 'hyper_dialog_style.dart';
import 'hyper_dialog_theme.dart';

/// 对话框负责表面与内容布局；路由开合使用 [showHyperDialog]。
class HyperDialog extends StatelessWidget {
  const HyperDialog({
    super.key,
    this.title,
    required this.content,
    this.actions = const [],
    this.showCloseButton = true,
    this.onClose,
    this.scrollable = true,
    this.semanticLabel,
    this.style,
  });

  final Widget? title;
  final Widget content;
  final List<Widget> actions;
  final bool showCloseButton;
  final VoidCallback? onClose;

  /// 默认正文滚动，标题和按钮固定；自带滚动的内容可关闭此包装。
  final bool scrollable;
  final String? semanticLabel;
  final HyperDialogStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).dialog;
    final resolved = HyperDialogStyle(
      background: HyperFill.color(theme.colors.surfaceElevated),
      borderRadius: BorderRadius.circular(metrics.radius),
      maxWidth: metrics.maxWidth,
      padding: metrics.padding,
      insetPadding: metrics.insetPadding,
      alignment: Alignment.center,
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
      clipBehavior: Clip.antiAlias,
    ).merge(HyperDialogTheme.of(context).style).merge(style);
    final layout = HyperModalContent(
      title: title,
      closeButton: showCloseButton
          ? HyperIconButton.ghost(
              icon: Icon(resolved.closeIcon!),
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
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
      padding: resolved.padding!,
      titleStyle: resolved.titleStyle!,
      contentStyle: resolved.contentStyle!,
      titleSpacing: resolved.titleSpacing!,
      actionSpacing: resolved.actionSpacing!,
      actionRunSpacing: resolved.actionRunSpacing!,
      actionsAlignment: resolved.actionsAlignment!,
      actionsDirection: resolved.actionsDirection!,
      buttonTheme: resolved.buttonTheme,
    );
    Widget surface = AnimatedContainer(
      duration: MediaQuery.of(context).disableAnimations
          ? Duration.zero
          : (resolved.duration ?? theme.motion.fastDuration),
      curve: resolved.curve ?? theme.motion.fastCurve,
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
      scopesRoute: true,
      namesRoute: true,
      label: semanticLabel ?? MaterialLocalizations.of(context).dialogLabel,
      explicitChildNodes: true,
      child: AnimatedPadding(
        padding: resolved.insetPadding!.add(MediaQuery.viewInsetsOf(context)),
        duration: MediaQuery.of(context).disableAnimations
            ? Duration.zero
            : (resolved.duration ?? theme.motion.fastDuration),
        curve: resolved.curve ?? theme.motion.fastCurve,
        child: Align(
          alignment: resolved.alignment!,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: resolved.maxWidth!),
            child: SizedBox(
              width: resolved.width ?? resolved.maxWidth,
              child: surface,
            ),
          ),
        ),
      ),
    );
  }
}

/// 捕获调用处的全局及局部主题，使用 Flutter 原生模态路由与焦点循环。
Future<T?> showHyperDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  HyperDialogStyle? style,
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
  final resolved = HyperDialogTheme.of(context).style.merge(style);
  final motion = HyperTheme.of(context).motion;
  final reduced = MediaQuery.of(context).disableAnimations;
  final textDirection = Directionality.of(context);
  return navigator.push<T>(
    RawDialogRoute<T>(
      barrierDismissible: barrierDismissible,
      barrierLabel:
          barrierLabel ??
          MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: resolved.barrierColor ?? Colors.black.withValues(alpha: .4),
      transitionDuration: reduced
          ? Duration.zero
          : (resolved.duration ?? motion.fastDuration),
      settings: routeSettings,
      anchorPoint: anchorPoint,
      requestFocus: requestFocus,
      traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop,
      pageBuilder: (context, animation, secondaryAnimation) {
        Widget page = themes.wrap(
          HyperDialogTheme(
            data: HyperDialogThemeData(style: resolved),
            child: Builder(builder: builder),
          ),
        );
        if (useSafeArea) page = SafeArea(child: page);
        // Navigator 之外的局部设置不会被 InheritedTheme.capture 捕获。
        page = Directionality(textDirection: textDirection, child: page);
        if (reduced) {
          page = MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: page,
          );
        }
        return page;
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        if (reduced) return child;
        if (resolved.transitionBuilder case final custom?) {
          return custom(context, animation, secondaryAnimation, child);
        }
        final eased = animation.drive(
          CurveTween(curve: resolved.curve ?? motion.fastCurve),
        );
        return FadeTransition(
          opacity: eased,
          child: ScaleTransition(
            scale: Tween<double>(begin: .96, end: 1).animate(eased),
            alignment: (resolved.alignment ?? Alignment.center).resolve(
              textDirection,
            ),
            child: child,
          ),
        );
      },
    ),
  );
}
