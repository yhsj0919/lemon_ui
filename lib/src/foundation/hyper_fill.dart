import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

/// Hyper 控件使用的背景填充。
///
/// 非空 [HyperFill] 始终表示显式设置：无填充、纯色或 Flutter [Gradient]。
/// 可空的 `HyperFill?` 因此可以用 `null` 表示继承，同时用 [HyperFill.none]
/// 显式移除主题提供的填充。
@immutable
sealed class HyperFill {
  const HyperFill();

  /// 创建一个显式无颜色、无渐变的填充。
  const factory HyperFill.none() = HyperNoFill;

  /// 创建纯色填充。
  const factory HyperFill.color(Color color) = HyperColorFill;

  /// 创建使用 Flutter [Gradient] 的渐变填充。
  const factory HyperFill.gradient(Gradient gradient) = HyperGradientFill;

  /// 当前值是否表示显式移除填充。
  bool get isNone => this is HyperNoFill;

  /// 纯色填充值；当前不是纯色填充时为 `null`。
  Color? get color => switch (this) {
    HyperColorFill(:final value) => value,
    _ => null,
  };

  /// 渐变填充值；当前不是渐变填充时为 `null`。
  Gradient? get gradient => switch (this) {
    HyperGradientFill(:final value) => value,
    _ => null,
  };

  /// 在两个显式填充值之间插值。
  ///
  /// 纯色使用 [Color.lerp]，渐变使用 [Gradient.lerp]。Flutter 无法安全插值的
  /// 填充类型在中点离散切换；绘制控件以后也可以显式选择交叉淡入淡出。
  static HyperFill lerp(HyperFill a, HyperFill b, double t) {
    if (identical(a, b) || a == b) {
      return a;
    }
    if (a case HyperColorFill(value: final aColor)) {
      if (b case HyperColorFill(value: final bColor)) {
        return HyperFill.color(Color.lerp(aColor, bColor, t)!);
      }
    }
    if (a case HyperGradientFill(value: final aGradient)) {
      if (b case HyperGradientFill(value: final bGradient)) {
        final value = Gradient.lerp(aGradient, bGradient, t);
        if (value != null) {
          return HyperFill.gradient(value);
        }
      }
    }
    return t < 0.5 ? a : b;
  }
}

/// 显式无背景填充。
@immutable
final class HyperNoFill extends HyperFill {
  const HyperNoFill();

  @override
  bool operator ==(Object other) => other is HyperNoFill;

  @override
  int get hashCode => Object.hash(HyperNoFill, 0);

  @override
  String toString() => 'HyperFill.none()';
}

/// 纯色背景填充。
@immutable
final class HyperColorFill extends HyperFill {
  const HyperColorFill(this.value);

  /// 填充颜色。
  final Color value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is HyperColorFill && other.value == value;

  @override
  int get hashCode => Object.hash(HyperColorFill, value);

  @override
  String toString() => 'HyperFill.color($value)';
}

/// 渐变背景填充。
@immutable
final class HyperGradientFill extends HyperFill {
  const HyperGradientFill(this.value);

  /// 绘制时使用的 Flutter 渐变。
  final Gradient value;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperGradientFill && other.value == value;

  @override
  int get hashCode => Object.hash(HyperGradientFill, value);

  @override
  String toString() => 'HyperFill.gradient($value)';
}
