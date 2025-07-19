import 'package:flutter/material.dart';
import 'package:location/location.dart';

class Mylocation extends StatefulWidget {
  const Mylocation({super.key});

  @override
  State<Mylocation> createState() => _MylocationState();
}

class _MylocationState extends State<Mylocation> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocationDetails();
  }
  Location location = Location();
  bool? serviceEnabled;
  PermissionStatus? permissionGranted;
  LocationData? locationData;
  getLocationDetails() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled!) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled!) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    locationData = await location.getLocation();
    print("Device location is latitude ${locationData!.latitude}  and Longitude ${locationData!.longitude}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Localtion"), backgroundColor: Colors.green),
      body: Text("hello location"),
    );
  }
}
