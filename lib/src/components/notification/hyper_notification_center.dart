import 'package:flutter/material.dart';

import '../../theme/core/hyper_theme.dart';
import '../button/hyper_button.dart';
import '../button/hyper_button_theme.dart';
import '../empty_state/hyper_empty_state.dart';
import 'hyper_notification.dart';
import 'hyper_notification_entry.dart';
import 'hyper_notification_theme.dart';
import 'hyper_notification_center_style.dart';
import 'hyper_notification_center_theme.dart';

typedef HyperNotificationItemBuilder = Widget Function(
  BuildContext context,
  HyperNotificationEntry entry,
);
typedef HyperNotificationGroupBuilder = Widget Function(
  BuildContext context,
  HyperNotificationGroup group,
);

/// 页面内受控通知列表。默认占用父级有限高度；嵌入外部滚动区域时开启 shrinkWrap。
class HyperNotificationCenter extends StatelessWidget {
  const HyperNotificationCenter({
    super.key,
    required this.entries,
    this.onTap,
    this.onMarkRead,
    this.onRemove,
    this.onMarkAllRead,
    this.onClear,
    this.itemBuilder,
    this.groupBuilder,
    this.header,
    this.empty,
    this.showHeader = true,
    this.showUnreadCount = true,
    this.grouped = true,
    this.enabled = true,
    this.shrinkWrap = false,
    this.controller,
    this.physics,
    this.style,
  });
  final List<HyperNotificationEntry> entries;
  final ValueChanged<HyperNotificationEntry>? onTap, onMarkRead, onRemove;
  final VoidCallback? onMarkAllRead, onClear;
  final HyperNotificationItemBuilder? itemBuilder;
  final HyperNotificationGroupBuilder? groupBuilder;
  final Widget? header, empty;
  final bool showHeader, showUnreadCount, grouped, enabled, shrinkWrap;
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final HyperNotificationCenterStyle? style;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final metrics = HyperTheme.sizesOf(context).notificationCenter;
    final resolved = HyperNotificationCenterStyle(
      padding: metrics.padding,
      spacing: metrics.spacing,
      groupSpacing: metrics.groupSpacing,
      titleStyle: theme.textTheme.titleMedium?.copyWith(
        color: theme.colors.textPrimary,
      ),
      groupStyle: theme.textTheme.bodySmall?.copyWith(
        color: theme.colors.textSecondary,
      ),
      countStyle: theme.textTheme.bodySmall?.copyWith(
        color: theme.colors.textSecondary,
      ),
      title: '通知',
      unreadCountLabel: '未读',
      markReadLabel: '标记已读',
      markAllReadLabel: '全部已读',
      clearLabel: '清空',
      emptyTitle: '暂无通知',
      emptyDescription: '新通知会显示在这里',
      duration: theme.motion.fastDuration,
      curve: theme.motion.fastCurve,
    ).merge(HyperNotificationCenterTheme.of(context).style).merge(style);
    final snapshot = HyperNotificationSnapshot(entries, grouped: grouped);
    final duration = (MediaQuery.maybeOf(context)?.disableAnimations ?? false)
        ? Duration.zero
        : resolved.duration!;
    Widget button(Widget child) => resolved.buttonTheme == null
        ? child
        : HyperButtonTheme(data: resolved.buttonTheme!, child: child);
    Widget label(TextStyle textStyle, Widget child) => AnimatedDefaultTextStyle(
      style: textStyle,
      duration: duration,
      curve: resolved.curve!,
      child: child,
    );
    final heading =
        header ??
        Wrap(
          spacing: resolved.spacing!,
          runSpacing: resolved.spacing!,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            label(resolved.titleStyle!, Text(resolved.title!)),
            if (showUnreadCount)
              label(
                resolved.countStyle!,
                Text('${snapshot.unreadCount} ${resolved.unreadCountLabel}'),
              ),
            if (onMarkAllRead != null)
              button(
                HyperButton.text(
                  label: Text(resolved.markAllReadLabel!),
                  onPressed: enabled && snapshot.unreadCount > 0
                      ? onMarkAllRead
                      : null,
                ),
              ),
            if (onClear != null)
              button(
                HyperButton.text(
                  label: Text(resolved.clearLabel!),
                  onPressed: enabled && entries.isNotEmpty ? onClear : null,
                ),
              ),
          ],
        );
    // 扁平行描述只保存数据；可见行才构建实际通知 Widget。
    final rows = <Object>[];
    for (final group in snapshot.groups) {
      if (group.label != null) {
        rows.add(group);
      }
      rows.addAll(group.entries);
    }
    Widget item(BuildContext context, HyperNotificationEntry entry) {
      Widget result =
          itemBuilder?.call(context, entry) ??
          HyperNotification(
            key: ValueKey(entry.id),
            content: entry.content,
            title: entry.title,
            time: entry.time,
            icon: entry.icon,
            isRead: entry.isRead,
            enabled: enabled && entry.enabled,
            actions: [
              ...entry.actions,
              if (onMarkRead != null && !entry.isRead)
                button(
                  HyperButton.text(
                    label: Text(resolved.markReadLabel!),
                    onPressed: enabled && entry.enabled
                        ? () => onMarkRead!(entry)
                        : null,
                  ),
                ),
            ],
            onTap: onTap == null ? null : () => onTap!(entry),
            onClose: onRemove == null ? null : () => onRemove!(entry),
            style: entry.style,
          );
      if (resolved.notificationTheme != null) {
        result = HyperNotificationTheme(
          data: resolved.notificationTheme!,
          child: result,
        );
      }
      return IgnorePointer(
        ignoring: !enabled || !entry.enabled,
        child: ExcludeFocus(
          excluding: !enabled || !entry.enabled,
          child: result,
        ),
      );
    }

    final list = ListView.builder(
      key: const ValueKey('notifications'),
      controller: controller,
      physics:
          physics ?? (shrinkWrap ? const NeverScrollableScrollPhysics() : null),
      primary: false,
      shrinkWrap: shrinkWrap,
      padding: EdgeInsets.zero,
      itemCount: rows.length,
      findChildIndexCallback: (key) {
        if (key is! ValueKey<Object>) {
          return null;
        }
        final index = rows.indexWhere(
          (row) => row is HyperNotificationEntry && row.id == key.value,
        );
        return index < 0 ? null : index;
      },
      itemBuilder: (context, index) {
        final row = rows[index];
        if (row is HyperNotificationGroup) {
          return Padding(
            padding: EdgeInsets.only(
              top: index == 0 ? 0 : resolved.groupSpacing!,
              bottom: resolved.spacing!,
            ),
            child:
                groupBuilder?.call(context, row) ??
                label(resolved.groupStyle!, Text(row.label!)),
          );
        }
        final entry = row as HyperNotificationEntry;
        return Padding(
          key: ValueKey(entry.id),
          padding: EdgeInsets.only(
            bottom:
                index == rows.length - 1 ||
                    rows[index + 1] is HyperNotificationGroup
                ? 0
                : resolved.spacing!,
          ),
          child: item(context, entry),
        );
      },
    );
    final body = AnimatedSwitcher(
      duration: duration,
      switchInCurve: resolved.curve!,
      switchOutCurve: resolved.curve!,
      transitionBuilder:
          resolved.transitionBuilder ??
          AnimatedSwitcher.defaultTransitionBuilder,
      // 单一滚动列表保持稳定；仅空状态与列表之间做默认过渡。
      layoutBuilder: (current, previous) => Stack(
        fit: shrinkWrap ? StackFit.loose : StackFit.expand,
        alignment: Alignment.topCenter,
        children: [
          for (final child in previous)
            IgnorePointer(
              child: ExcludeFocus(child: ExcludeSemantics(child: child)),
            ),
          ?current,
        ],
      ),
      child: rows.isEmpty
          ? KeyedSubtree(
              key: const ValueKey('empty'),
              child:
                  empty ??
                  HyperEmptyState(
                    title: resolved.emptyTitle,
                    description: resolved.emptyDescription,
                    icon:
                        resolved.emptyStateStyle?.icon ??
                        Icons.notifications_none,
                    style: resolved.emptyStateStyle,
                  ),
            )
          : list,
    );
    final result = Padding(
      padding: resolved.padding!,
      child: Column(
        mainAxisSize: shrinkWrap ? MainAxisSize.min : MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (showHeader) ...[heading, SizedBox(height: resolved.groupSpacing)],
          if (shrinkWrap) body else Expanded(child: body),
        ],
      ),
    );
    return IgnorePointer(
      ignoring: !enabled,
      child: ExcludeFocus(
        excluding: !enabled,
        child: Semantics(enabled: enabled, child: result),
      ),
    );
  }
}
