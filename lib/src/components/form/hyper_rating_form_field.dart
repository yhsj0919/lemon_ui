import '../rating/hyper_rating.dart';
import '../rating/hyper_rating_style.dart';
import 'hyper_form.dart';

class HyperRatingFormField extends HyperFormField<double> {
  HyperRatingFormField({
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
    int count = 5,
    double step = .5,
    bool readOnly = false,
    HyperRatingStyle? ratingStyle,
  }) : super(
         fieldBuilder: (f) => HyperRating(
           value: f.value ?? 0,
           count: count,
           step: step,
           enabled: f.enabled,
           readOnly: readOnly,
           focusNode: f.focusNode,
           style: ratingStyle,
           onChanged: f.enabled ? f.didChange : null,
         ),
       );
}
