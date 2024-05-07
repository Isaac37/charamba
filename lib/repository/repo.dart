import 'package:sqflite/sqflite.dart';

import '../db_helper/db_conn.dart';

class Repository {
  late DatabaseConnection _databaseConnection;
  Repository() {
    _databaseConnection = DatabaseConnection();
  }
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await _databaseConnection.setDatabase();
    }
    return _database;
  }

//insert user
  insertData(table, data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  //read all users
  readData(table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  //read user by id
  readDataById(table, userId) async {
    var connection = await database;
    return await connection?.query(table, where: 'id=?', whereArgs: [userId]);
  }

  //update user
  updateData(table, data) async {
    var connection = await database;
    return await connection
        ?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

  //delete user
  deleteDataById(table, userId) async {
    var connection = await database;
    return await connection?.rawDelete("delete from $table where id=$userId");
  }
}
