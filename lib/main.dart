import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SQFlite demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final dbHelper = DataBaseHelper.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('sqflite'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              child: Text(
                'insert',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed:() {_insert();},
            ),
            RaisedButton(
              child: Text(
                'query',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed:() {_query();},
            ),
            RaisedButton(
              child: Text(
                'update',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed:() {_update();},
            ),
            RaisedButton(
              child: Text(
                'delete',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed:() {_delete();},
            )
          ],
        ),
      ),
    );
  }

  void _insert() async{
    //row to insert
    Map<String, dynamic> row = {
      DataBaseHelper.columnName: 'Bob',
      DataBaseHelper.columnAge: 23
    }; 

    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  void _query() async{
    final allRows = await dbHelper.queryAllRows();
    print('query all rows: ');
    allRows.forEach((row) => print(row));
  }

  void _update() async{
    //row to update
    Map<String, dynamic> row = {
      DataBaseHelper.columnId: 1,
      DataBaseHelper.columnName: 'Mary',
      DataBaseHelper.columnAge: 32
    };

    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
  }

  void _delete() async{
    //assuming that the number of rows is the id for the last row
    final id = await dbHelper.queryRowCount();
    final rowsDeleted = await dbHelper.delete(id);
    print('deleted $rowsDeleted row(s): row $id');
  }
}
