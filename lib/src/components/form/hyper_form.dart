import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_field_style.dart';
import 'hyper_field_theme.dart';
import 'hyper_form_theme.dart';

export 'hyper_field_style.dart';

typedef HyperAsyncFieldValidator<T> = Future<String?> Function(T? value);
typedef HyperCrossFieldValidator = FutureOr<Map<String, String>> Function(
  Map<String, Object?> values,
);
typedef HyperFormSubmitHandler = FutureOr<void> Function(
  Map<String, Object?> values,
);

Object? _snapshot(Object? value) {
  if (value is List) return List<Object?>.unmodifiable(value.map(_snapshot));
  if (value is Set) return Set<Object?>.unmodifiable(value.map(_snapshot));
  if (value is Map) {
    return Map<Object?, Object?>.unmodifiable({
      for (final e in value.entries) _snapshot(e.key): _snapshot(e.value),
    });
  }
  return value;
}

bool _equal(Object? a, Object? b) {
  if (identical(a, b)) return true;
  if (a is List && b is List) {
    return a.length == b.length &&
        List.generate(a.length, (i) => _equal(a[i], b[i])).every((v) => v);
  }
  if (a is Map && b is Map) {
    return a.length == b.length &&
        a.entries.every(
          (e) => b.containsKey(e.key) && _equal(e.value, b[e.key]),
        );
  }
  if (a is Set && b is Set) {
    return a.length == b.length && a.every((v) => b.any((w) => _equal(v, w)));
  }
  return a == b;
}

abstract class _Entry {
  String? get name;
  Object? get currentValue;
  Object? takeSnapshot();
  bool matchesSnapshot(Object? baseline);
  bool get touched;
  bool get enabled;
  bool get hasError;
  BuildContext get context;
  void clearErrors();
  void invalidateValidation();
  void externalError(String? error);
  Future<bool> validateAsync(int revision);
  void reveal();
}

class HyperFormController extends ChangeNotifier {
  HyperFormController({this.crossValidators = const []});
  final List<HyperCrossFieldValidator> crossValidators;
  final formKey = GlobalKey<FormState>();
  final Set<_Entry> _fields = {};
  final Map<_Entry, Object?> _clean = {};
  Object? _owner;
  int _revision = 0, _ticket = 0;
  bool _disposed = false, _scheduled = false, _validating = false;
  Future<bool>? _submission;
  Object? _submitError;
  StackTrace? _submitStackTrace;
  bool get isValidating => _validating;
  bool get isSubmitting => _submission != null;
  Object? get submitError => _submitError;
  StackTrace? get submitStackTrace => _submitStackTrace;
  Map<String, Object?> get values => Map.unmodifiable({
    for (final f in _fields)
      if (f.name != null) f.name!: f.takeSnapshot(),
  });
  T? value<T>(String name) {
    final entries = _fields.where((f) => f.name == name);
    return entries.isEmpty ? null : entries.first.currentValue as T?;
  }

  Set<String> get dirtyFields => Set.unmodifiable({
    for (final f in _fields)
      if (f.name != null && !f.matchesSnapshot(_clean[f])) f.name!,
  });
  Set<String> get touchedFields => Set.unmodifiable({
    for (final f in _fields)
      if (f.name != null && f.touched) f.name!,
  });
  bool get isDirty => _fields.any((f) => !f.matchesSnapshot(_clean[f]));
  void _notify() {
    if (_disposed || _scheduled) return;
    _scheduled = true;
    scheduleMicrotask(() {
      _scheduled = false;
      if (!_disposed) notifyListeners();
    });
  }

  void _attach(Object owner) {
    if (_owner != null && !identical(owner, _owner)) {
      throw FlutterError('HyperFormController 不能同时挂载多张表单');
    }
    _owner = owner;
  }

  void _detach(Object owner) {
    if (identical(owner, _owner)) {
      _owner = null;
      _revision++;
      _ticket++;
      _validating = false;
    }
  }

  void _register(_Entry entry) {
    if (entry.name != null &&
        _fields.any((f) => !identical(f, entry) && f.name == entry.name)) {
      throw FlutterError('重复的表单字段名称：${entry.name}');
    }
    if (_fields.add(entry)) {
      _clean[entry] = entry.takeSnapshot();
      _revision++;
      _ticket++;
      _validating = false;
    }
    _notify();
  }

  void _unregister(_Entry entry) {
    _fields.remove(entry);
    _clean.remove(entry);
    _revision++;
    _ticket++;
    _validating = false;
    _notify();
  }

