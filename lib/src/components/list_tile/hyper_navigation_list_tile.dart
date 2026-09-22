import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../icon/hyper_icon.dart';
import 'hyper_list_tile.dart';
import 'hyper_list_tile_style.dart';
import 'hyper_list_tile_theme.dart';

/// 表示进入下一级页面的列表项。
///
/// [description] 用于显示当前值或状态，末尾的 chevron 由组件统一提供，
/// 调用方不需要自行组合图标、间距和颜色。
class HyperNavigationListTile extends StatelessWidget {
  const HyperNavigationListTile({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.leading,
    this.description,
    this.density = HyperListTileDensity.standard,
    this.enabled = true,
    this.autofocus = false,
    this.focusNode,
    this.semanticLabel,
    this.style,
  });

  final Widget title;
  final Widget? subtitle;
  final Widget? leading;

  /// chevron 前的当前值或状态说明。
  final Widget? description;

  final HyperListTileDensity density;
  final VoidCallback? onTap;
  final bool enabled;
  final bool autofocus;
  final FocusNode? focusNode;
  final String? semanticLabel;
  final HyperListTileStyle? style;

  @override
  Widget build(BuildContext context) {
    final metrics = HyperTheme.sizesOf(context).listTile;
    final themedStyle = HyperListTileTheme.of(context).style;
    final spacing =
        style?.trailingSpacing ??
        themedStyle?.trailingSpacing ??
        metrics.navigationSpacing;
    final navigationStyle = HyperListTileStyle(
      trailingSpacing: spacing,
      trailingIconSize:
          style?.trailingIconSize ??
          themedStyle?.trailingIconSize ??
          metrics.navigationIconSize,
    ).merge(style);
    return HyperListTile(
      title: title,
      subtitle: subtitle,
      leading: leading,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (description != null) ...[description!, SizedBox(width: spacing)],
          const HyperIcon(Icons.chevron_right),
        ],
      ),
      density: density,
      onTap: onTap,
      enabled: enabled,
      autofocus: autofocus,
      focusNode: focusNode,
      semanticLabel: semanticLabel,
      style: navigationStyle,
    );
  }
}
