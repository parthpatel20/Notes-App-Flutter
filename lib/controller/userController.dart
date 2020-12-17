import 'package:get/get.dart';
import 'package:notes/controller/authController.dart';
import 'package:notes/data/model/UserModel.dart';
import 'package:notes/data/ripository/userRepository.dart';

class UserController extends GetxController {
  UserRepository userRepository;
  UserController() {
    userRepository = UserRepository();
  }

  Rx<UserModel> _user = Rx<UserModel>();

  set user(UserModel user) => this._user.value = user;
  UserModel get user => this._user.value;

  loggedUser() async {
    var fireUser = Get.find<AuthController>().user;
    this.user = await userRepository.getUser(fireUser.uid);
  }

  void clear() {
    _user.value = UserModel();
  }
}
