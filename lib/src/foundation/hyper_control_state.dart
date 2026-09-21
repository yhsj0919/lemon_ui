/// 控件当前可能同时具有的交互和视觉状态。
enum HyperControlState {
  hovered,
  focused,
  selected,
  dragged,
  pressed,
  tertiaryPressed,
  secondaryPressed,
  longPressed,
  success,
  error,
  loading,
  disabled;

  /// 从低到高的统一解析优先级。
  static const List<HyperControlState> priority = [
    hovered,
    focused,
    selected,
    dragged,
    pressed,
    tertiaryPressed,
    secondaryPressed,
    longPressed,
    success,
    error,
    loading,
    disabled,
  ];

  /// 按统一优先级取得当前状态集合中优先级最高的状态。
  static HyperControlState? highestOf(Set<HyperControlState> states) {
    for (final state in priority.reversed) {
      if (states.contains(state)) return state;
    }
    return null;
  }
}
