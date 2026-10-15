import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/src/interaction/hyper_semantics_guard.dart';

class _Context extends Fake implements BuildContext {
  _Context([this.scope]);
  final InheritedWidget? scope;
  @override
  T? dependOnInheritedWidgetOfExactType<T extends InheritedWidget>({
    Object? aspect,
  }) => scope is T ? scope as T : null;
}

void main() {
  tearDown(() => debugDefaultTargetPlatformOverride = null);

  test('Windows UI 边界阻断组件语义，但真实渲染层仍接收指针', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    const child = SizedBox();
    final context = _Context();
    final scope = const HyperSemanticsGuard(
      child: child,
    ).build(context) as InheritedWidget;
    final exclusion = scope.child as ExcludeSemantics;
    expect(exclusion.excluding, isTrue);
    final render = exclusion.createRenderObject(context);
    var clicks = 0;
    final pointer = RenderPointerListener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) => clicks++,
      child: RenderConstrainedBox(
        additionalConstraints: const BoxConstraints.tightFor(
          width: 100,
          height: 40,
        ),
      ),
    );
    render.child = RenderSemanticsAnnotations(
      properties: SemanticsProperties(
        label: '调整',
        value: '50%',
        increasedValue: '55%',
        decreasedValue: '45%',
        onIncrease: () {},
        onDecrease: () {},
      ),
      child: pointer,
    );
    render.layout(const BoxConstraints.tightFor(width: 100, height: 40));
    final visible = <RenderObject>[];
    render.visitChildrenForSemantics(visible.add);
    expect(visible, isEmpty);
    final hits = BoxHitTestResult();
    expect(render.hitTest(hits, position: const Offset(10, 10)), isTrue);
    expect(hits.path.any((entry) => identical(entry.target, pointer)), isTrue);
    pointer.handleEvent(
      const PointerDownEvent(position: Offset(10, 10)),
      BoxHitTestEntry(pointer, const Offset(10, 10)),
    );
    expect(clicks, 1);
    render.child!.dispose();
    pointer.child!.dispose();
    pointer.dispose();
    render.dispose();
  });

  test('嵌套主题及独立控件复用同一 UI 边界，不重复屏蔽', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    const child = SizedBox();
    final scope = const HyperSemanticsGuard(
      child: child,
    ).build(_Context()) as InheritedWidget;
    expect(
      const HyperSemanticsGuard(child: child).build(_Context(scope)),
      same(child),
    );
  });

  for (final platform in TargetPlatform.values.where(
    (p) => p != TargetPlatform.windows,
  )) {
    test('${platform.name} 保留原 UI 和语义', () {
      debugDefaultTargetPlatformOverride = platform;
      const child = SizedBox();
      expect(
        const HyperSemanticsGuard(child: child).build(_Context()),
        same(child),
      );
    });
  }
}
