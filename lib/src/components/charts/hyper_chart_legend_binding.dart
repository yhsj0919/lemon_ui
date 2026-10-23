import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'hyper_chart_legend_controller.dart';

/// Shared lifecycle and post-frame snapshot delivery for chart legends.
mixin HyperChartLegendBinding<T extends StatefulWidget> on State<T> {
  HyperChartLegendController? get externalLegendController;
  ValueChanged<List<HyperChartLegendEntry>>? get legendChanged;
  List<String>? get explicitLegendIds;
  final _internalLegend = HyperChartLegendController();
  late HyperChartLegendController _listeningLegend;
  List<String> _legendIds = const [];
  List<HyperChartLegendEntry> _snapshot = const [];
  bool _hadCallback = false;
  int _legendRevision = 0;

  Set<int> get legendHiddenIndices => {
    for (var index = 0; index < _legendIds.length; index++)
      if (_listeningLegend.isHidden(_legendIds[index])) index,
  };

  void toggleLegendIndex(int index) =>
      _listeningLegend.toggle(_legendIds[index]);

  void syncChartLegend(List<({String label, Color color})> items) {
    final labels = items.map((item) => item.label).toList();
    final ids =
        explicitLegendIds ??
        (labels.toSet().length == labels.length
            ? labels
            : [
                for (var index = 0; index < labels.length; index++)
                  '$index:${labels[index]}',
              ]);
    if (ids.length != items.length || ids.toSet().length != ids.length) {
      throw ArgumentError(
        'Legend IDs must be unique and match the legend item count. Supply legendIds for duplicate labels.',
      );
    }
    _legendIds = List.unmodifiable(ids);
    final next = List<HyperChartLegendEntry>.unmodifiable([
      for (var index = 0; index < items.length; index++)
        HyperChartLegendEntry(
          id: ids[index],
          index: index,
          label: items[index].label,
          color: items[index].color,
          hidden: _listeningLegend.isHidden(ids[index]),
        ),
    ]);
    final callback = legendChanged;
    final changed =
        !listEquals(next, _snapshot) || (!_hadCallback && callback != null);
    _hadCallback = callback != null;
    if (!changed) return;
    _snapshot = next;
    final revision = ++_legendRevision;
    if (callback != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && revision == _legendRevision) callback(next);
      });
    }
  }

  void _legendVisibilityChanged() {
    if (mounted) setState(legendVisibilityChanged);
  }

  void legendVisibilityChanged() {}

  @override
  void initState() {
    super.initState();
    _listeningLegend = externalLegendController ?? _internalLegend;
    _listeningLegend.addListener(_legendVisibilityChanged);
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = externalLegendController ?? _internalLegend;
    if (next != _listeningLegend) {
      _listeningLegend.removeListener(_legendVisibilityChanged);
      _listeningLegend = next;
      next.addListener(_legendVisibilityChanged);
    }
  }

  @override
  void dispose() {
    _listeningLegend.removeListener(_legendVisibilityChanged);
    _internalLegend.dispose();
    super.dispose();
  }
}
