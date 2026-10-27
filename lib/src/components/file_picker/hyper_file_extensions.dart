Set<String> normalizeHyperFileExtensions(Iterable<String>? extensions) =>
    (extensions ?? const <String>[])
        .map(
          (value) =>
              value.trim().replaceFirst(RegExp(r'^\.'), '').toLowerCase(),
        )
        .where((value) => value.isNotEmpty)
        .toSet();
