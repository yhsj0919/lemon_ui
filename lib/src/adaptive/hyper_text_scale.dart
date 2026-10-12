import 'package:flutter/widgets.dart';

/// 指定子树的文字缩放策略。
enum HyperTextScalePolicy { system, limited, disabled }

/// 默认跟随系统；限制策略保留系统的非线性文字缩放。
class HyperTextScale extends StatelessWidget {
  const HyperTextScale({
    super.key,
    this.policy = HyperTextScalePolicy.system,
    this.minScaleFactor = 0,
    this.maxScaleFactor = 2,
    required this.child,
  }) : assert(minScaleFactor >= 0),
       assert(maxScaleFactor >= minScaleFactor);

  final HyperTextScalePolicy policy;
  final double minScaleFactor;
  final double maxScaleFactor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final scaler = switch (policy) {
      HyperTextScalePolicy.system => media.textScaler,
      HyperTextScalePolicy.limited => media.textScaler.clamp(
        minScaleFactor: minScaleFactor,
        maxScaleFactor: maxScaleFactor,
      ),
      HyperTextScalePolicy.disabled => TextScaler.noScaling,
    };
    return MediaQuery(
      data: media.copyWith(textScaler: scaler),
      child: child,
    );
  }
}
