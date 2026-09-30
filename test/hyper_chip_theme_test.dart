import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  test('Chip 四端尺寸集中管理，覆盖与插值参与全局值相等', () {
    final schemes = [
      const HyperSizeScheme.phone(),
      const HyperSizeScheme.tablet(),
      const HyperSizeScheme.desktop(),
      const HyperSizeScheme.watch(),
    ];
    expect(schemes.map((s) => s.chip.height), [32, 36, 28, 32]);
    for (final sizes in schemes) {
      final changed = sizes.copyWith(
        chip: sizes.chip.copyWith(height: 40, deleteTargetWidth: 40),
      );
      expect(changed, isNot(sizes));
      expect(changed.chip.avatarSize, sizes.chip.avatarSize);
      expect(
        HyperSizeScheme.lerp(sizes, changed, .5).chip.height,
        (sizes.chip.height + 40) / 2,
      );
      expect(changed, sizes.copyWith(chip: changed.chip));
      expect(changed.hashCode, sizes.copyWith(chip: changed.chip).hashCode);
    }
  });
  test('选中、悬停、按下、禁用状态遵循主题覆盖顺序', () {
    const theme = HyperChipThemeData(
      style: HyperChipStyle(radius: 8, foregroundColor: Colors.grey),
      selected: HyperChipStyle(foregroundColor: Colors.blue),
      hovered: HyperChipStyle(borderWidth: 1),
      pressed: HyperChipStyle(foregroundColor: Colors.orange),
      disabled: HyperChipStyle(foregroundColor: Colors.black),
    );
    final selected = theme.resolve({
      HyperControlState.selected,
      HyperControlState.hovered,
    });
    expect(selected.foregroundColor, Colors.blue);
    expect(selected.borderWidth, 1);
    expect(selected.radius, 8);
    expect(
      theme.resolve({
        HyperControlState.selected,
        HyperControlState.pressed,
      }).foregroundColor,
      Colors.orange,
    );
    expect(
      theme.resolve({
        HyperControlState.selected,
        HyperControlState.pressed,
        HyperControlState.disabled,
      }).foregroundColor,
      Colors.black,
    );
    expect(selected.copyWith(radius: 4).foregroundColor, Colors.blue);
  });
  test('全局、局部和实例覆盖，背景和动效保留强类型与插值端点', () {
    final base = HyperThemeData.light().copyWith(
      chipTheme: const HyperChipThemeData(
        style: HyperChipStyle(
          radius: 8,
          iconSize: 16,
          duration: Duration(milliseconds: 120),
        ),
        selected: HyperChipStyle(background: HyperFill.color(Colors.blue)),
      ),
    );
    final local = base.chipTheme.merge(
      const HyperChipThemeData(
        selected: HyperChipStyle(foregroundColor: Colors.white),
      ),
    );
    final resolved = local
        .resolve({HyperControlState.selected})
        .copyWith(showCheckmark: false);
    expect(resolved.iconSize, 16);
    expect(resolved.background, const HyperFill.color(Colors.blue));
    expect(resolved.foregroundColor, Colors.white);
    expect(resolved.showCheckmark, false);
    final changed = base.copyWith(
      chipTheme: local.copyWith(style: local.style.copyWith(radius: 12)),
    );
    expect(changed, isNot(base));
    expect(base.lerp(changed, .5).chipTheme.style.radius, 10);
    expect(HyperChipThemeData.lerp(base.chipTheme, local, 0), base.chipTheme);
    expect(HyperChipThemeData.lerp(base.chipTheme, local, 1), local);
    expect(resolved, resolved.copyWith());
    expect(resolved.hashCode, resolved.copyWith().hashCode);
  });
  test('便捷构造保持受控状态与独立回调，不混合选择和普通点击', () {
    bool? selectedValue;
    var deleted = 0;
    final chip = HyperChip.input(
      label: '文档',
      selected: true,
      onSelected: (value) => selectedValue = value,
      onDeleted: () => deleted++,
    );
    expect(chip.selected, true);
    expect(chip.onPressed, null);
    expect(chip.onSelected, isNotNull);
    expect(chip.onDeleted, isNotNull);
    chip.onDeleted!();
    expect(deleted, 1);
    expect(selectedValue, null);
    expect(chip.selected, true);
    expect(
      () => HyperChip(label: '互斥', onPressed: () {}, onSelected: (_) {}),
      throwsAssertionError,
    );
    expect(
      () => HyperChip(
        label: '互斥',
        icon: const Icon(Icons.star),
        avatar: const SizedBox(),
      ),
      throwsAssertionError,
    );
  });
}
