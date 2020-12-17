import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:notes/controller/userController.dart';
import 'package:notes/data/model/UserModel.dart';
import 'package:notes/data/ripository/firestoreRepository.dart';
import 'package:notes/data/ripository/userRepository.dart';

class AuthRepository extends FireStoreRepository {
  FirebaseAuth _auth = FirebaseAuth.instance; //Private Variable
  FireStoreRepository fireStoreRepository;
  UserRepository _userRepository;
  AuthRepository() {
    fireStoreRepository = FireStoreRepository();
    _userRepository = UserRepository();
  }
  Rx<User> user = Rx<User>();

  void init() {
    user.bindStream(
        _auth.authStateChanges()); //It Will check User LoggedIn or Not
    // called immediately after the widget is allocated memory
  }

  void createUser(String name, String email, String password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel _user = UserModel(
          id: userCredential.user.uid,
          email: userCredential.user.email,
          name: name);
      print(_user.email);
      var rs = await _userRepository.createNewUser(_user);
      if (rs) {
        Get.find<UserController>().user = _user;
        Get.back();
      } else {}
    } catch (e) {
      //getErrorSnack("Error While Creating Account", e.message);
    }
  }

//Login
  void login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(userCredential.user.email);
      Get.find<UserController>().user =
          await _userRepository.getUser(userCredential.user.uid);

      Get.back();
    } catch (e) {
      //getErrorSnack("Error While SignIn Account", e.message);
    }
  }

//Logout
  void logOut() async {
    await _auth.signOut();
    Get.reset();
    // Get.lazyPut(() => AuthController());
    //Get.lazyPut(() => UserController());
  }
}
