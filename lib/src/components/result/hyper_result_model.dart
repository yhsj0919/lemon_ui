import 'package:flutter/material.dart';

import '../../theme/color/hyper_color_scheme.dart';

enum HyperResultStatus { neutral, success, error, warning, info, empty }

/// 默认图标和颜色只有状态语义，不自动决定标题或业务操作。
extension HyperResultStatusVisuals on HyperResultStatus {
  IconData get icon => switch (this) {
    HyperResultStatus.empty => Icons.inbox_outlined,
    HyperResultStatus.neutral => Icons.task_alt_outlined,
    HyperResultStatus.success => Icons.check_circle_outline,
    HyperResultStatus.error => Icons.error_outline,
    HyperResultStatus.warning => Icons.warning_amber_rounded,
    HyperResultStatus.info => Icons.info_outline,
  };
  Color color(HyperColorScheme colors) => switch (this) {
    HyperResultStatus.empty => colors.textTertiary,
    HyperResultStatus.neutral => colors.textSecondary,
    HyperResultStatus.success => colors.success,
    HyperResultStatus.error => colors.error,
    HyperResultStatus.warning => colors.warning,
    HyperResultStatus.info => colors.primary,
  };
}
