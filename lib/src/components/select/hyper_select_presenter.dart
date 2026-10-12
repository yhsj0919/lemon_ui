import '../overlay/hyper_backdrop_safe_opacity.dart';

import '../overlay/hyper_navigator_scope.dart';
import '../overlay/hyper_live_route_themes.dart';

import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../bottom_sheet/hyper_bottom_sheet.dart';
import '../scaffold/hyper_scaffold.dart';
import '../app_bar/hyper_app_bar.dart';
import 'hyper_selection_style.dart';
import 'hyper_select_model.dart';

/// 模态呈现与锚定呈现共用同一内容 builder；手机默认值不限制显式选择。
Future<void> showHyperSelectModal({
  required BuildContext context,
  required HyperSelectPresentation presentation,
  required WidgetBuilder builder,
  required String title,
  HyperSelectionStyle? style,
}) async {
  if (presentation == HyperSelectPresentation.bottomSheet) {
    await showHyperBottomSheet<void>(
      context: context,
      builder: (context) => HyperBottomSheet(
        title: Text(title),
        scrollable: false,
        showCloseButton: true,
        onClose: () => Navigator.of(context).pop(),
        content: builder(context),
      ),
    );
    return;
  }
  if (presentation != HyperSelectPresentation.fullScreen) {
    throw ArgumentError('模态呈现只支持底部弹窗或全屏页。');
  }
  final navigator = Navigator.of(
    context,
    rootNavigator: HyperNavigatorScope.resolve(context),
  );
  final theme = HyperTheme.of(context);
  final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  await navigator.push<void>(
    PageRouteBuilder<void>(
      fullscreenDialog: true,
      transitionDuration: reduced
          ? Duration.zero
          : style?.duration ?? theme.motion.standardDuration,
      reverseTransitionDuration: reduced
          ? Duration.zero
          : theme.motion.fastDuration,
      pageBuilder: (routeContext, animation, secondaryAnimation) =>
          HyperLiveRouteThemes(
            source: context,
            destination: navigator.context,
            child: HyperScaffold(
              appBar: HyperAppBar(title: Text(title)),
              body: SafeArea(child: builder(context)),
            ),
          ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          style?.transitionBuilder?.call(context, animation, child) ??
          HyperBackdropSafeFade(
            opacity: animation.drive(
              CurveTween(curve: style?.curve ?? theme.motion.standardCurve),
            ),
            child: child,
          ),
    ),
  );
}
