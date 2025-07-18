import 'package:firebase_database/firebase_database.dart';
class FireBaseService{

   static final FirebaseDatabase _firebaseDatabase = FirebaseDatabase.instance;

  Future <void> create ({
    required String path,
    required Map<String, dynamic> data
}) async {
    final DatabaseReference ref= _firebaseDatabase.ref().child(path);
    await ref.push().set(data);
  }


  Future<DataSnapshot?> read ({required String path}) async {
    final DatabaseReference ref = _firebaseDatabase.ref().child(path);
    final DataSnapshot snapshot = await ref.get();
    return snapshot.exists? snapshot: null;
  }
}