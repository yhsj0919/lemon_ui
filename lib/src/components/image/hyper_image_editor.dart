import '../icon_button/hyper_icon_button_style.dart';

import 'dart:async';

import '../select/hyper_select.dart';
import 'hyper_image_workspace_layout.dart';

import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:lemon_extended_image/extended_image.dart';

import '../../foundation/hyper_fill.dart';
import '../../foundation/hyper_icons.dart';
import '../../theme/core/hyper_theme.dart';
import '../button/hyper_button.dart';
import '../card/hyper_card_style.dart';
import '../dialog/hyper_dialog.dart';
import '../dialog/hyper_dialog_style.dart';
import '../icon/hyper_icon.dart';
import '../icon_button/hyper_icon_button.dart';
import '../surface/hyper_navigation_surface.dart';
import 'hyper_image.dart';
import 'hyper_image_editor_style.dart';
import 'hyper_image_editor_theme.dart';
import 'hyper_image_export.dart';

/// A static PNG snapshot with physical pixel dimensions.
@immutable
class HyperImageEditResult {
  HyperImageEditResult({
    required Uint8List bytes,
    required this.width,
    required this.height,
  }) : bytes = bytes.asUnmodifiableView();
  final Uint8List bytes;
  final int width, height;
  String get mimeType => 'image/png';
}

/// Controls an attached editor without exposing backend controller types.
class HyperImageEditorController extends ChangeNotifier {
  _HyperImageEditorState? _binding;
  bool get ready =>
      (_binding?._ready ?? false) && !(_binding?._transforming ?? false);
  bool get exporting => _binding?._exporting ?? false;
  bool get canUndo => _binding?._backend.canUndo ?? false;
  bool get canRedo => _binding?._backend.canRedo ?? false;
  double? get cropAspectRatio => _binding?._backend.cropAspectRatio;
  void rotateClockwise() => _binding?._rotate(90);
  void rotateCounterclockwise() => _binding?._rotate(-90);
  void flipHorizontal() => _binding?._flip(false);
  void flipVertical() => _binding?._flip(true);
  void undo() => _binding?._edit(() => _binding!._backend.undo());
  void redo() => _binding?._edit(() => _binding!._backend.redo());
  void reset() => _binding?._edit(() => _binding!._backend.reset());
  void setCropAspectRatio(double? ratio) {
    if (ratio != null && (!ratio.isFinite || ratio <= 0)) {
      throw ArgumentError.value(ratio, 'ratio');
    }
    _binding?._edit(() => _binding!._backend.updateCropAspectRatio(ratio));
  }

  Future<HyperImageEditResult> exportPng() {
    final binding = _binding;
    if (binding == null) throw StateError('No editor attached');
    return binding._export();
  }

  void _notify() => notifyListeners();
  void _attach(_HyperImageEditorState state) {
    if (_binding != null && _binding != state) {
      throw StateError('An editor controller can attach to only one editor.');
    }
    _binding = state;
  }

  void _detach(_HyperImageEditorState state) {
    if (_binding == state) _binding = null;
  }
}

/// An interactive crop editor for encoded image bytes.
///
/// Requires bounded height. Rotation uses quarter turns; flip, crop ratio,
/// undo and redo preserve backend editing history. Export returns a static PNG
/// of the current decoded frame, including orientation applied by the decoder.
class HyperImageEditor extends StatefulWidget {
  const HyperImageEditor({
    super.key,
    required this.bytes,
    this.controller,
    this.cropAspectRatio,
    this.maxScale = 5,
    this.style,
    this.onExport,
    this.onExportError,
    this.onCancel,
    this.showExportButton = true,
    this.constrainCropRect = true,
  }) : assert(maxScale > 1),
       assert(cropAspectRatio == null || cropAspectRatio > 0);
  final Uint8List bytes;
  final HyperImageEditorController? controller;
  final double? cropAspectRatio;
  final double maxScale;
  final HyperImageEditorStyle? style;
  final ValueChanged<HyperImageEditResult>? onExport;
  final void Function(Object error, StackTrace stack)? onExportError;
  final VoidCallback? onCancel;
  final bool showExportButton;

