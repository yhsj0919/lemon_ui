import 'package:flutter/widgets.dart';

import '../../foundation/hyper_control_state.dart';
import '../../theme/core/hyper_theme.dart';
import 'hyper_notification_style.dart';

@immutable
final class HyperNotificationThemeData {
  const HyperNotificationThemeData({
    this.style = const HyperNotificationStyle(),
    this.read,
    this.unread,
    this.hovered,
    this.focused,
    this.pressed,
    this.disabled,
  });
  final HyperNotificationStyle style;
  final HyperNotificationStyle? read;
  final HyperNotificationStyle? unread;
  final HyperNotificationStyle? hovered;
  final HyperNotificationStyle? focused;
  final HyperNotificationStyle? pressed;
  final HyperNotificationStyle? disabled;
  HyperNotificationStyle resolve({
    required bool isRead,
    Set<HyperControlState> states = const {},
  }) {
    var result = style.merge(isRead ? read : unread);
    if (states.contains(HyperControlState.hovered)) {
      result = result.merge(hovered);
    }
    if (states.contains(HyperControlState.focused)) {
      result = result.merge(focused);
    }
    if (states.contains(HyperControlState.pressed)) {
      result = result.merge(pressed);
    }
    if (states.contains(HyperControlState.disabled)) {
      result = result.merge(disabled);
    }
    return result;
  }

  HyperNotificationThemeData copyWith({
    HyperNotificationStyle? style,
    HyperNotificationStyle? read,
    HyperNotificationStyle? unread,
    HyperNotificationStyle? hovered,
    HyperNotificationStyle? focused,
    HyperNotificationStyle? pressed,
    HyperNotificationStyle? disabled,
  }) => HyperNotificationThemeData(
    style: style ?? this.style,
    read: read ?? this.read,
    unread: unread ?? this.unread,
    hovered: hovered ?? this.hovered,
    focused: focused ?? this.focused,
    pressed: pressed ?? this.pressed,
    disabled: disabled ?? this.disabled,
  );
  HyperNotificationThemeData merge(HyperNotificationThemeData? other) =>
      other == null
      ? this
      : HyperNotificationThemeData(
          style: style.merge(other.style),
          read: read?.merge(other.read) ?? other.read,
          unread: unread?.merge(other.unread) ?? other.unread,
          hovered: hovered?.merge(other.hovered) ?? other.hovered,
          focused: focused?.merge(other.focused) ?? other.focused,
          pressed: pressed?.merge(other.pressed) ?? other.pressed,
          disabled: disabled?.merge(other.disabled) ?? other.disabled,
        );
  static HyperNotificationThemeData lerp(
    HyperNotificationThemeData a,
    HyperNotificationThemeData b,
    double t,
  ) {
    HyperNotificationStyle? blend(
      HyperNotificationStyle? x,
      HyperNotificationStyle? y,
    ) => x == null || y == null
        ? (t < .5 ? x : y)
        : HyperNotificationStyle.lerp(x, y, t);
    return HyperNotificationThemeData(
      style: HyperNotificationStyle.lerp(a.style, b.style, t),
      read: blend(a.read, b.read),
      unread: blend(a.unread, b.unread),
      hovered: blend(a.hovered, b.hovered),
      focused: blend(a.focused, b.focused),
      pressed: blend(a.pressed, b.pressed),
      disabled: blend(a.disabled, b.disabled),
    );
  }

  @override
  bool operator ==(Object other) =>
      other is HyperNotificationThemeData &&
      style == other.style &&
      read == other.read &&
      unread == other.unread &&
      hovered == other.hovered &&
      focused == other.focused &&
      pressed == other.pressed &&
      disabled == other.disabled;
  @override
  int get hashCode => Object.hashAll([
    style,
    read,
    unread,
    hovered,
    focused,
    pressed,
    disabled,
  ]);
}

class HyperNotificationTheme extends StatelessWidget {
  const HyperNotificationTheme({
    super.key,
    required this.data,
    required this.child,
  });
  final HyperNotificationThemeData data;
  final Widget child;
  static HyperNotificationThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).notificationTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperNotificationThemeData data;
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
}
