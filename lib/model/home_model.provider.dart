import 'dart:io';

import 'package:flutter/foundation.dart';

class ImagePickerProvider with ChangeNotifier {
  File? _imgFile;
  bool _isCompressing = false;

  // ? getter
  File? get file => _imgFile;
  bool get isCompressing => _isCompressing;

  // ? setter
  void setFile(File file) {
    _imgFile = file;
    notifyListeners();
  }

  void changeCompressingValue() {
    _isCompressing = !_isCompressing;
    notifyListeners();
  }
}
