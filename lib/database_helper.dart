import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DataBaseHelper{
  static final _databaseName = 'MyDatabase.db';
  static final _databaseVersion = 1;

  static final table = 'my_table';

  static final columnId = '_id';
  static final columnName = 'name';
  static final columnAge = 'age';

  //Make this a singleton class
  DataBaseHelper._privateConstructor();
  static final DataBaseHelper instance = DataBaseHelper._privateConstructor();

  //only have a single app-wide reference to the database
  static Database _database;
  Future<Database> get database async{
    if(_database != null) return _database;
    //lazily instantiate the db the first time it is accesed
    _database = await _initDatabase();
    return _database;
  }

  //this opens the database (and creates it if it doesn't exists)
  _initDatabase() async{
    Directory documentsDirecotory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirecotory.path, _databaseName);

    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate);
  }

  //SQL code to create the table
  Future _onCreate(Database db, int version) async{
    await db.execute('''
    CREATE TABLE $table (
      $columnId INTEGER PRIMARY KEY,
      $columnName TEXT NOT NULL,
      $columnAge INTEGER NOT NULL
    )
    ''');
  }

  /// Helper Methods

  /// 

  /// Insert a row in the database where eache key in the Map is a column name

  /// and the value is the column name value. The return value is the id of the

  /// inserted row


  Future<int> insert(Map<String, dynamic> row) async{
    Database db = await instance.database;
    return await db.insert(table, row);
  }

  //All of the rows as returned as a list of Maps, where each map is
  //a key-value list of columns
  Future<List<Map<String, dynamic>>> queryAllRows() async{
    Database db = await instance.database;
    return await db.query(table);
  }

  //All the methods (insert, update, create, delete) can also be done using
  //raw SQL commands. This methos uses a raw query to give the row count.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  //We are assuming here that the id column in the map is set. The other 
  //Column values will be used to update the row
  Future<int> update(Map<String, dynamic> row) async{
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  //Deleted the row specified by the id, The number of affected rows is
  //returned. This should be 1 as long as the row exists
  Future<int> delete(int id) async{
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}