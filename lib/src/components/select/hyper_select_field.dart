import 'hyper_select_focus.dart';
import '../../foundation/hyper_fill.dart';
import '../text_field/hyper_text_field_theme.dart';
import '../text/hyper_scrolling_text.dart';
import '../chip/hyper_chip_style.dart';

import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/core/hyper_theme.dart';
import '../../theme/size/components/hyper_button_size.dart';
import '../autocomplete/hyper_autocomplete_theme.dart';
import '../button/hyper_button.dart';
import '../chip/hyper_chip.dart';
import '../button/hyper_button_style.dart';
import '../select/hyper_select_style.dart';
import '../select/hyper_select_theme.dart';
import '../menu/hyper_menu_style.dart';
import '../menu/hyper_menu.dart';
import '../overlay/hyper_anchored_overlay.dart';
import '../text_field/hyper_text_field.dart';
import '../text_field/hyper_text_field_style.dart';
import 'hyper_select_model.dart';
import 'hyper_select_panel.dart';
import 'hyper_select_presenter.dart';
import 'hyper_selection_style.dart';
import 'hyper_selection_tags.dart';
import 'hyper_selection_theme.dart';
import 'hyper_selection_layout.dart';

/// 下拉框与自动填充共用状态宿主，选择始终由调用方控制。
class HyperSelectField<T> extends StatefulWidget {
  const HyperSelectField({
    super.key,
    required this.options,
    required this.values,
    required this.onChanged,
    this.source,
    this.selectedOptions = const [],
    this.labelBuilder,
    this.multiple = false,
    this.autocomplete = false,
    this.searchable = false,
    this.allowDeselect = false,
    this.enabled = true,
    this.maximumSelection,
    this.placeholder = '请选择',
    this.presentation,
    this.selectionStyle,
    this.selectStyle,
    this.buttonStyle,
    this.inputStyle,
    this.menuStyle,
    this.size = HyperButtonSizeVariant.medium,
    this.placement = HyperOverlayPlacement.bottomStart,
    this.transitionBuilder,
    this.createValue,
  });
  final List<HyperSelectOption<T>> options, selectedOptions;
  final HyperSelectSource<T>? source;
  final Set<T> values;
  final ValueChanged<Set<T>>? onChanged;
  final String Function(T)? labelBuilder;
  final bool multiple, autocomplete, searchable, allowDeselect, enabled;
  final int? maximumSelection;
  final String placeholder;
  final HyperSelectPresentation? presentation;
  final HyperSelectionStyle? selectionStyle;
  final HyperSelectStyle? selectStyle;
  final HyperButtonStyle? buttonStyle;
  final HyperTextFieldStyle? inputStyle;
  final HyperMenuStyle? menuStyle;
  final HyperButtonSizeVariant size;
  final HyperOverlayPlacement placement;
  final HyperOverlayTransitionBuilder? transitionBuilder;
  final T Function(String)? createValue;
  @override
  State<HyperSelectField<T>> createState() => _HyperSelectFieldState<T>();
}

class _HyperSelectFieldState<T> extends State<HyperSelectField<T>> {
  late HyperSelectOptionsController<T> _options;
  late final ValueNotifier<Set<T>> _selection = ValueNotifier(widget.values);
  final _labels = <T, HyperSelectOption<T>>{};
  final _input = TextEditingController();
  final _search = TextEditingController();
  final _focus = FocusNode();
  final _modalFocus = FocusNode();
  final _searchFocus = FocusNode();
  final _configuration = ValueNotifier<int>(0);
  final _navigation = HyperMenuNavigationController();
  Timer? _debounce;
  bool _open = false, _writing = false, _modal = false;
  bool _selectingWithKeyboard = false;
  bool _triggerHovered = false, _triggerPressed = false;
  String _lastSearchText = '';
  TextRange _lastSearchComposing = TextRange.empty;
  String _lastInputText = '';
  TextRange _lastInputComposing = TextRange.empty;
  VoidCallback? _closeModal;
  HyperSelectionStyle _resolved = const HyperSelectionStyle();
  bool get _enabled => widget.enabled && widget.onChanged != null;

  @override
  void initState() {
    super.initState();
    _newSource();
    _input.addListener(_inputChanged);
    _search.addListener(_searchChanged);
    _syncText();
  }

