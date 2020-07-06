import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqlite_api.dart';

import '../bean/history.dart';
import 'base_provider.dart';

class SearchHistoryProvider extends BaseDbProvider {
  //表名
  final String name = 'SearchHistory';

  final String columnId = 'id';
  final String columnName = 'name';

  SearchHistoryProvider();

  @override
  createTableString() => '''
  create table $name (
        $columnId integer primary key autoincrement,
        $columnName text not null
        )
  ''';

  @override
  tableName() => name;

  //根据ID查询数据
  Future<SearchHistory> getData(int id) async {
    var mapList = await selectData(id);
    if (mapList.length > 0) {
      return SearchHistory.fromMapObject(mapList.first);
    }
    return null;
  }

  //查询数据
  Future selectData(int id) async {
    Database db = await getDataBase();
    return await db.rawQuery('select * from $name where $columnId =$id');
  }

  //获取数据库所有记录
  Future<List<SearchHistory>> getAllData() async {
    List<SearchHistory> historyList = List<SearchHistory>();
    var mapList = await selectMapList();
    mapList.forEach((it) {
      print('it=====>$it');
      historyList.add(SearchHistory.fromMapObject(it));
    });
    return historyList;
  }

  //查询数据库所有记录
  Future<List<Map<String, dynamic>>> selectMapList() async {
    Database db = await getDataBase();
    return await db.query(name);
  }

  //增加数据
  Future<int> saveData(SearchHistory history) async {
    Database db = await getDataBase();
    List<Map> hasList =
        await db.query(name, where: "$columnName=?", whereArgs: [history.name]);
    // debugPrint('hasList===>$hasList');
    var result;
    if (hasList.length > 0) {
      result = update(history);
    } else {
      result = await db.insert(name, history.toMap());
    }
    print('result======>>>$result');
    return result;
  }

  //更新数据
  Future<int> update(SearchHistory history) async {
    Database db = await getDataBase();
    return await db.update(name, history.toMap(),
        where: "$columnId=?", whereArgs: [history.id]);
  }

  //删除数据
  Future<int> deleteData(String val) async {
    Database db = await getDataBase();
    return await db.delete(name, where: '$columnName=?', whereArgs: [val]);
  }

  //该方法证明效率高
  void deleteAllData() async {
    Database db = await getDataBase();
    var batch = db.batch();
    List<SearchHistory> histories = await getAllData();
    histories.forEach((it) {
      batch.rawDelete("DELETE FROM $name WHERE $columnId =${it.id}");
    });
    batch.commit();
  }
}
