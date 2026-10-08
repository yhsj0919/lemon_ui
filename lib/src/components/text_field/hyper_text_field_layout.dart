import 'dart:math' as math;

import 'package:flutter/painting.dart';

/// 按钮自身已包含图标两侧留白，外侧只补齐剩余的内容内边距。
double resolveHyperTextFieldSuffixPadding({
  required double padding,
  required double actionWidth,
  required double iconSize,
  required bool endsWithAction,
}) => endsWithAction
    ? math.max(0.0, padding - math.max(0.0, actionWidth - iconSize) / 2)
    : padding;

/// 只调整容器留白，不改变字体、字号或行高。
({double minimumHeight, EdgeInsets padding}) resolveHyperTextFieldLayout({
  required double? height,
  required double minimumHeight,
  required EdgeInsets padding,
  required double contentHeight,
  required double borderWidth,
}) {
  assert(height == null || height > 0);
  assert(contentHeight >= 0 && borderWidth >= 0);
  if (height == null) return (minimumHeight: minimumHeight, padding: padding);
  final target = math.max(height, contentHeight + borderWidth * 2);
  final budget = target - contentHeight - borderWidth * 2;
  final top = math.max(0.0, padding.top - borderWidth);
  final bottom = math.max(0.0, padding.bottom - borderWidth);
  final total = top + bottom;
  final factor = total == 0 ? 0.0 : math.min(1.0, budget / total);
  return (
    minimumHeight: target,
    padding: EdgeInsets.fromLTRB(
      padding.left,
      borderWidth + top * factor,
      padding.right,
      borderWidth + bottom * factor,
    ),
  );
}
