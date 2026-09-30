import 'package:flutter/physics.dart';
import 'package:flutter/widgets.dart';

import '../theme/core/hyper_theme.dart';

/// 将拖动超出边界的距离转换为有阻力的位移，并在松手后弹回。
///
/// 调用方负责计算有符号的越界距离：起点外为负，终点外为正。
/// 这个控制器不修改进度值，也不接管手势或命中区域。
final class HyperElasticOverscrollController extends ChangeNotifier {
  HyperElasticOverscrollController({required TickerProvider vsync}) {
    _animation = AnimationController.unbounded(vsync: vsync)
      ..addListener(notifyListeners);
  }

  late final AnimationController _animation;

  double get displacement => _animation.value;

  /// 新一轮拖动开始时停止旧回弹，保持当前视觉位置。
  void stop() => _animation.stop();

  /// 基于全局 Motion 弹簧生成越界回弹默认值。
  static SpringDescription springFromMotion(SpringDescription spring) =>
      SpringDescription(
        mass: spring.mass,
        stiffness: spring.stiffness * .65,
        damping: spring.damping * 1.5,
      );

  /// [resistance] 越大，同样的越界距离产生的位移越小。
  void pull(
    double overshoot, {
    required double maxExtent,
    double resistance = 9,
    bool disabled = false,
  }) {
    assert(maxExtent >= 0);
    assert(resistance > 0);
    if (disabled || maxExtent == 0) {
      _animation.value = 0;
      return;
    }
    final distance = overshoot.abs();
    _animation.value =
        overshoot.sign *
        maxExtent *
        distance /
        (distance + maxExtent * resistance);
  }

  /// 使用调用方提供的弹簧归位，可直接传入全局 Motion 主题参数。
  void release({required SpringDescription spring, bool disabled = false}) {
    if (disabled || displacement == 0) {
      _animation.value = 0;
      return;
    }
    _animation.animateWith(SpringSimulation(spring, displacement, 0, 0));
  }

  double scale({required double maxExtent, double maxScale = 1}) {
    assert(maxExtent >= 0);
    assert(maxScale > 0);
    if (maxExtent == 0) return 1;
    return 1 +
        (maxScale - 1) * (displacement.abs() / maxExtent).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _animation.dispose();
    super.dispose();
  }
}

/// 对任意拖动控件应用越界位移，可选轻微缩放，支持水平与竖直方向。
class HyperElasticOverscrollTransform extends StatelessWidget {
  const HyperElasticOverscrollTransform({
    super.key,
    required this.controller,
    required this.axis,
    required this.maxExtent,
    required this.child,
    this.maxScale = 1,
    this.enabled = true,
    this.transformHitTests = false,
  });

  final HyperElasticOverscrollController controller;
  final Axis axis;
  final double maxExtent;
  final double maxScale;
  final bool enabled;
  final bool transformHitTests;
  final Widget child;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    child: child,
    builder: (context, child) {
      final displacement = enabled ? controller.displacement : 0.0;
      final scale = enabled
          ? controller.scale(maxExtent: maxExtent, maxScale: maxScale)
          : 1.0;
      final shifted = scale == 1
          ? child
          : Transform.scale(
              scale: scale,
              alignment: Alignment.center,
              transformHitTests: transformHitTests,
              child: child,
            );
      return Transform.translate(
        offset: axis == Axis.vertical
            ? Offset(0, displacement)
            : Offset(displacement, 0),
        transformHitTests: transformHitTests,
        child: shifted,
      );
    },
  );
}

/// 包住现有滑块即可获得越界反馈，不接管滑块本身的手势和值。
///
/// 指针须从子组件范围内按下；拖出两端后才会产生阻尼位移。
class HyperElasticOverscrollRegion extends StatefulWidget {
  const HyperElasticOverscrollRegion({
    super.key,
    required this.axis,
    required this.maxExtent,
    required this.child,
    this.maxScale = 1,
    this.resistance = 9,
    this.spring,
    this.enabled = true,
    this.transformHitTests = false,
  }) : assert(maxExtent >= 0),
       assert(maxScale > 0),
       assert(resistance > 0);

  final Axis axis;
  final double maxExtent;
  final double maxScale;
  final double resistance;
  final SpringDescription? spring;
  final bool enabled;
  final bool transformHitTests;
  final Widget child;

  @override
  State<HyperElasticOverscrollRegion> createState() =>
      _HyperElasticOverscrollRegionState();
}

class _HyperElasticOverscrollRegionState
    extends State<HyperElasticOverscrollRegion>
    with SingleTickerProviderStateMixin {
  late final HyperElasticOverscrollController _controller;
  int? _pointer;

  @override
  void initState() {
    super.initState();
    _controller = HyperElasticOverscrollController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _release() {
    _pointer = null;
    _controller.release(
      spring:
          widget.spring ??
          HyperElasticOverscrollController.springFromMotion(
            HyperTheme.of(context).motion.spring,
          ),
      disabled:
          !widget.enabled ||
          (MediaQuery.maybeOf(context)?.disableAnimations ?? false),
    );
  }

  @override
  Widget build(BuildContext context) => Listener(
    behavior: HitTestBehavior.translucent,
    onPointerDown: widget.enabled
        ? (event) {
            if (_pointer != null) return;
            _pointer = event.pointer;
            _controller.stop();
          }
        : null,
    onPointerMove: widget.enabled
        ? (event) {
            if (event.pointer != _pointer) return;
            final extent = widget.axis == Axis.vertical
                ? context.size?.height
                : context.size?.width;
            if (extent == null) return;
            final position = widget.axis == Axis.vertical
                ? event.localPosition.dy
                : event.localPosition.dx;
            final overshoot = position < 0
                ? position
                : (position > extent ? position - extent : 0.0);
            _controller.pull(
              overshoot,
              maxExtent: widget.maxExtent,
              resistance: widget.resistance,
              disabled: MediaQuery.maybeOf(context)?.disableAnimations ?? false,
            );
          }
        : null,
    onPointerUp: (event) {
      if (event.pointer == _pointer) _release();
    },
    onPointerCancel: (event) {
      if (event.pointer == _pointer) _release();
    },
    child: HyperElasticOverscrollTransform(
      controller: _controller,
      axis: widget.axis,
      maxExtent: widget.maxExtent,
      maxScale: widget.maxScale,
      enabled:
          widget.enabled &&
          !(MediaQuery.maybeOf(context)?.disableAnimations ?? false),
      transformHitTests: widget.transformHitTests,
      child: widget.child,
    ),
  );
}