  void _invalidate() {
    if (_disposed) return;
    _revision++;
    _ticket++;
    _validating = false;
    for (final f in _fields.toList()) {
      f.invalidateValidation();
      f.externalError(null);
    }
    _submitError = null;
    _submitStackTrace = null;
    _notify();
  }

  void markClean() {
    for (final f in _fields) {
      _clean[f] = f.takeSnapshot();
    }
    _notify();
  }

  void save() => formKey.currentState?.save();
  void reset() {
    _invalidate();
    formKey.currentState?.reset();
    for (final f in _fields) {
      _clean[f] = f.takeSnapshot();
    }
    _notify();
  }

  bool validateSync() => formKey.currentState?.validate() ?? false;
  Future<bool> validate() async {
    if (_disposed || formKey.currentState == null) return false;
    for (final f in _fields) {
      f.clearErrors();
    }
    final ticket = ++_ticket, revision = _revision;
    _validating = true;
    _notify();
    try {
      final sync = validateSync();
      final fields = _fields.toList();
      final snapshot = values;
      final results = await Future.wait([
        for (final f in fields)
          if (f.enabled && !f.hasError) f.validateAsync(revision),
      ]);
      if (_disposed || ticket != _ticket || revision != _revision) return false;
      var cross = true;
      for (final validator in crossValidators) {
        final errors = await validator(snapshot);
        if (_disposed || ticket != _ticket || revision != _revision) {
          return false;
        }
        for (final e in errors.entries) {
          final matches = _fields.where((f) => f.name == e.key);
          if (matches.isEmpty) throw FlutterError('跨字段校验返回未知字段：${e.key}');
          if (matches.first.enabled) {
            matches.first.externalError(e.value);
            cross = false;
          }
        }
      }
      final valid = sync && results.every((v) => v) && cross;
      if (!valid) {
        for (final f in fields) {
          if (f.hasError) {
            f.reveal();
            break;
          }
        }
      }
      return valid;
    } finally {
      if (!_disposed && ticket == _ticket) {
        _validating = false;
        _notify();
      }
    }
  }

  Future<bool> submit(HyperFormSubmitHandler onValid) {
    if (_submission != null) return _submission!;
    final completer = Completer<bool>();
    _submission = completer.future;
    _notify();
    () async {
      final revision = _revision;
      try {
        _submitError = null;
        _submitStackTrace = null;
        if (!await validate() || _disposed || revision != _revision) {
          completer.complete(false);
          return;
        }
        final snapshot = values;
        save();
        await onValid(snapshot);
        completer.complete(true);
      } catch (e, st) {
        if (!_disposed && revision == _revision) {
          _submitError = e;
          _submitStackTrace = st;
        }
        completer.completeError(e, st);
      } finally {
        _submission = null;
        _notify();
      }
    }();
    return completer.future;
  }

  @override
  void dispose() {
    _disposed = true;
    _revision++;
    _ticket++;
    super.dispose();
  }
}

class HyperForm extends StatefulWidget {
  const HyperForm({
    super.key,
    required this.controller,
    required this.child,
    this.layout = HyperFieldLayout.vertical,
    this.errorDisplay = HyperFieldErrorDisplay.auto,
    this.style,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.onChanged,
    this.canPop,
  });
  final HyperFormController controller;
  final Widget child;
  final HyperFieldLayout layout;
  final HyperFieldErrorDisplay errorDisplay;
  final HyperFieldStyle? style;
  final AutovalidateMode autovalidateMode;
  final VoidCallback? onChanged;
  final bool? canPop;
  static HyperFormController? maybeControllerOf(BuildContext context) =>
      _FormScope.of(context)?.controller;
  @override
  State<HyperForm> createState() => _HyperFormState();
}

class _HyperFormState extends State<HyperForm> {
  @override
  void initState() {
    super.initState();
    widget.controller._attach(this);
  }