  /// Whether crop handles stop at the transformed image bounds.
  ///
  /// Viewport-edge drags still use native automatic fitting to reveal the image.
  final bool constrainCropRect;
  @override
  State<HyperImageEditor> createState() => _HyperImageEditorState();
}

class _HyperImageEditorState extends State<HyperImageEditor> {
  late HyperImageEditorController _controller;
  late ImageEditorController _backend;
  late ExtendedMemoryImageProvider _provider;
  ui.Image? _decoded;
  bool _ready = false, _exporting = false, _notificationPending = false;
  bool _transforming = false;
  Timer? _transformTimer;
  Object? _error;
  int _generation = 0;
  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? HyperImageEditorController();
    _controller._attach(this);
    _backend = ImageEditorController()..addListener(_notify);
    _provider = ExtendedMemoryImageProvider(widget.bytes);
  }

  void _notify() {
    if (_notificationPending) return;
    _notificationPending = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _notificationPending = false;
      if (mounted) {
        setState(() {});
        _controller._notify();
      }
    });
  }

  @override
  void didUpdateWidget(HyperImageEditor old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      _controller._detach(this);
      if (old.controller == null) _controller.dispose();
      _controller = widget.controller ?? HyperImageEditorController();
      _controller._attach(this);
    }
    if (old.bytes != widget.bytes) {
      _generation++;
      _transformTimer?.cancel();
      _transforming = false;
      _ready = false;
      _decoded = null;
      _error = null;
      _provider = ExtendedMemoryImageProvider(widget.bytes);
      _backend.removeListener(_notify);
      _backend.dispose();
      _backend = ImageEditorController()..addListener(_notify);
      _notify();
    }
    if (old.cropAspectRatio != widget.cropAspectRatio) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _controller.setCropAspectRatio(widget.cropAspectRatio);
      });
    }
  }

  @override
  void dispose() {
    _generation++;
    _transformTimer?.cancel();
    _controller._detach(this);
    if (widget.controller == null) _controller.dispose();
    _backend.removeListener(_notify);
    _backend.dispose();
    super.dispose();
  }

  void _edit(VoidCallback action) {
    if (!_ready || _exporting || _transforming) return;
    action();
    _error = null;
    _notify();
  }

  Duration get _duration =>
      (MediaQuery.maybeOf(context)?.disableAnimations ?? false)
      ? Duration.zero
      : resolveHyperImageEditorStyle(context, widget.style).animationDuration!;
  void _transform(void Function(bool animate, Duration duration) action) {
    _edit(() {
      final duration = _duration;
      action(duration > Duration.zero, duration);
      if (duration > Duration.zero) {
        _transforming = true;
        _transformTimer = Timer(duration, () {
          if (mounted) {
            _transforming = false;
            _notify();
          }
        });
      }
    });
  }

  void _rotate(double degree) => _transform(
    (animate, duration) =>
        _backend.rotate(degree: degree, animation: animate, duration: duration),
  );
  void _flip(bool vertical) => _transform((animate, duration) {
    _backend.flip(vertical: vertical, animation: animate, duration: duration);
  });
  Future<HyperImageEditResult> _export() async {
    if (!_ready || _decoded == null) throw StateError('Image is not ready');
    if (_exporting) throw StateError('An export is already running');
    if (_transforming) throw StateError('Wait for the transform to finish');
    final rect = _backend.getCropRect(), details = _backend.editActionDetails;
    if (rect == null || details == null) {
      throw StateError('Crop layout is not ready');
    }
    // Snapshot before yielding; source changes and disposal cannot invalidate it.
    final source = _decoded!.clone(), generation = _generation;
    final turns = (details.rotateDegrees / 90).round(), flip = details.flipY;
    setState(() {
      _exporting = true;
      _error = null;
    });
    _controller._notify();
    try {
      final result = await exportHyperImagePng(
        source,
        cropRect: rect,
        quarterTurns: turns,
        flipHorizontal: flip,
      );
      if (mounted && generation == _generation) widget.onExport?.call(result);
      return result;
    } catch (error, stack) {
      if (mounted && generation == _generation) {
        setState(() => _error = error);
        widget.onExportError?.call(error, stack);
      }
      rethrow;
    } finally {
      source.dispose();
      if (mounted) {
        setState(() => _exporting = false);
        _controller._notify();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final r = resolveHyperImageEditorStyle(context, widget.style);
    final reduced = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
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
    final enabled = _ready && !_exporting && !_transforming;
    return HyperNavigationSurface(
      style: r.surfaceStyle!,
      inheritMaterial: true,
      child: HyperImageWorkspaceLayout(
        children: [
          Expanded(
            child: IgnorePointer(
              ignoring: _exporting || _transforming,
              child: ExtendedImage(
                key: ValueKey(_provider),
                image: _provider,
                fit: BoxFit.contain,
                mode: ExtendedImageMode.editor,
                enableLoadState: true,
                initEditorConfigHandler: (state) => EditorConfig(
                  controller: _backend,
                  constrainCropRect: widget.constrainCropRect,
                  maxScale: widget.maxScale,
                  cropAspectRatio: widget.cropAspectRatio,
                  initialCropAspectRatio: widget.cropAspectRatio,
                  cropRectPadding: r.cropPadding!,
                  cornerSize: r.handleSize!,
                  cornerColor: r.cropColor,
                  lineColor: r.cropLineColor,
                  lineHeight: r.cropLineWidth!,
                  hitTestSize: r.handleHitSize!,
                  editorMaskColorHandler: (context, down) => r.maskColor!,
                  animationDuration: reduced
                      ? Duration.zero
                      : r.animationDuration!,
                  tickerDuration: reduced
                      ? Duration.zero
                      : r.animationDuration!,
                  editActionDetailsIsChanged: (_) => _notify(),
                ),
                loadStateChanged: (state) {
                  final ready =
                      state.extendedImageLoadState == LoadState.completed;
                  if (_ready != ready) {
                    _ready = ready;
                    _notify();
                  }
                  _decoded = ready ? state.extendedImageInfo?.image : null;
                  return buildHyperImageLoadState(
                    context,
                    state,
                    style: r.imageStyle,
                  );
                },
              ),
            ),
          ),
          if (_error != null)
            Padding(
              padding: r.padding!,
              child: Text(
                r.exportErrorText!,
                style: r.textStyle,
                semanticsLabel: r.exportErrorText,
              ),
            ),
          ColoredBox(
            color: r.toolbarBackground!,
            child: Padding(
              padding: r.padding!,
              child: Wrap(
                alignment: WrapAlignment.center,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: r.spacing!,
                runSpacing: r.spacing!,
                children: [
                  HyperSelect<double>(
                    value: _backend.cropAspectRatio ?? 0,
                    enabled: enabled,
                    placeholder: '裁剪比例',
                    options: [
                      const HyperSelectOption(value: 0, label: '自由裁剪'),
                      const HyperSelectOption(value: 1, label: '1:1'),
                      const HyperSelectOption(value: 4 / 3, label: '4:3'),
                      const HyperSelectOption(value: 16 / 9, label: '16:9'),
                      if (_backend.cropAspectRatio case final ratio?
                          when ratio != 1 && ratio != 4 / 3 && ratio != 16 / 9)
                        HyperSelectOption(value: ratio, label: '自定义比例'),
                    ],
                    onChanged: (ratio) => _controller.setCropAspectRatio(
                      ratio == 0 ? null : ratio,
                    ),
                  ),
                  tool(
                    '向左旋转',
                    HyperIcons.rotateCcw,
                    enabled ? _controller.rotateCounterclockwise : null,
                  ),
                  tool(
                    '向右旋转',
                    HyperIcons.rotateCw,
                    enabled ? _controller.rotateClockwise : null,
                  ),
                  tool(
                    '水平翻转',
                    HyperIcons.flipHorizontal,
                    enabled ? _controller.flipHorizontal : null,
                  ),
                  tool(
                    '垂直翻转',
                    HyperIcons.flipVertical,
                    enabled ? _controller.flipVertical : null,
                  ),
                  tool(
                    '撤销',
                    HyperIcons.undo2,
                    enabled && _backend.canUndo ? _controller.undo : null,
                  ),
                  tool(
                    '重做',
                    HyperIcons.redo2,
                    enabled && _backend.canRedo ? _controller.redo : null,
                  ),
                  tool(
                    '重置编辑',
                    HyperIcons.rotateCcw,
                    enabled ? _controller.reset : null,
                  ),
                  if (widget.onCancel != null)
                    tool(
                      '取消编辑',
                      HyperIcons.x,
                      _exporting ? null : widget.onCancel,
                    ),
                  if (widget.showExportButton)
                    HyperButton.filled(
                      onPressed: enabled
                          ? () async {
                              try {
                                await _export();
                              } catch (_) {
                                /* Rendered inline; also forwarded through onExportError. */
                              }
                            }
                          : null,
                      loading: _exporting,
                      label: Text(r.exportText!),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Resolves editing appearance using current-device image and interaction metrics.
HyperImageEditorStyle resolveHyperImageEditorStyle(
  BuildContext context, [
  HyperImageEditorStyle? style,
]) {
  final t = HyperTheme.of(context), m = HyperTheme.sizesOf(context).imageEditor;
  return HyperImageEditorStyle(
    surfaceStyle: HyperCardStyle(
      background: HyperFill.color(t.colors.surface),
      borderRadius: BorderRadius.zero,
      padding: EdgeInsets.zero,
    ),
    toolbarBackground: t.colors.surfaceMuted,
    foregroundColor: t.colors.textPrimary,
    textStyle: t.textTheme.bodySmall?.copyWith(color: t.colors.textPrimary),
    padding: EdgeInsets.all(m.padding),
    spacing: m.spacing,
    iconSize: m.iconSize,
    cropPadding: EdgeInsets.all(m.cropPadding ?? m.padding),
    handleSize: Size(m.handleLength, m.handleThickness),
    cropLineWidth: m.lineWidth,
    handleHitSize: m.handleHitSize,
    cropColor: t.colors.primary,
    cropLineColor: t.colors.outline,
    maskColor: t.colors.scrim,
    animationDuration: t.motion.standardDuration,
    exportText: '导出 PNG',
    exportErrorText: '图片导出失败，请重试。',
  ).merge(HyperImageEditorTheme.of(context).style).merge(style);
}

/// Opens an editor and returns PNG bytes on export, or null on cancellation.
Future<HyperImageEditResult?> showHyperImageEditor({
  required BuildContext context,
  required Uint8List bytes,
  HyperImageEditorController? controller,
  double? cropAspectRatio,
  bool constrainCropRect = true,
  HyperImageEditorStyle? style,
  HyperDialogStyle? dialogStyle,
  bool? useRootNavigator,
}) {
  final r = resolveHyperImageEditorStyle(context, style);
  return showHyperDialog<HyperImageEditResult>(
    context: context,
    useRootNavigator: useRootNavigator,
    style: (r.dialogStyle ?? const HyperDialogStyle()).merge(dialogStyle),
    builder: (context) => HyperDialog(
      title: const Text('图片编辑'),
      showCloseButton: false,
      scrollable: false,
      style: (r.dialogStyle ?? const HyperDialogStyle()).merge(dialogStyle),
      content: HyperImageEditor(
        bytes: bytes,
        controller: controller,
        cropAspectRatio: cropAspectRatio,
        constrainCropRect: constrainCropRect,
        style: style,
        onCancel: () => Navigator.of(context).pop(),
        onExport: (result) => Navigator.of(context).pop(result),
      ),
    ),
  );
}
