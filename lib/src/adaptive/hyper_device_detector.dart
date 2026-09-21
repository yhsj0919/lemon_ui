import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../foundation/hyper_device_type.dart';

/// 根据当前上下文和布局约束自定义设备类型。
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

/// 在主题之前解析设备类型的轻量作用域。
///
/// 自动判断只选择离散的 phone、tablet、desktop 或 watch，不计算尺寸倍率。
/// 手表和特殊窗口建议通过 [deviceType] 或 [resolver] 显式确认。
class HyperDeviceDetector extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolved =
            deviceType ??
            resolver?.call(context, constraints) ??
            _resolveBuiltIn(context, constraints);
        return _HyperDeviceScope(
          deviceType: resolved,
          child: Builder(
            builder: (context) => builder(context, resolved, child),
          ),
        );
      },
    );
  }

  HyperDeviceType _resolveBuiltIn(
    BuildContext context,
    BoxConstraints constraints,
  ) {
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
        shortestSide <= watchMaxShortestSide &&
        aspectRatio <= watchMaxAspectRatio) {
      return HyperDeviceType.watch;
    }

    if (_isDesktopPlatform(defaultTargetPlatform)) {
      return HyperDeviceType.desktop;
    }

    if (shortestSide >= tabletMinShortestSide) {
      return HyperDeviceType.tablet;
    }
    return HyperDeviceType.phone;
  }

  bool _isDesktopPlatform(TargetPlatform platform) => switch (platform) {
    TargetPlatform.windows ||
    TargetPlatform.macOS ||
    TargetPlatform.linux => true,
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