  @override
  void didUpdateWidget(HyperForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller._detach(this);
      widget.controller._attach(this);
    }
  }

  @override
  void dispose() {
    widget.controller._detach(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Form(
    key: widget.controller.formKey,
    canPop: widget.canPop,
    autovalidateMode: widget.autovalidateMode,
    onChanged: () {
      widget.controller._invalidate();
      widget.onChanged?.call();
    },
    child: _FormScope(
      controller: widget.controller,
      layout: widget.layout,
      errorDisplay: widget.errorDisplay,
      style: HyperFormTheme.of(context).style
          .merge(HyperTheme.of(context).fieldTheme.style)
          .merge(widget.style),
      child: widget.child,
    ),
  );
}

class _FormScope extends InheritedWidget {
  const _FormScope({
    required this.controller,
    required this.layout,
    required this.errorDisplay,
    required this.style,
    required super.child,
  });
  final HyperFormController controller;
  final HyperFieldLayout layout;
  final HyperFieldErrorDisplay errorDisplay;
  final HyperFieldStyle style;
  static _FormScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_FormScope>();
  @override
  bool updateShouldNotify(_FormScope oldWidget) =>
      oldWidget.controller != controller ||
      oldWidget.layout != layout ||
      oldWidget.errorDisplay != errorDisplay ||
      oldWidget.style != style;
}

/// Presentation only; field values and validators belong to HyperFormField.
class HyperField extends StatelessWidget {
  const HyperField({
    super.key,
    required this.child,
    this.label,
    this.semanticLabel,
    this.description,
    this.errorText,
    this.requiredIndicator = false,
    this.layout,
    this.errorDisplay,
    this.style,
    this.errorHandledByChild = false,
  });
  final Widget child;
  final String? label, semanticLabel, description, errorText;
  final bool requiredIndicator, errorHandledByChild;
  final HyperFieldLayout? layout;
  final HyperFieldErrorDisplay? errorDisplay;
  final HyperFieldStyle? style;
  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context),
        sizes = HyperTheme.sizesOf(context).form;
    final scope = _FormScope.of(context);
    final visual =
        (scope?.style ??
                HyperFormTheme.of(context).style
                    .merge(HyperTheme.of(context).fieldTheme.style))
            .merge(HyperFieldTheme.maybeOf(context)?.style)
            .merge(style);
    final requested = layout ?? scope?.layout ?? HyperFieldLayout.vertical;
    final gap = visual.gap ?? sizes.gap,
        labelWidth = visual.labelWidth ?? sizes.labelWidth;
    final messageGap = visual.messageSpacing ?? sizes.messageSpacing;
    final errorStyle = (theme.textTheme.bodySmall ?? const TextStyle())
        .copyWith(color: theme.colors.error)
        .merge(visual.errorStyle);
    final labelStyle = (theme.textTheme.bodyMedium ?? const TextStyle())
        .copyWith(color: theme.colors.textPrimary)
        .merge(visual.labelStyle);
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontal =
            requested == HyperFieldLayout.horizontal &&
            constraints.hasBoundedWidth &&
            constraints.maxWidth >=
                labelWidth +
                    gap +
                    (visual.minimumControlWidth ?? sizes.minimumControlWidth);
        final showLabel =
            requested != HyperFieldLayout.labelHidden && label != null;
        var display =
            errorDisplay ?? scope?.errorDisplay ?? HyperFieldErrorDisplay.auto;
        if (display == HyperFieldErrorDisplay.auto) {
          display = requested == HyperFieldLayout.vertical && showLabel
              ? HyperFieldErrorDisplay.inline
              : HyperFieldErrorDisplay.trailingIcon;
        }
        if (!showLabel && display == HyperFieldErrorDisplay.inline) {
          display = HyperFieldErrorDisplay.below;
        }
        final childHandlesError =
            errorHandledByChild &&
            display == HyperFieldErrorDisplay.trailingIcon;
        Widget error() => Semantics(
          liveRegion: true,
          child: Text(errorText!, style: errorStyle),
        );
        Widget title() => Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: gap,
          runSpacing: messageGap,
          children: [
            Text.rich(
              TextSpan(
                text: label,
                style: labelStyle,
                children: [
                  if (requiredIndicator)
                    TextSpan(
                      text: ' *',
                      style: TextStyle(
                        color: visual.requiredColor ?? theme.colors.error,
                      ),
                    ),
                ],
              ),
            ),
            if (errorText != null &&
                !childHandlesError &&
                display == HyperFieldErrorDisplay.inline)
              error(),
          ],
        );
        final content = Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Semantics(
              label:
                  semanticLabel ??
                  (requested == HyperFieldLayout.labelHidden ? label : null),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child:
                    display == HyperFieldErrorDisplay.trailingIcon &&
                        !childHandlesError &&
                        errorText != null
                    ? Row(
                        children: [
                          Flexible(child: child),
                          SizedBox(width: messageGap),
                          Tooltip(
                            message: errorText!,
                            child: Icon(
                              Icons.error_outline,
                              color: errorStyle.color,
                              size: theme.textTheme.bodyMedium?.fontSize,
                            ),
                          ),
                        ],
                      )
                    : child,
              ),
            ),
            if (description != null) ...[
              SizedBox(height: messageGap),
              Text(
                description!,
                style: (theme.textTheme.bodySmall ?? const TextStyle())
                    .copyWith(color: theme.colors.textSecondary)
                    .merge(visual.descriptionStyle),
              ),
            ],
            if (errorText != null &&
                !childHandlesError &&
                display == HyperFieldErrorDisplay.below) ...[
              SizedBox(height: messageGap),
              error(),
            ],
          ],
        );
        if (horizontal && showLabel) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: labelWidth, child: title()),
              SizedBox(width: gap),
              Expanded(child: content),
            ],
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showLabel) ...[title(), SizedBox(height: gap)],
            content,
          ],
        );
      },
    );
  }
}

