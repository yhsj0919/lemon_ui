import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show precisionErrorTolerance;

import '../../theme/core/hyper_theme.dart';
import '../../theme/size/components/hyper_avatar_size.dart';
import 'hyper_avatar.dart';
import 'hyper_avatar_style.dart';
import 'hyper_avatar_theme.dart';
import 'hyper_blended_avatar.dart';

/// horizontal 为重叠排列，row 为有间距的排列。
enum HyperAvatarGroupLayout {
  horizontal,
  row,
  vertical,
  circle5,
  centered,
  grid4,
  grid9,
  mosaic,
  blended,
  windmill,
  custom,
}

/// 自定义布局的参考画布与头像位置。位置须位于画布内，头像保持正方形。
@immutable
class HyperAvatarGroupGeometry {
  HyperAvatarGroupGeometry({required this.size, required List<Rect> slots})
    : slots = List.unmodifiable(slots) {
    if (!size.width.isFinite ||
        !size.height.isFinite ||
        size.width <= 0 ||
        size.height <= 0 ||
        slots.any(
          (r) =>
              !r.left.isFinite ||
              !r.top.isFinite ||
              !r.width.isFinite ||
              !r.height.isFinite ||
              r.width <= 0 ||
              (r.width - r.height).abs() > precisionErrorTolerance ||
              r.left < -precisionErrorTolerance ||
              r.top < -precisionErrorTolerance ||
              r.right - size.width > precisionErrorTolerance ||
              r.bottom - size.height > precisionErrorTolerance,
        )) {
      throw ArgumentError('头像布局需要有限正尺寸，正方形子项必须位于画布内。');
    }
  }
  final Size size;
  final List<Rect> slots;
}

typedef HyperAvatarGroupLayoutBuilder = HyperAvatarGroupGeometry Function(
  BuildContext context,
  int visibleCount,
  double avatarSize,
);

class HyperAvatarGroup extends StatelessWidget {
  const HyperAvatarGroup({
    super.key,
    required this.avatars,
    this.layout = HyperAvatarGroupLayout.horizontal,
    this.maxVisible,
    this.size = HyperAvatarSizeVariant.medium,
    this.groupSize,
    this.style,
    this.overflowBuilder,
    this.layoutBuilder,
    this.mosaicColumns = 2,
    this.mosaicShape = HyperAvatarShape.rounded,
    this.blendColors,
    this.blendShape,
    this.blendChild,
  }) : assert(maxVisible == null || maxVisible > 0),
       assert(mosaicColumns > 0),
       assert(layout != HyperAvatarGroupLayout.custom || layoutBuilder != null);
  final List<HyperAvatar> avatars;
  final HyperAvatarGroupLayout layout;

  /// 包含 +N 占位；固定布局会进一步限制到可用位置数量。
  final int? maxVisible;
  final HyperAvatarSizeVariant size;

  /// 整组宽高。布局等比缩放、居中，头像和间距随组大小调整。
  final Size? groupSize;
  final HyperAvatarStyle? style;
  final Widget Function(BuildContext context, int hiddenCount)? overflowBuilder;
  final HyperAvatarGroupLayoutBuilder? layoutBuilder;
  final int mosaicColumns;
  final HyperAvatarShape mosaicShape;
  final List<Color>? blendColors;
  final HyperAvatarShape? blendShape;
  final Widget? blendChild;

