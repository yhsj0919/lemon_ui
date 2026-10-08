import 'package:lemon_ui/src/motion/hyper_animated_checkmark.dart';

import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

void main() {
  testWidgets('普通与头像对勾使用相同画布、描边和抗锯齿路径', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Center(
          child: Wrap(
            children: [
              HyperChip.choice(label: '普通', selected: true, onSelected: (_) {}),
              HyperChip.choice(
                label: '头像',
                selected: true,
                onSelected: (_) {},
                avatar: const Icon(Icons.person),
                style: const HyperChipStyle(
                  checkmarkPlacement:
                      HyperChipCheckmarkPlacement.avatarReplacement,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final marks = find.byType(HyperAnimatedCheckmark);
    expect(marks, findsNWidgets(2));
    expect(tester.getSize(marks.first), tester.getSize(marks.last));
    final first = tester.widget<HyperAnimatedCheckmark>(marks.first);
    final last = tester.widget<HyperAnimatedCheckmark>(marks.last);
    expect(first.strokeWidth, last.strokeWidth);
    expect(first.glyphScale, last.glyphScale);
    final painter = tester
        .widget<CustomPaint>(
          find.descendant(of: marks.last, matching: find.byType(CustomPaint)),
        )
        .painter!;
    for (final ratio in [1.0, 1.25, 2.0]) {
      final hasSoftEdge = await tester.runAsync(() async {
        final recorder = ui.PictureRecorder();
        final canvas = Canvas(recorder)..scale(ratio);
        final size = tester.getSize(marks.last);
        painter.paint(canvas, size);
        final picture = recorder.endRecording();
        final image = await picture.toImage(
          (size.width * ratio).ceil(),
          (size.height * ratio).ceil(),
        );
        final bytes = (await image.toByteData(
          format: ui.ImageByteFormat.rawRgba,
        ))!;
        var partialAlpha = false;
        for (var offset = 3; offset < bytes.lengthInBytes; offset += 4) {
          final alpha = bytes.getUint8(offset);
          if (alpha > 0 && alpha < 255) {
            partialAlpha = true;
            break;
          }
        }
        image.dispose();
        picture.dispose();
        return partialAlpha;
      });
      expect(hasSoftEdge, true, reason: '像素密度 $ratio 下边缘应有混合覆盖像素');
    }
  });
  test('头像对勾配置参与合并、插值和值相等', () {
    const base = HyperChipStyle(
      checkmarkPlacement: HyperChipCheckmarkPlacement.leading,
      checkmarkColor: Colors.black,
    );
    final overlay = base.copyWith(
      checkmarkPlacement: HyperChipCheckmarkPlacement.avatarOverlay,
      checkmarkColor: Colors.white,
      checkmarkScale: 1.8,
      selectedAvatarColor: Colors.blue,
      selectedAvatarShape: const CircleBorder(),
    );
    expect(base.merge(overlay), overlay);
    expect(overlay.copyWith(), overlay);
    expect(overlay.copyWith().hashCode, overlay.hashCode);
    expect(overlay, isNot(base));
    expect(HyperChipStyle.lerp(base, overlay, 1), overlay);
    expect(
      HyperChipStyle.lerp(base, overlay, .5).checkmarkColor,
      Color.lerp(Colors.black, Colors.white, .5),
    );
  });
  testWidgets('覆盖头像模式只显示选中底色和标准对勾，取消后恢复头像', (tester) async {
    var selected = true;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Center(
            child: HyperChip.choice(
              label: '联系人',
              selected: selected,
              avatar: const Icon(Icons.person),
              style: const HyperChipStyle(
                checkmarkPlacement:
                    HyperChipCheckmarkPlacement.avatarReplacement,
                checkmarkScale: 2,
                selectedAvatarColor: Colors.blue,
                selectedAvatarShape: RoundedRectangleBorder(),
              ),
              onSelected: (value) => setState(() => selected = value),
            ),
          ),
        ),
      ),
    );
    final width = tester.getSize(find.byType(HyperChip)).width;
    expect(find.byIcon(Icons.person), findsNothing);
    final mark = tester.widget<HyperAnimatedCheckmark>(
      find.byType(HyperAnimatedCheckmark),
    );
    expect(mark.state, true);
    expect(mark.glyphScale, 2);
    final selectedSurface = find.byWidgetPredicate(
      (widget) =>
          widget is DecoratedBox &&
          widget.decoration is ShapeDecoration &&
          (widget.decoration as ShapeDecoration).color == Colors.blue,
    );
    expect(selectedSurface, findsOneWidget);
    await tester.tap(find.text('联系人'));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(selectedSurface, findsNothing);
    expect(tester.getSize(find.byType(HyperChip)).width, width);
  });
  testWidgets('头像叠加对勾保持中心位置且不增加选中宽度', (tester) async {
    var selected = false;
    await tester.pumpWidget(
      MaterialApp(
        home: StatefulBuilder(
          builder: (context, setState) => Center(
            child: HyperChipTheme(
              data: const HyperChipThemeData(
                style: HyperChipStyle(
                  checkmarkPlacement: HyperChipCheckmarkPlacement.avatarOverlay,
                  checkmarkColor: Colors.white,
                ),
              ),
              child: HyperChip.choice(
                label: '蓝色',
                selected: selected,
                avatar: const ColoredBox(
                  key: Key('avatar'),
                  color: Colors.blue,
                ),
                onSelected: (value) => setState(() => selected = value),
              ),
            ),
          ),
        ),
      ),
    );
    final before = tester.getSize(find.byType(HyperChip));
    expect(
      tester
          .widget<HyperAnimatedCheckmark>(find.byType(HyperAnimatedCheckmark))
          .state,
      false,
    );
    await tester.tap(find.text('蓝色'));
    await tester.pump();
    final markPaint = find.descendant(
      of: find.byType(HyperAnimatedCheckmark),
      matching: find.byType(CustomPaint),
    );
    final startPainter = tester.widget<CustomPaint>(markPaint).painter!;
    await tester.pump(const Duration(milliseconds: 150));
    final middlePainter = tester.widget<CustomPaint>(markPaint).painter!;
    expect(middlePainter.shouldRepaint(startPainter), isTrue);
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<CustomPaint>(markPaint)
          .painter!
          .shouldRepaint(middlePainter),
      isTrue,
    );
    expect(selected, isTrue);
    expect(tester.getSize(find.byType(HyperChip)), before);
    expect(
      tester.getCenter(find.byType(HyperAnimatedCheckmark)),
      tester.getCenter(find.byKey(const Key('avatar'))),
    );
    expect(
      tester
          .widget<HyperAnimatedCheckmark>(find.byType(HyperAnimatedCheckmark))
          .color,
      Colors.white,
    );
    await tester.tap(find.text('蓝色'));
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<HyperAnimatedCheckmark>(find.byType(HyperAnimatedCheckmark))
          .state,
      false,
    );
    expect(find.byKey(const Key('avatar')), findsOneWidget);
  });
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

