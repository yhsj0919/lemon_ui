import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

const _roots = [
  HyperCascaderNode(
    value: 1,
    label: 'A',
    children: [
      HyperCascaderNode(
        value: 2,
        label: 'B',
        children: [HyperCascaderNode(value: 3, label: 'C')],
      ),
    ],
  ),
  HyperCascaderNode(
    value: 4,
    label: 'Disabled',
    enabled: false,
    children: [HyperCascaderNode(value: 5, label: 'Hidden')],
  ),
];

void main() {
  test(
    'navigation restores only known contiguous ancestors and skips disabled',
    () async {
      final model = HyperCascaderController(nodes: _roots);
      addTearDown(model.dispose);
      await model.browse([1, 2, 3]);
      expect(model.path.map((n) => n.value), [1, 2]);
      expect(model.options.single.value, 3);
      model.goTo(1);
      expect(model.options.single.value, 2);
      model.goTo(0);
      await model.enter(model.nodes.last);
      expect(model.path, isEmpty);
      expect(model.resolvePath([1, 3]), hasLength(1));
      expect(() => model.nodes.add(_roots.first), throwsUnsupportedError);
    },
  );

  test('duplicate values and cycles are rejected before recursion', () {
    expect(
      () => HyperCascaderController(nodes: [_roots.first, _roots.first]),
      throwsArgumentError,
    );
    final children = <HyperCascaderNode<int>>[];
    final cycle = HyperCascaderNode(
      value: 1,
      label: 'Cycle',
      children: children,
    );
    children.add(cycle);
    expect(() => HyperCascaderController(nodes: [cycle]), throwsArgumentError);
  });

  test(
    'branch errors retry; successful results cache including empty branches',
    () async {
      var calls = 0;
      final model = HyperCascaderController<int>(
        nodes: const [
          HyperCascaderNode(value: 1, label: 'Remote', hasChildren: true),
        ],
        loadChildren: (_) async {
          if (++calls == 1) throw StateError('Offline');
          return [];
        },
      );
      addTearDown(model.dispose);
      await model.enter(model.nodes.single);
      expect(model.error, isStateError);
      await model.retry();
      expect(model.error, isNull);
      expect(model.options, isEmpty);
      expect(model.isBranch(model.nodes.single), isTrue);
      model.goTo(0);
      await model.enter(model.nodes.single);
      expect(calls, 2);
    },
  );

  test(
    'pending requests deduplicate and cannot navigate back from another branch',
    () async {
      final pending = Completer<List<HyperCascaderNode<int>>>();
      var calls = 0;
      final model = HyperCascaderController<int>(
        nodes: const [
          HyperCascaderNode(value: 1, label: 'A', hasChildren: true),
          HyperCascaderNode(
            value: 2,
            label: 'B',
            children: [HyperCascaderNode(value: 3, label: 'B leaf')],
          ),
        ],
        loadChildren: (_) {
          calls++;
          return pending.future;
        },
      );
      addTearDown(model.dispose);
      final opening = model.browse([1, 9]);
      final retry = model.retry();
      await Future<void>.delayed(Duration.zero);
      expect(calls, 1);
      model.goTo(0);
      await model.enter(model.nodes.last);
      pending.complete(const [HyperCascaderNode(value: 9, label: 'A leaf')]);
      await Future.wait([opening, retry]);
      expect(model.path.single.value, 2);
      expect(model.options.single.value, 3);
      expect(model.resolvePath([1, 9]).last.label, 'A leaf');
    },
  );

  test(
    'async duplicate response does not pollute index and can retry',
    () async {
      var calls = 0;
      final model = HyperCascaderController<int>(
        nodes: const [
          HyperCascaderNode(value: 1, label: 'A', hasChildren: true),
        ],
        loadChildren: (_) async => ++calls == 1
            ? const [
                HyperCascaderNode(value: 2, label: 'Valid'),
                HyperCascaderNode(value: 1, label: 'Duplicate'),
              ]
            : const [HyperCascaderNode(value: 2, label: 'Valid')],
      );
      addTearDown(model.dispose);
      await model.enter(model.nodes.single);
      expect(model.error, isArgumentError);
      await model.retry();
      expect(model.error, isNull);
      expect(model.options.single.value, 2);
    },
  );

  test(
    'disposing isolates late results from a replacement data source',
    () async {
      final pending = Completer<List<HyperCascaderNode<int>>>();
      final old = HyperCascaderController<int>(
        nodes: const [
          HyperCascaderNode(value: 1, label: 'Old', hasChildren: true),
        ],
        loadChildren: (_) => pending.future,
      );
      final request = old.enter(old.nodes.single);
      await Future<void>.delayed(Duration.zero);
      old.dispose();
      final replacement = HyperCascaderController(nodes: _roots);
      addTearDown(replacement.dispose);
      pending.complete(const [HyperCascaderNode(value: 9, label: 'Stale')]);
      await request;
      expect(old.resolvePath([1, 9]), hasLength(1));
      expect(replacement.resolvePath([9]), isEmpty);
    },
  );
}
