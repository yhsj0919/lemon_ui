import '../file_picker/hyper_file_picker.dart';

import 'package:flutter/widgets.dart';

import '../card/hyper_card_style.dart';
import 'hyper_form.dart';

class HyperFileFormField extends HyperFormField<List<HyperFileSelection>> {
  HyperFileFormField({
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
    List<HyperFileSelection> initialValue = const [],
    required HyperFilePickCallback pick,
    HyperFileDropBuilder? dropBuilder,
    bool multiple = true,
    int? maxFiles,
    int? maxFileSize,
    List<String>? allowedExtensions,
    HyperCardStyle? pickerStyle,
    HyperFilePickerVariant variant = HyperFilePickerVariant.dropzone,
    HyperFileUploadState? Function(HyperFileSelection)? uploadState,
    ValueChanged<HyperFileSelection>? onRetry,
    ValueChanged<HyperFileSelection>? onCancel,
    Widget? Function(BuildContext, HyperFileSelection)? thumbnailBuilder,
  }) : super(
         initialValue: List.unmodifiable(initialValue),
         fieldBuilder: (f) => HyperFilePicker(
           files: f.value ?? const [],
           onChanged: f.enabled ? f.didChange : null,
           enabled: f.enabled,
           pick: pick,
           dropBuilder: dropBuilder,
           multiple: multiple,
           maxFiles: maxFiles,
           maxFileSize: maxFileSize,
           allowedExtensions: allowedExtensions,
           style: pickerStyle,
           variant: variant,
           uploadState: uploadState,
           onRetry: onRetry,
           onCancel: onCancel,
           thumbnailBuilder: thumbnailBuilder,
         ),
       );
}
