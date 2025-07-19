import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';

class Mylocation extends StatefulWidget {
  const Mylocation({super.key});

  @override
  State<Mylocation> createState() => _MylocationState();
}

class _MylocationState extends State<Mylocation> {
  Location location = Location();
  bool? serviceEnabled;
  PermissionStatus? permissionGranted;
  LocationData? locationData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getLocationDetails();
  }

  getLocationDetails() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled!) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled!) return;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    locationData = await location.getLocation();
    print(
      "Device location is ${locationData!.latitude} and ${locationData!.longitude}",
    );

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Location"),
        backgroundColor: Colors.green,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: FlutterMap(
                    options: MapOptions(
                      initialCenter: LatLng(
                        locationData!.latitude!,
                        locationData!.longitude!,
                      ),
                      initialZoom: 10,
                      maxZoom: 50,
                    ),
                    children: <Widget>[
                      TileLayer(
                        urlTemplate:
                            'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png',
                        subdomains: ['a', 'b', 'c'],
                        tileProvider: NetworkTileProvider(
                          headers: {
                            'User-Agent':
                                'YourAppName/1.0 (sahammeedd@gmail.com.com)', // <-- replace with real info
                          },
                        ),
                      ),

                      MarkerClusterLayerWidget(
                        options: MarkerClusterLayerOptions(
                          alignment: Alignment(1, 2),
                          maxClusterRadius: 45,
                          size: const Size(40, 40),
                          markers: [
                            Marker(
                              width: 40,
                              height: 40,
                              point: LatLng(
                                locationData!.latitude!,
                                locationData!.longitude!,
                              ),
                              child: const Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 40,
                              ),
                            ),
                          ],
                          builder: (context, markers) {
                            return Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.blue,
                              ),
                              child: Center(
                                child: Text(
                                  markers.length.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
