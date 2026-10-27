import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/src/motion/hyper_animated_checkmark.dart';

void main() {
  for (final edge in [8.0, 12.0, 18.0, 24.0]) {
    test(
      'checkmark edge=$edge centers painted bounds and preserves 45 degree strokes',
      () {
        const origin = Offset(3, 7);
        final path = hyperCheckboxCheckPath(origin, edge, 1);
        final bounds = path.getBounds();
        final center = origin + Offset(edge / 2, edge / 2);
        expect(bounds.center.dx, closeTo(center.dx, .00001));
        expect(bounds.center.dy, closeTo(center.dy, .00001));
        expect(bounds.width, closeTo(edge * .7, .00001));
        expect(bounds.height, closeTo(edge * .45, .00001));
        final complete = path.computeMetrics().single;
        final first = complete
            .getTangentForOffset(complete.length * .1)!
            .vector;
        final second = complete
            .getTangentForOffset(complete.length * .9)!
            .vector;
        expect(first.dx.abs(), closeTo(first.dy.abs(), .00001));
        expect(second.dx.abs(), closeTo(second.dy.abs(), .00001));
        final start = complete.getTangentForOffset(0)!.position;
        for (final progress in [.1, .25, .5, .75, 1.0]) {
          final partial = hyperCheckboxCheckPath(
            origin,
            edge,
            progress,
          ).computeMetrics().single;
          final actual = partial.getTangentForOffset(0)!.position;
          expect((actual - start).distance, closeTo(0, .00001));
        }
      },
    );
  }
}
