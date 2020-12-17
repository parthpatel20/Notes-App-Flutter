import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes/controller/bindings/authBinding.dart';
import 'package:notes/widget/ToolsWiget/root.dart';

import 'controller/authController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Get.lazyPut(() => AuthController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AuthBinding(),
      //initialBinding: AuthBinding(),
      title: 'Notes',
      // themeMode: ThemeMode.system,
      theme: ThemeData(
          backgroundColor: const Color(0xFFFFFBFA),
          primaryColor: Colors.white, //const Color(0xFFFFFBFA),
          accentColor: Colors.white,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: AppBarTheme(brightness: Brightness.dark)),
      debugShowCheckedModeBanner: false,
      home: Root(),
    );
  }
}
