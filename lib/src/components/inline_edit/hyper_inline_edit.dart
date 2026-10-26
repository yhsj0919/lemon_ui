import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/core/hyper_theme.dart';
import '../../foundation/hyper_control_state.dart';
import '../../interaction/hyper_pressable.dart';
import '../button/hyper_button.dart';
import '../text/hyper_text.dart';
import '../text_field/hyper_text_field.dart';
import '../text_field/hyper_text_field_style.dart';
import 'hyper_inline_edit_style.dart';
import 'hyper_inline_edit_theme.dart';

enum HyperInlineEditActivation { doubleTap, tap }

enum HyperInlineEditInvalidBlurBehavior { cancel, keepEditing }

typedef HyperInlineEditSaver<T> = FutureOr<void> Function(T value);
typedef HyperInlineEditDialogBuilder<T> = Future<T?> Function(
  BuildContext context,
  T value,
);
typedef HyperInlineEditEditorBuilder<T> = Widget Function(
  BuildContext context,
  HyperInlineEditDetails<T> details,
);

/// An immutable snapshot of an editing session. Use immutable draft values.
@immutable
class HyperInlineEditDetails<T> {
  const HyperInlineEditDetails({
    required this.value,
    required this.onChanged,
    required this.submit,
    required this.cancel,
    required this.focusNode,
    required this.saving,
    required this.errorText,
    required this.style,
    required this.runOverlay,
  });
  final T value;
  final ValueChanged<T> onChanged;
  final Future<void> Function() submit;
  final VoidCallback cancel;
  final FocusNode focusNode;
  final bool saving;
  final String? errorText;
  final HyperInlineEditStyle style;

  /// Run picker/dialog interaction without committing on temporary focus loss.
  /// Await the operation and call onChanged/submit inside it as appropriate.
  final Future<void> Function(Future<void> Function() operation) runOverlay;
}

/// Controlled value with a private draft, validation and asynchronous saving.
/// External value changes invalidate the draft and any pending UI completion.
/// The saver must update the parent's value; cancellation cannot undo its I/O.
class HyperInlineEdit<T> extends StatefulWidget {
  const HyperInlineEdit({
    super.key,
    required this.value,
    required this.displayBuilder,
    this.editorBuilder,
    this.dialogBuilder,
    required this.onSaved,
    this.validator,
    this.valuesEqual,
    this.enabled = true,
    this.saveOnBlur = true,
    this.invalidBlurBehavior = HyperInlineEditInvalidBlurBehavior.keepEditing,
    this.activation = HyperInlineEditActivation.doubleTap,
    this.activateOnLongPress = true,
    this.submitOnEnter = false,
    this.commitOnChanged = false,
    this.showActions = true,
    this.onEditingChanged,
    this.onSaveError,
    this.saveErrorText = '保存失败，请重试',
    this.saveLabel = '保存',
    this.cancelLabel = '取消',
    this.semanticLabel = '编辑',
    this.style,
    this.transitionBuilder,
  }) : assert((editorBuilder == null) != (dialogBuilder == null));

  /// Edits outside the page. A null result cancels without calling the saver.
  const HyperInlineEdit.dialog({
    Key? key,
    required T value,
    required Widget Function(BuildContext context, T value) displayBuilder,
    required HyperInlineEditDialogBuilder<T> dialogBuilder,
    required HyperInlineEditSaver<T> onSaved,
    String? Function(T value)? validator,
    bool enabled = true,
    HyperInlineEditActivation activation = HyperInlineEditActivation.doubleTap,
    ValueChanged<bool>? onEditingChanged,
    void Function(Object error, StackTrace stack)? onSaveError,
    String saveErrorText = '保存失败，请重试',
    HyperInlineEditStyle? style,
  }) : this(
         key: key,
         value: value,
         displayBuilder: displayBuilder,
         dialogBuilder: dialogBuilder,
         onSaved: onSaved,
         validator: validator,
         enabled: enabled,
         activation: activation,
         onEditingChanged: onEditingChanged,
         onSaveError: onSaveError,
         saveErrorText: saveErrorText,
         style: style,
       );

  static HyperInlineEdit<String> text({
    Key? key,
    required String value,
    required HyperInlineEditSaver<String> onSaved,
    Widget Function(BuildContext context, String value)? displayBuilder,
    String? Function(String)? validator,
    bool enabled = true,
    bool multiline = false,
    String? hintText,
    bool saveOnBlur = true,
    bool showActions = true,
    HyperInlineEditActivation activation = HyperInlineEditActivation.doubleTap,
    HyperInlineEditStyle? style,
  }) => HyperInlineEdit<String>(
    key: key,
    value: value,
    onSaved: onSaved,
    validator: validator,
    enabled: enabled,
    saveOnBlur: saveOnBlur,
    showActions: showActions,
    activation: activation,
    style: style,
    submitOnEnter: !multiline,
    displayBuilder:
        displayBuilder ??
        (_, value) => HyperText(value.isEmpty ? (hintText ?? '未填写') : value),
    editorBuilder: (_, details) =>
        _TextEditor(details: details, multiline: multiline, hintText: hintText),
  );

