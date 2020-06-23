import 'dart:io';

import 'package:path_provider/path_provider.dart';

class Utils {
  static Utils _instance;

  static Utils getInstance() {
    if (null == _instance) _instance = Utils();
    return _instance;
  }

  ///获取缓存Size
  Future<String> loadCache() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      double _value = await _getTotalSizeOfFiles(tempDir);
      tempDir.list(followLinks: false, recursive: true).listen((file) {
        //打印每个缓存文件的路径
        print(file.path);
      });
      print('临时目录大小: ${_value.toString()}');
      return _formatSize(_value);
    } catch (e) {
      print(e);
    }
    return '0';
  }

  ///递归计算TemporaryDirectory目录中文件Size
  Future<double> _getTotalSizeOfFiles(final FileSystemEntity file) async {
    try {
      if (file is File) {
        print('file===>$file');
        int _length = await file.length();
        return double.parse(_length.toString());
      } else if (file is Directory) {
        final List<FileSystemEntity> _files = file.listSync();
        double _total = 0;
        if (_files != null) {
          for (final FileSystemEntity f in _files)
            _total += await _getTotalSizeOfFiles(f);
//          _files.forEach((f) async {
//            _total += await _getTotalSizeOfFiles(f);
//            print('_total:$_total');
//          });
        }
        print('all_total:$_total');
        return _total;
      }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  ///格式化缓存文件大小
  _formatSize(double value) {
    if (value == null) return 0;
    List<String> unitArr = List()..add('B')..add('KB')..add('M')..add('G');
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2); //保留两位小数
    return size + unitArr[index];
  }

  ///清除缓存
  void clearCache() async {
    Directory tempDir = await getTemporaryDirectory();
    await delDir(tempDir);
  }

  ///递归方式删除目录及文件
  Future<Null> delDir(FileSystemEntity file) async {
    try {
      if (file is Directory) {
        final List<FileSystemEntity> _files = file.listSync();
        for (final FileSystemEntity f in _files) await delDir(f);
//        _files.forEach((f) async {
//          await delDir(f);
//        });
      }
      await file.delete();
    } catch (e) {
      print(e);
    }
  }
}
