import 'package:flutter/widgets.dart';

/// Internal ownership shared by an editor and its anchored overlay descendants.
class HyperTapRegionScope extends InheritedWidget {
  const HyperTapRegionScope({
    super.key,
    required this.groupId,
    required super.child,
  });

  final Object groupId;

  static Object? maybeOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<HyperTapRegionScope>()
      ?.groupId;

  @override
  bool updateShouldNotify(HyperTapRegionScope oldWidget) =>
      groupId != oldWidget.groupId;
}
