// ignore: implementation_imports
import 'package:lemon_ui/src/components/table/hyper_table_defaults.dart';

import 'editor_table_fields.dart';

// The first-party editor shares the pure component resolvers so inherited
// swatches remain identical to the preview instead of duplicating defaults.
// ignore: implementation_imports
import 'package:lemon_ui/src/components/notice/hyper_notice_defaults.dart';
// ignore: implementation_imports
import 'package:lemon_ui/src/components/notification/hyper_notification_defaults.dart';

import 'editor_review_fields.dart';
import 'editor_input_fields.dart';
import 'editor_content_fields.dart';
import 'editor_surface_fields.dart';
import 'editor_dimension_limits.dart';
import 'editor_basic_control_fields.dart';
import 'editor_tag_fields.dart';
import 'editor_chip_fields.dart';
import 'editor_select_fields.dart';
import 'editor_text_field_fields.dart';
import 'editor_global_fields.dart';
import 'editor_property_help.dart';
import 'editor_button_fields.dart';

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

part 'editor_basic_control_workspace.dart';
part 'editor_surface_workspace.dart';
part 'editor_content_workspace.dart';
part 'editor_table_workspace.dart';
part 'editor_input_workspace.dart';
part 'editor_review_workspace.dart';

/// 编辑器外壳使用启动主题，草稿只进入独立预览 Navigator。
class ThemeEditor extends StatefulWidget {
  const ThemeEditor({super.key});
  @override
  State<ThemeEditor> createState() => _ThemeEditorState();
}

class _ThemeEditorState extends State<ThemeEditor> {
  String _tableState = 'hover';
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
  String _radioState = 'common',
      _checkboxState = 'common',
      _switchState = 'common';
  String get _basicState => switch (_component) {
    'radio' => _radioState,
    'checkbox' => _checkboxState,
    'switch' => _switchState,
    _ => 'common',
  };
  set _basicState(String value) {
    switch (_component) {
      case 'radio':
        _radioState = value;
      case 'checkbox':
        _checkboxState = value;
      case 'switch':
        _switchState = value;
    }
  }

  String _radioVariant = 'common',
      _checkboxVariant = 'common',
      _progressObject = 'common';
  String _reviewObject = '',
      _reviewState = 'common',
      _reviewPart = 'group',
      _reviewVariant = 'common';
  String _tagState = 'common';
  String _tagVariant = 'common';
  String _chipState = 'common';
  String _buttonState = 'common';
  String _fieldState = 'common';
  String _inputObject = 'standard',
      _inputState = 'default',
      _iconInputVariant = 'common';
  String _selectAnchorState = 'common';
  String _selectPanelState = 'common';
  String get _selectState =>
      _selectSurfaceAnchor ? _selectAnchorState : _selectPanelState;
  bool _selectSurfaceAnchor = true;
  HyperButtonVariant? _buttonVariant;
  HyperButtonSizeVariant _buttonSizeVariant = HyperButtonSizeVariant.medium;
  late final AppLifecycleListener _lifecycle;
  HyperThemeData? _resolvedLight, _resolvedDark;
  String? _encodedDocument;
  bool get _dirty => _saved != (_encodedDocument ??= _document.encode());

  HyperThemeData _resolveDeviceTheme(bool dark) {
    final theme = _document.resolve(dark, deviceType: _device);
    return theme.copyWith(
      typography: theme.typographyTheme.resolve(_device),
      typographyTheme: theme.typographyTheme,
    );
  }

  HyperThemeData _resolveTheme(bool dark) => dark
      ? (_resolvedDark ??= _resolveDeviceTheme(true))
      : (_resolvedLight ??= _resolveDeviceTheme(false));

  void _updateState(VoidCallback change) {
    setState(() {
      change();
      _resolvedLight = _resolvedDark = null;
      _encodedDocument = null;
    });
  }

