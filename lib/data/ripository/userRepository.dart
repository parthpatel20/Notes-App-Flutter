import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:notes/data/ripository/firestoreRepository.dart';
import 'package:notes/data/model/UserModel.dart';

class UserRepository extends FireStoreRepository {
  FireStoreRepository fireStoreRepository;
  UserRepository() {
    fireStoreRepository = FireStoreRepository();
  }

  Future<UserModel> getUser(String uid) async {
    var _fireStore = fireStoreRepository.firestore;
    try {
      DocumentSnapshot _doc =
          await _fireStore.collection("users").doc(uid).get();
      if (_doc.exists) {
        print(_doc['email']);
        return UserModel.fromSnapShot(_doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> createNewUser(UserModel user) async {
    var _fireStore = fireStoreRepository.firestore;
    try {
      await _fireStore.collection("users").doc(user.id).set(user.toJson());
      return true;
    } catch (e) {
      return false;
    }
  }
}
