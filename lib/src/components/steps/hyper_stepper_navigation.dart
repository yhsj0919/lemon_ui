import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_stepper_navigation_theme.dart';
import 'hyper_step_model.dart';
import 'hyper_step_style.dart';
import 'hyper_steps_body.dart';

class HyperStepperNavigation extends StatelessWidget {
  const HyperStepperNavigation({
    super.key,
    required this.items,
    required this.currentStep,
    this.onStepChanged,
    this.enabled = true,
    this.direction = Axis.horizontal,
    this.style,
  });
  final List<HyperStepItem> items;
  final int currentStep;
  final ValueChanged<int>? onStepChanged;
  final bool enabled;
  final Axis direction;
  final HyperStepStyle? style;
  @override
  Widget build(BuildContext context) => HyperStepsBody(
    model: HyperStepModel(items: items, currentStep: currentStep),
    direction: direction,
    metrics: HyperTheme.sizesOf(context).stepperNavigation,
    resolveTheme: HyperStepperNavigationTheme.of(context).resolve,
    style: style,
    enabled: enabled,
    onStepChanged: onStepChanged,
  );
}
