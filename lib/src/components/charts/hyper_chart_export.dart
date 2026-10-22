// Adapted from local lemon_shadcn chart implementations.
import 'hyper_chart_tokens.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// Controls an [HyperChartExportBoundary].
///
/// The controller deliberately returns bytes instead of writing a file so the
/// package remains platform independent. Hyperlications can download, share, or
/// upload the PNG using their existing platform service.
class HyperChartExportController {
  _HyperChartExportBoundaryState? _state;

  bool get attached => _state != null;

  Future<ui.Image> captureImage({double pixelRatio = 2}) {
    assert(pixelRatio > 0);
    final state = _state;
    if (state == null) {
      throw StateError(
        'HyperChartExportController is not attached to an '
        'HyperChartExportBoundary.',
      );
    }
    return state.captureImage(pixelRatio: pixelRatio);
  }

  Future<Uint8List> capturePng({double pixelRatio = 2}) async {
    final image = await captureImage(pixelRatio: pixelRatio);
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

  /// Defaults to the active shadcn background color. Set transparent to export
  /// only the chart pixels.
  final Color? backgroundColor;
  final EdgeInsetsGeometry padding;

  @override
  State<HyperChartExportBoundary> createState() =>
      _HyperChartExportBoundaryState();
}

class _HyperChartExportBoundaryState extends State<HyperChartExportBoundary> {
  final GlobalKey _boundaryKey = GlobalKey();

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

  Future<ui.Image> captureImage({required double pixelRatio}) async {
    final context = _boundaryKey.currentContext;
    var boundary = context?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) {
      throw StateError('The chart export boundary is not ready to capture.');
    }
    if (boundary.debugNeedsPaint) {
      WidgetsBinding.instance.scheduleFrame();
      await WidgetsBinding.instance.endOfFrame;
      boundary =
          _boundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;
    }
    if (boundary == null || boundary.debugNeedsPaint) {
      throw StateError('The chart export boundary is not ready to capture.');
    }
    return boundary.toImage(pixelRatio: pixelRatio);
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    return RepaintBoundary(
      key: _boundaryKey,
      child: ColoredBox(
        color: widget.backgroundColor ?? theme.colors.background,
        child: Padding(padding: widget.padding, child: widget.child),
      ),
    );
  }
}
