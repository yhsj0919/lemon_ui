import 'hyper_image_preview_gesture.dart';

import 'package:lemon_ui/src/vendor/extended_image/extended_image.dart';

import '../icon_button/hyper_icon_button_style.dart';
import 'hyper_image_workspace_layout.dart';

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/core/hyper_theme.dart';
import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_icons.dart';
import '../card/hyper_card_style.dart';
import '../dialog/hyper_dialog.dart';
import '../dialog/hyper_dialog_style.dart';
import '../icon/hyper_icon.dart';
import '../icon_button/hyper_icon_button.dart';
import '../surface/hyper_navigation_surface.dart';
import 'hyper_image.dart';
import 'hyper_image_preview_style.dart';
import 'hyper_image_preview_theme.dart';

/// A source and optional accessible description for a gallery page.
@immutable
class HyperImagePreviewItem {
  const HyperImagePreviewItem({
    required this.image,
    this.semanticLabel,
    this.heroTag,
  });
  final ImageProvider image;
  final String? semanticLabel;

  /// Matches [HyperImage.heroTag] on the thumbnail. Tags must be unique per route.
  final Object? heroTag;
}

/// Controls gallery navigation and the current page's zoom.
class HyperImagePreviewController extends ChangeNotifier {
  HyperImagePreviewController({int initialIndex = 0}) : _index = initialIndex {
    if (initialIndex < 0) {
      throw ArgumentError.value(initialIndex, 'initialIndex');
    }
  }
  int _index;
  int get index => _index;
  double get scale => _binding?._scale ?? 1;
  _HyperImagePreviewState? _binding;
  void jumpTo(int index) => _binding?._go(index);
  void next() => jumpTo(_index + 1);
  void previous() => jumpTo(_index - 1);
  void zoomIn() => _binding?._zoom(scale * 1.5);
  void zoomOut() => _binding?._zoom(scale / 1.5);
  void resetZoom() => _binding?._zoom(1);
  void _changed(int index) {
    _index = index;
    notifyListeners();
  }

  void _notify() => notifyListeners();
  void _attach(_HyperImagePreviewState state) {
    if (_binding != null && _binding != state) {
      throw StateError('A preview controller can attach to only one preview.');
    }
    _binding = state;
  }

  void _detach(_HyperImagePreviewState state) {
    if (_binding == state) _binding = null;
  }
}

/// A bounded image gallery with zoom, pan and keyboard navigation.
///
/// Supply a bounded height when embedding. Images reuse [HyperImage] loading,
/// retry and theme behavior. Dragging past a zoomed image edge hands off to
/// paging; leaving a page resets its image transform.
class HyperImagePreview extends StatefulWidget {
  HyperImagePreview({
    super.key,
    required List<HyperImagePreviewItem> items,
    this.controller,
    this.initialIndex = 0,
    this.onPageChanged,
    this.onClose,
    this.style,
    this.minScale = 1,
    this.maxScale = 5,
    this.autofocus = true,
    this.showSurface = true,
  }) : items = List.unmodifiable(items) {
    if (items.isEmpty) {
      throw ArgumentError.value(items, 'items', 'Must not be empty');
    }
    if (initialIndex < 0 || initialIndex >= items.length) {
      throw RangeError.index(initialIndex, items);
    }
    if (!minScale.isFinite ||
        minScale != 1 ||
        !maxScale.isFinite ||
        maxScale <= minScale) {
      throw ArgumentError(
        'minScale must be 1 and maxScale must be finite and greater than 1.',
      );
    }
  }
  final List<HyperImagePreviewItem> items;
  final HyperImagePreviewController? controller;
  final int initialIndex;
  final ValueChanged<int>? onPageChanged;
  final VoidCallback? onClose;
  final HyperImagePreviewStyle? style;
  final double minScale, maxScale;
  final bool autofocus;

  /// Whether the embedded workspace supplies its own surface.
  ///
  /// Dialog helpers let HyperDialog own the default backdrop. Explicit
  /// component surfaces remain independently configurable.
  final bool showSurface;
  @override
  State<HyperImagePreview> createState() => _HyperImagePreviewState();
}