  final T value;
  final Widget Function(BuildContext context, T value) displayBuilder;
  final HyperInlineEditEditorBuilder<T>? editorBuilder;
  final HyperInlineEditDialogBuilder<T>? dialogBuilder;
  final HyperInlineEditSaver<T> onSaved;
  final String? Function(T value)? validator;
  final bool Function(T left, T right)? valuesEqual;
  final bool enabled,
      saveOnBlur,
      activateOnLongPress,
      submitOnEnter,
      commitOnChanged,
      showActions;
  final HyperInlineEditActivation activation;
  final HyperInlineEditInvalidBlurBehavior invalidBlurBehavior;
  final ValueChanged<bool>? onEditingChanged;
  final void Function(Object error, StackTrace stack)? onSaveError;
  final String saveErrorText, saveLabel, cancelLabel, semanticLabel;
  final HyperInlineEditStyle? style;

  /// Replaces the default size transition. Do not fade advanced backdrop surfaces
  /// through ordinary opacity layers; preserve the editor subtree's identity.
  final Widget Function(
    BuildContext context,
    Widget child,
    Duration duration,
    Curve curve,
  )?
  transitionBuilder;
  @override
  State<HyperInlineEdit<T>> createState() => _HyperInlineEditState<T>();
}

class _HyperInlineEditState<T> extends State<HyperInlineEdit<T>> {
  final _editorFocus = FocusNode();
  final _displayFocus = FocusNode();
  final _groupFocus = FocusNode();
  final _defaultTransitionChildKey = GlobalKey();
  late T _draft;
  bool _editing = false, _saving = false;
  bool _dialogOpen = false;
  String? _error;
  int _session = 0, _overlayDepth = 0;
  bool equal(T a, T b) => widget.valuesEqual?.call(a, b) ?? a == b;

