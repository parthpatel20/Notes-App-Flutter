import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/controller/authController.dart';
import 'package:notes/controller/uiController/uiController.dart';
import 'package:notes/widget/loginForm.dart';
import 'package:notes/widget/signupForm.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LoginScreen extends StatelessWidget {
  final UiController uiController = UiController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[600],
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(10),
        child: Center(
            child: ListView(
          children: [
            Container(
              width: 100,
              height: 100,
              margin: EdgeInsets.only(bottom: 10, top: 10),
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.contain,
                      image: AssetImage('images/icon.jpg'))),
            ),
            //Toggle Switch View
            Container(
              padding: EdgeInsets.all(5),
              child: Center(
                child: ToggleSwitch(
                  iconSize: 30,
                  minWidth: 80.0,
                  cornerRadius: 25.0,
                  activeBgColor: Colors.black38,
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  labels: ['', ''],
                  icons: [Icons.login_sharp, Icons.person_add],
                  onToggle: (index) {
                    uiController.loginScreenTab = index;
                  },
                ),
              ),
            ),
            Obx(() {
              Get.put(AuthController());
              return Card(
                child: Column(
                  children: [
                    Container(
                      child: (uiController.loginScreenTab == 0)
                          ? LoginForm()
                          : SignUpForm(),
                    ),
                    Divider(
                      thickness: 1,
                    ),
                    Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            fit: BoxFit.contain,
                            image: NetworkImage(
                                "https://freeiconshop.com/wp-content/uploads/edd/google-flat.png")),
                      ),
                      margin: EdgeInsets.all(5),
                      child: IconButton(
                        onPressed: () {
                          Get.put(AuthController()).googleSignIn();
                        },
                        icon: Padding(
                          padding: EdgeInsets.all(5),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
          ],
        )),
      )),
    );
  }
}