  HyperAvatarGroupGeometry _geometry(
    BuildContext context,
    int count,
    double extent,
    double overlap,
    double spacing, {
    bool overflow = false,
  }) {
    if (layout == HyperAvatarGroupLayout.custom) {
      final geometry = layoutBuilder!(context, count, extent);
      if (geometry.slots.length != count) {
        throw ArgumentError('自定义头像布局必须为 $count 个可见项提供同样数量的位置。');
      }
      return geometry;
    }
    final grid =
        layout == HyperAvatarGroupLayout.grid4 ||
        layout == HyperAvatarGroupLayout.grid9 ||
        layout == HyperAvatarGroupLayout.mosaic;
    final columns = layout == HyperAvatarGroupLayout.mosaic
        ? mosaicColumns
        : layout == HyperAvatarGroupLayout.grid9
        ? 3
        : 2;
    final tile = layout == HyperAvatarGroupLayout.mosaic
        ? extent / columns
        : extent;
    final orbit = layout == HyperAvatarGroupLayout.centered
        ? extent - overlap
        : math.max(0.0, extent - overlap * 2);
    final circular =
        layout == HyperAvatarGroupLayout.circle5 ||
        layout == HyperAvatarGroupLayout.centered;
    final side = grid
        ? columns * tile
        : circular && count > 1
        ? extent + orbit * 2
        : extent;
    final step = layout == HyperAvatarGroupLayout.row
        ? extent + spacing
        : extent - overlap;
    final canvas = switch (layout) {
      HyperAvatarGroupLayout.horizontal ||
      HyperAvatarGroupLayout.row => Size(extent + (count - 1) * step, extent),
      HyperAvatarGroupLayout.vertical => Size(
        extent,
        extent + (count - 1) * step,
      ),
      _ => Size.square(side),
    };
    final slots = <Rect>[];
    for (var i = 0; i < count; i++) {
      Offset position;
      if (grid) {
        position = Offset((i % columns) * tile, (i ~/ columns) * tile);
      } else if (circular) {
        final center = (side - extent) / 2;
        if (count == 1 ||
            (layout == HyperAvatarGroupLayout.centered && i == 0)) {
          position = Offset(center, center);
        } else {
          final centered = layout == HyperAvatarGroupLayout.centered;
          final angle =
              -math.pi / 2 +
              (centered ? i - 1 : i) * 2 * math.pi / (centered ? count - 1 : 5);
          position = Offset(
            center + math.cos(angle) * orbit,
            center + math.sin(angle) * orbit,
          );
        }
      } else {
        position = layout == HyperAvatarGroupLayout.vertical
            ? Offset(0, i * step)
            : Offset(i * step, 0);
      }
      slots.add(Rect.fromLTWH(position.dx, position.dy, tile, tile));
    }
    if (overflow && circular && count > 1) {
      // 将溢出项与右下方向的环绕位置交换，中心头像保持原位。
      final first = layout == HyperAvatarGroupLayout.centered ? 1 : 0;
      final rtl = Directionality.of(context) == TextDirection.rtl;
      double score(Rect slot) =>
          (rtl ? -slot.center.dx : slot.center.dx) + slot.center.dy;
      var target = first;
      for (var i = first + 1; i < slots.length; i++) {
        if (score(slots[i]) > score(slots[target])) target = i;
      }
      final last = slots.last;
      slots[slots.length - 1] = slots[target];
      slots[target] = last;
    }
    return HyperAvatarGroupGeometry(size: canvas, slots: slots);
  }

