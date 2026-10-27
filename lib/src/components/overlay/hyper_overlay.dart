import 'package:flutter/widgets.dart';

/// 关闭当前内容所属的最近弹层，不回退普通页面。
abstract final class HyperOverlay {
  /// 返回是否发出了关闭请求。受控浮层仍由 onOpenChanged 更新开合状态。
  /// result 类型必须与打开弹层时声明的类型一致。
  static bool close<T>(BuildContext context, [T? result]) {
    if (!context.mounted) return false;
    final scope = context.getInheritedWidgetOfExactType<_HyperOverlayScope>();
    if (scope != null) return scope.close(result);
    // Preserve close-button behavior when HyperDialog/HyperBottomSheet is used
    // inside a Flutter popup route rather than a Hyper show function.
    final route = ModalRoute.of(context);
    if (route is! PopupRoute || !route.isCurrent || route.navigator == null) {
      return false;
    }
    route.navigator!.pop<T>(result);
    return true;
  }
}

/// 为自定义弹层接入统一关闭入口；只应包裹弹层内容，不包裹触发器。
class HyperOverlayScope<T> extends StatelessWidget {
  const HyperOverlayScope({
    super.key,
    required this.onClose,
    required this.child,
  });

  /// 返回是否发出了关闭请求；返回 false 时不会向外层继续关闭。
  final bool Function(T? result) onClose;
  final Widget child;

  /// 绑定内容所属路由，拒绝关闭其上方的其他路由。
  static Widget route<T>({
    required BuildContext context,
    required Widget child,
  }) {
    final route = ModalRoute.of<T>(context)!;
    return HyperOverlayScope<T>(
      onClose: (result) {
        if (!route.isCurrent || route.navigator == null) return false;
        route.navigator!.pop<T>(result);
        return true;
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) => _HyperOverlayScope(
    close: (result) => onClose(result as T?),
    child: child,
  );
}

class _HyperOverlayScope extends InheritedWidget {
  const _HyperOverlayScope({required this.close, required super.child});
  final bool Function(Object?) close;

  @override
  bool updateShouldNotify(_HyperOverlayScope oldWidget) =>
      close != oldWidget.close;
}
