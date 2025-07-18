import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'DBHelper.dart';
import 'Model/Person.dart';

class Showpersondata extends StatefulWidget {
  const Showpersondata({super.key});

  @override
  State<Showpersondata> createState() => _ShowpersondataState();
}

class _ShowpersondataState extends State<Showpersondata> {
  var dbHelper = DBHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Person Data"), backgroundColor: Colors.green),

      body: FutureBuilder<List<Person>>(
        future: DBHelper.readContact(),
        builder: (BuildContext context, AsyncSnapshot<List<Person>> snapshot) {
          if (!snapshot.hasData) {
            return Column(
              children: [
                Center(child: CircularProgressIndicator()),
                SizedBox(height: 20),

                Text("Loading...."),
              ],
            );
          }
          List<Person> people = snapshot.data!;
          return ListView.builder(
            itemCount: people.length,
            itemBuilder: (context, index) {
              final person = people[index];
              return ListTile(
                leading: CircleAvatar( child:  Text(
                  (person.name != null && person.name!.isNotEmpty)
                      ? person.name![0].toUpperCase()
                      : '?',
                ),),
                title: Text(person.name ?? "No name"),
                subtitle: Text(person.contact ?? "No contact"),
                trailing: IconButton(onPressed: (){
                  DBHelper.onDelete(person.id!.toInt());

                  setState(() {

                  });
                }, icon: Icon(Icons.delete)),
              );
            },
          );
        },
      ),
    );
  }
}
