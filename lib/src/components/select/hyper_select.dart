import 'package:flutter/material.dart';

import '../../theme/size/components/hyper_button_size.dart';
import '../button/hyper_button_style.dart';
import '../select/hyper_select_style.dart';
import '../menu/hyper_menu_style.dart';
import '../overlay/hyper_anchored_overlay.dart';
import '../text_field/hyper_text_field_style.dart';
import '../select/hyper_select_field.dart';
import '../select/hyper_select_model.dart';
import '../select/hyper_selection_style.dart';
export '../select/hyper_select_model.dart';

class HyperSelect<T> extends StatelessWidget {
  const HyperSelect({
    super.key,
    required this.value,
    required this.onChanged,
    this.options = const [],
    this.source,
    this.selectedOptions = const [],
    this.labelBuilder,
    this.enabled = true,
    this.searchable = false,
    this.allowDeselect = false,
    this.maximumSelection,
    this.placeholder = '请选择',
    this.presentation,
    this.selectionStyle,
    this.style,
    this.buttonStyle,
    this.menuStyle,
    this.inputStyle,
    this.size = HyperButtonSizeVariant.medium,
    this.placement = HyperOverlayPlacement.bottomStart,
    this.transitionBuilder,
    this.createValue,
  }) : values = const {},
       onSelectionChanged = null,
       multiple = false;
  const HyperSelect.multiple({
    super.key,
    required this.values,
    required this.onSelectionChanged,
    this.options = const [],
    this.source,
    this.selectedOptions = const [],
    this.labelBuilder,
    this.enabled = true,
    this.searchable = false,
    this.allowDeselect = false,
    this.maximumSelection,
    this.placeholder = '请选择',
    this.presentation,
    this.selectionStyle,
    this.style,
    this.buttonStyle,
    this.menuStyle,
    this.inputStyle,
    this.size = HyperButtonSizeVariant.medium,
    this.placement = HyperOverlayPlacement.bottomStart,
    this.transitionBuilder,
    this.createValue,
  }) : value = null,
       onChanged = null,
       multiple = true;
  final List<HyperSelectOption<T>> options, selectedOptions;
  final HyperSelectSource<T>? source;
  final T? value;
  final Set<T> values;
  final ValueChanged<T?>? onChanged;
  final ValueChanged<Set<T>>? onSelectionChanged;
  final String Function(T)? labelBuilder;
  final bool multiple, enabled, searchable, allowDeselect;
  final int? maximumSelection;
  final String placeholder;
  final HyperSelectPresentation? presentation;
  final HyperSelectionStyle? selectionStyle;
  final HyperSelectStyle? style;
  final HyperButtonStyle? buttonStyle;
  final HyperMenuStyle? menuStyle;
  final HyperTextFieldStyle? inputStyle;
  final HyperButtonSizeVariant size;
  final HyperOverlayPlacement placement;
  final HyperOverlayTransitionBuilder? transitionBuilder;
  final T Function(String)? createValue;
  @override
  Widget build(BuildContext context) => HyperSelectField<T>(
    options: options,
    source: source,
    selectedOptions: selectedOptions,
    labelBuilder: labelBuilder,
    values: multiple ? values : {if (value != null) value as T},
    onChanged: multiple
        ? onSelectionChanged
        : onChanged == null
        ? null
        : (values) => onChanged!(values.isEmpty ? null : values.first),
    multiple: multiple,
    autocomplete: false,
    enabled: enabled,
    searchable: searchable,
    allowDeselect: allowDeselect,
    maximumSelection: maximumSelection,
    placeholder: placeholder,
    presentation: presentation,
    selectionStyle: selectionStyle,
    selectStyle: style,
    buttonStyle: buttonStyle,
    inputStyle: inputStyle,
    menuStyle: menuStyle,
    size: size,
    placement: placement,
    transitionBuilder: transitionBuilder,
    createValue: createValue,
  );
}
