import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseTestService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Test Writing Data
  Future<void> addTestData() async {
    try {
      await db.collection("test_collection").add({
        "message": "Hello World",
        "timestamp": FieldValue.serverTimestamp(),
      });
      print("Data added successfully!");
    } catch (e) {
      print("Error adding data: $e");
    }
  }

  // Test Reading Data
  Future<void> readTestData() async {
    try {
      QuerySnapshot snapshot = await db.collection("test_collection").get();
      for (var doc in snapshot.docs) {
        print("Found document: ${doc.data()}");
      }
    } catch (e) {
      print("Error reading data: $e");
    }
  }
}
