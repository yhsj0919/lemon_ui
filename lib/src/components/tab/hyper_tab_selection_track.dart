import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import '../card/hyper_card_style.dart';
import '../surface/hyper_navigation_surface.dart';

class HyperTabSelectionMarker extends SingleChildRenderObjectWidget {
  const HyperTabSelectionMarker({super.key, required super.child});
  @override
  RenderObject createRenderObject(BuildContext context) => _RenderMarker();
}

class _RenderMarker extends RenderProxyBox {
  Rect bounds = Rect.zero;
  @override
  void performLayout() {
    super.performLayout();
    bounds = Rect.fromLTWH(0, 0, size.width, size.height);
  }
}

/// A single surface follows the controller between the actual laid-out tabs.
/// Keeping it as a widget preserves backdrop materials and their shadow policy.
class HyperTabSelectionTrack extends StatefulWidget {
  const HyperTabSelectionTrack({
    super.key,
    required this.controller,
    required this.count,
    required this.inset,
    required this.style,
    required this.builder,
  });

  final TabController controller;
  final int count;
  final EdgeInsets inset;
  final HyperCardStyle style;
  final Widget Function(List<GlobalKey>) builder;

  @override
  State<HyperTabSelectionTrack> createState() => _TrackState();
}

class _TrackState extends State<HyperTabSelectionTrack> {
  final List<GlobalKey> _keys = [];

  @override
  Widget build(BuildContext context) {
    while (_keys.length < widget.count) {
      _keys.add(GlobalKey());
    }
    if (_keys.length > widget.count) {
      _keys.removeRange(widget.count, _keys.length);
    }
    return _TrackLayout(
      controller: widget.controller,
      tabKeys: List.of(_keys),
      inset: widget.inset,
      reduceMotion: MediaQuery.maybeOf(context)?.disableAnimations ?? false,
      children: [
        widget.builder(_keys),
        ExcludeSemantics(
          child: IgnorePointer(
            child: HyperNavigationSurface(
              key: const ValueKey('hyper-tab-selection'),
              style: widget.style,
              child: const SizedBox.expand(),
            ),
          ),
        ),
      ],
    );
  }
}

class _TrackLayout extends MultiChildRenderObjectWidget {
  const _TrackLayout({
    required this.controller,
    required this.tabKeys,
    required this.inset,
    required this.reduceMotion,
    required super.children,
  });
  final TabController controller;
  final List<GlobalKey> tabKeys;
  final EdgeInsets inset;
  final bool reduceMotion;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderTrack(controller, tabKeys, inset, reduceMotion);

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderTrack renderObject,
  ) {
    renderObject.update(controller, tabKeys, inset, reduceMotion);
  }
}

class _TrackParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderTrack extends RenderBox
    with ContainerRenderObjectMixin<RenderBox, _TrackParentData> {
  _RenderTrack(this._controller, this._keys, this._inset, this._reduceMotion);
  TabController _controller;
  List<GlobalKey> _keys;
  EdgeInsets _inset;
  bool _reduceMotion;
  ScrollPosition? _scroll;
  Listenable get _animation => _controller.animation ?? _controller;

  void update(
    TabController controller,
    List<GlobalKey> keys,
    EdgeInsets inset,
    bool reduceMotion,
  ) {
    if (controller != _controller) {
      if (attached) _animation.removeListener(markNeedsLayout);
      _controller = controller;
      if (attached) _animation.addListener(markNeedsLayout);
    }
    _keys = keys;
    _inset = inset;
    _reduceMotion = reduceMotion;
    markNeedsLayout();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _TrackParentData) {
      child.parentData = _TrackParentData();
    }
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _animation.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _animation.removeListener(markNeedsLayout);
    _scroll?.removeListener(markNeedsLayout);
    _scroll = null;
    super.detach();
  }

  Rect _tabRect(int index) {
    final box =
        _keys[index].currentContext!.findRenderObject()! as _RenderMarker;
    return MatrixUtils.transformRect(box.getTransformTo(this), box.bounds);
  }

  @override
  void performLayout() {
    final bar = firstChild!;
    bar.layout(constraints, parentUsesSize: true);
    size = constraints.constrain(bar.size);
    (bar.parentData! as _TrackParentData).offset = Offset.zero;
    final selection = lastChild!;
    if (_keys.isEmpty) {
      selection.layout(BoxConstraints.tight(Size.zero));
      return;
    }
    final scroll = Scrollable.maybeOf(_keys.first.currentContext!)?.position;
    if (scroll != _scroll) {
      _scroll?.removeListener(markNeedsLayout);
      _scroll = scroll;
      _scroll?.addListener(markNeedsLayout);
    }
    final value =
        (_reduceMotion
                ? _controller.index.toDouble()
                : _controller.animation?.value ?? _controller.index.toDouble())
            .clamp(0.0, (_keys.length - 1).toDouble());
    final rect = Rect.lerp(
      _tabRect(value.floor()),
      _tabRect(value.ceil()),
      value % 1,
    )!;
    final inset = EdgeInsets.fromLTRB(
      _inset.left.clamp(0, rect.width / 2),
      _inset.top.clamp(0, rect.height / 2),
      _inset.right.clamp(0, rect.width / 2),
      _inset.bottom.clamp(0, rect.height / 2),
    );
    final target = inset.deflateRect(rect);
    selection.layout(BoxConstraints.tight(target.size));
    (selection.parentData! as _TrackParentData).offset = target.topLeft;
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      firstChild!.getDryLayout(constraints);

  @override
  double computeMinIntrinsicWidth(double height) =>
      firstChild!.getMinIntrinsicWidth(height);
  @override
  double computeMaxIntrinsicWidth(double height) =>
      firstChild!.getMaxIntrinsicWidth(height);
  @override
  double computeMinIntrinsicHeight(double width) =>
      firstChild!.getMinIntrinsicHeight(width);
  @override
  double computeMaxIntrinsicHeight(double width) =>
      firstChild!.getMaxIntrinsicHeight(width);

  @override
  void paint(PaintingContext context, Offset offset) {
    context.pushClipRect(needsCompositing, offset, Offset.zero & size, (
      context,
      offset,
    ) {
      final selection = lastChild!;
      context.paintChild(
        selection,
        offset + (selection.parentData! as _TrackParentData).offset,
      );
      context.paintChild(firstChild!, offset);
    });
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      firstChild!.hitTest(result, position: position);
}
