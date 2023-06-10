import 'package:flutter_day2_iti3/constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  //1- single instance from Dbhelper (singletone)
  DbHelper._(); //private named constructor
  static final DbHelper helper = DbHelper._();

  //2-find db path
  Future<String> _getDbPath() async {
    String dir = await getDatabasesPath();
    String noteDbPath = join(dir, dbName);
    return noteDbPath;
  }

  //3-create note Db
  Future<Database> useDb() async {
    String path = await _getDbPath();
    Database db = await openDatabase(path,
        version: version,
        onCreate: (db, version) => _onCreateTable(db),
        onUpgrade: (db, oldVersion, newVersion) => _onUpgradeTable(db),
        onDowngrade: (db, oldVersion, newVersion) => _onDowngradeTable(db),
        singleInstance: true);
    return db;
  }

  //3-a
  void _onCreateTable(Database db) {
    String sql =
        'create table $tableName($colId integer primary key autoincrement, $colTitle text, $colText text, $colDate text, $colColor integer)';
    try {
      print(sql);
      db.execute(sql);
    } on DatabaseException catch (e) {
      print(e.toString());
    }
  }

  //3-b
  void _onUpgradeTable(Database db) {
    String sql = 'drop table $tableName';
    try {
      db.execute(sql);
      _onCreateTable(db);
    } on DatabaseException catch (e) {
      print(e.toString());
    }
  }

  //3-c
  void _onDowngradeTable(Database db) {}
}
