import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

// import '../model/task.dart';

class DatabaseConnection
{
  Future<Database> setDatabase()async
  {
    var directory = await getApplicationCacheDirectory();
    var path = join(directory.path, 'db_crud');
    var database = await openDatabase(path, version: 1, onCreate: _createDatabase);

    return database;
  }
  Future<void> _createDatabase(Database database,int version) async{
    String sql =
        'CREATE TABLE tasks (id INTEGER PRIMARY KEY, name TEXT, description TEXT,date TEXT); ';
        await database.execute(sql);
  }



}

