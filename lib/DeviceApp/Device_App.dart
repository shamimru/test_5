import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:test_5/DeviceApp/AppUsagesDetails.dart';
import 'package:usage_stats/usage_stats.dart';


class MyDeviceApp extends StatefulWidget {
  const MyDeviceApp({super.key});

  @override
  State<MyDeviceApp> createState() => _MyDeviceAppState();
}

class _MyDeviceAppState extends State<MyDeviceApp> {

  List<Application> apps = [];

  @override
  void initState() {
    super.initState();
    getAllDevices();
  }

  getAllDevices() async {
    List<Application> installedApps = await DeviceApps.getInstalledApplications(
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
      includeAppIcons: true,
    );
    setState(() {
      apps = installedApps;
    });
    print("All apps: ${apps.length}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.green,
        title: Text('${apps.length} devices'),
      ),
      body: apps.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: apps.length,
        itemBuilder: (context, index) {
          final app = apps[index] as ApplicationWithIcon;
          return Card(
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: ListTile(
              // 👇 Only app icon is tappable
              leading: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Appusagesdetails(app: apps[index])));
                },
                child: CircleAvatar(
                  backgroundImage: MemoryImage(app.icon),
                  backgroundColor: Colors.transparent,
                ),
              ),
              title: Text("${index + 1}. ${app.appName}"),
              // Optional: show another icon for separate actions
              trailing: IconButton(
                icon: const Icon(Icons.open_in_new),
                onPressed: () {
                  app.openApp();
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
