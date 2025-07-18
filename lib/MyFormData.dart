import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';


import 'FireBaseService.dart';
import 'Model/Person.dart';


class MyFormdata extends StatefulWidget {
  const MyFormdata({super.key});

  @override
  State<MyFormdata> createState() => _MyFormdataState();
}

class _MyFormdataState extends State<MyFormdata> {
  var firebaseService = FireBaseService();

  TextEditingController _name= TextEditingController();
  TextEditingController _contact= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,

        title: Text("Form"),
      ),

      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            _MyFormData(_name, "Name"),
            SizedBox(height: 20,),
            _MyFormData(_contact, "Contact"),
            SizedBox(height: 20,),

            ElevatedButton(onPressed: (){

              //firebase test
              firebaseService.create(path: "data1", data: {"name":_name.text, "contact":_contact.text});
              // DBHelper.createPerson(Person(
              //   name: _name.text,
              //    contact: _contact.text
              // ));
              Get.toNamed("/firedata");
            }, child: Text("Save"),
            ),
          ],
        ),
      )
    );
  }

  TextField _MyFormData(TextEditingController _controller, String hint ){
    return TextField(

      controller: _controller,
      decoration: InputDecoration(
        labelText: hint,
        hintText: hint,

        border: OutlineInputBorder()
      ),
    );

  }
}
