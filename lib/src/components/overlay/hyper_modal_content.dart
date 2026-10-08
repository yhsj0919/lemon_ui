import 'package:flutter/material.dart';

import '../button/hyper_button_theme.dart';

/// 内部布局复用：不读取 Dialog/Sheet 主题，不管理路由或业务状态。
class HyperModalContent extends StatelessWidget {
  const HyperModalContent({
    super.key,
    this.title,
    this.closeButton,
    required this.content,
    required this.actions,
    required this.scrollable,
    this.expandContent = false,
    required this.padding,
    required this.titleStyle,
    required this.contentStyle,
    required this.titleSpacing,
    required this.actionSpacing,
    required this.actionRunSpacing,
    required this.actionsAlignment,
    required this.actionsDirection,
    this.buttonTheme,
  });
  final Widget? title, closeButton;
  final Widget content;
  final List<Widget> actions;
  final bool scrollable;
  final bool expandContent;
  final EdgeInsetsGeometry padding;
  final TextStyle titleStyle, contentStyle;
  final double titleSpacing, actionSpacing, actionRunSpacing;
  final WrapAlignment actionsAlignment;
  final Axis actionsDirection;
  final HyperButtonThemeData? buttonTheme;

  @override
  Widget build(BuildContext context) {
    final themedActions = [
      for (final action in actions)
        if (buttonTheme case final theme?)
          HyperButtonTheme(data: theme, child: action)
        else
          action,
    ];
    Widget body = DefaultTextStyle.merge(style: contentStyle, child: content);
    if (scrollable) body = SingleChildScrollView(child: body);
    return Padding(
      padding: padding,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null || closeButton != null) ...[
            Row(
              children: [
                Expanded(
                  child: DefaultTextStyle.merge(
                    style: titleStyle,
                    child: title ?? const SizedBox.shrink(),
                  ),
                ),
                ?closeButton,
              ],
            ),
            SizedBox(height: titleSpacing),
          ],
          Flexible(
            fit: expandContent ? FlexFit.tight : FlexFit.loose,
            child: body,
          ),
          if (actions.isNotEmpty) ...[
            SizedBox(height: titleSpacing),
            actionsDirection == Axis.vertical
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (final (index, action) in themedActions.indexed) ...[
                        if (index > 0) SizedBox(height: actionSpacing),
                        action,
                      ],
                    ],
                  )
                : Wrap(
                    alignment: actionsAlignment,
                    spacing: actionSpacing,
                    runSpacing: actionRunSpacing,
                    children: themedActions,
                  ),
          ],
        ],
      ),
    );
  }
}
