import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:gallery_saver/gallery_saver.dart';

class Utils {
  static getFileSize(int bytes, int decimals) {
    try {
      if (bytes <= 0) return "0 B";
      const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
      var i = (log(bytes) / log(1024)).floor();
      return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) +
          ' ' +
          suffixes[i];
    } catch (e) {
      return "0 KB";
    }
  }

  // 1. compress file and get Uint8List
  static Future<Uint8List> testCompressFile(
      File file, int height, int width, int quality) async {
    var result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: width,
      minHeight: height,
      quality: quality,
    );
    print(getFileSize(file.lengthSync(), 1));
    print(getFileSize(result!.length, 1));
    return result;
  }

  static Future<String> externaleStorage() async {
    var storage = await getTemporaryDirectory();

    return storage.path;
  }

  static Future saveFile(Uint8List file) async {
    try {
      var path = await externaleStorage();
      DateTime now = DateTime.now();
      File _file = File(
          "$path/Rx${now.day}${now.millisecond}${now.month}${now.microsecond}.jpeg");
      _file.writeAsBytesSync(file);
      bool? done = await GallerySaver.saveImage(_file.path);
      return done;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
