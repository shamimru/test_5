import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:test_5/DeviceApp/Device_App.dart';

import 'CameraWesome.dart';
import 'ContactList/GetMyContactList.dart';
import 'Hidden_Camera/HiddenCamera.dart';
import 'MyCamera.dart';
import 'MyFormData.dart';
import 'MyLocalNotification.dart';
import 'NotificationUtilities.dart';
import 'ShowFirebaseData.dart';
import 'ShowPersonData.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  NotificationUtilities.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorKey= GlobalKey();
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: "/camera", page: () => const Mycamera()),
        GetPage(name: "/cameraWesome", page: () => const CameraAwesome()),
        GetPage(name: "/form", page: () => const MyFormdata()),
        GetPage(name: "/showPerson", page: () => const Showpersondata()),
        GetPage(name: "/firedata", page: () => MyFirebaseList()),
        GetPage(name: "/notification", page: () => Mylocalnotification()),
        GetPage(name: "/getContacts", page: () => Getmycontactlist()),
        GetPage(name: "/hiddenCamera", page: () => Hiddencamera()),
        GetPage(name: "/devices", page: () => MyDeviceApp()),
      ],
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("cameraWesome");
                Get.toNamed("/cameraWesome");
              },
              child: Text("Camerawesom"),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("formData");
                Get.toNamed("/form");
              },
              child: Text("Form Data to Sql"),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print("formData");
                Get.toNamed("/notification");
              },
              child: Text("Local Notification"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // DataSnapshot? snapshot = await FireBaseService().read(path: "data1");

                // print(snapshot?.value);
                Get.toNamed("/firedata");
              },
              child: Text("Show firebase Data"),
            ),
            
            ElevatedButton(onPressed: (){
              Get.toNamed("/devices");
            }, child: Text("get all devices"))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed("/camera");
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
