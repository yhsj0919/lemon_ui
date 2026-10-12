import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/message/hyper_message_surface.dart';

void main() {
  testWidgets('显示中的提示跟随主题，显式样式仍保留', (tester) async {
    for (final toast in [true, false]) {
      final controller = HyperSnackbarController();
      late BuildContext messageContext;
      Widget app(HyperThemeData theme) => MaterialApp(
        home: HyperTheme(
          data: theme,
          duration: Duration.zero,
          child: HyperSnackbarHost(
            controller: controller,
            child: Builder(
              builder: (context) {
                messageContext = context;
                return const Scaffold(body: SizedBox.expand());
              },
            ),
          ),
        ),
      );
      await tester.pumpWidget(app(HyperThemeData.light()));
      final explicit = const HyperMessageStyle(iconColor: Colors.orange);
      if (toast) {
        showHyperToast(
          messageContext,
          content: const Text('跟随主题'),
          duration: Duration.zero,
          style: explicit,
        );
      } else {
        showHyperSnackbar(
          messageContext,
          content: const Text('跟随主题'),
          duration: Duration.zero,
          style: explicit,
        );
      }
      await tester.pumpAndSettle();
      final light = tester
          .widget<HyperMessageSurface>(find.byType(HyperMessageSurface))
          .style;
      await tester.pumpWidget(app(HyperThemeData.dark()));
      await tester.pumpAndSettle();
      final dark = tester
          .widget<HyperMessageSurface>(find.byType(HyperMessageSurface))
          .style;
      expect(dark.textStyle!.color, HyperThemeData.dark().colors.textPrimary);
      expect(dark.textStyle!.color, isNot(light.textStyle!.color));
      expect(dark.material!.background, isNot(light.material!.background));
      expect(dark.iconColor, Colors.orange);
      controller.clear();
      await tester.pumpAndSettle();
      await tester.pumpWidget(const SizedBox.shrink());
      controller.dispose();
    }
  });
  testWidgets('消息收展动画不裁切表面外的阴影', (tester) async {
    final controller = HyperSnackbarController();
    await tester.pumpWidget(
      MaterialApp(
        home: HyperTheme(
          data: HyperThemeData.light(),
          duration: Duration.zero,
          child: HyperSnackbarHost(
            controller: controller,
            child: const Scaffold(body: SizedBox.expand()),
          ),
        ),
      ),
    );
    controller.show(
      content: const Text('阴影提示'),
      toast: true,
      duration: Duration.zero,
    );
    await tester.pumpAndSettle();
    final surface = find.byType(HyperMessageSurface);
    expect(surface, findsOneWidget);
    final filter = tester.widget<BackdropFilter>(find.byType(BackdropFilter));
    expect(filter.enabled, isTrue);
    expect(filter.filter.toString(), contains('20.0'));
    expect(
      find.ancestor(
        of: surface,
        matching: find.byWidgetPredicate(
          (widget) => widget is ClipRect && widget.clipBehavior != Clip.none,
        ),
      ),
      findsNothing,
    );
    controller.clear();
    await tester.pumpAndSettle();
    await tester.pumpWidget(const SizedBox.shrink());
    controller.dispose();
  });
  testWidgets('Toast 与 Snackbar 默认玻璃和阴影，显式无阴影可关闭', (tester) async {
    for (final toast in [true, false]) {
      for (final clearShadow in [false, true]) {
        await tester.pumpWidget(
          MaterialApp(
            home: HyperTheme(
              data: HyperThemeData.light(),
              duration: Duration.zero,
              child: Builder(
                builder: (context) => Center(
                  child: HyperMessageSurface(
                    content: const Text('已保存'),
                    style: resolveMessageStyle(
                      context,
                      toast,
                      clearShadow
                          ? const HyperMessageStyle(boxShadow: [])
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        final material = tester
            .widget<HyperMaterialSurface>(find.byType(HyperMaterialSurface))
            .material!;
        expect(material.kind, HyperSurfaceMaterialKind.softLightGlass);
        expect(material.boxShadow.isEmpty, clearShadow);
        expect(
          material
              .resolve(quality: HyperMaterialQuality.standard)
              .boxShadow
              .isEmpty,
          clearShadow,
        );
      }
    }
  });
  test('高级材质质量和透明度策略参与主题覆盖、插值和降级', () {
    const base = HyperMessageStyle(
      material: HyperSurfaceMaterial.frostedGlass(
        fallback: HyperSurfaceMaterial.solid(
          background: HyperFill.color(Colors.white),
        ),
      ),
      materialQuality: HyperMaterialQuality.advanced,
      reduceTransparency: false,
    );
    final reduced = base.merge(
      const HyperMessageStyle(reduceTransparency: true),
    );
    expect(reduced.materialQuality, HyperMaterialQuality.advanced);
    expect(
      reduced.material!
          .resolve(
            quality: reduced.materialQuality!,
            reduceTransparency: reduced.reduceTransparency!,
          )
          .usesBackdrop,
      false,
    );
    expect(
      base.material!
          .resolve(
            quality: base.materialQuality!,
            reduceTransparency: base.reduceTransparency!,
          )
          .usesBackdrop,
      true,
    );
    expect(base.copyWith(), base);
    expect(base.copyWith().hashCode, base.hashCode);
    expect(reduced, isNot(base));
    expect(HyperMessageStyle.lerp(base, reduced, 1), reduced);
    expect(
      base.copyWith(materialQuality: HyperMaterialQuality.standard),
      isNot(base),
    );
  });
  test('队列顺序、排队取消及关闭完成只发生一次', () async {
    final controller = HyperSnackbarController();
    final first = controller.show(content: const Text('first'));
    final request = controller.current!;
    final second = controller.show(content: const Text('second'));
    final third = controller.show(content: const Text('third'));
    second.close();
    expect(await second.closed, HyperMessageCloseReason.dismissed);
    expect(controller.pendingCount, 2);
    expect(controller.current, same(request));
    first.close(HyperMessageCloseReason.action);
    first.close(HyperMessageCloseReason.timeout);
    expect(controller.current, same(request));
    expect(request.closeReason, HyperMessageCloseReason.action);
    controller.complete(request);
    controller.complete(request);
    expect(await first.closed, HyperMessageCloseReason.action);
    expect(controller.current!.handle, same(third));
    controller.dispose();
    expect(await third.closed, HyperMessageCloseReason.hostDisposed);
  });

  test('宿主解绑清空当前和排队项，外部控制器可以连接新宿主', () async {
    final controller = HyperSnackbarController();
    final owner = Object();
    controller.attach(owner);
    expect(() => controller.attach(Object()), throwsStateError);
    expect(controller.dispose, throwsStateError);
    final first = controller.show(content: const Text('one'));
    final second = controller.show(content: const Text('two'));
    controller.detach(owner);
    expect(await first.closed, HyperMessageCloseReason.hostDisposed);
    expect(await second.closed, HyperMessageCloseReason.hostDisposed);
    expect(controller.current, isNull);
    controller.attach(owner);
    controller.detach(owner);
    controller.dispose();
    first.close();
    expect(
      () => controller.show(content: const Text('disposed')),
      throwsStateError,
    );
  });

  test('清空保留当前项退出职责，拒绝负时长和交互 Toast', () async {
    final controller = HyperSnackbarController();
    expect(
      () => controller.show(
        content: const Text('negative'),
        duration: const Duration(seconds: -1),
      ),
      throwsArgumentError,
    );
    expect(
      () => controller.show(
        content: const Text('toast'),
        toast: true,
        action: const Text('action'),
      ),
      throwsArgumentError,
    );
    final first = controller.show(
      content: const Text('one'),
      duration: Duration.zero,
    );
    final request = controller.current!;
    final second = controller.show(content: const Text('two'));
    controller.clear();
    expect(controller.current, same(request));
    expect(await second.closed, HyperMessageCloseReason.dismissed);
    controller.complete(request);
    expect(await first.closed, HyperMessageCloseReason.dismissed);
    expect(controller.pendingCount, 0);
    controller.dispose();
  });

  test('视觉主题合并、插值、值相等与嵌套覆盖', () {
    final base = HyperMessageStyle(
      maxWidth: 320,
      spacing: 8,
      borderRadius: BorderRadius.all(Radius.circular(12)),
      animationStyle: AnimationStyle(
        duration: Duration(milliseconds: 240),
        reverseDuration: Duration(milliseconds: 120),
        curve: Curves.easeOut,
      ),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      buttonTheme: HyperButtonThemeData(style: HyperButtonStyle(height: 32)),
    );
    final changed = base.merge(
      HyperMessageStyle(
        maxWidth: 480,
        animationStyle: AnimationStyle(duration: Duration.zero),
        buttonTheme: HyperButtonThemeData(
          style: HyperButtonStyle(
            borderRadius: BorderRadius.all(Radius.circular(6)),
          ),
        ),
      ),
    );
    expect(changed.animationStyle!.curve, Curves.easeOut);
    expect(
      changed.animationStyle!.reverseDuration,
      const Duration(milliseconds: 120),
    );
    expect(changed.buttonTheme!.style!.height, 32);
    expect(changed.buttonTheme!.style!.borderRadius, BorderRadius.circular(6));
    expect(changed.spacing, 8);
    expect(HyperMessageStyle.lerp(base, changed, .5).maxWidth, 400);
    expect(base.copyWith(), base);
    expect(base.copyWith().hashCode, base.hashCode);
    expect(HyperMessageStyle.lerp(base, changed, 0), same(base));
    expect(base.copyWith(boxShadow: []), isNot(base));
  });

  test('Toast、Snackbar 四端与全局主题独立配置', () {
    const sizes = HyperSizeThemeData();
    expect(
      [
        sizes.phone.toast.maxWidth,
        sizes.tablet.toast.maxWidth,
        sizes.desktop.toast.maxWidth,
        sizes.watch.toast.maxWidth,
      ],
      [320, 400, 360, 180],
    );
    final changed = sizes.desktop.copyWith(
      toast: sizes.desktop.toast.copyWith(maxWidth: 480),
    );
    expect(changed.snackbar, sizes.desktop.snackbar);
    expect(
      HyperSizeScheme.lerp(sizes.desktop, changed, .5).toast.maxWidth,
      420,
    );
    expect(changed.copyWith(), changed);
    expect(changed.copyWith().hashCode, changed.hashCode);
    final base = HyperThemeData.light();
    final themed = base.copyWith(
      toastTheme: const HyperToastThemeData(
        style: HyperMessageStyle(spacing: 20),
      ),
    );
    expect(themed.snackbarTheme, base.snackbarTheme);
    expect(themed, isNot(base));
    expect(themed.copyWith(), themed);
    expect(base.lerp(themed, 1).toastTheme, themed.toastTheme);
    final snackbar = base.copyWith(
      snackbarTheme: const HyperSnackbarThemeData(
        style: HyperMessageStyle(maxWidth: 480),
      ),
    );
    expect(snackbar.toastTheme, base.toastTheme);
    expect(snackbar, isNot(base));
  });
}
