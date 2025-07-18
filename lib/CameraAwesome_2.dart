import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';


class Cameraawesome2 extends StatefulWidget {
  const Cameraawesome2({super.key});

  @override
  State<Cameraawesome2> createState() => _Cameraawesome2State();
}

class _Cameraawesome2State extends State<Cameraawesome2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("camera awesome 2"),
      ),
      body: Container(
        child: CameraAwesomeBuilder.awesome(saveConfig: SaveConfig.photoAndVideo(),
        onMediaTap: (media){
        },
        ),
      ),
    );
  }
}