  @override
  void didUpdateWidget(covariant HyperInlineEdit<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!equal(widget.value, oldWidget.value) || !widget.enabled) {
      final wasEditing = _editing;
      _session++;
      _overlayDepth = 0;
      _editing = _saving = false;
      _error = null;
      if (wasEditing) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) widget.onEditingChanged?.call(false);
        });
      }
    }
  }

  void start() {
    if (!widget.enabled || _editing || _dialogOpen) return;
    setState(() {
      _draft = widget.value;
      _editing = true;
      _error = null;
      _session++;
      _overlayDepth = 0;
    });
    widget.onEditingChanged?.call(true);
    if (widget.dialogBuilder != null) {
      unawaited(openDialog());
      return;
    }
    final session = _session;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _editing && _session == session) {
        requestEditorFocus();
      }
    });
  }

  Future<void> openDialog() async {
    final session = _session;
    _dialogOpen = true;
    try {
      final value = await widget.dialogBuilder!(context, _draft);
      if (!mounted || _session != session) return;
      if (value == null) {
        finish();
        return;
      }
      _draft = value;
      await submit();
    } catch (error, stack) {
      if (!mounted || _session != session) return;
      setState(() => _error = widget.saveErrorText);
      widget.onSaveError?.call(error, stack);
    } finally {
      if (mounted) {
        setState(() => _dialogOpen = false);
      } else {
        _dialogOpen = false;
      }
      if (mounted && _session == session && _editing) {
        // Validation or saving failed: keep the trigger and its error visible.
        finish(clearError: false);
      }
    }
  }

  void finish({bool restoreFocus = true, bool clearError = true}) {
    _session++;
    _overlayDepth = 0;
    setState(() {
      _editing = _saving = false;
      if (clearError) _error = null;
    });
    if (restoreFocus) _displayFocus.requestFocus();
    widget.onEditingChanged?.call(false);
  }

  void cancel() {
    if (_editing && !_saving) finish();
  }

  Future<void> submit({bool fromBlur = false}) async {
    if (!_editing || _saving || !widget.enabled) return;
    final error = widget.validator?.call(_draft);
    if (error != null) {
      if (fromBlur &&
          widget.invalidBlurBehavior ==
              HyperInlineEditInvalidBlurBehavior.cancel) {
        finish(restoreFocus: false);
      } else {
        setState(() => _error = error);
        requestEditorFocus();
      }
      return;
    }
    if (equal(_draft, widget.value)) {
      finish(restoreFocus: !fromBlur);
      return;
    }
    final session = _session, value = _draft;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await widget.onSaved(value);
      if (mounted && _session == session) finish(restoreFocus: !fromBlur);
    } catch (error, stack) {
      if (!mounted || _session != session) return;
      setState(() {
        _saving = false;
        _error = widget.saveErrorText;
      });
      requestEditorFocus();
      widget.onSaveError?.call(error, stack);
    }
  }

  void change(T value) {
    if (!_editing || _saving) return;
    setState(() {
      _draft = value;
      _error = null;
    });
    if (widget.commitOnChanged) unawaited(submit());
  }

  void focusChanged(bool focused) {
    if (focused ||
        !_editing ||
        _saving ||
        _overlayDepth > 0 ||
        !widget.saveOnBlur) {
      return;
    }
    final session = _session;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted &&
          _editing &&
          _session == session &&
          !_groupFocus.hasFocus &&
          _overlayDepth == 0) {
        unawaited(submit(fromBlur: true));
      }
    });
  }

  Future<void> runOverlay(Future<void> Function() operation) async {
    if (!_editing || _saving) return;
    final session = _session;
    _overlayDepth++;
    try {
      await operation();
    } finally {
      if (_session == session) _overlayDepth--;
      if (mounted && _editing && _session == session) {
        requestEditorFocus();
      }
    }
  }

  void requestEditorFocus() {
    if (_editorFocus.context != null) {
      _editorFocus.requestFocus();
    } else {
      _groupFocus.requestFocus();
    }
  }

  @override
  void dispose() {
    _session++;
    _editorFocus.dispose();
    _displayFocus.dispose();
    _groupFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context), sizes = HyperTheme.sizesOf(context);
    final style = HyperInlineEditTheme.of(context).style.merge(widget.style);
    final duration = MediaQuery.disableAnimationsOf(context)
        ? Duration.zero
        : (style.transitionDuration ?? theme.motion.fastDuration);
    final curve = style.transitionCurve ?? theme.motion.fastCurve;
    Widget child;
    if (!_editing || widget.dialogBuilder != null) {
      child = Shortcuts(
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.f2): ActivateIntent(),
        },
        child: Actions(
          actions: {
            ActivateIntent: CallbackAction<ActivateIntent>(
              onInvoke: (_) {
                start();
                return null;
              },
            ),
          },
          child: HyperPressable(
            focusNode: _displayFocus,
            enabled: widget.enabled,
            mouseCursor: _saving || _dialogOpen
                ? SystemMouseCursors.progress
                : style.mouseCursor ?? SystemMouseCursors.click,
            semanticLabel: widget.semanticLabel,
            onTap: widget.activation == HyperInlineEditActivation.tap
                ? start
                : null,
            onDoubleTap:
                widget.activation == HyperInlineEditActivation.doubleTap
                ? start
                : null,
            onLongPress: widget.activateOnLongPress ? start : null,
            builder: (_, states, child) => ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    style.inputStyle?.minimumHeight ??
                    sizes.textField.minimumHeight,
              ),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                widthFactor: 1,
                child: AnimatedDefaultTextStyle(
                  duration: duration,
                  curve: curve,
                  style: DefaultTextStyle.of(context).style
                      .merge(
                        TextStyle(
                          color: !widget.enabled
                              ? theme.colors.disabled
                              : states.contains(HyperControlState.focused) ||
                                    states.contains(HyperControlState.hovered)
                              ? theme.colors.primary
                              : null,
                        ),
                      )
                      .merge(style.displayStyle),
                  child: child!,
                ),
              ),
            ),
            child: Builder(
              builder: (context) =>
                  widget.displayBuilder(context, widget.value),
            ),
          ),
        ),
      );
      child = Semantics(onTap: widget.enabled ? start : null, child: child);
      if (_error != null) {
        child = Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            child,
            Padding(
              padding: EdgeInsets.only(top: sizes.form.messageSpacing),
              child: Semantics(
                liveRegion: true,
                child: HyperText(
                  _error!,
                  style: TextStyle(color: theme.colors.error)
                      .merge(style.errorStyle),
                ),
              ),
            ),
          ],
        );
      }
    } else {
      final session = _session;
      final details = HyperInlineEditDetails<T>(
        value: _draft,
        onChanged: (value) {
          if (_session == session) change(value);
        },
        submit: () async {
          if (_session == session) await submit();
        },
        cancel: () {
          if (_session == session) cancel();
        },
        focusNode: _editorFocus,
        saving: _saving,
        errorText: _error,
        style: style,
        runOverlay: (operation) async {
          if (_session == session) await runOverlay(operation);
        },
      );
      child = Focus(
        focusNode: _groupFocus,
        onFocusChange: focusChanged,
        onKeyEvent: (_, event) {
          if (event is! KeyDownEvent) return KeyEventResult.ignored;
          if (event.logicalKey == LogicalKeyboardKey.escape) {
            cancel();
            return KeyEventResult.handled;
          }
          // IME-owned Enter must finish composing before it can submit.
          final primary = FocusManager.instance.primaryFocus?.context;
          final editable = primary
              ?.findAncestorStateOfType<EditableTextState>();
          final composing = editable?.widget.controller.value.composing;
          if (widget.submitOnEnter &&
              event.logicalKey == LogicalKeyboardKey.enter &&
              !((composing?.isValid ?? false) &&
                  !(composing?.isCollapsed ?? true))) {
            unawaited(submit());
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IgnorePointer(
              ignoring: _saving,
              child: widget.editorBuilder!(context, details),
            ),
            if (_error != null)
              Padding(
                padding: EdgeInsets.only(top: sizes.form.messageSpacing),
                child: Semantics(
                  liveRegion: true,
                  child: HyperText(
                    _error!,
                    style: TextStyle(color: theme.colors.error)
                        .merge(style.errorStyle),
                  ),
                ),
              ),
            if (widget.showActions)
              Padding(
                padding: EdgeInsets.only(top: sizes.form.gap),
                child: Wrap(
                  spacing: sizes.form.gap,
                  runSpacing: sizes.form.gap,
                  children: [
                    HyperButton.filled(
                      onPressed: _saving ? null : () => submit(),
                      loading: _saving,
                      style: style.actionStyle,
                      label: Text(widget.saveLabel),
                    ),
                    HyperButton.text(
                      onPressed: _saving ? null : cancel,
                      style: style.actionStyle,
                      label: Text(widget.cancelLabel),
                    ),
                  ],
                ),
              ),
            if (_saving && !widget.showActions)
              Semantics(liveRegion: true, child: const HyperText('正在保存')),
          ],
        ),
      );
      child = TapRegion(
        onTapOutside: (_) {
          if (widget.saveOnBlur && _overlayDepth == 0 && !_saving) {
            unawaited(submit(fromBlur: true));
          }
        },
        child: child,
      );
    }
    // Size-only animation never puts advanced backdrop filters in opacity layers.
    if (widget.transitionBuilder != null) {
      return widget.transitionBuilder!(context, child, duration, curve);
    }
    // Flutter's RenderAnimatedSize can synchronously dirty itself during layout
    // when a zero-duration controller resumes or restarts. No size animator is
    // needed in instant mode. Preserve the editor when motion settings change.
    final content = KeyedSubtree(key: _defaultTransitionChildKey, child: child);
    return duration == Duration.zero
        ? Align(
            alignment: AlignmentDirectional.topStart,
            heightFactor: 1,
            child: content,
          )
        : AnimatedSize(
            duration: duration,
            curve: curve,
            alignment: AlignmentDirectional.topStart,
            child: content,
          );
  }
}

