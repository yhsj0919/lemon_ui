import '../../foundation/hyper_icons.dart';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

import '../../theme/core/hyper_theme.dart';
import '../dialog/hyper_dialog.dart';
import '../dialog/hyper_dialog_style.dart';
import '../icon_button/hyper_icon_button.dart';
import '../../theme/material/hyper_material_theme.dart';
import '../dialog/hyper_dialog_theme.dart';
import '../overlay/hyper_overlay.dart';
import '../resizable/hyper_resizable_theme.dart';
import 'hyper_movable_dialog_style.dart';
import 'hyper_movable_dialog_theme.dart';

class HyperMovableDialogController extends ChangeNotifier {
  HyperMovableDialogController({
    Offset initialOffset = Offset.zero,
    Size? initialSize,
  }) : _offset = initialOffset,
       _size = initialSize {
    if (!initialOffset.dx.isFinite || !initialOffset.dy.isFinite) {
      throw ArgumentError('位移须有限');
    }
    if (initialSize != null) _validateSize(initialSize);
  }
  Size? _size;
  Size? get size => _size;
  static void _validateSize(Size size) {
    if (!size.width.isFinite || !size.height.isFinite || size.isEmpty) {
      throw ArgumentError('尺寸须有限且大于零');
    }
  }

  void resizeTo(Size size, {Offset? offset}) {
    _validateSize(size);
    final nextOffset = offset ?? _offset;
    if (!nextOffset.dx.isFinite || !nextOffset.dy.isFinite) {
      throw ArgumentError('位移须有限');
    }
    if (_size == size && _offset == nextOffset) return;
    _size = size;
    _offset = nextOffset;
    notifyListeners();
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
    this.closeButtonBuilder,
    this.maximizeButtonBuilder,
    this.onClose,
    this.scrollable = true,
    this.onPositionChanged,
    this.resizable = true,
    this.resizeConstraints = const BoxConstraints(),
    this.onSizeChanged,
    this.style,
    this.semanticLabel = '可移动对话框',
  });
  final Widget title, content;
  final List<Widget> actions;
  final HyperMovableDialogController? controller;
  final bool enabled, showCloseButton, scrollable;
  final bool showMaximizeButton;
  final Widget Function(BuildContext context, VoidCallback close)?
  closeButtonBuilder;
  final Widget Function(
    BuildContext context,
    bool maximized,
    VoidCallback? toggle,
  )?
  maximizeButtonBuilder;
  final VoidCallback? onClose;
  final ValueChanged<Offset>? onPositionChanged;
  final bool resizable;
  final BoxConstraints resizeConstraints;
  final ValueChanged<Size>? onSizeChanged;
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
  final _maximizeControlKey = GlobalKey(), _closeControlKey = GlobalKey();
  final _actionKeys = <GlobalKey>[];
  final _titleFocus = FocusNode();
  BoxConstraints? _lastConstraints;
  Rect? _resizeStartRect;
  Offset? _resizeStartPointer;
  Offset _resizeStartOffset = Offset.zero;
  Size _resizeMinimum = Size.zero;
  Size _resizeMaximum = Size.infinite;
  Alignment _resizeAlignment = Alignment.center;
  Size? _reportedSize;
  HyperMovableDialogController get controller => widget.controller ?? _owned;
  @override
  void initState() {
    super.initState();
    controller.addListener(changed);
    _lastMaximized = controller.maximized;
    _geometry.addStatusListener((status) {
      if (mounted && status == AnimationStatus.completed) {
        _material.forward(from: 0);
      }
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
    if (controller.size != null && controller.size != _reportedSize) {
      _reportedSize = controller.size;
      widget.onSizeChanged?.call(controller.size!);
    }
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
    final available = _availableRect!;
    double clamp(double change, double lower, double upper) =>
        lower > upper ? lower : change.clamp(lower, upper).toDouble();
    final actual = Offset(
      clamp(delta.dx, available.left - rect.left, available.right - rect.right),
      clamp(delta.dy, available.top - rect.top, available.bottom - rect.bottom),
    );
    controller.moveTo(controller.offset + actual);
  }

  Rect? get _availableRect {
    final bounds = _bounds.currentContext?.findRenderObject();
    if (bounds is! RenderBox || !bounds.hasSize) return null;
    final origin = bounds.localToGlobal(Offset.zero);
    final insets = MediaQuery.viewInsetsOf(context);
    return Rect.fromLTWH(
      origin.dx + insets.left,
      origin.dy + insets.top,
      math.max(0, bounds.size.width - insets.horizontal),
      math.max(0, bounds.size.height - insets.vertical),
    );
  }

  void _startResize(DragStartDetails details) {
    final surface = _surface.currentContext?.findRenderObject();
    final content = _contentKey.currentContext?.findRenderObject();
    if (surface is! RenderBox || !surface.hasSize) return;
    final style = HyperDialogTheme.of(context).style.merge(
      HyperMovableDialogTheme.of(context).style.merge(widget.style).dialogStyle,
    );
    final sizes = HyperTheme.sizesOf(context);
    final padding = (style.padding ?? sizes.dialog.padding).resolve(
      Directionality.of(context),
    );
    final insets = (style.insetPadding ?? sizes.dialog.insetPadding).resolve(
      Directionality.of(context),
    );
    final available = _availableRect;
    if (available == null || available.isEmpty) return;
    _resizeStartRect = surface.localToGlobal(Offset.zero) & surface.size;
    _resizeStartPointer = details.globalPosition;
    _resizeStartOffset = controller.offset;
    _resizeAlignment = (style.alignment ?? Alignment.center).resolve(
      Directionality.of(context),
    );
    // Keep the measured header/actions and a usable content row. Width leaves
    // room for the title and the actual number of window controls.
    Rect? actionsRect;
    for (final key in _actionKeys) {
      final action = key.currentContext?.findRenderObject();
      if (action is RenderBox && action.hasSize) {
        final rect = action.localToGlobal(Offset.zero) & action.size;
        actionsRect = actionsRect?.expandToInclude(rect) ?? rect;
      }
    }
    // Exclude unused space in a manually enlarged dialog. Subtracting content
    // height from surface height would mistake that space for fixed chrome
    // and prevent the next drag from shrinking the dialog again.
    final chromeHeight = content is RenderBox && content.hasSize
        ? content.localToGlobal(Offset.zero).dy -
              surface.localToGlobal(Offset.zero).dy +
              padding.bottom +
              (actionsRect == null
                  ? 0
                  : actionsRect.height +
                        (style.titleSpacing ?? sizes.dialog.titleSpacing))
        : padding.vertical;
    double controlWidth(GlobalKey key) {
      final box = key.currentContext?.findRenderObject();
      return box is RenderBox && box.hasSize
          ? box.size.width
          : sizes.minimumInteractiveDimension;
    }

    final controlsWidth =
        (widget.showCloseButton ? controlWidth(_closeControlKey) : 0) +
        (widget.showMaximizeButton ? controlWidth(_maximizeControlKey) : 0);
    final title = _titleFocus.context?.findRenderObject();
    double naturalWidth(RenderBox box) {
      // Custom title/action widgets may not implement intrinsic measurement.
      // Their currently laid-out width remains a valid conservative bound.
      try {
        final width = box.getMaxIntrinsicWidth(double.infinity);
        if (width.isFinite) return width;
      } on FlutterError {
        return box.size.width;
      }
      return box.size.width;
    }

    final titleWidth = title is RenderBox && title.hasSize
        ? naturalWidth(title)
        : sizes.minimumInteractiveDimension;
    var actionWidth = 0.0;
    for (final key in _actionKeys) {
      final action = key.currentContext?.findRenderObject();
      if (action is RenderBox && action.hasSize) {
        actionWidth += naturalWidth(action);
      }
    }
    if (widget.actions.length > 1) {
      actionWidth +=
          (style.actionSpacing ?? sizes.dialog.actionSpacing) *
          (widget.actions.length - 1);
    }
    final minimumWidth =
        padding.horizontal + math.max(titleWidth + controlsWidth, actionWidth);
    _resizeMaximum = Size(
      math.max(
        0,
        math.min(
          widget.resizeConstraints.maxWidth,
          available.width - insets.horizontal,
        ),
      ),
      math.max(
        0,
        math.min(
          widget.resizeConstraints.maxHeight,
          available.height - insets.vertical,
        ),
      ),
    );
    _resizeMinimum = Size(
      math.min(
        _resizeMaximum.width,
        math.max(widget.resizeConstraints.minWidth, minimumWidth),
      ),
      math.min(
        _resizeMaximum.height,
        math.max(
          widget.resizeConstraints.minHeight,
          chromeHeight + sizes.minimumInteractiveDimension,
        ),
      ),
    );
  }

  void _resize(DragUpdateDetails details, Alignment edge) {
    if (!widget.enabled ||
        !widget.resizable ||
        controller.maximized ||
        _geometry.isAnimating) {
      return;
    }
    final start = _resizeStartRect,
        pointer = _resizeStartPointer,
        available = _availableRect;
    if (start == null || pointer == null || available == null) return;
    double coordinate(
      double value,
      double lower,
      double upper,
      double current,
    ) => lower > upper ? current : value.clamp(lower, upper);
    final delta = details.globalPosition - pointer;
    var left = start.left,
        right = start.right,
        top = start.top,
        bottom = start.bottom;
    if (edge.x < 0) {
      left = coordinate(
        start.left + delta.dx,
        math.max(available.left, right - _resizeMaximum.width),
        right - _resizeMinimum.width,
        start.left,
      );
    } else if (edge.x > 0) {
      right = coordinate(
        start.right + delta.dx,
        left + _resizeMinimum.width,
        math.min(available.right, left + _resizeMaximum.width),
        start.right,
      );
    }
    if (edge.y < 0) {
      top = coordinate(
        start.top + delta.dy,
        math.max(available.top, bottom - _resizeMaximum.height),
        bottom - _resizeMinimum.height,
        start.top,
      );
    } else if (edge.y > 0) {
      bottom = coordinate(
        start.bottom + delta.dy,
        top + _resizeMinimum.height,
        math.min(available.bottom, top + _resizeMaximum.height),
        start.bottom,
      );
    }
    final next = Rect.fromLTRB(left, top, right, bottom);
    if (next.isEmpty) return;
    controller.resizeTo(
      next.size,
      offset:
          _resizeStartOffset +
          next.topLeft -
          start.topLeft +
          Offset(
            (next.width - start.width) * (_resizeAlignment.x + 1) / 2,
            (next.height - start.height) * (_resizeAlignment.y + 1) / 2,
          ),
    );
  }

  Widget _resizeHandles(Widget surface) {
    final canResize =
        widget.enabled &&
        widget.resizable &&
        !controller.maximized &&
        !_geometry.isAnimating;
    // Same semantic hit extent as the shared resizable pane handles.
    final measured = _surface.currentContext?.findRenderObject();
    final maxExtent = measured is RenderBox && measured.hasSize
        ? measured.size.shortestSide / 2
        : double.infinity;
    final extent =
        (HyperResizableTheme.of(context).style.handleExtent ??
                HyperTheme.sizesOf(context).form.gap)
            .clamp(0, maxExtent)
            .toDouble();
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      children: [
        KeyedSubtree(key: _surface, child: surface),
        if (canResize && extent > 0)
          for (final edge in const [
            Alignment.topLeft,
            Alignment.topCenter,
            Alignment.topRight,
            Alignment.centerLeft,
            Alignment.centerRight,
            Alignment.bottomLeft,
            Alignment.bottomCenter,
            Alignment.bottomRight,
          ])
            Positioned(
              left: edge.x < 0
                  ? 0
                  : edge.x == 0
                  ? extent
                  : null,
              right: edge.x > 0
                  ? 0
                  : edge.x == 0
                  ? extent
                  : null,
              top: edge.y < 0
                  ? 0
                  : edge.y == 0
                  ? extent
                  : null,
              bottom: edge.y > 0
                  ? 0
                  : edge.y == 0
                  ? extent
                  : null,
              width: edge.x == 0 ? null : extent,
              height: edge.y == 0 ? null : extent,
              child: MouseRegion(
                cursor: edge.x == 0
                    ? SystemMouseCursors.resizeUpDown
                    : edge.y == 0
                    ? SystemMouseCursors.resizeLeftRight
                    : edge.x == edge.y
                    ? SystemMouseCursors.resizeUpLeftDownRight
                    : SystemMouseCursors.resizeUpRightDownLeft,
                child: GestureDetector(
                  key: ValueKey(
                    'hyper-movable-dialog-resize-${edge.x.toInt()}-${edge.y.toInt()}',
                  ),
                  behavior: HitTestBehavior.opaque,
                  dragStartBehavior: DragStartBehavior.down,
                  onPanStart: _startResize,
                  onPanUpdate: (details) => _resize(details, edge),
                  child: const SizedBox.expand(),
                ),
              ),
            ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    while (_actionKeys.length < widget.actions.length) {
      _actionKeys.add(GlobalKey());
    }
    if (_actionKeys.length > widget.actions.length) {
      _actionKeys.removeRange(widget.actions.length, _actionKeys.length);
    }
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
                .clamp(
                  0,
                  math.max(0, constraints.maxWidth - normalInsets.horizontal),
                )
                .toDouble();
        final normalAlignment = (baseStyle.alignment ?? Alignment.center)
            .resolve(Directionality.of(context));
        final manualInsetOffset = controller.size == null
            ? Offset.zero
            : Offset(
                normalInsets.left -
                    normalInsets.horizontal * (normalAlignment.x + 1) / 2,
                normalInsets.top -
                    normalInsets.vertical * (normalAlignment.y + 1) / 2,
              );
        final normalSize =
            controller.size ??
            _normalSize ??
            Size(normalWidth, _fromSize?.height ?? constraints.maxHeight);
        final target = controller.maximized
            ? Size(
                constraints.maxWidth,
                (constraints.maxHeight -
                        MediaQuery.viewInsetsOf(context).vertical)
                    .clamp(0, double.infinity),
              )
            : Size(
                normalSize.width.clamp(
                  0,
                  math.max(0, constraints.maxWidth - normalInsets.horizontal),
                ),
                normalSize.height.clamp(
                  0,
                  math.max(
                    0,
                    constraints.maxHeight -
                        normalInsets.vertical -
                        MediaQuery.viewInsetsOf(context).vertical,
                  ),
                ),
              );
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
            style: controller.maximized || animating || controller.size != null
                ? (style.dialogStyle ?? const HyperDialogStyle()).copyWith(
                    width: animatedSize.width,
                    maxWidth: animatedSize.width,
                    insetPadding: EdgeInsets.zero,
                    alignment: controller.maximized || animating
                        ? Alignment.center
                        : baseStyle.alignment,
                  )
                : style.dialogStyle,
            showCloseButton:
                widget.showCloseButton && widget.closeButtonBuilder == null,
            onClose: widget.onClose,
            scrollable: widget.scrollable,
            content: KeyedSubtree(key: _contentKey, child: widget.content),
            actions: [
              for (var index = 0; index < widget.actions.length; index++)
                KeyedSubtree(
                  key: _actionKeys[index],
                  child: widget.actions[index],
                ),
            ],
            titleActions: [
              if (widget.showMaximizeButton)
                KeyedSubtree(
                  key: _maximizeControlKey,
                  child:
                      widget.maximizeButtonBuilder?.call(
                        context,
                        controller.maximized,
                        widget.enabled ? controller.toggleMaximized : null,
                      ) ??
                      HyperIconButton.ghost(
                        tooltip: controller.maximized ? '还原' : '最大化',
                        icon: Icon(
                          controller.maximized
                              ? HyperIcons.copy
                              : HyperIcons.square,
                        ),
                        onPressed: widget.enabled
                            ? controller.toggleMaximized
                            : null,
                      ),
                ),
              if (widget.showCloseButton && widget.closeButtonBuilder != null)
                KeyedSubtree(
                  key: _closeControlKey,
                  child: widget.closeButtonBuilder!(
                    context,
                    widget.onClose ?? () => HyperOverlay.close(context),
                  ),
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
                    dragStartBehavior: DragStartBehavior.down,
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
                  : controller.offset + manualInsetOffset,
              child: SizedBox(
                height:
                    controller.maximized || animating || controller.size != null
                    ? animatedSize.height
                    : null,
                child: _resizeHandles(surface),
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