  void _newSource() {
    if (widget.source != null && widget.options.isNotEmpty) {
      throw ArgumentError('options 和 source 只能指定一个。');
    }
    if (widget.maximumSelection != null && widget.maximumSelection! < 1) {
      throw ArgumentError('maximumSelection 必须为正。');
    }
    _options = HyperSelectOptionsController(
      widget.source ?? HyperSelectSource.static(widget.options),
    );
    _remember();
    _options.addListener(_remember);
  }

  void _remember() {
    _labels.removeWhere((value, _) => !widget.values.contains(value));
    for (final option in [
      ...widget.options,
      ...widget.selectedOptions,
      ..._options.options,
    ]) {
      _labels[option.value] = option;
    }
    if (!_open && !_focus.hasFocus) _syncText();
  }

  String _label(T value) =>
      _labels[value]?.label ?? widget.labelBuilder?.call(value) ?? '$value';
  void _syncText() {
    if (!widget.autocomplete || widget.multiple) return;
    _writing = true;
    _input.text = widget.values.isEmpty ? '' : _label(widget.values.first);
    _writing = false;
  }

  @override
  void didUpdateWidget(HyperSelectField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.source != widget.source ||
        !listEquals(oldWidget.options, widget.options)) {
      _debounce?.cancel();
      _options.dispose();
      _newSource();
      if (_open) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _open) _options.load(_query);
        });
      }
    }
    _remember();
    if (_modal) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _selection.value = Set.unmodifiable(widget.values);
          _configuration.value++;
        }
      });
    } else {
      _selection.value = Set.unmodifiable(widget.values);
    }
    if (!setEquals(oldWidget.values, widget.values)) _syncText();
    if (!_enabled && _open) _close();
  }

  @override
  void dispose() {
    final close = _closeModal;
    if (close != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => close());
    }
    _debounce?.cancel();
    _options.dispose();
    _selection.dispose();
    _input.dispose();
    _search.dispose();
    _focus.dispose();
    _modalFocus.dispose();
    _searchFocus.dispose();
    _configuration.dispose();
    super.dispose();
  }

  String get _query => widget.autocomplete ? _input.text : _search.text;
  void _inputChanged() {
    final value = _input.value;
    if (value.text == _lastInputText &&
        value.composing == _lastInputComposing) {
      return;
    }
    _lastInputText = value.text;
    _lastInputComposing = value.composing;
    if (!_writing && widget.autocomplete) _changed(_input);
  }

  void _searchChanged() {
    final value = _search.value;
    if (value.text == _lastSearchText &&
        value.composing == _lastSearchComposing) {
      return;
    }
    _lastSearchText = value.text;
    _lastSearchComposing = value.composing;
    if (!_writing && !widget.autocomplete) _changed(_search);
  }

  void _changed(TextEditingController editor) {
    if (!_enabled) return;
    _debounce?.cancel();
    _options.invalidate(editor.text);
    if (!hyperSelectCanQuery(editor.value)) {
      return;
    }
    if (!_open) _show(load: false);
    _debounce = Timer(
      _resolved.searchDebounce ??
          HyperTheme.of(context).motion.standardDuration,
      () {
        if (mounted && _open) _options.load(editor.text);
      },
    );
  }

  HyperSelectPresentation get _presentation => hyperResolveSelectPresentation(
    widget.presentation ??
        _resolved.presentation ??
        HyperSelectPresentation.adaptive,
    HyperTheme.sizesOf(context).deviceType,
  );
  Future<void> _show({bool load = true}) async {
    if (!_enabled || _open) return;
    final presentation = _presentation;
    _modal =
        presentation == HyperSelectPresentation.bottomSheet ||
        presentation == HyperSelectPresentation.fullScreen;
    setState(() => _open = true);
    if (!widget.autocomplete) {
      _writing = true;
      _search.clear();
      _writing = false;
    }
    if (load) {
      unawaited(
        _options.load(
          widget.autocomplete ? '' : _query,
          refresh: widget.source?.cachePolicy == HyperSelectCachePolicy.none,
        ),
      );
    }
    if (!mounted || !_open || !_modal) return;
    await showHyperSelectModal(
      context: context,
      presentation: presentation,
      title: widget.placeholder,
      style: _resolved,
      surfaceStyle:
          _resolved.menuStyle?.surfaceStyle?.merge(_resolved.surfaceStyle) ??
          _resolved.surfaceStyle,
      builder: (modalContext) {
        final navigator = Navigator.of(modalContext);
        final route = ModalRoute.of(modalContext)!;
        _closeModal = () {
          if (!route.isActive) return;
          if (route.isCurrent) {
            navigator.pop();
          } else {
            navigator.removeRoute(route);
          }
        };
        return LayoutBuilder(
          builder: (context, constraints) => ListenableBuilder(
            listenable: _configuration,
            builder: (context, _) =>
                _panel(context, constraints.maxWidth, modal: true),
          ),
        );
      },
    );
    _closeModal = null;
    if (mounted) {
      setState(() {
        _open = false;
        _modal = false;
      });
      _syncText();
    }
  }

  void _close({bool restoreFocus = false}) {
    if (!_open) return;
    _debounce?.cancel();
    _closeModal?.call();
    _closeModal = null;
    if (_searchFocus.hasFocus) _searchFocus.unfocus();
    if (_modalFocus.hasFocus) _modalFocus.unfocus();
    if (mounted) setState(() => _open = false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_open) {
        _syncText();
        if (restoreFocus) {
          _focus.requestFocus();
        } else {
          _focus.unfocus();
        }
      }
    });
  }

  void _select(HyperSelectOption<T> option) {
    if (!_enabled ||
        !option.enabled ||
        _labels[option.value]?.enabled == false) {
      return;
    }
    final selected = widget.values;
    final next = widget.multiple
        ? hyperToggleSelect(selected, option, maximum: widget.maximumSelection)
        : widget.allowDeselect && selected.contains(option.value)
        ? <T>{}
        : <T>{option.value};
    _labels[option.value] = option;
    widget.onChanged?.call(Set.unmodifiable(next));
    if (widget.multiple && widget.autocomplete) {
      _writing = true;
      _input.clear();
      _writing = false;
      _options.load('');
      (_modal ? _modalFocus : _focus).requestFocus();
    }
    if (!widget.multiple) {
      _close(restoreFocus: _selectingWithKeyboard);
    }
  }

  void _remove(T value) {
    if (!_enabled || _labels[value]?.enabled == false) return;
    widget.onChanged?.call(
      Set.unmodifiable(Set<T>.of(widget.values)..remove(value)),
    );
  }

  // 紧凑摘要不加入额外 Tab 停靠点；完整面板提供可聚焦的删除操作。
  Widget _tags() {
    final sizes = HyperTheme.sizesOf(context);
    // Select 与 Autocomplete 共用表单内容区规格，不按宿主分别压缩标签。
    final availableHeight =
        sizes.textField.minimumHeight - sizes.textField.verticalPadding * 2;
    final chipStyle = HyperChipStyle(
      height: math.min(sizes.chip.height, math.max(0, availableHeight)),
      minimumTapTargetSize: 0,
    ).merge(_resolved.chipStyle);
    final painter = TextPainter(
      text: TextSpan(
        text: widget.values.isEmpty
            ? ''
            : '${(_label(widget.values.first).characters.firstOrNull ?? '')}…',
        style:
            (HyperTheme.of(context).textTheme.labelMedium ?? const TextStyle())
                .copyWith(height: 1)
                .merge(chipStyle.textStyle),
      ),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final minimumTagWidth =
        painter.width +
        (chipStyle.horizontalPadding ?? sizes.chip.horizontalPadding) * 2 +
        (chipStyle.deleteTargetWidth ?? sizes.chip.deleteTargetWidth);
    painter.dispose();
    return ExcludeFocus(
      child: HyperSelectionTags(
        minimumTagWidth: minimumTagWidth,
        tags: [
          for (final value in widget.values)
            HyperChip.input(
              label: _label(value),
              enabled: _enabled && _labels[value]?.enabled != false,
              onDeleted: () => _remove(value),
              deleteIcon: Icon(_resolved.clearIcon ?? Icons.close),
              style: chipStyle,
            ),
        ],
        overflowBuilder: (count) => HyperChip.action(
          label: '+$count',
          onPressed: _show,
          style: chipStyle,
        ),
        spacing:
            _resolved.chipSpacing ??
            HyperTheme.sizesOf(context).selection.chipSpacing,
        direction: Directionality.of(context),
      ),
    );
  }

  HyperTextFieldThemeData _autocompleteTriggerTheme(BuildContext context) {
    final button = HyperSelectTheme.of(context).style?.buttonStyle;
    return HyperTextFieldThemeData(
      style: HyperTextFieldStyle(
        boxShadow: _triggerPressed
            ? button?.pressedBoxShadow ?? button?.boxShadow
            : button?.boxShadow,
      ),
      hovered: HyperTextFieldStyle(
        boxShadow: _triggerPressed
            ? button?.pressedBoxShadow
            : button?.hoveredBoxShadow,
      ),
      focused: HyperTextFieldStyle(
        boxShadow: _triggerPressed
            ? button?.pressedBoxShadow
            : button?.focusedBoxShadow,
      ),
      disabled: HyperTextFieldStyle(
        background: button?.disabledBackground,
        foregroundColor: button?.disabledForegroundColor,
        boxShadow: button?.disabledBoxShadow,
      ),
    );
  }

  Widget _editor({required bool modal}) => LayoutBuilder(
    builder: (context, constraints) => HyperTextFieldTheme(
      data: widget.autocomplete && !modal
          ? _autocompleteTriggerTheme(context)
          : const HyperTextFieldThemeData(),
      child: HyperTextField(
        controller: widget.autocomplete ? _input : _search,
        focusNode: modal
            ? _modalFocus
            : widget.autocomplete
            ? _focus
            : _searchFocus,
        autofocus: modal || !widget.autocomplete,
        leading:
            !modal &&
                widget.autocomplete &&
                widget.multiple &&
                widget.values.isNotEmpty
            ? SizedBox(
                width: math.max(
                  0,
                  constraints.maxWidth -
                      (_resolved.minimumInputWidth ??
                          HyperTheme.sizesOf(context)
                              .selection
                              .minimumInputWidth) -
                      HyperTheme.sizesOf(context).textField.horizontalPadding *
                          2,
                ),
                child: _tags(),
              )
            : null,
        enabled: _enabled,
        hintText: widget.autocomplete && !modal
            ? widget.placeholder
            : (_resolved.searchHint ?? '搜索'),
        style: widget.autocomplete
            ? HyperTextFieldStyle(
                borderRadius:
                    !modal && HyperTheme.sizesOf(context).select.radius != null
                    ? BorderRadius.circular(
                        HyperTheme.sizesOf(context).select.radius!,
                      )
                    : null,
                background:
                    HyperTextFieldTheme.of(context).style.background ??
                    HyperFill.color(HyperTheme.of(context).colors.surface),
                height:
                    HyperTextFieldTheme.of(context).style.height ??
                    HyperTheme.sizesOf(context).select.minimumHeight ??
                    HyperTheme.sizesOf(context).textField.minimumHeight,
                padding:
                    !modal &&
                        (HyperTheme.sizesOf(context).select.paddingHorizontal !=
                                null ||
                            HyperTheme.sizesOf(context)
                                    .select
                                    .paddingVertical !=
                                null)
                    ? EdgeInsets.symmetric(
                        horizontal:
                            HyperTheme.sizesOf(context)
                                .select
                                .paddingHorizontal ??
                            HyperTheme.sizesOf(context)
                                .textField
                                .horizontalPadding,
                        vertical:
                            HyperTheme.sizesOf(context)
                                .select
                                .paddingVertical ??
                            HyperTheme.sizesOf(context)
                                .textField
                                .verticalPadding,
                      )
                    : null,
              ).merge(_resolved.inputStyle).merge(widget.inputStyle)
            : _resolved.searchStyle,
        onTap: !modal ? _show : null,
        onSubmitted: widget.createValue == null
            ? null
            : (text) {
                if (text.trim().isNotEmpty) {
                  _select(
                    HyperSelectOption(
                      value: widget.createValue!(text.trim()),
                      label: text.trim(),
                    ),
                  );
                }
              },
      ),
    ),
  );
  Widget _panel(BuildContext context, double width, {bool modal = false}) {
    return Focus(
      onKeyEvent: _key,
      child: HyperSelectPanel<T>(
        editing: widget.multiple,
        showSurface: !modal,
        navigationController: _navigation,
        controller: _options,
        selection: _selection,
        onSelected: _select,
        style: _resolved,
        width: width,
        maximumSelection: widget.multiple ? widget.maximumSelection : null,
        requestFocusOnOpen: !widget.autocomplete && !widget.searchable,
        header:
            (!widget.autocomplete && widget.searchable) ||
                (widget.autocomplete && modal)
            ? _editor(modal: modal)
            : null,
        footer: widget.multiple
            ? HyperSelectionActions(
                clearText: _resolved.clearText ?? '清空',
                confirmText: _resolved.doneText ?? '完成',
                onClear: _enabled
                    ? () {
                        widget.onChanged?.call(
                          Set.unmodifiable(
                            widget.values.where(
                              (value) => _labels[value]?.enabled == false,
                            ),
                          ),
                        );
                      }
                    : null,
                onConfirm: _close,
              )
            : null,
      ),
    );
  }

  KeyEventResult _key(FocusNode node, KeyEvent event) {
    if (!_enabled || event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.escape && _open) {
      _close(restoreFocus: true);
      return KeyEventResult.handled;
    }
    if ((event.logicalKey == LogicalKeyboardKey.arrowDown ||
            event.logicalKey == LogicalKeyboardKey.arrowUp) &&
        !_open) {
      _show();
      return KeyEventResult.handled;
    }
    if (_open &&
        (event.logicalKey == LogicalKeyboardKey.arrowDown ||
            event.logicalKey == LogicalKeyboardKey.arrowUp ||
            event.logicalKey == LogicalKeyboardKey.enter)) {
      final editor = widget.autocomplete ? _input : _search;
      if (!hyperSelectCanQuery(editor.value)) return KeyEventResult.ignored;
      _selectingWithKeyboard = true;
      try {
        return _navigation.handleKeyEvent(event);
      } finally {
        _selectingWithKeyboard = false;
      }
    }
    if (widget.multiple &&
        widget.autocomplete &&
        _input.text.isEmpty &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        widget.values.isNotEmpty) {
      final removable = widget.values.where(
        (value) => _labels[value]?.enabled != false,
      );
      if (removable.isNotEmpty) _remove(removable.last);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: _options,
    builder: (context, _) => _buildField(context),
  );

  Widget _buildField(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    final theme = HyperTheme.of(context);
    final dropdown =
        HyperSelectStyle(
              selectionStyle: HyperSelectionStyle(
                menuStyle: HyperMenuStyle(
                  itemHeight: sizes.select.itemHeight,
                  padding: sizes.select.itemPadding,
                  itemSpacing: sizes.select.itemSpacing,
                  itemRadius: sizes.select.itemRadius,
                  surfaceRadius: sizes.select.surfaceRadius,
                ),
              ),
              width: sizes.select.width,
              arrowSize: sizes.select.arrowSize,
              arrowSpacing: sizes.select.arrowSpacing,
              popupSpacing: sizes.select.popupSpacing ?? sizes.overlaySpacing,
              arrowColor: theme.colors.textSecondary,
              foregroundColor: theme.colors.textPrimary,
              disabledArrowColor: theme.colors.disabled,
            )
            .merge(
              widget.autocomplete ? null : HyperSelectTheme.of(context).style,
            )
            .merge(widget.selectStyle);
    _resolved = HyperSelectionTheme.of(context).style
        .merge(
          widget.autocomplete
              ? HyperAutocompleteTheme.of(context).style
              : dropdown.selectionStyle,
        )
        .merge(widget.selectionStyle)
        .merge(
          HyperSelectionStyle(
            menuStyle: HyperMenuStyle(
              selectedBackgroundColor: dropdown.selectedBackgroundColor,
            ).merge(widget.menuStyle),
          ),
        );
    final width =
        widget.buttonStyle?.width ??
        widget.selectStyle?.width ??
        _resolved.width ??
        dropdown.width!;
    Widget anchor;
    if (widget.autocomplete) {
      anchor = MouseRegion(
        onEnter: (_) => setState(() => _triggerHovered = true),
        onExit: (_) => setState(() => _triggerHovered = false),
        child: Listener(
          onPointerDown: (_) => setState(() => _triggerPressed = true),
          onPointerUp: (_) => setState(() => _triggerPressed = false),
          onPointerCancel: (_) => setState(() => _triggerPressed = false),
          child: AnimatedBuilder(
            animation: _focus,
            builder: (context, _) {
              final visual = HyperSelectTheme.of(context).style?.buttonStyle;
              final reduced =
                  MediaQuery.disableAnimationsOf(context) || !_enabled;
              final offset = reduced
                  ? Offset.zero
                  : _triggerPressed
                  ? visual?.pressedOffset ?? Offset.zero
                  : _focus.hasFocus && visual?.focusedOffset != null
                  ? visual!.focusedOffset!
                  : _triggerHovered
                  ? visual?.hoveredOffset ?? Offset.zero
                  : Offset.zero;
              final scale = reduced
                  ? 1.0
                  : _triggerPressed
                  ? visual?.pressedScale ?? 1
                  : _focus.hasFocus && visual?.focusedScale != null
                  ? visual!.focusedScale!
                  : _triggerHovered
                  ? visual?.hoveredScale ?? 1
                  : 1.0;
              final duration = reduced
                  ? Duration.zero
                  : visual?.animationDuration ?? theme.motion.fastDuration;
              return TweenAnimationBuilder<Offset>(
                tween: Tween(end: offset),
                duration: duration,
                curve: visual?.animationCurve ?? theme.motion.fastCurve,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(end: scale),
                  duration: duration,
                  curve: visual?.animationCurve ?? theme.motion.fastCurve,
                  child: SizedBox(width: width, child: _editor(modal: false)),
                  builder: (context, value, child) => Transform.scale(
                    scale: value,
                    transformHitTests: false,
                    child: child,
                  ),
                ),
                builder: (context, value, child) => Transform.translate(
                  offset: value,
                  transformHitTests: false,
                  child: child,
                ),
              );
            },
          ),
        ),
      );
    } else {
      anchor = HyperSelectFocus(
        open: _open,
        enabled: _enabled,
        builder: (focusStyle) => HyperButton.outlined(
          onPressed: _enabled ? () => _open ? _close() : _show() : null,
          focusNode: _focus,
          focusHighlight: _open ? true : null,
          size: widget.size,
          style:
              HyperButtonStyle(
                    width: width,
                    minimumSize: Size(
                      0,
                      sizes.select.minimumHeight ??
                          (widget.size == HyperButtonSizeVariant.medium
                              ? sizes.textField.minimumHeight
                              : sizes.button.heightFor(widget.size)),
                    ),
                    padding:
                        sizes.select.paddingHorizontal == null &&
                            sizes.select.paddingVertical == null
                        ? null
                        : EdgeInsets.symmetric(
                            horizontal:
                                sizes.select.paddingHorizontal ??
                                sizes.button
                                    .paddingFor(widget.size)
                                    .resolve(Directionality.of(context))
                                    .left,
                            vertical:
                                sizes.select.paddingVertical ??
                                sizes.button
                                    .paddingFor(widget.size)
                                    .resolve(Directionality.of(context))
                                    .top,
                          ),
                    borderRadius: sizes.select.radius == null
                        ? null
                        : BorderRadius.circular(sizes.select.radius!),
                    minimumTapTargetSize:
                        sizes.select.minimumTapTargetSize == null
                        ? null
                        : Size.square(sizes.select.minimumTapTargetSize!),
                    foregroundColor: dropdown.foregroundColor,
                  )
                  .merge(focusStyle)
                  .merge(dropdown.buttonStyle)
                  .merge(widget.buttonStyle),
          child: Row(
            children: [
              Expanded(
                child: widget.multiple && widget.values.isNotEmpty
                    ? _tags()
                    : HyperScrollingText(
                        widget.values.isEmpty
                            ? widget.placeholder
                            : _label(widget.values.first),
                        trigger: HyperTextScrollTrigger.hover,
                      ),
              ),
              SizedBox(width: dropdown.arrowSpacing),
              Icon(
                _open ? Icons.expand_less : Icons.expand_more,
                size: widget.buttonStyle?.iconSize ?? dropdown.arrowSize,
                color: _enabled
                    ? dropdown.arrowColor
                    : dropdown.disabledArrowColor,
              ),
            ],
          ),
        ),
      );
    }
    return Focus(
      onKeyEvent: _key,
      child: HyperAnchoredOverlay(
        trigger: HyperOverlayTrigger.manual,
        isOpen: _open && !_modal,
        onOpenChanged: (value) {
          if (!value) {
            _close(
              restoreFocus: HardwareKeyboard.instance.logicalKeysPressed
                  .contains(LogicalKeyboardKey.escape),
            );
          }
        },
        placement: _presentation == HyperSelectPresentation.trailing
            ? HyperOverlayPlacement.bottomEnd
            : widget.placement,
        spacing: dropdown.popupSpacing,
        transitionBuilder:
            widget.transitionBuilder ?? _resolved.transitionBuilder,
        anchor: anchor,
        overlayBuilder: (context, close) => _panel(
          context,
          math.min(
            _resolved.menuStyle?.width ?? width,
            MediaQuery.sizeOf(context).width,
          ),
        ),
      ),
    );
  }
}
