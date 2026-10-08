import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_ui/src/components/text_field/hyper_text_field_layout.dart';

void main() {
  test('尾部图标留白只计算一次，计数保留完整内边距', () {
    expect(
      resolveHyperTextFieldSuffixPadding(
        padding: 12,
        actionWidth: 28,
        iconSize: 16,
        endsWithAction: true,
      ),
      6,
    );
    expect(
      resolveHyperTextFieldSuffixPadding(
        padding: 12,
        actionWidth: 28,
        iconSize: 16,
        endsWithAction: false,
      ),
      12,
    );
    expect(
      resolveHyperTextFieldSuffixPadding(
        padding: 2,
        actionWidth: 28,
        iconSize: 16,
        endsWithAction: true,
      ),
      0,
    );
  });
  test('降低高度先缩减留白，水平内边距不变', () {
    final layout = resolveHyperTextFieldLayout(
      height: 28,
      minimumHeight: 48,
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
      contentHeight: 20,
      borderWidth: 1,
    );
    expect(layout.minimumHeight, 28);
    expect(layout.padding, const EdgeInsets.fromLTRB(12, 4, 16, 4));
  });
  test('高度小于文字时保留内容和边框，允许撑高', () {
    final layout = resolveHyperTextFieldLayout(
      height: 16,
      minimumHeight: 32,
      padding: const EdgeInsets.all(6),
      contentHeight: 40,
      borderWidth: 2,
    );
    expect(layout.minimumHeight, 44);
    expect(layout.padding.vertical, 4);
    final unchanged = resolveHyperTextFieldLayout(
      height: null,
      minimumHeight: 32,
      padding: const EdgeInsets.all(6),
      contentHeight: 20,
      borderWidth: 1,
    );
    expect(unchanged.minimumHeight, 32);
    expect(unchanged.padding, const EdgeInsets.all(6));
  });
  test('状态优先级：聚焦后错误优先，禁用最后覆盖', () {
    const data = HyperTextFieldThemeData(
      style: HyperTextFieldStyle(borderColor: Colors.grey, minimumHeight: 32),
      hovered: HyperTextFieldStyle(borderColor: Colors.black),
      focused: HyperTextFieldStyle(borderColor: Colors.blue),
      error: HyperTextFieldStyle(
        borderColor: Colors.red,
        errorIconColor: Colors.red,
      ),
      disabled: HyperTextFieldStyle(
        borderColor: Colors.grey,
        foregroundColor: Colors.grey,
      ),
    );
    final invalid = data.resolve({
      HyperControlState.hovered,
      HyperControlState.focused,
      HyperControlState.error,
    });
    expect(invalid.borderColor, Colors.red);
    expect(invalid.minimumHeight, 32);
    final disabled = data.resolve({
      HyperControlState.error,
      HyperControlState.disabled,
    });
    expect(disabled.borderColor, Colors.grey);
    expect(disabled.errorIconColor, Colors.red);
  });

  test('三层覆盖只改显式字段，错误不改布局尺寸', () {
    const global = HyperTextFieldThemeData(
      style: HyperTextFieldStyle(
        minimumHeight: 48,
        padding: EdgeInsets.all(12),
        actionWidth: 40,
        background: HyperFill.color(Colors.white),
      ),
    );
    const local = HyperTextFieldThemeData(
      focused: HyperTextFieldStyle(borderColor: Colors.blue),
      error: HyperTextFieldStyle(borderColor: Colors.red),
    );
    final ordinary = global.merge(local).resolve({});
    final invalid = global.merge(local).resolve({HyperControlState.error});
    expect(invalid.minimumHeight, ordinary.minimumHeight);
    expect(invalid.padding, ordinary.padding);
    expect(invalid.actionWidth, ordinary.actionWidth);
    final instance = invalid.merge(
      const HyperTextFieldStyle(
        borderColor: Colors.orange,
        errorPlacement: HyperOverlayPlacement.topStart,
      ),
    );
    expect(instance.borderColor, Colors.orange);
    expect(instance.background, ordinary.background);
    expect(instance.errorPlacement, HyperOverlayPlacement.topStart);
  });

  test('完整视觉值的复制、插值与相等', () {
    final a = HyperTextFieldStyle(
      background: const HyperFill.color(Colors.white),
      material: const HyperSurfaceMaterial.frostedGlass(),
      borderWidth: 1,
      borderRadius: BorderRadius.circular(6),
      boxShadow: const [BoxShadow(color: Colors.black12)],
      textStyle: const TextStyle(fontSize: 14),
      errorPopupStyle: HyperCardStyle(padding: const EdgeInsets.all(12)),
      errorMaxWidth: 320,
      errorPlacement: HyperOverlayPlacement.bottomEnd,
    );
    final b = a.copyWith(borderWidth: 3, errorMaxWidth: 400);
    expect(a, a.copyWith());
    expect(a.hashCode, a.copyWith().hashCode);
    expect(HyperTextFieldStyle.lerp(a, b, 0), a);
    expect(HyperTextFieldStyle.lerp(a, b, 1), b);
    expect(HyperTextFieldStyle.lerp(a, b, .5).borderWidth, 2);
    expect(HyperTextFieldStyle.lerp(a, b, .5).errorMaxWidth, 360);
    expect(
      HyperTextFieldStyle.lerp(
        const HyperTextFieldStyle(),
        const HyperTextFieldStyle(),
        .5,
      ),
      const HyperTextFieldStyle(),
    );
  });

  test('四端尺寸和全局主题完整集成', () {
    final scheme = const HyperSizeThemeData();
    expect(scheme.phone.textField.minimumHeight, 48);
    expect(scheme.tablet.textField.minimumHeight, 52);
    expect(scheme.desktop.textField.minimumHeight, 32);
    expect(scheme.watch.textField.minimumHeight, 48);
    final modified = scheme.desktop.textField.copyWith(actionWidth: 36);
    final sizes = scheme.copyWith(
      desktop: scheme.desktop.copyWith(textField: modified),
    );
    expect(sizes.desktop.textField.actionWidth, 36);
    expect(sizes.phone, scheme.phone);
    expect(HyperTextFieldSize.lerp(modified, modified, .5), modified);
    expect(sizes, sizes.copyWith());
    expect(sizes.hashCode, sizes.copyWith().hashCode);
    const data = HyperTextFieldThemeData(
      style: HyperTextFieldStyle(errorIcon: Icons.info_outline),
    );
    final theme = HyperThemeData.light().copyWith(
      textFieldTheme: data,
      sizes: sizes,
    );
    expect(theme.textFieldTheme, data);
    expect(theme, theme.copyWith());
    expect(theme.hashCode, theme.copyWith().hashCode);
    final other = theme.copyWith(
      textFieldTheme: data.copyWith(
        style: data.style.copyWith(errorIcon: Icons.warning_amber),
      ),
    );
    expect(theme, isNot(other));
    expect(theme.lerp(other, 1), other);
  });

  test('输入配置约束和错误空间的默认约定', () {
    const field = HyperTextField(
      errorText: '错误',
      maxLength: 20,
      showCounter: true,
    );
    expect(field.reserveErrorSpace, isFalse);
    expect(field.maxLines, 1);
    final controller = TextEditingController();
    addTearDown(controller.dispose);
    expect(
      () => HyperTextField(controller: controller, initialValue: '重复'),
      throwsAssertionError,
    );
    expect(
      () => HyperTextField(obscureText: true, maxLines: 3),
      throwsAssertionError,
    );
    expect(
      () => HyperTextField(minLines: 3, maxLines: 2),
      throwsAssertionError,
    );
    expect(() => HyperTextField(maxLength: 0), throwsAssertionError);
  });
}
