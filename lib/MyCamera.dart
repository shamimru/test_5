import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Mycamera extends StatefulWidget {
  const Mycamera({super.key});

  @override
  State<Mycamera> createState() => _MycameraState();
}

class _MycameraState extends State<Mycamera> {

// var sourceOfImage=ImageSource.values;
  File? _image ;
  final _picker = ImagePicker();

  picImage() async {

    final picedFile= await _picker.pickImage(source: ImageSource.camera);

    if(picedFile != null){
      _image=File(picedFile.path);
      setState(() {

      });
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Camera"),
      ),

      body:  Column(
        children: [
          Text("Camera"),

          _image==null? Text("No image"):Image.file(_image!),
          FloatingActionButton(onPressed: (){
            picImage();
          },child: Icon(Icons.camera_alt),)

        ],
      ),
    );
  }
}