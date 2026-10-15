import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// 公共 UI 安全边界：原生 Windows 暂停组件无障碍输出。
///
/// Flutter #190357 / #175041 的孤立 OverlayPortal 节点可使 AXTree 失效并崩溃。
/// 用户授权先停用此能力；宿主判断不使用模拟设备或窗口宽度。
/// 不修改 Focus、Shortcuts、Actions、指针或手势处理。
/// 待 SDK 修复并通过 Windows 路由、拖动和读屏原生回归后移除此保护。
class HyperSemanticsGuard extends StatelessWidget {
  const HyperSemanticsGuard({
    super.key,
    required this.child,
    this.containOverlay = false,
  });
  final Widget child;

  /// 原生 Slider 的 Portal 在祖先 Overlay 绘制，需留在排除边界内部。
  final bool containOverlay;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.windows) return child;
    final content = containOverlay
        ? Overlay.wrap(
            alwaysSizeToContent: true,
            clipBehavior: Clip.none,
            child: child,
          )
        : child;
    if (context.dependOnInheritedWidgetOfExactType<_GuardScope>() != null) {
      return content;
    }
    return _GuardScope(child: ExcludeSemantics(child: content));
  }
}

class _GuardScope extends InheritedWidget {
  const _GuardScope({required super.child});
  @override
  bool updateShouldNotify(_GuardScope oldWidget) => false;
}
