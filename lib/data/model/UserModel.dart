import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String id, name, email;
  UserModel({this.id, this.name, this.email});

  UserModel.fromSnapShot(DocumentSnapshot userSnap) {
    this.id = userSnap.id;
    this.name = userSnap['name'];
    this.email = userSnap['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    return data;
  }
}
