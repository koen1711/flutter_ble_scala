import 'package:sqflite/sqflite.dart';

class SQLHandler {



  Future<Database> openDB(String name, int version, String onCreate) async {
      var databasesPath = await getDatabasesPath();
    return await openDatabase(
      '$databasesPath/$name',
      version: version,
      onCreate: (Database db, int version) async {
        if (onCreate != '') {
          await db.execute(onCreate);
        }
        
      },
    );
  }



  Future<void> insert(Database db, String table, Map<String, dynamic> row) async {
    await db.insert(
      table,
      row,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> execute(Database db, String sql) async {
    await db.execute(sql);
  }

  Future<List<Map<String, dynamic>>> query(Database db, String table, String where) async {
    return await db.query(table, where: where);
  }

  Future<void> update(Database db, String table, Map<String, dynamic> row, String where) async {
    await db.update(
      table,
      row,
      where: where,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> delete(Database db, String table, String where) async {
    await db.delete(
      table,
      where: where,
    );
  }

  Future<void> closeDB(Database db) async {
    await db.close();
  }
}