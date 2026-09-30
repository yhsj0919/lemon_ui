import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_avatar_style.dart';

@immutable
final class HyperAvatarThemeData {
  const HyperAvatarThemeData({
    this.style = const HyperAvatarStyle(),
    this.groupStyle = const HyperAvatarStyle(),
  });
  final HyperAvatarStyle style, groupStyle;
  HyperAvatarThemeData copyWith({
    HyperAvatarStyle? style,
    HyperAvatarStyle? groupStyle,
  }) => HyperAvatarThemeData(
    style: style ?? this.style,
    groupStyle: groupStyle ?? this.groupStyle,
  );
  HyperAvatarThemeData merge(HyperAvatarThemeData? other) => other == null
      ? this
      : HyperAvatarThemeData(
          style: style.merge(other.style),
          groupStyle: groupStyle.merge(other.groupStyle),
        );
  static HyperAvatarThemeData lerp(
    HyperAvatarThemeData a,
    HyperAvatarThemeData b,
    double t,
  ) => a == b
      ? a
      : HyperAvatarThemeData(
          style: HyperAvatarStyle.lerp(a.style, b.style, t),
          groupStyle: HyperAvatarStyle.lerp(a.groupStyle, b.groupStyle, t),
        );
  @override
  bool operator ==(Object other) =>
      other is HyperAvatarThemeData &&
      other.style == style &&
      other.groupStyle == groupStyle;
  @override
  int get hashCode => Object.hash(style, groupStyle);
}

class HyperAvatarTheme extends StatelessWidget {
  const HyperAvatarTheme({super.key, required this.data, required this.child});
  final HyperAvatarThemeData data;
  final Widget child;
  static HyperAvatarThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_AvatarScope>()?.data ??
      HyperTheme.of(context).avatarTheme;
  @override
  Widget build(BuildContext context) =>
      _AvatarScope(data: of(context).merge(data), child: child);
}

class _AvatarScope extends InheritedTheme {
  const _AvatarScope({required this.data, required super.child});
  final HyperAvatarThemeData data;
  @override
  bool updateShouldNotify(_AvatarScope oldWidget) => data != oldWidget.data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _AvatarScope(data: data, child: child);
}
