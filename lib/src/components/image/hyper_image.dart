import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lemon_extended_image/extended_image.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_icons.dart';
import '../../theme/core/hyper_theme.dart';
import '../button/hyper_button.dart';
import '../card/hyper_card_style.dart';
import '../icon/hyper_icon.dart';
import '../progress/hyper_progress.dart';
import '../surface/hyper_navigation_surface.dart';
import 'hyper_image_style.dart';
import 'hyper_image_theme.dart';
import 'hyper_file_image_stub.dart'
    if (dart.library.io) 'hyper_file_image_io.dart';

typedef HyperImageLoadingBuilder = Widget Function(
  BuildContext context,
  ImageChunkEvent? progress,
);
typedef HyperImageErrorBuilder = Widget Function(
  BuildContext context,
  Object? error,
  VoidCallback retry,
);

/// Image display with built-in loading, failure and retry presentation.
///
/// Reserve space with width/height, aspectRatio, or tight parent constraints.
/// Without them, intrinsic image dimensions become available after decoding.
class HyperImage extends StatelessWidget {
  const HyperImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.aspectRatio,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
    this.variant = HyperImageVariant.plain,
    this.style,
    this.loadingBuilder,
    this.errorBuilder,
    this.semanticLabel,
    this.heroTag,
    this.excludeFromSemantics = false,
    this.cacheWidth,
    this.cacheHeight,
    this.filterQuality = FilterQuality.medium,
    this.matchTextDirection = false,
  }) : assert(width == null || width >= 0),
       assert(height == null || height >= 0),
       assert(aspectRatio == null || aspectRatio > 0),
       assert(cacheWidth == null || cacheWidth > 0),
       assert(cacheHeight == null || cacheHeight > 0);
  final ImageProvider image;
  final double? width, height, aspectRatio;
  final BoxFit fit;
  final AlignmentGeometry alignment;
  final HyperImageVariant variant;
  final HyperImageStyle? style;
  final HyperImageLoadingBuilder? loadingBuilder;
  final HyperImageErrorBuilder? errorBuilder;
  final String? semanticLabel;

  /// Matches the preview item tag to animate between thumbnail and preview.
  final Object? heroTag;
  final bool excludeFromSemantics;

  /// Decode dimensions in physical pixels, following Flutter ImageProvider.
  final int? cacheWidth, cacheHeight;
  final FilterQuality filterQuality;
  final bool matchTextDirection;

  /// Creates a network image with optional native disk caching.
  ///
  /// Browser caching and request headers remain subject to browser CORS rules.
  factory HyperImage.network(
    String url, {
    bool cache = true,
    Map<String, String>? headers,
    Duration? timeout,
    int retries = 3,
    Duration retryDelay = const Duration(milliseconds: 100),
    String? cacheKey,
    Duration? cacheMaxAge,
    Key? key,
    double? width,
    double? height,
    double? aspectRatio,
    BoxFit fit = BoxFit.cover,
    AlignmentGeometry alignment = Alignment.center,
    HyperImageVariant variant = HyperImageVariant.plain,
    HyperImageStyle? style,
    HyperImageLoadingBuilder? loadingBuilder,
    HyperImageErrorBuilder? errorBuilder,
    String? semanticLabel,
    Object? heroTag,
    bool excludeFromSemantics = false,
    int? cacheWidth,
    int? cacheHeight,
    FilterQuality filterQuality = FilterQuality.medium,
    bool matchTextDirection = false,
  }) => HyperImage(
    image: ExtendedNetworkImageProvider(
      url,
      cache: cache,
      headers: headers,
      timeLimit: timeout,
      retries: retries,
      timeRetry: retryDelay,
      cacheKey: cacheKey,
      cacheMaxAge: cacheMaxAge,
      printError: false,
    ),
    key: key,
    width: width,
    height: height,
    aspectRatio: aspectRatio,
    fit: fit,
    alignment: alignment,
    variant: variant,
    style: style,
    loadingBuilder: loadingBuilder,
    errorBuilder: errorBuilder,
    semanticLabel: semanticLabel,
    heroTag: heroTag,
    excludeFromSemantics: excludeFromSemantics,
    cacheWidth: cacheWidth,
    cacheHeight: cacheHeight,
    filterQuality: filterQuality,
    matchTextDirection: matchTextDirection,
  );

  /// Creates a density-aware asset image.
  factory HyperImage.asset(
    String name, {
    String? package,
    AssetBundle? bundle,
    Key? key,
    double? width,
    double? height,
    double? aspectRatio,
    BoxFit fit = BoxFit.cover,
    AlignmentGeometry alignment = Alignment.center,
    HyperImageVariant variant = HyperImageVariant.plain,
    HyperImageStyle? style,
    HyperImageLoadingBuilder? loadingBuilder,
    HyperImageErrorBuilder? errorBuilder,
    String? semanticLabel,
    Object? heroTag,
    bool excludeFromSemantics = false,
    int? cacheWidth,
    int? cacheHeight,
    FilterQuality filterQuality = FilterQuality.medium,
    bool matchTextDirection = false,
  }) => HyperImage(
    image: AssetImage(name, package: package, bundle: bundle),
    key: key,
    width: width,
    height: height,
    aspectRatio: aspectRatio,
    fit: fit,
    alignment: alignment,
    variant: variant,
    style: style,
    loadingBuilder: loadingBuilder,
    errorBuilder: errorBuilder,
    semanticLabel: semanticLabel,
    heroTag: heroTag,
    excludeFromSemantics: excludeFromSemantics,
    cacheWidth: cacheWidth,
    cacheHeight: cacheHeight,
    filterQuality: filterQuality,
    matchTextDirection: matchTextDirection,
  );

  /// Creates an image from encoded bytes, including browser-selected files.
  factory HyperImage.memory(
    Uint8List bytes, {
    double scale = 1,
    Key? key,
    double? width,
    double? height,
    double? aspectRatio,
    BoxFit fit = BoxFit.cover,
    AlignmentGeometry alignment = Alignment.center,
    HyperImageVariant variant = HyperImageVariant.plain,
    HyperImageStyle? style,
    HyperImageLoadingBuilder? loadingBuilder,
    HyperImageErrorBuilder? errorBuilder,
    String? semanticLabel,
    Object? heroTag,
    bool excludeFromSemantics = false,
    int? cacheWidth,
    int? cacheHeight,
    FilterQuality filterQuality = FilterQuality.medium,
    bool matchTextDirection = false,
  }) => HyperImage(
    image: MemoryImage(bytes, scale: scale),
    key: key,
    width: width,
    height: height,
    aspectRatio: aspectRatio,
    fit: fit,
    alignment: alignment,
    variant: variant,
    style: style,
    loadingBuilder: loadingBuilder,
    errorBuilder: errorBuilder,
    semanticLabel: semanticLabel,
    heroTag: heroTag,
    excludeFromSemantics: excludeFromSemantics,
    cacheWidth: cacheWidth,
    cacheHeight: cacheHeight,
    filterQuality: filterQuality,
    matchTextDirection: matchTextDirection,
  );

  /// Creates an image from a native file path.
  ///
  /// Throws [UnsupportedError] on Web; use [HyperImage.memory] with file bytes.
  factory HyperImage.file(
    String path, {
    double scale = 1,
    Key? key,
    double? width,
    double? height,
    double? aspectRatio,
    BoxFit fit = BoxFit.cover,
    AlignmentGeometry alignment = Alignment.center,
    HyperImageVariant variant = HyperImageVariant.plain,
    HyperImageStyle? style,
    HyperImageLoadingBuilder? loadingBuilder,
    HyperImageErrorBuilder? errorBuilder,
    String? semanticLabel,
    Object? heroTag,
    bool excludeFromSemantics = false,
    int? cacheWidth,
    int? cacheHeight,
    FilterQuality filterQuality = FilterQuality.medium,
    bool matchTextDirection = false,
  }) => HyperImage(
    image: hyperFileImage(path, scale: scale),
    key: key,
    width: width,
    height: height,
    aspectRatio: aspectRatio,
    fit: fit,
    alignment: alignment,
    variant: variant,
    style: style,
    loadingBuilder: loadingBuilder,
    errorBuilder: errorBuilder,
    semanticLabel: semanticLabel,
    heroTag: heroTag,
    excludeFromSemantics: excludeFromSemantics,
    cacheWidth: cacheWidth,
    cacheHeight: cacheHeight,
    filterQuality: filterQuality,
    matchTextDirection: matchTextDirection,
  );

  @override
  Widget build(BuildContext context) {
    final provider = ResizeImage.resizeIfNeeded(cacheWidth, cacheHeight, image);
    Widget child = ExtendedImage(
      image: provider,
      fit: fit,
      alignment: alignment,
      filterQuality: filterQuality,
      matchTextDirection: matchTextDirection,
      excludeFromSemantics: excludeFromSemantics,
      semanticLabel: semanticLabel,
      enableLoadState: true,
      handleLoadingProgress: true,
      loadStateChanged: (state) {
        return buildHyperImageLoadState(
          context,
          state,
          variant: variant,
          style: style,
          loadingBuilder: loadingBuilder,
          errorBuilder: errorBuilder,
          semanticLabel: semanticLabel,
          excludeFromSemantics: excludeFromSemantics,
        );
      },
    );
    if (aspectRatio != null) {
      child = AspectRatio(aspectRatio: aspectRatio!, child: child);
    }
    child = SizedBox(width: width, height: height, child: child);
    return heroTag == null
        ? child
        : Hero(
            tag: heroTag!,
            // The preview route is transparent, so keep its thumbnail visible
            // behind the modal barrier while the separate image shuttle flies.
            placeholderBuilder: (context, size, child) => SizedBox(
              width: size.width,
              height: size.height,
              child: IgnorePointer(child: child),
            ),
            child: child,
          );
  }
}

