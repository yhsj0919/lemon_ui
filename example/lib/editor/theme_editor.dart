import 'editor_global_fields.dart';
import 'editor_property_help.dart';

import 'dart:convert';
import 'dart:ui' show AppExitResponse;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lemon_ui/lemon_ui.dart';
import 'package:lemon_x/lemon_x.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../gallery/gallery_registry.dart';
import '../gallery/gallery_shell.dart';
import '../gallery/gallery_item.dart';
import 'editor_theme_document.dart';
import 'editor_component_navigation.dart';
import 'editor_selection_controller.dart';

/// 编辑器外壳使用启动主题，草稿只进入独立预览 Navigator。
class ThemeEditor extends StatefulWidget {
  const ThemeEditor({super.key});
  @override
  State<ThemeEditor> createState() => _ThemeEditorState();
}

class _ThemeEditorState extends State<ThemeEditor> {
  EditorThemeDocument _document = EditorThemeDocument();
  String _saved = EditorThemeDocument().encode();
  final List<String> _undo = [], _redo = [];
  Map<String, String> _library = {};
  bool _dark = false, _landscape = true, _left = false, _right = false;
  HyperDeviceType _device = HyperDeviceType.desktop;
  final _selection = EditorSelectionController();
  String get _component => _selection.component.value;
  set _component(String value) => _selection.component.value = value;
  String get _page => _selection.page.value;
  set _page(String value) => _selection.page.value = value;
  double _textScale = 1;
  String? _gestureStart;
  late final AppLifecycleListener _lifecycle;
  bool get _dirty => _saved != _document.encode();
  EditorMode get _mode => _document.mode(_dark);
  EditorDevice get _spec => _document.device(_device);
  EditorComponent get _appearance => switch (_component) {
    'button' => _mode.button,
    'card' => _mode.card,
    'field' => _mode.field,
    _ => _mode.menu,
  };
  static const _components = {
    'button': 'Button',
    'card': 'Card',
    'field': 'TextField',
    'menu': 'Menu',
  };
  static const _pages = {
    'button': 'hyper-button',
    'card': 'hyper-card',
    'field': 'hyper-text-field',
    'menu': 'hyper-menu',
  };
  static const _devices = {
    HyperDeviceType.phone: '手机',
    HyperDeviceType.tablet: '平板',
    HyperDeviceType.desktop: '桌面',
    HyperDeviceType.watch: '手表',
  };

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(
      onExitRequested: () async =>
          await _canReplace() ? AppExitResponse.exit : AppExitResponse.cancel,
    );
    _loadLibrary();
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    _selection.dispose();
    super.dispose();
  }

  Future<void> _loadLibrary() async {
    final preferences = await SharedPreferences.getInstance();
    final source = preferences.getString('theme-editor-library');
    if (!mounted) return;
    if (source != null) {
      try {
        setState(
          () => _library = (jsonDecode(source) as Map<String, dynamic>)
              .cast<String, String>(),
        );
      } catch (_) {
        _notice('本地主题库读取失败，请从 JSON 文件导入');
      }
    }
  }

  void _change(VoidCallback change) {
    final before = _document.encode();
    setState(change);
    if (_document.encode() != before && _gestureStart == null) {
      _undo.add(before);
      _redo.clear();
    }
  }

  void _endGesture() {
    final before = _gestureStart;
    _gestureStart = null;
    if (before != null && before != _document.encode()) {
      setState(() {
        _undo.add(before);
        _redo.clear();
      });
    }
  }

  void _history(bool redo) {
    final source = redo ? _redo : _undo, target = redo ? _undo : _redo;
    if (source.isEmpty) return;
    setState(() {
      target.add(_document.encode());
      _document = EditorThemeDocument.decode(source.removeLast());
    });
  }

  void _notice(String message) {
    if (!mounted) return;
    showHyperDialog<void>(
      context: context,
      builder: (_) => HyperDialog(
        title: const Text('主题编辑器'),
        content: Text(message),
        actions: [
          HyperButton.filled(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  Future<String?> _input(String title, String initial) async {
    return showHyperDialog<String>(
      context: context,
      builder: (_) => _TextPrompt(title: title, initial: initial),
    );
  }

  Future<bool> _save({bool asNew = false}) async {
    final name = await _input(asNew ? '另存主题' : '保存主题', _document.name);
    if (name == null || !mounted) return false;
    final copy = EditorThemeDocument.decode(_document.encode())..name = name;
    final library = {..._library, name: copy.encode()};
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(
        'theme-editor-library',
        jsonEncode(library),
      );
      if (!success) throw StateError('写入失败');
      if (!mounted) return false;
      setState(() {
        _document.name = name;
        _saved = _document.encode();
        _library = library;
      });
      return true;
    } catch (e) {
      _notice('保存失败：$e');
      return false;
    }
  }

  Future<bool> _canReplace() async {
    if (!_dirty) return true;
    final action = await showHyperDialog<String>(
      context: context,
      builder: (context) => HyperDialog(
        title: const Text('当前主题有未保存修改'),
        content: const Text('先保存，或放弃修改后继续。'),
        actions: [
          HyperButton.ghost(
            onPressed: () => Navigator.pop(context, 'cancel'),
            child: const Text('取消'),
          ),
          HyperButton.tonal(
            onPressed: () => Navigator.pop(context, 'discard'),
            child: const Text('放弃修改'),
          ),
          HyperButton.filled(
            onPressed: () => Navigator.pop(context, 'save'),
            child: const Text('保存'),
          ),
        ],
      ),
    );
    return action == 'discard' || (action == 'save' && await _save());
  }

  void _replace(EditorThemeDocument document) {
    setState(() {
      _document = document;
      _saved = document.encode();
      _undo.clear();
      _redo.clear();
    });
  }

  Future<void> _openLibrary() async {
    if (!await _canReplace() || !mounted) return;
    if (_library.isEmpty) {
      _notice('还没有保存的主题，可以新建或导入 JSON');
      return;
    }
    final name = await showHyperDialog<String>(
      context: context,
      builder: (context) => HyperDialog(
        title: const Text('主题库'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final name in _library.keys)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: HyperButton.tonal(
                  onPressed: () => Navigator.pop(context, name),
                  child: Text(name),
                ),
              ),
          ],
        ),
      ),
    );
    if (name != null && mounted) {
      _replace(EditorThemeDocument.decode(_library[name]!));
    }
  }

  Future<void> _import() async {
    if (!await _canReplace()) return;
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (file == null) return;
      final document = EditorThemeDocument.decode(
        utf8.decode(await file.readAsBytes()),
      );
      if (mounted) {
        _replace(document);
        setState(() => _saved = ''); // 导入后需要显式保存到本地主题库。
      }
    } catch (e) {
      _notice('导入失败：$e');
    }
  }

  Future<void> _export() async {
    try {
      await FilePicker.saveFile(
        dialogTitle: '导出主题 JSON',
        fileName: 'theme.json',
        type: FileType.custom,
        allowedExtensions: ['json'],
        bytes: Uint8List.fromList(utf8.encode(_document.encode())),
      );
    } catch (e) {
      _notice('导出失败：$e');
    }
  }

  Future<void> _setStartup() async {
    if (_dirty && !await _save()) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setString(
        'theme-editor-startup',
        jsonEncode({'dark': _dark, 'theme': _document.toJson()}),
      );
      if (!success) throw StateError('写入失败');
      _notice('已设置应用主题，下次启动生效。当前编辑器外壳保持原主题。');
    } catch (e) {
      _notice('设置失败：$e');
    }
  }

  @override
  Widget build(BuildContext context) => _buildEditor(context);

  Widget _buildEditor(BuildContext context) => CallbackShortcuts(
    bindings: {
      const SingleActivator(LogicalKeyboardKey.keyZ, control: true): () =>
          _history(false),
      const SingleActivator(
        LogicalKeyboardKey.keyZ,
        control: true,
        shift: true,
      ): () =>
          _history(true),
      const SingleActivator(LogicalKeyboardKey.keyS, control: true): () =>
          _save(),
    },
    child: PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop && await _canReplace() && context.mounted) {
          Navigator.of(context).pop();
        }
      },
      child: HyperScaffold(
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final wide = constraints.maxWidth >= 1050;
                    return Column(
                      children: [
                        if (!wide) ...[_toolbar(), const HyperDivider()],
                        if (!wide)
                          Wrap(
                            spacing: 8,
                            children: [
                              HyperButton.ghost(
                                onPressed: () => setState(() {
                                  _left = !_left;
                                  if (_left) _right = false;
                                }),
                                child: const Text('全局工作区'),
                              ),
                              HyperButton.ghost(
                                onPressed: () => setState(() {
                                  _right = !_right;
                                  if (_right) _left = false;
                                }),
                                child: const Text('组件工作区'),
                              ),
                            ],
                          ),
                        Expanded(
                          child: !wide && (_left || _right)
                              ? (_left ? _globalPanel() : _componentPanel())
                              : Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    if (wide || _left)
                                      SizedBox(
                                        width: wide ? 260 : 240,
                                        child: _globalPanel(),
                                      ),
                                    if (wide || _left)
                                      const HyperDivider.vertical(),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          if (wide) ...[
                                            _toolbar(),
                                            const HyperDivider(),
                                          ],
                                          Expanded(child: _preview()),
                                        ],
                                      ),
                                    ),
                                    if (wide || (_right && !_left))
                                      const HyperDivider.vertical(),
                                    if (wide || (_right && !_left))
                                      SizedBox(
                                        width: wide ? 290 : 240,
                                        child: _componentPanel(),
                                      ),
                                  ],
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _toolbar() => Padding(
    padding: const EdgeInsets.all(12),
    child: Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        HyperText('主题工作室 · ${_document.name}${_dirty ? ' • 未保存' : ''}'),
        HyperButton.ghost(
          onPressed: () async {
            if (await _canReplace() && mounted) {
              _replace(EditorThemeDocument());
            }
          },
          child: const Text('新建'),
        ),
        HyperButton.ghost(onPressed: _openLibrary, child: const Text('主题库')),
        HyperButton.filled(onPressed: () => _save(), child: const Text('保存')),
        HyperButton.ghost(
          onPressed: () => _save(asNew: true),
          child: const Text('另存为'),
        ),
        HyperButton.ghost(onPressed: _import, child: const Text('导入')),
        HyperButton.ghost(onPressed: _export, child: const Text('导出 JSON')),
        HyperButton.ghost(onPressed: _setStartup, child: const Text('下次启动使用')),
        HyperIconButton.ghost(
          tooltip: '撤销',
          onPressed: _undo.isEmpty ? null : () => _history(false),
          icon: const Icon(Icons.undo),
        ),
        HyperIconButton.ghost(
          tooltip: '重做',
          onPressed: _redo.isEmpty ? null : () => _history(true),
          icon: const Icon(Icons.redo),
        ),
      ],
    ),
  );

  Widget _panel(String title, List<Widget> children) => ColoredBox(
    color: HyperTheme.of(context).colors.surface,
    child: ListView(
      padding: const EdgeInsets.all(16),
      children: [
        HyperText(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: HyperDivider(),
        ),
        ...children,
      ],
    ),
  );
  Widget _heading(String text) => Padding(
    padding: const EdgeInsets.only(top: 20, bottom: 12),
    child: HyperText(text, style: const TextStyle(fontWeight: FontWeight.w600)),
  );
  Widget _select<T>(
    String label,
    T value,
    Map<T, String> options,
    ValueChanged<T> changed,
  ) => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Tooltip(message: editorPropertyHelp(label), child: HyperText(label)),
        const SizedBox(height: 6),
        HyperSelect<T>(
          value: value,
          options: [
            for (final entry in options.entries)
              HyperSelectOption(value: entry.key, label: entry.value),
          ],
          onChanged: (value) {
            if (value != null) changed(value);
          },
        ),
      ],
    ),
  );
  Widget _number(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> changed,
    VoidCallback reset,
    bool overridden, {
    bool wholeNumbers = true,
  }) => Column(
    key: ValueKey('editor-number-$label'),
    children: [
      Row(
        children: [
          Expanded(
            child: Tooltip(
              message: editorPropertyHelp(label),
              child: HyperText(
                '$label  ${value.toStringAsFixed(wholeNumbers ? 0 : 2)}',
              ),
            ),
          ),
          HyperIconButton.ghost(
            tooltip: overridden ? '恢复继承' : '继承默认',
            onPressed: overridden ? () => _change(reset) : null,
            icon: Icon(overridden ? Icons.restart_alt : Icons.link, size: 16),
          ),
        ],
      ),
      HyperSlider(
        value: value.clamp(min, max),
        min: min,
        max: max,
        divisions: wholeNumbers ? (max - min).round() : null,
        onChangeStart: (_) => _gestureStart = _document.encode(),
        onChangeEnd: (_) => _endGesture(),
        onChanged: (value) => _change(
          () => changed(wholeNumbers ? value.roundToDouble() : value),
        ),
      ),
    ],
  );
  Future<Color?> _pickColor(String title, Color initial) =>
      showHyperColorPickerDialog(
        context: context,
        initialColor: initial,
        title: Text(title),
      );

  Widget _color(
    String label,
    EditorColor? color,
    ValueChanged<EditorColor?> changed,
  ) {
    final colors = _document.resolve(_dark).colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _select(
          label,
          color?.semantic ?? (color == null ? 'inherit' : 'custom'),
          {
            'inherit': '恢复默认',
            'primary': '预设 · 主色',
            'surface': '预设 · 表面',
            'textPrimary': '预设 · 正文',
            'outline': '预设 · 边框',
            'custom': '自定义 ARGB',
          },
          (value) async {
            if (value == 'custom') {
              final picked = await _pickColor(
                label,
                color?.resolve(colors) ?? colors.primary,
              );
              if (picked != null && mounted) {
                _change(() => changed(EditorColor(argb: picked.toARGB32())));
              }
            } else {
              _change(
                () => changed(
                  value == 'inherit' ? null : EditorColor(semantic: value),
                ),
              );
            }
          },
        ),
        if (color?.argb != null)
          HyperColorPickerField(
            value: color!.resolve(colors),
            onChanged: (value) =>
                _change(() => changed(EditorColor(argb: value.toARGB32()))),
          )
        else if (color != null)
          Container(
            height: 12,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: color.resolve(colors),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        Wrap(
          spacing: 4,
          children: [
            for (final entry in const <String, int>{
              '蓝色': 0xff3482ff,
              '橙色': 0xffff6900,
              '紫色': 0xff7e57c2,
              '绿色': 0xff2e7d32,
            }.entries)
              HyperIconButton.ghost(
                tooltip: '使用${entry.key}',
                icon: Icon(Icons.circle, color: Color(entry.value)),
                onPressed: () =>
                    _change(() => changed(EditorColor(argb: entry.value))),
              ),
          ],
        ),
      ],
    );
  }

  Widget _semanticColor(
    String label,
    Color effective,
    Color? override,
    ValueChanged<Color?> changed,
  ) => Padding(
    key: ValueKey('editor-color-$label'),
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(
      children: [
        Expanded(
          flex: 4,
          child: Tooltip(
            triggerMode: TooltipTriggerMode.tap,
            message: '$label\n${editorPropertyHelp(label)}',
            child: Row(
              children: [
                Expanded(
                  child: HyperText(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 3),
                Icon(
                  Icons.info_outline,
                  size: 12,
                  color: HyperTheme.of(context).colors.textTertiary,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),
        SizedBox(
          width: 40,
          child: HyperColorPickerField(
            value: effective,
            display: HyperColorPickerFieldDisplay.swatch,
            buttonStyle: HyperButtonStyle(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              iconSize: 20,
              textStyle: TextStyle(fontSize: 11),
              minimumTapTargetSize: Size(0, 32),
              minimumSize: Size(0, 32),
            ),
            onChanged: (value) => _change(() => changed(value)),
          ),
        ),
        HyperIconButton.ghost(
          tooltip: override == null ? '继承默认' : '恢复继承',
          style: HyperIconButtonStyle(size: 24, minimumTapTargetSize: 24),
          onPressed: override == null
              ? null
              : () => _change(() => changed(null)),
          icon: Icon(
            override == null ? Icons.link : Icons.restart_alt,
            size: 14,
          ),
        ),
      ],
    ),
  );

  Widget _globalPanel() {
    final theme = _document.resolve(_dark),
        typo = theme.typographyTheme.resolve(_device);
    return _panel('全局工作区', [
      const HyperText('编辑设备'),
      Row(
        children: [
          Expanded(
            child: HyperSegmentedButton<HyperDeviceType>(
              expanded: true,
              showLabels: false,
              segments: const [
                HyperSegment(
                  value: HyperDeviceType.phone,
                  label: '手机',
                  icon: Icon(Icons.smartphone),
                ),
                HyperSegment(
                  value: HyperDeviceType.tablet,
                  label: '平板',
                  icon: Icon(Icons.tablet_mac),
                ),
                HyperSegment(
                  value: HyperDeviceType.desktop,
                  label: '桌面',
                  icon: Icon(Icons.desktop_windows_outlined),
                ),
                HyperSegment(
                  value: HyperDeviceType.watch,
                  label: '手表',
                  icon: Icon(Icons.watch_outlined),
                ),
              ],
              selected: {_device},
              onSelectionChanged: (value) => setState(() {
                _device = value.single;
                _landscape = _device == HyperDeviceType.desktop;
              }),
            ),
          ),
          const SizedBox(width: 8),
          HyperIconButton.outlined(
            tooltip: _landscape ? '当前横屏，切换竖屏' : '当前竖屏，切换横屏',
            onPressed: () => setState(() => _landscape = !_landscape),
            icon: Icon(
              _landscape
                  ? Icons.stay_current_landscape
                  : Icons.stay_current_portrait,
            ),
          ),
        ],
      ),
      _heading('明暗方案'),
      HyperSegmentedButton<bool>(
        expanded: true,
        showLabels: false,
        segments: const [
          HyperSegment(
            value: false,
            label: '亮色',
            icon: Icon(Icons.light_mode_outlined),
          ),
          HyperSegment(
            value: true,
            label: '暗色',
            icon: Icon(Icons.dark_mode_outlined),
          ),
        ],
        selected: {_dark},
        onSelectionChanged: (value) => setState(() => _dark = value.single),
      ),
      _heading('文字缩放'),
      HyperSegmentedButton<double>(
        expanded: true,
        segments: const [
          HyperSegment(value: 1.0, label: '1.0×'),
          HyperSegment(value: 1.3, label: '1.3×'),
          HyperSegment(value: 2.0, label: '2.0×'),
        ],
        selected: {_textScale},
        onSelectionChanged: (value) =>
            setState(() => _textScale = value.single),
      ),
      const HyperText('当前方案独立编辑；尺寸与字阶属于当前设备。'),
      _heading('基础配色'),
      _semanticColor(
        '生成基础配色',
        Color(_mode.seed ?? 0xff3482ff),
        _mode.seed == null ? null : Color(_mode.seed!),
        (value) => _mode.seed = value?.toARGB32(),
      ),
      const HyperText('生成整套基础颜色，已单独修改的语义颜色保留。'),
      _heading('语义颜色 · 当前明暗方案'),
      _semanticColor(
        'primary',
        theme.colors.primary,
        _mode.palette.primary,
        (value) => _mode.palette.primary = value,
      ),
      _semanticColor(
        'onPrimary',
        theme.colors.onPrimary,
        _mode.palette.onPrimary,
        (value) => _mode.palette.onPrimary = value,
      ),
      _semanticColor(
        'primaryContainer',
        theme.colors.primaryContainer,
        _mode.palette.primaryContainer,
        (value) => _mode.palette.primaryContainer = value,
      ),
      _semanticColor(
        'onPrimaryContainer',
        theme.colors.onPrimaryContainer,
        _mode.palette.onPrimaryContainer,
        (value) => _mode.palette.onPrimaryContainer = value,
      ),
      _semanticColor(
        'background',
        theme.colors.background,
        _mode.palette.background,
        (value) => _mode.palette.background = value,
      ),
      _semanticColor(
        'onBackground',
        theme.colors.onBackground,
        _mode.palette.onBackground,
        (value) => _mode.palette.onBackground = value,
      ),
      _semanticColor(
        'surface',
        theme.colors.surface,
        _mode.palette.surface,
        (value) => _mode.palette.surface = value,
      ),
      _semanticColor(
        'onSurface',
        theme.colors.onSurface,
        _mode.palette.onSurface,
        (value) => _mode.palette.onSurface = value,
      ),
      _semanticColor(
        'surfaceElevated',
        theme.colors.surfaceElevated,
        _mode.palette.surfaceElevated,
        (value) => _mode.palette.surfaceElevated = value,
      ),
      _semanticColor(
        'onSurfaceElevated',
        theme.colors.onSurfaceElevated,
        _mode.palette.onSurfaceElevated,
        (value) => _mode.palette.onSurfaceElevated = value,
      ),
      _semanticColor(
        'surfaceMuted',
        theme.colors.surfaceMuted,
        _mode.palette.surfaceMuted,
        (value) => _mode.palette.surfaceMuted = value,
      ),
      _semanticColor(
        'onSurfaceMuted',
        theme.colors.onSurfaceMuted,
        _mode.palette.onSurfaceMuted,
        (value) => _mode.palette.onSurfaceMuted = value,
      ),
      _semanticColor(
        'textPrimary',
        theme.colors.textPrimary,
        _mode.palette.textPrimary,
        (value) => _mode.palette.textPrimary = value,
      ),
      _semanticColor(
        'textSecondary',
        theme.colors.textSecondary,
        _mode.palette.textSecondary,
        (value) => _mode.palette.textSecondary = value,
      ),
      _semanticColor(
        'textTertiary',
        theme.colors.textTertiary,
        _mode.palette.textTertiary,
        (value) => _mode.palette.textTertiary = value,
      ),
      _semanticColor(
        'outline',
        theme.colors.outline,
        _mode.palette.outline,
        (value) => _mode.palette.outline = value,
      ),
      _semanticColor(
        'disabled',
        theme.colors.disabled,
        _mode.palette.disabled,
        (value) => _mode.palette.disabled = value,
      ),
      _semanticColor(
        'stateLayer',
        theme.colors.stateLayer,
        _mode.palette.stateLayer,
        (value) => _mode.palette.stateLayer = value,
      ),
      _semanticColor(
        'scrim',
        theme.colors.scrim,
        _mode.palette.scrim,
        (value) => _mode.palette.scrim = value,
      ),
      _semanticColor(
        'error',
        theme.colors.error,
        _mode.palette.error,
        (value) => _mode.palette.error = value,
      ),
      _semanticColor(
        'onError',
        theme.colors.onError,
        _mode.palette.onError,
        (value) => _mode.palette.onError = value,
      ),
      _semanticColor(
        'success',
        theme.colors.success,
        _mode.palette.success,
        (value) => _mode.palette.success = value,
      ),
      _semanticColor(
        'onSuccess',
        theme.colors.onSuccess,
        _mode.palette.onSuccess,
        (value) => _mode.palette.onSuccess = value,
      ),
      _semanticColor(
        'warning',
        theme.colors.warning,
        _mode.palette.warning,
        (value) => _mode.palette.warning = value,
      ),
      _semanticColor(
        'onWarning',
        theme.colors.onWarning,
        _mode.palette.onWarning,
        (value) => _mode.palette.onWarning = value,
      ),
      _heading('字体'),
      HyperTextField(
        key: ValueKey('font/$_dark/${_mode.fontFamily}'),
        initialValue: _mode.fontFamily ?? '',
        hintText: '系统默认字体',
        onSubmitted: (v) => _change(
          () => _mode.fontFamily = v.trim().isEmpty ? null : v.trim(),
        ),
      ),
      _heading('语义字阶 · ${_devices[_device]}'),
      _number(
        '正文',
        typo.body,
        8,
        40,
        (value) => _spec.body = value,
        () => _spec.body = null,
        _spec.body != null,
      ),
      _number(
        '控件文字',
        typo.control,
        8,
        40,
        (value) => _spec.control = value,
        () => _spec.control = null,
        _spec.control != null,
      ),
      _number(
        '展示大字',
        typo.displayLarge,
        8,
        96,
        (v) => _spec.typography.displayLarge = v,
        () => _spec.typography.displayLarge = null,
        _spec.typography.displayLarge != null,
        wholeNumbers: true,
      ),
      _number(
        '展示中字',
        typo.displayMedium,
        8,
        96,
        (v) => _spec.typography.displayMedium = v,
        () => _spec.typography.displayMedium = null,
        _spec.typography.displayMedium != null,
        wholeNumbers: true,
      ),
      _number(
        '展示小字',
        typo.displaySmall,
        8,
        96,
        (v) => _spec.typography.displaySmall = v,
        () => _spec.typography.displaySmall = null,
        _spec.typography.displaySmall != null,
        wholeNumbers: true,
      ),
      _number(
        '页面标题',
        typo.pageTitle,
        8,
        96,
        (v) => _spec.typography.pageTitle = v,
        () => _spec.typography.pageTitle = null,
        _spec.typography.pageTitle != null,
        wholeNumbers: true,
      ),
      _number(
        '章节标题',
        typo.sectionTitle,
        8,
        96,
        (v) => _spec.typography.sectionTitle = v,
        () => _spec.typography.sectionTitle = null,
        _spec.typography.sectionTitle != null,
        wholeNumbers: true,
      ),
      _number(
        '小节标题',
        typo.subsectionTitle,
        8,
        96,
        (v) => _spec.typography.subsectionTitle = v,
        () => _spec.typography.subsectionTitle = null,
        _spec.typography.subsectionTitle != null,
        wholeNumbers: true,
      ),
      _number(
        '大正文',
        typo.bodyLarge,
        8,
        96,
        (v) => _spec.typography.bodyLarge = v,
        () => _spec.typography.bodyLarge = null,
        _spec.typography.bodyLarge != null,
        wholeNumbers: true,
      ),
      _number(
        '小正文',
        typo.bodySmall,
        8,
        96,
        (v) => _spec.typography.bodySmall = v,
        () => _spec.typography.bodySmall = null,
        _spec.typography.bodySmall != null,
        wholeNumbers: true,
      ),
      _number(
        '面包屑',
        typo.breadcrumb,
        8,
        96,
        (v) => _spec.typography.breadcrumb = v,
        () => _spec.typography.breadcrumb = null,
        _spec.typography.breadcrumb != null,
        wholeNumbers: true,
      ),
      _number(
        '列表标题',
        typo.listTitle,
        8,
        96,
        (v) => _spec.typography.listTitle = v,
        () => _spec.typography.listTitle = null,
        _spec.typography.listTitle != null,
        wholeNumbers: true,
      ),
      _number(
        '列表副标题',
        typo.listSubtitle,
        8,
        96,
        (v) => _spec.typography.listSubtitle = v,
        () => _spec.typography.listSubtitle = null,
        _spec.typography.listSubtitle != null,
        wholeNumbers: true,
      ),
      _number(
        '列表标题行高',
        typo.listTitleLineHeight,
        0.5,
        4,
        (v) => _spec.typography.listTitleLineHeight = v,
        () => _spec.typography.listTitleLineHeight = null,
        _spec.typography.listTitleLineHeight != null,
        wholeNumbers: false,
      ),
      _number(
        '列表副标题行高',
        typo.listSubtitleLineHeight,
        0.5,
        4,
        (v) => _spec.typography.listSubtitleLineHeight = v,
        () => _spec.typography.listSubtitleLineHeight = null,
        _spec.typography.listSubtitleLineHeight != null,
        wholeNumbers: false,
      ),
      _number(
        '卡片标题',
        typo.cardTitle,
        8,
        96,
        (v) => _spec.typography.cardTitle = v,
        () => _spec.typography.cardTitle = null,
        _spec.typography.cardTitle != null,
        wholeNumbers: true,
      ),
      _number(
        '标签',
        typo.label,
        8,
        96,
        (v) => _spec.typography.label = v,
        () => _spec.typography.label = null,
        _spec.typography.label != null,
        wholeNumbers: true,
      ),
      _number(
        '说明文字',
        typo.caption,
        8,
        96,
        (v) => _spec.typography.caption = v,
        () => _spec.typography.caption = null,
        _spec.typography.caption != null,
        wholeNumbers: true,
      ),
      _heading('公共尺寸 · ${_devices[_device]}'),
      _number(
        '导航项间距',
        theme.sizes.resolve(_device).navigationItemSpacing,
        0,
        200,
        (v) => _spec.layout.navigationItemSpacing = v,
        () => _spec.layout.navigationItemSpacing = null,
        _spec.layout.navigationItemSpacing != null,
      ),
      _number(
        '特小控件高度',
        theme.sizes.resolve(_device).controlHeightXs,
        0,
        200,
        (v) => _spec.layout.controlHeightXs = v,
        () => _spec.layout.controlHeightXs = null,
        _spec.layout.controlHeightXs != null,
      ),
      _number(
        '小控件高度',
        theme.sizes.resolve(_device).controlHeightSm,
        0,
        200,
        (v) => _spec.layout.controlHeightSm = v,
        () => _spec.layout.controlHeightSm = null,
        _spec.layout.controlHeightSm != null,
      ),
      _number(
        '中控件高度',
        theme.sizes.resolve(_device).controlHeightMd,
        0,
        200,
        (v) => _spec.layout.controlHeightMd = v,
        () => _spec.layout.controlHeightMd = null,
        _spec.layout.controlHeightMd != null,
      ),
      _number(
        '大控件高度',
        theme.sizes.resolve(_device).controlHeightLg,
        0,
        200,
        (v) => _spec.layout.controlHeightLg = v,
        () => _spec.layout.controlHeightLg = null,
        _spec.layout.controlHeightLg != null,
      ),
      _number(
        '特大控件高度',
        theme.sizes.resolve(_device).controlHeightXl,
        0,
        200,
        (v) => _spec.layout.controlHeightXl = v,
        () => _spec.layout.controlHeightXl = null,
        _spec.layout.controlHeightXl != null,
      ),
      _number(
        '最小触控尺寸',
        theme.sizes.resolve(_device).minimumInteractiveDimension,
        0,
        200,
        (v) => _spec.layout.minimumInteractiveDimension = v,
        () => _spec.layout.minimumInteractiveDimension = null,
        _spec.layout.minimumInteractiveDimension != null,
      ),
      _number(
        '控件圆角',
        theme.sizes.resolve(_device).controlRadius,
        0,
        200,
        (v) => _spec.layout.controlRadius = v,
        () => _spec.layout.controlRadius = null,
        _spec.layout.controlRadius != null,
      ),
      _number(
        '表面圆角',
        theme.sizes.resolve(_device).surfaceRadius,
        0,
        200,
        (v) => _spec.layout.surfaceRadius = v,
        () => _spec.layout.surfaceRadius = null,
        _spec.layout.surfaceRadius != null,
      ),
      _number(
        '浮层圆角',
        theme.sizes.resolve(_device).overlayRadius,
        0,
        200,
        (v) => _spec.layout.overlayRadius = v,
        () => _spec.layout.overlayRadius = null,
        _spec.layout.overlayRadius != null,
      ),
      _number(
        '浮层间距',
        theme.sizes.resolve(_device).overlaySpacing,
        0,
        200,
        (v) => _spec.layout.overlaySpacing = v,
        () => _spec.layout.overlaySpacing = null,
        _spec.layout.overlaySpacing != null,
      ),
      _number(
        '页面水平留白',
        theme.sizes.resolve(_device).pageHorizontalPadding,
        0,
        200,
        (v) => _spec.layout.pageHorizontalPadding = v,
        () => _spec.layout.pageHorizontalPadding = null,
        _spec.layout.pageHorizontalPadding != null,
      ),
      _number(
        '紧凑章节间距',
        theme.sizes.resolve(_device).compactSectionSpacing,
        0,
        200,
        (v) => _spec.layout.compactSectionSpacing = v,
        () => _spec.layout.compactSectionSpacing = null,
        _spec.layout.compactSectionSpacing != null,
      ),
      _number(
        '章节间距',
        theme.sizes.resolve(_device).sectionSpacing,
        0,
        200,
        (v) => _spec.layout.sectionSpacing = v,
        () => _spec.layout.sectionSpacing = null,
        _spec.layout.sectionSpacing != null,
      ),
      _number(
        '紧凑工具栏高度',
        theme.sizes.resolve(_device).toolbarCompactHeight,
        0,
        200,
        (v) => _spec.layout.toolbarCompactHeight = v,
        () => _spec.layout.toolbarCompactHeight = null,
        _spec.layout.toolbarCompactHeight != null,
      ),
      _number(
        '工具栏高度',
        theme.sizes.resolve(_device).toolbarHeight,
        0,
        200,
        (v) => _spec.layout.toolbarHeight = v,
        () => _spec.layout.toolbarHeight = null,
        _spec.layout.toolbarHeight != null,
      ),
      _number(
        '强调工具栏高度',
        theme.sizes.resolve(_device).toolbarEmphasizedHeight,
        0,
        200,
        (v) => _spec.layout.toolbarEmphasizedHeight = v,
        () => _spec.layout.toolbarEmphasizedHeight = null,
        _spec.layout.toolbarEmphasizedHeight != null,
      ),
      _number(
        '图标尺寸',
        theme.sizes.resolve(_device).iconSize,
        0,
        200,
        (v) => _spec.layout.iconSize = v,
        () => _spec.layout.iconSize = null,
        _spec.layout.iconSize != null,
      ),
      _heading('控件内边距'),
      _number(
        '左',
        theme.sizes
            .resolve(_device)
            .controlPadding
            .resolve(TextDirection.ltr)
            .left,
        0,
        200,
        (v) => _spec.layout.paddingLeft = v,
        () => _spec.layout.paddingLeft = null,
        _spec.layout.paddingLeft != null,
      ),
      _number(
        '上',
        theme.sizes
            .resolve(_device)
            .controlPadding
            .resolve(TextDirection.ltr)
            .top,
        0,
        200,
        (v) => _spec.layout.paddingTop = v,
        () => _spec.layout.paddingTop = null,
        _spec.layout.paddingTop != null,
      ),
      _number(
        '右',
        theme.sizes
            .resolve(_device)
            .controlPadding
            .resolve(TextDirection.ltr)
            .right,
        0,
        200,
        (v) => _spec.layout.paddingRight = v,
        () => _spec.layout.paddingRight = null,
        _spec.layout.paddingRight != null,
      ),
      _number(
        '下',
        theme.sizes
            .resolve(_device)
            .controlPadding
            .resolve(TextDirection.ltr)
            .bottom,
        0,
        200,
        (v) => _spec.layout.paddingBottom = v,
        () => _spec.layout.paddingBottom = null,
        _spec.layout.paddingBottom != null,
      ),
      _heading('动效与对比度'),
      _number(
        '快速时长（毫秒）',
        _mode.behavior.fastDuration ??
            theme.motion.fastDuration.inMilliseconds.toDouble(),
        0,
        2000,
        (v) => _mode.behavior.fastDuration = v,
        () => _mode.behavior.fastDuration = null,
        _mode.behavior.fastDuration != null,
        wholeNumbers: true,
      ),
      _number(
        '标准时长（毫秒）',
        _mode.behavior.standardDuration ??
            theme.motion.standardDuration.inMilliseconds.toDouble(),
        0,
        2000,
        (v) => _mode.behavior.standardDuration = v,
        () => _mode.behavior.standardDuration = null,
        _mode.behavior.standardDuration != null,
        wholeNumbers: true,
      ),
      _number(
        '强调时长（毫秒）',
        _mode.behavior.emphasizedDuration ??
            theme.motion.emphasizedDuration.inMilliseconds.toDouble(),
        0,
        2000,
        (v) => _mode.behavior.emphasizedDuration = v,
        () => _mode.behavior.emphasizedDuration = null,
        _mode.behavior.emphasizedDuration != null,
        wholeNumbers: true,
      ),
      _number(
        '弹簧质量',
        _mode.behavior.springMass ?? theme.motion.spring.mass,
        0.01,
        100,
        (v) => _mode.behavior.springMass = v,
        () => _mode.behavior.springMass = null,
        _mode.behavior.springMass != null,
        wholeNumbers: false,
      ),
      _number(
        '弹簧刚度',
        _mode.behavior.springStiffness ?? theme.motion.spring.stiffness,
        0.01,
        2000,
        (v) => _mode.behavior.springStiffness = v,
        () => _mode.behavior.springStiffness = null,
        _mode.behavior.springStiffness != null,
        wholeNumbers: false,
      ),
      _number(
        '弹簧阻尼',
        _mode.behavior.springDamping ?? theme.motion.spring.damping,
        0,
        200,
        (v) => _mode.behavior.springDamping = v,
        () => _mode.behavior.springDamping = null,
        _mode.behavior.springDamping != null,
        wholeNumbers: false,
      ),
      _number(
        '材质淡入阶段占比',
        _mode.behavior.transitionFadeFraction ??
            theme.materialTheme.transitionFadeFraction ??
            .6,
        0.01,
        0.99,
        (v) => _mode.behavior.transitionFadeFraction = v,
        () => _mode.behavior.transitionFadeFraction = null,
        _mode.behavior.transitionFadeFraction != null,
        wholeNumbers: false,
      ),
      _number(
        '最低对比度',
        _mode.behavior.minimumContrastRatio ??
            theme.contrastTheme.minimumContrastRatio,
        1,
        21,
        (v) => _mode.behavior.minimumContrastRatio = v,
        () => _mode.behavior.minimumContrastRatio = null,
        _mode.behavior.minimumContrastRatio != null,
        wholeNumbers: false,
      ),
      _select(
        '快速曲线',
        _mode.behavior.fastCurve?.name ?? 'inherit',
        {'inherit': '继承默认', for (final v in EditorCurve.values) v.name: v.name},
        (v) => _change(
          () => _mode.behavior.fastCurve = v == 'inherit'
              ? null
              : EditorCurve.values.byName(v),
        ),
      ),
      _select(
        '标准曲线',
        _mode.behavior.standardCurve?.name ?? 'inherit',
        {'inherit': '继承默认', for (final v in EditorCurve.values) v.name: v.name},
        (v) => _change(
          () => _mode.behavior.standardCurve = v == 'inherit'
              ? null
              : EditorCurve.values.byName(v),
        ),
      ),
      _select(
        '强调曲线',
        _mode.behavior.emphasizedCurve?.name ?? 'inherit',
        {'inherit': '继承默认', for (final v in EditorCurve.values) v.name: v.name},
        (v) => _change(
          () => _mode.behavior.emphasizedCurve = v == 'inherit'
              ? null
              : EditorCurve.values.byName(v),
        ),
      ),
      _select(
        '材质质量',
        _mode.behavior.quality?.name ?? 'inherit',
        {
          'inherit': '继承默认',
          for (final v in HyperMaterialQuality.values)
            v.name: v == HyperMaterialQuality.advanced ? '高级材质' : '普通质量',
        },
        (v) => _change(
          () => _mode.behavior.quality = v == 'inherit'
              ? null
              : HyperMaterialQuality.values.byName(v),
        ),
      ),
      _select(
        '前景反色策略',
        _mode.behavior.contrastMode?.name ?? 'inherit',
        {
          'inherit': '继承默认',
          for (final v in HyperContrastMode.values)
            v.name: switch (v) {
              HyperContrastMode.standard => '标准',
              HyperContrastMode.adaptive => '自适应',
              HyperContrastMode.inverted => '反色',
            },
        },
        (v) => _change(
          () => _mode.behavior.contrastMode = v == 'inherit'
              ? null
              : HyperContrastMode.values.byName(v),
        ),
      ),
      _select(
        '减少透明度',
        _mode.behavior.reduceTransparency?.toString() ?? 'inherit',
        const {'inherit': '继承默认', 'true': '开启', 'false': '关闭'},
        (v) => _change(
          () => _mode.behavior.reduceTransparency = v == 'inherit'
              ? null
              : v == 'true',
        ),
      ),
      _semanticColor(
        '浅色前景',
        theme.contrastTheme.lightForeground,
        _mode.behavior.lightForeground,
        (v) => _mode.behavior.lightForeground = v,
      ),
      _semanticColor(
        '深色前景',
        theme.contrastTheme.darkForeground,
        _mode.behavior.darkForeground,
        (v) => _mode.behavior.darkForeground = v,
      ),
      _heading('背景材质'),
      _select(
        '配方',
        _mode.material?.name ?? 'inherit',
        {
          'inherit': '继承默认',
          for (final kind in HyperSurfaceMaterialKind.values)
            kind.name: switch (kind) {
              HyperSurfaceMaterialKind.solid => '普通填充',
              HyperSurfaceMaterialKind.translucent => '半透明',
              HyperSurfaceMaterialKind.frostedGlass => '毛玻璃',
              HyperSurfaceMaterialKind.softLightGlass => '柔光玻璃',
            },
        },
        (value) => _change(() {
          _mode.material = value == 'inherit'
              ? null
              : HyperSurfaceMaterialKind.values.byName(value);
          if (value == 'inherit') {
            _mode.opacity = null;
            _mode.blur = null;
            _mode.blurY = null;
            _mode.materialTint = null;
            _mode.materialBorder = null;
            _mode.materialBorderWidth = null;
            _mode.materialAppearance.background = null;
            _mode.materialAppearance.shadows = null;
          }
        }),
      ),
      ...[
        _number(
          '背景不透明度',
          _mode.opacity ??
              (_mode.material == HyperSurfaceMaterialKind.solid ? 1 : .75),
          0,
          1,
          (value) {
            _mode.material ??= HyperSurfaceMaterialKind.softLightGlass;
            _mode.opacity = value;
          },
          () => _mode.opacity = null,
          _mode.opacity != null,
          wholeNumbers: false,
        ),
        _number(
          '水平模糊',
          _mode.blur ??
              (_mode.material == HyperSurfaceMaterialKind.softLightGlass
                  ? 28
                  : 20),
          0,
          80,
          (value) {
            _mode.material ??= HyperSurfaceMaterialKind.softLightGlass;
            _mode.blur = value;
          },
          () => _mode.blur = null,
          _mode.blur != null,
        ),
      ],
      _color('材质背景', _mode.materialAppearance.background, (v) {
        _mode.material ??= HyperSurfaceMaterialKind.softLightGlass;
        _mode.materialAppearance.background = v;
      }),
      _color('材质染色', _mode.materialTint, (v) {
        _mode.material ??= HyperSurfaceMaterialKind.softLightGlass;
        _mode.materialTint = v;
      }),
      _color('材质边框', _mode.materialBorder, (v) {
        _mode.material ??= HyperSurfaceMaterialKind.softLightGlass;
        _mode.materialBorder = v;
      }),
      _number(
        '材质边框宽度',
        _mode.materialBorderWidth ?? 0,
        0,
        20,
        (v) {
          _mode.material ??= HyperSurfaceMaterialKind.softLightGlass;
          _mode.materialBorderWidth = v;
        },
        () => _mode.materialBorderWidth = null,
        _mode.materialBorderWidth != null,
        wholeNumbers: false,
      ),
      _heading('材质阴影'),
      Wrap(
        spacing: 8,
        children: [
          HyperButton.ghost(
            onPressed: () =>
                _change(() => _mode.materialAppearance.shadows = null),
            child: const Text('恢复默认'),
          ),
          HyperButton.ghost(
            onPressed: () => _change(() {
              _mode.material ??= HyperSurfaceMaterialKind.softLightGlass;
              _mode.materialAppearance.shadows = [];
            }),
            child: const Text('无阴影'),
          ),
          HyperButton.tonal(
            onPressed: () => _change(() {
              _mode.material ??= HyperSurfaceMaterialKind.softLightGlass;
              _mode.materialAppearance.shadows = [
                ...?_mode.materialAppearance.shadows,
                EditorShadow(),
              ];
            }),
            child: const Text('增加一层'),
          ),
        ],
      ),
      for (var i = 0; i < (_mode.materialAppearance.shadows?.length ?? 0); i++)
        _shadow(i, target: _mode.materialAppearance),
      const HyperText('材质仅作用于继承该配方的预览表面，文字保持清晰。'),
    ]);
  }

  Widget _componentPanel() => Obx(_buildComponentPanel);

  Widget _buildComponentPanel() {
    final s = _document.resolve(_dark).sizes.resolve(_device), a = _appearance;
    return _panel('组件工作区', [
      Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          for (final entry in _components.entries)
            HyperButton.tonal(
              onPressed: entry.key == _component
                  ? null
                  : () => rxBatch(() {
                      _component = entry.key;
                      if (_page != 'all') _page = _pages[entry.key]!;
                    }),
              child: Text(entry.value),
            ),
        ],
      ),
      HyperText('${_devices[_device]}尺寸 · ${_dark ? '暗色' : '亮色'}外观'),
      HyperButton.ghost(
        onPressed: () => _change(() {
          a.background = null;
          a.foreground = null;
          a.shadows = null;
          switch (_component) {
            case 'button':
              _spec.buttonHeight = null;
              _spec.buttonRadius = null;
            case 'card':
              _spec.cardRadius = null;
            case 'field':
              _spec.fieldHeight = null;
              _spec.fieldRadius = null;
            case 'menu':
              _spec.menuHeight = null;
              _spec.menuRadius = null;
          }
        }),
        child: const Text('重置当前组件'),
      ),
      _heading('尺寸'),
      if (_component == 'button') ...[
        _number(
          '中号高度',
          s.button.minimumSize.height,
          20,
          100,
          (v) => _spec.buttonHeight = v,
          () => _spec.buttonHeight = null,
          _spec.buttonHeight != null,
        ),
        _number(
          '圆角',
          s.button.radius,
          0,
          60,
          (v) => _spec.buttonRadius = v,
          () => _spec.buttonRadius = null,
          _spec.buttonRadius != null,
        ),
      ],
      if (_component == 'card')
        _number(
          '圆角',
          s.card.radius,
          0,
          60,
          (v) => _spec.cardRadius = v,
          () => _spec.cardRadius = null,
          _spec.cardRadius != null,
        ),
      if (_component == 'field') ...[
        _number(
          '最小高度',
          s.textField.minimumHeight,
          20,
          100,
          (v) => _spec.fieldHeight = v,
          () => _spec.fieldHeight = null,
          _spec.fieldHeight != null,
        ),
        _number(
          '圆角',
          s.textField.radius,
          0,
          60,
          (v) => _spec.fieldRadius = v,
          () => _spec.fieldRadius = null,
          _spec.fieldRadius != null,
        ),
      ],
      if (_component == 'menu') ...[
        _number(
          '菜单行高',
          s.menu.itemHeight,
          20,
          100,
          (v) => _spec.menuHeight = v,
          () => _spec.menuHeight = null,
          _spec.menuHeight != null,
        ),
        _number(
          '表面圆角',
          s.menu.surfaceRadius,
          0,
          60,
          (v) => _spec.menuRadius = v,
          () => _spec.menuRadius = null,
          _spec.menuRadius != null,
        ),
      ],
      _heading('通用外观'),
      _color('背景', a.background, (value) => a.background = value),
      _color('前景', a.foreground, (value) => a.foreground = value),
      _heading('彩色阴影'),
      Wrap(
        spacing: 8,
        children: [
          HyperButton.ghost(
            onPressed: () => _change(() => a.shadows = null),
            child: const Text('恢复默认'),
          ),
          HyperButton.ghost(
            onPressed: () => _change(() => a.shadows = []),
            child: const Text('无阴影'),
          ),
          HyperButton.tonal(
            onPressed: () =>
                _change(() => a.shadows = [...?a.shadows, EditorShadow()]),
            child: const Text('添加'),
          ),
        ],
      ),
      if (a.shadows == null) const HyperText('继承组件默认阴影'),
      for (var i = 0; i < (a.shadows?.length ?? 0); i++) _shadow(i),
      _heading('编辑范围'),
      const HyperText('本版编辑通用外观与当前端尺寸；状态与变体仍沿用组件默认配方。所有同类预览组件同步更新。'),
    ]);
  }

  Widget _shadow(int index, {EditorComponent? target}) {
    final appearance = target ?? _appearance;
    final s = appearance.shadows![index];
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: HyperText('第 ${index + 1} 层')),
            HyperIconButton.ghost(
              tooltip: '删除阴影',
              onPressed: () => _change(
                () =>
                    appearance.shadows = [...appearance.shadows!]
                      ..removeAt(index),
              ),
              icon: const Icon(Icons.delete_outline),
            ),
          ],
        ),
        _color(
          '颜色',
          s.color,
          (value) => s.color = value ?? const EditorColor(semantic: 'primary'),
        ),
        _number(
          '阴影不透明度',
          s.opacity,
          0,
          1,
          (v) => s.opacity = v,
          () => s.opacity = .2,
          true,
          wholeNumbers: false,
        ),
        _number('水平偏移', s.dx, -40, 40, (v) => s.dx = v, () => s.dx = 0, true),
        _number('垂直偏移', s.dy, -40, 40, (v) => s.dy = v, () => s.dy = 4, true),
        _number(
          '模糊',
          s.blur,
          0,
          80,
          (v) => s.blur = v,
          () => s.blur = 16,
          true,
        ),
        _number(
          '扩散',
          s.spread,
          -20,
          40,
          (v) => s.spread = v,
          () => s.spread = 0,
          true,
        ),
      ],
    );
  }

  Widget _preview() {
    final theme = _document.resolve(_dark);
    return Column(
      children: [
        Obx(
          () => EditorComponentNavigation(
            page: _page,
            onSelected: (value) => rxBatch(() {
              _page = value;
              for (final entry in _pages.entries) {
                if (entry.value == value) _component = entry.key;
              }
            }),
          ),
        ),
        const HyperDivider(),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) => Obx(() {
              var size = switch (_device) {
                HyperDeviceType.phone => const Size(390, 844),
                HyperDeviceType.tablet => const Size(834, 1194),
                HyperDeviceType.desktop => const Size(1280, 800),
                HyperDeviceType.watch => const Size(220, 220),
              };
              if (_landscape != (size.width > size.height)) size = size.flipped;
              final item = _page == 'all'
                  ? null
                  : galleryItems.firstWhere((item) => item.id == _page);
              return ColoredBox(
                color: HyperTheme.of(context).colors.surfaceMuted,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: _DevicePreviewFrame(
                      device: _device,
                      child: SizedBox(
                        width: size.width,
                        height: size.height,
                        child: MaterialApp(
                          key: ValueKey('$_device/$_page'),
                          debugShowCheckedModeBanner: false,
                          theme: theme.toMaterialThemeData(),
                          builder: (context, child) => MediaQuery(
                            data: MediaQuery.of(context).copyWith(
                              size: size,
                              textScaler: TextScaler.linear(_textScale),
                            ),
                            child: HyperNavigatorScope(
                              useRootNavigator: false,
                              child: HyperDeviceDetector(
                                deviceType: _device,
                                builder: (context, device, _) => HyperTheme(
                                  data: theme,
                                  duration: Duration.zero,
                                  child: child!,
                                ),
                              ),
                            ),
                          ),
                          home: item == null
                              ? const GalleryShell()
                              : Builder(
                                  builder: (context) => HyperScaffold(
                                    body: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(16),
                                          child: HyperText(item.title),
                                        ),
                                        if (item.hasStyleOverrides)
                                          const HyperText(
                                            GalleryItem.styleOverridesNotice,
                                          ),
                                        Expanded(child: item.builder(context)),
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: HyperText('${_devices[_device]} · 模拟画布 · UI 未审核'),
        ),
      ],
    );
  }
}

/// 仅绘制设备外框，不进入预览的主题作用域或改变画布逻辑尺寸。
class _DevicePreviewFrame extends StatelessWidget {
  const _DevicePreviewFrame({required this.device, required this.child});
  final HyperDeviceType device;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final theme = HyperTheme.of(context);
    final sizes = theme.sizes.resolve(device);
    final radius = BorderRadius.circular(sizes.card.radius);
    return DecoratedBox(
      key: const ValueKey('device-preview-frame'),
      decoration: BoxDecoration(
        color: theme.colors.outline,
        borderRadius: BorderRadius.circular(
          sizes.card.radius + sizes.overlaySpacing,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(sizes.overlaySpacing),
        child: ClipRRect(borderRadius: radius, child: child),
      ),
    );
  }
}

class _TextPrompt extends StatefulWidget {
  const _TextPrompt({required this.title, required this.initial});
  final String title, initial;
  @override
  State<_TextPrompt> createState() => _TextPromptState();
}

class _TextPromptState extends State<_TextPrompt> {
  late final _controller = TextEditingController(text: widget.initial);
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HyperDialog(
    title: Text(widget.title),
    content: HyperTextField(controller: _controller, autofocus: true),
    actions: [
      HyperButton.ghost(
        onPressed: () => Navigator.pop(context),
        child: const Text('取消'),
      ),
      HyperButton.filled(
        onPressed: () {
          if (_controller.text.trim().isNotEmpty) {
            Navigator.pop(context, _controller.text.trim());
          }
        },
        child: const Text('确定'),
      ),
    ],
  );
}
