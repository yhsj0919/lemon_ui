import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/core/hyper_theme.dart';
import '../dialog/hyper_dialog.dart';
import '../dialog/hyper_dialog_style.dart';
import '../icon_button/hyper_icon_button.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../dialog/hyper_dialog_theme.dart';
import 'hyper_movable_dialog_style.dart';
import 'hyper_movable_dialog_theme.dart';

class HyperMovableDialogController extends ChangeNotifier {
  HyperMovableDialogController({Offset initialOffset = Offset.zero})
    : _offset = initialOffset {
    if (!initialOffset.dx.isFinite || !initialOffset.dy.isFinite) {
      throw ArgumentError('位移须有限');
    }
  }
  Offset _offset;
  bool _maximized = false;
  bool get maximized => _maximized;
  void setMaximized(bool value) {
    if (_maximized == value) return;
    _maximized = value;
    notifyListeners();
  }

  void toggleMaximized() => setMaximized(!_maximized);
  Offset get offset => _offset;
  void moveTo(Offset value) {
    if (!value.dx.isFinite || !value.dy.isFinite) throw ArgumentError('位移须有限');
    if (value == _offset) return;
    _offset = value;
    notifyListeners();
  }

  void reset() => moveTo(Offset.zero);
}

/// Title-only dragging and keyboard movement around the shared HyperDialog.
class HyperMovableDialog extends StatefulWidget {
  const HyperMovableDialog({
    super.key,
    required this.title,
    required this.content,
    this.actions = const [],
    this.controller,
    this.enabled = true,
    this.showCloseButton = true,
    this.showMaximizeButton = true,
    this.onClose,
    this.scrollable = true,
    this.onPositionChanged,
    this.style,
    this.semanticLabel = '可移动对话框',
  });
  final Widget title, content;
  final List<Widget> actions;
  final HyperMovableDialogController? controller;
  final bool enabled, showCloseButton, scrollable;
  final bool showMaximizeButton;
  final VoidCallback? onClose;
  final ValueChanged<Offset>? onPositionChanged;
  final HyperMovableDialogStyle? style;
  final String semanticLabel;
  @override
  State<HyperMovableDialog> createState() => _HyperMovableDialogState();
}

