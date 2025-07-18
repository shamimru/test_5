import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:test_5/Model/Person.dart';

class DBHelper{
  static Future<Database> initDB() async{
    var dbPath= await getDatabasesPath();
    String path= join(dbPath, "person.db");
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future _onCreate (Database db, int version) async{
     final sql= ''' create table persons(id integer primary key AUTOINCREMENT, name text, contact text) ''';
      await db.execute(sql);
  }

  static Future onDelete(int id) async {

    Database db= await initDB();
    try{
      await db.delete("persons", where: "id=?", whereArgs: [id]);
      DBHelper.readContact();

    }catch(ex){
      debugPrint(ex.hashCode.toString());
    }

  }

static Future<int> createPerson(Person person) async{
    Database db= await initDB();
    return await db.insert("persons", person.toJson());
}

  static Future<List<Person>> readContact() async{
    Database db= await initDB();
    var person= await db.query("persons", orderBy: "name");
    List<Person> personsList = person.isNotEmpty? person.map((toElement) =>
    Person.fromJson(toElement)).toList():
        [];
    return personsList;
  }


}
