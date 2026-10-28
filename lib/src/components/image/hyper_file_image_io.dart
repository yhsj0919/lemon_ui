import 'dart:io';

import 'package:flutter/painting.dart';

ImageProvider hyperFileImage(String path, {double scale = 1}) =>
    FileImage(File(path), scale: scale);
