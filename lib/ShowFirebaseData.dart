import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';

class MyFirebaseList extends StatefulWidget {
  const MyFirebaseList({super.key}); // ✅ Best to use `const` when possible

  @override
  _MyFirebaseListState createState() => _MyFirebaseListState();
}

class _MyFirebaseListState extends State<MyFirebaseList> {
   DatabaseReference ref = FirebaseDatabase.instance.ref("data1");

  void deleteWholeData(String key) {
    ref=FirebaseDatabase.instance.ref("data1/$key");
    ref.remove().then((_) {
      print("Data deleted successfully.");
    }).catchError((error) {
      print("Failed to delete data: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(title: Text("Firebase Animated List"),
        backgroundColor: Colors.green,
        ),
      
        body: StreamBuilder<DatabaseEvent>(
          stream: ref.onValue,
          builder: (context, snapshot) {
            // 🔄 Still loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
      
            // ⚠️ Error handling (optional but recommended)
            if (snapshot.hasError) {
              return Center(child: Text("Something went wrong!"));
            }
      
            final data = snapshot.data?.snapshot.value;
      
            // ❌ No data case
            if (data == null || (data is Map && data.isEmpty)) {
              return Center(child: CircularProgressIndicator());
            }
      
            // ✅ Data exists
            return FirebaseAnimatedList(
              query: ref,
              itemBuilder: (context, data, animation, index) {
                final key = data.key?? "";
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  child: ListTile(
                    leading: Text("${index+1}".toString(), style: TextStyle(fontSize: 24)),
                    title: Text(data.child("name").value?.toString() ?? "No Name"),
                    subtitle: Text(data.child("contact").value?.toString() ?? "No Contact"),
                    trailing: IconButton(onPressed: (){
                      deleteWholeData(key);
                    }, icon: Icon(Icons.delete_forever, size: 30,)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
