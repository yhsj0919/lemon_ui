part of 'hyper_container.dart';

class _HyperImageGradientContainer extends HyperContainer {
  const _HyperImageGradientContainer({
    super.key,
    required this.image,
    required this.startColor,
    required this.colorRole,
    this.colorStrength,
    this.fallbackColor,
    required this.begin,
    required this.end,
    this.onColorExtracted,
    this.onImageError,
    this.stops,
    super.child,
    super.material,
    super.border,
    super.borderRadius,
    super.boxShadow,
    super.padding,
    super.margin,
    super.alignment,
    super.width,
    super.height,
    super.constraints,
    super.animationDuration,
    super.animationCurve,
    super.clipBehavior,
  });
  final ImageProvider image;
  final Color startColor;
  final HyperImageColorRole colorRole;
  final double? colorStrength;
  final Color? fallbackColor;
  final AlignmentGeometry begin, end;
  final List<double>? stops;
  final ValueChanged<Color>? onColorExtracted;
  final ValueChanged<Object>? onImageError;

  @override
  Widget build(BuildContext context) => _ImageGradientBody(configuration: this);
}

class _ImageGradientBody extends StatefulWidget {
  const _ImageGradientBody({required this.configuration});
  final _HyperImageGradientContainer configuration;
  @override
  State<_ImageGradientBody> createState() => _ImageGradientBodyState();
}

class _ImageGradientBodyState extends State<_ImageGradientBody> {
  Color? _color;
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(_ImageGradientBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.configuration.image != widget.configuration.image ||
        oldWidget.configuration.colorRole != widget.configuration.colorRole) {
      _load();
    }
  }

  Future<void> _load() async {
    final generation = ++_generation;
    _color = null;
    try {
      final color = await HyperImageColors.fromImageProvider(
        widget.configuration.image,
        role: widget.configuration.colorRole,
      );
      if (!mounted || generation != _generation) return;
      setState(() => _color = color);
      widget.configuration.onColorExtracted?.call(color);
    } catch (error) {
      if (!mounted || generation != _generation) return;
      widget.configuration.onImageError?.call(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.configuration;
    final theme = HyperTheme.of(context);
    final duration = MediaQuery.maybeOf(context)?.disableAnimations == true
        ? Duration.zero
        : c.animationDuration ??
              theme.containerTheme.animationDuration ??
              theme.motion.standardDuration;
    final strength =
        c.colorStrength ?? theme.containerTheme.imageColorStrength ?? .2;
    final endColor = _color == null
        ? c.fallbackColor ?? c.startColor
        : Color.lerp(c.startColor, _color, strength)!;
    return TweenAnimationBuilder<Color?>(
      tween: ColorTween(begin: endColor, end: endColor),
      duration: duration,
      curve:
          c.animationCurve ??
          theme.containerTheme.animationCurve ??
          theme.motion.standardCurve,
      child: c.child,
      builder: (context, color, child) => HyperContainer(
        background: HyperFill.gradient(
          LinearGradient(
            begin: c.begin,
            end: c.end,
            stops: c.stops,
            colors: [c.startColor, color ?? endColor],
          ),
        ),
        material: c.material,
        border: c.border,
        borderRadius: c.borderRadius,
        boxShadow: c.boxShadow,
        padding: c.padding,
        margin: c.margin,
        alignment: c.alignment,
        width: c.width,
        height: c.height,
        constraints: c.constraints,
        animationDuration: c.animationDuration,
        animationCurve: c.animationCurve,
        clipBehavior: c.clipBehavior,
        child: child,
      ),
    );
  }
}
