import 'package:flutter/foundation.dart';

@immutable
final class HyperFormSize {
  const HyperFormSize({
    this.labelWidth = 120,
    this.gap = 8,
    this.fieldSpacing = 16,
    this.messageSpacing = 6,
    this.minimumControlWidth = 120,
  });
  final double labelWidth;
  final double gap;
  final double fieldSpacing;
  final double messageSpacing;
  final double minimumControlWidth;
  HyperFormSize copyWith({
    double? labelWidth,
    double? gap,
    double? fieldSpacing,
    double? messageSpacing,
    double? minimumControlWidth,
  }) => HyperFormSize(
    labelWidth: labelWidth ?? this.labelWidth,
    gap: gap ?? this.gap,
    fieldSpacing: fieldSpacing ?? this.fieldSpacing,
    messageSpacing: messageSpacing ?? this.messageSpacing,
    minimumControlWidth: minimumControlWidth ?? this.minimumControlWidth,
  );
  static HyperFormSize lerp(HyperFormSize a, HyperFormSize b, double t) =>
      HyperFormSize(
        labelWidth: a.labelWidth + (b.labelWidth - a.labelWidth) * t,
        gap: a.gap + (b.gap - a.gap) * t,
        fieldSpacing: a.fieldSpacing + (b.fieldSpacing - a.fieldSpacing) * t,
        messageSpacing:
            a.messageSpacing + (b.messageSpacing - a.messageSpacing) * t,
        minimumControlWidth:
            a.minimumControlWidth +
            (b.minimumControlWidth - a.minimumControlWidth) * t,
      );
  @override
  bool operator ==(Object other) =>
      other is HyperFormSize &&
      other.labelWidth == labelWidth &&
      other.gap == gap &&
      other.fieldSpacing == fieldSpacing &&
      other.messageSpacing == messageSpacing &&
      other.minimumControlWidth == minimumControlWidth;
  @override
  int get hashCode => Object.hashAll([
    labelWidth,
    gap,
    fieldSpacing,
    messageSpacing,
    minimumControlWidth,
  ]);
}
