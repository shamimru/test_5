import 'package:flutter/material.dart';
import 'package:flutter_hidden_camera_android/flutter_hidden_camera_android.dart';


class Hiddencamera extends StatefulWidget {
  const Hiddencamera({super.key});

  @override
  State<Hiddencamera> createState() => _HiddencameraState();
}

class _HiddencameraState extends State<Hiddencamera> {
  String? path;
  
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FlutterHiddenCameraAndroid.events.listen((event){
      if(event is ImageEvent){
        setState(() {
          path=event.file.path;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Text("data");
  }
}