/// Resolves defaults and explicit theme overrides for an image state.
HyperImageStyle resolveHyperImageStyle(
  BuildContext context, {
  required HyperImageVariant variant,
  required HyperImageLoadState state,
  HyperImageStyle? style,
}) {
  final theme = HyperTheme.of(context), s = HyperTheme.sizesOf(context);
  final m = s.image;
  return HyperImageStyle(
    surfaceStyle: HyperCardStyle(
      background: HyperFill.color(
        variant == HyperImageVariant.plain
            ? Colors.transparent
            : theme.colors.surface,
      ),
      borderRadius: variant == HyperImageVariant.plain
          ? BorderRadius.zero
          : BorderRadius.circular(m.radius),
      border: variant == HyperImageVariant.outlined
          ? Border.all(color: theme.colors.outline)
          : null,
      boxShadow: variant == HyperImageVariant.elevated
          ? [
              BoxShadow(
                color: theme.colors.scrim.withValues(alpha: .10),
                blurRadius: m.radius,
                offset: Offset(0, m.spacing),
              ),
            ]
          : null,
      padding: EdgeInsets.zero,
    ),
    placeholderColor: theme.colors.surfaceMuted,
    progressColor: theme.colors.primary,
    progressTrackColor: theme.colors.outline,
    failureIcon: HyperIcons.imageOff,
    iconColor: theme.colors.textSecondary,
    textStyle: theme.textTheme.bodySmall?.copyWith(
      color: theme.colors.textSecondary,
    ),
    failureText: '图片加载失败',
    retryText: '重试',
    iconSize: m.iconSize,
    progressSize: m.progressSize,
    progressThickness: m.progressThickness,
    spacing: m.spacing,
    padding: EdgeInsets.all(m.padding),
    animationDuration: theme.motion.fastDuration,
    animationCurve: theme.motion.standardCurve,
  ).merge(HyperImageTheme.of(context).resolve(variant, state)).merge(style);
}

