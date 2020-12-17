import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:notes/controller/userController.dart';
import 'package:notes/data/model/UserModel.dart';
import 'package:notes/data/model/authModel.dart';
import 'package:notes/data/ripository/userRepository.dart';
import 'package:notes/widget/ToolsWiget/errorWidget.dart';

class AuthController extends GetxController {
  FirebaseAuth _auth = FirebaseAuth.instance; //Private Variable
  UserRepository _userRepository;
  Rx<User> _fireUser = Rx<User>();
  User get user => _fireUser.value;
  final googleSignIN = GoogleSignIn();
  UserController _userController;

  AuthController() {
    _userRepository = UserRepository();
    _userController = Get.put(UserController());
  }

  @override
  void onInit() {
    init();
    logOut();
    super.onInit();
  }

  void init() {
    _fireUser.bindStream(_auth.authStateChanges());
    //It Will check User LoggedIn or Not
    // called immediately after the widget is allocated memory
  }

  void createUser(AuthModel authModel) async {
    try {
      //UserCredential userCredential =
      print(authModel.email);
      await _auth
          .createUserWithEmailAndPassword(
        email: authModel.email,
        password: authModel.password,
      )
          .then((userCredential) async {
        print(userCredential.user.uid);
        UserModel _user = UserModel(
            id: userCredential.user.uid,
            email: userCredential.user.email,
            name: authModel.name);
        //var rs =
        await _userRepository.createNewUser(_user).then((value) {
          Get.find<UserController>().user = _user;
          Get.back();
        }).catchError((onError) => {
              userErrorSnak("Error While Creating Account", onError.toString())
              //Error Module
              // print(onError.toString())
            });
      }).catchError((onError) => {
                userErrorSnak(
                    "Error While Creating Account", onError.toString())
              });

      // if (rs) {
      //   Get.find<UserController>().user = _user;
      //   Get.back();
      // } else {}
    } catch (e) {
      //getErrorSnack("Error While Creating Account", e.message);
    }
  }

//Login
  void login(AuthModel authModel) async {
    try {
      //UserCredential userCredential =
      await _auth
          .signInWithEmailAndPassword(
        email: authModel.email,
        password: authModel.password,
      )
          .then((userCredential) async {
        print(userCredential.user.uid);
        Get.find<UserController>().user =
            await _userRepository.getUser(userCredential.user.uid);
        Get.back();
      }).catchError((onError) {
        userErrorSnak("Error While SignIn Account", onError.toString());
        print(onError.message);
      });
      //print(userCredential.user.email);
      // Get.find<UserController>().user =
      //     await _userRepository.getUser(userCredential.user.uid);

//      Get.back();
    } catch (e) {
      //getErrorSnack("Error While SignIn Account", e.message);
    }
  }

//Google Sign-In
  googleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await googleSignIN.signIn();

    if (googleSignInAccount != null) {
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;
      AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);
      try {
        await _auth.signInWithCredential(credential).then((userCredential) {
          print("H1");
          UserModel _user = UserModel(
              id: userCredential.user.uid,
              email: userCredential.user.email,
              name: userCredential.user.displayName);
          addUserToFireStore(_user);
        });
        return Future.value(true);
      } catch (e) {
        return Future.value(false);
      }
    }
    return Future.value(false);
  }

//Logout
  void logOut() async {
    User user = _auth.currentUser;
    if (user != null && user.providerData[0].providerId == 'google.com') {
      await googleSignIN.disconnect();
    }
    await _auth.signOut();
    Get.reset();
    // Get.lazyPut(() => AuthController());
    //Get.lazyPut(() => UserController());
  }

  addUserToFireStore(UserModel _user) async {
    print(_user.id);

    var user = await _userRepository.getUser(_user.id);
    print(user.id);

    if (user == null) {
      await _userRepository.createNewUser(_user).then((value) {
        _userController.user = _user;
        Get.back();
      }).catchError((onError) =>
          {userErrorSnak("Error While Creating Account", onError.toString())});
    } else {
      _userController.user = _user;
      Get.back();
    }
  }
}
