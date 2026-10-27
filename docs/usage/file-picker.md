# 文件选择与上传界面

上传状态通过 uploadState(file) 返回 HyperFileUploadState，支持 waiting、uploading、
success、failed、canceled。progress 为 0–1 或 null（不确定进度），errorText 显示失败原因。
onRetry / onCancel 只发出业务操作通知，不修改任务、不取消网络请求；移除文件也由调用方
在 onChanged 中清理上传任务。状态与文件值分开，不会因进度变化将 Form 标记为已修改。
thumbnailBuilder 可提供受控预览；Demo 对已知大小不超过 10 MB 的图片使用第三方文件句柄
读取缩略图，其余显示普通文件图标。读取失败或图片解码失败回退图标。
Form 字段同样透传状态、重试、取消和缩略图接口。
Demo 的进度及失败重试完全本地模拟，不发送文件。

`HyperFilePicker` 提供 dropzone / simple 两种外观，主包已内置系统选择与拖放适配。
不传 `pick` 或 `dropBuilder` 即可使用；显式回调仍优先，`enableDrop: false` 可关闭拖入。
实现复用 file_picker 13.1.0、desktop_drop 0.7.1 与 cross_file，不自建系统文件窗口或拖放引擎。
desktop_drop 0.8.4 的 dbus 约束与 file_picker Linux 依赖冲突，因此保留兼容版本，
不使用 dependency_overrides。上传请求仍由业务负责。

```dart
HyperFilePicker(
  files: attachments,
  onChanged: (value) => setState(() => attachments = value),
  allowedExtensions: const ['png', 'jpg'],
  maxFiles: 3,
)
```

独立文件窗口使用 `HyperFileDialog.pickFiles`；`multiple: false` 打开单选窗口，
取消时返回空列表。`HyperFileDialog.saveFile` 保存传入字节，Web 上由浏览器下载。
主题编辑器的 JSON 导入、导出也使用这组主包接口。

HyperFileSelection 保存 name、size 和原始 source 句柄；不预读整份文件字节。
需要内容时调用 `readAsBytes()`；自定义非平台句柄仍可通过 `source` 自行处理。
allowedExtensions、maxFileSize、maxFiles 在选择和拖放入口执行相同检查；
开启大小限制时拒绝未知大小的文件。multiple=false 用新文件替换，取消选择保持原值。
trailingBuilder 可展示调用方控制的进度、成功、失败和重试操作，实际上传由业务完成。
元数据限制不替代服务端文件校验。

HyperFileFormField 同样默认使用系统选择与拖放，使用不可变 List 值，支持必填/异步校验、禁用和重置。
界面复用 Card、Button、IconButton、文字与 Form 间距的现有四端主题（来源 D，待确认），
表面可用 style / pickerStyle 覆盖。新增入口位于“选择控件 → 文件选择 Upload”。
原生文件选择及系统拖入需在各目标平台实际运行验证；测试使用平台接口替身及拖放通道事件，
覆盖默认入口、显式回调优先级、单选/多选、过滤、取消、表单校验与预览 DPR。
