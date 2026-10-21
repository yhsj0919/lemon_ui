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
  }) : isNavigation = false,
       enabled = true,
       onStepChanged = null;

  /// 可交互的受控步骤导航，流程验证和内容切换由调用方管理。
  const HyperStepIndicator.navigation({
    super.key,
    required this.items,
    required this.currentStep,
    this.onStepChanged,
    this.enabled = true,
    this.direction = Axis.horizontal,
    this.style,
  }) : isNavigation = true;

  final bool isNavigation;
  final bool enabled;
  final ValueChanged<int>? onStepChanged;
  final List<HyperStepItem> items;
  final int currentStep;
  final Axis direction;
  final HyperStepStyle? style;
  @override
  Widget build(BuildContext context) {
    final sizes = HyperTheme.sizesOf(context);
    final theme = HyperStepIndicatorTheme.of(context);
    return HyperStepsBody(
      model: HyperStepModel(items: items, currentStep: currentStep),
      direction: direction,
      metrics: isNavigation
          ? sizes.stepIndicator.navigation
          : sizes.stepIndicator,
      resolveTheme: (status) => theme.resolve(status, navigation: isNavigation),
      style: style,
      enabled: enabled,
      onStepChanged: onStepChanged,
    );
  }
}
