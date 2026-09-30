import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../../theme/size/components/hyper_avatar_size.dart';
import 'hyper_avatar_style.dart';
import 'hyper_avatar_theme.dart';

enum HyperAvatarShape { circle, rounded }

/// 图片加载中或失败时依次回退到 child、文字、图标和默认人物图标。
class HyperAvatar extends StatelessWidget {
  const HyperAvatar({
    super.key,
    this.image,
    this.text,
    this.icon,
    this.child,
    this.size = HyperAvatarSizeVariant.medium,
    this.shape = HyperAvatarShape.circle,
    this.style,
    this.semanticsLabel,
  });
  final ImageProvider? image;
  final String? text;
  final Widget? icon;
  final Widget? child;
  final HyperAvatarSizeVariant size;
  final HyperAvatarShape shape;
  final HyperAvatarStyle? style;
  final String? semanticsLabel;

  static Widget _transition(Widget child, Animation<double> animation) =>
      FadeTransition(opacity: animation, child: child);

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).avatar;
    final resolved = HyperAvatarTheme.of(context).style.merge(style);
    final extent = resolved.size ?? metrics.sizeFor(size);
    assert(extent > 0);
    final radius = shape == HyperAvatarShape.circle
        ? extent / 2
        : resolved.radius ?? metrics.radius;
    final duration = MediaQuery.maybeOf(context)?.disableAnimations == true
        ? Duration.zero
        : resolved.duration ?? theme.motion.fastDuration;
    final foreground = resolved.foregroundColor ?? theme.colors.textSecondary;
    final fallback =
        child ??
        (text != null && text!.isNotEmpty
            ? Padding(
                padding: EdgeInsets.all(extent / 8),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(text!, maxLines: 1),
                ),
              )
            : icon ?? const Icon(Icons.person_outline));
    Widget content = fallback;
    if (image != null) {
      content = Image(
        image: image!,
        width: extent,
        height: extent,
        fit: resolved.imageFit ?? BoxFit.cover,
        alignment: (resolved.imageAlignment ?? Alignment.center).resolve(
          Directionality.of(context),
        ),
        errorBuilder: (_, error, stack) => fallback,
        frameBuilder: (_, loaded, frame, synchronous) => AnimatedSwitcher(
          duration: duration,
          switchInCurve: resolved.curve ?? theme.motion.fastCurve,
          switchOutCurve: resolved.curve ?? theme.motion.fastCurve,
          transitionBuilder: resolved.transitionBuilder ?? _transition,
          child: synchronous || frame != null
              ? KeyedSubtree(key: ValueKey(image), child: loaded)
              : KeyedSubtree(key: const ValueKey('fallback'), child: fallback),
        ),
      );
    }
    return Semantics(
      label: semanticsLabel ?? text,
      image: true,
      child: ExcludeSemantics(
        child: AnimatedContainer(
          duration: duration,
          curve: resolved.curve ?? theme.motion.fastCurve,
          width: extent,
          height: extent,
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: resolved.backgroundColor ?? theme.colors.surfaceMuted,
            boxShadow: resolved.boxShadow,
            borderRadius: BorderRadius.circular(radius),
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: (resolved.borderWidth ?? 0) > 0
                ? Border.all(
                    color: resolved.borderColor ?? theme.colors.outline,
                    width: resolved.borderWidth!,
                  )
                : null,
          ),
          child: IconTheme.merge(
            data: IconThemeData(
              color: foreground,
              size: resolved.iconSize ?? metrics.iconSize,
            ),
            child: DefaultTextStyle(
              style: (theme.textTheme.labelLarge ?? const TextStyle())
                  .copyWith(color: foreground)
                  .merge(resolved.textStyle),
              child: Center(child: content),
            ),
          ),
        ),
      ),
    );
  }
}