class _HyperMovableDialogState extends State<HyperMovableDialog>
    with TickerProviderStateMixin {
  late final _geometry = AnimationController(vsync: this, value: 1)
    ..addListener(() {
      if (mounted) setState(() {});
    });
  late final _material = AnimationController(vsync: this, value: 1);
  bool _lastMaximized = false;
  Size? _normalSize, _fromSize;
  Offset _fromOffset = Offset.zero;
  late final _owned = HyperMovableDialogController();
  final _surface = GlobalKey(), _bounds = GlobalKey();
  final _contentKey = GlobalKey();
  final _titleFocus = FocusNode();
  BoxConstraints? _lastConstraints;
  HyperMovableDialogController get controller => widget.controller ?? _owned;
  @override
  void initState() {
    super.initState();
    controller.addListener(changed);
    _lastMaximized = controller.maximized;
    _geometry.addStatusListener((status) {
      if (mounted && status == AnimationStatus.completed)
        _material.forward(from: 0);
    });
  }

  @override
  void didUpdateWidget(covariant HyperMovableDialog oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      (oldWidget.controller ?? _owned).removeListener(changed);
      controller.addListener(changed);
    }
  }

  void changed() {
    if (!mounted) return;
    if (_lastMaximized != controller.maximized) {
      final surface = _surface.currentContext?.findRenderObject();
      if (surface is RenderBox && surface.hasSize) {
        _fromSize = surface.size;
        if (!_lastMaximized) _normalSize = surface.size;
      }
      _fromOffset = _lastMaximized ? Offset.zero : controller.offset;
      _lastMaximized = controller.maximized;
      final theme = HyperTheme.of(context);
      final reduced = MediaQuery.disableAnimationsOf(context);
      _geometry.duration = reduced
          ? Duration.zero
          : theme.motion.standardDuration;
      _material.duration = reduced ? Duration.zero : theme.motion.fastDuration;
      _material.value = 0;
      _geometry.forward(from: 0);
    }
    setState(() {});
    widget.onPositionChanged?.call(controller.offset);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) move(Offset.zero);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) move(Offset.zero);
    });
  }

  @override
  void dispose() {
    _geometry.dispose();
    _material.dispose();
    _titleFocus.dispose();
    controller.removeListener(changed);
    _owned.dispose();
    super.dispose();
  }

  void move(Offset delta) {
    if (controller.maximized || _geometry.isAnimating) return;
    final surface = _surface.currentContext?.findRenderObject();
    final bounds = _bounds.currentContext?.findRenderObject();
    if (surface is! RenderBox ||
        bounds is! RenderBox ||
        !surface.hasSize ||
        !bounds.hasSize) {
      return;
    }
    final rect = surface.localToGlobal(Offset.zero) & surface.size;
    final origin = bounds.localToGlobal(Offset.zero);
    final insets = MediaQuery.viewInsetsOf(context);
    final available = Rect.fromLTWH(
      origin.dx,
      origin.dy,
      bounds.size.width,
      (bounds.size.height - insets.bottom).clamp(0, double.infinity),
    );
    double clamp(double change, double lower, double upper) =>
        lower > upper ? lower : change.clamp(lower, upper).toDouble();
    final actual = Offset(
      clamp(delta.dx, available.left - rect.left, available.right - rect.right),
      clamp(delta.dy, available.top - rect.top, available.bottom - rect.bottom),
    );
    controller.moveTo(controller.offset + actual);
  }

  @override
  Widget build(BuildContext context) {
    final style = HyperMovableDialogTheme.of(context).style.merge(widget.style);
    final dialog = LayoutBuilder(
      builder: (_, constraints) {
        if (!constraints.hasBoundedWidth || !constraints.hasBoundedHeight) {
          throw FlutterError('HyperMovableDialog 需要有界的对话框宿主');
        }
        if (_lastConstraints != constraints) {
          _lastConstraints = constraints;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) move(Offset.zero);
          });
        }
        final baseStyle = HyperDialogTheme.of(context).style
            .merge(style.dialogStyle);
        final normalInsets =
            (baseStyle.insetPadding ??
                    HyperTheme.sizesOf(context).dialog.insetPadding)
                .resolve(Directionality.of(context));
        final normalWidth =
            (baseStyle.width ??
                    baseStyle.maxWidth ??
                    HyperTheme.sizesOf(context).dialog.maxWidth)
                .clamp(0, constraints.maxWidth - normalInsets.horizontal)
                .toDouble();
        final normalSize =
            _normalSize ??
            Size(normalWidth, _fromSize?.height ?? constraints.maxHeight);
        final target = controller.maximized
            ? Size(
                constraints.maxWidth,
                (constraints.maxHeight -
                        MediaQuery.viewInsetsOf(context).vertical)
                    .clamp(0, double.infinity),
              )
            : normalSize;
        final progress = HyperTheme.of(context).motion.standardCurve
            .transform(_geometry.value);
        final animatedSize = Size.lerp(_fromSize ?? target, target, progress)!;
        final animating = _geometry.isAnimating;
        final offset = Offset.lerp(
          _fromOffset,
          controller.maximized ? Offset.zero : controller.offset,
          progress,
        )!;
        return SizedBox.expand(
          key: _bounds,
          child: HyperDialog(
            animateInsets: false,
            semanticLabel: widget.semanticLabel,
            style: controller.maximized || animating
                ? (style.dialogStyle ?? const HyperDialogStyle()).copyWith(
                    width: animatedSize.width,
                    maxWidth: animatedSize.width,
                    insetPadding: EdgeInsets.zero,
                    alignment: Alignment.center,
                  )
                : style.dialogStyle,
            showCloseButton: widget.showCloseButton,
            onClose: widget.onClose,
            scrollable: widget.scrollable,
            content: KeyedSubtree(key: _contentKey, child: widget.content),
            actions: widget.actions,
            titleActions: [
              if (widget.showMaximizeButton)
                HyperIconButton.ghost(
                  tooltip: controller.maximized ? '还原' : '最大化',
                  icon: Icon(
                    controller.maximized
                        ? Icons.filter_none
                        : Icons.crop_square,
                  ),
                  onPressed: widget.enabled ? controller.toggleMaximized : null,
                ),
            ],
            title: Semantics(
              label: '拖动或使用方向键移动对话框',
              child: Focus(
                focusNode: _titleFocus,
                canRequestFocus: widget.enabled,
                onKeyEvent: (_, event) {
                  if (!widget.enabled ||
                      event is! KeyDownEvent && event is! KeyRepeatEvent) {
                    return KeyEventResult.ignored;
                  }
                  final key = event.logicalKey;
                  if (key == LogicalKeyboardKey.home) {
                    controller.reset();
                    return KeyEventResult.handled;
                  }
                  final step = HardwareKeyboard.instance.isShiftPressed
                      ? HyperTheme.sizesOf(context).form.gap
                      : 1.0;
                  if (key == LogicalKeyboardKey.arrowLeft) {
                    move(Offset(-step, 0));
                  } else if (key == LogicalKeyboardKey.arrowRight) {
                    move(Offset(step, 0));
                  } else if (key == LogicalKeyboardKey.arrowUp) {
                    move(Offset(0, -step));
                  } else if (key == LogicalKeyboardKey.arrowDown) {
                    move(Offset(0, step));
                  } else {
                    return KeyEventResult.ignored;
                  }
                  return KeyEventResult.handled;
                },
                child: MouseRegion(
                  cursor: widget.enabled
                      ? style.mouseCursor ?? SystemMouseCursors.move
                      : SystemMouseCursors.basic,
                  child: GestureDetector(
                    key: const ValueKey('hyper-movable-dialog-handle'),
                    behavior: HitTestBehavior.opaque,
                    onPanStart: widget.enabled && !controller.maximized
                        ? (_) => _titleFocus.requestFocus()
                        : null,
                    onPanUpdate: widget.enabled && !controller.maximized
                        ? (e) => move(e.delta)
                        : null,
                    onDoubleTap: widget.enabled && widget.showMaximizeButton
                        ? controller.toggleMaximized
                        : null,
                    child: widget.title,
                  ),
                ),
              ),
            ),
            surfaceBuilder: (_, surface) => Transform.translate(
              offset: animating
                  ? offset
                  : controller.maximized
                  ? Offset.zero
                  : controller.offset,
              child: SizedBox(
                height: controller.maximized || animating
                    ? animatedSize.height
                    : null,
                child: KeyedSubtree(key: _surface, child: surface),
              ),
            ),
          ),
        );
      },
    );
    return AnimatedBuilder(
      animation: _material,
      child: dialog,
      builder: (context, child) => HyperMaterialTheme(
        data: HyperMaterialThemeData(transitionProgress: _material.value),
        child: child!,
      ),
    );
  }
}

/// Shared modal route: captures call-site themes, safe material transition and focus.
Future<T?> showHyperMovableDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  HyperDialogStyle? style,
  bool barrierDismissible = true,
  bool? useRootNavigator,
  String? barrierLabel,
  RouteSettings? routeSettings,
}) => showHyperDialog<T>(
  context: context,
  builder: builder,
  style:
      HyperMovableDialogTheme.of(context).style.dialogStyle?.merge(style) ??
      style,
  barrierDismissible: barrierDismissible,
  useRootNavigator: useRootNavigator,
  barrierLabel: barrierLabel,
  routeSettings: routeSettings,
);
