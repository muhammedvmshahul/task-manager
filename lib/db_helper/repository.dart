import 'package:sqflite/sqflite.dart';
import 'package:todo_app/db_helper/dataBase_connection.dart';

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
      return _database;
    }
  }

  // Insert data
  Future<int?> insertData(String table, Map<String, dynamic> data) async {
    var connection = await database;
    return await connection?.insert(table, data);
  }

  // Read data
  Future<List<Map<String, dynamic>>?> readData(String table) async {
    var connection = await database;
    return await connection?.query(table);
  }

  // Read data by ID
  Future<Map<String, dynamic>?> readDataById(String table, int itemId) async {
    var connection = await database;
    List<Map<String, dynamic>> result = await connection?.query(
      table,
      where: 'id = ?',
      whereArgs: [itemId],
    ) ?? [];
    return result.isNotEmpty ? result.first : null;
  }

  // Update data
  Future<int?> updateData(
      String table, Map<String, dynamic> data, int itemId) async {
    var connection = await database;
    return await connection?.update(table, data, where: 'id = ?', whereArgs: [itemId]);
  }

  // Delete data by ID
  Future<int?> deleteDataById(String table, int itemId) async {
    var connection = await database;
    return await connection?.delete(table, where: 'id = ?', whereArgs: [itemId]);
  }




}
