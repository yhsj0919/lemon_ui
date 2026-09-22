import 'package:flutter/animation.dart';
import 'package:flutter/foundation.dart';

/// 全局统一动画节奏档位。
enum HyperMotionSpeed { instant, fast, standard, emphasized }

/// Lemon UI 的统一动画时长、曲线和弹簧参数。
@immutable
final class HyperMotionThemeData {
  const HyperMotionThemeData({
    this.fastDuration = const Duration(milliseconds: 120),
    this.standardDuration = const Duration(milliseconds: 240),
    this.emphasizedDuration = const Duration(milliseconds: 360),
    this.fastCurve = Curves.easeOut,
    this.standardCurve = Curves.easeOutCubic,
    this.emphasizedCurve = Curves.easeInOutCubic,
    this.spring = const SpringDescription(mass: 1, stiffness: 420, damping: 34),
  });

  final Duration fastDuration;
  final Duration standardDuration;
  final Duration emphasizedDuration;
  final Curve fastCurve;
  final Curve standardCurve;
  final Curve emphasizedCurve;
  final SpringDescription spring;

  /// 返回指定档位的明确动画时长。
  Duration durationFor(
    HyperMotionSpeed speed, {
    bool disableAnimations = false,
  }) {
    if (disableAnimations || speed == HyperMotionSpeed.instant) {
      return Duration.zero;
    }
    return switch (speed) {
      HyperMotionSpeed.instant => Duration.zero,
      HyperMotionSpeed.fast => fastDuration,
      HyperMotionSpeed.standard => standardDuration,
      HyperMotionSpeed.emphasized => emphasizedDuration,
    };
  }

  /// 返回指定档位的曲线；关闭动画时使用线性曲线但时长仍为零。
  Curve curveFor(HyperMotionSpeed speed) => switch (speed) {
    HyperMotionSpeed.instant => Curves.linear,
    HyperMotionSpeed.fast => fastCurve,
    HyperMotionSpeed.standard => standardCurve,
    HyperMotionSpeed.emphasized => emphasizedCurve,
  };

  HyperMotionThemeData copyWith({
    Duration? fastDuration,
    Duration? standardDuration,
    Duration? emphasizedDuration,
    Curve? fastCurve,
    Curve? standardCurve,
    Curve? emphasizedCurve,
    SpringDescription? spring,
  }) => HyperMotionThemeData(
    fastDuration: fastDuration ?? this.fastDuration,
    standardDuration: standardDuration ?? this.standardDuration,
    emphasizedDuration: emphasizedDuration ?? this.emphasizedDuration,
    fastCurve: fastCurve ?? this.fastCurve,
    standardCurve: standardCurve ?? this.standardCurve,
    emphasizedCurve: emphasizedCurve ?? this.emphasizedCurve,
    spring: spring ?? this.spring,
  );

  static HyperMotionThemeData lerp(
    HyperMotionThemeData a,
    HyperMotionThemeData b,
    double t,
  ) {
    if (t == 0) return a;
    if (t == 1) return b;
    Duration duration(Duration x, Duration y) => Duration(
      microseconds:
          (x.inMicroseconds + (y.inMicroseconds - x.inMicroseconds) * t)
              .round(),
    );
    double value(double x, double y) => x + (y - x) * t;
    return HyperMotionThemeData(
      fastDuration: duration(a.fastDuration, b.fastDuration),
      standardDuration: duration(a.standardDuration, b.standardDuration),
      emphasizedDuration: duration(a.emphasizedDuration, b.emphasizedDuration),
      fastCurve: t < .5 ? a.fastCurve : b.fastCurve,
      standardCurve: t < .5 ? a.standardCurve : b.standardCurve,
      emphasizedCurve: t < .5 ? a.emphasizedCurve : b.emphasizedCurve,
      spring: SpringDescription(
        mass: value(a.spring.mass, b.spring.mass),
        stiffness: value(a.spring.stiffness, b.spring.stiffness),
        damping: value(a.spring.damping, b.spring.damping),
      ),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HyperMotionThemeData &&
          other.fastDuration == fastDuration &&
          other.standardDuration == standardDuration &&
          other.emphasizedDuration == emphasizedDuration &&
          other.fastCurve == fastCurve &&
          other.standardCurve == standardCurve &&
          other.emphasizedCurve == emphasizedCurve &&
          other.spring.mass == spring.mass &&
          other.spring.stiffness == spring.stiffness &&
          other.spring.damping == spring.damping;

  @override
  int get hashCode => Object.hash(
    fastDuration,
    standardDuration,
    emphasizedDuration,
    fastCurve,
    standardCurve,
    emphasizedCurve,
    spring.mass,
    spring.stiffness,
    spring.damping,
  );
}
