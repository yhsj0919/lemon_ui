import '../autocomplete/hyper_autocomplete.dart';
import '../select/hyper_select_style.dart';
import '../text_field/hyper_text_field_style.dart';
import 'hyper_form.dart';

/// Autocomplete selection participates in Form validation, reset and submit.
class HyperAutocompleteFormField<T> extends HyperFormField<T> {
  HyperAutocompleteFormField({
    super.key,
    super.name,
    super.label,
    super.semanticLabel,
    super.description,
    super.requiredIndicator,
    super.layout,
    super.errorDisplay,
    super.style,
    super.initialValue,
    super.validator,
    super.asyncValidator,
    super.onSaved,
    super.onReset,
    super.onChanged,
    super.enabled,
    super.autovalidateMode,
    super.focusNode,
    List<HyperSelectOption<T>> options = const [],
    HyperSelectSource<T>? source,
    List<HyperSelectOption<T>> selectedOptions = const [],
    String Function(T)? labelBuilder,
    T Function(String)? createValue,
    String placeholder = '输入搜索',
    HyperSelectPresentation? presentation,
    HyperSelectStyle? selectStyle,
    HyperTextFieldStyle? inputStyle,
  }) : super(
         fieldBuilder: (f) => HyperAutocomplete<T>(
           value: f.value,
           onChanged: f.enabled ? f.didChange : null,
           options: options,
           source: source,
           selectedOptions: selectedOptions,
           labelBuilder: labelBuilder,
           createValue: createValue,
           placeholder: placeholder,
           presentation: presentation,
           style: selectStyle,
           inputStyle: inputStyle,
           enabled: f.enabled,
         ),
       );
}

/// Multi autocomplete uses immutable set values, matching multi select.
class HyperMultiAutocompleteFormField<T> extends HyperFormField<Set<T>> {
  HyperMultiAutocompleteFormField({
    super.key,
    super.name,
    super.label,
    super.semanticLabel,
    super.description,
    super.requiredIndicator,
    super.layout,
    super.errorDisplay,
    super.style,
    super.validator,
    super.asyncValidator,
    super.onSaved,
    super.onReset,
    super.onChanged,
    super.enabled,
    super.autovalidateMode,
    super.focusNode,
    Set<T> initialValue = const {},
    List<HyperSelectOption<T>> options = const [],
    HyperSelectSource<T>? source,
    List<HyperSelectOption<T>> selectedOptions = const [],
    String Function(T)? labelBuilder,
    T Function(String)? createValue,
    int? maximumSelection,
    String placeholder = '输入搜索',
    HyperSelectPresentation? presentation,
    HyperSelectStyle? selectStyle,
    HyperTextFieldStyle? inputStyle,
  }) : super(
         initialValue: Set<T>.unmodifiable(initialValue),
         fieldBuilder: (f) => HyperAutocomplete<T>.multiple(
           values: f.value ?? <T>{},
           onSelectionChanged: f.enabled
               ? (v) => f.didChange(Set<T>.unmodifiable(v))
               : null,
           options: options,
           source: source,
           selectedOptions: selectedOptions,
           labelBuilder: labelBuilder,
           createValue: createValue,
           maximumSelection: maximumSelection,
           placeholder: placeholder,
           presentation: presentation,
           style: selectStyle,
           inputStyle: inputStyle,
           enabled: f.enabled,
         ),
       );
}