class _TextEditor extends StatefulWidget {
  const _TextEditor({
    required this.details,
    required this.multiline,
    this.hintText,
  });
  final HyperInlineEditDetails<String> details;
  final bool multiline;
  final String? hintText;
  @override
  State<_TextEditor> createState() => _TextEditorState();
}

class _TextEditorState extends State<_TextEditor> {
  late final _controller = TextEditingController(text: widget.details.value);
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewport = widget.multiline
        ? widget.details.style.inputStyle?.height
        : null;
    final field = HyperTextField(
      controller: _controller,
      focusNode: widget.details.focusNode,
      enabled: !widget.details.saving,
      hintText: widget.hintText,
      maxLines: widget.multiline ? null : 1,
      expands: viewport != null,
      textInputAction: widget.multiline
          ? TextInputAction.newline
          : TextInputAction.done,
      // Compact inline editors grow from one row, including multiline drafts.
      // Center within that minimum row; explicit inline input overrides win.
      style: const HyperTextFieldStyle(
        textAlignVertical: TextAlignVertical.center,
      ).merge(widget.details.style.inputStyle),
      onChanged: widget.details.onChanged,
      onSubmitted: widget.multiline
          ? null
          : (_) {
              if (!_controller.value.composing.isValid ||
                  _controller.value.composing.isCollapsed) {
                unawaited(widget.details.submit());
              }
            },
    );
    return viewport == null ? field : SizedBox(height: viewport, child: field);
  }
}
