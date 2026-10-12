import 'package:flutter/widgets.dart';

@immutable
final class HyperPageIndicatorSize {
  const HyperPageIndicatorSize({
    required this.dotSize,
    required this.selectedWidth,
    required this.spacing,
    required this.padding,
  });
  final double dotSize;
  final double selectedWidth;
  final double spacing;
  final EdgeInsetsGeometry padding;
  HyperPageIndicatorSize copyWith({
    double? dotSize,
    double? selectedWidth,
    double? spacing,
    EdgeInsetsGeometry? padding,
  }) => HyperPageIndicatorSize(
    dotSize: dotSize ?? this.dotSize,
    selectedWidth: selectedWidth ?? this.selectedWidth,
    spacing: spacing ?? this.spacing,
    padding: padding ?? this.padding,
  );
  static HyperPageIndicatorSize lerp(
    HyperPageIndicatorSize a,
    HyperPageIndicatorSize b,
    double t,
  ) => HyperPageIndicatorSize(
    dotSize: a.dotSize + (b.dotSize - a.dotSize) * t,
    selectedWidth: a.selectedWidth + (b.selectedWidth - a.selectedWidth) * t,
    spacing: a.spacing + (b.spacing - a.spacing) * t,
    padding: EdgeInsetsGeometry.lerp(a.padding, b.padding, t)!,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperPageIndicatorSize &&
      dotSize == other.dotSize &&
      selectedWidth == other.selectedWidth &&
      spacing == other.spacing &&
      padding == other.padding;
  @override
  int get hashCode => Object.hash(dotSize, selectedWidth, spacing, padding);
}
