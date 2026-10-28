import 'package:flutter/painting.dart';

ImageProvider hyperFileImage(String path, {double scale = 1}) =>
    throw UnsupportedError(
      'HyperImage.file requires dart:io. On Web use HyperImage.memory with selected file bytes.',
    );
