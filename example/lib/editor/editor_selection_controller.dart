import 'package:lemon_x/lemon_x.dart';

/// 编辑器页面与精调对象的选择状态，由工作区创建并销毁。
class EditorSelectionController {
  final page = Rx<String>('hyper-button');
  final component = Rx<String>('button');

  void dispose() {
    page.dispose();
    component.dispose();
  }
}
