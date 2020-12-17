import 'package:cloud_firestore/cloud_firestore.dart';

class FireStoreRepository {
  FirebaseFirestore firestore;
  FireStoreRepository() {
    firestore = FirebaseFirestore.instance;
  }
}