  EditorMode get _mode => _document.mode(_dark);
  EditorDevice get _spec => _document.device(_device);
  EditorComponent get _appearance => _isContentControl
      ? _contentAppearance
      : _isBasicControl
      ? _basicAppearance
      : switch (_component) {
          'button' =>
            _buttonVariant == null
                ? _mode.button
                : _mode.buttonVariants.forVariant(_buttonVariant!),
          'tag' =>
            _tagState == 'disabled'
                ? _mode.tagDisabled
                : _tagVariant == 'emphasized'
                ? _mode.tagEmphasized
                : _mode.tag,
          'chip' => switch (_chipState) {
            'selected' => _mode.chipSelected,
            'hovered' => _mode.chipHovered,
            'focused' => _mode.chipFocused,
            'pressed' => _mode.chipPressed,
            'disabled' => _mode.chipDisabled,
            _ => _mode.chip,
          },
          'select' => _selectSurfaceAnchor ? _mode.selectAnchor : _mode.select,
          'container' => _mode.container,
          'collapsible' => _mode.collapsible,
          'group' => _mode.group,
          'card' => _mode.card,
          'field' => _mode.field,
          _ => _mode.menu,
        };
  static const _components = {
    'appBarReview': '应用顶栏',
    'drawerReview': '抽屉',
    'tooltipReview': '文字提示',
    'notificationReview': '通知卡片',
    'loadingOverlayReview': '加载遮罩',
    'alertReview': '内联提示 / 横幅提示',
    'bottomSheetReview': '底部弹窗',
    'toastReview': '轻提示 / 操作提示',
    'dialogReview': '对话框',
    'emptyStateReview': '结果 · 空状态',
    'skeletonReview': '骨架屏',
    'sidebarReview': '侧边导航',
    'tabBarReview': '标签导航',
    'stepIndicatorReview': '步骤指示器 / 步骤导航',
    'paginationReview': '分页',
    'pageIndicatorReview': '页面指示器',
    'breadcrumbReview': '面包屑',
    'topNavigationReview': '顶部导航',
    'button': '按钮',
    'tag': '标签',
    'chip': '选择标签',
    'sliderInput': '滑块',
    'segmentedInput': '分段按钮',
    'iconButtonInput': '图标按钮',
    'table': '数据表格',
    'tree': '树形列表',
    'treeSelect': '树形选择',
    'result': '结果页',
    'description': '描述列表',
    'timeline': '时间线',
    'avatar': '头像',
    'listTile': '列表项',
    'text': '文字',
    'icon': '图标',
    'container': '容器',
    'collapsible': '折叠面板',
    'group': '控件组',
    'surface': '材质表面',
    'card': '卡片',
    'field': '文本输入',
    'select': '选择与自动补全',
    'badge': '徽标',
    'divider': '分隔线',
    'progress': '进度',
    'radio': '单选框',
    'checkbox': '复选框',
    'switch': '开关',
    'menu': '菜单',
  };
  static const _pages = {
    'appBarReview': 'hyper-app-bar',
    'drawerReview': 'hyper-drawer',
    'tooltipReview': 'hyper-tooltip',
    'notificationReview': 'hyper-notification',
    'loadingOverlayReview': 'hyper-loading-overlay',
    'alertReview': 'hyper-notice',
    'bottomSheetReview': 'hyper-bottom-sheet',
    'toastReview': 'hyper-message',
    'dialogReview': 'hyper-dialog',
    'emptyStateReview': 'hyper-empty-state',
    'skeletonReview': 'hyper-skeleton',
    'sidebarReview': 'hyper-sidebar',
    'tabBarReview': 'hyper-tab-bar',
    'stepIndicatorReview': 'hyper-steps',
    'paginationReview': 'hyper-pagination',
    'pageIndicatorReview': 'hyper-page-indicator',
    'breadcrumbReview': 'hyper-breadcrumb',
    'topNavigationReview': 'hyper-top-navigation',
    'button': 'hyper-button',
    'tag': 'hyper-tag',
    'chip': 'hyper-chip',
    'sliderInput': 'hyper-slider',
    'segmentedInput': 'hyper-segmented-button',
    'iconButtonInput': 'hyper-icon-button',
    'table': 'hyper-table',
    'tree': 'hyper-tree-view',
    'treeSelect': 'hyper-tree-select',
    'result': 'hyper-result',
    'description': 'hyper-description-list',
    'timeline': 'hyper-timeline',
    'avatar': 'hyper-avatar',
    'listTile': 'hyper-list-tile',
    'text': 'hyper-text',
    'icon': 'hyper-icon',
    'container': 'hyper-container',
    'collapsible': 'hyper-collapsible',
    'group': 'hyper-widget-group',
    'surface': 'hyper-material-surface',
    'card': 'hyper-card',
    'field': 'hyper-text-field',
    'select': 'hyper-select-fields',
    'badge': 'hyper-badge',
    'divider': 'hyper-divider',
    'progress': 'hyper-progress-indicator',
    'radio': 'hyper-radio',
    'checkbox': 'hyper-checkbox',
    'switch': 'hyper-switch',
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
        _updateState(
          () => _library = (jsonDecode(source) as Map<String, dynamic>)
              .cast<String, String>(),
        );
      } catch (_) {
        _notice('本地主题库读取失败，请从 JSON 文件导入');
      }
    }
  }

  void _change(VoidCallback change) {
    if (_component == 'switch') {
      final before = _document.encode();
      try {
        _updateState(() {
          change();
          _document.validateControlGeometry();
        });
      } on FormatException catch (error) {
        _updateState(() => _document = EditorThemeDocument.decode(before));
        _notice('${error.message}。请先调整关联尺寸或重置当前编辑范围。');
        return;
      }
      if (_gestureStart == null && _document.encode() != before) {
        _undo.add(before);
        _redo.clear();
      }
      return;
    }

    if (_gestureStart != null) {
      _updateState(change);
      return;
    }
    final before = _document.encode();
    _updateState(change);
    if (_document.encode() != before && _gestureStart == null) {
      _undo.add(before);
      _redo.clear();
    }
  }

  void _endGesture() {
    final before = _gestureStart;
    _gestureStart = null;
    if (before != null && before != _document.encode()) {
      _updateState(() {
        _undo.add(before);
        _redo.clear();
      });
    }
  }

  void _history(bool redo) {
    final source = redo ? _redo : _undo, target = redo ? _undo : _redo;
    if (source.isEmpty) return;
    _updateState(() {
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
      _updateState(() {
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
    _updateState(() {
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
      builder: (context) => StatefulBuilder(
        builder: (context, refresh) => HyperDialog(
          title: const Text('主题库'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_library.isEmpty) const HyperText('还没有保存的主题'),
              for (final name in _library.keys)
                HyperListTile(
                  title: Text(name),
                  leading: const Icon(Icons.palette_outlined),
                  onTap: () => Navigator.pop(context, name),
                  trailing: HyperIconButton.ghost(
                    tooltip: '删除主题 $name',
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () {
                      _deleteLibraryTheme(name).then((deleted) {
                        if (deleted && context.mounted) refresh(() {});
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    if (name != null && mounted) {
      _replace(EditorThemeDocument.decode(_library[name]!));
    }
  }

  Future<bool> _deleteLibraryTheme(String name) async {
    final confirmed = await showHyperDialog<bool>(
      context: context,
      builder: (dialogContext) => HyperDialog(
        title: const Text('删除主题'),
        content: Text('删除主题库中的“$name”？当前编辑内容和启动主题设置会保留。'),
        actions: [
          HyperButton.ghost(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('取消'),
          ),
          HyperButton.filled(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('删除'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return false;
    final library = {..._library}..remove(name);
    try {
      final prefs = await SharedPreferences.getInstance();
      if (!await prefs.setString('theme-editor-library', jsonEncode(library))) {
        throw StateError('写入失败');
      }
      if (!mounted) return false;
      _updateState(() {
        _library = library;
        if (_document.name == name) _saved = '';
      });
      return true;
    } catch (e) {
      _notice('删除失败：$e');
      return false;
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
        _updateState(() => _saved = ''); // 导入后需要显式保存到本地主题库。
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
                                onPressed: () => _updateState(() {
                                  _left = !_left;
                                  if (_left) _right = false;
                                }),
                                child: const Text('全局工作区'),
                              ),
                              HyperButton.ghost(
                                onPressed: () => _updateState(() {
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
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: LayoutBuilder(
      builder: (context, constraints) {
        Widget action(
          String label,
          IconData icon,
          VoidCallback? pressed, {
          bool primary = false,
        }) => HyperTooltip(
          message: label,
          child: primary
              ? HyperButton.filled(
                  label: Text(label),
                  icon: Icon(icon),
                  onPressed: pressed,
                )
              : HyperButton.tonal(
                  label: Text(label),
                  icon: Icon(icon),
                  onPressed: pressed,
                ),
        );
        Widget group(List<Widget> children) =>
            Wrap(spacing: 6, runSpacing: 8, children: children);
        final title = HyperTooltip(
          message: '主题库',
          child: HyperButton.ghost(
            onPressed: () {
              _openLibrary();
            },
            style: HyperButtonStyle(alignment: Alignment.centerLeft),
            icon: const Icon(Icons.expand_more),
            iconAlignment: HyperButtonIconAlignment.end,
            label: HyperText(
              '主题工作室 · ${_document.name}${_dirty ? ' • 未保存' : ''}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
        final leftActions = Wrap(
          spacing: 16,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            title,
            group([
              action('新建', Icons.note_add_outlined, () {
                _newTheme();
              }),
            ]),
            group([
              action(
                '撤销',
                Icons.undo,
                _undo.isEmpty ? null : () => _history(false),
              ),
              action(
                '重做',
                Icons.redo,
                _redo.isEmpty ? null : () => _history(true),
              ),
            ]),
          ],
        );
        final rightActions = Wrap(
          alignment: WrapAlignment.end,
          spacing: 16,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            group([
              action('导入', Icons.file_upload_outlined, () {
                _import();
              }),
              action('导出 JSON', Icons.file_download_outlined, () {
                _export();
              }),
            ]),
            group([
              action('另存为', Icons.save_as_outlined, () {
                _save(asNew: true);
              }),
              action('下次启动使用', Icons.launch_outlined, () {
                _setStartup();
              }),
              action('保存', Icons.save_outlined, () {
                _save();
              }, primary: true),
            ]),
          ],
        );
        if (constraints.maxWidth < 1200) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              leftActions,
              const SizedBox(height: 12),
              Align(alignment: Alignment.centerRight, child: rightActions),
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: leftActions),
            const SizedBox(width: 24),
            Expanded(child: rightActions),
          ],
        );
      },
    ),
  );

  Future<void> _newTheme() async {
    if (await _canReplace() && mounted) _replace(EditorThemeDocument());
  }

  Widget _panel(String title, List<Widget> children) => ColoredBox(
    color: HyperTheme.of(context).colors.surface,
    child: ListView(
      key: ValueKey('editor-panel-$title'),
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
    key: ValueKey('editor-heading-$text'),
    padding: const EdgeInsets.only(top: 20, bottom: 12),
    child: HyperText(text, style: const TextStyle(fontWeight: FontWeight.w600)),
  );
  Widget _select<T>(
    String label,
    T value,
    Map<T, String> options,
    ValueChanged<T> changed,
  ) => Padding(
    key: ValueKey('editor-select-$label'),
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HyperTooltip(
          message: editorPropertyHelp(label),
          child: Row(
            children: [
              Expanded(child: HyperText(label)),
              const Icon(Icons.info_outline, size: 14),
            ],
          ),
        ),
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
  Widget _formPanel() {
    final theme = _resolveTheme(_dark),
        s = _resolveTheme(_dark).sizes.resolve(_device).form;
    final m = _spec.formMetrics, v = _mode.formFields;
    final viewport = editorPreviewSize(_device, landscape: _landscape);
    final maxLabel = editorFormLabelWidthLimit(
      viewport.width,
      s.minimumControlWidth,
      s.gap,
    );
    final fontLimit = editorReviewFontSizeLimit(
      theme.textTheme.displayLarge!.fontSize!,
    );
    return _panel('表单', [
      const HyperText('字段布局、标签和校验信息由表单主题统一配置；字段外观沿用子控件自身主题。'),
      _heading('标签'),
      _number(
        '标签列宽',
        s.labelWidth,
        0,
        maxLabel,
        (n) => m.labelWidth = n,
        () => m.labelWidth = null,
        m.labelWidth != null,
      ),
      _number(
        '标签字号',
        v.labelFontSize ?? theme.textTheme.bodyMedium!.fontSize!,
        1,
        fontLimit,
        (n) => v.labelFontSize = n,
        () => v.labelFontSize = null,
        v.labelFontSize != null,
      ),
      _color(
        '标签文字颜色',
        v.labelColor,
        (c) => v.labelColor = c,
        inheritedColor: theme.colors.textPrimary,
      ),
      _color(
        '必填标识颜色',
        v.requiredColor,
        (c) => v.requiredColor = c,
        inheritedColor: theme.colors.error,
      ),
      _heading('内容布局'),
      _number(
        '标签与控件间距',
        s.gap,
        0,
        editorContentSpacingLimit,
        (n) => m.gap = n,
        () => m.gap = null,
        m.gap != null,
      ),
      _number(
        '字段间距',
        s.fieldSpacing,
        0,
        editorContentSpacingLimit,
        (n) => m.fieldSpacing = n,
        () => m.fieldSpacing = null,
        m.fieldSpacing != null,
      ),
      _number(
        '控件最小可用宽度',
        s.minimumControlWidth,
        1,
        editorFormControlWidthLimit(viewport.width),
        (n) => m.minimumControlWidth = n,
        () => m.minimumControlWidth = null,
        m.minimumControlWidth != null,
      ),
      _heading('说明与错误'),
      _number(
        '辅助文字间距',
        s.messageSpacing,
        0,
        editorContentSpacingLimit,
        (n) => m.messageSpacing = n,
        () => m.messageSpacing = null,
        m.messageSpacing != null,
      ),
      _number(
        '说明字号',
        v.descriptionFontSize ?? theme.textTheme.bodySmall!.fontSize!,
        1,
        fontLimit,
        (n) => v.descriptionFontSize = n,
        () => v.descriptionFontSize = null,
        v.descriptionFontSize != null,
      ),
      _color(
        '说明文字颜色',
        v.descriptionColor,
        (c) => v.descriptionColor = c,
        inheritedColor: theme.colors.textSecondary,
      ),
      _number(
        '错误字号',
        v.errorFontSize ?? theme.textTheme.bodySmall!.fontSize!,
        1,
        fontLimit,
        (n) => v.errorFontSize = n,
        () => v.errorFontSize = null,
        v.errorFontSize != null,
      ),
      _color(
        '错误文字颜色',
        v.errorColor,
        (c) => v.errorColor = c,
        inheritedColor: theme.colors.error,
      ),
    ]);
  }

  Widget _calendarPanel() {
    final theme = _resolveTheme(_dark),
        s = _resolveTheme(_dark).sizes.resolve(_device).calendar;
    final m = _spec.calendarMetrics, v = _mode.calendar;
    return _panel('日历', [
      _heading('文字'),
      _number(
        '日历字号',
        v.fontSize ?? theme.textTheme.bodyMedium!.fontSize!,
        1,
        editorReviewFontSizeLimit(theme.textTheme.displayLarge!.fontSize!),
        (n) => v.fontSize = n,
        () => v.fontSize = null,
        v.fontSize != null,
      ),
      _color(
        '日期文字颜色',
        v.foreground,
        (c) => v.foreground = c,
        inheritedColor: theme.colors.textPrimary,
      ),
      _color(
        '选中日期文字颜色',
        v.selectedForeground,
        (c) => v.selectedForeground = c,
        inheritedColor: theme.colors.onPrimary,
      ),
      _color(
        '禁用日期文字颜色',
        v.disabledForeground,
        (c) => v.disabledForeground = c,
        inheritedColor: theme.colors.disabled,
      ),
      _heading('布局'),
      _number(
        '日历宽度',
        s.width,
        1,
        editorContentWidthLimit,
        (n) => m.width = n,
        () => m.width = null,
        m.width != null,
      ),
      _number(
        '日期最小高度',
        s.dayMinHeight,
        1,
        editorCalendarDayExtentLimit,
        (n) => m.itemExtent = n,
        () => m.itemExtent = null,
        m.itemExtent != null,
      ),
      _number(
        '日期间距',
        s.spacing,
        0,
        (s.width / 6).floorToDouble(),
        (n) => m.horizontalPadding = n,
        () => m.horizontalPadding = null,
        m.horizontalPadding != null,
      ),
      _heading('表面'),
      _number(
        '选中框边长',
        s.selectionSize ?? s.dayMinHeight,
        0,
        ((s.width - s.spacing * 6) / 7).floorToDouble().clamp(
          0,
          double.infinity,
        ),
        (n) => m.selectionSize = n,
        () => m.selectionSize = null,
        m.selectionSize != null,
      ),
      _color(
        '日历背景',
        v.background,
        (c) => v.background = c,
        inheritedColor: Colors.transparent,
      ),
      _color(
        '选中日期背景',
        v.selection,
        (c) => v.selection = c,
        inheritedColor: theme.colors.primary,
      ),
      _radiusNumber(
        '日期圆角',
        s.radius,
        0,
        editorRadiusLimit(
          ((s.width - s.spacing * 6) / 7).clamp(0, s.dayMinHeight),
        ),
        (n) => m.selectionRadius = n,
        () => m.selectionRadius = null,
        m.selectionRadius != null,
      ),
    ]);
  }

  String _wheelState = 'common';
  Widget _wheelPanel() {
    final theme = _resolveTheme(_dark);
    final s = theme.sizes.resolve(_device).wheelPicker;
    final m = _spec.wheelMetrics;
    final v = _mode.wheel;
    final visual = theme.wheelPickerTheme.style;
    final baseFont =
        theme.textTheme.bodyLarge?.fontSize ?? theme.typography.bodyLarge;
    final fontLimit = editorReviewFontSizeLimit(
      theme.textTheme.displayLarge?.fontSize ?? baseFont,
    );
    final radiusLimit = editorRadiusLimit(
      s.width < s.itemExtent ? s.width : s.itemExtent,
    );
    return _panel('滚轮选择器', [
      const HyperText('尺寸按设备保存，外观按亮暗模式保存。行最小高度随文字缩放自动增高。'),
      _select('交互状态', _wheelState, const {
        'common': '通用（所有状态）',
        'default': '默认',
        'selected': '选中',
        'disabled': '禁用',
      }, (value) => _updateState(() => _wheelState = value)),
      if (_wheelState == 'common') ...[
        _heading('文字'),
        _number(
          '字号',
          v.fontSize ?? baseFont,
          1,
          fontLimit,
          (n) => v.fontSize = n,
          () => v.fontSize = null,
          v.fontSize != null,
        ),
        _number(
          '字重',
          v.fontWeight ?? 400,
          100,
          900,
          (n) => v.fontWeight = (n / 100).round() * 100.0,
          () => v.fontWeight = null,
          v.fontWeight != null,
        ),
        _heading('布局'),
        _number(
          '滚轮宽度',
          s.width,
          1,
          editorWheelWidthLimit,
          (n) {
            m.width = n;
            if (m.horizontalPadding != null) {
              m.horizontalPadding = m.horizontalPadding!.roundToDouble().clamp(
                0,
                (n / 2).floorToDouble(),
              );
            }
            if (m.selectionRadius != null) {
              m.selectionRadius = m.selectionRadius!.roundToDouble().clamp(
                0,
                editorRadiusLimit(n < s.itemExtent ? n : s.itemExtent),
              );
            }
          },
          () => m.width = null,
          m.width != null,
        ),
        _number(
          '行最小高度',
          s.itemExtent,
          1,
          editorWheelItemExtentLimit,
          (n) {
            m.itemExtent = n;
            if (m.selectionRadius != null) {
              m.selectionRadius = m.selectionRadius!.roundToDouble().clamp(
                0,
                editorRadiusLimit(n < s.width ? n : s.width),
              );
            }
          },
          () => m.itemExtent = null,
          m.itemExtent != null,
        ),
        _number(
          '文字水平内边距',
          s.horizontalPadding,
          0,
          (s.width / 2).floorToDouble(),
          (n) => m.horizontalPadding = n,
          () => m.horizontalPadding = null,
          m.horizontalPadding != null,
        ),
        _number(
          '直径比',
          v.diameterRatio ?? 2,
          editorWheelDiameterRatioMin,
          editorWheelDiameterRatioMax,
          (n) => v.diameterRatio = n,
          () => v.diameterRatio = null,
          v.diameterRatio != null,
          wholeNumbers: false,
        ),
        _number(
          '透视',
          v.perspective ?? .003,
          editorWheelPerspectiveMin,
          editorWheelPerspectiveMax,
          (n) => v.perspective = n,
          () => v.perspective = null,
          v.perspective != null,
          wholeNumbers: false,
        ),
        _number(
          '挤压比例',
          v.squeeze ?? 1,
          editorWheelSqueezeMin,
          editorWheelSqueezeMax,
          (n) => v.squeeze = n,
          () => v.squeeze = null,
          v.squeeze != null,
          wholeNumbers: false,
        ),
        _number(
          '非选中透明度',
          v.unselectedOpacity ?? 1,
          0,
          1,
          (n) => v.unselectedOpacity = n,
          () => v.unselectedOpacity = null,
          v.unselectedOpacity != null,
          wholeNumbers: false,
        ),
        _heading('动效'),
        _select('切换曲线', v.curve ?? 'inherit', const {
          'inherit': '继承 Motion',
          'linear': '线性',
          'easeOut': '缓出',
          'easeOutCubic': '三次缓出',
          'easeInOutCubic': '三次缓入缓出',
        }, (n) => _change(() => v.curve = n == 'inherit' ? null : n)),
        _number(
          '切换时长',
          v.duration ?? theme.motion.fastDuration.inMilliseconds.toDouble(),
          0,
          editorReviewDurationLimit,
          (n) => v.duration = n,
          () => v.duration = null,
          v.duration != null,
        ),
        _heading('表面'),
        _color(
          '选中区域边框颜色',
          v.borderColor,
          (c) => v.borderColor = c,
          inheritedColor: theme.colors.outline,
        ),
        _number(
          '选中区域边框宽度',
          v.borderWidth ?? 0,
          0,
          radiusLimit,
          (n) => v.borderWidth = n,
          () => v.borderWidth = null,
          v.borderWidth != null,
        ),
        _color(
          '滚轮背景',
          v.background,
          (c) => v.background = c,
          inheritedColor: visual.backgroundColor ?? Colors.transparent,
        ),
        _color(
          '选中区域背景',
          v.selection,
          (c) => v.selection = c,
          inheritedColor: visual.selectionColor ?? theme.colors.surfaceMuted,
        ),
        _radiusNumber(
          '选中区域圆角',
          s.selectionRadius,
          0,
          radiusLimit,
          (n) => m.selectionRadius = n,
          () => m.selectionRadius = null,
          m.selectionRadius != null,
        ),
      ],
      if (_wheelState == 'default') ...[
        _number(
          '非选中缩放比例',
          v.unselectedScale ?? 1,
          0,
          1,
          (n) => v.unselectedScale = n,
          () => v.unselectedScale = null,
          v.unselectedScale != null,
          wholeNumbers: false,
        ),
        _heading('文字'),
        _color(
          '文字颜色',
          v.foreground,
          (c) => v.foreground = c,
          inheritedColor: visual.foregroundColor ?? theme.colors.textSecondary,
        ),
      ],
      if (_wheelState == 'selected') ...[
        _number(
          '选中文字字重',
          v.selectedFontWeight ?? v.fontWeight ?? 400,
          100,
          900,
          (n) => v.selectedFontWeight = (n / 100).round() * 100.0,
          () => v.selectedFontWeight = null,
          v.selectedFontWeight != null,
        ),
        _heading('文字'),
        _number(
          '选中文字字号',
          v.selectedFontSize ?? v.fontSize ?? baseFont,
          1,
          fontLimit,
          (n) => v.selectedFontSize = n,
          () => v.selectedFontSize = null,
          v.selectedFontSize != null,
        ),
        _color(
          '选中文字颜色',
          v.selectedForeground,
          (c) => v.selectedForeground = c,
          inheritedColor:
              visual.selectedForegroundColor ?? theme.colors.primary,
        ),
      ],
      if (_wheelState == 'disabled') ...[
        _heading('文字'),
        _color(
          '禁用文字颜色',
          v.disabledForeground,
          (c) => v.disabledForeground = c,
          inheritedColor: visual.disabledColor ?? theme.colors.disabled,
        ),
      ],
    ]);
  }

  Widget _radiusNumber(
    String label,
    double value,
    double min,
    double max,
    ValueChanged<double> changed,
    VoidCallback reset,
    bool overridden,
  ) => _number(
    label,
    value.clamp(min, max).toDouble(),
    min,
    max,
    changed,
    reset,
    overridden,
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
  }) {
    final lower = wholeNumbers ? min.ceilToDouble() : min;
    final upper = wholeNumbers ? max.floorToDouble() : max;
    final hasRange = upper > lower;
    final sliderMin = lower <= upper ? lower : max;
    final sliderMax = lower <= upper ? upper : max;
    final sliderValue = (wholeNumbers ? value.roundToDouble() : value)
        .clamp(sliderMin, sliderMax)
        .toDouble();
    return Padding(
      key: ValueKey('editor-number-$label'),
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: HyperTooltip(
                  message: editorPropertyHelp(label),
                  child: Row(
                    children: [
                      Expanded(
                        child: HyperText(
                          '$label  ${sliderValue.toStringAsFixed(wholeNumbers ? 0 : 2)}',
                        ),
                      ),
                      const Icon(Icons.info_outline, size: 14),
                    ],
                  ),
                ),
              ),
              HyperIconButton.ghost(
                tooltip: overridden ? '恢复继承' : '继承默认',
                style: HyperIconButtonStyle(size: 24, minimumTapTargetSize: 24),
                onPressed: overridden ? () => _change(reset) : null,
                icon: Icon(
                  overridden ? Icons.restart_alt : Icons.link,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          HyperSlider(
            value: sliderValue,
            min: sliderMin,
            max: sliderMax,
            divisions: wholeNumbers && hasRange
                ? (upper - lower).round()
                : null,
            onChangeStart: (_) => _gestureStart = _document.encode(),
            onChangeEnd: (_) => _endGesture(),
            onChanged: !hasRange
                ? null
                : (value) => _change(
                    () => changed(
                      (wholeNumbers ? value.roundToDouble() : value)
                          .clamp(lower, upper)
                          .toDouble(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _color(
    String label,
    EditorColor? color,
    ValueChanged<EditorColor?> changed, {
    Color? inheritedColor,
  }) {
    final theme = _resolveTheme(_dark);
    final colors = theme.colors;
    final inherited = switch (label) {
      '前景' =>
        _component == 'button' &&
                (_buttonVariant == null ||
                    _buttonVariant == HyperButtonVariant.filled ||
                    _buttonVariant == HyperButtonVariant.gradient)
            ? colors.onPrimary
            : colors.textPrimary,
      '材质边框' => colors.outline,
      '材质染色' => colors.surface.withValues(alpha: .06),
      '材质背景' => colors.surface,
      '背景' => switch (_component) {
        'container' =>
          theme.containerTheme.background?.color ?? Colors.transparent,
        'button' =>
          theme.buttonTheme
                  .resolve(_buttonVariant ?? HyperButtonVariant.filled)
                  .background
                  ?.color ??
              (_buttonVariant == HyperButtonVariant.filled ||
                      _buttonVariant == HyperButtonVariant.gradient
                  ? colors.primary
                  : _buttonVariant == HyperButtonVariant.tonal
                  ? colors.surface
                  : Colors.transparent),
        'field' =>
          theme.textFieldTheme.style.background?.color ?? colors.surfaceMuted,
        'select' =>
          _componentFill(theme)?.color ??
              (_selectSurfaceAnchor
                  ? Colors.transparent
                  : colors.surfaceElevated),
        'chip' || 'tag' => _componentFill(theme)?.color ?? colors.surfaceMuted,
        'card' => theme.cardTheme.style?.background?.color ?? colors.surface,
        _ => colors.surfaceElevated,
      },
      _ => colors.primary,
    };
    return _semanticColor(
      label,
      color?.resolve(colors) ?? inheritedColor ?? inherited,
      color?.resolve(colors),
      (value) =>
          changed(value == null ? null : EditorColor(argb: value.toARGB32())),
    );
  }

  Widget _semanticColor(
    String label,
    Color effective,
    Color? override,
    ValueChanged<Color?> changed,
  ) => Padding(
    key: ValueKey('editor-color-$label'),
    padding: const EdgeInsets.only(bottom: 12),
    child: Row(
      children: [
        Expanded(
          flex: 4,
          child: HyperTooltip(
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

  Widget _globalPanel({Set<String>? sections}) {
    final theme = _resolveTheme(_dark),
        typo = theme.typographyTheme.resolve(_device);
    final children = <Widget>[
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
              onSelectionChanged: (value) => _updateState(() {
                _device = value.single;
                _landscape = _device == HyperDeviceType.desktop;
              }),
            ),
          ),
          const SizedBox(width: 8),
          HyperIconButton.outlined(
            tooltip: _landscape ? '当前横屏，切换竖屏' : '当前竖屏，切换横屏',
            onPressed: () => _updateState(() => _landscape = !_landscape),
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
        onSelectionChanged: (value) => _updateState(() => _dark = value.single),
      ),
      _heading('主题与强调色'),
      _semanticColor(
        '主题色',
        Color(_mode.seed ?? 0xff3482ff),
        _mode.seed == null ? null : Color(_mode.seed!),
        (value) => _mode.seed = value?.toARGB32(),
      ),
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
      const HyperText('根据主题色生成基础配色，已单独修改的颜色保持不变。'),
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
            _updateState(() => _textScale = value.single),
      ),
      const HyperText('当前方案独立编辑；尺寸与字阶属于当前设备。'),
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
      _heading('文字语义颜色'),
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
      _heading('页面布局'),
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
      _heading('导航与工具栏'),
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
      _heading('控件布局与触控'),
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
      _heading('图标'),
      _number(
        '图标尺寸',
        theme.sizes.resolve(_device).iconSize,
        0,
        200,
        (v) => _spec.layout.iconSize = v,
        () => _spec.layout.iconSize = null,
        _spec.layout.iconSize != null,
      ),
      _heading('禁用状态'),
      _semanticColor(
        'disabled',
        theme.colors.disabled,
        _mode.palette.disabled,
        (value) => _mode.palette.disabled = value,
      ),
      _heading('交互状态'),
      _semanticColor(
        'stateLayer',
        theme.colors.stateLayer,
        _mode.palette.stateLayer,
        (value) => _mode.palette.stateLayer = value,
      ),
      _heading('错误状态'),
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
      _heading('成功状态'),
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
      _heading('警告状态'),
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
      _heading('前景对比度'),
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
      _heading('快速动效'),
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
      _heading('标准动效'),
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
      _heading('强调动效'),
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
      _heading('弹簧动效'),
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
      _heading('页面背景'),
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
      _heading('普通表面'),
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
      _radiusNumber(
        '表面圆角',
        theme.sizes.resolve(_device).surfaceRadius,
        0,
        editorSurfaceRadiusLimit,
        (v) => _spec.layout.surfaceRadius = v,
        () => _spec.layout.surfaceRadius = null,
        _spec.layout.surfaceRadius != null,
      ),
      _heading('抬升表面'),
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
      _heading('弱化表面'),
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
      _heading('控件轮廓'),
      _radiusNumber(
        '控件圆角',
        theme.sizes.resolve(_device).controlRadius,
        0,
        editorSurfaceRadiusLimit,
        (v) => _spec.layout.controlRadius = v,
        () => _spec.layout.controlRadius = null,
        _spec.layout.controlRadius != null,
      ),
      _semanticColor(
        'outline',
        theme.colors.outline,
        _mode.palette.outline,
        (value) => _mode.palette.outline = value,
      ),
      _heading('浮层表面'),
      _radiusNumber(
        '浮层圆角',
        theme.sizes.resolve(_device).overlayRadius,
        0,
        editorSurfaceRadiusLimit,
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
      _semanticColor(
        'scrim',
        theme.colors.scrim,
        _mode.palette.scrim,
        (value) => _mode.palette.scrim = value,
      ),
      _heading('材质质量与降级'),
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
        '减少透明度',
        _mode.behavior.reduceTransparency?.toString() ?? 'inherit',
        const {'inherit': '继承默认', 'true': '开启', 'false': '关闭'},
        (v) => _change(
          () => _mode.behavior.reduceTransparency = v == 'inherit'
              ? null
              : v == 'true',
        ),
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
      _heading('背景材质'),
      _select(
        '高光描边',
        _mode.materialAppearance.material.materialEdgeEnabled?.toString() ??
            'inherit',
        const {'inherit': '按表面用途默认', 'true': '全部开启', 'false': '全部关闭'},
        (value) => _change(
          () => _mode.materialAppearance.material.materialEdgeEnabled =
              value == 'inherit' ? null : value == 'true',
        ),
      ),

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
              HyperSurfaceMaterialKind.clearFrostedGlass => '高透毛玻璃',
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
            _mode.materialAppearance.material.materialEdgeEnabled = null;
          }
        }),
      ),
      ...[
        _number(
          '背景不透明度',
          _mode.opacity ??
              (_mode.material == HyperSurfaceMaterialKind.solid
                  ? 1
                  : _mode.material == HyperSurfaceMaterialKind.clearFrostedGlass
                  ? const HyperSurfaceMaterial.clearFrostedGlass()
                        .background!
                        .gradient!
                        .colors
                        .first
                        .a
                  : _mode.material == HyperSurfaceMaterialKind.translucent
                  ? HyperSurfaceMaterial.semanticTranslucentOpacity
                  : HyperSurfaceMaterial.semanticGlassOpacity),
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
                  : _mode.material == HyperSurfaceMaterialKind.clearFrostedGlass
                  ? const HyperSurfaceMaterial.clearFrostedGlass().blurSigmaX
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
        wholeNumbers: true,
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
    ];
    if (sections == null) {
      final compact = <Widget>[];
      var materialDetails = false;
      for (final child in children) {
        if (child.key == const ValueKey('editor-heading-材质质量与降级')) {
          materialDetails = true;
          compact.add(_heading('材质'));
        }
        if (!materialDetails ||
            child.key == const ValueKey('editor-select-配方')) {
          compact.add(child);
        }
      }
      compact.add(
        HyperButton.text(
          onPressed: () => rxBatch(() {
            _page = 'hyper-material-surface';
            _component = 'surface';
          }),
          child: const Text('编辑材质详细参数'),
        ),
      );
      return _panel('全局工作区', compact);
    }
    var include = _page != 'hyper-material-surface';
    final selected = <Widget>[
      if (_page != 'hyper-material-surface')
        const HyperText('修改全局配置，与顶部全局工作区共用同一数据；未覆盖组件同步继承。'),
    ];
    for (final child in children) {
      final key = child.key;
      if (key is ValueKey<String> && key.value.startsWith('editor-heading-')) {
        final title = key.value.substring('editor-heading-'.length);
        include = sections.any(
          (section) => title == section || title.startsWith('$section ·'),
        );
      }
      if (include) selected.add(child);
    }
    return _panel(
      _page == 'hyper-material-surface' ? '材质设置' : '全局配置',
      selected,
    );
  }

  Widget _componentPanel() => Obx(_buildComponentPanel);

  Widget _buildComponentPanel() {
    final sections = switch (_page) {
      'hyper-color-scheme' => {
        '主题与强调色',
        '文字语义颜色',
        '图标',
        '禁用状态',
        '交互状态',
        '错误状态',
        '成功状态',
        '警告状态',
        '前景对比度',
        '页面背景',
        '普通表面',
        '抬升表面',
        '弱化表面',
        '控件轮廓',
        '浮层表面',
      },
      'hyper-typography-scheme' => {'文字缩放', '字体', '语义字阶', '文字语义颜色'},
      'hyper-motion-theme' => {'快速动效', '标准动效', '强调动效', '弹簧动效'},
      'hyper-material-surface' => {'材质质量与降级', '背景材质', '材质阴影'},
      'hyper-clear-glass' => {'材质质量与降级'},
      _ => null,
    };
    if (sections != null) {
      return _globalPanel(sections: sections.isEmpty ? null : sections);
    }
    if (_page == 'hyper-form') return _formPanel();
    if (_page == 'hyper-form-actions') {
      return _panel('表单操作', [
        const HyperText(
          '操作按钮沿用 HyperButton 的主题和实例样式；按钮间距继承 Form 主题，本组件不增加独立表面配置。',
        ),
        HyperButton.text(
          onPressed: () => rxBatch(() {
            _page = 'hyper-form';
            _component = 'form';
          }),
          label: const Text('编辑表单布局主题'),
        ),
        HyperButton.text(
          onPressed: () => rxBatch(() {
            _page = 'hyper-button';
            _component = 'button';
          }),
          label: const Text('编辑按钮主题'),
        ),
      ]);
    }
    if (_page == 'hyper-cascader') {
      return _panel('级联选择', [
        const HyperText(
          '触发器与面板继承下拉选择器，选项继承菜单，路径导航继承文字按钮。四端尺寸与亮暗外观在对应主题中编辑；实例 Style 与局部主题覆盖在 Demo 中明确标记。',
        ),
        HyperButton.text(
          onPressed: () => rxBatch(() {
            _page = 'hyper-select-fields';
            _component = 'select';
          }),
          label: const Text('编辑下拉选择器主题'),
        ),
        HyperButton.text(
          onPressed: () => rxBatch(() {
            _page = 'hyper-menu';
            _component = 'menu';
          }),
          label: const Text('编辑选项菜单主题'),
        ),
        HyperButton.text(
          onPressed: () => rxBatch(() {
            _page = 'hyper-button';
            _component = 'button';
          }),
          label: const Text('编辑路径导航按钮主题'),
        ),
        HyperButton.text(
          onPressed: () => rxBatch(() {
            _page = 'hyper-wheel-picker';
            _component = 'hyper-wheel-picker';
          }),
          label: const Text('编辑手机滚轮主题'),
        ),
      ]);
    }
    if (_page == 'hyper-tree-select') {
      return _panel('树形选择', [
        const HyperText(
          '触发器与面板沿用下拉选择器和公共浮层，树行与异步状态沿用树形列表规格。尺寸、选项、按钮和表面外观在对应主题中配置；实例覆盖在 Demo 中展示。',
        ),
        HyperButton.text(
          onPressed: () => rxBatch(() {
            _page = 'hyper-select-fields';
            _component = 'select';
          }),
          label: const Text('编辑下拉选择器主题'),
        ),
        HyperButton.text(
          onPressed: () => rxBatch(() {
            _page = 'hyper-tree-view';
            _component = 'tree';
          }),
          label: const Text('编辑树形列表主题'),
        ),
      ]);
    }
    if (_page == 'hyper-text-area') {
      return _panel('多行文本', [
        const HyperText(
          '多行文本沿用 HyperTextField 的字体、光标、状态、表面和尺寸主题；默认行数、内容增长与 Form 行为已确认。',
        ),
        HyperButton.text(
          onPressed: () => rxBatch(() {
            _page = 'hyper-text-field';
            _component = 'field';
          }),
          label: const Text('编辑文本输入主题'),
        ),
      ]);
    }
    if (_page == 'hyper-file-picker') {
      return _panel('文件选择 · 继承现有主题', [
        const HyperText(
          '默认界面复用卡片、按钮、图标按钮和文字主题；实例 pickerStyle 可覆盖表面。文件选择和拖放由第三方适配层提供。',
        ),
      ]);
    }
    if (_page == 'hyper-number-input') {
      return _panel('数字输入 · 继承现有主题', [
        const HyperText(
          '输入框外观与四端尺寸继承文本输入框；步进图标继承图标按钮。实例可通过 style 和 stepperStyle 分别覆盖。',
        ),
      ]);
    }
    if (_page == 'hyper-calendar') return _calendarPanel();
    if (_page == 'hyper-wheel-picker') return _wheelPanel();
    if (_page == 'hyper-color-picker') {
      return _panel('颜色选择器', [const HyperText('本页仅提供 Demo 预览，外观跟随主题。')]);
    }
    if (_isReviewControl) return _reviewPanel();
    if (_isInputControl) return _inputPanel();
    if (_component == 'table') return _tablePanel();
    if (_isContentControl) return _contentPanel();
    if (_isBasicControl) return _basicControlPanel();
    if (const {
      'container',
      'card',
      'collapsible',
      'group',
    }.contains(_component)) {
      return _surfacePanel();
    }
    if (_component == 'surface') {
      return _panel('材质表面', [
        const HyperText('材质配方、质量和降级请在全局配置的材质设置中编辑；本页预览复用同一配置。'),
      ]);
    }
    if (_page == 'hyper-fill') {
      return _panel('填充样式', [
        const HyperText(
          'HyperFill 是纯色、渐变及无填充的共用样式对象。示例使用显式填充；背景设置在实际使用它的组件中编辑，圆角由承载组件控制。',
        ),
      ]);
    }
    final supported = _components.containsKey(_component);
    if (!supported) {
      final item = gallerySections
          .expand((section) => section.items)
          .where((item) => item.id == _page)
          .firstOrNull;
      return _panel('组件工作区', [
        HyperText(
          item?.title ?? '完整 Demo',
          style: HyperTheme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        const HyperText('暂不支持编辑'),
      ]);
    }
    final s = _resolveTheme(_dark).sizes.resolve(_device), a = _appearance;
    return _panel('组件工作区', [
      HyperText(
        _components[_component]!,
        style: HyperTheme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: 12),
      HyperText('${_devices[_device]}尺寸 · ${_dark ? '暗色' : '亮色'}外观'),
      if (_component == 'select') ...[
        KeyedSubtree(
          key: const ValueKey('editor-select-surface'),
          child: _select('编辑对象', _selectSurfaceAnchor, const {
            true: '触发器',
            false: '选项面板',
          }, (value) => _updateState(() => _selectSurfaceAnchor = value)),
        ),
        KeyedSubtree(
          key: const ValueKey('editor-select-state'),
          child: _select(
            '状态覆盖',
            _selectState,
            _selectSurfaceAnchor
                ? const {
                    'common': '通用（所有状态）',
                    'hovered': '悬停',
                    'focused': '聚焦',
                    'pressed': '按下',
                    'disabled': '禁用',
                  }
                : const {
                    'common': '通用（所有状态）',
                    'selected': '选中',
                    'active': '活动（悬停 / 键盘）',
                    'disabled': '禁用',
                  },
            (value) => _updateState(() {
              if (_selectSurfaceAnchor) {
                _selectAnchorState = value;
              } else {
                _selectPanelState = value;
              }
            }),
          ),
        ),
      ],
      if (_component == 'field')
        KeyedSubtree(
          key: const ValueKey('editor-field-state'),
          child: _select('状态覆盖', _fieldState, const {
            'common': '通用（所有状态）',
            'hovered': '悬停',
            'focused': '聚焦',
            'error': '错误',
            'disabled': '禁用',
          }, (value) => _updateState(() => _fieldState = value)),
        ),
      if (_component == 'tag') ...[
        KeyedSubtree(
          key: const ValueKey('editor-tag-variant'),
          child: _select('外观变体', _tagVariant, const {
            'common': '通用（所有变体）',
            'emphasized': '强调',
          }, (value) => _updateState(() => _tagVariant = value)),
        ),
        KeyedSubtree(
          key: const ValueKey('editor-tag-state'),
          child: _select('状态覆盖', _tagState, const {
            'common': '通用',
            'disabled': '禁用（所有变体）',
          }, (value) => _updateState(() => _tagState = value)),
        ),
      ],
      if (_component == 'button') ...[
        KeyedSubtree(
          key: const ValueKey('editor-button-variant'),
          child: _select(
            '外观变体',
            _buttonVariant?.name ?? 'common',
            {
              'common': '通用（所有变体）',
              for (final variant in HyperButtonVariant.values)
                variant.name: variant.name,
            },
            (value) => _updateState(() {
              _buttonVariant = value == 'common'
                  ? null
                  : HyperButtonVariant.values.byName(value);
            }),
          ),
        ),
        const SizedBox(height: 12),
        HyperText(
          _buttonVariant == null
              ? '通用属性由各变体继承；尺寸按当前设备和大小档位保存。'
              : '只编辑当前变体的外观与状态；通用尺寸请切换到“通用”设置。',
        ),
      ],
      if (_component == 'button') ...[
        KeyedSubtree(
          key: const ValueKey('editor-button-state'),
          child: _select('状态覆盖', _buttonState, const {
            'common': '通用（所有状态）',
            'hovered': '悬停',
            'focused': '聚焦',
            'pressed': '按下',
            'disabled': '禁用',
          }, (value) => _updateState(() => _buttonState = value)),
        ),
        const HyperText('在当前外观变体内编辑所选状态；通用设置由各状态继承。'),
      ],
      HyperButton.ghost(
        onPressed: () => _change(() {
          if (_component == 'button' && _buttonState != 'common') {
            _resetButtonState(a);
            return;
          }
          if (_component == 'field' && _fieldState != 'common') {
            _resetFieldState(a);
            return;
          }
          if (_component == 'select' && _selectState != 'common') {
            _resetSelectState();
            return;
          }
          if (_component == 'select') {
            _resetSelectObject();
            return;
          }
          a.background = null;
          a.fillKind = null;
          a.gradient = null;
          a.border = EditorBorder();
          a.foreground = null;
          a.shadows = null;
          a.focusedShadow.shadows = null;
          a.hoveredShadow.shadows = null;
          a.pressedShadow.shadows = null;
          a.disabledShadow.shadows = null;
          a.buttonStyle = EditorButtonVisual();
          a.textFieldStyle = EditorTextFieldVisual();
          a.selectStyle = EditorSelectVisual();
          a.tagStyle = EditorTagVisual();
          if (_component == 'tag' &&
              _tagState == 'common' &&
              _tagVariant == 'common') {
            _spec.tagMetrics = EditorTagMetrics();
          }
          a.chipStyle = EditorChipVisual();
          if (_component == 'chip' && _chipState == 'common') {
            _spec.chipMetrics = EditorChipMetrics();
          }
          if (_component == 'select') {
            _spec.selectMetrics = EditorSelectMetrics();
          }
          if (_component != 'button' || _buttonVariant == null) {
            switch (_component) {
              case 'button':
                _spec.buttonMetrics = EditorButtonMetrics();
                _spec.buttonHeight = null;
                _spec.buttonRadius = null;
              case 'card':
                _spec.cardRadius = null;
              case 'field':
                _spec.textFieldMetrics = EditorTextFieldMetrics();
                _spec.fieldHeight = null;
                _spec.fieldRadius = null;
              case 'menu':
                _spec.menuHeight = null;
                _spec.menuRadius = null;
            }
          }
        }),
        child: Text(
          (_component == 'button' && _buttonState != 'common') ||
                  (_component == 'tag' && _tagState != 'common') ||
                  (_component == 'field' && _fieldState != 'common') ||
                  (_component == 'select' && _selectState != 'common')
              ? '重置当前状态'
              : (_component == 'button' && _buttonVariant != null) ||
                    (_component == 'tag' && _tagVariant != 'common')
              ? '重置当前变体'
              : _component == 'select'
              ? '重置当前对象'
              : '重置当前组件',
        ),
      ),
      if (_component != 'field' &&
          _component != 'select' &&
          _component != 'chip' &&
          _component != 'tag' &&
          (_component != 'button' ||
              (_buttonVariant == null && _buttonState == 'common')))
        _heading('尺寸'),
      if (_component == 'button' &&
          _buttonVariant == null &&
          _buttonState == 'common')
        ..._buttonSizeProperties(s),
      if (_component == 'card')
        _radiusNumber(
          '圆角',
          s.card.radius,
          0,
          editorSurfaceRadiusLimit,
          (v) => _spec.cardRadius = v,
          () => _spec.cardRadius = null,
          _spec.cardRadius != null,
        ),
      if (_component == 'field') ..._textFieldProperties(s, a),
      if (_component == 'menu') ...[
        _number(
          '菜单项最小高度',
          s.menu.itemHeight,
          20,
          100,
          (v) => _spec.menuHeight = v,
          () => _spec.menuHeight = null,
          _spec.menuHeight != null,
        ),
        _radiusNumber(
          '表面圆角',
          s.menu.surfaceRadius,
          0,
          editorSurfaceRadiusLimit,
          (v) => _spec.menuRadius = v,
          () => _spec.menuRadius = null,
          _spec.menuRadius != null,
        ),
      ],
      if (_component == 'tag') ..._tagProperties(s, a),
      if (_component == 'chip') ..._chipProperties(s, a),
      if (_component == 'select') ..._selectProperties(s),
      if (_component == 'button') ..._buttonProperties(s, a),
      if (_component != 'field' &&
          (_component != 'button' || _buttonState == 'common') &&
          (_component != 'select' || _selectState == 'common')) ...[
        if (_component == 'button' && _buttonVariant == null) ...[
          _heading('按钮表面'),
          _radiusNumber(
            '圆角',
            s.button.radius,
            0,
            editorRadiusLimit(s.textField.minimumHeight),
            (v) => _spec.buttonRadius = v,
            () => _spec.buttonRadius = null,
            _spec.buttonRadius != null,
          ),
        ],
        if (_component == 'select' && !_selectSurfaceAnchor) ...[
          _radiusNumber(
            '面板圆角',
            _spec.selectMetrics.surfaceRadius ?? s.menu.surfaceRadius,
            0,
            editorSurfaceRadiusLimit,
            (v) => _spec.selectMetrics.surfaceRadius = v,
            () => _spec.selectMetrics.surfaceRadius = null,
            _spec.selectMetrics.surfaceRadius != null,
          ),
          _radiusNumber(
            '选项圆角',
            _spec.selectMetrics.itemRadius ?? s.menu.itemRadius,
            0,
            editorRadiusLimit(s.menu.itemHeight),
            (v) => _spec.selectMetrics.itemRadius = v,
            () => _spec.selectMetrics.itemRadius = null,
            _spec.selectMetrics.itemRadius != null,
          ),
        ],
        _heading(
          _component == 'button' && _buttonVariant != null ? '变体外观' : '通用外观',
        ),
        ..._backgroundProperties(a),
        if (_component != 'chip' && _component != 'tag')
          ..._borderProperties(a),
        if (_component != 'chip' &&
            _component != 'tag' &&
            _component != 'button' &&
            !(_component == 'select' && _selectSurfaceAnchor))
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
      ],
      if ((_component == 'field' && _fieldState == 'focused') ||
          (_component == 'button' && _buttonState == 'focused') ||
          (_component == 'select' &&
              _selectSurfaceAnchor &&
              _selectState == 'focused'))
        ..._focusedShadowProperties(a),
      if (_component == 'button' ||
          (_component == 'select' && _selectSurfaceAnchor)) ...[
        if ((_component == 'button' && _buttonState == 'hovered') ||
            (_component == 'select' && _selectState == 'hovered'))
          ..._focusedShadowProperties(
            a,
            stateTarget: a.hoveredShadow,
            label: '悬停阴影',
          ),
        if ((_component == 'button' && _buttonState == 'pressed') ||
            (_component == 'select' && _selectState == 'pressed'))
          ..._focusedShadowProperties(
            a,
            stateTarget: a.pressedShadow,
            label: '按下阴影',
          ),
        if ((_component == 'button' && _buttonState == 'disabled') ||
            (_component == 'select' && _selectState == 'disabled'))
          ..._focusedShadowProperties(
            a,
            stateTarget: a.disabledShadow,
            label: '禁用阴影',
          ),
      ],
      _heading('编辑范围'),
      HyperText(switch (_component) {
        'button' => '编辑按钮通用样式或当前变体：文字、图标、加载进度、禁用与交互状态、位移缩放、背景、边框及状态阴影。尺寸按当前设备和大小档位保存，外观按亮暗方案保存；未覆盖项继续继承。',
        'field' => '编辑输入框布局、输入与占位文字、标签、计数、图标、光标、错误提示、各状态边框及聚焦阴影。尺寸按当前设备保存，外观按亮暗方案保存；局部主题和实例覆盖以 Demo 标记为准。',
        'select' => '编辑 Select 的触发按钮、箭头、选项文字与状态、搜索、面板和表面；共用属性同时作用于 Autocomplete；箭头仅适用于 Select。尺寸按当前设备保存，外观按亮暗方案保存。顶部可切换触发器与选项面板，完整 Demo 中的局部及实例覆盖不被强制替换。',
        'tag' =>
          '编辑标签的布局、文字、图标、配色、减淡比例、背景、边框和阴影。尺寸按设备保存；外观按亮暗方案保存，禁用覆盖由所有变体共用。',
        'chip' => '编辑 Chip 的通用、选中、悬停、聚焦、按下和禁用样式。尺寸按设备保存；文字、图标、删除与状态按对象分组，表面配置置底。多选摘要会显式覆盖标签紧凑高度。',
        'card' => '编辑卡片圆角、背景、边框、前景和阴影；未覆盖项继续继承。',
        _ => '编辑菜单项最小高度、圆角、表面、前景和阴影；未覆盖项继续继承。',
      }),
    ]);
  }

  List<Widget> _tagProperties(HyperSizeScheme s, EditorComponent a) {
    final m = _spec.tagMetrics, v = a.tagStyle, theme = _resolveTheme(_dark);
    final palette = theme.tagTheme.style
        .merge(_tagVariant == 'emphasized' ? theme.tagTheme.emphasized : null)
        .merge(_tagState == 'disabled' ? theme.tagTheme.disabled : null)
        .resolvePalette(theme.colors, theme.contrastTheme);
    return [
      if (_tagState == 'common' && _tagVariant == 'common') ...[
        _heading('标签布局'),
        _number(
          '标签高度',
          s.tag.height,
          0,
          120,
          (value) => m.height = value,
          () => m.height = null,
          m.height != null,
        ),
        _number(
          '标签水平内边距',
          s.tag.horizontalPadding,
          0,
          120,
          (value) => m.horizontalPadding = value,
          () => m.horizontalPadding = null,
          m.horizontalPadding != null,
        ),
      ],
      _heading('标签文字与图标'),
      if (_tagState == 'common' && _tagVariant == 'common') ...[
        _number(
          '图标尺寸',
          s.tag.iconSize,
          0,
          120,
          (value) => m.iconSize = value,
          () => m.iconSize = null,
          m.iconSize != null,
        ),
        _number(
          '图标间距',
          s.tag.iconSpacing,
          0,
          120,
          (value) => m.iconSpacing = value,
          () => m.iconSpacing = null,
          m.iconSpacing != null,
        ),
      ],
      _number(
        '标签字号',
        v.fontSize ?? theme.textTheme.labelMedium?.fontSize ?? 12,
        8,
        64,
        (value) => v.fontSize = value,
        () => v.fontSize = null,
        v.fontSize != null,
      ),
      _color(
        '标签文字颜色',
        v.foreground,
        (value) => v.foreground = value,
        inheritedColor: palette.foregroundColor ?? theme.colors.textSecondary,
      ),
      _number(
        '标签过渡时长（毫秒）',
        v.durationMilliseconds ??
            theme.motion.fastDuration.inMilliseconds.toDouble(),
        0,
        5000,
        (value) => v.durationMilliseconds = value,
        () => v.durationMilliseconds = null,
        v.durationMilliseconds != null,
      ),
      _heading('标签配色'),
      _select(
        '外观配色',
        v.colorVariant ?? 'inherit',
        const {
          'inherit': '继承默认',
          'neutral': '中性',
          'soft': '浅色',
          'filled': '实色',
          'outlined': '描边',
          'text': '无底色',
        },
        (value) =>
            _change(() => v.colorVariant = value == 'inherit' ? null : value),
      ),
      _color(
        '标签基色',
        v.baseColor,
        (value) => v.baseColor = value,
        inheritedColor: theme.colors.primary,
      ),
      if (v.colorVariant == 'filled')
        _select(
          '实色前景策略',
          v.foregroundMode ?? 'inherit',
          const {'inherit': '继承默认', 'automatic': '自动对比色', 'white': '白色'},
          (value) => _change(
            () => v.foregroundMode = value == 'inherit' ? null : value,
          ),
        ),
      _number(
        '背景减淡比例',
        (v.backgroundFade ?? (v.colorVariant == 'soft' ? .88 : 0)) * 100,
        0,
        100,
        (value) => v.backgroundFade = value / 100,
        () => v.backgroundFade = null,
        v.backgroundFade != null,
      ),
      _number(
        '边框减淡比例',
        (v.borderFade ?? (v.colorVariant == 'soft' ? .65 : 0)) * 100,
        0,
        100,
        (value) => v.borderFade = value / 100,
        () => v.borderFade = null,
        v.borderFade != null,
      ),
      _number(
        '文字减淡比例',
        (v.foregroundFade ?? 0) * 100,
        0,
        100,
        (value) => v.foregroundFade = value / 100,
        () => v.foregroundFade = null,
        v.foregroundFade != null,
      ),

      _heading('标签表面'),
      if (_tagState == 'common' && _tagVariant == 'common')
        _radiusNumber(
          '标签圆角',
          s.tag.radius,
          0,
          editorRadiusLimit(s.tag.height),
          (value) => m.radius = value,
          () => m.radius = null,
          m.radius != null,
        ),
      ..._borderProperties(
        a,
        label: '标签边框',
        inheritedColor: palette.borderColor,
      ),
    ];
  }

  List<Widget> _chipProperties(HyperSizeScheme s, EditorComponent a) {
    final m = _spec.chipMetrics, v = a.chipStyle, theme = _resolveTheme(_dark);
    final palette = theme.chipTheme
        .resolve({
          if (_chipState != 'common')
            HyperControlState.values.byName(_chipState),
        })
        .resolvePalette(theme.colors, theme.contrastTheme);
    return [
      KeyedSubtree(
        key: const ValueKey('editor-chip-state'),
        child: _select('状态覆盖', _chipState, const {
          'common': '通用（所有状态）',
          'selected': '选中',
          'hovered': '悬停',
          'focused': '聚焦',
          'pressed': '按下',
          'disabled': '禁用',
        }, (value) => _updateState(() => _chipState = value)),
      ),
      const HyperText('通用设置由所有状态继承；选择状态后，仅编辑该状态的覆盖项。配色样式属于外观，不代表选中或按下状态。'),
      if (_chipState == 'common') ...[
        _heading('标签布局'),
        _number(
          '标签高度',
          s.chip.height,
          0,
          120,
          (value) => m.height = value,
          () => m.height = null,
          m.height != null,
        ),
        _number(
          '标签水平内边距',
          s.chip.horizontalPadding,
          0,
          120,
          (value) => m.horizontalPadding = value,
          () => m.horizontalPadding = null,
          m.horizontalPadding != null,
        ),
      ],
      if (_chipState == 'common') ...[
        _heading('标签图标'),
        _number(
          '标签图标尺寸',
          s.chip.iconSize,
          0,
          120,
          (value) => m.iconSize = value,
          () => m.iconSize = null,
          m.iconSize != null,
        ),
        _number(
          '标签图标间距',
          s.chip.iconSpacing,
          0,
          120,
          (value) => m.iconSpacing = value,
          () => m.iconSpacing = null,
          m.iconSpacing != null,
        ),
      ],
      _heading('文字'),
      _number(
        '标签字号',
        v.fontSize ?? theme.textTheme.labelMedium?.fontSize ?? 12,
        8,
        64,
        (value) => v.fontSize = value,
        () => v.fontSize = null,
        v.fontSize != null,
      ),
      _color(
        '标签前景',
        v.foreground,
        (value) => v.foreground = value,
        inheritedColor: palette.foregroundColor ?? theme.colors.textSecondary,
      ),
      _heading('头像与选中标记'),
      if (_chipState == 'common') ...[
        _number(
          '头像尺寸',
          s.chip.avatarSize,
          0,
          120,
          (value) => m.avatarSize = value,
          () => m.avatarSize = null,
          m.avatarSize != null,
        ),
      ],
      _select(
        '显示标签选中标记',
        v.showCheckmark?.toString() ?? 'inherit',
        const {'inherit': '继承默认', 'true': '显示', 'false': '隐藏'},
        (value) => _change(
          () => v.showCheckmark = value == 'inherit' ? null : value == 'true',
        ),
      ),
      _select(
        '标签选中标记位置',
        v.checkPlacement ?? 'inherit',
        const {
          'inherit': '继承默认',
          'leading': '文字前',
          'avatarOverlay': '头像叠加',
          'avatarReplacement': '替换头像',
        },
        (value) =>
            _change(() => v.checkPlacement = value == 'inherit' ? null : value),
      ),
      _select(
        '标签选中图标',
        v.checkIcon ?? 'inherit',
        const {'inherit': '继承默认', 'check': '对勾', 'star': '星形'},
        (value) =>
            _change(() => v.checkIcon = value == 'inherit' ? null : value),
      ),
      _number(
        '头像透明度',
        v.avatarOpacity ?? 1,
        0,
        1,
        (value) => v.avatarOpacity = value,
        () => v.avatarOpacity = null,
        v.avatarOpacity != null,
        wholeNumbers: false,
      ),
      _number(
        '选中图标缩放',
        v.checkmarkScale ?? 1,
        0,
        3,
        (value) => v.checkmarkScale = value,
        () => v.checkmarkScale = null,
        v.checkmarkScale != null,
        wholeNumbers: false,
      ),
      _color(
        '选中图标颜色',
        v.checkColor,
        (value) => v.checkColor = value,
        inheritedColor: theme.colors.primary,
      ),
      _color(
        '选中头像颜色',
        v.avatarColor,
        (value) => v.avatarColor = value,
        inheritedColor: theme.colors.primaryContainer,
      ),
      _heading('删除操作'),
      if (_chipState == 'common') ...[
        _number(
          '删除图标尺寸',
          s.chip.deleteIconSize,
          0,
          120,
          (value) => m.deleteIconSize = value,
          () => m.deleteIconSize = null,
          m.deleteIconSize != null,
        ),
        _number(
          '删除区域宽度',
          s.chip.deleteTargetWidth,
          0,
          120,
          (value) => m.deleteTargetWidth = value,
          () => m.deleteTargetWidth = null,
          m.deleteTargetWidth != null,
        ),
      ],
      _select(
        '标签删除图标',
        v.deleteIcon ?? 'inherit',
        const {
          'inherit': '继承默认',
          'close': '关闭',
          'cancel': '圆形关闭',
          'delete': '删除',
        },
        (value) =>
            _change(() => v.deleteIcon = value == 'inherit' ? null : value),
      ),
      _heading('交互与过渡'),
      _number(
        '标签过渡时长（毫秒）',
        v.durationMilliseconds ??
            theme.motion.fastDuration.inMilliseconds.toDouble(),
        0,
        5000,
        (value) => v.durationMilliseconds = value,
        () => v.durationMilliseconds = null,
        v.durationMilliseconds != null,
      ),
      _color(
        '标签叠加色',
        v.overlay,
        (value) => v.overlay = value,
        inheritedColor: theme.colors.stateLayer,
      ),
      _heading('标签配色'),
      _select(
        '外观配色',
        v.colorVariant ?? 'inherit',
        const {
          'inherit': '继承默认',
          'neutral': '中性',
          'soft': '浅色',
          'filled': '实色',
          'outlined': '描边',
          'text': '无底色',
        },
        (value) =>
            _change(() => v.colorVariant = value == 'inherit' ? null : value),
      ),
      _color(
        '标签基色',
        v.baseColor,
        (value) => v.baseColor = value,
        inheritedColor: theme.colors.primary,
      ),
      if (v.colorVariant == 'filled')
        _select(
          '实色前景策略',
          v.foregroundMode ?? 'inherit',
          const {'inherit': '继承默认', 'automatic': '自动对比色', 'white': '白色'},
          (value) => _change(
            () => v.foregroundMode = value == 'inherit' ? null : value,
          ),
        ),
      _number(
        '背景减淡比例',
        (v.backgroundFade ?? (v.colorVariant == 'soft' ? .88 : 0)) * 100,
        0,
        100,
        (value) => v.backgroundFade = value / 100,
        () => v.backgroundFade = null,
        v.backgroundFade != null,
      ),
      _number(
        '边框减淡比例',
        (v.borderFade ?? (v.colorVariant == 'soft' ? .65 : 0)) * 100,
        0,
        100,
        (value) => v.borderFade = value / 100,
        () => v.borderFade = null,
        v.borderFade != null,
      ),
      _number(
        '文字减淡比例',
        (v.foregroundFade ?? 0) * 100,
        0,
        100,
        (value) => v.foregroundFade = value / 100,
        () => v.foregroundFade = null,
        v.foregroundFade != null,
      ),
      _heading('标签表面'),
      if (_chipState == 'common')
        _radiusNumber(
          '标签圆角',
          s.chip.radius,
          0,
          editorRadiusLimit(s.chip.height),
          (value) => m.radius = value,
          () => m.radius = null,
          m.radius != null,
        ),
      ..._borderProperties(a, label: '标签边框'),
    ];
  }

  List<Widget> _selectTriggerProperties(HyperSizeScheme s) {
    final a = _mode.selectAnchor,
        m = _spec.selectMetrics,
        v = _mode.selectAnchor.buttonStyle;
    final theme = _resolveTheme(_dark);
    return [
      if (_selectState == 'common') ...[
        _number(
          '触发最小高度',
          m.minimumHeight ?? (s.textField.minimumHeight),
          0,
          200,
          (value) => m.minimumHeight = value,
          () => m.minimumHeight = null,
          m.minimumHeight != null,
        ),
        _number(
          '触发水平内边距',
          m.paddingHorizontal ??
              (s.button.padding.resolve(TextDirection.ltr).left),
          0,
          200,
          (value) => m.paddingHorizontal = value,
          () => m.paddingHorizontal = null,
          m.paddingHorizontal != null,
        ),
        _number(
          '触发垂直内边距',
          m.paddingVertical ??
              (s.button.padding.resolve(TextDirection.ltr).top),
          0,
          200,
          (value) => m.paddingVertical = value,
          () => m.paddingVertical = null,
          m.paddingVertical != null,
        ),
        _number(
          '触发最小命中尺寸',
          m.minimumTapTargetSize ?? (s.minimumInteractiveDimension),
          0,
          200,
          (value) => m.minimumTapTargetSize = value,
          () => m.minimumTapTargetSize = null,
          m.minimumTapTargetSize != null,
        ),
        _color(
          '触发文字颜色',
          a.foreground,
          (value) => a.foreground = value,
          inheritedColor: theme.colors.textPrimary,
        ),
        _radiusNumber(
          '触发圆角',
          _spec.selectMetrics.radius ?? s.button.radius,
          0,
          editorRadiusLimit(
            s.select.minimumHeight ?? s.textField.minimumHeight,
          ),
          (value) => _spec.selectMetrics.radius = value,
          () => _spec.selectMetrics.radius = null,
          _spec.selectMetrics.radius != null,
        ),
      ],
      if (_selectState == 'disabled') ...[
        _heading('触发禁用状态'),
        _color(
          '触发禁用背景',
          v.disabledBackground,
          (value) => v.disabledBackground = value,
          inheritedColor: theme.colors.surfaceMuted,
        ),
        _color(
          '触发禁用前景',
          v.disabledForeground,
          (value) => v.disabledForeground = value,
          inheritedColor: theme.colors.disabled,
        ),
      ],
      if (_selectState != 'disabled') _heading('触发交互反馈 · 下拉专属'),
      const HyperText('状态叠加色与透明度用于下拉按钮；自动填充使用输入框的焦点与边框状态。'),
      if (_selectState == 'common') ...[
        _color(
          '触发交互叠加色',
          v.overlay,
          (value) => v.overlay = value,
          inheritedColor: theme.colors.stateLayer,
        ),
      ],
      if (_selectState == 'hovered') ...[
        _number(
          '触发悬停叠加',
          v.hoverOpacity ?? (s.button.hoverOverlayOpacity),
          0,
          1,
          (value) => v.hoverOpacity = value,
          () => v.hoverOpacity = null,
          v.hoverOpacity != null,
          wholeNumbers: false,
        ),
      ],
      if (_selectState == 'focused') ...[
        _number(
          '触发聚焦叠加',
          v.focusOpacity ?? (s.button.focusOverlayOpacity),
          0,
          1,
          (value) => v.focusOpacity = value,
          () => v.focusOpacity = null,
          v.focusOpacity != null,
          wholeNumbers: false,
        ),
      ],
      if (_selectState == 'pressed') ...[
        _number(
          '触发按下叠加',
          v.pressOpacity ?? (s.button.pressOverlayOpacity),
          0,
          1,
          (value) => v.pressOpacity = value,
          () => v.pressOpacity = null,
          v.pressOpacity != null,
          wholeNumbers: false,
        ),
      ],
      if (['hovered', 'focused', 'pressed'].contains(_selectState))
        _heading('触发交互变换'),
      if (_selectState == 'hovered') ...[
        _number(
          '触发悬停水平位移',
          v.hoveredOffsetX ?? 0,
          -20,
          20,
          (value) => v.hoveredOffsetX = value,
          () => v.hoveredOffsetX = null,
          v.hoveredOffsetX != null,
        ),
        _number(
          '触发悬停垂直位移',
          v.hoveredOffsetY ?? 0,
          -20,
          20,
          (value) => v.hoveredOffsetY = value,
          () => v.hoveredOffsetY = null,
          v.hoveredOffsetY != null,
        ),
        _number(
          '触发悬停缩放',
          v.hoveredScale ?? 1,
          .5,
          1.5,
          (value) => v.hoveredScale = value,
          () => v.hoveredScale = null,
          v.hoveredScale != null,
          wholeNumbers: false,
        ),
      ],
      if (_selectState == 'focused') ...[
        _number(
          '触发聚焦水平位移',
          v.focusedOffsetX ?? 0,
          -20,
          20,
          (value) => v.focusedOffsetX = value,
          () => v.focusedOffsetX = null,
          v.focusedOffsetX != null,
        ),
        _number(
          '触发聚焦垂直位移',
          v.focusedOffsetY ?? 0,
          -20,
          20,
          (value) => v.focusedOffsetY = value,
          () => v.focusedOffsetY = null,
          v.focusedOffsetY != null,
        ),
        _number(
          '触发聚焦缩放',
          v.focusedScale ?? 1,
          .5,
          1.5,
          (value) => v.focusedScale = value,
          () => v.focusedScale = null,
          v.focusedScale != null,
          wholeNumbers: false,
        ),
      ],
      if (_selectState == 'pressed') ...[
        _number(
          '触发按下水平位移',
          v.pressedOffsetX ?? 0,
          -20,
          20,
          (value) => v.pressedOffsetX = value,
          () => v.pressedOffsetX = null,
          v.pressedOffsetX != null,
        ),
        _number(
          '触发按下垂直位移',
          v.pressedOffsetY ?? 0,
          -20,
          20,
          (value) => v.pressedOffsetY = value,
          () => v.pressedOffsetY = null,
          v.pressedOffsetY != null,
        ),
        _number(
          '触发按下缩放',
          v.pressedScale ?? 1,
          .5,
          1.5,
          (value) => v.pressedScale = value,
          () => v.pressedScale = null,
          v.pressedScale != null,
          wholeNumbers: false,
        ),
      ],
      if (_selectState == 'common') ...[
        _heading('触发动效'),
        _number(
          '触发过渡时长（毫秒）',
          v.animationMilliseconds ??
              theme.motion.fastDuration.inMilliseconds.toDouble(),
          0,
          5000,
          (value) => v.animationMilliseconds = value,
          () => v.animationMilliseconds = null,
          v.animationMilliseconds != null,
        ),
      ],
    ];
  }

  List<Widget> _selectProperties(HyperSizeScheme s) {
    final m = _spec.selectMetrics, v = _mode.select.selectStyle;
    final theme = _resolveTheme(_dark),
        style = _resolveTheme(_dark).selectTheme.style;
    return [
      if (_selectSurfaceAnchor) ...[
        if (_selectState == 'common') ...[
          _heading('触发按钮'),
          _number(
            '选择器宽度',
            s.select.width,
            0,
            1000,
            (value) => m.width = value,
            () => m.width = null,
            m.width != null,
          ),
          _number(
            '触发文字字号',
            v.labelFontSize ?? (theme.textTheme.labelLarge?.fontSize ?? 14),
            8,
            64,
            (value) => v.labelFontSize = value,
            () => v.labelFontSize = null,
            v.labelFontSize != null,
          ),
        ],
        ..._selectTriggerProperties(s),
        if (_selectState == 'common') ...[
          _heading('箭头'),
          _number(
            '箭头尺寸',
            s.select.arrowSize,
            0,
            1000,
            (value) => m.arrowSize = value,
            () => m.arrowSize = null,
            m.arrowSize != null,
          ),
          _number(
            '箭头间距',
            s.select.arrowSpacing,
            0,
            1000,
            (value) => m.arrowSpacing = value,
            () => m.arrowSpacing = null,
            m.arrowSpacing != null,
          ),
          _color(
            '箭头颜色',
            v.arrowColor,
            (value) => v.arrowColor = value,
            inheritedColor: style?.arrowColor ?? theme.colors.textSecondary,
          ),
        ],
        if (_selectState == 'disabled') ...[
          _color(
            '禁用箭头颜色',
            v.disabledArrowColor,
            (value) => v.disabledArrowColor = value,
            inheritedColor: style?.disabledArrowColor ?? theme.colors.disabled,
          ),
        ],
        if (_selectState == 'common') ...[
          _heading('多选标签'),
          _number(
            '标签间距',
            s.selection.chipSpacing,
            0,
            1000,
            (value) => m.chipSpacing = value,
            () => m.chipSpacing = null,
            m.chipSpacing != null,
          ),
          _number(
            '最小输入宽度',
            s.selection.minimumInputWidth,
            0,
            1000,
            (value) => m.minimumInputWidth = value,
            () => m.minimumInputWidth = null,
            m.minimumInputWidth != null,
          ),
        ],
      ] else ...[
        if (_selectState == 'common') ...[
          _heading('选项布局'),
          _number(
            '选项最小高度',
            m.itemHeight ?? (s.menu.itemHeight),
            0,
            200,
            (value) => m.itemHeight = value,
            () => m.itemHeight = null,
            m.itemHeight != null,
          ),
          _number(
            '选项内边距',
            m.itemPadding ?? (s.menu.padding),
            0,
            200,
            (value) => m.itemPadding = value,
            () => m.itemPadding = null,
            m.itemPadding != null,
          ),
          _number(
            '选项间距',
            m.itemSpacing ?? (s.menu.itemSpacing ?? s.navigationItemSpacing),
            0,
            200,
            (value) => m.itemSpacing = value,
            () => m.itemSpacing = null,
            m.itemSpacing != null,
          ),
        ],
        if (_selectState == 'selected') ...[
          _heading('选中图标'),
          _select(
            '显示选中对勾',
            v.showCheckmark?.toString() ?? 'inherit',
            const {'inherit': '继承默认', 'true': '显示', 'false': '隐藏'},
            (value) => _change(
              () =>
                  v.showCheckmark = value == 'inherit' ? null : value == 'true',
            ),
          ),
          _select(
            '选中图标位置',
            v.checkPlacement ?? 'inherit',
            const {'inherit': '继承默认', 'leading': '前面', 'trailing': '后面'},
            (value) => _change(
              () => v.checkPlacement = value == 'inherit' ? null : value,
            ),
          ),
          _select(
            '选中图标',
            v.checkIcon ?? 'inherit',
            const {
              'inherit': '继承默认',
              'check': '对勾',
              'doneAll': '双对勾',
              'radio': '圆形选中',
              'star': '星形',
            },
            (value) =>
                _change(() => v.checkIcon = value == 'inherit' ? null : value),
          ),
          _color(
            '选中图标颜色',
            v.checkColor,
            (value) => v.checkColor = value,
            inheritedColor:
                v.selectedForegroundColor?.resolve(theme.colors) ??
                theme.colors.textPrimary,
          ),
          _number(
            '选中图标尺寸',
            v.checkSize ?? s.menu.iconSize,
            0,
            80,
            (value) => v.checkSize = value,
            () => v.checkSize = null,
            v.checkSize != null,
          ),
          _number(
            '选中图标间距',
            v.checkSpacing ?? s.menu.iconSpacing,
            0,
            80,
            (value) => v.checkSpacing = value,
            () => v.checkSpacing = null,
            v.checkSpacing != null,
          ),
          const HyperText('隐藏对勾时保留选中配色，同时移除图标占位。'),
        ],
        if (_selectState == 'common') ...[
          _heading('选项文字'),
          _number(
            '选项字号',
            v.optionFontSize ?? theme.typography.control,
            8,
            64,
            (value) => v.optionFontSize = value,
            () => v.optionFontSize = null,
            v.optionFontSize != null,
          ),
          _color(
            '选项颜色',
            v.optionForegroundColor,
            (value) => v.optionForegroundColor = value,
            inheritedColor: theme.colors.textPrimary,
          ),
        ],
        if (_selectState == 'disabled') ...[
          _color(
            '禁用选项颜色',
            v.disabledOptionColor,
            (value) => v.disabledOptionColor = value,
            inheritedColor: theme.colors.disabled,
          ),
        ],
        if (_selectState == 'selected') ...[
          _color(
            '选中选项背景',
            v.selectedBackgroundColor,
            (value) => v.selectedBackgroundColor = value,
            inheritedColor: theme.colors.primary.withValues(alpha: .08),
          ),
          _color(
            '选中选项前景',
            v.selectedForegroundColor,
            (value) => v.selectedForegroundColor = value,
            inheritedColor: theme.colors.primary,
          ),
        ],
        if (_selectState == 'active') ...[
          _color(
            '活动选项背景',
            v.activeBackgroundColor,
            (value) => v.activeBackgroundColor = value,
            inheritedColor: theme.colors.stateLayer.withValues(alpha: .06),
          ),
        ],
        if (_selectState == 'common') ...[
          _heading('搜索'),
          _number(
            '搜索字号',
            v.searchFontSize ?? (theme.textTheme.labelLarge?.fontSize ?? 14),
            8,
            64,
            (value) => v.searchFontSize = value,
            () => v.searchFontSize = null,
            v.searchFontSize != null,
          ),
          _number(
            '搜索防抖（毫秒）',
            v.searchDebounce ??
                (theme.motion.standardDuration.inMilliseconds.toDouble()),
            0,
            5000,
            (value) => v.searchDebounce = value,
            () => v.searchDebounce = null,
            v.searchDebounce != null,
          ),
          _color(
            '搜索占位颜色',
            v.searchHintColor,
            (value) => v.searchHintColor = value,
            inheritedColor: theme.colors.textTertiary,
          ),
          _heading('选项面板'),
          _number(
            '面板最大高度',
            s.selection.maxPanelHeight,
            0,
            1000,
            (value) => m.maxPanelHeight = value,
            () => m.maxPanelHeight = null,
            m.maxPanelHeight != null,
          ),
          _number(
            '弹出间距',
            s.select.popupSpacing ?? s.overlaySpacing,
            0,
            1000,
            (value) => m.popupSpacing = value,
            () => m.popupSpacing = null,
            m.popupSpacing != null,
          ),
          _heading('状态过渡'),
          _number(
            '选择器过渡时长（毫秒）',
            v.durationMilliseconds ??
                (theme.motion.fastDuration.inMilliseconds.toDouble()),
            0,
            5000,
            (value) => v.durationMilliseconds = value,
            () => v.durationMilliseconds = null,
            v.durationMilliseconds != null,
          ),
        ],
      ],
    ];
  }

  List<Widget> _textFieldProperties(HyperSizeScheme s, EditorComponent a) {
    final m = _spec.textFieldMetrics, v = a.textFieldStyle;
    final theme = _resolveTheme(_dark);
    Widget weightControl(String label, int? value, void Function(int?) set) =>
        _select(label, value?.toString() ?? 'inherit', const {
          'inherit': '继承',
          '100': '100',
          '200': '200',
          '300': '300',
          '400': '400 常规',
          '500': '500 中等',
          '600': '600 半粗',
          '700': '700 粗体',
          '800': '800',
          '900': '900',
        }, (x) => _change(() => set(x == 'inherit' ? null : int.parse(x))));
    Widget iconControl(
      String label,
      String? value,
      void Function(String?) set,
    ) => _select(label, value ?? 'inherit', const {
      'inherit': '继承默认',
      'close': '关闭',
      'cancel': '圆形关闭',
      'visibility': '显示',
      'visibilityOff': '隐藏',
      'lock': '锁定',
      'lockOpen': '解锁',
      'error': '错误',
      'warning': '警告',
      'info': '信息',
    }, (x) => _change(() => set(x == 'inherit' ? null : x)));
    return [
      if (_fieldState == 'common') ...[
        _heading('输入框布局'),
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
          '水平内边距',
          s.textField.horizontalPadding,
          0,
          editorLayoutInsetLimit,
          (value) => m.horizontalPadding = value,
          () => m.horizontalPadding = null,
          m.horizontalPadding != null,
        ),
        _number(
          '垂直内边距',
          s.textField.verticalPadding,
          0,
          editorLayoutInsetLimit,
          (value) => m.verticalPadding = value,
          () => m.verticalPadding = null,
          m.verticalPadding != null,
        ),
        _select(
          '文字垂直对齐',
          v.verticalAlignment ?? 'inherit',
          const {
            'inherit': '继承（单行居中，多行顶部）',
            'top': '顶部',
            'center': '居中',
            'bottom': '底部',
          },
          (x) => _change(() => v.verticalAlignment = x == 'inherit' ? null : x),
        ),
        _heading('输入文字'),
        weightControl('输入字重', v.textWeight, (x) => v.textWeight = x),
        _number(
          '输入字号',
          v.textFontSize ?? (theme.textTheme.labelLarge?.fontSize ?? 14),
          8,
          editorContentIconLimit,
          (value) => v.textFontSize = value,
          () => v.textFontSize = null,
          v.textFontSize != null,
        ),
        _color('前景', a.foreground, (value) => a.foreground = value),
        _heading('占位文字'),
        weightControl('占位字重', v.hintWeight, (x) => v.hintWeight = x),
        _number(
          '占位字号',
          v.hintFontSize ?? (theme.textTheme.labelLarge?.fontSize ?? 14),
          8,
          editorContentIconLimit,
          (value) => v.hintFontSize = value,
          () => v.hintFontSize = null,
          v.hintFontSize != null,
        ),
        _color(
          '占位文字颜色',
          v.hintColor,
          (value) => v.hintColor = value,
          inheritedColor:
              theme.textFieldTheme.style.hintStyle?.color ??
              theme.colors.textTertiary,
        ),
        _heading('标签'),
        weightControl('标签字重', v.labelWeight, (x) => v.labelWeight = x),
        _number(
          '标签字号',
          v.labelFontSize ?? (theme.textTheme.labelMedium?.fontSize ?? 12),
          8,
          editorContentIconLimit,
          (value) => v.labelFontSize = value,
          () => v.labelFontSize = null,
          v.labelFontSize != null,
        ),
        _color(
          '标签颜色',
          v.labelColor,
          (value) => v.labelColor = value,
          inheritedColor:
              theme.textFieldTheme.style.labelStyle?.color ??
              theme.colors.textSecondary,
        ),
        _number(
          '标签间距',
          s.textField.labelGap,
          0,
          editorLayoutInsetLimit,
          (value) => m.labelGap = value,
          () => m.labelGap = null,
          m.labelGap != null,
        ),
        _heading('字数计数'),
        weightControl('计数字重', v.counterWeight, (x) => v.counterWeight = x),
        _number(
          '计数字号',
          v.counterFontSize ?? (theme.textTheme.labelSmall?.fontSize ?? 11),
          8,
          editorContentIconLimit,
          (value) => v.counterFontSize = value,
          () => v.counterFontSize = null,
          v.counterFontSize != null,
        ),
        _color(
          '计数颜色',
          v.counterColor,
          (value) => v.counterColor = value,
          inheritedColor:
              theme.textFieldTheme.style.counterStyle?.color ??
              theme.colors.textSecondary,
        ),
        _heading('图标与操作区'),
        _number(
          '图标尺寸',
          s.textField.iconSize,
          0,
          editorContentIconLimit,
          (value) => m.iconSize = value,
          () => m.iconSize = null,
          m.iconSize != null,
        ),
        _color(
          '图标颜色',
          v.iconColor,
          (value) => v.iconColor = value,
          inheritedColor:
              theme.textFieldTheme.style.iconColor ??
              theme.colors.textSecondary,
        ),
        _number(
          '操作区宽度',
          s.textField.actionWidth,
          0,
          editorLayoutInsetLimit,
          (value) => m.actionWidth = value,
          () => m.actionWidth = null,
          m.actionWidth != null,
        ),
        iconControl('清除图标', v.clearIconName, (x) => v.clearIconName = x),
        iconControl(
          '密码显示图标',
          v.showPasswordIconName,
          (x) => v.showPasswordIconName = x,
        ),
        iconControl(
          '密码隐藏图标',
          v.hidePasswordIconName,
          (x) => v.hidePasswordIconName = x,
        ),
        _heading('光标'),
        _color(
          '光标颜色',
          v.cursorColor,
          (value) => v.cursorColor = value,
          inheritedColor:
              theme.textFieldTheme.style.cursorColor ?? theme.colors.primary,
        ),
        _number(
          '光标宽度',
          v.cursorWidth ?? (theme.textFieldTheme.style.cursorWidth ?? 2),
          0,
          editorSelectionStrokeLimit(s.textField.minimumHeight),
          (value) => v.cursorWidth = value,
          () => v.cursorWidth = null,
          v.cursorWidth != null,
        ),
        _radiusNumber(
          '光标圆角',
          v.cursorRadius ?? (theme.textFieldTheme.style.cursorRadius?.x ?? 1),
          0,
          editorRadiusLimit(
            v.cursorWidth ?? theme.textFieldTheme.style.cursorWidth ?? 2,
          ),
          (value) => v.cursorRadius = value,
          () => v.cursorRadius = null,
          v.cursorRadius != null,
        ),
      ],
      if (_fieldState == 'error') ...[
        _heading('错误提示'),
        iconControl('错误图标', v.errorIconName, (x) => v.errorIconName = x),
        _number(
          '错误文字字号',
          m.errorFontSize ?? theme.typography.bodySmall,
          8,
          editorContentIconLimit,
          (x) => m.errorFontSize = x,
          () => m.errorFontSize = null,
          m.errorFontSize != null,
        ),
        weightControl('错误文字字重', v.errorWeight, (x) => v.errorWeight = x),
        _color(
          '错误文字颜色',
          v.errorTextColor,
          (x) => v.errorTextColor = x,
          inheritedColor: theme.colors.textPrimary,
        ),
        _select('错误浮层位置', v.errorPlacement ?? 'inherit', const {
          'inherit': '继承默认',
          'bottomStart': '下方起点',
          'bottomEnd': '下方末端',
          'topStart': '上方起点',
          'sideStart': '侧边起点',
          'sideEnd': '侧边末端',
        }, (x) => _change(() => v.errorPlacement = x == 'inherit' ? null : x)),
        _color(
          '错误图标颜色',
          v.errorIconColor,
          (value) => v.errorIconColor = value,
          inheritedColor:
              theme.textFieldTheme.style.errorIconColor ?? theme.colors.error,
        ),
        _number(
          '错误浮层最大宽度',
          s.textField.errorMaxWidth,
          0,
          editorContentWidthLimit,
          (value) => m.errorMaxWidth = value,
          () => m.errorMaxWidth = null,
          m.errorMaxWidth != null,
        ),
      ],
      if (_fieldState == 'error') ...[
        _heading('错误浮层表面'),
        _color(
          '错误浮层背景',
          v.errorPopupBackground,
          (x) => v.errorPopupBackground = x,
          inheritedColor: theme.colors.surface,
        ),
        _number(
          '错误浮层内边距',
          m.errorPopupPadding ?? s.textField.horizontalPadding,
          0,
          editorLayoutInsetLimit,
          (x) => m.errorPopupPadding = x,
          () => m.errorPopupPadding = null,
          m.errorPopupPadding != null,
        ),
        _radiusNumber(
          '错误浮层圆角',
          m.errorPopupRadius ?? s.menu.surfaceRadius,
          0,
          editorSurfaceRadiusLimit,
          (x) => m.errorPopupRadius = x,
          () => m.errorPopupRadius = null,
          m.errorPopupRadius != null,
        ),
        _number(
          '错误浮层边框宽度',
          m.errorPopupBorderWidth ?? 0,
          0,
          editorLineThicknessLimit,
          (x) => m.errorPopupBorderWidth = x,
          () => m.errorPopupBorderWidth = null,
          m.errorPopupBorderWidth != null,
        ),
        _color(
          '错误浮层边框颜色',
          v.errorPopupBorderColor,
          (x) => v.errorPopupBorderColor = x,
          inheritedColor: theme.colors.outline,
        ),
        ..._focusedShadowProperties(
          a,
          stateTarget: v.errorPopupShadow,
          label: '错误浮层阴影',
          description: '继承统一浮层阴影；空列表关闭错误浮层阴影。',
        ),
      ],
      if (_fieldState == 'disabled') ...[
        _heading('禁用状态'),
        _color(
          '禁用前景颜色',
          v.disabledForegroundColor,
          (value) => v.disabledForegroundColor = value,
          inheritedColor:
              theme.textFieldTheme.disabled.foregroundColor ??
              theme.colors.disabled,
        ),
      ],
      if (_fieldState == 'common') ...[
        _heading('状态过渡'),
        _select('状态过渡曲线', v.motionCurve ?? 'inherit', const {
          'inherit': '继承默认',
          'linear': '线性',
          'easeInOut': '缓入缓出',
          'fastOutSlowIn': '快出慢入',
        }, (x) => _change(() => v.motionCurve = x == 'inherit' ? null : x)),
        _number(
          '状态过渡时长（毫秒）',
          v.durationMilliseconds ??
              (theme.motion.fastDuration.inMilliseconds.toDouble()),
          0,
          5000,
          (value) => v.durationMilliseconds = value,
          () => v.durationMilliseconds = null,
          v.durationMilliseconds != null,
        ),
        _heading('输入框表面'),
        _radiusNumber(
          '圆角',
          s.textField.radius,
          0,
          editorRadiusLimit(s.textField.minimumHeight),
          (v) => _spec.fieldRadius = v,
          () => _spec.fieldRadius = null,
          _spec.fieldRadius != null,
        ),
        ..._backgroundProperties(a),
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
      ],
      ..._textFieldBorderProperties(a),
    ];
  }

  HyperFill? _componentFill(HyperThemeData theme) => switch (_component) {
    'button' =>
      theme.buttonTheme
          .resolve(_buttonVariant ?? HyperButtonVariant.filled)
          .background,
    'container' => theme.containerTheme.background ?? const HyperFill.none(),
    'collapsible' => theme.collapsibleTheme.style.background,
    'group' =>
      theme.widgetGroupTheme.style.backgroundColor == null
          ? null
          : HyperFill.color(theme.widgetGroupTheme.style.backgroundColor!),
    'card' => theme.cardTheme.style?.background,
    'tag' =>
      resolveEditorTag(
            _appearance,
            theme.colors,
            theme.contrastTheme,
          ).resolvePalette(theme.colors, theme.contrastTheme).background ??
          HyperFill.color(theme.colors.surfaceMuted),
    'chip' =>
      resolveEditorChip(
            _appearance,
            theme.colors,
          ).resolvePalette(theme.colors, theme.contrastTheme).background ??
          HyperFill.color(theme.colors.surfaceMuted),
    'field' => theme.textFieldTheme.style.background,
    'select' =>
      _selectSurfaceAnchor
          ? theme.selectTheme.style?.buttonStyle?.background ??
                const HyperFill.none()
          : theme.selectTheme.style?.selectionStyle?.surfaceStyle?.background,
    _ => theme.menuTheme.style?.surfaceStyle?.background,
  };

  List<Widget> _backgroundProperties(EditorComponent a) {
    final fill = _componentFill(_resolveTheme(_dark));
    final current =
        a.fillKind ??
        (a.gradient != null ||
                a.buttonStyle.gradient != null ||
                fill?.gradient != null ||
                (_component == 'button' &&
                    _buttonVariant == HyperButtonVariant.gradient)
            ? EditorFillKind.gradient
            : fill?.isNone == true
            ? EditorFillKind.none
            : EditorFillKind.solid);
    return [
      _select(
        '背景类型',
        a.fillKind?.name ?? 'inherit',
        const {
          'inherit': '继承默认',
          'solid': '纯色',
          'gradient': '渐变',
          'none': '无填充',
        },
        (v) => _change(() {
          a.fillKind = v == 'inherit' ? null : EditorFillKind.values.byName(v);
          a.buttonStyle.gradient = null;
          if (v == 'gradient') {
            a.gradient ??= EditorGradient(
              colors: [
                const EditorColor(semantic: 'primary'),
                const EditorColor(semantic: 'surface'),
              ],
              stops: [0, 1],
            );
          }
          if (v == 'solid') {
            a.background ??= EditorColor(
              argb:
                  (fill?.color ??
                          (_component == 'button'
                              ? _resolveTheme(_dark).colors.primary
                              : _resolveTheme(_dark).colors.surface))
                      .toARGB32(),
            );
          }
          if (v == 'inherit') {
            a.background = null;
            a.gradient = null;
          }
        }),
      ),
      if (current == EditorFillKind.gradient) ..._gradientProperties(a),
      if (current == EditorFillKind.solid)
        _color(
          _component == 'button' && _buttonVariant == null && a.fillKind == null
              ? '通用强调色'
              : '背景',
          a.background,
          (v) => a.background = v,
        ),
    ];
  }

  List<Widget> _textFieldBorderProperties(EditorComponent a) {
    final v = a.textFieldStyle;
    final colors = _resolveTheme(_dark).colors;
    return [
      const HyperText('聚焦表示点击输入框或通过键盘获得焦点；错误优先于聚焦，禁用最后覆盖。未配置项继承默认边框形态。'),
      if (_fieldState == 'common') ..._borderProperties(a, label: '默认边框'),
      if (_fieldState == 'hovered')
        ..._borderProperties(
          a,
          stateBorder: v.hoveredBorder,
          label: '悬停边框',
          inheritedColor:
              v.hoverBorderColor?.resolve(colors) ?? colors.textSecondary,
          reset: () {
            v.hoveredBorder = EditorBorder();
            v.hoverBorderColor = null;
          },
        ),
      if (_fieldState == 'focused')
        ..._borderProperties(
          a,
          stateBorder: v.focusedBorder,
          label: '聚焦边框',
          inheritedColor: v.focusBorderColor?.resolve(colors) ?? colors.primary,
          reset: () {
            v.focusedBorder = EditorBorder();
            v.focusBorderColor = null;
          },
        ),
      if (_fieldState == 'error')
        ..._borderProperties(
          a,
          stateBorder: v.errorBorder,
          label: '错误边框',
          inheritedColor: v.errorBorderColor?.resolve(colors) ?? colors.error,
          reset: () {
            v.errorBorder = EditorBorder();
            v.errorBorderColor = null;
          },
        ),
      if (_fieldState == 'disabled')
        ..._borderProperties(
          a,
          stateBorder: v.disabledBorder,
          label: '禁用边框',
          reset: () {
            v.disabledBorder = EditorBorder();
          },
        ),
    ];
  }

  List<Widget> _borderProperties(
    EditorComponent a, {
    EditorBorder? stateBorder,
    String label = '边框',
    Color? inheritedColor,
    VoidCallback? reset,
  }) {
    final border = stateBorder ?? a.border;
    final colors = _resolveTheme(_dark).colors;
    final legacyColor = switch (_component) {
      'button' => a.buttonStyle.borderColor,
      'chip' => a.chipStyle.borderColor,
      _ => null,
    };
    final legacyWidth = switch (_component) {
      'button' => a.buttonStyle.borderWidth,
      'chip' => a.chipStyle.borderWidth,
      _ => null,
    };
    return [
      _heading(label),
      _select(
        '$label类型',
        border.kind?.name ?? 'inherit',
        const {
          'inherit': '继承默认',
          'solid': '实线',
          'dashed': '虚线',
          'dotted': '点线',
          'none': '无边框',
        },
        (v) => _change(() {
          if (v == 'inherit') {
            if (reset != null) {
              reset();
            } else {
              a.border = EditorBorder();
            }
            if (_component == 'button') {
              a.buttonStyle.borderWidth = null;
              a.buttonStyle.borderColor = null;
            } else if (_component == 'chip') {
              a.chipStyle.borderWidth = null;
              a.chipStyle.borderColor = null;
            }
          } else {
            border.kind = EditorBorderKind.values.byName(v);
          }
        }),
      ),
      if (border.kind != null && border.kind != EditorBorderKind.none) ...[
        _semanticColor(
          '$label颜色',
          (border.color ?? legacyColor)?.resolve(colors) ??
              inheritedColor ??
              colors.outline,
          border.color?.resolve(colors),
          (v) =>
              border.color = v == null ? null : EditorColor(argb: v.toARGB32()),
        ),
        _number(
          '$label宽度',
          border.width ??
              legacyWidth ??
              (stateBorder == null ? null : a.border.width) ??
              1,
          0,
          10,
          (v) => border.width = v,
          () => border.width = null,
          border.width != null,
          wholeNumbers: true,
        ),
        if (border.kind == EditorBorderKind.dashed ||
            border.kind == EditorBorderKind.dotted) ...[
          if (border.kind == EditorBorderKind.dashed)
            _number(
              label == '边框' ? '虚线长度' : '$label虚线长度',
              border.dashLength ?? 6,
              1,
              editorPatternSegmentLimit,
              (v) => border.dashLength = v,
              () => border.dashLength = null,
              border.dashLength != null,
              wholeNumbers: true,
            ),
          _number(
            label == '边框' ? '虚线间隔' : '$label虚线间隔',
            border.gapLength ?? 4,
            1,
            editorPatternSegmentLimit,
            (v) => border.gapLength = v,
            () => border.gapLength = null,
            border.gapLength != null,
            wholeNumbers: true,
          ),
        ],
      ],
    ];
  }

  List<Widget> _gradientProperties(
    EditorComponent appearance, {
    EditorGradient? Function()? readGradient,
    ValueChanged<EditorGradient?>? writeGradient,
    Gradient? inheritedGradient,
    bool showType = true,
  }) {
    final theme = _resolveTheme(_dark);
    final inherited = inheritedGradient ?? _componentFill(theme)?.gradient;
    final baseColors =
        inherited?.colors ??
        [
          theme.colors.primary,
          Color.lerp(theme.colors.primary, theme.colors.error, .45)!,
        ];
    final gradient =
        readGradient?.call() ??
        appearance.gradient ??
        appearance.buttonStyle.gradient ??
        (inherited == null ? null : EditorGradient.fromGradient(inherited)) ??
        EditorGradient(
          colors: baseColors
              .map((c) => EditorColor(argb: c.toARGB32()))
              .toList(),
          stops:
              inherited?.stops ??
              List.generate(
                baseColors.length,
                (i) => i / (baseColors.length - 1),
              ),
        );
    void edit(void Function(EditorGradient) change) {
      final current =
          readGradient?.call() ??
          appearance.gradient ??
          appearance.buttonStyle.gradient ??
          gradient;
      final next = EditorGradient.fromJson(current.toJson());
      change(next);
      if (writeGradient != null) {
        writeGradient(next);
      } else {
        appearance.gradient = next;
        appearance.fillKind = EditorFillKind.gradient;
        appearance.buttonStyle.gradient = null;
      }
    }

    return [
      Row(
        children: [
          Expanded(child: HyperText(writeGradient == null ? '渐变背景' : '渐变节点')),
          HyperIconButton.ghost(
            tooltip: '恢复继承',
            icon: const Icon(Icons.restart_alt),
            onPressed:
                (readGradient != null
                    ? readGradient() == null
                    : appearance.gradient == null &&
                          appearance.buttonStyle.gradient == null)
                ? null
                : () => _change(() {
                    if (writeGradient != null) {
                      writeGradient(null);
                    } else {
                      appearance.gradient = null;
                      appearance.buttonStyle.gradient = null;
                      appearance.fillKind = null;
                    }
                  }),
          ),
          HyperIconButton.ghost(
            tooltip: '添加颜色节点',
            icon: const Icon(Icons.add),
            onPressed: () => _change(
              () => edit((g) {
                g.appendStop();
              }),
            ),
          ),
        ],
      ),
      if (showType)
        _select(
          '渐变类型',
          gradient.kind.name,
          const {'linear': '线性', 'radial': '径向', 'sweep': '扫描'},
          (v) => _change(
            () => edit((g) => g.kind = EditorGradientKind.values.byName(v)),
          ),
        ),
      if (gradient.kind == EditorGradientKind.linear)
        _number(
          '渐变方向（度）',
          gradient.angle,
          0,
          360,
          (v) => edit((g) => g.angle = v),
          () => edit((g) => g.angle = 0),
          appearance.gradient != null ||
              appearance.buttonStyle.gradient != null,
          wholeNumbers: true,
        ),
      if (gradient.kind != EditorGradientKind.linear) ...[
        _number(
          '渐变中心 X',
          gradient.centerX,
          -1,
          1,
          (v) => edit((g) => g.centerX = v),
          () => edit((g) => g.centerX = 0),
          gradient.centerX != 0,
          wholeNumbers: false,
        ),
        _number(
          '渐变中心 Y',
          gradient.centerY,
          -1,
          1,
          (v) => edit((g) => g.centerY = v),
          () => edit((g) => g.centerY = 0),
          gradient.centerY != 0,
          wholeNumbers: false,
        ),
      ],
      if (gradient.kind == EditorGradientKind.radial)
        _number(
          '渐变半径',
          gradient.radius,
          .01,
          2,
          (v) => edit((g) => g.radius = v),
          () => edit((g) => g.radius = .5),
          gradient.radius != .5,
          wholeNumbers: false,
        ),
      if (gradient.kind == EditorGradientKind.sweep) ...[
        _number(
          '扫描起始角（度）',
          gradient.startAngle,
          0,
          (gradient.endAngle - .1).clamp(0.0, 360.0).toDouble(),
          (v) => edit((g) => g.startAngle = v),
          () => edit((g) => g.startAngle = 0),
          gradient.startAngle != 0,
          wholeNumbers: false,
        ),
        _number(
          '扫描终止角（度）',
          gradient.endAngle,
          (gradient.startAngle + .1).clamp(0.0, 360.0).toDouble(),
          360,
          (v) => edit((g) => g.endAngle = v),
          () => edit((g) => g.endAngle = 360),
          gradient.endAngle != 360,
          wholeNumbers: false,
        ),
        _number(
          '扫描旋转（度）',
          gradient.angle,
          0,
          360,
          (v) => edit((g) => g.angle = v),
          () => edit((g) => g.angle = 0),
          gradient.angle != 0,
          wholeNumbers: true,
        ),
      ],
      for (var i = 0; i < gradient.colors.length; i++) ...[
        Row(
          children: [
            Expanded(
              child: _semanticColor(
                '渐变节点 ${i + 1}',
                gradient.colors[i].resolve(theme.colors),
                gradient.colors[i].resolve(theme.colors),
                (c) => edit(
                  (g) => g.colors[i] = c == null
                      ? const EditorColor(semantic: 'primary')
                      : EditorColor(argb: c.toARGB32()),
                ),
              ),
            ),
            HyperIconButton.ghost(
              tooltip: '删除颜色节点',
              icon: const Icon(Icons.remove),
              onPressed: gradient.colors.length <= 2
                  ? null
                  : () => _change(
                      () => edit((g) {
                        g.colors.removeAt(i);
                        g.stops.removeAt(i);
                      }),
                    ),
            ),
          ],
        ),
        if ((i == 0 ? 0.0 : gradient.stops[i - 1]) <
            (i == gradient.stops.length - 1 ? 1.0 : gradient.stops[i + 1]))
          _number(
            '节点 ${i + 1} 位置',
            gradient.stops[i],
            i == 0 ? 0 : gradient.stops[i - 1],
            i == gradient.stops.length - 1 ? 1 : gradient.stops[i + 1],
            (v) => edit((g) => g.stops[i] = v),
            () => edit((g) => g.resetStop(i)),
            appearance.gradient != null ||
                appearance.buttonStyle.gradient != null,
            wholeNumbers: false,
          ),
      ],
    ];
  }

  List<Widget> _buttonSizeProperties(HyperSizeScheme s) {
    final metrics = _spec.buttonMetrics;
    final size = _buttonSizeVariant;
    final minimumWidth = switch (size) {
      HyperButtonSizeVariant.small => metrics.smallMinimumWidth,
      HyperButtonSizeVariant.medium => metrics.minimumWidth,
      HyperButtonSizeVariant.large => metrics.largeMinimumWidth,
    };
    final height = switch (size) {
      HyperButtonSizeVariant.small => metrics.smallHeight,
      HyperButtonSizeVariant.medium => _spec.buttonHeight,
      HyperButtonSizeVariant.large => metrics.largeHeight,
    };
    final horizontal = switch (size) {
      HyperButtonSizeVariant.small => metrics.smallPaddingHorizontal,
      HyperButtonSizeVariant.medium => metrics.paddingHorizontal,
      HyperButtonSizeVariant.large => metrics.largePaddingHorizontal,
    };
    final vertical = switch (size) {
      HyperButtonSizeVariant.small => metrics.smallPaddingVertical,
      HyperButtonSizeVariant.medium => metrics.paddingVertical,
      HyperButtonSizeVariant.large => metrics.largePaddingVertical,
    };
    final width = switch (size) {
      HyperButtonSizeVariant.small => metrics.smallWidth,
      HyperButtonSizeVariant.medium => metrics.width,
      HyperButtonSizeVariant.large => metrics.largeWidth,
    };
    void setMinimumWidth(double? value) {
      switch (size) {
        case HyperButtonSizeVariant.small:
          metrics.smallMinimumWidth = value;
        case HyperButtonSizeVariant.medium:
          metrics.minimumWidth = value;
        case HyperButtonSizeVariant.large:
          metrics.largeMinimumWidth = value;
      }
    }

    void setHeight(double? value) {
      switch (size) {
        case HyperButtonSizeVariant.small:
          metrics.smallHeight = value;
        case HyperButtonSizeVariant.medium:
          _spec.buttonHeight = value;
        case HyperButtonSizeVariant.large:
          metrics.largeHeight = value;
      }
    }

    void setHorizontal(double? value) {
      switch (size) {
        case HyperButtonSizeVariant.small:
          metrics.smallPaddingHorizontal = value;
        case HyperButtonSizeVariant.medium:
          metrics.paddingHorizontal = value;
        case HyperButtonSizeVariant.large:
          metrics.largePaddingHorizontal = value;
      }
    }

    void setVertical(double? value) {
      switch (size) {
        case HyperButtonSizeVariant.small:
          metrics.smallPaddingVertical = value;
        case HyperButtonSizeVariant.medium:
          metrics.paddingVertical = value;
        case HyperButtonSizeVariant.large:
          metrics.largePaddingVertical = value;
      }
    }

    void setWidth(double? value) {
      switch (size) {
        case HyperButtonSizeVariant.small:
          metrics.smallWidth = value;
        case HyperButtonSizeVariant.medium:
          metrics.width = value;
        case HyperButtonSizeVariant.large:
          metrics.largeWidth = value;
      }
    }

    final padding = s.button.paddingFor(size).resolve(TextDirection.ltr);
    return [
      HyperSegmentedButton<HyperButtonSizeVariant>(
        key: const ValueKey('editor-button-size'),
        expanded: true,
        segments: const [
          HyperSegment(value: HyperButtonSizeVariant.small, label: '小'),
          HyperSegment(value: HyperButtonSizeVariant.medium, label: '中'),
          HyperSegment(value: HyperButtonSizeVariant.large, label: '大'),
        ],
        selected: {size},
        onSelectionChanged: (v) =>
            _updateState(() => _buttonSizeVariant = v.single),
      ),
      const SizedBox(height: 12),
      const HyperText('以下规格按当前设备和尺寸档位保存，所有按钮外观变体共用。'),
      _number(
        '最小高度',
        height ?? s.button.heightFor(size),
        20,
        160,
        setHeight,
        () => setHeight(null),
        height != null,
      ),
      _number(
        '最小宽度',
        minimumWidth ?? s.button.minimumWidthFor(size),
        0,
        300,
        setMinimumWidth,
        () => setMinimumWidth(null),
        minimumWidth != null,
      ),
      _select(
        '宽度模式',
        width == null ? 'auto' : 'fixed',
        const {'auto': '随内容自适应', 'fixed': '固定宽度'},
        (v) => _change(
          () => setWidth(v == 'auto' ? null : s.button.minimumWidthFor(size)),
        ),
      ),
      if (width != null)
        _number('固定宽度', width, 0, 600, setWidth, () => setWidth(null), true),
      _number(
        '水平内边距',
        horizontal ?? padding.left,
        0,
        80,
        setHorizontal,
        () => setHorizontal(null),
        horizontal != null,
      ),
      _number(
        '垂直内边距',
        vertical ?? padding.top,
        0,
        80,
        setVertical,
        () => setVertical(null),
        vertical != null,
      ),
      _heading('图标'),

      _number(
        'iconSize',
        metrics.iconSize ?? s.button.iconSize,
        8,
        80,
        (v) => metrics.iconSize = v,
        () => metrics.iconSize = null,
        metrics.iconSize != null,
      ),
      _number(
        'iconSpacing',
        metrics.iconSpacing ?? s.button.iconSpacing,
        0,
        40,
        (v) => metrics.iconSpacing = v,
        () => metrics.iconSpacing = null,
        metrics.iconSpacing != null,
      ),
    ];
  }

  void _resetFieldState(EditorComponent a) {
    final v = a.textFieldStyle;
    switch (_fieldState) {
      case 'hovered':
        v.hoveredBorder = EditorBorder();
        v.hoverBorderColor = null;
      case 'focused':
        v.focusedBorder = EditorBorder();
        v.focusBorderColor = null;
        a.focusedShadow.shadows = null;
      case 'error':
        v.errorBorder = EditorBorder();
        v.errorBorderColor = v.errorIconColor = null;
        v.errorTextColor = v.errorPopupBackground = v.errorPopupBorderColor =
            null;
        v.errorWeight = null;
        v.errorPopupShadow.shadows = null;
        v.errorPlacement = v.errorIconName = null;
        _spec.textFieldMetrics
          ..errorFontSize = null
          ..errorPopupRadius = null
          ..errorPopupPadding = null
          ..errorPopupBorderWidth = null
          ..errorMaxWidth = null;
      case 'disabled':
        v.disabledBorder = EditorBorder();
        v.disabledForegroundColor = null;
    }
  }

  void _resetSelectObject() {
    final a = _appearance,
        m = _spec.selectMetrics,
        v = _mode.select.selectStyle;
    a.background = a.foreground = null;
    a.fillKind = null;
    a.gradient = null;
    a.border = EditorBorder();
    a.shadows = null;
    if (_selectSurfaceAnchor) {
      a.buttonStyle = EditorButtonVisual();
      a.hoveredShadow.shadows = a.focusedShadow.shadows =
          a.pressedShadow.shadows = a.disabledShadow.shadows = null;
      v.arrowColor = v.disabledArrowColor = null;
      v.labelFontSize = null;
      m.minimumHeight = m.minimumTapTargetSize = m.radius =
          m.paddingHorizontal = m.paddingVertical = m.width = m.arrowSize =
              m.arrowSpacing = m.chipSpacing = m.minimumInputWidth = null;
    } else {
      _mode.select.selectStyle = EditorSelectVisual()
        ..arrowColor = v.arrowColor
        ..disabledArrowColor = v.disabledArrowColor
        ..labelFontSize = v.labelFontSize;
      m.itemHeight = m.itemPadding = m.itemSpacing = m.itemRadius =
          m.surfaceRadius = m.maxPanelHeight = m.popupSpacing = null;
    }
  }

  void _resetSelectState() {
    if (_selectSurfaceAnchor) {
      _resetButtonState(_mode.selectAnchor, state: _selectState);
      if (_selectState == 'disabled') {
        _mode.select.selectStyle.disabledArrowColor = null;
      }
    } else {
      final v = _mode.select.selectStyle;
      switch (_selectState) {
        case 'selected':
          v.showCheckmark = null;
          v.checkPlacement = v.checkIcon = null;
          v.checkColor = v.selectedBackgroundColor = v.selectedForegroundColor =
              null;
          v.checkSize = v.checkSpacing = null;
        case 'active':
          v.activeBackgroundColor = null;
        case 'disabled':
          v.disabledOptionColor = null;
      }
    }
  }

  void _resetButtonState(EditorComponent a, {String? state}) {
    final v = a.buttonStyle;
    switch (state ?? _buttonState) {
      case 'hovered':
        v.hoverOpacity = null;
        v.hoveredOffsetX = v.hoveredOffsetY = v.hoveredScale = null;
        a.hoveredShadow.shadows = null;
      case 'focused':
        v.focusOpacity = null;
        v.focusedOffsetX = v.focusedOffsetY = v.focusedScale = null;
        a.focusedShadow.shadows = null;
      case 'pressed':
        v.pressOpacity = null;
        v.pressedOffsetX = v.pressedOffsetY = v.pressedScale = null;
        a.pressedShadow.shadows = null;
      case 'disabled':
        v.disabledBackground = v.disabledForeground = null;
        a.disabledShadow.shadows = null;
    }
  }

  List<Widget> _buttonProperties(
    HyperSizeScheme s,
    EditorComponent appearance,
  ) {
    final theme = _resolveTheme(_dark);
    final resolved = theme.buttonTheme.resolve(
      _buttonVariant ?? HyperButtonVariant.filled,
    );
    final visual = appearance.buttonStyle;
    Widget color(
      String name,
      EditorColor? override,
      Color inherited,
      ValueChanged<EditorColor?> changed,
    ) => _semanticColor(
      name,
      override?.resolve(theme.colors) ?? inherited,
      override?.resolve(theme.colors),
      (value) =>
          changed(value == null ? null : EditorColor(argb: value.toARGB32())),
    );
    return [
      if (_buttonState == 'common') ...[
        _heading('按钮文字'),
        _color(
          '前景',
          appearance.foreground,
          (value) => appearance.foreground = value,
        ),
      ],
      if (_buttonState == 'disabled') ...[
        _heading('禁用状态'),
        color(
          'disabledBackground',
          visual.disabledBackground,
          resolved.disabledBackground?.color ??
              theme.colors.primary.withValues(alpha: .35),
          (v) => visual.disabledBackground = v,
        ),
        color(
          'disabledForegroundColor',
          visual.disabledForeground,
          resolved.disabledForegroundColor ?? theme.colors.disabled,
          (v) => visual.disabledForeground = v,
        ),
      ],
      if (_buttonState != 'disabled') _heading('交互反馈'),
      if (_buttonState == 'common') ...[
        color(
          'overlayColor',
          visual.overlay,
          resolved.overlayColor ?? theme.colors.stateLayer,
          (v) => visual.overlay = v,
        ),
      ],
      if (_buttonState == 'hovered') ...[
        _number(
          'hoverOverlayOpacity',
          visual.hoverOpacity ??
              resolved.hoverOverlayOpacity ??
              s.button.hoverOverlayOpacity,
          0,
          1,
          (v) => visual.hoverOpacity = v,
          () => visual.hoverOpacity = null,
          visual.hoverOpacity != null,
          wholeNumbers: false,
        ),
      ],
      if (_buttonState == 'focused') ...[
        _number(
          'focusOverlayOpacity',
          visual.focusOpacity ??
              resolved.focusOverlayOpacity ??
              s.button.focusOverlayOpacity,
          0,
          1,
          (v) => visual.focusOpacity = v,
          () => visual.focusOpacity = null,
          visual.focusOpacity != null,
          wholeNumbers: false,
        ),
      ],
      if (_buttonState == 'pressed') ...[
        _number(
          'pressOverlayOpacity',
          visual.pressOpacity ??
              resolved.pressOverlayOpacity ??
              s.button.pressOverlayOpacity,
          0,
          1,
          (v) => visual.pressOpacity = v,
          () => visual.pressOpacity = null,
          visual.pressOpacity != null,
          wholeNumbers: false,
        ),
      ],
      if (_buttonState == 'common') ...[
        _heading('加载进度'),
        if (_buttonVariant == null)
          _number(
            'progressSize',
            _spec.buttonMetrics.progressSize ?? s.button.progressSize,
            8,
            80,
            (v) => _spec.buttonMetrics.progressSize = v,
            () => _spec.buttonMetrics.progressSize = null,
            _spec.buttonMetrics.progressSize != null,
          ),
        color(
          'progressColor',
          visual.progressColor,
          resolved.progressColor ??
              resolved.foregroundColor ??
              theme.colors.onPrimary,
          (v) => visual.progressColor = v,
        ),
        color(
          'progressTrackColor',
          visual.progressTrackColor,
          resolved.progressTrackColor ??
              (resolved.foregroundColor ?? theme.colors.onPrimary).withValues(
                alpha: .24,
              ),
          (v) => visual.progressTrackColor = v,
        ),
        _number(
          'progressThickness',
          visual.progressThickness ?? resolved.progressThickness ?? 2,
          1,
          10,
          (v) => visual.progressThickness = v,
          () => visual.progressThickness = null,
          visual.progressThickness != null,
          wholeNumbers: true,
        ),
      ],
      if (['hovered', 'focused', 'pressed'].contains(_buttonState)) ...[
        _heading('交互变换'),
        const HyperText('默认不启用；水平正值向右，垂直正值向下；缩放 1 为原尺寸。变换不改变布局与命中区域，减少动画时不启用。'),
      ],
      if (_buttonState == 'hovered') ...[
        _heading('悬停变换'),
        _number(
          '悬停水平位移',
          visual.hoveredOffsetX ?? 0,
          -20,
          20,
          (v) => visual.hoveredOffsetX = v,
          () => visual.hoveredOffsetX = null,
          visual.hoveredOffsetX != null,
        ),
        _number(
          '悬停垂直位移',
          visual.hoveredOffsetY ?? 0,
          -20,
          20,
          (v) => visual.hoveredOffsetY = v,
          () => visual.hoveredOffsetY = null,
          visual.hoveredOffsetY != null,
        ),
        _number(
          '悬停缩放',
          visual.hoveredScale ?? 1,
          .5,
          1.5,
          (v) => visual.hoveredScale = v,
          () => visual.hoveredScale = null,
          visual.hoveredScale != null,
          wholeNumbers: false,
        ),
      ],
      if (_buttonState == 'focused') ...[
        _heading('聚焦变换'),
        _number(
          '聚焦水平位移',
          visual.focusedOffsetX ?? 0,
          -20,
          20,
          (v) => visual.focusedOffsetX = v,
          () => visual.focusedOffsetX = null,
          visual.focusedOffsetX != null,
        ),
        _number(
          '聚焦垂直位移',
          visual.focusedOffsetY ?? 0,
          -20,
          20,
          (v) => visual.focusedOffsetY = v,
          () => visual.focusedOffsetY = null,
          visual.focusedOffsetY != null,
        ),
        _number(
          '聚焦缩放',
          visual.focusedScale ?? 1,
          .5,
          1.5,
          (v) => visual.focusedScale = v,
          () => visual.focusedScale = null,
          visual.focusedScale != null,
          wholeNumbers: false,
        ),
      ],
      if (_buttonState == 'pressed') ...[
        _heading('按下变换'),
        _number(
          '按下水平位移',
          visual.pressedOffsetX ?? 0,
          -20,
          20,
          (v) => visual.pressedOffsetX = v,
          () => visual.pressedOffsetX = null,
          visual.pressedOffsetX != null,
        ),
        _number(
          '按下垂直位移',
          visual.pressedOffsetY ?? 0,
          -20,
          20,
          (v) => visual.pressedOffsetY = v,
          () => visual.pressedOffsetY = null,
          visual.pressedOffsetY != null,
        ),
        _number(
          '按下缩放',
          visual.pressedScale ?? 1,
          .5,
          1.5,
          (v) => visual.pressedScale = v,
          () => visual.pressedScale = null,
          visual.pressedScale != null,
          wholeNumbers: false,
        ),
      ],
      if (_buttonState == 'common') ...[
        _heading('状态过渡'),
        _number(
          'animationDuration（毫秒）',
          visual.animationMilliseconds ??
              resolved.animationDuration?.inMilliseconds.toDouble() ??
              theme.motion.fastDuration.inMilliseconds.toDouble(),
          0,
          2000,
          (v) => visual.animationMilliseconds = v,
          () => visual.animationMilliseconds = null,
          visual.animationMilliseconds != null,
          wholeNumbers: true,
        ),
      ],
    ];
  }

  List<Widget> _focusedShadowProperties(
    EditorComponent a, {
    EditorComponentShadow? stateTarget,
    String label = '聚焦阴影 / 焦点环',
    String? description,
    double? maxExtent,
  }) {
    final target = stateTarget ?? a.focusedShadow;
    return [
      _heading(label),
      HyperText(
        description ??
            (stateTarget == null
                ? '仅获得焦点时显示；零偏移、零模糊和正扩散可绘制焦点环。该配置替换聚焦时的普通阴影。'
                : '仅在当前状态显示；未覆盖时继承普通阴影，空列表关闭当前状态阴影。'),
      ),
      Wrap(
        spacing: 8,
        children: [
          HyperButton.ghost(
            onPressed: () => _change(() => target.shadows = null),
            child: const Text('继承普通阴影'),
          ),
          HyperButton.ghost(
            onPressed: () => _change(() => target.shadows = []),
            child: const Text('关闭阴影'),
          ),
          HyperButton.tonal(
            onPressed: () => _change(
              () => target.shadows = [
                ...?target.shadows,
                EditorShadow(opacity: .5, dx: 0, dy: 0, blur: 0, spread: 3),
              ],
            ),
            child: Text(stateTarget == null ? '添加焦点环' : '添加阴影'),
          ),
        ],
      ),
      for (var i = 0; i < (target.shadows?.length ?? 0); i++)
        _shadow(i, shadowTarget: target, maxExtent: maxExtent),
    ];
  }

  Widget _shadow(
    int index, {
    EditorComponent? target,
    EditorComponentShadow? shadowTarget,
    double? maxExtent,
  }) {
    final appearance = target ?? _appearance;
    final shadows = shadowTarget == null
        ? appearance.shadows!
        : shadowTarget.shadows!;
    final s = shadows[index];
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: HyperText('第 ${index + 1} 层')),
            HyperIconButton.ghost(
              tooltip: '删除阴影',
              onPressed: () => _change(() {
                final next = [...shadows]..removeAt(index);
                if (shadowTarget == null) {
                  appearance.shadows = next;
                } else {
                  shadowTarget.shadows = next;
                }
              }),
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
        _number(
          '水平偏移',
          s.dx,
          -(maxExtent == null ? 40.0 : (maxExtent / 2).floorToDouble()),
          maxExtent == null ? 40.0 : (maxExtent / 2).floorToDouble(),
          (v) => s.dx = v,
          () => s.dx = 0,
          true,
        ),
        _number(
          '垂直偏移',
          s.dy,
          -(maxExtent == null ? 40.0 : (maxExtent / 2).floorToDouble()),
          maxExtent == null ? 40.0 : (maxExtent / 2).floorToDouble(),
          (v) => s.dy = v,
          () => s.dy = 4,
          true,
        ),
        _number(
          '模糊',
          s.blur,
          0,
          maxExtent ?? 80,
          (v) => s.blur = v,
          () => s.blur = 16,
          true,
        ),
        _number(
          '扩散',
          s.spread,
          -(maxExtent == null ? 20.0 : (maxExtent / 2).floorToDouble()),
          maxExtent == null ? 40.0 : (maxExtent / 2).floorToDouble(),
          (v) => s.spread = v,
          () => s.spread = 0,
          true,
        ),
      ],
    );
  }

  Widget _preview() {
    final theme = _resolveTheme(_dark);
    return Column(
      children: [
        Obx(
          () => EditorComponentNavigation(
            page: _page,
            onSelected: (value) => rxBatch(() {
              _page = value;
              _component =
                  _pages.entries
                      .where((entry) => entry.value == value)
                      .firstOrNull
                      ?.key ??
                  value;
              if (value == 'hyper-dropdown' ||
                  value == 'hyper-date-time-picker') {
                _component = 'select';
              }
              if (value == 'hyper-notification-center') {
                _component = 'notificationReview';
              }
              if (value == 'hyper-text-area') _component = 'field';
              _reviewObject = '';
              _reviewState = 'common';
              _reviewPart = 'group';
              _reviewVariant = 'common';
              _inputObject = 'standard';
              _inputState = 'default';
              _iconInputVariant = 'common';
              if (value == 'hyper-scrolling-text') _component = 'text';
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
              final size = editorPreviewSize(_device, landscape: _landscape);
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
