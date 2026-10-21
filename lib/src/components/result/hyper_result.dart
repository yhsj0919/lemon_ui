import 'package:flutter/material.dart';

import '../../foundation/hyper_fill.dart';
import '../../theme/core/hyper_theme.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../surface/hyper_material_surface.dart';

import 'hyper_result_model.dart';
import 'hyper_result_style.dart';
import 'hyper_result_theme.dart';

/// 受控结果展示；不触发请求、重试、导航或自动隐藏。
class HyperResult extends StatelessWidget {
  const HyperResult({
    super.key,
    this.status = HyperResultStatus.neutral,
    this.title,
    this.description,
    this.titleWidget,
    this.descriptionWidget,
    this.illustration,
    this.showIllustration = true,
    this.content,
    this.actions = const [],
    this.style,
  });

  /// 空内容结果；与其他结果状态共享布局、主题和表面解析。
  const HyperResult.empty({
    super.key,
    this.title = '暂无内容',
    this.description,
    this.titleWidget,
    this.descriptionWidget,
    this.illustration,
    this.showIllustration = true,
    this.content,
    this.actions = const [],
    this.style,
  }) : status = HyperResultStatus.empty;
  final HyperResultStatus status;
  final String? title, description;
  final Widget? titleWidget, descriptionWidget, illustration, content;
  final bool showIllustration;
  final List<Widget> actions;
  final HyperResultStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = HyperTheme.sizesOf(context);
    final size = status == HyperResultStatus.empty
        ? sizes.result.empty
        : sizes.result;
    final material = HyperMaterialTheme.of(context);
    final configured = HyperResultTheme.of(context)
        .resolve(status)
        .merge(style);
    final s = HyperResultStyle(
      icon: status.icon,
      iconColor: status.color(theme.colors),
      iconSize: size.iconSize,
      illustrationSize: size.illustrationSize,
      maxWidth: size.maxWidth,
      contentSpacing: size.contentSpacing,
      titleSpacing: size.titleSpacing,
      actionSpacing: size.actionSpacing,
      actionRunSpacing: size.actionRunSpacing,
      padding: size.padding,
      background: const HyperFill.none(),
      borderRadius: BorderRadius.zero,
      material: material.material,
      materialQuality: material.quality,
      reduceTransparency: material.reduceTransparency,
      titleStyle: theme.textTheme.titleMedium?.copyWith(
        color: theme.colors.textPrimary,
      ),
      descriptionStyle: theme.textTheme.bodySmall?.copyWith(
        color: theme.colors.textSecondary,
      ),
      textAlign: TextAlign.center,
      actionAlignment: WrapAlignment.center,
      alignment: Alignment.center,
      duration: theme.motion.standardDuration,
      curve: theme.motion.standardCurve,
    ).merge(configured);
    final duration = (MediaQuery.maybeOf(context)?.disableAnimations ?? false)
        ? Duration.zero
        : s.duration!;
    Widget transition(Widget child, Object identity) => AnimatedSwitcher(
      duration: duration,
      switchInCurve: s.curve!,
      switchOutCurve: s.curve!,
      transitionBuilder:
          s.transitionBuilder ?? AnimatedSwitcher.defaultTransitionBuilder,
      child: KeyedSubtree(key: ValueKey(identity), child: child),
    );
    Widget text(Widget? custom, String? value, TextStyle textStyle) =>
        AnimatedDefaultTextStyle(
          duration: duration,
          curve: s.curve!,
          style: textStyle,
          textAlign: s.textAlign,
          child: transition(
            custom ?? Text(value!, textAlign: s.textAlign),
            custom?.key ?? custom?.runtimeType ?? value!,
          ),
        );
    final hasTitle = titleWidget != null || (title?.isNotEmpty ?? false);
    final hasDescription =
        descriptionWidget != null || (description?.isNotEmpty ?? false);
    final blocks = <Widget>[
      if (showIllustration)
        ExcludeSemantics(
          child: SizedBox.square(
            dimension: s.illustrationSize,
            child: transition(
              illustration == null
                  ? Center(
                      child: Icon(s.icon, size: s.iconSize, color: s.iconColor),
                    )
                  : IconTheme.merge(
                      data: IconThemeData(color: s.iconColor, size: s.iconSize),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: illustration,
                      ),
                    ),
              (
                status,
                illustration?.key ?? illustration?.runtimeType ?? s.icon,
                s.iconColor,
              ),
            ),
          ),
        ),
      if (hasTitle || hasDescription)
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (hasTitle) text(titleWidget, title, s.titleStyle!),
            if (hasTitle && hasDescription) SizedBox(height: s.titleSpacing),
            if (hasDescription)
              text(descriptionWidget, description, s.descriptionStyle!),
          ],
        ),
      ?content,
      if (actions.isNotEmpty)
        Wrap(
          alignment: s.actionAlignment!,
          spacing: s.actionSpacing!,
          runSpacing: s.actionRunSpacing!,
          children: actions,
        ),
    ];
    final body = TweenAnimationBuilder<HyperResultStyle>(
      tween: _ResultStyleTween(end: s),
      duration: duration,
      curve: s.curve!,
      builder: (context, visual, child) => HyperMaterialSurface(
        material: configured.background == null || visual.material == null
            ? visual.material
            : visual.material!.copyWith(
                background: visual.background,
                fallback: visual.material!.fallback?.copyWith(
                  background: visual.background,
                ),
              ),
        semanticBackground: visual.background,
        quality: visual.materialQuality,
        reduceTransparency: visual.reduceTransparency,
        borderRadius: visual.borderRadius,
        border: visual.border,
        boxShadow: visual.boxShadow,
        padding: visual.padding,
        child: child,
      ),
      child: AnimatedSize(
        duration: duration,
        curve: s.curve!,
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < blocks.length; i++) ...[
              if (i > 0) SizedBox(height: s.contentSpacing),
              blocks[i],
            ],
          ],
        ),
      ),
    );
    return Align(
      alignment: s.alignment!,
      widthFactor: 1,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: s.maxWidth!),
        child: body,
      ),
    );
  }
}

class _ResultStyleTween extends Tween<HyperResultStyle> {
  _ResultStyleTween({required HyperResultStyle end}) : super(end: end);

  @override
  HyperResultStyle lerp(double t) => HyperResultStyle.lerp(begin!, end!, t);
}
