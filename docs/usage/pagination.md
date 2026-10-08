# 分页

`HyperPagination` 是受控页码导航，不持有数据或请求状态。页码从 1 开始；pageCount 为 0 时 currentPage 必须为 0。输入越界或数量为负数会抛出异常，页面应在数据变化后同步修正当前页。

~~~dart
HyperPagination(
  pageCount: 20,
  currentPage: 1,
  showBoundaryButtons: true,
  onPageChanged: (page) {},
)
~~~

页面收到 onPageChanged 后更新 currentPage 并请求数据。首尾页禁用对应导航；当前页保留选中样式但不再次发出请求。enabled 为 false 或未提供回调时所有按钮禁用。

## 页码和简洁模式

siblingCount 默认 1，控制当前页附近的页码窗口；靠近首尾时窗口会平移。boundaryCount 默认 1，控制两端保留的页码。缺口只有一页时直接显示该页，大缺口绘制不可交互省略号。算法与数据加载分离，也可通过 HyperPaginationModel 直接获得页码列表，null 表示省略号。

~~~dart
HyperPagination(
  pageCount: 1000,
  currentPage: 500,
  siblingCount: 2,
  onPageChanged: (page) {},
)
~~~

showPageNumbers 为 false 时显示计数与前后导航。counterBuilder 可替换计数内容；pageLabelBuilder 可修改数字文字格式。

~~~dart
HyperPagination(
  pageCount: 8,
  currentPage: 3,
  showPageNumbers: false,
  counterBuilder: (context, page, total) => Text('第 $page / $total 页'),
  onPageChanged: (page) {},
)
~~~

## 主题与布局

全局 paginationTheme、局部 HyperPaginationTheme 和实例 style 依次覆盖。buttonStyle 管理全部按钮；selectedStyle 覆盖当前页；navigationStyle 覆盖前后及首尾导航。背景、材质、边框、圆角、文字、尺寸、图标和交互状态复用 HyperButtonStyle，不重复一套按钮字段。

HyperButtonStyle 逐字段覆盖，其中 textStyle 字段整体替换；仅修改文字颜色时，可从当前语义文字样式 copyWith。ellipsisStyle 的 TextStyle 按字段合并。

~~~dart
HyperPaginationTheme(
  data: HyperPaginationThemeData(
    style: HyperPaginationStyle(
      selectedStyle: HyperButtonStyle(
        background: const HyperFill.color(Colors.blue),
        disabledBackground: const HyperFill.color(Colors.blue),
        foregroundColor: Colors.white,
        disabledForegroundColor: Colors.white,
      ),
      buttonStyle: HyperButtonStyle(borderRadius: BorderRadius.circular(8)),
      ellipsis: '…',
      previousLabel: 'Previous',
      nextLabel: 'Next',
    ),
  ),
  child: HyperPagination(pageCount: 20, currentPage: 3, onPageChanged: (page) {}),
)
~~~

当前页不提供切页动作，因而使用按钮的 disabledBackground / disabledForegroundColor；修改其选中颜色时也应覆盖这两个字段。

默认 Wrap 在可用宽度不足时换行，间距与换行间距可配置。它不会因为窗口宽度改变设备类别。RTL 下行顺序遵循 Directionality，导航图标自动镜像；自定义导航 IconData 应提供 LTR 形状。

按钮、焦点、键盘操作和状态动画复用 HyperButton；导航提示复用 HyperTooltip。材质通过统一 HyperMaterialTheme 配置，局部按钮材质可显式覆盖。主题动画默认来自 Motion，遵守减少动画设置。

四端规格集中在 sizes.pagination。默认视觉为同端既有按钮和语义尺寸的 D 级推导，未运行设备、Widget 或截图对照。

- [Demo](../../example/lib/pages/framework/hyper_pagination_page.dart)
- [尺寸来源](../size-specification.md)
