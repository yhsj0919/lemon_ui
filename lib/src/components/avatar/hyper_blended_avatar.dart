import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../../theme/size/components/hyper_avatar_size.dart';
import 'hyper_avatar.dart';
import 'hyper_avatar_style.dart';
import 'hyper_avatar_theme.dart';

/// 根据各头像主色生成群组标识。colors 可避免图片解码并指定明确配色。
class HyperBlendedAvatar extends StatefulWidget {
  const HyperBlendedAvatar({
    super.key,
    required this.avatars,
    this.colors,
    this.groupSize,
    this.size = HyperAvatarSizeVariant.medium,
    this.shape,
    this.style,
    this.semanticsLabel,
    this.child,
  });
  final List<HyperAvatar> avatars;
  final List<Color>? colors;
  final Size? groupSize;
  final HyperAvatarSizeVariant size;
  final HyperAvatarShape? shape;
  final HyperAvatarStyle? style;
  final String? semanticsLabel;
  final Widget? child;
  @override
  State<HyperBlendedAvatar> createState() => _HyperBlendedAvatarState();
}

class _HyperBlendedAvatarState extends State<HyperBlendedAvatar> {
  final _listeners = <ImageProvider, (ImageStream, ImageStreamListener)>{};
  final _colors = <ImageProvider, Color>{};
  List<ImageProvider> _sources = const [];
  ImageConfiguration? _configuration;
  int _generation = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _sync();
  }

  @override
  void didUpdateWidget(HyperBlendedAvatar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _sync();
  }

  void _cancel() {
    for (final entry in _listeners.values) {
      entry.$1.removeListener(entry.$2);
    }
    _listeners.clear();
  }

  void _sync() {
    final sources = widget.colors == null
        ? widget.avatars
              .map((a) => a.image)
              .whereType<ImageProvider>()
              .toSet()
              .toList()
        : <ImageProvider>[];
    final configuration = createLocalImageConfiguration(context);
    if (listEquals(sources, _sources) && configuration == _configuration) {
      return;
    }
    final generation = ++_generation;
    _cancel();
    _sources = sources;
    _configuration = configuration;
    _colors.removeWhere((source, color) => !sources.contains(source));
    for (final source in sources) {
      if (_colors.containsKey(source)) continue;
      final stream = source.resolve(configuration);
      late ImageStreamListener listener;
      listener = ImageStreamListener(
        (info, synchronous) {
          final image = info.image.clone();
          info.dispose();
          stream.removeListener(listener);
          _listeners.remove(source);
          _sample(image).then((color) {
            if (mounted && generation == _generation && color != null) {
              setState(() => _colors[source] = color);
            }
          });
        },
        onError: (Object error, StackTrace? stack) {
          stream.removeListener(listener);
          _listeners.remove(source);
        },
      );
      _listeners[source] = (stream, listener);
      stream.addListener(listener);
    }
  }

  Future<Color?> _sample(ui.Image image) async {
    ui.Image? thumbnail;
    ui.Picture? picture;
    try {
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      // 固定采样分辨率仅用于色彩统计，不属于组件布局尺寸。
      canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        const Rect.fromLTWH(0, 0, 32, 32),
        Paint(),
      );
      picture = recorder.endRecording();
      thumbnail = await picture.toImage(32, 32);
      final data = await thumbnail.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      );
      return data == null
          ? null
          : hyperAvatarDominantColor(
              data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes),
            );
    } catch (_) {
      return null;
    } finally {
      thumbnail?.dispose();
      picture?.dispose();
      image.dispose();
    }
  }

  @override
  void dispose() {
    ++_generation;
    _cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final avatarTheme = HyperAvatarTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).avatar;
    final resolved = avatarTheme.groupStyle.merge(widget.style);
    final windmill = resolved.blendVariant == HyperAvatarBlendVariant.windmill;
    final palette =
        widget.colors ??
        [
          for (final avatar in widget.avatars)
            _colors[avatar.image] ??
                avatar.style?.backgroundColor ??
                avatarTheme.style.backgroundColor ??
                resolved.backgroundColor ??
                theme.colors.surfaceMuted,
        ];
    final colors = palette.isEmpty
        ? [resolved.backgroundColor ?? theme.colors.surfaceMuted]
        : [
            for (final color in palette)
              Color.lerp(
                color,
                resolved.blendTintColor ?? theme.colors.surface,
                (resolved.blendSoftness ?? (windmill ? 0 : .45)).clamp(
                  0.0,
                  1.0,
                ),
              )!,
          ];
    final extent = resolved.size ?? metrics.sizeFor(widget.size);
    final target =
        widget.groupSize ?? resolved.groupSize ?? Size.square(extent);
    final duration = MediaQuery.maybeOf(context)?.disableAnimations == true
        ? Duration.zero
        : resolved.duration ?? theme.motion.fastDuration;
    return Semantics(
      label: widget.semanticsLabel ?? '${widget.avatars.length} 个头像的混色标识',
      image: true,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bounds = constraints.constrain(target);
          final side = math.min(bounds.width, bounds.height);
          final avatarShape =
              widget.shape ??
              (windmill ? HyperAvatarShape.rounded : HyperAvatarShape.circle);
          final radius = avatarShape == HyperAvatarShape.circle
              ? side / 2
              : (resolved.radius ?? metrics.radius) * side / extent;
          final border = (resolved.borderWidth ?? 0) > 0
              ? BorderSide(
                  color: resolved.borderColor ?? theme.colors.outline,
                  width: resolved.borderWidth!,
                )
              : BorderSide.none;
          final shape =
              resolved.blendShapeBorder ??
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius),
                side: border,
              );
          return SizedBox(
            width: bounds.width,
            height: bounds.height,
            child: Center(
              child: AnimatedContainer(
                duration: duration,
                curve: resolved.curve ?? theme.motion.fastCurve,
                width: side,
                height: side,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  shape: shape,
                  shadows: resolved.boxShadow,
                  color: windmill ? resolved.backgroundColor : null,
                  gradient: windmill
                      ? null
                      : resolved.blendGradient ??
                            SweepGradient(
                              colors: [...colors, colors.first],
                              transform: GradientRotation(
                                resolved.blendRotation ?? 0,
                              ),
                            ),
                ),
                child: IconTheme.merge(
                  data: IconThemeData(
                    color: resolved.foregroundColor ?? theme.colors.onSurface,
                    size: resolved.iconSize ?? metrics.iconSize,
                  ),
                  child: DefaultTextStyle(
                    style: (theme.textTheme.labelLarge ?? const TextStyle())
                        .copyWith(
                          color:
                              resolved.foregroundColor ??
                              theme.colors.onSurface,
                        )
                        .merge(resolved.textStyle),
                    child: Stack(
                      children: [
                        if (windmill)
                          Positioned.fill(
                            child: TweenAnimationBuilder<List<Color>>(
                              tween: _PaletteTween(colors),
                              duration: duration,
                              curve: resolved.curve ?? theme.motion.fastCurve,
                              builder: (context, palette, child) => CustomPaint(
                                painter: HyperAvatarWindmillPainter(
                                  colors: palette,
                                  rotation: resolved.blendRotation ?? 0,
                                  petalRotation:
                                      resolved.blendPetalRotation ?? -.22,
                                  petalOpacity:
                                      resolved.blendPetalOpacity ?? .72,
                                  padding:
                                      (resolved.blendPadding ??
                                          metrics.spacing) *
                                      side /
                                      extent,
                                  border:
                                      resolved.blendPetalBorder ??
                                      BorderSide(
                                        color: theme.colors.surface.withValues(
                                          alpha: .5,
                                        ),
                                        width: metrics.ringWidth / 2,
                                      ),
                                  gradient: resolved.blendGradient,
                                  shadowColor: resolved.blendPetalShadowColor,
                                  shadowBlur:
                                      resolved.blendPetalShadowBlur == null
                                      ? null
                                      : resolved.blendPetalShadowBlur! *
                                            side /
                                            extent,
                                ),
                              ),
                            ),
                          ),
                        Center(child: widget.child),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PaletteTween extends Tween<List<Color>> {
  _PaletteTween(List<Color> colors) : super(begin: colors, end: colors);
  @override
  List<Color> lerp(double t) => [
    for (var i = 0; i < end!.length; i++)
      Color.lerp(begin![math.min(i, begin!.length - 1)], end![i], t)!,
  ];
}

/// 关于纵轴对称的水滴轮廓，旋转后保持圆润大头与收尖尾端。
@visibleForTesting
Path hyperAvatarWindmillPetal(Rect bounds) {
  final center = bounds.center;
  final radius = math.min(bounds.width, bounds.height) / 2;
  Offset p(double x, double y) => center + Offset(x * radius, y * radius);
  final path = Path();
  final start = p(-.025, -.095);
  path.moveTo(start.dx, start.dy);
  void curve(double x1, double y1, double x2, double y2, double x3, double y3) {
    final a = p(x1, y1), b = p(x2, y2), c = p(x3, y3);
    path.cubicTo(a.dx, a.dy, b.dx, b.dy, c.dx, c.dy);
  }

  curve(-.10, -.23, -.30, -.40, -.30, -.65);
  curve(-.30, -.82, -.17, -.96, 0, -.96);
  curve(.17, -.96, .30, -.82, .30, -.65);
  curve(.30, -.40, .10, -.23, .025, -.095);
  final tip = p(0, -.06);
  path.quadraticBezierTo(tip.dx, tip.dy, start.dx, start.dy);
  path.close();
  return path;
}

@visibleForTesting
class HyperAvatarWindmillPainter extends CustomPainter {
  const HyperAvatarWindmillPainter({
    required this.colors,
    required this.rotation,
    required this.padding,
    required this.border,
    this.petalRotation = -.22,
    this.petalOpacity = .72,
    this.gradient,
    this.shadowColor,
    this.shadowBlur,
  });
  final List<Color> colors;
  final double rotation, padding;
  final double petalRotation;
  final double petalOpacity;
  final BorderSide border;
  final Gradient? gradient;
  final Color? shadowColor;
  final double? shadowBlur;
  @override
  void paint(Canvas canvas, Size size) {
    final radius = math.max(
      0.0,
      math.min(size.width, size.height) / 2 - padding,
    );
    if (radius == 0 || colors.isEmpty) return;
    final bounds = Rect.fromCircle(center: Offset.zero, radius: radius);
    final pivot = Offset(0, -radius * .65);
    final tilt = Matrix4.identity()
      ..translateByDouble(pivot.dx, pivot.dy, 0, 1)
      ..rotateZ(petalRotation)
      ..translateByDouble(-pivot.dx, -pivot.dy, 0, 1);
    final petal = hyperAvatarWindmillPetal(bounds).transform(tilt.storage);
    final count = math.max(3, colors.length);
    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.rotate(rotation);
    final petals = [
      for (var i = 0; i < count; i++)
        petal.transform(Matrix4.rotationZ(i * 2 * math.pi / count).storage),
    ];
    final opacity = petalOpacity.clamp(0.0, 1.0);
    final foldX = .10 * math.cos(petalRotation) - .53 * math.sin(petalRotation);
    final foldY =
        -.65 + .10 * math.sin(petalRotation) + .53 * math.cos(petalRotation);
    final foldColor = shadowColor ?? Colors.black.withValues(alpha: .30);
    final foldRadius = radius * .48 + math.max(0, shadowBlur ?? radius * .045);
    // 每片被下一片压住，最后一片也被第一片压住，形成循环搭接。
    // 中心空洞来自花瓣内端的位置，绘制过程中不裁洞、不覆盖圆心。
    for (var i = 0; i < count; i++) {
      final angle = i * 2 * math.pi / count;
      final next = petals[(i + 1) % count];
      final visible = Path.combine(PathOperation.difference, petals[i], next);
      final color = colors[i % colors.length];
      final hsl = HSLColor.fromColor(color);
      final dark = hsl
          .withLightness((hsl.lightness - .09).clamp(0.0, 1.0))
          .toColor();
      final rich = hsl
          .withSaturation((hsl.saturation + .08).clamp(0.0, 1.0))
          .toColor();
      final fill =
          gradient ??
          LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color, rich, color, dark],
            stops: const [0, .28, .55, 1],
            transform: GradientRotation(angle),
          );
      canvas.drawPath(visible, Paint()..shader = fill.createShader(bounds));
      canvas.save();
      canvas.clipPath(visible);
      // 只在真实搭接处透出下层色彩，连续渐变模拟磨砂后的柔和叠色。
      if (opacity < 1) {
        final previousIndex = (i + count - 1) % count;
        final overlap = Path.combine(
          PathOperation.intersect,
          visible,
          petals[previousIndex],
        );
        final underneath = colors[previousIndex % colors.length];
        final transmitted = Color.alphaBlend(
          color.withValues(alpha: opacity),
          underneath,
        );
        canvas.drawPath(
          overlap,
          Paint()
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, radius * .025)
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [color, transmitted, transmitted],
              stops: const [0, .55, 1],
              transform: GradientRotation(angle),
            ).createShader(bounds),
        );
      }
      // 尖端附近的搭接内阴影向大头逐渐消退，形成弯折感。
      final foldCenter = Offset(
        radius * (foldX * math.cos(angle) - foldY * math.sin(angle)),
        radius * (foldX * math.sin(angle) + foldY * math.cos(angle)),
      );
      canvas.drawPath(
        visible,
        Paint()
          ..shader = ui.Gradient.radial(
            foldCenter,
            foldRadius,
            [foldColor, foldColor.withValues(alpha: 0)],
            const [0, 1],
          ),
      );
      if (border.style != BorderStyle.none && border.width > 0) {
        canvas.drawPath(
          visible,
          border.toPaint()
            ..strokeWidth = border.width * 2
            ..shader = LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                border.color,
                border.color.withValues(alpha: border.color.a * .25),
              ],
              transform: GradientRotation(angle),
            ).createShader(bounds),
        );
      }
      canvas.restore();
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(HyperAvatarWindmillPainter old) =>
      !listEquals(colors, old.colors) ||
      rotation != old.rotation ||
      petalRotation != old.petalRotation ||
      petalOpacity != old.petalOpacity ||
      padding != old.padding ||
      border != old.border ||
      gradient != old.gradient ||
      shadowColor != old.shadowColor ||
      shadowBlur != old.shadowBlur;
}

/// 按量化后的像素出现频率取主色，忽略近透明像素。
@visibleForTesting
Color? hyperAvatarDominantColor(Uint8List rgba) {
  final buckets = <int, List<int>>{};
  for (var i = 0; i + 3 < rgba.length; i += 4) {
    if (rgba[i + 3] < 128) continue;
    final r = rgba[i], g = rgba[i + 1], b = rgba[i + 2];
    final key = ((r >> 4) << 8) | ((g >> 4) << 4) | (b >> 4);
    final sum = buckets.putIfAbsent(key, () => [0, 0, 0, 0]);
    sum[0]++;
    sum[1] += r;
    sum[2] += g;
    sum[3] += b;
  }
  if (buckets.isEmpty) return null;
  final winner = buckets.values.reduce((a, b) => a[0] >= b[0] ? a : b);
  return Color.fromARGB(
    255,
    (winner[1] / winner[0]).round(),
    (winner[2] / winner[0]).round(),
    (winner[3] / winner[0]).round(),
  );
}
