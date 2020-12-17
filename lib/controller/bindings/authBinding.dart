import 'package:get/get.dart';
import 'package:notes/controller/authController.dart';

class AuthBinding extends Bindings {
  // Create Pipeline between contrller to UI
  @override
  void dependencies() {
    Get.lazyPut(() => AuthController());
    //Get.put(AuthController());
    // It will help us to load controller to Ui
  }
}
