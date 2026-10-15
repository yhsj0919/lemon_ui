/// 手势期间以用户的临时值为准；结束后恢复受控值，不回放中途的外部更新。
class HyperSliderDragValue<T extends Object> {
  T? _value;
  bool get active => _value != null;
  T resolve(T external) => _value ?? external;
  void begin(T value) => _value = value;
  void update(T value) {
    if (active) _value = value;
  }

  T end(T external) {
    final result = resolve(external);
    _value = null;
    return result;
  }

  void cancel() => _value = null;
}