class HyperFormField<T> extends FormField<T> {
  HyperFormField({
    super.key,
    this.name,
    this.label,
    this.semanticLabel,
    this.description,
    this.requiredIndicator = false,
    this.layout,
    this.errorDisplay,
    this.style,
    this.asyncValidator,
    this.onChanged,
    this.focusNode,
    this.errorHandledByChild = false,
    this.valueEquals,
    this.valueSnapshot,
    required this.fieldBuilder,
    super.initialValue,
    FormFieldValidator<T>? validator,
    super.onSaved,
    super.onReset,
    super.enabled,
    super.autovalidateMode,
  }) : super(
         validator: enabled ? validator : null,
         builder: (state) {
           final field = state as HyperFormFieldState<T>;
           return HyperField(
             label: label,
             semanticLabel: semanticLabel,
             description: description,
             requiredIndicator: requiredIndicator,
             layout: layout,
             errorDisplay: errorDisplay,
             style: style,
             errorText: field.displayError,
             errorHandledByChild: errorHandledByChild,
             child: fieldBuilder(field),
           );
         },
       );
  final String? name, label, semanticLabel, description;
  final bool requiredIndicator, errorHandledByChild;
  final HyperFieldLayout? layout;
  final HyperFieldErrorDisplay? errorDisplay;
  final HyperFieldStyle? style;
  final HyperAsyncFieldValidator<T>? asyncValidator;
  final ValueChanged<T?>? onChanged;
  final bool Function(T? baseline, T? value)? valueEquals;
  final T? Function(T? value)? valueSnapshot;
  final FocusNode? focusNode;
  final Widget Function(HyperFormFieldState<T> field) fieldBuilder;
  @override
  HyperFormFieldState<T> createState() => HyperFormFieldState<T>();
}

class HyperFormFieldState<T> extends FormFieldState<T> implements _Entry {
  HyperFormController? _controller;
  String? _asyncError, _externalError;
  bool _validating = false;
  bool _touched = false;
  int _asyncTicket = 0;
  final FocusNode _ownedFocus = FocusNode();
  HyperFormField<T> get field => widget as HyperFormField<T>;

  /// Whether the input should render its own trailing error indicator.
  bool get usesTrailingError {
    final scope = _FormScope.of(context);
    final display =
        field.errorDisplay ??
        scope?.errorDisplay ??
        HyperFieldErrorDisplay.auto;
    if (display != HyperFieldErrorDisplay.auto) {
      return display == HyperFieldErrorDisplay.trailingIcon;
    }
    final layout = field.layout ?? scope?.layout ?? HyperFieldLayout.vertical;
    return layout != HyperFieldLayout.vertical || field.label == null;
  }

