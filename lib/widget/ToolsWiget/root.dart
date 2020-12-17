import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/controller/authController.dart';
import 'package:notes/screens/LoginScreen.dart';
import 'package:notes/screens/note_list.dart';

class Root extends GetWidget<AuthController> {
  final AuthController _authController = Get.find();
  renderRoot() {
    // if (_authController.user != null) {
    //   return NoteList();
    // }
    // return LoginScreen();
    return (_authController.user == null) ? LoginScreen() : NoteList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Obx(() => renderRoot()),
    );
  }
}
