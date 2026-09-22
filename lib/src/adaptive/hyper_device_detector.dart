import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../foundation/hyper_device_type.dart';

/// 根据应用启动时的上下文和布局约束自定义设备类型。
typedef HyperDeviceResolver = HyperDeviceType Function(
  BuildContext context,
  BoxConstraints constraints,
);

/// 使用已解析设备类型构建主题或应用子树。
typedef HyperDeviceWidgetBuilder = Widget Function(
  BuildContext context,
  HyperDeviceType deviceType,
  Widget? child,
);

/// 在主题之前一次性解析设备类型的轻量作用域。
///
/// Windows、Linux 和 macOS 固定使用 desktop。只有 Android 和 iOS 会在作用域
/// 首次建立时根据初始窗口区分 phone、tablet 或 watch；之后的窗口缩放不改变
/// 设备类型。预览、测试和特殊设备可以通过 [deviceType] 或 [resolver] 覆盖。
class HyperDeviceDetector extends StatefulWidget {
  const HyperDeviceDetector({
    super.key,
    required this.builder,
    this.child,
    this.deviceType,
    this.resolver,
    this.tabletMinShortestSide = 600,
    this.watchMaxShortestSide = 260,
    this.watchMaxAspectRatio = 1.25,
  });

  /// 使用解析后的设备类型构建主题或页面。
  final HyperDeviceWidgetBuilder builder;

  /// 原样传给 [builder] 的可选子节点。
  final Widget? child;

  /// 显式设备类型；提供后跳过自动判断。
  final HyperDeviceType? deviceType;

  /// 项目自定义解析器；优先于内置判断，低于显式 [deviceType]。
  final HyperDeviceResolver? resolver;

  /// 触摸设备判定为平板的最小短边。
  final double tabletMinShortestSide;

  /// 自动判定手表的最大短边。
  final double watchMaxShortestSide;

  /// 自动判定手表允许的最大长短边比。
  final double watchMaxAspectRatio;

  /// 获取最近作用域解析出的设备类型。
  static HyperDeviceType of(BuildContext context) {
    final scope = context
        .dependOnInheritedWidgetOfExactType<_HyperDeviceScope>();
    assert(scope != null, '当前上下文中不存在 HyperDeviceDetector。');
    return scope!.deviceType;
  }

  /// 获取最近作用域的设备类型；不存在时返回 null。
  static HyperDeviceType? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_HyperDeviceScope>()
      ?.deviceType;

  @override
  State<HyperDeviceDetector> createState() => _HyperDeviceDetectorState();
}

class _HyperDeviceDetectorState extends State<HyperDeviceDetector> {
  HyperDeviceType? _detectedDeviceType;

  @override
  void didUpdateWidget(HyperDeviceDetector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.deviceType != widget.deviceType ||
        oldWidget.resolver != widget.resolver ||
        oldWidget.tabletMinShortestSide != widget.tabletMinShortestSide ||
        oldWidget.watchMaxShortestSide != widget.watchMaxShortestSide ||
        oldWidget.watchMaxAspectRatio != widget.watchMaxAspectRatio) {
      _detectedDeviceType = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolved =
            widget.deviceType ??
            (_detectedDeviceType ??=
                widget.resolver?.call(context, constraints) ??
                _resolveBuiltIn(context, constraints));
        return _HyperDeviceScope(
          deviceType: resolved,
          child: Builder(
            builder: (context) =>
                widget.builder(context, resolved, widget.child),
          ),
        );
      },
    );
  }

  HyperDeviceType _resolveBuiltIn(
    BuildContext context,
    BoxConstraints constraints,
  ) {
    if (!_isMobilePlatform(defaultTargetPlatform)) {
      return HyperDeviceType.desktop;
    }

    final mediaSize = MediaQuery.maybeSizeOf(context);
    final width = constraints.hasBoundedWidth
        ? constraints.maxWidth
        : mediaSize?.width ?? 0;
    final height = constraints.hasBoundedHeight
        ? constraints.maxHeight
        : mediaSize?.height ?? 0;
    final shortestSide = width < height ? width : height;
    final longestSide = width > height ? width : height;
    final aspectRatio = shortestSide > 0
        ? longestSide / shortestSide
        : double.infinity;

    if (shortestSide > 0 &&
        shortestSide <= widget.watchMaxShortestSide &&
        aspectRatio <= widget.watchMaxAspectRatio) {
      return HyperDeviceType.watch;
    }

    if (shortestSide >= widget.tabletMinShortestSide) {
      return HyperDeviceType.tablet;
    }
    return HyperDeviceType.phone;
  }

  bool _isMobilePlatform(TargetPlatform platform) => switch (platform) {
    TargetPlatform.android || TargetPlatform.iOS => true,
    _ => false,
  };
}

class _HyperDeviceScope extends InheritedWidget {
  const _HyperDeviceScope({required this.deviceType, required super.child});

  final HyperDeviceType deviceType;

  @override
  bool updateShouldNotify(_HyperDeviceScope oldWidget) =>
      deviceType != oldWidget.deviceType;
}
