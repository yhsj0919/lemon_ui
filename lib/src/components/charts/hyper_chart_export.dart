// Adapted from local lemon_shadcn chart implementations.
import 'hyper_chart_tokens.dart';
import 'hyper_chart_capture_scope.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Controls an [HyperChartExportBoundary].
///
/// The controller deliberately returns bytes instead of writing a file so the
/// package remains platform independent. Applications can download, share, or
/// upload the PNG using their existing platform service.
class HyperChartExportController {
  _HyperChartExportBoundaryState? _state;

  bool get attached => _state != null;

  /// Captures the full boundary after a fresh frame, excluding tooltips unless
  /// [includeTooltip] is true. Concurrent captures are serialized.
  Future<ui.Image> captureImage({
    double pixelRatio = 2,
    bool includeTooltip = false,
  }) {
    if (!pixelRatio.isFinite || pixelRatio <= 0) {
      throw ArgumentError.value(
        pixelRatio,
        'pixelRatio',
        'Must be finite and positive.',
      );
    }
    final state = _state;
    if (state == null) {
      throw StateError(
        'HyperChartExportController is not attached to an '
        'HyperChartExportBoundary.',
      );
    }
    return state.captureImage(
      pixelRatio: pixelRatio,
      includeTooltip: includeTooltip,
    );
  }

  Future<Uint8List> capturePng({
    double pixelRatio = 2,
    bool includeTooltip = false,
  }) async {
    final image = await captureImage(
      pixelRatio: pixelRatio,
      includeTooltip: includeTooltip,
    );
    try {
      final data = await image.toByteData(format: ui.ImageByteFormat.png);
      if (data == null) {
        throw StateError('Unable to encode the chart as PNG.');
      }
      return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    } finally {
      image.dispose();
    }
  }
}

/// A platform-neutral export boundary shared by every Hyper chart.
class HyperChartExportBoundary extends StatefulWidget {
  const HyperChartExportBoundary({
    super.key,
    required this.controller,
    required this.child,
    this.backgroundColor,
    this.padding = EdgeInsets.zero,
  });

  final HyperChartExportController controller;
  final Widget child;

  /// Defaults to the active theme background color. Set transparent to export
  /// only the chart pixels.
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  @override
  State<HyperChartExportBoundary> createState() =>
      _HyperChartExportBoundaryState();
}

class _HyperChartExportBoundaryState extends State<HyperChartExportBoundary> {
  final GlobalKey _boundaryKey = GlobalKey();
  bool _hideTooltip = false;
  Future<void> _captureTail = Future.value();

  @override
  void initState() {
    super.initState();
    _attach(widget.controller);
  }

  @override
  void didUpdateWidget(covariant HyperChartExportBoundary oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      _detach(oldWidget.controller);
      _attach(widget.controller);
    }
  }

  @override
  void dispose() {
    _detach(widget.controller);
    super.dispose();
  }

  void _attach(HyperChartExportController controller) {
    final owner = controller._state;
    if (owner != null && owner != this) {
      throw FlutterError(
        'An HyperChartExportController cannot be attached to multiple '
        'HyperChartExportBoundary widgets.',
      );
    }
    controller._state = this;
  }

  void _detach(HyperChartExportController controller) {
    if (controller._state == this) controller._state = null;
  }

  Future<ui.Image> captureImage({
    required double pixelRatio,
    required bool includeTooltip,
  }) {
    final result = _captureTail.then(
      (_) => _capture(pixelRatio, includeTooltip),
    );
    _captureTail = result.then<void>(
      (_) {},
      onError: (Object _, StackTrace _) {},
    );
    return result;
  }

  Future<ui.Image> _capture(double pixelRatio, bool includeTooltip) async {
    if (!mounted) throw StateError('The chart export boundary was removed.');
    setState(() => _hideTooltip = !includeTooltip);
    final current = _boundaryKey.currentContext?.findRenderObject();
    if (current is RenderRepaintBoundary) current.markNeedsPaint();
    try {
      // Always finish a new frame. A pending descendant rebuild need not mark
      // this repaint boundary dirty yet; capturing its old layer is stale.
      WidgetsBinding.instance.scheduleFrame();
      await WidgetsBinding.instance.endOfFrame;
      final boundary =
          _boundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
      if (!mounted ||
          boundary == null ||
          !boundary.hasSize ||
          boundary.size.isEmpty ||
          boundary.debugNeedsPaint) {
        throw StateError('The chart export boundary is not ready to capture.');
      }
      return await boundary.toImage(pixelRatio: pixelRatio);
    } finally {
      if (mounted) setState(() => _hideTooltip = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    return HyperChartCaptureScope(
      hideTooltip: _hideTooltip,
      child: RepaintBoundary(
        key: _boundaryKey,
        child: ColoredBox(
          color: widget.backgroundColor ?? theme.colors.background,
          child: Padding(padding: widget.padding, child: widget.child),
        ),
      ),
    );
  }
}
