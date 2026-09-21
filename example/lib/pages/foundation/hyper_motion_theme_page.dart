import 'package:flutter/material.dart';
import 'package:lemon_ui/lemon_ui.dart';

/// 展示统一动画档位和减少动画行为。
class HyperMotionThemePage extends StatefulWidget {
  const HyperMotionThemePage({super.key});

  @override
  State<HyperMotionThemePage> createState() => _HyperMotionThemePageState();
}

class _HyperMotionThemePageState extends State<HyperMotionThemePage> {
  bool _atEnd = false;
  bool _reduceMotion = false;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final motion = theme.motion;
    return Material(
      color: theme.colors.background,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('统一动画', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          const Text('快速、标准和强调档位共享全局主题；减少动画时立即到达最终状态。'),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton(
                onPressed: () => setState(() => _atEnd = !_atEnd),
                child: const Text('播放动画'),
              ),
              FilterChip(
                label: const Text('模拟减少动画'),
                selected: _reduceMotion,
                onSelected: (value) => setState(() => _reduceMotion = value),
              ),
            ],
          ),
          const SizedBox(height: 24),
          for (final item in <(String, HyperMotionSpeed)>[
            ('快速 120ms', HyperMotionSpeed.fast),
            ('标准 240ms', HyperMotionSpeed.standard),
            ('强调 360ms', HyperMotionSpeed.emphasized),
          ]) ...[
            _MotionTrack(
              label: item.$1,
              atEnd: _atEnd,
              duration: motion.durationFor(
                item.$2,
                disableAnimations: _reduceMotion,
              ),
              curve: motion.curveFor(item.$2),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            '弹簧：mass ${motion.spring.mass.toStringAsFixed(0)} · '
            'stiffness ${motion.spring.stiffness.toStringAsFixed(0)} · '
            'damping ${motion.spring.damping.toStringAsFixed(0)}',
          ),
        ],
      ),
    );
  }
}

class _MotionTrack extends StatelessWidget {
  const _MotionTrack({
    required this.label,
    required this.atEnd,
    required this.duration,
    required this.curve,
  });

  final String label;
  final bool atEnd;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$label · 实际 ${duration.inMilliseconds}ms'),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            const size = 36.0;
            return SizedBox(
              height: size,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colors.surface,
                        borderRadius: BorderRadius.circular(size / 2),
                      ),
                    ),
                  ),
                  AnimatedPositionedDirectional(
                    key: ValueKey('motion-$label'),
                    start: atEnd ? constraints.maxWidth - size : 0,
                    duration: duration,
                    curve: curve,
                    child: Container(
                      width: size,
                      height: size,
                      decoration: BoxDecoration(
                        color: theme.colors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
