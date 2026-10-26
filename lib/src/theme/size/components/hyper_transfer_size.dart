import 'package:flutter/foundation.dart';

/// Transfer dimensions in logical pixels, explicitly requested by the user.
@immutable
final class HyperTransferSize {
  const HyperTransferSize({this.itemSpacing = 4});
  final double itemSpacing;
  HyperTransferSize copyWith({double? itemSpacing}) =>
      HyperTransferSize(itemSpacing: itemSpacing ?? this.itemSpacing);
  static HyperTransferSize lerp(
    HyperTransferSize a,
    HyperTransferSize b,
    double t,
  ) => HyperTransferSize(
    itemSpacing: a.itemSpacing + (b.itemSpacing - a.itemSpacing) * t,
  );
  @override
  bool operator ==(Object other) =>
      other is HyperTransferSize && other.itemSpacing == itemSpacing;
  @override
  int get hashCode => itemSpacing.hashCode;
}
