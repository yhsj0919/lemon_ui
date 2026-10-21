import 'package:flutter/material.dart';

import '../button/hyper_button_style.dart';
import '../card/hyper_card_style.dart';
import '../color_picker/hyper_color_picker_field.dart';
import '../color_picker/hyper_color_picker_style.dart';
import '../overlay/hyper_anchored_overlay.dart';
import '../select/hyper_select_model.dart';
import 'hyper_form.dart';

/// A color picker integrated with validation, saving and resetting in HyperForm.
class HyperColorPickerFormField extends HyperFormField<Color> {
  HyperColorPickerFormField({
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
    Color initialValue = const Color(0xFF3482FF),
    bool showAlpha = true,
    HyperColorPickerFieldDisplay display =
        HyperColorPickerFieldDisplay.colorAndValue,
    HyperColorPickerStyle? pickerStyle,
    HyperButtonStyle? buttonStyle,
    HyperCardStyle? panelStyle,
    List<Color> recommendedColors = const [],
    HyperOverlayPlacement placement = HyperOverlayPlacement.bottomStart,
    HyperOverlayTransitionBuilder? transitionBuilder,
    HyperSelectPresentation presentation = HyperSelectPresentation.adaptive,
  }) : super(
         initialValue: initialValue,
         fieldBuilder: (field) => HyperColorPickerField(
           value: field.value ?? initialValue,
           onChanged: field.enabled ? field.didChange : null,
           enabled: field.enabled,
           showAlpha: showAlpha,
           display: display,
           pickerStyle: pickerStyle,
           buttonStyle: buttonStyle,
           panelStyle: panelStyle,
           recommendedColors: recommendedColors,
           placement: placement,
           transitionBuilder: transitionBuilder,
           presentation: presentation,
         ),
       );
}