class _HyperImagePreviewState extends State<HyperImagePreview>
    with SingleTickerProviderStateMixin {
  late HyperImagePreviewController _controller;
  late ExtendedPageController _pages;
  final _gestures = <GlobalKey<ExtendedImageGestureState>>[];
  final _scales = <double>[];
  final _loaded = <bool>[];
  final _toolbar = ValueNotifier<int>(0);
  late AnimationController _animation;
  double _zoomBegin = 1, _zoomEnd = 1;
  Offset? _zoomFocal;
  int _index = 0, _generation = 0;
  bool get _canZoom => _loaded[_index];
  double get _scale => _canZoom ? _scales[_index] : 1;
  bool get _reduced => MediaQuery.maybeOf(context)?.disableAnimations ?? false;
  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        HyperImagePreviewController(initialIndex: widget.initialIndex);
    _index = _controller.index.clamp(0, widget.items.length - 1);
    _controller._index = _index;
    _controller._attach(this);
    _pages = ExtendedPageController(initialPage: _index);
    _makePages();
    _animation = AnimationController(vsync: this)
      ..addListener(() {
        final r = _resolved();
        final value = r.animationCurve!.transform(_animation.value);
        _gestures[_index].currentState?.handleDoubleTap(
          scale: _zoomBegin + (_zoomEnd - _zoomBegin) * value,
          doubleTapPosition: _zoomFocal,
        );
      });
  }

  void _makePages() {
    _generation++;
    _gestures.clear();
    _scales.clear();
    _loaded.clear();
    for (var i = 0; i < widget.items.length; i++) {
      _gestures.add(GlobalKey<ExtendedImageGestureState>());
      _scales.add(1);
      _loaded.add(false);
    }
  }

  @override
  void didUpdateWidget(HyperImagePreview old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      _controller._detach(this);
      if (old.controller == null) _controller.dispose();
      _controller =
          widget.controller ??
          HyperImagePreviewController(initialIndex: _index);
      _controller._attach(this);
    }
    final changed =
        old.items.length != widget.items.length ||
        List.generate(
          widget.items.length,
          (i) =>
              i >= old.items.length ||
              old.items[i].image != widget.items[i].image,
        ).any((x) => x);
    if (changed) {
      _animation.stop();
      _makePages();
    }
    final next = _controller.index.clamp(0, widget.items.length - 1);
    if (changed || next != _index) {
      _index = next;
      _controller._index = next;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pages.hasClients) {
          _pages.jumpToPage(_index);
          _notifyToolbar();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller._detach(this);
    if (widget.controller == null) _controller.dispose();
    _animation.dispose();
    _pages.dispose();
    _toolbar.dispose();
    super.dispose();
  }

  HyperImagePreviewStyle _resolved() =>
      resolveHyperImagePreviewStyle(context, widget.style);
  void _notifyToolbar() {
    _toolbar.value++;
    _controller._notify();
  }

  void _go(int index) {
    if (index < 0 || index >= widget.items.length || index == _index) return;
    _animation.stop();
    final r = _resolved();
    if (_reduced || r.animationDuration == Duration.zero) {
      _pages.jumpToPage(index);
    } else {
      _pages.animateToPage(
        index,
        duration: r.animationDuration!,
        curve: r.animationCurve!,
      );
    }
  }

  void _zoom(double scale, {Offset? focal}) {
    if (!_canZoom) return;
    final gesture = _gestures[_index].currentState;
    if (gesture == null) return;
    _animation.stop();
    final target = scale.clamp(widget.minScale, widget.maxScale);
    final box = gesture.context.findRenderObject() as RenderBox?;
    final point =
        focal ??
        (box == null
            ? Offset.zero
            : box.localToGlobal(box.size.center(Offset.zero)));
    final r = _resolved();
    if (_reduced || r.animationDuration == Duration.zero) {
      gesture.handleDoubleTap(scale: target, doubleTapPosition: point);
    } else {
      _zoomBegin = _scale;
      _zoomEnd = target;
      _zoomFocal = point;
      _animation.duration = r.animationDuration;
      _animation.forward(from: 0);
    }
  }

  void _gestureChanged(int index, GestureDetails? details, int generation) {
    if (generation != _generation) return;
    final scale = details?.totalScale ?? 1;
    if (_scales[index] == scale) return;
    _scales[index] = scale;
    // Pan and boundary work remain inside extended_image. Only scale changes
    // update toolbar/controller listeners; the gallery is never rebuilt here.
    if (index == _index) _notifyToolbar();
  }

  void _activateCurrentGesture() {
    final image = _gestures[_index].currentState;
    final gallery = image?.context
        .findAncestorStateOfType<ExtendedImageGesturePageViewState>();
    if (gallery == null || image == null) return;
    // The backend stores gesture states in an insertion-ordered Set. Adding an
    // already registered visible image does not make it the last active item;
    // preloaded/off-screen states can otherwise decide whether paging wins.
    gallery.extendedImageGestureStates.remove(image);
    gallery.extendedImageGestureState = image;
  }

  void _resetInactivePages() {
    final generation = _generation;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted ||
          generation != _generation ||
          !_pages.hasClients ||
          _pages.position.isScrollingNotifier.value) {
        return;
      }
      for (var i = 0; i < _gestures.length; i++) {
        if (i == _index) continue;
        _scales[i] = 1;
        _gestures[i].currentState?.reset();
      }
    });
  }

  void _pageLoadChanged(int index, bool loaded, int generation) {
    if (generation != _generation || _loaded[index] == loaded) return;
    _loaded[index] = loaded;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || generation != _generation) return;
      if (!_loaded[index]) {
        if (index == _index) _animation.stop();
        _scales[index] = 1;
      }
      _notifyToolbar();
    });
  }

  Widget _buildPage(BuildContext context, int index, HyperImagePreviewStyle r) {
    final item = widget.items[index], generation = _generation;
    Widget page = RepaintBoundary(
      child: ExtendedImage(
        key: ValueKey((generation, index, item.image)),
        image: item.image,
        fit: BoxFit.contain,
        mode: ExtendedImageMode.none,
        enableLoadState: true,
        handleLoadingProgress: true,
        initGestureConfigHandler: (_) {
          return GestureConfig(
            inPageView: true,
            reverseMousePointerScrollDirection: true,
            cacheGesture: false,
            minScale: widget.minScale,
            maxScale: widget.maxScale,
            animationMinScale: widget.minScale,
            animationMaxScale: widget.maxScale,
            gestureDetailsIsChanged: (details) =>
                _gestureChanged(index, details, generation),
          );
        },
        onDoubleTap: (gesture) {
          _zoom(
            _scale > 1.001 ? 1 : math.min(2, widget.maxScale),
            focal: gesture.pointerDownPosition,
          );
        },
        loadStateChanged: (state) {
          final loaded = state.extendedImageLoadState == LoadState.completed;
          _pageLoadChanged(index, loaded, generation);
          return buildHyperImageLoadState(
            context,
            state,
            style: r.imageStyle,
            semanticLabel: item.semanticLabel,
            // The workspace/dialog owns the default backdrop; explicit image
            // material overrides still pass through the shared surface path.
            inheritMaterial: false,
            completed: loaded
                ? HyperImagePreviewGesture(state, key: _gestures[index])
                : null,
          );
        },
      ),
    );
    if (item.heroTag != null) {
      page = ValueListenableBuilder<int>(
        valueListenable: _toolbar,
        child: Hero(
          tag: item.heroTag!,
          flightShuttleBuilder: (context, animation, direction, from, to) =>
              Image(
                image: item.image,
                fit: BoxFit.contain,
                gaplessPlayback: true,
                errorBuilder: (context, error, stack) =>
                    const SizedBox.expand(),
              ),
          child: page,
        ),
        builder: (context, _, child) =>
            HeroMode(enabled: index == _index && !_reduced, child: child!),
      );
    }
    return page;
  }

  Widget _buildToolbar(HyperImagePreviewStyle r) {
    Widget tool(String label, IconData icon, VoidCallback? action) =>
        HyperIconButton.ghost(
          tooltip: label,
          onPressed: action,
          style: HyperIconButtonStyle(
            foregroundColor: r.foregroundColor,
            iconSize: r.iconSize,
          ).merge(r.buttonStyle),
          icon: HyperIcon(icon),
        );
    return ColoredBox(
      color: r.toolbarBackground!,
      child: Padding(
        padding: r.padding!,
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: r.spacing!,
          runSpacing: r.spacing!,
          children: [
            tool(
              '上一张',
              HyperIcons.chevronLeft,
              _index > 0 ? _controller.previous : null,
            ),
            Semantics(
              liveRegion: true,
              child: Text(
                '${_index + 1} / ${widget.items.length}',
                style: r.textStyle,
              ),
            ),
            tool(
              '下一张',
              HyperIcons.chevronRight,
              _index + 1 < widget.items.length ? _controller.next : null,
            ),
            tool(
              '缩小',
              HyperIcons.zoomOut,
              _canZoom && _scale > widget.minScale ? _controller.zoomOut : null,
            ),
            Text('${(_scale * 100).round()}%', style: r.textStyle),
            tool(
              '放大',
              HyperIcons.zoomIn,
              _canZoom && _scale < widget.maxScale ? _controller.zoomIn : null,
            ),
            tool(
              '重置缩放',
              HyperIcons.maximize,
              _canZoom ? _controller.resetZoom : null,
            ),
            if (widget.onClose != null)
              tool('关闭预览', HyperIcons.x, widget.onClose),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final r = _resolved();
    final workspace = HyperImageWorkspaceLayout(
      children: [
        Expanded(
          child: ClipRect(
            child: Listener(
              onPointerDown: (_) => _activateCurrentGesture(),
              onPointerPanZoomStart: (_) => _activateCurrentGesture(),
              onPointerSignal: (_) => _activateCurrentGesture(),
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (notification) {
                  if (notification.depth == 0) _resetInactivePages();
                  return false;
                },
                child: ExtendedImageGesturePageView.builder(
                  shouldAccpetHorizontalOrVerticalDrag: (pointers) =>
                      pointers.length == 1 && _scale <= 1.001,
                  controller: _pages,
                  allowImplicitScrolling: true,
                  itemCount: widget.items.length,
                  canScrollPage: (_) => true,
                  onPageChanged: (index) {
                    _animation.stop();
                    _index = index;
                    _controller._changed(index);
                    _toolbar.value++;
                    _resetInactivePages();
                    widget.onPageChanged?.call(index);
                  },
                  itemBuilder: (context, index) =>
                      _buildPage(context, index, r),
                ),
              ),
            ),
          ),
        ),
        ValueListenableBuilder<int>(
          valueListenable: _toolbar,
          builder: (context, _, _) => _buildToolbar(r),
        ),
      ],
    );
    return CallbackShortcuts(
      bindings: {
        const SingleActivator(LogicalKeyboardKey.arrowLeft):
            _controller.previous,
        const SingleActivator(LogicalKeyboardKey.arrowRight): _controller.next,
        const SingleActivator(LogicalKeyboardKey.equal): _controller.zoomIn,
        const SingleActivator(LogicalKeyboardKey.minus): _controller.zoomOut,
        const SingleActivator(LogicalKeyboardKey.digit0): _controller.resetZoom,
        if (widget.onClose != null)
          const SingleActivator(LogicalKeyboardKey.escape): widget.onClose!,
      },
      child: Focus(
        autofocus: widget.autofocus,
        child: widget.showSurface
            ? HyperNavigationSurface(
                style: r.surfaceStyle!,
                inheritMaterial: true,
                child: workspace,
              )
            : workspace,
      ),
    );
  }
}

/// Resolves preview appearance from same-device semantic metrics.
HyperImagePreviewStyle resolveHyperImagePreviewStyle(
  BuildContext context, [
  HyperImagePreviewStyle? style,
]) {
  final t = HyperTheme.of(context),
      m = HyperTheme.sizesOf(context).imagePreview;
  return HyperImagePreviewStyle(
    surfaceStyle: HyperCardStyle(
      background: HyperFill.color(t.colors.surface),
      padding: EdgeInsets.zero,
      borderRadius: BorderRadius.zero,
    ),
    toolbarBackground: t.colors.surfaceMuted,
    foregroundColor: t.colors.textPrimary,
    textStyle: t.textTheme.bodySmall?.copyWith(color: t.colors.textPrimary),
    spacing: m.spacing,
    padding: EdgeInsets.all(m.padding),
    iconSize: m.iconSize,
    animationDuration: t.motion.fastDuration,
    animationCurve: t.motion.standardCurve,
  ).merge(HyperImagePreviewTheme.of(context).style).merge(style);
}

/// Opens a gallery using the shared dialog surface and material transitions.
///
/// Matching thumbnail/item hero tags enable native Hero flights automatically.
/// Set [enableHero] to false to keep the regular dialog route. Both ends must
/// belong to the same Navigator; use [useRootNavigator] for nested navigation.
Future<void> showHyperImagePreview({
  required BuildContext context,
  required List<HyperImagePreviewItem> items,
  int initialIndex = 0,
  HyperImagePreviewController? controller,
  HyperImagePreviewStyle? style,
  HyperDialogStyle? dialogStyle,
  bool? useRootNavigator,
  bool enableHero = true,
}) {
  final r = resolveHyperImagePreviewStyle(context, style);
  final explicitSurface = HyperImagePreviewTheme.of(context).style
      .merge(style)
      .surfaceStyle;
  return showHyperDialog<void>(
    heroAnimation: enableHero && items.any((item) => item.heroTag != null),
    context: context,
    useRootNavigator: useRootNavigator,
    style: (r.dialogStyle ?? const HyperDialogStyle()).merge(dialogStyle),
    builder: (context) => HyperDialog(
      title: const Text('图片预览'),
      scrollable: false,
      showCloseButton: false,
      style: (r.dialogStyle ?? const HyperDialogStyle()).merge(dialogStyle),
      content: HyperImagePreview(
        items: items,
        initialIndex: initialIndex,
        showSurface: explicitSurface != null,
        controller: controller,
        style: style,
        onClose: () => Navigator.of(context).pop(),
      ),
    ),
  );
}
