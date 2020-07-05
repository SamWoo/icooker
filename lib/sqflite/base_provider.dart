import 'sql_manager.dart';
import 'package:sqflite/sqflite.dart';
import 'package:meta/meta.dart';

abstract class BaseDbProvider {
  bool isTableExisted = false;
  createTableString();
  tableName();

  //创建table的sql语句
  tableBaseString(String sql) => sql;

  Future<Database> getDataBase() async => await open();

  @mustCallSuper
  prepare(name, String createSql) async {
    isTableExisted = await SqlManager.isTableExisted(name);
    if (!isTableExisted) {
      Database db = await SqlManager.getCurrentDatabase();
      return await db.execute(createSql);
    }
  }

  @mustCallSuper
  open() async {
    if (!isTableExisted) await prepare(tableName(), createTableString());
    return await SqlManager.getCurrentDatabase();
  }
}
