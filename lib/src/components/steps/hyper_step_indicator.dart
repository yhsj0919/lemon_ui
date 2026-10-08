import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_step_indicator_theme.dart';
import 'hyper_step_model.dart';
import 'hyper_step_style.dart';
import 'hyper_steps_body.dart';

class HyperStepIndicator extends StatelessWidget {
  const HyperStepIndicator({
    super.key,
    required this.items,
    required this.currentStep,
    this.direction = Axis.horizontal,
    this.style,
  });
  final List<HyperStepItem> items;
  final int currentStep;
  final Axis direction;
  final HyperStepStyle? style;
  @override
  Widget build(BuildContext context) => HyperStepsBody(
    model: HyperStepModel(items: items, currentStep: currentStep),
    direction: direction,
    metrics: HyperTheme.sizesOf(context).stepIndicator,
    resolveTheme: HyperStepIndicatorTheme.of(context).resolve,
    style: style,
  );
}
