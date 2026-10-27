import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lemon_ui/lemon_ui.dart';

Widget host(
  Widget child, {
  double scale = 1,
  HyperThemeData? theme,
  double width = 400,
  double height = 500,
}) => MaterialApp(
  home: HyperTheme(
    data: theme ?? HyperThemeData.light(),
    child: MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(scale)),
      child: Scaffold(
        body: SizedBox(width: width, height: height, child: child),
      ),
    ),
  ),
);

void main() {
  test('transfer item spacing defaults to 4 on every device and supports interpolation', () {
    final theme = HyperThemeData.light();
    for (final device in HyperDeviceType.values) {
      final sizes = theme.sizes.resolve(device);
      expect(sizes.transfer.itemSpacing, 4);
      final changed = sizes.copyWith(
        transfer: sizes.transfer.copyWith(itemSpacing: 8),
      );
      expect(HyperSizeScheme.lerp(sizes, changed, .5).transfer.itemSpacing, 6);
      expect(changed.copyWith(), changed);
    }
  });
  testWidgets(
    'transfer items clip to menu radius and use matching compact checkboxes',
    (t) async {
      final theme = HyperThemeData.light();
      await t.pumpWidget(
        host(
          SingleChildScrollView(
            child: HyperTransfer<int>(
              options: const [HyperTransferOption(value: 1, label: 'One')],
              value: const {},
              onChanged: (_) {},
              style: const HyperTransferStyle(panelHeight: 200),
            ),
          ),
          theme: theme,
        ),
      );
      await t.pumpAndSettle();
      final row = find.byType(HyperCheckboxListTile);
      final sizes = HyperTheme.sizesOf(t.element(row));
      final clip = t.widget<ClipRRect>(
        find.ancestor(of: row, matching: find.byType(ClipRRect)).first,
      );
      expect(clip.borderRadius, BorderRadius.circular(sizes.menu.itemRadius));
      final checks = t.widgetList<HyperCheckbox>(find.byType(HyperCheckbox));
      expect(
        checks.every((c) => c.variant == HyperCheckboxVariant.rounded),
        isTrue,
      );
      expect(checks.map((c) => c.style?.size).toSet(), {sizes.menu.iconSize});
      expect(t.takeException(), isNull);
      final a = HyperTransferStyle(
        itemRadius: 4,
        checkboxStyle: HyperCheckboxStyle(size: 16),
      );
      final b = a.copyWith(itemRadius: 8, selectedItemColor: Colors.red);
      expect(b.checkboxStyle?.size, 16);
      expect(HyperTransferStyle.lerp(a, b, .5).itemRadius, 6);
    },
  );
  testWidgets('RTL rating input and vertical resize use correct direction', (
    t,
  ) async {
    double score = 0;
    await t.pumpWidget(
      host(
        Directionality(
          textDirection: TextDirection.rtl,
          child: StatefulBuilder(
            builder: (_, set) => Align(
              alignment: Alignment.topRight,
              child: HyperRating(
                value: score,
                onChanged: (v) => set(() => score = v),
              ),
            ),
          ),
        ),
      ),
    );
    await t.tapAt(
      t.getTopRight(find.byType(HyperRating)) + const Offset(-12, 24),
    );
    await t.pumpAndSettle();
    expect(score, .5);
    await t.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await t.pumpAndSettle();
    expect(score, 1);
    await t.pumpWidget(
      host(
        HyperResizable(
          direction: Axis.vertical,
          handleBuilder: (_, i, active) => const ColoredBox(
            key: ValueKey('vertical-handle'),
            color: Colors.blue,
          ),
          panes: [
            HyperResizablePane(
              child: const ColoredBox(
                key: ValueKey('upper'),
                color: Colors.red,
              ),
            ),
            HyperResizablePane(child: const ColoredBox(color: Colors.green)),
          ],
        ),
        width: 300,
        height: 300,
      ),
    );
    final before = t.getSize(find.byKey(const ValueKey('upper'))).height;
    await t.drag(
      find.byKey(const ValueKey('vertical-handle')),
      const Offset(0, 30),
    );
    await t.pumpAndSettle();
    expect(
      t.getSize(find.byKey(const ValueKey('upper'))).height,
      greaterThan(before),
    );
    expect(t.takeException(), isNull);
  });

  testWidgets('rating global local and instance visual overrides compose', (
    t,
  ) async {
    final theme = HyperThemeData.light().copyWith(
      ratingTheme: const HyperRatingThemeData(
        style: HyperRatingStyle(activeColor: Colors.red, iconSize: 24),
      ),
    );
    await t.pumpWidget(
      host(
        HyperRatingTheme(
          data: const HyperRatingThemeData(
            style: HyperRatingStyle(activeColor: Colors.blue, gap: 10),
          ),
          child: HyperRating(
            value: 1,
            count: 1,
            style: const HyperRatingStyle(activeColor: Colors.green),
          ),
        ),
        theme: theme,
      ),
    );
    await t.pumpAndSettle();
    final icons = t.widgetList<Icon>(find.byType(Icon));
    expect(icons.any((i) => i.color == Colors.green && i.size == 24), isTrue);
    expect(t.takeException(), isNull);
  });
  testWidgets(
    'rating and transfer Form fields reset and validate through shared Form',
    (t) async {
      final form = HyperFormController();
      addTearDown(form.dispose);
      await t.pumpWidget(
        host(
          SingleChildScrollView(
            child: HyperForm(
              controller: form,
              child: Column(
                children: [
                  HyperRatingFormField(
                    name: 'score',
                    initialValue: 2,
                    validator: (v) => (v ?? 0) < 1 ? 'required' : null,
                  ),
                  HyperTransferFormField<int>(
                    name: 'targets',
                    initialValue: const {1},
                    options: const [
                      HyperTransferOption(value: 1, label: 'One'),
                    ],
                    transferStyle: const HyperTransferStyle(panelHeight: 160),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await t.pumpAndSettle();
      final score = t.state<HyperFormFieldState<double>>(
        find.byType(HyperRatingFormField),
      );
      score.didChange(0);
      await t.pump();
      final pending = form.validate();
      await t.pumpAndSettle();
      expect(await pending, isFalse);
      form.reset();
      await t.pumpAndSettle();
      expect(form.values['score'], 2);
      expect(form.values['targets'], {1});
      expect(t.takeException(), isNull);
    },
  );

  testWidgets(
    'movable dialog inherits advanced material and explicit border shadow overrides',
    (t) async {
      final global = HyperThemeData.light().copyWith(
        materialTheme: const HyperMaterialThemeData(
          quality: HyperMaterialQuality.advanced,
          material: HyperSurfaceMaterial.frostedGlass(),
        ),
      );
      final border = Border.all(color: Colors.red, width: 2);
      await t.pumpWidget(
        host(
          Builder(
            builder: (context) => HyperButton.text(
              label: const Text('Open'),
              onPressed: () => showHyperMovableDialog<void>(
                context: context,
                builder: (_) => HyperMovableDialog(
                  title: const Text('Title'),
                  content: const Text('Body'),
                  style: HyperMovableDialogStyle(
                    dialogStyle: HyperDialogStyle(
                      border: border,
                      boxShadow: const [],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ),
          theme: global,
        ),
      );
      await t.tap(find.text('Open'));
      await t.pump();
      await t.pump(const Duration(milliseconds: 60));
      final surfaces = t
          .widgetList<HyperMaterialSurface>(
            find.descendant(
              of: find.byType(HyperMovableDialog),
              matching: find.byType(HyperMaterialSurface),
            ),
          )
          .toList();
      expect(surfaces, isNotEmpty);
      expect(
        surfaces.any((s) => s.border == border && s.boxShadow?.isEmpty == true),
        isTrue,
      );
      final filters = find.descendant(
        of: find.byType(HyperMovableDialog),
        matching: find.byType(BackdropFilter),
      );
      if (filters.evaluate().isNotEmpty) {
        final opacity = t.widgetList<Opacity>(
          find.ancestor(of: filters.first, matching: find.byType(Opacity)),
        );
        expect(opacity.every((o) => o.opacity == 1), isTrue);
      }
      // The async trigger remains busy until the dialog closes; advance bounded frames.
      await t.pump(const Duration(milliseconds: 300));
      expect(t.takeException(), isNull);
    },
  );

  testWidgets(
    'transfer tiny panel setting grows to fit scalable header and search',
    (t) async {
      await t.pumpWidget(
        host(
          SingleChildScrollView(
            child: HyperTransfer<int>(
              options: const [HyperTransferOption(value: 1, label: 'One')],
              value: const {},
              onChanged: (_) {},
              style: const HyperTransferStyle(panelHeight: 1),
            ),
          ),
          scale: 2,
          width: 200,
        ),
      );
      await t.pumpAndSettle();
      expect(t.takeException(), isNull);
    },
  );

  testWidgets('rating supports half steps keyboard and readonly semantics', (
    t,
  ) async {
    double value = 0;
    await t.pumpWidget(
      host(
        StatefulBuilder(
          builder: (_, set) => Align(
            alignment: Alignment.topLeft,
            child: HyperRating(
              value: value,
              allowClear: true,
              onChanged: (v) => set(() => value = v),
            ),
          ),
        ),
      ),
    );
    final origin = t.getTopLeft(find.byType(HyperRating));
    await t.tapAt(origin + const Offset(12, 24));
    await t.pumpAndSettle();
    expect(value, .5);
    await t.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await t.pumpAndSettle();
    expect(value, 1);
    await t.sendKeyEvent(LogicalKeyboardKey.end);
    await t.pumpAndSettle();
    expect(value, 5);
    await t.pumpWidget(
      host(
        HyperRating(
          value: 2.5,
          readOnly: true,
          onChanged: (_) => fail('readonly callback'),
        ),
      ),
    );
    await t.tapAt(
      t.getTopLeft(find.byType(HyperRating)) + const Offset(12, 24),
    );
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
  });

  test(
    'rating rejects invalid values and controllers reject invalid weights',
    () {
      expect(() => HyperRating(value: double.nan), throwsArgumentError);
      expect(() => HyperRating(value: 6), throwsArgumentError);
      expect(() => HyperRating(value: 2, step: 0), throwsArgumentError);
      expect(
        () => HyperResizableController(weights: [0, 0]),
        throwsArgumentError,
      );
      expect(
        () => HyperMovableDialogController(
          initialOffset: const Offset(double.infinity, 0),
        ),
        throwsArgumentError,
      );
    },
  );

  testWidgets(
    'transfer filters, moves enabled checked rows and preserves unknown targets',
    (t) async {
      Set<int> values = {99};
      const options = [
        HyperTransferOption(value: 1, label: 'Alpha'),
        HyperTransferOption(value: 2, label: 'Beta', enabled: false),
        HyperTransferOption(value: 3, label: 'Gamma'),
      ];
      await t.pumpWidget(
        host(
          SingleChildScrollView(
            child: StatefulBuilder(
              builder: (_, set) => HyperTransfer(
                options: options,
                value: values,
                onChanged: (v) => set(() => values = v),
                style: const HyperTransferStyle(panelHeight: 240),
              ),
            ),
          ),
          width: 800,
          height: 500,
        ),
      );
      await t.tap(find.text('Alpha'));
      await t.pumpAndSettle();
      await t.tap(find.text('移入'));
      await t.pumpAndSettle();
      expect(values, {1, 99});
      await t.tap(find.text('Beta'));
      await t.pumpAndSettle();
      await t.tap(find.text('移入'));
      await t.pumpAndSettle();
      expect(values, {1, 99});
      final search = find.descendant(
        of: find.byKey(const ValueKey('transfer-source-search')),
        matching: find.byType(EditableText),
      );
      await t.enterText(search, 'Gamma');
      await t.pumpAndSettle();
      expect(find.text('Beta'), findsNothing);
      final gamma = find.descendant(
        of: find.byType(HyperCheckboxListTile),
        matching: find.text('Gamma'),
      );
      expect(gamma, findsOneWidget);
      await t.tap(gamma);
      await t.pumpAndSettle();
      await t.tap(find.text('移入'));
      await t.pumpAndSettle();
      expect(values, {1, 3, 99});
      expect(t.takeException(), isNull);
    },
  );

  testWidgets('resizable respects bounds, collapse and horizontal drag', (
    t,
  ) async {
    final controller = HyperResizableController();
    addTearDown(controller.dispose);
    List<double>? last;
    await t.pumpWidget(
      host(
        HyperResizable(
          controller: controller,
          onResize: (v) => last = v,
          handleBuilder: (_, i, active) =>
              const ColoredBox(key: ValueKey('handle'), color: Colors.blue),
          panes: [
            HyperResizablePane(
              minimumExtent: 80,
              maximumExtent: 250,
              collapsible: true,
              child: const ColoredBox(key: ValueKey('left'), color: Colors.red),
            ),
            HyperResizablePane(
              minimumExtent: 80,
              child: const ColoredBox(
                key: ValueKey('right'),
                color: Colors.green,
              ),
            ),
          ],
        ),
        width: 400,
        height: 200,
      ),
    );
    final before = t.getSize(find.byKey(const ValueKey('left'))).width;
    await t.drag(find.byKey(const ValueKey('handle')), const Offset(40, 0));
    await t.pumpAndSettle();
    expect(
      t.getSize(find.byKey(const ValueKey('left'))).width,
      greaterThan(before),
    );
    expect(last, isNotNull);
    final afterDrag = t.getSize(find.byKey(const ValueKey('left'))).width;
    t
        .widget<Focus>(
          find
              .ancestor(
                of: find.byKey(const ValueKey('handle')),
                matching: find.byType(Focus),
              )
              .first,
        )
        .focusNode!
        .requestFocus();
    await t.pump();
    await t.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await t.pumpAndSettle();
    expect(
      t.getSize(find.byKey(const ValueKey('left'))).width,
      lessThan(afterDrag),
    );
    await t.drag(find.byKey(const ValueKey('handle')), const Offset(1000, 0));
    await t.pumpAndSettle();
    expect(
      t.getSize(find.byKey(const ValueKey('left'))).width,
      lessThanOrEqualTo(250),
    );
    controller.setCollapsed(0, true);
    await t.pumpAndSettle();
    expect(t.getSize(find.byKey(const ValueKey('left'))).width, 0);
    controller.setCollapsed(0, false);
    await t.pumpAndSettle();
    expect(
      t.getSize(find.byKey(const ValueKey('left'))).width,
      greaterThanOrEqualTo(80),
    );
    expect(t.takeException(), isNull);
  });

  testWidgets('infeasible resizable minima scroll instead of overflowing', (
    t,
  ) async {
    await t.pumpWidget(
      host(
        HyperResizable(
          panes: [
            HyperResizablePane(minimumExtent: 180, child: const Text('first')),
            HyperResizablePane(minimumExtent: 180, child: const Text('second')),
          ],
        ),
        width: 240,
        height: 150,
      ),
    );
    await t.pumpAndSettle();
    expect(t.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });

  testWidgets(
    'movable dialog uses shared surface and clamps title drag to host',
    (t) async {
      final controller = HyperMovableDialogController();
      addTearDown(controller.dispose);
      await t.pumpWidget(
        host(
          HyperMovableDialog(
            controller: controller,
            title: const Text('drag title'),
            content: const Text('content'),
            style: const HyperMovableDialogStyle(
              dialogStyle: HyperDialogStyle(width: 200, maxWidth: 200),
            ),
          ),
          width: 400,
          height: 300,
        ),
      );
      await t.pumpAndSettle();
      final handle = find.byKey(const ValueKey('hyper-movable-dialog-handle'));
      final before = t.getTopLeft(find.text('drag title'));
      await t.drag(handle, const Offset(30, 20));
      await t.pumpAndSettle();
      expect(t.getTopLeft(find.text('drag title')).dx, greaterThan(before.dx));
      expect(controller.offset.dx, greaterThan(0));
      await t.drag(handle, const Offset(1000, 1000));
      await t.pumpAndSettle();
      final rect = t.getRect(find.text('drag title'));
      expect(rect.right, lessThanOrEqualTo(400));
      expect(rect.bottom, lessThanOrEqualTo(300));
      controller.reset();
      await t.pumpAndSettle();
      expect(t.getTopLeft(find.text('drag title')), before);
      expect(find.byType(HyperDialog), findsOneWidget);
      controller.moveTo(const Offset(10000, 10000));
      await t.pumpAndSettle();
      expect(t.getRect(find.text('drag title')).right, lessThanOrEqualTo(400));
      expect(t.getRect(find.text('drag title')).bottom, lessThanOrEqualTo(300));
      expect(t.takeException(), isNull);
    },
  );

  testWidgets('material navigation selection ignores disabled destinations', (
    t,
  ) async {
    int selected = 0;
    await t.pumpWidget(
      host(
        StatefulBuilder(
          builder: (_, set) => Align(
            alignment: Alignment.topLeft,
            child: HyperNavigationBar<int>(
              selectedValue: selected,
              onSelected: (v) => set(() => selected = v),
              destinations: const [
                HyperNavigationDestination(
                  value: 0,
                  label: 'Home',
                  icon: Icon(Icons.home),
                ),
                HyperNavigationDestination(
                  value: 1,
                  label: 'Disabled',
                  icon: Icon(Icons.block),
                  enabled: false,
                ),
                HyperNavigationDestination(
                  value: 2,
                  label: 'Settings',
                  icon: Icon(Icons.settings),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await t.tap(find.text('Settings'));
    await t.pumpAndSettle();
    expect(selected, 2);
    await t.tap(find.text('Home'));
    await t.pumpAndSettle();
    expect(selected, 0);
    await t.tap(find.text('Disabled'));
    await t.pumpAndSettle();
    expect(selected, 0);
    expect(t.takeException(), isNull);
  });

  test(
    'new component themes participate in copy equality and interpolation',
    () {
      final base = HyperThemeData.light();
      final other = base.copyWith(
        ratingTheme: const HyperRatingThemeData(
          style: HyperRatingStyle(iconSize: 30, activeColor: Colors.red),
        ),
        transferTheme: const HyperTransferThemeData(
          style: HyperTransferStyle(panelWidth: 300),
        ),
        resizableTheme: const HyperResizableThemeData(
          style: HyperResizableStyle(handleExtent: 10),
        ),
        movableDialogTheme: const HyperMovableDialogThemeData(
          style: HyperMovableDialogStyle(mouseCursor: SystemMouseCursors.grab),
        ),
        navigationBarTheme: const HyperNavigationBarThemeData(
          style: HyperNavigationBarStyle(iconSize: 22),
        ),
      );
      expect(other, other.copyWith());
      expect(other.hashCode, other.copyWith().hashCode);
      final end = base.lerp(other, 1);
      expect(end.ratingTheme, other.ratingTheme);
      expect(end.transferTheme, other.transferTheme);
      expect(end.resizableTheme, other.resizableTheme);
      expect(end.movableDialogTheme, other.movableDialogTheme);
      expect(end.navigationBarTheme, other.navigationBarTheme);
    },
  );
}