  @override
  Widget build(BuildContext context) {
    if (layout == HyperAvatarGroupLayout.blended ||
        layout == HyperAvatarGroupLayout.windmill) {
      return HyperBlendedAvatar(
        avatars: avatars,
        colors: blendColors,
        groupSize: groupSize,
        size: size,
        shape: blendShape,
        style: (style ?? const HyperAvatarStyle()).merge(
          layout == HyperAvatarGroupLayout.windmill
              ? const HyperAvatarStyle(
                  blendVariant: HyperAvatarBlendVariant.windmill,
                )
              : null,
        ),
        child: blendChild,
      );
    }
    if (avatars.isEmpty) return const SizedBox.shrink();
    final theme = HyperTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).avatar;
    final resolved = HyperAvatarTheme.of(context).groupStyle.merge(style);
    final extent = resolved.size ?? metrics.sizeFor(size);
    assert(extent > 0);
    final limit = switch (layout) {
      HyperAvatarGroupLayout.circle5 => 5,
      HyperAvatarGroupLayout.centered => 6,
      HyperAvatarGroupLayout.grid4 => 4,
      HyperAvatarGroupLayout.grid9 => 9,
      HyperAvatarGroupLayout.mosaic => mosaicColumns * mosaicColumns,
      _ => maxVisible ?? 5,
    };
    final capacity = math.min(maxVisible ?? limit, limit);
    final visible = math.min(avatars.length, capacity);
    final overflow = avatars.length > capacity;
    final geometry = _geometry(
      context,
      visible,
      extent,
      (resolved.overlap ?? metrics.overlap).clamp(0.0, extent),
      math.max(0.0, resolved.spacing ?? metrics.spacing),
      overflow: overflow,
    );
    final duration = MediaQuery.maybeOf(context)?.disableAnimations == true
        ? Duration.zero
        : resolved.duration ?? theme.motion.fastDuration;
    final curve = resolved.curve ?? theme.motion.fastCurve;
    final mosaic = layout == HyperAvatarGroupLayout.mosaic;
    final grid =
        layout == HyperAvatarGroupLayout.grid4 ||
        layout == HyperAvatarGroupLayout.grid9;
    final target = groupSize ?? resolved.groupSize ?? geometry.size;
    assert(
      target.width.isFinite &&
          target.height.isFinite &&
          target.width > 0 &&
          target.height > 0,
    );
    return LayoutBuilder(
      builder: (context, constraints) {
        final canvas = constraints.constrain(target);
        final scale = math.min(
          canvas.width / geometry.size.width,
          canvas.height / geometry.size.height,
        );
        final dx = (canvas.width - geometry.size.width * scale) / 2;
        final dy = (canvas.height - geometry.size.height * scale) / 2;
        final ringWidth = (resolved.ringWidth ?? metrics.ringWidth) * scale;
        final ringColor = resolved.ringColor ?? theme.colors.background;
        final tileSide = geometry.size.width * scale;
        final outerRadius = mosaicShape == HyperAvatarShape.circle
            ? tileSide / 2
            : (resolved.radius ?? metrics.radius) * scale;
        final stack = Stack(
          clipBehavior: Clip.none,
          children: [
            for (var i = 0; i < visible; i++)
              AnimatedPositionedDirectional(
                key: ValueKey(avatars[i].key ?? i),
                duration: duration,
                curve: curve,
                start: (mosaic ? 0 : dx) + geometry.slots[i].left * scale,
                top: (mosaic ? 0 : dy) + geometry.slots[i].top * scale,
                width: geometry.slots[i].width * scale,
                height: geometry.slots[i].height * scale,
                child: Builder(
                  builder: (context) {
                    final hidden = avatars.length - visible + 1;
                    if (overflow &&
                        i == visible - 1 &&
                        overflowBuilder != null) {
                      return overflowBuilder!(context, hidden);
                    }
                    final avatar = overflow && i == visible - 1
                        ? HyperAvatar(
                            text: '+$hidden',
                            semanticsLabel: '还有 $hidden 个头像',
                          )
                        : avatars[i];
                    final avatarExtent = geometry.slots[i].width * scale;
                    final textStyle = theme.textTheme.labelLarge
                        ?.merge(avatar.style?.textStyle)
                        .merge(resolved.textStyle);
                    return HyperAvatar(
                      image: avatar.image,
                      text: avatar.text,
                      icon: avatar.icon,
                      size: size,
                      shape: mosaic || grid
                          ? HyperAvatarShape.rounded
                          : avatar.shape,
                      semanticsLabel: avatar.semanticsLabel,
                      style: (avatar.style ?? const HyperAvatarStyle())
                          .merge(resolved)
                          .merge(
                            HyperAvatarStyle(
                              size: avatarExtent,
                              radius: mosaic
                                  ? 0
                                  : (resolved.radius ??
                                            avatar.style?.radius ??
                                            metrics.radius) *
                                        scale,
                              textStyle: textStyle?.copyWith(
                                fontSize: textStyle.fontSize == null
                                    ? null
                                    : textStyle.fontSize! *
                                          avatarExtent /
                                          extent,
                              ),
                              iconSize: math.min(
                                (resolved.iconSize ??
                                        avatar.style?.iconSize ??
                                        metrics.iconSize) *
                                    scale,
                                avatarExtent / 2,
                              ),
                              borderColor: ringColor,
                              borderWidth: ringWidth,
                            ),
                          ),
                      child: avatar.child,
                    );
                  },
                ),
              ),
          ],
        );
        return AnimatedContainer(
          duration: duration,
          curve: curve,
          width: canvas.width,
          height: canvas.height,
          child: mosaic
              ? Center(
                  child: AnimatedContainer(
                    duration: duration,
                    curve: curve,
                    width: tileSide,
                    height: tileSide,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(outerRadius),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: stack,
                  ),
                )
              : stack,
        );
      },
    );
  }
}
