import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class MyDeviceApp extends StatefulWidget {
  const MyDeviceApp({super.key});

  @override
  State<MyDeviceApp> createState() => _MyDeviceAppState();
}

class _MyDeviceAppState extends State<MyDeviceApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllDevices();
  }

  getAllDevices () async {
    List<Application> apps = await DeviceApps.getInstalledApplications(
      includeSystemApps: true, onlyAppsWithLaunchIntent: true, includeAppIcons: true
    );
    print("all app ${apps.length}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('devices'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("devices"),
            ElevatedButton(onPressed: (){
              setState(() {
                getAllDevices();
              });
            }, child: Text("Get devices")),


            Container(
              child: FutureBuilder(
                  future: DeviceApps.getInstalledApplications(
                      includeSystemApps: true, onlyAppsWithLaunchIntent: true, includeAppIcons: true
                  ),
                  builder: (context, snapshort){
                    if(!snapshort.hasData){
                      return CircularProgressIndicator();
                    }
                    List<Application> apps= snapshort.data as List<Application>;
                    return Expanded(
                      child: ListView.builder(
                        itemCount: apps.length,
                          physics: ScrollPhysics(),
                          itemBuilder: (context,index){
                            return Card(
                              elevation: 5,
                              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                              child: Padding(
                                padding: const EdgeInsets.all(1.0),
                                child: ListTile(
                                  leading: Image.memory((apps[index] as ApplicationWithIcon).icon),

                                  trailing: IconButton(onPressed: (){
                                    apps[index].openApp();
                                  }, icon: Icon(Icons.open_in_new)),
                                ),
                              ),
                            );
                          }),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }
}
