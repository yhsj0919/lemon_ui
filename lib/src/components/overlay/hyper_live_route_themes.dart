import 'package:flutter/widgets.dart';

/// 保留调用处主题；源子树更新后重新捕获，避免跨路由注册继承依赖。
class HyperLiveRouteThemes extends StatefulWidget {
  const HyperLiveRouteThemes({
    super.key,
    required this.source,
    required this.destination,
    required this.child,
  });
  final BuildContext source;
  final BuildContext destination;
  final Widget child;
  @override
  State<HyperLiveRouteThemes> createState() => _HyperLiveRouteThemesState();
}

class _HyperLiveRouteThemesState extends State<HyperLiveRouteThemes> {
  late CapturedThemes _themes;
  List<Widget> _ancestors = [];
  List<Widget> _read() {
    final result = <Widget>[];
    widget.source.visitAncestorElements((element) {
      if (element == widget.destination) return false;
      if (element.widget is InheritedTheme) result.add(element.widget);
      return true;
    });
    return result;
  }

  void _capture() {
    _ancestors = _read();
    _themes = InheritedTheme.capture(
      from: widget.source,
      to: widget.destination,
    );
  }

  @override
  void initState() {
    super.initState();
    _capture();
    WidgetsBinding.instance.addPostFrameCallback(_check);
  }

  void _check(Duration _) {
    if (!mounted || !widget.source.mounted) return;
    final current = _read();
    if (current.length != _ancestors.length ||
        List.generate(
          current.length,
          (i) => identical(current[i], _ancestors[i]),
        ).contains(false)) {
      setState(_capture);
    }
    // 只观察已有帧，不主动请求帧；空闲时不会持续刷新。
    WidgetsBinding.instance.addPostFrameCallback(_check);
  }

  @override
  Widget build(BuildContext context) => _themes.wrap(widget.child);
}
