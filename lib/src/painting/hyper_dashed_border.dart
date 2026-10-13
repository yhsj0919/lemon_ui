// 公共参数保留 line / side 等名称，私有字段保存两种 const 构造形式。
// ignore_for_file: prefer_initializing_formals
import 'dart:math' as math;

import 'package:flutter/painting.dart';

import '../foundation/hyper_line.dart';
import '../foundation/hyper_fill.dart';

/// 将共用线条样式绘制为均匀的矩形、圆角或圆形轮廓。
class HyperLineBorder extends BoxBorder {
  const HyperLineBorder({
    required HyperLine line,
    double strokeAlign = BorderSide.strokeAlignInside,
  }) : _line = line,
       _strokeAlign = strokeAlign,
       _side = null,
       _dashLength = null,
       _gapLength = null;
  const HyperLineBorder._dashed({
    required BorderSide side,
    required double dashLength,
    required double gapLength,
  }) : _line = null,
       _strokeAlign = null,
       _side = side,
       _dashLength = dashLength,
       _gapLength = gapLength;
  final HyperLine? _line;
  final BorderSide? _side;
  final double? _strokeAlign, _dashLength, _gapLength;
  HyperLine get line =>
      _line ??
      HyperLine(
        fill: HyperFill.color(_side!.color),
        thickness: _side.style == BorderStyle.none ? 0 : _side.width,
        pattern: HyperLinePattern.dashed,
        dashLength: _dashLength!,
        gap: _gapLength!,
      );
  double get strokeAlign => _strokeAlign ?? _side!.strokeAlign;
  BorderSide get side => BorderSide(
    color:
        line.fill.color ??
        line.fill.gradient?.colors.first ??
        const Color(0x00000000),
    width: line.thickness,
    style: line.isNone ? BorderStyle.none : BorderStyle.solid,
    strokeAlign: strokeAlign,
  );
  @override
  BorderSide get top => side;
  @override
  BorderSide get bottom => side;
  @override
  bool get isUniform => true;
  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.all(side.strokeInset);
  @override
  HyperLineBorder scale(double t) => HyperLineBorder(
    line: line.copyWith(thickness: math.max(0, line.thickness * t)),
    strokeAlign: strokeAlign,
  );
  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRect(rect);
  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) =>
      Path()..addRect(rect.deflate(side.strokeInset));
  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    if (line.isNone) return;
    final offset = line.thickness * strokeAlign / 2;
    final path = Path();
    if (shape == BoxShape.circle) {
      path.addOval(
        Rect.fromCircle(
          center: rect.center,
          radius: math.max(0, rect.shortestSide / 2 + offset),
        ),
      );
    } else {
      path.addRRect(
        (borderRadius ?? BorderRadius.zero).toRRect(rect).inflate(offset),
      );
    }
    final paint = Paint()
      ..color = line.fill.gradient == null
          ? side.color
          : const Color(0xffffffff)
      ..shader = line.fill.gradient?.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = line.thickness
      ..strokeCap = line.radius > 0 ? StrokeCap.round : StrokeCap.butt;
    if (line.pattern == HyperLinePattern.solid) {
      canvas.drawPath(path, paint);
      return;
    }
    for (final metric in path.computeMetrics()) {
      for (final segment in line.segments(metric.length)) {
        if (line.pattern == HyperLinePattern.dotted) {
          final tangent = metric.getTangentForOffset(
            math.min(segment.start + line.thickness / 2, metric.length),
          );
          if (tangent != null) {
            canvas.drawCircle(
              tangent.position,
              line.thickness / 2,
              Paint()
                ..color = paint.color
                ..shader = paint.shader,
            );
          }
        } else {
          canvas.drawPath(
            metric.extractPath(segment.start, segment.end),
            paint,
          );
        }
      }
    }
  }

  BoxBorder? _blend(ShapeBorder? other, double t, bool from) {
    if (other != null && (other is! BoxBorder || !other.isUniform)) return null;
    final otherSide = (other as BoxBorder?)?.top ?? BorderSide.none;
    final otherLine = other is HyperLineBorder
        ? other.line
        : HyperLine(
            fill: otherSide.style == BorderStyle.none
                ? const HyperFill.none()
                : HyperFill.color(otherSide.color),
            thickness: otherSide.width,
          );
    final value = from
        ? HyperLine.lerp(otherLine, line, t)
        : HyperLine.lerp(line, otherLine, t);
    final align = other is HyperLineBorder
        ? other.strokeAlign
        : otherSide.strokeAlign;
    return HyperLineBorder(
      line: value,
      strokeAlign: from
          ? align + (strokeAlign - align) * t
          : strokeAlign + (align - strokeAlign) * t,
    );
  }

  @override
  BoxBorder? lerpFrom(ShapeBorder? a, double t) => _blend(a, t, true);
  @override
  BoxBorder? lerpTo(ShapeBorder? b, double t) => _blend(b, t, false);
  @override
  bool operator ==(Object other) =>
      other is HyperLineBorder &&
      other.line == line &&
      other.strokeAlign == strokeAlign;
  @override
  int get hashCode => Object.hash(line, strokeAlign);
}

/// 保留虚线边框便捷接口；所有绘制和插值由 HyperLineBorder 负责。
class HyperDashedBorder extends HyperLineBorder {
  const HyperDashedBorder({
    super.side = const BorderSide(),
    super.dashLength = 6,
    super.gapLength = 4,
  }) : super._dashed();
  double get dashLength => line.dashLength;
  double get gapLength => line.gap;
  @override
  HyperDashedBorder scale(double t) => HyperDashedBorder(
    side: side.scale(t),
    dashLength: dashLength,
    gapLength: gapLength,
  );
}

extension HyperLineBorderConversion on HyperLine {
  /// 复用同一线条样式作为控件轮廓，空线条会明确关闭轮廓。
  BoxBorder toBorder({double strokeAlign = BorderSide.strokeAlignInside}) =>
      HyperLineBorder(line: this, strokeAlign: strokeAlign);
}
