import 'package:flutter/widgets.dart';

import '../../theme/core/hyper_theme.dart';
import 'hyper_image_style.dart';

/// Surface appearances independent of loading state and layout.
enum HyperImageVariant { plain, outlined, elevated }

/// The decoded image lifecycle exposed without backend-specific types.
enum HyperImageLoadState { loading, completed, failed }

@immutable
final class HyperImageAppearance {
  const HyperImageAppearance({
    this.style = const HyperImageStyle(),
    this.loading = const HyperImageStyle(),
    this.completed = const HyperImageStyle(),
    this.failed = const HyperImageStyle(),
  });
  final HyperImageStyle style;
  final HyperImageStyle loading;
  final HyperImageStyle completed;
  final HyperImageStyle failed;
  HyperImageAppearance copyWith({
    HyperImageStyle? style,
    HyperImageStyle? loading,
    HyperImageStyle? completed,
    HyperImageStyle? failed,
  }) => HyperImageAppearance(
    style: this.style.merge(style),
    loading: this.loading.merge(loading),
    completed: this.completed.merge(completed),
    failed: this.failed.merge(failed),
  );
  HyperImageAppearance merge(HyperImageAppearance? other) => copyWith(
    style: other?.style,
    loading: other?.loading,
    completed: other?.completed,
    failed: other?.failed,
  );
  static HyperImageAppearance lerp(
    HyperImageAppearance a,
    HyperImageAppearance b,
    double t,
  ) => HyperImageAppearance(
    style: HyperImageStyle.lerp(a.style, b.style, t),
    loading: HyperImageStyle.lerp(a.loading, b.loading, t),
    completed: HyperImageStyle.lerp(a.completed, b.completed, t),
    failed: HyperImageStyle.lerp(a.failed, b.failed, t),
  );
  HyperImageStyle forState(HyperImageLoadState state) => switch (state) {
    HyperImageLoadState.loading => loading,
    HyperImageLoadState.completed => completed,
    HyperImageLoadState.failed => failed,
  };
  @override
  bool operator ==(Object other) =>
      other is HyperImageAppearance &&
      style == other.style &&
      loading == other.loading &&
      completed == other.completed &&
      failed == other.failed;
  @override
  int get hashCode => Object.hash(style, loading, completed, failed);
}

@immutable
final class HyperImageThemeData {
  const HyperImageThemeData({
    this.appearance = const HyperImageAppearance(),
    this.plain = const HyperImageAppearance(),
    this.outlined = const HyperImageAppearance(),
    this.elevated = const HyperImageAppearance(),
  });
  final HyperImageAppearance appearance;
  final HyperImageAppearance plain;
  final HyperImageAppearance outlined;
  final HyperImageAppearance elevated;
  HyperImageThemeData copyWith({
    HyperImageAppearance? appearance,
    HyperImageAppearance? plain,
    HyperImageAppearance? outlined,
    HyperImageAppearance? elevated,
  }) => HyperImageThemeData(
    appearance: this.appearance.merge(appearance),
    plain: this.plain.merge(plain),
    outlined: this.outlined.merge(outlined),
    elevated: this.elevated.merge(elevated),
  );
  HyperImageThemeData merge(HyperImageThemeData? other) => copyWith(
    appearance: other?.appearance,
    plain: other?.plain,
    outlined: other?.outlined,
    elevated: other?.elevated,
  );
  static HyperImageThemeData lerp(
    HyperImageThemeData a,
    HyperImageThemeData b,
    double t,
  ) => HyperImageThemeData(
    appearance: HyperImageAppearance.lerp(a.appearance, b.appearance, t),
    plain: HyperImageAppearance.lerp(a.plain, b.plain, t),
    outlined: HyperImageAppearance.lerp(a.outlined, b.outlined, t),
    elevated: HyperImageAppearance.lerp(a.elevated, b.elevated, t),
  );
  HyperImageAppearance forVariant(HyperImageVariant variant) =>
      switch (variant) {
        HyperImageVariant.plain => plain,
        HyperImageVariant.outlined => outlined,
        HyperImageVariant.elevated => elevated,
      };
  HyperImageStyle resolve(
    HyperImageVariant variant,
    HyperImageLoadState state,
  ) {
    final v = forVariant(variant);
    return appearance.style
        .merge(v.style)
        .merge(appearance.forState(state))
        .merge(v.forState(state));
  }

  @override
  bool operator ==(Object other) =>
      other is HyperImageThemeData &&
      appearance == other.appearance &&
      plain == other.plain &&
      outlined == other.outlined &&
      elevated == other.elevated;
  @override
  int get hashCode => Object.hash(appearance, plain, outlined, elevated);
}

class HyperImageTheme extends StatelessWidget {
  const HyperImageTheme({super.key, required this.data, required this.child});
  final HyperImageThemeData data;
  final Widget child;
  static HyperImageThemeData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<_Scope>()?.data ??
      HyperTheme.of(context).imageTheme;
  @override
  Widget build(BuildContext context) =>
      _Scope(data: of(context).merge(data), child: child);
}

class _Scope extends InheritedTheme {
  const _Scope({required this.data, required super.child});
  final HyperImageThemeData data;
  @override
  Widget wrap(BuildContext context, Widget child) =>
      _Scope(data: data, child: child);
  @override
  bool updateShouldNotify(_Scope oldWidget) => data != oldWidget.data;
}