Widget _imageFade(Widget child, Animation<double> animation) =>
    FadeTransition(opacity: animation, child: child);

// Internal shared rendering path. Backend modes retain their completed widget.
Widget buildHyperImageLoadState(
  BuildContext context,
  ExtendedImageState state, {
  HyperImageVariant variant = HyperImageVariant.plain,
  HyperImageStyle? style,
  HyperImageLoadingBuilder? loadingBuilder,
  HyperImageErrorBuilder? errorBuilder,
  String? semanticLabel,
  bool excludeFromSemantics = false,
  Widget? completed,
  bool inheritMaterial = true,
}) {
  state.returnLoadStateChangedWidget = true;
  final loadState = switch (state.extendedImageLoadState) {
    LoadState.loading => HyperImageLoadState.loading,
    LoadState.completed => HyperImageLoadState.completed,
    LoadState.failed => HyperImageLoadState.failed,
  };
  final resolved = resolveHyperImageStyle(
    context,
    variant: variant,
    state: loadState,
    style: style,
  );
  final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  final duration = reduced ? Duration.zero : resolved.animationDuration!;
  Widget content;
  switch (loadState) {
    case HyperImageLoadState.completed:
      content = excludeFromSemantics
          ? (completed ?? state.completedWidget)
          : Semantics(
              container: semanticLabel != null,
              image: true,
              label: semanticLabel ?? '',
              child: completed ?? state.completedWidget,
            );
    case HyperImageLoadState.loading:
      final progress = state.loadingProgress;
      final total = progress?.expectedTotalBytes;
      final value = total != null && total > 0
          ? (progress!.cumulativeBytesLoaded / total).clamp(0.0, 1.0)
          : null;
      content =
          loadingBuilder?.call(context, progress) ??
          _imagePlaceholder(
            resolved,
            HyperProgress.circular(
              value: value,
              color: resolved.progressColor,
              trackColor: resolved.progressTrackColor,
              size: resolved.progressSize,
              thickness: resolved.progressThickness,
              semanticsLabel: '图片加载中',
            ),
          );
    case HyperImageLoadState.failed:
      content =
          errorBuilder?.call(context, state.lastException, state.reLoadImage) ??
          _imagePlaceholder(
            resolved,
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HyperIcon(
                  resolved.failureIcon!,
                  size: resolved.iconSize,
                  color: resolved.iconColor,
                ),
                SizedBox(height: resolved.spacing),
                Text(
                  resolved.failureText!,
                  style: resolved.textStyle,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: resolved.spacing),
                HyperButton.text(
                  onPressed: state.reLoadImage,
                  label: Text(resolved.retryText!, style: resolved.textStyle),
                ),
              ],
            ),
          );
  }
  // Only image/status content fades; backdrop material stays outside opacity layers.
  return HyperNavigationSurface(
    style: resolved.surfaceStyle!,
    inheritMaterial: inheritMaterial,
    child: AnimatedSwitcher(
      duration: duration,
      switchInCurve: resolved.animationCurve!,
      switchOutCurve: resolved.animationCurve!,
      transitionBuilder: resolved.transitionBuilder ?? _imageFade,
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.center,
        fit: StackFit.passthrough,
        children: [
          ...previous.map(
            (child) => Positioned.fill(
              child: IgnorePointer(child: ExcludeSemantics(child: child)),
            ),
          ),
          ?current,
        ],
      ),
      child: KeyedSubtree(key: ValueKey(loadState), child: content),
    ),
  );
}

Widget _imagePlaceholder(HyperImageStyle style, Widget child) => ColoredBox(
  color: style.placeholderColor!,
  child: Center(
    child: SingleChildScrollView(
      primary: false,
      padding: style.padding,
      child: child,
    ),
  ),
);
