import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqlManager {
  /**
   * 数据库操作管理类
   */

  static const _VERSION = 1;
  static const _NAME = 'app.db';
  static Database _database;

  //init database
  static init() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, _NAME);
    _database = await openDatabase(path,
        version: _VERSION, onCreate: (Database db, int version) async {});
  }

  //判断表是否存在
  static isTableExisted(String tableName) async {
    await getCurrentDatabase();
    var res = await _database.rawQuery(
        "select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res != null && res.length > 0;
  }

  //获取当前数据库对象
  static Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      debugPrint('db is null');
      await init();
    }
    return _database;
  }

  //关闭数据库
  static close() {
    _database?.close();
    _database = null;
  }
}
