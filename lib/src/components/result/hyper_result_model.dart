import '../../foundation/hyper_icons.dart';

import 'package:flutter/material.dart';

import '../../theme/color/hyper_color_scheme.dart';

enum HyperResultStatus { neutral, success, error, warning, info, empty }

/// 默认图标和颜色只有状态语义，不自动决定标题或业务操作。
extension HyperResultStatusVisuals on HyperResultStatus {
  IconData get icon => switch (this) {
    HyperResultStatus.empty => HyperIcons.inbox,
    HyperResultStatus.neutral => HyperIcons.badgeCheck,
    HyperResultStatus.success => HyperIcons.circleCheck,
    HyperResultStatus.error => HyperIcons.circleAlert,
    HyperResultStatus.warning => HyperIcons.triangleAlert,
    HyperResultStatus.info => HyperIcons.info,
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