  FocusNode get focusNode => field.focusNode ?? _ownedFocus;
  String? get displayError =>
      !enabled ? null : errorText ?? _asyncError ?? _externalError;
  bool get isValidating => _validating;
  @override
  String? get name => field.name;
  @override
  Object? get currentValue => value;
  @override
  Object? takeSnapshot() => field.valueSnapshot != null
      ? field.valueSnapshot!(value)
      : field.valueEquals != null
      ? value
      : _snapshot(value);
  @override
  bool matchesSnapshot(Object? baseline) => field.valueEquals != null
      ? field.valueEquals!(baseline as T?, value)
      : _equal(baseline, value);
  @override
  bool get touched => _touched;
  @override
  bool get enabled => widget.enabled;
  @override
  bool get hasError => displayError != null;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final next = _FormScope.of(context)?.controller;
    if (next != _controller) {
      _controller?._unregister(this);
      _controller = next;
    }
    _controller?._register(this);
  }

  @override
  void didUpdateWidget(covariant HyperFormField<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.name != field.name) {
      _controller?._unregister(this);
      _controller?._register(this);
    }
  }

  @override
  void didChange(T? value) {
    _touched = true;
    _asyncTicket++;
    _asyncError = null;
    _validating = false;
    super.didChange(value);
    field.onChanged?.call(value);
    _controller?._notify();
  }

  @override
  void reset() {
    _touched = false;
    _asyncTicket++;
    _asyncError = _externalError = null;
    _validating = false;
    super.reset();
    field.onChanged?.call(value);
  }

  @override
  void clearErrors() {
    _asyncTicket++;
    if (_asyncError != null || _externalError != null || _validating) {
      setState(() {
        _asyncError = _externalError = null;
        _validating = false;
      });
    }
  }

  @override
  void invalidateValidation() {
    _asyncTicket++;
    if (_validating) setState(() => _validating = false);
  }

  @override
  void externalError(String? error) {
    if (_externalError != error) setState(() => _externalError = error);
  }

  @override
  Future<bool> validateAsync(int revision) async {
    if (field.asyncValidator == null) return true;
    final ticket = ++_asyncTicket;
    setState(() => _validating = true);
    try {
      final result = await field.asyncValidator!(value);
      if (!mounted ||
          ticket != _asyncTicket ||
          revision != _controller?._revision) {
        return false;
      }
      setState(() => _asyncError = result);
      return result == null;
    } finally {
      if (mounted && ticket == _asyncTicket) {
        setState(() => _validating = false);
      }
    }
  }

  @override
  void reveal() {
    if (!mounted) return;
    Scrollable.ensureVisible(
      context,
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : HyperTheme.of(context).motion.fastDuration,
    );
    focusNode.requestFocus();
  }

  @override
  void dispose() {
    _asyncTicket++;
    _controller?._unregister(this);
    _ownedFocus.dispose();
    super.dispose();
  }
}

class HyperFormErrorSummary extends StatelessWidget {
  const HyperFormErrorSummary({
    super.key,
    required this.controller,
    this.builder,
  });
  final HyperFormController controller;
  final Widget Function(BuildContext, Object)? builder;
  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, child) {
      final error = controller.submitError;
      if (error == null) return const SizedBox.shrink();
      return Semantics(
        liveRegion: true,
        child:
            builder?.call(context, error) ??
            Text(
              error.toString(),
              style: HyperTheme.of(context).textTheme.bodySmall
                  ?.copyWith(color: HyperTheme.of(context).colors.error),
            ),
      );
    },
  );
}

class HyperFormSection extends StatelessWidget {
  const HyperFormSection({
    super.key,
    this.title,
    this.description,
    this.columns = 1,
    required this.children,
  }) : assert(columns > 0);
  final String? title, description;
  final List<Widget> children;
  final int columns;
  @override
  Widget build(BuildContext context) {
    final gap =
        (_FormScope.of(context)?.style.fieldSpacing ??
            HyperFormTheme.of(context).style.fieldSpacing) ??
        HyperTheme.sizesOf(context).form.fieldSpacing;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Text(title!, style: HyperTheme.of(context).textTheme.titleMedium),
        if (description != null)
          Text(description!, style: HyperTheme.of(context).textTheme.bodySmall),
        if (title != null || description != null) SizedBox(height: gap),
        LayoutBuilder(
          builder: (context, constraints) {
            final scope = _FormScope.of(context),
                s = HyperTheme.sizesOf(context).form;
            final style =
                (scope?.style ??
                        HyperFormTheme.of(context).style
                            .merge(HyperTheme.of(context).fieldTheme.style))
                    .merge(HyperFieldTheme.maybeOf(context)?.style);
            final minWidth =
                (style.minimumControlWidth ?? s.minimumControlWidth) +
                (scope?.layout == HyperFieldLayout.horizontal
                    ? (style.labelWidth ?? s.labelWidth) + (style.gap ?? s.gap)
                    : 0);
            final count = constraints.hasBoundedWidth
                ? math.max(
                    1,
                    math.min(
                      columns,
                      ((constraints.maxWidth + gap) / (minWidth + gap)).floor(),
                    ),
                  )
                : 1;
            if (count == 1) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  for (var i = 0; i < children.length; i++) ...[
                    if (i > 0) SizedBox(height: gap),
                    children[i],
                  ],
                ],
              );
            }
            final width = (constraints.maxWidth - gap * (count - 1)) / count;
            return Wrap(
              spacing: gap,
              runSpacing: gap,
              children: [
                for (final child in children)
                  SizedBox(width: width, child: child),
              ],
            );
          },
        ),
      ],
    );
  }
}
