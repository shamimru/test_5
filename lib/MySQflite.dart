import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart'; // ✅ Import this for join()

void saveDataToSQlite(String name, String email) async{
  // var db= await openDatabase("my_db.db");

  var databasePath= await getDatabasesPath();
  String path= join(databasePath, "my_db.db");

  Database database = await openDatabase(path, version: 1, onCreate: (Database db, int version) async{
    await db.execute("create table test ( id integer primary key AUTOINCREMENT, name text, email text) ");
  });

  await database.transaction((txn) async{
    int id1= await txn.rawInsert(
      "insert into test ( name,email) values (?,?)",
      [name, email],
    );

    print("inserted: ${id1}");
  });


  // await deleteDatabase(path);

  database.close();
}